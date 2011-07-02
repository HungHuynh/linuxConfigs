#!/bin/sh

#urxvtd daemon
urxvtd -q -f -o &

#wallpaper random
while true
do
    feh --bg-scale "$(find /ntfs-data/Dropbox/Photos/wide -type f | shuf -n1)"
    sleep 15m
done &

#font
xset +fp /usr/share/fonts/local
xset fp rehash

#Disable touchpad tapping and scrolling when typing
syndaemon -t -i 2 &

# Dropbox
(sleep 300 && dropboxd) &
 
# Status script for dwm
bat(){
	ac="$(acpi -V | awk '{ gsub(/,/, "");} NR==1 {print $3}')"
		if [$ac == "on-line"]; then echo -e "BAT \x03$ac\x01"
		else echo -e "AC \x06$ac\x01"
		fi
}

mem(){
     mem="$(free -m | awk '/Mem/ {print $4}')"
     echo -e "\x04$mem\x01"
     }

   # CPU line courtesy Procyon: https://bbs.archlinux.org/viewtopic.php?pid=661592
cpu(){
     cpu="$(eval $(awk '/^cpu /{print "previdle=" $5 "; prevtotal=" $2+$3+$4+$5 }' /proc/stat); sleep 0.4; 
      eval $(awk '/^cpu /{print "idle=" $5 "; total=" $2+$3+$4+$5 }' /proc/stat); 
      intervaltotal=$((total-${prevtotal:-0})); 
      echo "$((100*( (intervaltotal) - ($idle-${previdle:-0}) ) / (intervaltotal) ))")"
      echo -e "\x05$cpu%\x01"
     }

hdd(){     
     hd="$(df -P | sort -d | awk '/^\/dev/{printf "%s ", $5;}' | sed '$s/.$//')"
     echo -e "\x07$hd\x01"
     }

eml(){
     maildirs="$HOME/Mail/*/INBOX/new/"
     ml="$(find $maildirs -type f | wc -l)"
     if [ $ml == 0 ]; then
     echo "0"
     else
     echo -en "\x03$ml\x01"
     fi
     }

pac(){
     pup="$(pacman -Qu | wc -l)"
     if [ $pup == 0 ]; then echo "0"
     else echo -en "\x06$pup\x01"
     fi
     }

int(){
	int="$(ping -c1 google.com>/dev/null)"
		if [ $? -eq 0 ]; then echo -e "\x04NET\x01"
		else echo -e "\x03NET\x01"
			fi
}

dte(){
	dte="$(date "+ %a %d %b %r")"
		echo -e "\x08$dte\x01"
}

   # Pipe to status bar

# DWM status
while true; do
    xsetroot -name "[$(bat)] [$(cpu) $(mem)] [$(hdd)] [PAC $(pac)] [$(int)] $(dte) "
done &
exec dwm 
