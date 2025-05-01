#!/usr/bin/env bash
set -euo pipefail

ZSHRC="$HOME/.zshrc"
cd ~

# 1. Install Oh My Zsh (unattended)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 2. Clone Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

# 3. Clone Zsh autosuggestions and syntax highlighting plugins
git clone https://github.com/zsh-users/zsh-autosuggestions \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

# 4. Install zoxide
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# 5. Backup existing .zshrc (if present)
cp -n "$ZSHRC" "${ZSHRC}.backup" || true

# 6. Download custom .zshrc from GitHub
echo "Downloading new .zshrc from GitHub..."
curl -fsSL https://raw.githubusercontent.com/blitzes27/macos/main/terminal_plastic_surgery/.zshrc \
  -o "$ZSHRC"
  echo ' Dont forget to source your .zshrc file. COMMAND = source ~/.zshrc'
  echo ' Or restart your terminal'
  echo ' You can now use the following commands:'
  echo '  - ls = ls -a'
  echo '  - ls1 = ls -lah'