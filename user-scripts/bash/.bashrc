#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Git extension
. ~/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1

#Set a terminal look and color for users, root has a different one
if [[ $(id -u) -eq 0 ]]; then
	PS1='\[\033[01;31m\]\u\[\033[00m\]@\[\033[01;34m\]\h\[\033[00m\]: \[\033[01;33m\][\w]\[\033[01;34m\]$(__git_ps1)\[\033[01;33m\] --> \[\033[31m\]# \[\033[00m\]'
else
	PS1='\[\033[01;32m\]\u\[\033[00m\]@\[\033[01;34m\]\h\[\033[00m\]: \[\033[01;33m\][\w]\[\033[01;34m\]$(__git_ps1)\[\033[01;33m\] --> \[\033[32m\]$ \[\033[00m\]'
fi

export HISTSIZE=50000
export HISTFILESIZE=50000
export EDITOR=vim

# Auto merge terimal historys after command
HISTCONTROL=ignoredups:erasedups:ignorespace
shopt -s histappend
#PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Aliases
alias ls='ls --color=auto'
alias l='ls -la --color=auto'
alias ip='ip --color=auto'
alias grep='grep --color'
alias ..='cd ..;pwd'
alias ...='cd ../..;pwd'
alias ....='cd ../../..;pwd'
alias c='clear'
alias h='history'
alias mkdir='mkdir -p -v'

# Bash completions
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Functions
function find-largest-files() {
    du -h -x -s -- * | sort -r -h | head -20;
}
