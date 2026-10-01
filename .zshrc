# ==========================================
# PATH & ENVIRONMENT (Zsh Native Array)
# ==========================================
typeset -U path PATH
path=(
  /usr/local/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  $HOME/.local/bin
  $HOME/Applications/depot_tools
  $path
)
export PATH
rehash  # Forces Zsh to scan the PATH immediately so mv, uname, etc. are found

export TERM="xterm-256color"

# Run hyfetch as welcome message
if command -v hyfetch &> /dev/null; then
  hyfetch
fi

# Format man pages using bat & col
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Enable colors
autoload -U colors && colors

# ==========================================
# HISTORY SETTINGS
# ==========================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt bang_hist            # Zsh native support for ! and !$

# Custom history with timestamps
alias history="fc -E -i 1"

# ==========================================
# AUTO-COMPLETION
# ==========================================
autoload -U compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

# ==========================================
# FEDORA PACKAGE SOURCES
# ==========================================
# 1. Autosuggestions
if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# 2. Syntax Highlighting (Must be loaded near the end)
if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# 3. Fzf/fd-find
#
# # Source Fedora's system-wide fzf scripts if available
if [ -f /usr/share/fzf/shell/key-bindings.zsh ]; then
  source /usr/share/fzf/shell/key-bindings.zsh
fi

if [ -f /usr/share/fzf/shell/completion.zsh ]; then
  source /usr/share/fzf/shell/completion.zsh
fi

# Optional: Use fd-find for lightning-fast file searches inside fzf
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ==========================================
# KEYBINDINGS
# ==========================================
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[C' forward-word

# ==========================================
# CUSTOM FUNCTIONS (Ported from Fish)
# ==========================================
backup() {
  cp "$1" "$1.bak"
}

# ==========================================
# ALIASES
# ==========================================

# Eza
alias ls='eza -al --color=always --group-directories-first --icons'
alias la='eza -a --color=always --group-directories-first --icons'
alias ll='eza -l --color=always --group-directories-first --icons'
alias lt='eza -aT --color=always --group-directories-first --icons'
alias l.="eza -a | grep -e '^\.'"

# Z
alias ..='z ..'
alias ...='z ../..'
alias ....='z ../../..'
alias .....='z ../../../..'
alias ......='z ../../../../..'

# DNF
alias d='sudo dnf'
alias dup='sudo dnf upgrade'
alias dse='dnf search'
alias din='sudo dnf install'
alias dre='sudo dnf remove'
alias dau='sudo dnf autoremove'
alias drp='dnf repoquery'
alias drp-ui='dnf repoquery --userinstalled'

# GIT
alias g='git'
alias gst='git status'
alias gad='git add'
alias gco='git commit -m'
alias gpu='git push'
alias glo='git log --oneline --graph --decorate'

# My random commands
alias nv='nvim'
alias dots='z ~/Git/dotfiles/'
alias home='z ~'
alias grubup="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias psmem='ps auxf | sort -nr -k 5'
alias psmem11='ps auxf | sort -nr -k 4 | head -10'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias hw='hwinfo --short'
alias jctl="journalctl -p 4 -xb"
alias cls='clear'
alias reload='source ~/.zshrc'


# Initialisations
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
