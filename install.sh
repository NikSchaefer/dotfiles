#!/bin/bash
mkdir -p ~/.config

# Use -n to prevent nesting if target is a symlink to a directory
ln -snfv ~/dotfiles/nvim ~/.config/nvim
ln -snfv ~/dotfiles/ghostty ~/.config/ghostty
ln -snfv ~/dotfiles/yazi ~/.config/yazi
ln -snfv ~/dotfiles/btop ~/.config/btop

ln -snfv ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -snfv ~/dotfiles/zsh/.p10k.zsh ~/.p10k.zsh

# Install zap zsh if not already present
if [ ! -d "$HOME/.local/share/zap" ]; then
    curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh | zsh -s -- --branch release-v1
else
    echo "Zap Zsh already installed."
fi

echo "Dotfiles installed. 'source ~/.zshrc' to refresh"

