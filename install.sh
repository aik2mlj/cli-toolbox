#!/bin/bash

# By default, it will copy all the binary tools to ~/.local/bin/,
# backup the configurations files if you already have them,
# and copy the configuration files for tmux, fish, starship, and yazi.

# Variables
SOURCE_BIN="./home/.local/bin"
DEST_BIN="$HOME/.local/bin"
BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
CONFIG_FILES=(
    ".config/tmux/tmux.conf"
    ".config/fish/config.fish"
    ".config/starship.toml"
    ".config/yazi/yazi.toml"
)

# Create directories if they don't exist
mkdir -p "$DEST_BIN"
mkdir -p "$BACKUP_DIR"

# Copy binary tools
echo "Copying binary tools..."
for tool in "$SOURCE_BIN"/*; do
    tool_name=$(basename "$tool")
    dest_tool="$DEST_BIN/$tool_name"

    if [ -f "$dest_tool" ]; then
        echo "Backing up existing $tool_name..."
        mv "$dest_tool" "$BACKUP_DIR/"
    fi

    cp "$tool" "$DEST_BIN/"
    echo "Copied $tool_name to $DEST_BIN"
done

# Backup and copy config files
echo -e "\nHandling configuration files..."
for config in "${CONFIG_FILES[@]}"; do
    source_config="./home/$config"
    dest_config="$HOME/$config"

    if [ -f "$source_config" ]; then
        if [ -f "$dest_config" ]; then
            echo "Backing up existing $config..."
            mkdir -p "$(dirname "$BACKUP_DIR/$config")"
            mv "$dest_config" "$BACKUP_DIR/$config"
        fi

        echo "Copying $config..."
        mkdir -p "$(dirname "$dest_config")"
        cp "$source_config" "$dest_config"
    else
        echo "Warning: Source config $source_config not found"
    fi
done

echo -e "\nDone! Backups saved to $BACKUP_DIR"
