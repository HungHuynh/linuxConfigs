#!/bin/zsh

# Clipboard sync
autocutsel -fork &
autocutsel -selection PRIMARY -fork &

#turn off beep sound
xset -b

#slow down mouse speed
xset m 1/5

#urxvtd daemon
urxvtd -q -f -o &

#wallpaper random
while true
do
    imlibsetroot "$(find /mnt/ntfs-inbox/Dropbox/photo/square -type f | shuf -n1)"
    sleep 10m
done &

#font
xset +fp /usr/share/fonts/local
xset fp rehash

#Disable touchpad tapping and scrolling when typing
syndaemon -t -i 2 &

# Dropbox
(sleep 300 && dropboxd) &

# DWM status bar
#!/bin/bash
# Status script for dwm

bat(){
    ac="$(awk '{ gsub(/%|%,/, "");} NR==1 {print $4}' <(acpi -V))"
    onl="$(grep "on-line" <(acpi -V))"
    if [ -z "$onl" ] && [ "$ac" -gt "15" ]; then
        echo -e "BAT \x06$ac%\x01"
    elif [ -z "$onl" ] && [ "$ac" -le "15" ]; then
        echo -e "BAT \x03$ac%\x01"
    else
        echo -e "AC \x06$ac%\x01"
    fi
}

mem(){
    mem="$(awk '/cache:/ {print $3}' <(free -m))"
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
    hd="$(df -P | sort -d | awk '/^\/dev/{s=s (s?" ":"") $5} END {printf "%s", s}')"
    echo -e "\x07$hd\x01"
}

pac(){
    pup="$(pacman -Qu | wc -l)"
    if [ $pup == 0 ]; then echo "0"
    else echo -en "\x05$pup\x01"
    fi
}

int(){
    int="$(ping -c1 google.com>/dev/null)"
    if [ $? -eq 0 ]; then echo -e "\x04NET\x01"
    else echo -e "\x03NET\x01"
    fi
}

dte(){
    dte="$(date "+%I:%M")"
    echo -e "\x08$dte\x01"
}

# Pipe to status bar

while true; do
    xsetroot -name "[$(bat)] [$(cpu)$(mem)] [$(hdd)] [PAC $(pac)] [$(int)] $(dte) "
    sleep 1m    # Update time every minute
done &

exec dwm
