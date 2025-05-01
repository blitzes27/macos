#!/usr/bin/env bash
set -euo pipefail

FONT_NAME="Meslo"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/${FONT_NAME}.zip"
FONT_DIR="$HOME/Library/Fonts"

echo "[INFO] Downloading ${FONT_NAME} Nerd Font..."
curl -L -o "${FONT_NAME}.zip" "$FONT_URL"

echo "[INFO] Unzipping archive..."
unzip -q "${FONT_NAME}.zip" -d "${FONT_NAME}_font"
rm "${FONT_NAME}.zip"

echo "[INFO] Installing font files to $FONT_DIR..."
mkdir -p "$FONT_DIR"
cp "${FONT_NAME}_font"/*.ttf "$FONT_DIR/"

echo "[INFO] Cleaning up..."
rm -rf "${FONT_NAME}_font"

echo "[DONE] MesloGS Nerd Font installed."
echo "To activate the font in Terminal.app:"
echo "1. Open Terminal > Settings > Profiles > Text."
echo "2. Click 'Change Font' and select 'MesloLGS NF'."