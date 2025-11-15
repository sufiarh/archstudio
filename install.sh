#!/bin/bash
set -e

echo "================================="
echo "  Sufiarh Hyprland Dotfiles Installer"
echo "================================="

# --------------------------------------------------------
# 1. Update system
# --------------------------------------------------------
echo "[1/6] Updating system..."
sudo pacman -Syu --noconfirm

# --------------------------------------------------------
# 2. Install pacman packages from packages.txt
# --------------------------------------------------------
echo "[2/6] Installing packages..."
if [ ! -f packages.txt ]; then
    echo "ERROR: packages.txt tidak ditemukan!"
    exit 1
fi

sudo pacman -S --needed --noconfirm - < packages.txt

# --------------------------------------------------------
# 3. Install yay (AUR helper)
# --------------------------------------------------------
echo "[3/6] Installing yay (AUR helper)..."

if ! command -v yay &>/dev/null; then
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
else
    echo "yay sudah terinstall."
fi

# --------------------------------------------------------
# 4. Restore dotfiles (~/.config)
# --------------------------------------------------------
echo "[4/6] Restoring dotfiles to ~/.config ..."

mkdir -p ~/.config
rsync -avh .config/ ~/.config/

# --------------------------------------------------------
# 5. Restore SDDM (themes + faces)
# --------------------------------------------------------
echo "[5/6] Restoring SDDM theme & faces..."

# Themes
if [ -d sddm/themes ]; then
    sudo mkdir -p /usr/share/sddm/themes/
    sudo cp -r sddm/themes/* /usr/share/sddm/themes/
fi

# Faces (user profile images)
if [ -d sddm/faces ]; then
    sudo mkdir -p /usr/share/sddm/faces/
    sudo cp -r sddm/faces/* /usr/share/sddm/faces/
fi

# Enable SDDM
sudo systemctl enable sddm.service

# --------------------------------------------------------
# 6. Enable core services
# --------------------------------------------------------
echo "[6/6] Enabling services..."

sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth || true

echo "================================="
echo "  Instalasi Selesai!"
echo "  Silakan reboot untuk melihat hasil."
echo "================================="
