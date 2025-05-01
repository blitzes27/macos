#!/usr/bin/env bash
set -euo pipefail

# check if the script is run as root
if [ "$EUID" -eq 0 ]; then
  echo "[ERROR] Do not run this script as root. Exit."
  exit 1
fi

# Check if Command Line Tools are installed
# If not, install them
echo "[INFO] Checking for Command Line Tools..."

if ! xcode-select -p &>/dev/null; then
  echo "[INFO] Command Line Tools not found. Launching installer..."
  xcode-select --install

  echo "[INFO] Waiting for Command Line Tools installation to complete..."
  while ! xcode-select -p &>/dev/null; do
    sleep 5
  done

  echo "[INFO] Command Line Tools installation completed."
else
  echo "[INFO] Command Line Tools already installed."
fi

ZSHRC="$HOME/.zshrc"
cd ~

echo "[INFO] Backing up existing .zshrc if it exists..."
cp -n "$ZSHRC" "${ZSHRC}.backup" || true

# to prevent the script from running interactively
export RUNZSH=no

ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
THEME_DIR="$ZSH_CUSTOM_DIR/themes/powerlevel10k"
AUTOSUGGEST_DIR="$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
SYNTAXHIGHLIGHT_DIR="$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"

echo "[INFO] Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "[INFO] Installing Powerlevel10k theme..."
if [ ! -d "$THEME_DIR" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$THEME_DIR"
fi

echo "[INFO] Installing Powerlevel10k config…"
curl -fsSL https://raw.githubusercontent.com/blitzes27/macos/main/terminal_plastic_surgery/.p10k.zsh \
  -o ~/.p10k.zsh


echo "[INFO] Installing Zsh plugins: autosuggestions"
if [ ! -d "$AUTOSUGGEST_DIR" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "$AUTOSUGGEST_DIR"
fi

echo "[INFO] Installing zsh-syntax-highlighting..."
if [ ! -d "$SYNTAXHIGHLIGHT_DIR" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$SYNTAXHIGHLIGHT_DIR"
fi

echo "[INFO] Installing zoxide..."
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

echo "[INFO] Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH if not already there
if ! grep -q '/opt/homebrew/bin' ~/.zprofile 2>/dev/null; then
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

if ! command -v brew >/dev/null 2>&1; then
  echo "[ERROR] Homebrew not found after installation"
  exit 1
fi

echo "[INFO] Installing eza using Homebrew..."
brew install eza

echo "[INFO] Installing Sublime Text using Homebrew..."
brew install --cask sublime-text

echo "[INFO] Installing iTerm2 using Homebrew..."
brew install --cask iterm2



echo "[INFO] Downloading custom .zshrc from GitHub..."
curl -fsSL https://raw.githubusercontent.com/blitzes27/macos/main/terminal_plastic_surgery/.zshrc -o "$ZSHRC"

curl -fsSL https://raw.githubusercontent.com/blitzes27/macos/main/terminal_plastic_surgery/fonts_for_terminal.sh | bash


echo ""
echo "[DONE] Installation complete!"
echo "You can now use:"
echo "  - ls   (eza -a --group-directories-first --icons=auto)"
echo "  - ls1  (eza -lah --group-directories-first --icons=auto)"
echo "To apply changes in new terminals, either run: source ~/.zshrc or restart your terminal."