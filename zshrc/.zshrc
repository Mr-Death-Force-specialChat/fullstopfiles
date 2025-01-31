EDITOR=vim
# Luke's config for the Zoomer Shell

# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zhistory

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Load aliases and shortcuts if existent.
[ -f "$HOME/.config/shortcutrc" ] && source "$HOME/.config/shortcutrc"
[ -f "$HOME/.config/aliasrc" ] && source "$HOME/.config/aliasrc"

# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# Custom
setopt interactivecomments
setopt HIST_IGNORE_SPACE
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^[[3~' delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
alias ls='ls --color=auto'
alias ll='ls -lstrah'
alias grep='grep --color=auto'
alias nbos='cd ~/desktop/NBOS && vim -p src/bootloader/stage1/boot.asm src/bootloader/stage2/main.c src/krnl/krnl.asm'
alias arduino='~/Downloads/arduino-ide_nightly-20231219_Linux_64bit/arduino-ide'
alias vim='nvim'
alias ovim='/bin/vim'
alias clipc='xclip'
alias clipg='xclip -selection clipboard'
alias clipv='xclip -o'
alias less='less -R'

program() { cd ~/desktop/programs/C++/P/$1; ./open.sh; };
rust() { cd ~/desktop/rusty/$1; vim; };
programq() { cd ~/desktop/programs/C++/P/qfs/q$1; ./open.sh; };
_program()
{
  compadd $(ls ~/desktop/programs/C++/P/ --color=none)
}
_rust()
{
  compadd $(ls ~/desktop/rusty/ --color=none)
}
_programq()
{
  compadd "16"
}

compdef _program program
compdef _rust rust
compdef _programq programq
neofetch -L
if [ -s NOTE.STARTUP_NOTE.txt ]; then
  cat NOTE.STARTUP_NOTE.txt
fi
setxkbmap us
setxkbmap -layout us,ara -option 'grp:win_space_toggle'

export DOTNET_CLI_TELEMETRY_OPTOUT=1
export PATH=$PATH:~/.local/bin
export LS_COLORS=$(cat ~/lscolors)
export SUDO_ASKPASS=~/askpass.sh
