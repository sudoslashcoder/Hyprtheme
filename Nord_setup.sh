#!/bin/bash
# Hyprland Nord Theme Setup Script
# Clones nord-dotfiles, installs packages, copies configs, and sets up Hyprland rice.
# Usage: Run as a regular user (will invoke sudo for installations).

set -euo pipefail

REPO_URL="https://github.com/a-lebailly/nord-dotfiles.git"
DOTFILES_DIR="$HOME/nord-dotfiles"
CONFIG_DIR="$HOME/.config"

echo "===> Starting Nord rice setup..."

# Clone the nord-dotfiles repository
if [ -d "$DOTFILES_DIR" ]; then
    echo "Error: Directory '$DOTFILES_DIR' already exists. Please remove or rename it and rerun."
    exit 1
fi
echo "--> Cloning nord-dotfiles into $DOTFILES_DIR"
git clone "$REPO_URL" "$DOTFILES_DIR"

# 2. Install required system packages via pacman
echo "--> Installing core packages with pacman (may prompt for password)..."
sudo pacman -Syu --noconfirm hyprland hyprpaper kitty waybar rofi wofi starship zsh git btop cava fastfetch

#  Install AUR helper (yay) if not present
if ! command -v yay &>/dev/null; then
    echo "--> Installing AUR helper 'yay'..."
    sudo pacman -S --needed --noconfirm base-devel git
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
    (cd "$tmpdir/yay" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"
fi

# 4. (Optional) Install any additional AUR packages here
# e.g., if a package is only in AUR: yay -S --noconfirm some-aur-package

# Install Nerd Fonts from assets
echo "--> Installing Nerd Fonts..."
mkdir -p "$HOME/.local/share/fonts"
cp -r "$DOTFILES_DIR/assets/fonts/CaskaydiaCoveNerdFont"/* "$HOME/.local/share/fonts/" || {
    echo "Warning: CaskaydiaCoveNerdFont not found!"
}
# (Also copy UbuntuNerdFont if present)
if [ -d "$DOTFILES_DIR/assets/fonts/UbuntuNerdFont" ]; then
    cp -r "$DOTFILES_DIR/assets/fonts/UbuntuNerdFont"/* "$HOME/.local/share/fonts/"
fi

# Copy/symlink config directories to ~/.config
echo "--> Setting up configuration files..."
mkdir -p "$CONFIG_DIR"
# Define an array of config directories/files to copy
configs=("hypr" "waybar" "kitty" "rofi" "starship.toml")
for name in "${configs[@]}"; do
    src="$DOTFILES_DIR/.config/$name"
    if [ -e "$src" ]; then
        if [ -d "$src" ]; then
            echo "   Copying directory $name to ~/.config/"
            cp -r "$src" "$CONFIG_DIR/"
        else
            echo "   Copying file $name to ~/.config/"
            cp "$src" "$CONFIG_DIR/$name"
        fi
    else
        echo "   Note: '$name' not found in dotfiles, skipping."
    fi
done
#Update font cache
echo "--> Updating font cache..."
fc-cache -fv
rm -rf ~/.config/hypr/hyprland.conf
mv ~/Hyprtheme/hyprland.conf ~/.config/hypr/
