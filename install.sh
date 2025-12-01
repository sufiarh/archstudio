#!/bin/bash
set -e

echo "================================="
echo "  Sufiarh Hyprland Dotfiles Installer"
echo "================================="

# --------------------------------------------------------
# 0. Ensure yay exists
# --------------------------------------------------------
if ! command -v yay &> /dev/null; then
    echo "[0/6] yay not found. Installing yay..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
fi

# --------------------------------------------------------
# 1. Update system
# --------------------------------------------------------
echo "[1/6] Updating system..."
sudo pacman -Syu --noconfirm

# --------------------------------------------------------
# 2. Install packages (using pacman.txt + aur.txt)
# --------------------------------------------------------
echo "[2/6] Installing packages..."

if [ ! -f pacman.txt ]; then
    echo "ERROR: pacman.txt not found!"
    exit 1
fi

if [ ! -f aur.txt ]; then
    echo "ERROR: aur.txt not found!"
    exit 1
fi

PACMAN_PKGS=$(grep -v "^\s*#" pacman.txt | grep -v "^\s*$")
AUR_PKGS=$(grep -v "^\s*#" aur.txt | grep -v "^\s*$")

if [ -n "$PACMAN_PKGS" ]; then
    echo "→ Installing official packages..."
    sudo pacman -S --needed --noconfirm $PACMAN_PKGS
fi

if [ -n "$AUR_PKGS" ]; then
    echo "→ Installing AUR packages..."
    yay -S --needed --noconfirm $AUR_PKGS
fi

# --------------------------------------------------------
# 3. Restore ~/.config
# --------------------------------------------------------
echo "[3/6] Restoring ~/.config..."
sudo pacman -S --needed --noconfirm rsync

mkdir -p ~/.config
rsync -avh .config/ ~/.config/

# --------------------------------------------------------
# 4. Enable services
# --------------------------------------------------------
echo "[4/6] Enabling services..."
sudo pacman -S --needed --noconfirm networkmanager bluez
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth.service || true

# --------------------------------------------------------
# 5. Setup auto-login & Hyprland autostart
# --------------------------------------------------------
echo "[5/6] Setting up auto-login to Hyprland and disabling boot menu..."
USER_NAME=$(whoami)

sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf > /dev/null <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $USER_NAME --noclear %I \$TERM
EOF

grep -qxF '[[ -z $DISPLAY ]] && exec Hyprland' ~/.bash_profile || \
    echo '[[ -z $DISPLAY ]] && exec Hyprland' >> ~/.bash_profile

# Disable bootloader timeout if using systemd-boot
if [ -d /boot/loader ]; then
    echo "default arch" | sudo tee /boot/loader/loader.conf
    echo "timeout 0" | sudo tee -a /boot/loader/loader.conf
fi

# --------------------------------------------------------
# 6. Finish
# --------------------------------------------------------
echo "================================="
echo " Installation complete!"
echo " System will reboot now to apply everything and auto-login to Hyprland."
echo "================================="

sudo reboot
