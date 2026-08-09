#!/bin/bash
set -euo pipefail

mkdir -p ~/.config

DOTFILES_DIR=~/dotfiles

# Link dotfile configs
ln -snfv $DOTFILES_DIR/nvim ~/.config/nvim
ln -snfv $DOTFILES_DIR/ghostty ~/.config/ghostty
ln -snfv $DOTFILES_DIR/yazi ~/.config/yazi

ln -snfv $DOTFILES_DIR/zsh/.zshrc ~/.zshrc
ln -snfv $DOTFILES_DIR/zsh/.p10k.zsh ~/.p10k.zsh

# Install zap zsh if not present
if [ ! -d "$HOME/.local/share/zap" ]; then
    curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh | zsh -s -- --branch release-v1
fi

if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Install it first: https://brew.sh" >&2
    exit 1
fi

brew bundle --file $DOTFILES_DIR/Brewfile

echo "Dotfiles installed. 'source ~/.zshrc' to refresh"
