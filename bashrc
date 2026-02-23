# CUSTOM BASHRC

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2000
HISTFILESIZE=20000

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command
shopt -s checkwinsize

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

[ -z "$PS1" ] && return

# Aliases
alias r='echo Clearing... && sleep 1 && clear && source ~/.bashrc'
alias dirsize='du -sh -- * .[!.]* 2>/dev/null | sort -h'
alias update='sudo apt update && sudo apt upgrade && sudo flatpak update'
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'

# Autostart
if [ -f "$HOME/.starofitrc" ]; then
    source "$HOME/.starofitrc"
    date "+%A, %d.%m.%Y - %H:%M:%S"
    echo "Hostname: $HOSTNAME"
    echo "IP: $(ip route get 1.1.1.1 | awk '{print $7; exit}')"
else
    fastfetch
    date "+%a, %d.%m.%Y - %H:%M:%S"
    echo Bro denkt, er wäre im Hacker-Modus
fi
PS1='\[\e[1;32m\][\u@\h:\w]\$\[\e[0m\] '
