#!/usr/bin/env bash
#
# KDE + Custom Backup Script
#

BACKUP_DIR="$HOME/kde-backup"

# Check user
if [ "$EUID" -eq 0 ]; then
    echo "Please run as a normal user, not root"
    exit 1
fi

rm -r $BACKUP_DIR

# Backup folder
mkdir -p "$BACKUP_DIR/config"
mkdir -p "$BACKUP_DIR/local/share"

echo "Creating backup in: $BACKUP_DIR"

# --- Bash files (rename without dot) ---
if [ -f "$HOME/.bashrc" ]; then
    cp "$HOME/.bashrc" "$BACKUP_DIR/bashrc"
    echo "Backing up .bashrc → bashrc"
fi

if [ -f "$HOME/.bash_profile" ]; then
    cp "$HOME/.bash_profile" "$BACKUP_DIR/bash_profile"
    echo "Backing up .bash_profile → bash_profile"
fi

# --- CONFIG files ---
CONFIG_FILES=(
    "backup-config.sh"
    "kdeglobals"
    "kscreenlockerrc"
    "plasmarc"
    "plasma-org.kde.plasma.desktop-appletsrc"
    "kglobalshortcutsrc"
    "kwinrc"
    "konsolerc"
)

for f in "${CONFIG_FILES[@]}"; do
    if [ -f "$HOME/.config/$f" ]; then
        cp "$HOME/.config/$f" "$BACKUP_DIR/config/"
        echo "Backing up $f"
    fi
done

# --- Directories in config ---
CONFIG_DIRS=(
    "autostart"             # KDE + Conky autostart .desktop files
    "konsole"               # Konsole profiles
    "conky"                 # Conky configs
    "wallpaper"             # Wallpaper configs
)

for d in "${CONFIG_DIRS[@]}"; do
    if [ -d "$HOME/.config/$d" ]; then
        cp -r "$HOME/.config/$d" "$BACKUP_DIR/config/"
        echo "Backing up folder $d"
    fi
done

# --- Local ---
LOCAL_ITEMS=(
    "konsole"
)

for item in "${LOCAL_ITEMS[@]}"; do
    if [ -d "$HOME/.local/share/$item" ]; then
        mkdir -p "$BACKUP_DIR/local/share"
        cp -a "$HOME/.local/share/$item" "$BACKUP_DIR/local/share/"
        echo "Backing up local/share/$item"
    fi
done

echo "Backup complete!"
echo "All files are in: $BACKUP_DIR"
