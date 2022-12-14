local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return 
end

configs.setup({
    ensure_installed = "all",
    auto_install = true,
    sync_install = false,
    highlight = {
        enable = true,
        disable = { "" },
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true, disable = {"yaml"} },
})
