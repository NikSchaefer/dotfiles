#!/bin/bash
mkdir -p ~/.config

# -n to prevent nesting
ln -snfv ~/dotfiles/nvim ~/.config/nvim
ln -snfv ~/dotfiles/ghostty ~/.config/ghostty
ln -snfv ~/dotfiles/yazi ~/.config/yazi
ln -snfv ~/dotfiles/btop ~/.config/btop

ln -snfv ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -snfv ~/dotfiles/zsh/.p10k.zsh ~/.p10k.zsh

# Install zap zsh if not present
if [ ! -d "$HOME/.local/share/zap" ]; then
    curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh | zsh -s -- --branch release-v1
fi

echo "Dotfiles installed. 'source ~/.zshrc' to refresh"

