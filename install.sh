mkdir -p ~/.config

ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/ghostty ~/.config/ghostty
ln -sf ~/dotfiles/yazi ~/.config/yazi
ln -sf ~/dotfiles/btop ~/.config/btop

ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/zsh/.p10k.zsh ~/.p10k.zsh

# Install zap zsh
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1

echo "Dotfiles installed. 'source ~/.zshrc' to refresh"

