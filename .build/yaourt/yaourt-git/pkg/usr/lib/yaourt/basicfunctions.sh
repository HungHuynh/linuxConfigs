#!/bin/bash
#
# basicfunctions.sh: common functions and initialisation 
# This file is part of Yaourt (http://archlinux.fr/yaourt-en)

unset PACMANDB LOCKFILE
COLUMNS=$(tput cols)

# pacman & package-query call with command line options
pacman_parse () { LC_ALL=C pacman "${PACMAN_C_ARG[@]}" "$@"; }
pacman_out () { $PACMAN "${PACMAN_C_ARG[@]}" "$@"; }
pkgquery () { package-query "${PKGQUERY_C_ARG[@]}" "$@"; }

# set misc path
initpath(){
	readarray -t P_CONF < <(
	pacman_parse --verbose | sed -n \
		-e 's|/ *$|/|' \
		-e 's/^Conf File *: //p' \
		-e 's/^DB Path *: //p' \
		-e 's/^Cache Dirs *: //p' \
		-e 's/^Lock File *: //p' \
		-e 's/^Log File *: //p' )
	PACMANDB=${P_CONF[1]}
	CACHEDIR=${P_CONF[2]}
	LOCKFILE=${P_CONF[3]}
	mkdir -p "$YAOURTTMPDIR"
}

# Load library but never reload twice the same lib
loadlibrary(){
	while [[ $1 ]]; do
		[[ "${!1}" ]] && return 0
		if [[ ! -r "/usr/lib/yaourt/$1.sh" ]]; then
			error "$1.sh file is missing"
			die 1
		fi
		source "/usr/lib/yaourt/$1.sh" || warning "problem in $1.sh library"
		eval $1=1
		shift
	done
}

printf -v P_INDENT "%*s" ${COLUMNS:-0}
# Fill line ($color_start,$content,$color_end)
echo_fill ()
{
	echo -e "$1${P_INDENT// /$2}$3"
}

# Wrap string
# usage: str_wrap ($indent, $str)
# return: set $strwrap with wrapped content
str_wrap ()
{
	local indent=${1:-0} ; shift
	(( indent > COLUMNS )) && { strwrap="$*"; return 0; }
	strwrap="${P_INDENT:0:$indent}$*"
	(( ${#strwrap} < COLUMNS-indent-1 )) && return 0 || { strwrap=""; set -- $*; }
	local i=0 strout=""
	while [[ $1 ]]; do
		strout+="$1 "
		(( i+=${#1}+1 ))
		k=${#2}
		if (( k && (i%COLUMNS)+indent+k>COLUMNS-1 )); then
			strwrap+="${P_INDENT:0:$indent}$strout\n"
			strout=""
			i=0
		fi
		shift
	done
	strwrap+="${P_INDENT:0:$indent}$strout"
}

echo_wrap ()
{
	str_wrap "$1" "$2"
	echo -e "$strwrap"
}

echo_wrap_next_line () 
{
	echo -en "$1"; shift
	local len=$1; shift
	local strout=""
	local i=0
	for str in "$@"; do
		str_wrap $len "$str"
		(( i++ )) || strwrap=${strwrap##*( )}
		strout+="$strwrap\n"
	done
	echo -en "$strout"
}

list_select ()
{
	local i=0
	for _line in "$@"; do
		(( i++ ))
		echo -e  "${colors[nb]}$i$C0 $_line"
	done
	echo
}

# ask 
userinput() 
{
	local _key=${1:-YN}
	local default=${2:-Y}
	local answer
	if (( NOCONFIRM ));then 
		answer=$default
	else
		read -en $NOENTER
		[[ $REPLY ]] && answer=$(echo ${REPLY^^*} | tr "$(gettext $_key)" "$_key") || answer=$default
		[[ "${_key/$answer/}" = "$_key" ]] && answer=$default
	fi
	echo $answer
	[[ "$answer" = "$default" ]]
}

useragrees()
{
	userinput "$@" &> /dev/null
	local ret=$?
	echo 
	return $ret
}

builduserinput () { NOCONFIRM=$BUILD_NOCONFIRM userinput "$@"; }
builduseragrees () { NOCONFIRM=$BUILD_NOCONFIRM useragrees "$@"; }

yes_no ()
{
	case $1 in
	  1) echo $(gettext "[Y/n]");;
	  2) echo $(gettext "[y/N]");;
	  *) echo $(gettext "[y/n]");;
	esac
}


is_x_gt_y(){
	[[ $(vercmp "$1" "$2" 2> /dev/null) -gt 0 ]]
}


##
# From makepkg.
#  usage : in_array( $needle, $haystack )
# return : 0 - found
#          1 - not found
##
in_array() {
	local needle=$1; shift
	[[ "$1" ]] || return 1 # Not Found
	local item
	for item in "$@"; do
		[[ "$item" = "$needle" ]] && return 0 # Found
	done
	return 1 # Not Found
}

# Run editor
# Usage: run_editor ($file, $default_answer)
# 	$file: file to edit 
# 	$default_answer: 0: don't ask	1 (default): Y	2: N
run_editor ()
{
	local edit_cmd
	local file="$1"
	local default_answer=${2:-1}
	local answer_str=" YN"
	local answer='Y'
	if (( default_answer )); then
		prompt "$(eval_gettext 'Edit $file ?') $(yes_no $default_answer) $(gettext '("A" to abort)')"
		local answer=$(userinput "YNA" ${answer_str:$default_answer:1})
		echo
		[[ "$answer" = "A" ]] && msg "$(gettext 'Aborted...')" && return 2
		[[ "$answer" = "N" ]] && return 1
	fi
	if [[ ! "$EDITOR" ]]; then
		echo -e "$CRED$(gettext 'Please add \$EDITOR to your environment variables')"
		echo -e "$C0$(gettext 'for example:')"
		echo -e "${CBLUE}export EDITOR=\"vim\"$C0 $(gettext '(in ~/.bashrc)')"
		echo "$(gettext '(replace vim with your favorite editor)')"
		echo
		prompt2 "$(eval_gettext 'Edit $file with: ')"
		read -e EDITOR
		echo
	fi
	[[ "$(basename "$EDITOR")" = "gvim" ]] && edit_cmd="$EDITOR --nofork" || edit_cmd="$EDITOR"
	( $edit_cmd "$file" )
	wait
}

check_dir ()
{
	[[ ! -d "${!1}" ]] && { error "${!1} $(gettext 'is not a directory')"; return 1; }	
	[[ ! -w "${!1}" ]] && { error "${!1} $(gettext 'is not writable')"; return 1; }	
	eval $1'="$(readlink -e "${!1}")"'	# get cannonical name
	return 0
}

# Main init

declare -A colors	#TODO not its place
shopt -s extglob
loadlibrary color
unset ABS_REPO
# General
AUTOSAVEBACKUPFILE=0
DEVELBUILDDIR='/var/abs/local/yaourtbuild'
DEVEL=0
FORCEENGLISH=0
FORCE=0
SUDONOVERIF=0 
# AUR 
AURCOMMENT=5
AURDEVELONLY=0
AURSEARCH=1
AURUPGRADE=0
AURVOTE=1
# BUILD
EXPORT=0
EXPORTSRC=0
EXPORTDIR=""
# Prompt
NOCONFIRM=0
UP_NOCONFIRM=0
BUILD_NOCONFIRM=0
EDITFILES=1
NOENTER=1
# OUTPUT
USECOLOR=1
DETAILUPGRADE=1
SHOWORPHANS=1
TERMINALTITLE=1
# Command
DIFFEDITCMD="vimdiff"

[[ -r '/etc/yaourtrc' ]] && source '/etc/yaourtrc'
[[ -r ~/.yaourtrc ]] && source ~/.yaourtrc
(( FORCEENGLISH )) && export LC_ALL=C
TMPDIR=${TMPDIR:-/tmp}
check_dir TMPDIR || die 1
YAOURTTMPDIR="$TMPDIR/yaourt-tmp-$(id -un)"
# PACMANBIN is depreceated
PACMAN=${PACMAN:-$PACMANBIN}
export PACMAN=${PACMAN:-pacman}
# vim: set ts=4 sw=4 noet: 
