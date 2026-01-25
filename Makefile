install:
	@mkdir -p ~/.config

	@ln -sf ~/dotfiles/nvim ~/.config/nvim
	@ln -sf ~/dotfiles/ghostty ~/.config/ghostty
	@ln -sf ~/dotfiles/yazi ~/.config/yazi

	@ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
	@ln -sf ~/dotfiles/zsh/.p10k.zsh ~/.p10k.zsh

	@echo "Dotfiles installed. 'source ~/.zshrc' to refresh"

