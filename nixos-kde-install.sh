#!/usr/bin/env bash
#
# Script to install NixOS + KDE + my configs
# I made this mainly for me but feel free to use
# Made by Knuspii
#

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit 1
fi

# Ask for target user
read -p "Enter username: " USERNAME
if ! id "$USERNAME" &>/dev/null; then
  echo "User does not exist."
  exit 1
fi

# --- Clone configs ---
TMP_DIR=/home/$USERNAME/temp
sudo -u $USERNAME git clone --depth=1 --branch main https://github.com/knuspii/nixos-kde.git $TMP_DIR
echo "Copying configuration files..."
sudo -u $USERNAME cp "$TMP_DIR/bashrc" "/home/$USERNAME/.bashrc"
sudo -u $USERNAME cp "$TMP_DIR/bash_profile" "/home/$USERNAME/.bash_profile"
sudo -u $USERNAME cp -r "$TMP_DIR/config/." "/home/$USERNAME/.config/"
sudo -u $USERNAME cp -r "$TMP_DIR/local/share/konsole/." "/home/$USERNAME/.local/share/konsole/"
# NIXOS
sudo cp "$TMP_DIR/configuration.nix" "/etc/nixos/configuration.nix"
# Temp löschen
rm -rf "$TMP_DIR"

sudo nixos-rebuild switch

# Reboot at the end :)
echo Installation finished!
read -p "Do you want to reboot? [y/n] " answer
case "$answer" in
    [Yy]* ) echo "OK, rebooting now...";;
    [Nn]* ) echo "Aborted"; exit 1;;
    * ) echo "Invalid response"; exit 1;;
esac
sleep 3
reboot

exit 0
