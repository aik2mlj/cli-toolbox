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

upgrade_yazi_plugins() {
    if PATH="$LOCAL_BIN_DIR:$PATH" command -v ya >/dev/null 2>&1; then
        echo "Installing yazi plugins..."
        PATH="$LOCAL_BIN_DIR:$PATH" ya pkg upgrade
    else
        echo "Warning: ya not found, skipping yazi plugin upgrade." >&2
    fi
}

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

# MediaInfo: AppImage for maximum glibc compatibility (bundles glibc 2.3).
# Only x86_64 AppImages are published; arm64 is not available upstream.
install_mediainfo() {
    if [[ $(uname -m) != "x86_64" ]]; then
        echo "Warning: mediainfo AppImage is x86_64-only, skipping." >&2
        return
    fi
    local url="https://mediaarea.net/download/binary/mediainfo/20.09/mediainfo-20.09.glibc2.3-x86_64.AppImage"
    http_download "$url" "$LOCAL_BIN_DIR/mediainfo"
    chmod +x "$LOCAL_BIN_DIR/mediainfo"
    echo "Installed: mediainfo (AppImage)"
}

install_gah() {
    mkdir -p "$LOCAL_BIN_DIR"
    cp "$DOTFILES_DIR/tools/gah" "$LOCAL_BIN_DIR/gah"
    chmod +x "$LOCAL_BIN_DIR/gah"
    echo "Installed: gah to $LOCAL_BIN_DIR/gah"
}

# Persist $LOCAL_BIN_DIR on PATH for the user's login shell ($SHELL),
# skipping if the rc file already mentions .local/bin.
ensure_local_bin_in_path() {
    local shell_name="${SHELL##*/}"
    local config line
    case "$shell_name" in
    fish)
        config="$HOME_DIR/.config/fish/config.fish"
        line="fish_add_path -g $LOCAL_BIN_DIR"
        ;;
    bash)
        config="$HOME_DIR/.bashrc"
        line='export PATH="$HOME/.local/bin:$PATH"'
        ;;
    zsh)
        config="$HOME_DIR/.zshrc"
        line='export PATH="$HOME/.local/bin:$PATH"'
        ;;
    *)
        echo "Warning: unknown shell '$SHELL', skipping PATH update." >&2
        return
        ;;
    esac

    if [[ ":$PATH:" == *":$LOCAL_BIN_DIR:"* ]]; then
        echo "$LOCAL_BIN_DIR already on PATH"
        return
    fi

    mkdir -p "$(dirname "$config")"
    printf '\n%s\n' "$line" >>"$config"
    echo "Added $LOCAL_BIN_DIR to PATH in $config"
}

install_bin_tools() {
    echo "Installing binary tools..."
    mkdir -p "$LOCAL_BIN_DIR"

    # jq is required by gah
    ensure_jq

    # Install via gah (fetches latest releases from GitHub, auto-detects OS/arch)
    run_gah sharkdp/bat
    run_gah sharkdp/fd
    run_gah junegunn/fzf
    run_gah jesseduffield/lazygit
    run_gah sxyazi/yazi # also installs ya
    run_gah ajeetdsouza/zoxide
    run_gah aristocratos/btop
    run_gah Wilfred/difftastic # installs difft
    run_gah bootandy/dust
    run_gah eza-community/eza
    run_gah Skardyy/mcat
    run_gah BurntSushi/ripgrep # installs rg
    run_gah starship/starship
    run_gah fish-shell/fish-shell # installs fish
    install_nvim                  # AppImage — gah would ambiguously match both AppImage and tarball
    install_mediainfo             # AppImage — only x86_64 available upstream
    run_gah ip7z/7zip             # installs 7zz and 7zzs

    # also install gah to ~/.local/bin/
    install_gah

    echo "Binary tools installed to $LOCAL_BIN_DIR"
}

install_nvim_config() {
    echo "Installing Neovim config..."
    local rel_path=".config/nvim"
    local src="$SOURCE_HOME/$rel_path"
    local dest="$HOME_DIR/$rel_path"
    if [ ! -e "$src" ]; then
        echo "Warning: $src not found, skipping." >&2
        return
    fi
    backup_file "$dest"
    if [ "$OVERWRITE" = true ] && [ -d "$dest" ]; then
        rm -rf "$dest"
    fi
    mkdir -p "$(dirname "$dest")"
    cp -r "$src" "$dest"
    echo "Installed $rel_path"
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

    upgrade_yazi_plugins
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
            dest="$HOME_DIR/$config_rel_path"

            backup_file "$dest"
            if [ "$OVERWRITE" = true ] && [ -d "$dest" ]; then
                rm -rf "$dest"
            fi
            mkdir -p "$(dirname "$dest")"
            cp -r "$src" "$(dirname "$dest")/"
            echo "Installed $config_rel_path"
        done
    done

    shopt -u dotglob

    upgrade_yazi_plugins
}

main() {
    local install_all=false
    local binary_only=false
    local config_only=false
    local gah_only=false
    local nvim_only=false
    for arg in "$@"; do
        case "$arg" in
        --overwrite) OVERWRITE=true ;;
        --all) install_all=true ;;
        --upgrade | --binary-only) binary_only=true ;;
        --config-only) config_only=true ;;
        --gah) gah_only=true ;;
        --nvim) nvim_only=true ;;
        esac
    done

    if [ "$gah_only" = true ]; then
        install_gah
        ensure_local_bin_in_path
        echo "✅ gah installed."
        return
    fi

    if [ "$nvim_only" = true ]; then
        install_nvim_config
        echo "✅ Neovim config installed."
        return
    fi

    if [ "$binary_only" = true ]; then
        install_bin_tools
        ensure_local_bin_in_path
        echo "✅ Upgrade complete."
        return
    fi

    if [ "$config_only" = false ]; then
        install_bin_tools
    fi

    if [ "$install_all" = true ]; then
        install_all_configs
    else
        install_configs
    fi

    ensure_local_bin_in_path
    echo "✅ Installation complete."
}

main "$@"
