#!/usr/bin/env bash
set -euo pipefail
ZSHRC="$HOME/.zshrc"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

cp -n "$ZSHRC" "${ZSHRC}.backup"

echo "Downloading new .zshrc from GitHub"
curl -fsSL https://raw.githubusercontent.com/blitzes27/macos/main/terminal_plastic_surgery/.zshrc -o "$ZSHRC"

  echo ' Dont forget to source your .zshrc file. COMMAND = source ~/.zshrc'
  echo ' Or restart your terminal'
  echo ' You can now use the following commands:'
  echo '  - ls = ls -a'
  echo '  - ls1 = ls -lah'