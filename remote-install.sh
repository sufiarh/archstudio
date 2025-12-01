#!/bin/bash
set -e
sudo pacman -S --needed --noconfirm git
git clone https://github.com/sufiarh/archstudio.git ~/archstudio
cd ~/archstudio
chmod +x install.sh
./install.sh
