#!/bin/bash

set -e  # Exit on any error

DOTFILES_DIR="$HOME/dotfiles"

# Create .config directory if it doesn't exist
mkdir -p ~/.config

# Symlink config directories
ln -sf $DOTFILES_DIR/config/nvim ~/.config/nvim
ln -sf $DOTFILES_DIR/config/ghostty ~/.config/ghostty
ln -sf $DOTFILES_DIR/config/yazi ~/.config/yazi

# Symlink config files
ln -sf $DOTFILES_DIR/config/zsh/.zshrc ~/.zshrc
ln -sf $DOTFILES_DIR/config/zsh/.p10k.zsh ~/.p10k.zsh

echo "Dotfiles installed. 'source ~/.zshrc' to refresh"

