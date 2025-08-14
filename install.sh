#!/bin/bash

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Create backup of existing config
backup_if_exists() {
    local target="$1"
    if [[ -e "$target" && ! -L "$target" ]]; then
        local backup="${target}.backup.$(date +%Y%m%d_%H%M%S)"
        log_warning "Backing up existing $target to $backup"
        mv "$target" "$backup"
    elif [[ -L "$target" ]]; then
        log_info "Removing existing symlink: $target"
        rm "$target"
    fi
}

# Create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Create target directory if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    # Backup existing file/dir
    backup_if_exists "$target"
    
    # Create symlink
    ln -sf "$source" "$target"
    log_success "Created symlink: $target -> $source"
}

# Detect operating system
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "unknown"
    fi
}

main() {
    log_info "Starting dotfiles installation..."
    log_info "Dotfiles directory: $DOTFILES_DIR"
    
    # Detect OS
    OS=$(detect_os)
    log_info "Detected OS: $OS"

    # Ensure config directory exists
    mkdir -p "$HOME/.config"

    # Create symlinks for config files
    log_info "Creating configuration symlinks..."

    # Neovim
    if [[ -d "$DOTFILES_DIR/config/nvim" ]]; then
        create_symlink "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"
    fi

    # Ghostty
    if [[ -d "$DOTFILES_DIR/config/ghostty" ]]; then
        if [[ "$OS" == "macos" ]]; then
            create_symlink "$DOTFILES_DIR/config/ghostty" "$HOME/Library/Application Support/com.mitchellh.ghostty"
        else
            create_symlink "$DOTFILES_DIR/config/ghostty" "$HOME/.config/ghostty"
        fi
    fi

    # Zsh
    if [[ -f "$DOTFILES_DIR/config/zsh/.zshrc" ]]; then
        create_symlink "$DOTFILES_DIR/config/zsh/.zshrc" "$HOME/.zshrc"
    fi

    if [[ -f "$DOTFILES_DIR/config/zsh/.p10k.zsh" ]]; then
        create_symlink "$DOTFILES_DIR/config/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
    fi

    if [[ -f "$DOTFILES_DIR/config/zsh/.zshenv" ]]; then
        create_symlink "$DOTFILES_DIR/config/zsh/.zshenv" "$HOME/.zshenv"
    fi
    log_success "Dotfiles installation completed!"
    log_info "Please restart your terminal or run 'source ~/.zshrc' to apply changes"
}

# Check if script is being run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
