# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$HOME/.composer/vendor/bin:$PATH
PHP_VERSION=$(ls /Applications/MAMP/bin/php/ | sort -n | tail -1)
export PATH=$PATH:/usr/local/mysql/bin

export PATH=/Applications/MAMP/bin/php/${PHP_VERSION}/bin:$PATH
# Path to your oh-my-zsh installation.
export ZSH=/Users/m/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Change the command execution time stamp shown in the history command output.
HIST_STAMPS="yyyy/mm/dd"

# Standard plugins: ~/.oh-my-zsh/plugins/*
# Custom plugins: ~/.oh-my-zsh/custom/plugins/

local ret_status="%(?:%{$fg_bold[green]%}☝️ :%{$fg_bold[red]%}👀 )"
PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

plugins=(git zsh-completions autojump)

source $ZSH/oh-my-zsh.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Open the current repo on github.com
function gh() {
  REPO=`git remote -v | grep github.com | head -n 1 | sed -e 's/.*:\([^.]*\).*/\1/'`
  open "https://github.com/$REPO/"
}

# Open a pull request for the current branch on github.com
function ghpr() {
  BRANCH=`git symbolic-ref --quiet --short HEAD`
  REPO=`git remote -v | grep github.com | head -n 1 | sed -e 's/.*:\([^.]*\).*/\1/'`
  open "https://github.com/$REPO/compare/master...$BRANCH"
}

# 👤 User configuration

export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code'
fi

# Load .profile
[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

