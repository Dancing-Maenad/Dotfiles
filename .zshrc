# Lines marked "# CHANGED:" or "# NEW:" are the edits from this round.
# Everything else is your previous config, unchanged.

# Uncomment to profile startup (also uncomment `zprof` at the very bottom)
# zmodload zsh/zprof

# ==========================================
# PATH & ENVIRONMENT (Zsh Native Array)
# ==========================================
typeset -U path PATH
path=(
  $HOME/.local/bin
  $HOME/Applications/depot_tools
  /usr/local/bin
  /usr/bin
  /bin
  /usr/sbin
  /sbin
  $path
)
export PATH
# CHANGED: removed the startup `rehash` (it did nothing useful here).
# New binaries are picked up via the `rehash true` completion style below.

# NEW: cache the output of slow `tool init zsh` commands. The cache is rebuilt
# automatically when the tool's binary is newer than the cache (i.e. after an
# update). Returns non-zero if the command fails, so callers can fall back.
_evalcache() {
  local dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  local cache="$dir/${1:t}-init.zsh"
  [[ -d $dir ]] || mkdir -p "$dir"
  if [[ ! -s $cache || ${commands[$1]} -nt $cache ]]; then
    if ! "$@" > "$cache.tmp" 2>/dev/null; then
      rm -f "$cache.tmp"
      return 1
    fi
    mv -f "$cache.tmp" "$cache"
  fi
  source "$cache"
}

# Run hyfetch as welcome message (interactive shells only)
# Optional: only run it in a shell opened in $HOME by adding
#   && [[ $PWD == $HOME ]]
# to the condition below.
if [[ -o interactive && $PWD == $HOME ]] && command -v hyfetch &> /dev/null; then
  hyfetch
#  fastfetch --kitty-direct ~/Pictures/mintyforcows.png --logo-width 65
#  echo "Wheek! Wheek! Have you fed us a treat?" | cowsay -f ~/.cows/guineapig.cow
fi

# Format man pages using bat & col
export MANROFFOPT="-c"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Enable colors
autoload -U colors && colors

# ==========================================
# OPTIONS
# ==========================================
setopt extended_glob auto_cd auto_pushd pushd_ignore_dups pushd_silent
setopt interactive_comments no_beep complete_in_word
# Free up Ctrl-S / Ctrl-Q so the terminal can't freeze
setopt no_flow_control
# Report background job status immediately
setopt notify

# Ctrl-W / Alt-B stop at slashes, so deleting a path goes one segment at a time
WORDCHARS=${WORDCHARS//\//}

# Named directory, so `cd ~dots` works anywhere
hash -d dots=$HOME/Git/dotfiles

# ==========================================
# HISTORY SETTINGS
# ==========================================
HISTFILE=~/.zsh_history
# CHANGED: HISTSIZE is larger than SAVEHIST so hist_expire_dups_first has room
# to work (with equal sizes it behaves like hist_ignore_all_dups once full)
HISTSIZE=120000
SAVEHIST=100000
setopt append_history
setopt share_history
setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
setopt bang_hist
setopt hist_expire_dups_first
setopt hist_find_no_dups

# Custom history with timestamps
alias history="fc -E -i 1"

# ==========================================
# AUTO-COMPLETION
# ==========================================
autoload -Uz compinit
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

# Cache slow completers (dnf), label groups (shown by fzf-tab), complete . and ..
[[ -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh" ]] || mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' special-dirs true
# NEW: newly installed commands are completable right away (no new shell needed
# after `dnf install`)
zstyle ':completion:*' rehash true

# ==========================================
# KEYBINDINGS
# ==========================================
bindkey -e

# Covers both normal and application-mode arrow codes (kitty/zsh can send
# either), and handles multi-line commands better.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search
bindkey '^[[C' forward-word

# Delete, Home, End
bindkey '^[[3~' delete-char
bindkey '^[[H'  beginning-of-line
bindkey '^[OH'  beginning-of-line
bindkey '^[[F'  end-of-line
bindkey '^[OF'  end-of-line

# Ctrl+arrows and Ctrl+Delete
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[3;5~' kill-word

# Page Up / Page Down
bindkey '^[[5~' beginning-of-buffer-or-history
bindkey '^[[6~' end-of-buffer-or-history

# Edit current command line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Double-tap Esc to prepend sudo
sudo-command-line() {
  [[ -z $BUFFER ]] && zle up-history
  [[ $BUFFER == sudo\ * ]] || BUFFER="sudo $BUFFER"
  CURSOR=$#BUFFER
}
zle -N sudo-command-line
bindkey '\e\e' sudo-command-line

# ==========================================
# FEDORA PACKAGE SOURCES
# ==========================================
# Fzf
# CHANGED: use `fzf --zsh` (fzf 0.48+, output cached), falling back to the
# packaged files on older versions
if (( $+commands[fzf] )); then
  if ! _evalcache fzf --zsh; then
    [[ -f /usr/share/fzf/shell/key-bindings.zsh ]] && source /usr/share/fzf/shell/key-bindings.zsh
    [[ -f /usr/share/fzf/shell/completion.zsh ]]   && source /usr/share/fzf/shell/completion.zsh
  fi
fi

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--height=40% --layout=reverse --border=rounded --info=inline-right --bind='ctrl-/:toggle-preview'"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --icons --color=always {}'"

# fzf-tab: auto-clone on first run, update with `zsh-update`
[[ -d ~/.zsh/fzf-tab ]] || git clone --depth=1 https://github.com/Aloxaf/fzf-tab ~/.zsh/fzf-tab
alias zsh-update='git -C ~/.zsh/fzf-tab pull'

# Optional: fzf-tab (git clone https://github.com/Aloxaf/fzf-tab ~/.zsh/fzf-tab)
# Must load after compinit and before autosuggestions/syntax-highlighting
if [[ -f ~/.zsh/fzf-tab/fzf-tab.plugin.zsh ]]; then
  source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh
  zstyle ':completion:*' menu no
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath'
  zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --line-range=:100 $realpath 2>/dev/null || eza -1 --color=always $realpath'
fi

# Autosuggestions fall back to completion when history has nothing.
# These must be set BEFORE the plugin is sourced.
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40

# Autosuggestions
if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  # Ctrl+Space accepts the whole suggestion (Right arrow still goes word by word)
  bindkey '^ ' autosuggest-accept
fi

# ==========================================
# HOOKS
# ==========================================
autoload -Uz add-zsh-hook

# CHANGED: (Y51) stops globbing after 51 entries, so cd into a huge directory
# no longer has to read all of it just to decide not to list it
_ls_on_cd() {
  local -a entries
  entries=( *(NDY51) )
  (( $#entries <= 50 )) && eza --icons --group-directories-first
}
add-zsh-hook chpwd _ls_on_cd

# ==========================================
# CUSTOM FUNCTIONS
# ==========================================
# NOTE: zsh expands aliases when it parses a function body, so after a `reload`
# an alias like `ps` or `grep` would get baked into these functions. Inside
# functions, call such commands as `command ps`, `command grep`, etc.

backup() {
  cp "$1" "$1.bak"
}

mkcd() { mkdir -p "$1" && cd "$1" }

extract() {
  case "$1" in
    *.tar.*|*.tgz|*.tbz2) tar xf "$1" ;;
    *.zip) unzip "$1" ;;
    *.gz)  gunzip "$1" ;;
    *.7z)  7z x "$1" ;;
    *.rar) unrar x "$1" ;;
    *) echo "don't know how to extract $1" ;;
  esac
}

# Fuzzy-jump into any subdirectory
fcd() {
  local d
  d=$(fd --type d --hidden --exclude .git | fzf --preview 'eza --tree --level=2 --color=always {}') && z "$d"
}

# Fuzzy-kill processes
# CHANGED: `command ps` so a future `ps` alias can't break this
fkill() {
  local pids
  pids=$(command ps -u $USER -o pid,comm,%cpu,%mem | sed 1d | fzf -m | awk '{print $1}')
  [[ -n $pids ]] && kill ${=pids}
}

# Batch rename with patterns. Dry run first: zmv -n '(*).jpeg' '$1.jpg'
autoload -Uz zmv

# Fuzzy branch checkout, newest first
# CHANGED: `command grep` so the grep alias can't leak in on reload
gbr() {
  local b
  b=$(git branch --all --sort=-committerdate | command grep -v HEAD | sed 's/^[* ]*//; s#remotes/origin/##' | awk '!seen[$0]++' \
    | fzf --preview 'git log --oneline --color=always -n 15 {}') && git checkout "$b"
}

# Browse commits with a diff preview
glf() {
  git log --oneline --color=always | fzf --ansi --no-sort --preview 'git show --color=always {1}'
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
# CHANGED: noglob, because extended_glob makes `git show HEAD^` fail with
# "no matches found". (git does its own pathspec matching, so this is safe.)
alias git='noglob git'
alias g='git'
alias gst='git status'
alias gad='git add'
alias gco='git commit -m'
alias gpu='git push'
alias glo='git log --oneline --graph --decorate'

# My random commands
alias ki='kitten icat'
alias nv='nvim'
alias dots='z ~/Git/dotfiles/'
alias home='z ~'
alias grubup="sudo grub2-mkconfig -o /boot/grub2/grub.cfg"
alias tarnow='tar -acf '
# CHANGED: -z only handled gzip; plain -x auto-detects the compression
alias untar='tar -xvf '
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

# Fun
alias gpig='echo "Wheek! Wheek! Feed us a treat!" | cowsay -f ~/.cows/guineapig.cow'
alias gpigl='echo "¡Lechuga, señorita, por favor!" | cowsay -f ~/.cows/guineapig.cow'
alias gpigb='echo "Happiness is a warm guinea!" | cowsay -f ~/.cows/guineapig.cow'

# Global aliases (use anywhere in a command) and suffix aliases
alias -g G='| grep -i'
alias -g L='| less'
alias -g NE='2>/dev/null'
alias -s {md,txt,conf,json,toml,lua}=nvim

# Optional extras, uncomment if you want them
# alias cat='bat --paging=never'

# CHANGED: modern replacements are only aliased if the tool is installed.
# Note: duf and dust take different flags than df/du (e.g. no `df -h`).
# `ps` is deliberately NOT aliased (it breaks psmem / psmem11); use `pp` instead.
(( $+commands[btop] ))    && alias top='btop'
(( $+commands[duf] ))     && alias df='duf'
(( $+commands[dust] ))    && alias du='dust'
(( $+commands[procs] ))   && alias pp='procs'
(( $+commands[lazygit] )) && alias lg='lazygit'

# ==========================================
# INITIALISATIONS
# ==========================================
# CHANGED: init output is cached (rebuilt when the binary updates). If a tool
# ever misbehaves after an update, delete ~/.cache/zsh/*-init.zsh
if (( $+commands[starship] )); then _evalcache starship init zsh; fi
if (( $+commands[zoxide] ));  then _evalcache zoxide init zsh;  fi

# Per-directory environment variables (only if direnv is installed)
#if command -v direnv &> /dev/null; then
#  eval "$(direnv hook zsh)"
#fi

# Transient prompt: collapses old prompts down to a bare arrow
zle-line-init() {
  emulate -L zsh
  [[ $CONTEXT == start ]] || return 0
  while true; do
    zle .recursive-edit
    local -i ret=$?
    [[ $ret == 0 && $KEYS == $'\4' ]] || break
    [[ -o ignore_eof ]] || exit 0
  done
  local saved_prompt=$PROMPT
  local saved_rprompt=$RPROMPT
  PROMPT='%F{green}❯%f '
  RPROMPT=''
  zle .reset-prompt
  PROMPT=$saved_prompt
  RPROMPT=$saved_rprompt
  if (( ret )); then
    zle .send-break
  else
    zle .accept-line
  fi
  return ret
}
zle -N zle-line-init

# Syntax highlighting must be the very last thing sourced
if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Uncomment together with the zmodload line at the top to see startup timings
# zprof
