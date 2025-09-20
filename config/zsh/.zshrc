# Powerlevel 10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Paths
export BUN_INSTALL="$HOME/.bun"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Zap
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-syntax-highlighting"
plug "romkatv/powerlevel10k"
plug "hlissner/zsh-autopair"
plug "aloxaf/fzf-tab"

autoload -U compinit; compinit

alias v="nvim"
alias cat="bat"
alias ls="eza --icons"
alias la="eza -A --icons"
alias gorepo='open "$(git remote get-url origin | sed "s/\.git$//")"'

# fzf - general file finder from anywhere
function ff() {
    local selected=$HOME/$(cd ~ && fd . --follow --exclude .git --exclude Library --exclude Applications --exclude go | fzf)
    if [ -n "$selected" ]; then
        if [ -d "$selected" ]; then
            cd "$selected"
        else
            # Change to the file's directory first
            local dir=$(dirname "$selected")
            cd "$dir"
            # Open file based on extension
            case "${selected:l}" in
                *.pdf) tdf "$selected" -m 1 -f true ;;
                *.png|*.jpg|*.jpeg|*.gif|*.webp|*.svg|*.bmp|*.tiff) open "$selected" ;;
                *.mp4|*.mov|*.avi|*.mkv|*.webm|*.m4v) open "$selected" ;;
                *) nvim "$selected" ;;
            esac
        fi
    fi
}

# Setup Yazi (f for file)
function f() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
