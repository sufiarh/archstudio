#!/bin/bash
set -e

echo "=== Archstudio Online Installer ==="

sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm git

if [ -d ~/archstudio ]; then
    rm -rf ~/archstudio
fi

git clone https://github.com/sufiarh/archstudio.git ~/archstudio
cd ~/archstudio
chmod +x install.sh

./install.sh
