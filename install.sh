#!/usr/bin/env bash

set -euo pipefail

# Adjust this path if your script lives elsewhere
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"
LOCAL_BIN_DIR="$HOME_DIR/.local/bin"
SOURCE_HOME="$DOTFILES_DIR/home"
OVERWRITE=false

# Tools and configs
ESSENTIAL_CONFIGS=(
    ".tmux.conf"
    ".tmux.conf.local"
    ".config/fish"
    # ".config/starship.toml"
    ".config/yazi"
    ".config/lazygit"
    ".ssh/rc"
)

ALL_CONFIG_SPECIAL_DIR=(
    ".config"
    ".ssh"
)

backup_file() {
    local target="$1"
    if [ "$OVERWRITE" = true ]; then
        return 0
    fi
    if [ -e "$target" ] || [ -L "$target" ]; then
        local backup="${target}.bak_$(date +%s)"
        echo "Backing up $target to $backup"
        mv "$target" "$backup"
    fi
}

#--------------------------------------------------
# Binary tool installation via gah
# gah fetches pre-built releases from GitHub, no root required.
# See: https://github.com/get-gah/gah
#--------------------------------------------------

# Download a file using curl or wget
http_download() {
    local url="$1"
    local dest="$2"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$url" -o "$dest"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO "$dest" "$url"
    else
        echo "Error: neither curl nor wget found." >&2
        exit 1
    fi
}

# Ensure jq is available (required by gah). Bootstraps a static binary if needed.
ensure_jq() {
    if command -v jq >/dev/null 2>&1; then
        return
    fi
    echo "jq not found, bootstrapping static binary..."
    local arch
    case $(uname -m) in
    x86_64) arch="amd64" ;;
    aarch64 | arm64) arch="arm64" ;;
    *)
        echo "Error: unsupported arch for jq bootstrap: $(uname -m)" >&2
        exit 1
        ;;
    esac
    mkdir -p "$LOCAL_BIN_DIR"
    http_download \
        "https://github.com/jqlang/jq/releases/latest/download/jq-linux-${arch}" \
        "$LOCAL_BIN_DIR/jq"
    chmod +x "$LOCAL_BIN_DIR/jq"
    export PATH="$LOCAL_BIN_DIR:$PATH"
    echo "jq installed to $LOCAL_BIN_DIR/jq"
}

# Run gah to install a tool from GitHub releases.
# Usage: run_gah <alias_or_owner/repo>
run_gah() {
    local gah="$DOTFILES_DIR/tools/gah"
    chmod +x "$gah"
    GAH_INSTALL_DIR="$LOCAL_BIN_DIR" GAH_UNATTENDED=true bash "$gah" install "$@"
}

# Neovim: explicitly fetch the AppImage rather than letting gah pick between
# the AppImage and tarball (both match gah's regex for neovim/neovim).
install_nvim() {
    local arch
    case $(uname -m) in
    x86_64) arch="x86_64" ;;
    aarch64 | arm64) arch="arm64" ;;
    *)
        echo "Warning: unsupported arch for nvim, skipping." >&2
        return
        ;;
    esac
    local asset="nvim-linux-${arch}.appimage"
    local url
    url=$(http_download "https://api.github.com/repos/neovim/neovim/releases/latest" /dev/stdout |
        jq -r --arg a "$asset" '.assets[] | select(.name == $a) | .browser_download_url')
    [[ -z "$url" ]] && {
        echo "Warning: nvim AppImage not found, skipping." >&2
        return
    }
    http_download "$url" "$LOCAL_BIN_DIR/nvim"
    chmod +x "$LOCAL_BIN_DIR/nvim"
    echo "Installed: nvim (AppImage)"
}

install_bin_tools() {
    echo "Installing binary tools..."
    mkdir -p "$LOCAL_BIN_DIR"

    # jq is required by gah
    ensure_jq

    # Install via gah (fetches latest releases from GitHub, auto-detects OS/arch)
    run_gah sharkdp/fd
    run_gah junegunn/fzf
    run_gah jesseduffield/lazygit
    run_gah sxyazi/yazi              # also installs ya
    run_gah ajeetdsouza/zoxide
    run_gah aristocratos/btop
    run_gah Wilfred/difftastic       # installs difft
    run_gah bootandy/dust
    run_gah eza-community/eza
    run_gah Skardyy/mcat
    run_gah BurntSushi/ripgrep       # installs rg
    run_gah starship/starship
    run_gah astral-sh/uv             # also installs uvx
    run_gah fish-shell/fish-shell    # installs fish
    install_nvim                  # AppImage — gah would ambiguously match both AppImage and tarball
    run_gah ip7z/7zip             # installs 7zz and 7zzs
}

install_configs() {
    echo "Installing essential config files..."
    for path in "${ESSENTIAL_CONFIGS[@]}"; do
        src="$SOURCE_HOME/$path"
        dest="$HOME_DIR/$path"
        if [ -e "$src" ]; then
            backup_file "$dest"
            mkdir -p "$(dirname "$dest")"
            cp -r "$src" "$dest"
            echo "Installed $path"
        fi
    done
}

install_all_configs() {
    echo "Installing all config files from home/..."
    shopt -s dotglob
    for item in "$SOURCE_HOME"/*; do
        # continue only if the item is a file
        if [ -f "$item" ]; then
            rel_path="${item#$SOURCE_HOME/}"
            src="$item"
            dest="$HOME_DIR/$rel_path"

            backup_file "$dest"
            mkdir -p "$(dirname "$dest")"
            cp -r "$src" "$dest"
            echo "Installed $rel_path"
            continue
        fi
    done

    # Special handling for secondary directory contents
    for spec_dir in "${ALL_CONFIG_SPECIAL_DIR[@]}"; do
        for config_item in "$SOURCE_HOME/$spec_dir"/*; do
            config_rel_path="${config_item#$SOURCE_HOME/}"
            src="$config_item"
            dest="$HOME_DIR/$spec_dir/"

            backup_file "$dest"
            mkdir -p "$(dirname "$dest")"
            cp -r "$src" "$dest"
            echo "Installed $config_rel_path"
        done
    done

    shopt -u dotglob
}

main() {
    local install_all=false
    local upgrade_only=false
    for arg in "$@"; do
        case "$arg" in
            --overwrite)  OVERWRITE=true ;;
            --all)        install_all=true ;;
            --upgrade)    upgrade_only=true ;;
        esac
    done

    if [ "$upgrade_only" = true ]; then
        install_bin_tools
        echo "✅ Upgrade complete."
        return
    fi

    install_bin_tools

    if [ "$install_all" = true ]; then
        install_all_configs
    else
        install_configs
    fi

    echo "✅ Installation complete."
}

main "$@"
