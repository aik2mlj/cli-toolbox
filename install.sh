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
    ".config/starship.toml"
    ".config/yazi"
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

install_bin_tools() {
    echo "Installing binary tools..."
    mkdir -p "$LOCAL_BIN_DIR"
    if [ -d "$SOURCE_HOME/.local/bin" ]; then
        for bin in "$SOURCE_HOME/.local/bin/"*; do
            echo "Copying $(basename "$bin") to $LOCAL_BIN_DIR"
            cp "$bin" "$LOCAL_BIN_DIR/" || true
        done
    fi
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
    install_bin_tools

    if [ "${1:-}" == "--overwrite" ]; then
        OVERWRITE=true
        shift
    fi
    if [ "${1:-}" == "--all" ]; then
        install_all_configs
    else
        install_configs
    fi

    echo "✅ Installation complete."
}

main "$@"
