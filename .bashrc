#-------------------------------------------------
# file:     ~/.bashrc                           
# author:   jason ryan - http://jasonwryan.com/    
# vim:nu:ai:si:et:ts=4:sw=4:ft=sh:
# -------------------------------------------------

# GPG Key
export GPGKEY=B1BD4E40

# bash options ------------------------------------
shopt -s autocd             # change to named directory
shopt -s cdable_vars        # if cd arg is not valid, assumes its a var defining a dir
shopt -s cdspell            # autocorrects cd misspellings
shopt -s checkwinsize       # update the value of LINES and COLUMNS after each command if altered
shopt -s cmdhist            # save multi-line commands in history as single line
shopt -s dotglob            # include dotfiles in pathname expansion
shopt -s expand_aliases     # expand aliases
shopt -s extglob            # enable extended pattern-matching features
shopt -s hostcomplete       # attempt hostname expansion when @ is at the beginning of a word
shopt -s nocaseglob         # pathname expansion will be treated as case-insensitive

# If not running interactively, don't do anything
[ -z "$PS1" ] && return


set_prompt_style () {

  PS1="┌─[\[\e[34m\]\h\[\e[0m\]][\[\e[32m\]\w\[\e[0m\]]\n└─╼ "
}
set_prompt_style

alias ls='ls --color=auto'

eval `dircolors -b ~/.dir_colors`

# set 256 colours in tmux
[ -n "$TMUX" ] && export TERM=screen-256color

# set Vim as default editor
export EDITOR="vim"
export FCEDIT="vim"

# export other directories to PATH
PATH=$PATH:/home/jason/Scripts
PATH=$PATH:/usr/lib/surfraw

# colourize terminal output w/ cope
PATH=/usr/share/perl5/vendor_perl/auto/share/dist/Cope:$PATH

# set default browser
BROWSER=/usr/bin/jumanji

# set history variables 
export HISTFILESIZE="1000"
export HISTCONTROL="ignoredups"

# share history across all terminals
shopt -s histappend
PROMPT_COMMAND='history -a'

# Bash completion
set show-all-if-ambiguous on

######## Aliases ########
#########################
#The 'ls' family
#---------------------------
alias ll="ls -l --group-directories-first"
alias ls="ls -hF --color"  # add colors for filetype recognition
alias la="ls -a"           # show hidden files
alias lx="ls -xb"          # sort by extension
alias lk="ls -lSr"         # sort by size, biggest last
alias lc="ls -ltcr"        # sort by and show change time, most recent last
alias lu="ls -ltur"        # sort by and show access time, most recent last
alias lt="ls -ltr"         # sort by date, most recent last
alias lm="ls -al |more"    # pipe through 'more'
alias lr="ls -lR"          # recursive ls
alias lsr="tree -Csu"      # nice alternative to 'recursive ls'

# The 'cd' family ----------
alias h="cd ~"
alias home="cd ~"
alias ..="cd .."        # go back one directory
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# General ------------------
alias hi="history"
alias rm="rm -i"
alias v="vim"
alias vi="vim"
alias sv="sudo vim"
alias svi="sudo vim"
alias wifi="wicd-curses"
alias pong="ping -c 3 www.google.com"
alias temp="acpi -t"
alias exit="clear; exit"
alias irc="rm -f /home/jason/.irssi/saved_colors & irssi"
alias lock="xscreensaver-command --lock"
alias ttytter="Scripts/ttytter.pl"
alias chat="tmux attach"
alias dush="du -sm *|sort -n|tail"
alias rss="newsbeuter"
alias sync="~/.dropbox-dist/dropboxd &"
alias config="cd /home/jason/Build/dwm/ && vim config.h"
alias nocomment='egrep -v "^[ \t]*#|^[ \t]*$"'
alias skype='ALSA_OSS_PCM_DEVICE="skype" aoss skype'

# grep
export GREP_COLOR="1;33"
alias grep='grep --color=auto'

# Power
alias reboot="sudo shutdown -r now"
alias shut="sudo shutdown -h now"

# Posts per day on Arch forum
alias posts="python ~/Scripts/postsperday.py 25579"

# Lock screensaver
alias lock="xscreensaver-command -lock"

######## Pacman ########
########################
# Colourized output
alias pacman="pacman"

# Lets you search through all available packages simply using 'pacsearch packagename'
alias pacsearch="pacman -Sl | cut -d' ' -f2 | grep "

# sudo pacman -Syu by typing pacup (sudo must be installed and configured first)
alias pacup="sudo pacman-color -Syu"

# sudo pacman -S by typing pac
alias pac="sudo pacman -S"

# Clean cache
alias clean="sudo pacman -Sc"

# Remove orphans
alias orphans="pacman -Qtdq > ~/Orphans.txt && less Orphans.txt"

# sudo pacman backup packages to Dropbox
alias pacback='sudo pacman -Qqe | grep -v "$(pacman -Qmq)" > ~/Dropbox/Archer/pklist.txt'

# coloured repo search
search () {
       echo -e "$(pacman -Ss $@ | sed \
       -e 's#core/.*#\\033[1;31m&\\033[0;37m#g' \
       -e 's#extra/.*#\\033[0;32m&\\033[0;37m#g' \
       -e 's#community/.*#\\033[1;35m&\\033[0;37m#g' \
       -e 's#^.*/.* [0-9].*#\\033[0;36m&\\033[0;37m#g' )"
}

# Mount options -----------
# Mount quiver
alias quiver="mount /mnt/quiver"

# Unmount quiver
alias sheath="umount /mnt/quiver"

# Mount Centurion
alias centurion="sudo mount.nfs 192.168.1.100:/home/jason ~/Centurion"

# Unmount Centurion
alias dismount="sudo umount ~/Centurion"

# Mount USB drives
alias usb="mount /mnt/usb"

# Unmount USB drives
alias unmount="umount /mnt/usb"

# Mount Fallback
alias fallback="mount /mnt/Fallback"

# Unmount Fallback
alias fallout="umount /mnt/Fallback"

####### Functions ########
##########################

# Extract Files
extract () {
  if [ -f $1 ] ; then
      case $1 in
          *.tar.bz2)   tar xvjf $1    ;;
          *.tar.gz)    tar xvzf $1    ;;
          *.tar.xz)    tar xvJf $1    ;;
          *.bz2)       bunzip2 $1     ;;
          *.rar)       unrar x $1     ;;
          *.gz)        gunzip $1      ;;
          *.tar)       tar xvf $1     ;;
          *.tbz2)      tar xvjf $1    ;;
          *.tgz)       tar xvzf $1    ;;
          *.zip)       unzip $1       ;;
          *.Z)         uncompress $1  ;;
          *.7z)        7z x $1        ;;
          *.xz)        unxz $1        ;;
          *.exe)       cabextract $1  ;;
          *)           echo "\`$1': unrecognized file compression" ;;
      esac
  else
      echo "\`$1' is not a valid file"
  fi
}

# Follow copied and moved files to destination directory
cpf() { cp "$@" && goto "$_"; }
mvf() { mv "$@" && goto "$_"; }
goto() { [ -d "$1" ] && cd "$1" || cd "$(dirname "$1")"; }

# Simple notes
n() { $EDITOR ~/.notes/"$*".txt ; }
nls () { tree -CR --noreport ~/.notes | awk '{ if ((NR > 1) gsub(/.txt/,"")); if (NF==1) print $1; else if (NF==2) print $2; else if (NF==3) printf "  %s\n", $3 }' ;}

# Print man pages 
manp() { man -t "$@" | lpr -pPrinter; }

# Create pdf of man page - requires ghostscript and mimeinfo
manpdf () { man -t "$@" | ps2pdf - /tmp/manpdf_$1.pdf && xdg-open /tmp/manpdf_$1.pdf ;}

##################################

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

### linux console colors (jwr dark) ###

if [ "$TERM" = "linux" ]; then
    echo -en "\e]P0000000" #black
    echo -en "\e]P83d3d3d" #darkgrey
    echo -en "\e]P18c4665" #darkred
    echo -en "\e]P9bf4d80" #red
    echo -en "\e]P2287373" #darkgreen
    echo -en "\e]PA53a6a6" #green
    echo -en "\e]P37c7c99" #brown
    echo -en "\e]PB9e9ecb" #yellow
    echo -en "\e]P4395573" #darkblue
    echo -en "\e]PC477ab3" #blue
    echo -en "\e]P55e468c" #darkmagenta
    echo -en "\e]PD7e62b3" #magenta
    echo -en "\e]P631658c" #darkcyan
    echo -en "\e]PE6096bf" #cyan
    echo -en "\e]P7899ca1" #lightgrey
    echo -en "\e]PFc0c0c0" #white
    clear # bring us back to default input colours
fi
