#  -----------------------------
#  1.  CONFIGURATION
#  -----------------------------

export PS1="[\[\033[0;37m\]dev\[\033[0m\]] \w\n-> "
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

repo_status() {
    # Fetch the latest updates from the upstream remote
    local upstream_remote
    upstream_remote=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null | sed 's/\/.*//')

    # If no upstream remote is found, return an error
    if [ -z "$upstream_remote" ]; then
        echo "No upstream remote found for the current branch."
        return 1
    fi

    # Detect the default branch (e.g., main or master)
    local default_branch
    default_branch=$(git symbolic-ref refs/remotes/"$upstream_remote"/HEAD 2>/dev/null | sed 's|^refs/remotes/'"$upstream_remote"'/||')

    # Fallback to 'main' if no default branch is found
    if [ -z "$default_branch" ]; then
        default_branch="main"
    fi

    git fetch "$upstream_remote" "$default_branch" &> /dev/null

    # Get the name of the current branch
    local branch=$(git rev-parse --abbrev-ref HEAD)

    # Helper function to format commit message
    format_commit_message() {
        local count=$1
        if [ "$count" -eq 1 ]; then
            echo "$count commit"
        else
            echo "$count commits"
        fi
    }

    if [ "$branch" = "$default_branch" ]; then
        # Check if we're behind the remote default branch
        local behind=$(git rev-list --count HEAD.."$upstream_remote"/"$default_branch")
        if [ "$behind" -gt 0 ]; then
            echo "On $default_branch branch, $(format_commit_message "$behind") behind $upstream_remote/$default_branch"
        else
            echo "On $default_branch branch, up to date with $upstream_remote/$default_branch"
        fi
    else
        # Check if the branch is ahead or behind the default branch
        local ahead=$(git rev-list --count "$default_branch"..HEAD)
        local behind=$(git rev-list --count HEAD.."$default_branch")

        # Check if there are remote commits available
        local remote_ahead=$(git rev-list --count "$branch".."$upstream_remote"/"$branch")
        local remote_behind=$(git rev-list --count "$upstream_remote"/"$branch"..HEAD)

        echo "On branch '$branch':"
        if [ "$ahead" -gt 0 ]; then
            echo "  $(format_commit_message "$ahead") ahead of $default_branch"
        fi
        if [ "$behind" -gt 0 ]; then
            echo "  $(format_commit_message "$behind") behind $default_branch"
        fi
        if [ "$remote_ahead" -gt 0 ]; then
            echo "  $(format_commit_message "$remote_ahead") ahead of $upstream_remote/$branch"
        fi
        if [ "$remote_behind" -gt 0 ]; then
            echo "  $(format_commit_message "$remote_behind") behind $upstream_remote/$branch"
        fi
        if [ "$ahead" -eq 0 ] && [ "$behind" -eq 0 ] && [ "$remote_ahead" -eq 0 ] && [ "$remote_behind" -eq 0 ]; then
            echo "  Branch is up to date with $default_branch and $upstream_remote/$branch"
        fi
    fi
}
