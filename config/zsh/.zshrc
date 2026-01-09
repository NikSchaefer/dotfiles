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
export PATH="$HOME/dotfiles/bin:$PATH"

# Zap
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-syntax-highlighting"
plug "romkatv/powerlevel10k"
plug "hlissner/zsh-autopair"
plug "aloxaf/fzf-tab"

# Brew tab completions
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)

autoload -U compinit; compinit

alias v="nvim"
alias cat="bat"
alias ls="eza --icons"
alias gorepo='open "$(git remote get-url origin | sed "s/\.git$//")"'

# fzf - general file finder from anywhere
fuzzy-find() {
    local selected=$HOME/$(cd ~ && fd . --follow --exclude .git --exclude Library --exclude Applications | fzf)
    if [ -n "$selected" ]; then
        if [ -d "$selected" ]; then
            BUFFER="cd $(printf %q "$selected")"
        else
            local dir=$(dirname "$selected")
            case "${selected:l}" in
                *.pdf)
                    BUFFER="cd $(printf %q "$dir"); tdf $(printf %q "$selected") -m 1 -f true"
                    ;;
                *.png|*.jpg|*.jpeg|*.gif|*.webp|*.svg|*.bmp|*.tiff|*.mp4|*.mov|*.avi|*.mkv|*.webm|*.m4v)
                    BUFFER="cd $(printf %q "$dir"); open $(printf %q "$selected")"
                    ;;
                *)
                    BUFFER="cd $(printf %q "$dir"); nvim $(printf %q "$selected")"
                    ;;
            esac
        fi
        zle accept-line
    else
        zle reset-prompt
    fi
}
zle -N fuzzy-find
bindkey '^F' fuzzy-find

# Setup Yazi (f for file)
function f() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# bun completions
[ -s "/Users/nikschaefer/.bun/_bun" ] && source "/Users/nikschaefer/.bun/_bun"

