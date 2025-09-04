# Powerlevel 10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Paths
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

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

# fzf
function ff() {
    local selected=$(fd . ~ --follow --exclude .git --exclude Library --exclude Applications | fzf)
    if [ -n "$selected" ]; then
        if [ -d "$selected" ]; then
            cd "$selected"
        elif [[ "${selected:l}" == *.pdf ]]; then
            tdf "$selected" -m 1 -f true
        elif [[ "${selected:l}" == *.png ]]; then
            open "$selected"
        else
            nvim "$selected"
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
export IFX_TOOLBOX_UUID=97e4e1b6-cc54-3474-a522-f6e375f4c8f7
