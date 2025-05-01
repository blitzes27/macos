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

PLIST="$HOME/Library/Preferences/com.googlecode.iterm2.plist"

if [ ! -f "$PLIST" ]; then
  echo "[ERROR] iTerm preferences not found at $PLIST"
  exit 1
fi

# 1. Extract the GUID for the profile named "mesloLGS Nerd Font"
GUID=$(
  /usr/libexec/PlistBuddy -c "Print :\"New Bookmarks\"" "$PLIST" \
  | awk '/Name = MesloLGS Nerd Font/{ getline; print }' \
  | sed -E 's/ *GUID = (.*);/\1/'
)

if [ -z "$GUID" ]; then
  echo "[ERROR] Could not find GUID for MesloLGS Nerd Font profile"
  exit 1
fi

# 2. Set it as the default profile
/usr/libexec/PlistBuddy -c "Set :\"Default Bookmark Guid\" $GUID" "$PLIST"

# 3. Restart iTerm so the change takes effect
osascript <<EOF
tell application "iTerm"
  quit
  delay 1
  activate
end tell
EOF

echo "[DONE] iTerm default profile set to MesloLGS Nerd Font."