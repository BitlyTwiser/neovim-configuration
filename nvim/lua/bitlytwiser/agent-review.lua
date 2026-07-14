-- Agent review sync: keep buffers and any open Diffview in step while an
-- external agent (Claude Code, aider, etc.) rewrites files on disk.
--
-- Two mechanisms:
--   1. autoread + a checktime autocmd, so edited buffers reload when Neovim
--      regains focus, enters a buffer, holds the cursor, or leaves a terminal.
--   2. a recursive fs_event watcher on the cwd that, on a real (non-noise,
--      non-gitignored) change, refreshes the open Diffview and reloads buffers.
--
-- WSL2 / Linux caveat: libuv only honours the `recursive` fs_event flag on
-- macOS and Windows. On Linux (including WSL2) this watcher sees only top-level
-- cwd changes, and for repos under the Windows mount (/mnt/c/...) drvfs emits
-- no inotify events at all - so nested files never fire there. A polling
-- fallback (a vim.uv.new_timer loop calling :checktime plus :DiffviewRefresh)
-- would be needed on those setups. This module fails safe: if the watcher
-- cannot start it simply falls back to the autoread autocmd.

local M = {}

local uv = vim.uv or vim.loop
local DEBOUNCE_MS = 150

local watcher
local timer
local pending = {}

-- Cheap filters for filesystem noise. `rel` is the fs_event path, relative to
-- the watched cwd.
local function noise(rel)
  if not rel or rel == "" then
    return true
  end
  -- Editor swap / backup / atomic-write probe files.
  if rel:match("%.sw[a-p]$") or rel:match("~$") or rel == "4913" or rel:match("/4913$") then
    return true
  end
  if rel:match("^node_modules/") or rel:match("/node_modules/") then
    return true
  end
  -- Let .git/index through (staging should refresh the view); drop the rest of
  -- .git so index.lock, refs, objects churn does not spam refreshes.
  if rel == ".git/index" or rel:match("/%.git/index$") then
    return false
  end
  if rel:match("^%.git/") or rel:match("/%.git/") then
    return true
  end
  return false
end

-- True if at least one path is NOT gitignored (so the change is worth showing).
local function has_tracked(paths)
  if vim.fn.executable("git") == 0 then
    return true
  end
  local out = vim.fn.system({ "git", "check-ignore", "--stdin" }, table.concat(paths, "\n"))
  -- git check-ignore: exit 0 = some ignored, 1 = none ignored, >1 = error.
  if vim.v.shell_error > 1 then
    return true
  end
  local ignored = {}
  for line in vim.gsplit(out, "\n", { plain = true }) do
    if line ~= "" then
      ignored[line] = true
    end
  end
  for _, p in ipairs(paths) do
    if not ignored[p] then
      return true
    end
  end
  return false
end

local function flush()
  local paths = {}
  for p in pairs(pending) do
    paths[#paths + 1] = p
  end
  pending = {}
  if #paths == 0 then
    return
  end
  -- Only refresh when a Diffview is actually open.
  local ok, lib = pcall(require, "diffview.lib")
  local view = ok and lib.get_current_view() or nil
  if not view then
    return
  end
  if not has_tracked(paths) then
    return
  end
  pcall(function()
    view:update_files()
  end)
  vim.cmd("checktime")
end

local function on_fs_event(err, filename, _)
  if err or noise(filename) then
    return
  end
  pending[filename] = true
  timer:stop()
  timer:start(DEBOUNCE_MS, 0, function()
    vim.schedule(flush)
  end)
end

function M.setup()
  vim.o.autoread = true

  vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermLeave" }, {
    group = vim.api.nvim_create_augroup("bitlytwiser_agent_review", { clear = true }),
    callback = function()
      -- :checktime errors in the command-line window and special buffers.
      if vim.fn.mode() ~= "c" and vim.bo.buftype == "" then
        pcall(vim.cmd, "checktime")
      end
    end,
  })

  local ok_watcher, handle = pcall(uv.new_fs_event)
  if not ok_watcher or not handle then
    vim.notify("agent-review: fs_event unavailable; using autoread only", vim.log.levels.WARN)
    return
  end
  watcher = handle
  timer = uv.new_timer()

  local ok, res = pcall(function()
    return watcher:start(uv.cwd(), { recursive = true }, on_fs_event)
  end)
  -- fs_event:start returns 0 on success, or nil + err on failure.
  if not ok or res ~= 0 then
    vim.notify("agent-review: watcher failed to start; using autoread only", vim.log.levels.WARN)
    watcher:close()
    watcher = nil
    timer:close()
    timer = nil
  end
end

return M
