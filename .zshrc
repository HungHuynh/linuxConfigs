# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh
export EDITOR="vim"

#DIR = "/root/.zsh"
. /root/.zsh/aliases
. /root/.zsh/functs

export XMODIFIERS="@im=ibus"
export GTK_IM_MODULE="ibus"
export QT_IM_MODULE="ibus"
# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
export ZSH_THEME="prose"

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
#plugins=(git github vi-mode)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

