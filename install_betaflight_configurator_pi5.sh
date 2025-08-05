#!/bin/bash
set -e

echo "========================================"
echo "  Betaflight Configurator Installer"
echo "  För Raspberry Pi 5 - 64-bit OS"
echo "========================================"

# --- Uppdatera systemet ---
sudo apt update && sudo apt upgrade -y

# --- Installera grundläggande verktyg ---
sudo apt install -y curl wget git build-essential python3 unzip

# --- Lägg till NodeSource repo (Node 18) ---
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -

# --- Installera NodeJS och NPM ---
sudo apt install -y nodejs

# --- Installera övriga beroenden ---
sudo apt install -y libusb-1.0-0 libudev-dev

# --- Hämta källkod ---
if [ ! -d "$HOME/betaflight-configurator" ]; then
    git clone https://github.com/betaflight/betaflight-configurator.git "$HOME/betaflight-configurator"
else
    cd "$HOME/betaflight-configurator"
    git pull
    cd ..
fi

# --- Bygg Betaflight Configurator ---
cd "$HOME/betaflight-configurator"
npm install
npm run dist

# --- Skapa startikon ---
DESKTOP_FILE="$HOME/.local/share/applications/betaflight-configurator.desktop"
mkdir -p "$(dirname "$DESKTOP_FILE")"

cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=Betaflight Configurator
Comment=FPV Flight Controller Configurator
Exec=$HOME/betaflight-configurator/dist/linux-arm64-unpacked/betaflight-configurator
Icon=$HOME/betaflight-configurator/images/icons/icon_256.png
Terminal=false
Type=Application
Categories=Development;Utility;
EOF

chmod +x "$DESKTOP_FILE"

echo "========================================"
echo "✅ Betaflight Configurator är installerad!"
echo "   Starta via menyn eller kör manuellt:"
echo "   $HOME/betaflight-configurator/dist/linux-arm64-unpacked/betaflight-configurator"
echo "========================================"
