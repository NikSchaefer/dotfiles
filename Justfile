install:
    @mkdir -p ~/.config

    @ln -sf ~/dotfiles/config/nvim ~/.config/nvim
    @ln -sf ~/dotfiles/config/ghostty ~/.config/ghostty
    @ln -sf ~/dotfiles/config/yazi ~/.config/yazi

    @ln -sf ~/dotfiles/config/zsh/.zshrc ~/.zshrc
    @ln -sf ~/dotfiles/config/zsh/.p10k.zsh ~/.p10k.zsh

    @echo "Dotfiles installed. 'source ~/.zshrc' to refresh"

