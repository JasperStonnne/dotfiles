# npm global (no sudo)
export PATH="$HOME/.npm-global/bin:$PATH"

# Hermes Agent — ensure ~/.local/bin is on PATH
export PATH="$HOME/.local/bin:$PATH"

# Hermes profile aliases
alias alan='hermes --profile alan'
alias bruce='hermes --profile bruce'
alias heart='hermes --profile heart'
alias naval='hermes --profile naval'
alias qwen-tunnel='ssh -N -L 11435:127.0.0.1:11434 -J xuzhanliang@safe.kaer.cn:60022 kaer@192.168.0.101'
alias ai-server='ssh -p 60022 xuzhanliang@safe.kaer.cn'


# Codex shell enhancements: completion, suggestions, highlighting
if type brew >/dev/null 2>&1; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
fi

zstyle ":completion:*" menu select
zstyle ":completion:*" matcher-list "m:{a-zA-Z}={A-Za-z}"
zmodload zsh/complist 2>/dev/null

autoload -Uz compinit
compinit

if command -v gh >/dev/null 2>&1; then
  eval "$(gh completion -s zsh)"
fi

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

if [[ -o interactive && -t 0 && -x /opt/homebrew/bin/fzf ]]; then
  source <(/opt/homebrew/bin/fzf --zsh)
fi
export PATH="$(go env GOPATH)/bin:$PATH"
