#!/usr/bin/env bash
#
# Turnkey installer for the external toolchains this Neovim config depends on.
#
# The language servers and debug adapters themselves are managed by Mason from
# inside Neovim (:Mason). This script only installs the OS-level runtimes and
# tools that Mason and the config need but cannot provide:
#
#   ripgrep        Telescope live grep
#   C compiler     building treesitter parsers
#   git, curl      plugin + tool downloads
#   Node.js        TypeScript / Vue / JSON / YAML / ESLint language servers
#   Go             gopls + delve (Go debugging)
#   Rust (cargo)   rust_analyzer development
#   Python 3       pyright / debugpy (Python debugging)
#   lazygit        the <leader>gg terminal binding (optional)
#
# Go, Rust, and lazygit install into your home directory - no root required.
# Only base system packages (ripgrep, compiler, ...) need a package manager,
# and those are skipped when already present. Supports apt, dnf, pacman, brew.

set -euo pipefail

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

# Detect package manager (only used for base packages).
PM=""
if have brew; then PM=brew
elif have apt-get; then PM=apt
elif have dnf; then PM=dnf
elif have pacman; then PM=pacman
fi

# Can we install system packages without an interactive password prompt?
CAN_SUDO=false
SUDO=""
if [ "$PM" = brew ] || [ "$(id -u)" -eq 0 ]; then
  CAN_SUDO=true
elif have sudo && sudo -n true 2>/dev/null; then
  CAN_SUDO=true
  SUDO="sudo"
fi

pkg_install() {
  case "$PM" in
    apt)    $SUDO apt-get update -y && $SUDO apt-get install -y "$@" ;;
    dnf)    $SUDO dnf install -y "$@" ;;
    pacman) $SUDO pacman -S --needed --noconfirm "$@" ;;
    brew)   brew install "$@" ;;
  esac
}

arch_tag() {
  case "$(uname -m)" in
    x86_64|amd64) echo amd64 ;;
    aarch64|arm64) echo arm64 ;;
    *) uname -m ;;
  esac
}

# ---------------------------------------------------------------------------
# 1. Base tools that genuinely need the system package manager (a C compiler,
#    git, curl, python3). ripgrep is handled separately below as a user-local
#    install so it never needs root.
# ---------------------------------------------------------------------------
missing=()
{ have gcc || have cc; } || missing+=(compiler)
have git || missing+=(git)
have curl || missing+=(curl)
have python3 || missing+=(python3)

if [ ${#missing[@]} -eq 0 ]; then
  info "Base tools already present (compiler, git, curl, python3)."
elif [ -z "$PM" ]; then
  warn "Missing base tools: ${missing[*]} - install them with your package manager."
elif [ "$CAN_SUDO" = true ]; then
  info "Installing base tools: ${missing[*]}"
  case "$PM" in
    apt)    pkg_install build-essential git curl unzip python3 python3-venv python3-pip ;;
    dnf)    pkg_install gcc gcc-c++ make git curl unzip python3 python3-pip ;;
    pacman) pkg_install base-devel git curl unzip python python-pip ;;
    brew)   pkg_install git curl python ;;
  esac
else
  warn "Missing base tools: ${missing[*]}"
  warn "These need root. Run this once in a terminal, then re-run ./install.sh:"
  case "$PM" in
    apt)    echo "    sudo apt-get install -y build-essential git curl unzip python3 python3-venv python3-pip" ;;
    dnf)    echo "    sudo dnf install -y gcc gcc-c++ make git curl unzip python3 python3-pip" ;;
    pacman) echo "    sudo pacman -S --needed base-devel git curl unzip python python-pip" ;;
  esac
fi

# ripgrep -> $HOME/.local/bin (no root). Required for Telescope live grep.
if have rg; then
  info "ripgrep present: $(rg --version | head -1)"
elif [ "$PM" = brew ] || [ "$PM" = pacman ]; then
  info "Installing ripgrep"; pkg_install ripgrep
else
  info "Installing ripgrep to \$HOME/.local/bin"
  RG_ARCH="x86_64-unknown-linux-musl"; [ "$(uname -m)" = "aarch64" ] && RG_ARCH="aarch64-unknown-linux-gnu"
  RG_VER="$(curl -fsSL https://api.github.com/repos/BurntSushi/ripgrep/releases/latest \
    | grep -Po '"tag_name":\s*"\K[^"]*' || true)"
  if [ -n "$RG_VER" ]; then
    curl -fsSLo /tmp/rg.tar.gz \
      "https://github.com/BurntSushi/ripgrep/releases/download/${RG_VER}/ripgrep-${RG_VER}-${RG_ARCH}.tar.gz"
    tar -C /tmp -xzf /tmp/rg.tar.gz "ripgrep-${RG_VER}-${RG_ARCH}/rg"
    install "/tmp/ripgrep-${RG_VER}-${RG_ARCH}/rg" "$LOCAL_BIN/rg"
    rm -rf /tmp/rg.tar.gz "/tmp/ripgrep-${RG_VER}-${RG_ARCH}"
  else
    warn "Could not resolve latest ripgrep release; install it manually (needed for live grep)."
  fi
fi

# ---------------------------------------------------------------------------
# 2. Node.js (JS-family language servers).
# ---------------------------------------------------------------------------
if have node; then
  info "Node.js present: $(node --version)"
elif [ "$PM" = brew ]; then
  info "Installing Node.js"; pkg_install node
else
  warn "Node.js not found. Install the LTS from https://nodejs.org (or your"
  warn "package manager) - it's needed for the TS/Vue/JSON/YAML/ESLint servers."
fi

# ---------------------------------------------------------------------------
# 3. Go -> $HOME/.local/go (no root).
# ---------------------------------------------------------------------------
if have go; then
  info "Go present: $(go version)"
elif [ "$PM" = brew ]; then
  info "Installing Go"; pkg_install go
else
  GO_VERSION="1.23.4"
  TARBALL="go${GO_VERSION}.linux-$(arch_tag).tar.gz"
  info "Installing Go ${GO_VERSION} to \$HOME/.local/go"
  curl -fsSLo "/tmp/${TARBALL}" "https://go.dev/dl/${TARBALL}"
  rm -rf "$HOME/.local/go"
  tar -C "$HOME/.local" -xzf "/tmp/${TARBALL}"
  rm -f "/tmp/${TARBALL}"
  ln -sf "$HOME/.local/go/bin/go" "$LOCAL_BIN/go"
  ln -sf "$HOME/.local/go/bin/gofmt" "$LOCAL_BIN/gofmt"
fi

# ---------------------------------------------------------------------------
# 4. Rust via rustup (already user-level, no root).
# ---------------------------------------------------------------------------
if have cargo; then
  info "Rust present: $(rustc --version 2>/dev/null || echo cargo)"
elif [ "$PM" = brew ]; then
  info "Installing Rust"; pkg_install rustup-init && rustup-init -y --no-modify-path
else
  info "Installing Rust via rustup"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# ---------------------------------------------------------------------------
# 5. lazygit -> $HOME/.local/bin (no root).
# ---------------------------------------------------------------------------
if have lazygit; then
  info "lazygit present"
elif [ "$PM" = brew ] || [ "$PM" = pacman ]; then
  info "Installing lazygit"; pkg_install lazygit
else
  info "Installing lazygit to \$HOME/.local/bin"
  LG_ARCH="$(uname -m)"; [ "$LG_ARCH" = "aarch64" ] && LG_ARCH=arm64
  LG_VER="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
    | grep -Po '"tag_name":\s*"v\K[^"]*' || true)"
  if [ -n "$LG_VER" ]; then
    curl -fsSLo /tmp/lazygit.tar.gz \
      "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LG_VER}_Linux_${LG_ARCH}.tar.gz"
    tar -C /tmp -xf /tmp/lazygit.tar.gz lazygit
    install /tmp/lazygit "$LOCAL_BIN/lazygit"
    rm -f /tmp/lazygit /tmp/lazygit.tar.gz
  else
    warn "Could not resolve latest lazygit release; install manually if you want <leader>gg."
  fi
fi

# ---------------------------------------------------------------------------
info "External toolchains installed."

# PATH guidance.
need_path=()
echo "$PATH" | grep -q "$LOCAL_BIN" || need_path+=("$LOCAL_BIN")
[ -d "$HOME/go/bin" ] && { echo "$PATH" | grep -q "$HOME/go/bin" || need_path+=("$HOME/go/bin"); }
[ -f "$HOME/.cargo/env" ] && { echo "$PATH" | grep -q "$HOME/.cargo/bin" || need_path+=("$HOME/.cargo/bin"); }

cat <<EOF

Next steps:
EOF
if [ ${#need_path[@]} -gt 0 ]; then
  echo "  1. Add these to your PATH (e.g. in ~/.zshrc), then open a new shell:"
  printf '        export PATH="%s:$PATH"\n' "$(IFS=:; echo "${need_path[*]}")"
  [ -f "$HOME/.cargo/env" ] && echo "        source \$HOME/.cargo/env   # or just open a new shell"
else
  echo "  1. Open a new shell so everything is on your PATH."
fi
cat <<'EOF'
  2. Launch: nvim
       - lazy.nvim installs plugins on first run.
       - Mason installs the language servers + debug adapters (delve, debugpy).
  3. Run :checkhealth to confirm everything is green.
EOF
