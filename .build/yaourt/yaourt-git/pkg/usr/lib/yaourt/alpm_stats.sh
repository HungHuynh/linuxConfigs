#!/bin/bash
#
# alpm_stats.sh : collect and show some stats about local database.
# This file is part of Yaourt (http://archlinux.fr/yaourt-en)

loadlibrary pacman_conf
loadlibrary pkgbuild
unset repos_packages orphans repositories
pkgs_nb=0 pkgs_nb_d=0 pkgs_nb_e=0 pkgs_nb_dt=0 pkgs_nb_u=0

# set orphans, repo_packages, pkg_nb*
# parse pacman conf for ignored/hold packages
buildpackagelist()
{
	repositories=($(pkgquery -L))
	local f_foreign=1 f_explicit=2 f_deps=4 f_unrequired=8 \
		  f_upgrades=16 f_group=32 	
	while read pkgstate pkgrepo pkgname; do
		(( pkgs_nb++ ))
		(( pkgstate & f_deps )) && (( ++pkgs_nb_d )) && \
			(( pkgstate & f_unrequired )) && {
				(( pkgs_nb_dt++ ))
				orphans+=($pkgname)
			}
		(( pkgstate & f_explicit )) && (( pkgs_nb_e++ ))
		(( pkgstate & f_upgrades )) && (( pkgs_nb_u++ ))
		local reponumber=0
		for repo in ${repositories[@]}; do
			[[ "$repo" == "$pkgrepo" ]] && (( ++repos_packages[$reponumber] )) \
				&& break
			(( reponumber++ ))
		done
	done < <(pkgquery -Qf "%4 %s %n")
}

showpackagestats(){
	echo_fill "$CBLUE" - "$C0"
	if [[ -t 1 ]]; then
		printf "$C0%${COLUMNS}s\r|$C0$CBOLD%*s $CGREEN%s$C0\n" \
			"|" $((COLUMNS/2)) "Archlinux " "($NAME $VERSION)"
	else
		printf "%*s %s\n" 40 "Archlinux " "($NAME $VERSION)"
	fi
	echo_fill "$CBLUE" - "$C0"
	echo; echo_fill "$CBLUE" - "$C0"
	echo -e "$CGREEN$(gettext 'Total installed packages:')  $CYELLOW$pkgs_nb"	
	echo -e "$CGREEN$(gettext 'Explicitly installed packages:')  $C0$CYELLOW$pkgs_nb_e"	
	echo -e "$CGREEN$(gettext 'Packages installed as dependencies to run other packages:')  ${CYELLOW}$pkgs_nb_d"   
	echo -e "$CGREEN$(gettext 'Packages out of date:')  $CYELLOW$pkgs_nb_u"   
	if (( pkgs_nb_dt )); then
		echo -e "$CRED$(eval_gettext 'Where $pkgs_nb_dt packages seems no more used by any package:')$C0"
		echo_wrap 4 "${orphans[*]}"
	fi
	echo -e "$CGREEN$(gettext 'Hold packages:') (${#HoldPkg[@]}) $C0$CYELLOW${HoldPkg[@]}"
	echo -e "$CGREEN$(gettext 'Ignored packages:') (${#IgnorePkg[@]}) $C0$CYELLOW${IgnorePkg[@]}"
	echo -e "$CGREEN$(gettext 'Ignored groups:') (${#IgnoreGroup[@]}) $C0$CYELLOW${IgnoreGroup[@]}"
	echo; echo_fill "$CBLUE" - "$C0"
}

showrepostats(){
	local strout=""
	echo -e "$CGREEN$(gettext 'Number of configured repositories:')  $C0$CYELLOW${#repositories[@]}"
	echo -e "$CGREEN$(gettext 'Packages by repositories (ordered by pacman''s priority)')$C0:"
	local reponumber=0 pkgs_l=0
	for repo in ${repositories[@]}; do
		[[ ${repos_packages[$reponumber]} ]] || repos_packages[$reponumber]=0
		(( pkgs_l+=repos_packages[$reponumber] ))
		strout+="${repo}(${repos_packages[$reponumber]}), "
		(( reponumber++ ))
	done
	strout+=" $(gettext 'others')*($((pkgs_nb-pkgs_l)))"
	str_wrap 4 "$strout"
	strwrap=${strwrap//\(/$CYELLOW\(}
	strwrap=${strwrap//)/)$C0}
	echo -e "$strwrap"
	echo
	echo_wrap 4 "*$(gettext 'others') $(gettext 'are packages from local build or AUR Unsupported')"
	echo; echo_fill "$CBLUE" - "$C0"
}

showdiskusage()
{
	local cachedir size_t=0 size_r=0 i=1 _msg_label _msg_prog

	# Get space used by installed package (from info in alpm db)
	_msg_label=$(gettext 'Theorical - Real space used by packages:')
	_msg_prog=$(gettext 'progression:')
	while read s_t s_r; do
		(( size_t+=s_t ))
		(( size_r+=s_r ))
		[[ -t 1 ]] && \
			echo -ne "\r$CGREEN $_msg_label $CYELLOW$(($size_t/1048576))M -  $(($size_r/1048576))M $_msg_prog $((i++))/$pkgs_nb"
	done < <(pkgquery -Qf "%2 %3")
	[[ -t 1 ]] && { echo -en "\r"  ; echo_fill "" " " ""; }
	echo -e "$CGREEN$(gettext 'Theorical space used by packages:') $CYELLOW$(($size_t/1048576))M"
	echo -e "$CGREEN$(gettext 'Real space used by packages:') $CYELLOW$(($size_r/1048576))M"	
	# Get cachedir
	cachedir=(`pacman_parse --debug 2>/dev/null | grep "^debug: option 'cachedir'" |awk '{print $5}'`)
	# space used by download packages or sources in cache
	echo -e "$CGREEN$(gettext 'Space used by pkg downloaded in cache (cachedir):') $CYELLOW $(du -sh $cachedir 2>/dev/null|awk '{print $1}')"
	[[ "$SRCDEST" ]] && srcdestsize=`du -sh $SRCDEST 2>/dev/null|awk '{print $1}'` || srcdestsize=null
	echo -e "${CGREEN}$(gettext 'Space used by src downloaded in cache:') $CYELLOW $srcdestsize$C0"
}
# vim: set ts=4 sw=4 noet: 
