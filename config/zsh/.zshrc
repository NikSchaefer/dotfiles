# Powerlevel 10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# paths
export PATH="/opt/homebrew/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# zap
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"
plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-syntax-highlighting"
plug "romkatv/powerlevel10k"
plug "hlissner/zsh-autopair"

autoload -U compinit; compinit

alias cat="bat"
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias v='nvim'
alias la="ls -A"
alias reload='source ~/.zshrc'
alias spotify='spotify_player'

alias gorepo='url=$(git config --get remote.origin.url); if [[ -n "$url" ]]; then open "$url"; else echo "No git remote origin found"; fi'

weather() { curl -s "wttr.in/$1?format=3"; }

# powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

