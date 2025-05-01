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

# Open iTerm2 (launch if not running)
open -a iTerm

# Give iTerm2 a moment to start
sleep 5

# Use AppleScript to update all iTerm2 profiles to use MesloLGS NF
osascript <<EOF
tell application "iTerm"
  -- Update fonts in every saved profile
  repeat with p in profiles
    tell p
      set normal font to "MesloLGS NF"
      set normal font size to 17
      set non ascii font to "MesloLGS NF"
      set non ascii font size to 17
    end tell
  end repeat

  -- Refresh the current session so changes take effect
  tell current window
    select first session
  end tell

  -- Restart iTerm to apply all changes
  quit
  delay 1
  activate
end tell
EOF

echo "[DONE] iTerm2 profiles updated to use MesloLGS NF."
echo "Please restart iTerm2 if you do not see the change immediately."