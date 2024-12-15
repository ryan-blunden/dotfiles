#  -----------------------------
#  1.  CONFIGURATION
#  -----------------------------

# export PS1="[\[\033[0;37m\]dev\[\033[0m\]] \w\n-> "
export TERM='xterm-color'
export CLICOLOR=1
export LC_CTYPE='en_US.UTF-8'

export GIT_EDITOR='nano'
export EDITOR='nano'

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# ignore frequent commands and duplicates
# source: https://askubuntu.com/a/15930
export HISTIGNORE="&:[ ]*:exit:e:R:make:tmux.*:cd:la:ls:gd:gs:c:history:clear"
export HISTCONTROL=ignoredups
export HISTSIZE=10000


# make bash append rather than overwrite the history on disk
shopt -s histappend

# allow typos for cd, tab-completion, and better directory management
shopt -s audocd 2> /dev/null
shopt -s dirspell 2> /dev/null
shopt -s cdspell 2> /dev/null

# Debian bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Brew bash completion macOS
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"


#  -----------------------------
#  2.  UTILITIES
#  -----------------------------

alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ll='ls -FGlAhp'                       # Preferred 'ls' implementation
alias less='less -FSRXc'                    # Preferred 'less' implementation
cd() { builtin cd "$@"; ll; }               # Always list directory contents upon 'cd'
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels


#  -----------------------------
#  3.  ENHANCEMENTS
#  -----------------------------
eval "$(starship init bash)"