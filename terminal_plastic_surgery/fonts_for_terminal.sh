#!/usr/bin/env bash
set -euo pipefail

# Do not run as root
if [ "$EUID" -eq 0 ]; then
  echo "[ERROR] Do not run this script as root."
  exit 1
fi

# Install MesloGS Nerd Font into ~/Library/Fonts
FONT_NAME="Meslo"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/${FONT_NAME}.zip"
FONT_DIR="$HOME/Library/Fonts"

echo "[INFO] Downloading ${FONT_NAME} Nerd Font..."
curl -L -o "${FONT_NAME}.zip" "$FONT_URL"

echo "[INFO] Unzipping archive..."
unzip -q "${FONT_NAME}.zip" -d "${FONT_NAME}_font"
rm "${FONT_NAME}.zip"

echo "[INFO] Copying .ttf files to $FONT_DIR..."
mkdir -p "$FONT_DIR"
cp "${FONT_NAME}_font"/*.ttf "$FONT_DIR"

echo "[INFO] Cleaning up temporary files..."
rm -rf "${FONT_NAME}_font"

echo "[INFO] MesloGS Nerd Font installed in $FONT_DIR."

# Open iTerm (launch if not running)
open -a iTerm
