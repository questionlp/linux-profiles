# ~/.bashrc: executed by bash(1) for non-login shells.
# .bash_profile sources this file
# Utility methods are currently stored here, but may be
#  included elsewhere in the future

# Add command to ascertain external ip
whatsmyip() {
  if hash dig 2>/dev/null; then
    echo "Sending dig request to @resolver1.opendns.com."
    dig +short myip.opendns.com @resolver1.opendns.com
  else
    echo "command 'dig' required."
  fi
}


# Disable ctrl-s locking
[[ $- == *i* ]] && stty -ixon

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt 
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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

############## set_screen_title ##############
# Sets screen and Terminal title.  May not work
# for all terminals.
set_screen_title ()
{
    echo -ne "\ek$1\e\\"
    echo -e '\033]2;'$1'\007'
}

############## GBRAIN HELP SYSTEM ##############
# Autocomplete method for the 'ghelp' function
_ghelp()
{
    local cur=${COMP_WORDS[COMP_CWORD]}
    # these map to files in the /notes/ directory
    COMPREPLY=( $(compgen -W "vim git screen" -- $cur) )
}
complete -F _ghelp ghelp

ghelp(){
	cat ${GHELP_DIR}/notes/$1_notes.md
}

export PS1="\[\033[01;34m\]\u\[\033[01;32m\]@\[\033[01;36m\]\h:\[\033[01;35m\]\w \[\033[01;31m\]\$ \[\033[00m\]"

LS_COLORS='di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
export LS_COLORS
