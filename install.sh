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
# Supported package managers: apt, dnf, pacman, brew. Anything else prints
# manual-install hints and keeps going.

set -euo pipefail

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

# Detect package manager.
PM=""
if have brew; then PM=brew
elif have apt-get; then PM=apt
elif have dnf; then PM=dnf
elif have pacman; then PM=pacman
fi
[ -n "$PM" ] && info "Using package manager: $PM" || warn "No supported package manager detected."

# Use sudo for system installs when not already root (brew never needs it).
SUDO=""
if [ "$PM" != "brew" ] && [ "$(id -u)" -ne 0 ] && have sudo; then SUDO="sudo"; fi

pkg_install() {
  case "$PM" in
    apt)    $SUDO apt-get install -y "$@" ;;
    dnf)    $SUDO dnf install -y "$@" ;;
    pacman) $SUDO pacman -S --needed --noconfirm "$@" ;;
    brew)   brew install "$@" ;;
    *)      warn "Please install manually: $*" ;;
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
# 1. Base tools.
# ---------------------------------------------------------------------------
info "Installing base tools (ripgrep, compiler, git, curl, unzip, python3)"
[ "$PM" = apt ] && $SUDO apt-get update -y
case "$PM" in
  apt)    pkg_install ripgrep build-essential git curl unzip python3 python3-venv python3-pip ;;
  dnf)    pkg_install ripgrep gcc gcc-c++ make git curl unzip python3 python3-pip ;;
  pacman) pkg_install ripgrep base-devel git curl unzip python python-pip ;;
  brew)   pkg_install ripgrep git curl python ;;
  *)      warn "Install ripgrep, a C compiler, git, curl, unzip, and python3 by hand." ;;
esac

# ---------------------------------------------------------------------------
# 2. Node.js (JS-family language servers).
# ---------------------------------------------------------------------------
if have node; then
  info "Node.js present: $(node --version)"
else
  info "Installing Node.js (LTS)"
  case "$PM" in
    brew)   pkg_install node ;;
    apt)    curl -fsSL https://deb.nodesource.com/setup_lts.x | $SUDO -E bash - && pkg_install nodejs ;;
    dnf)    curl -fsSL https://rpm.nodesource.com/setup_lts.x | $SUDO bash - && pkg_install nodejs ;;
    pacman) pkg_install nodejs npm ;;
    *)      warn "Install Node.js from https://nodejs.org and re-run." ;;
  esac
fi

# ---------------------------------------------------------------------------
# 3. Go (gopls + delve).
# ---------------------------------------------------------------------------
if have go; then
  info "Go present: $(go version)"
elif [ "$PM" = brew ]; then
  info "Installing Go"; pkg_install go
else
  GO_VERSION="1.23.4"
  TARBALL="go${GO_VERSION}.linux-$(arch_tag).tar.gz"
  info "Installing Go ${GO_VERSION} to /usr/local/go"
  curl -fsSLo "/tmp/${TARBALL}" "https://go.dev/dl/${TARBALL}"
  $SUDO rm -rf /usr/local/go && $SUDO tar -C /usr/local -xzf "/tmp/${TARBALL}"
  if ! echo "$PATH" | grep -q "/usr/local/go/bin"; then
    warn "Add Go to your PATH (e.g. in ~/.zshrc): export PATH=\$PATH:/usr/local/go/bin:\$HOME/go/bin"
  fi
fi

# ---------------------------------------------------------------------------
# 4. Rust (rust_analyzer / cargo).
# ---------------------------------------------------------------------------
if have cargo; then
  info "Rust present: $(rustc --version 2>/dev/null || echo cargo)"
elif [ "$PM" = brew ]; then
  info "Installing Rust"; pkg_install rustup-init && rustup-init -y
else
  info "Installing Rust via rustup"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  warn "Run 'source \$HOME/.cargo/env' or restart your shell to use cargo."
fi

# ---------------------------------------------------------------------------
# 5. lazygit (optional, for <leader>gg).
# ---------------------------------------------------------------------------
if have lazygit; then
  info "lazygit present"
else
  info "Installing lazygit"
  case "$PM" in
    brew|pacman) pkg_install lazygit ;;
    *)
      LG_ARCH="$(uname -m)"; [ "$LG_ARCH" = "aarch64" ] && LG_ARCH=arm64
      LG_VER="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
        | grep -Po '"tag_name":\s*"v\K[^"]*' || true)"
      if [ -n "$LG_VER" ]; then
        curl -fsSLo /tmp/lazygit.tar.gz \
          "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LG_VER}_Linux_${LG_ARCH}.tar.gz"
        tar -C /tmp -xf /tmp/lazygit.tar.gz lazygit
        $SUDO install /tmp/lazygit /usr/local/bin/lazygit
      else
        warn "Could not resolve latest lazygit release; install manually if you want <leader>gg."
      fi
      ;;
  esac
fi

# ---------------------------------------------------------------------------
info "External toolchains installed."
cat <<'EOF'

Next steps:
  1. Open a NEW shell (so Go/Rust are on PATH), or source your shell rc.
  2. Launch: nvim
     - lazy.nvim installs plugins on first run.
     - Mason installs the language servers + debug adapters (delve, debugpy).
  3. Run :checkhealth to confirm everything is green.
EOF
