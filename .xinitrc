#!/bin/sh

# -- Apps
#clipboard synching
/usr/bin/autocutsel -fork &
/usr/bin/autocutsel -selection PRIMARY -fork &

#xscreensaver 
/usr/bin/xscreensaver -no-splash &

#wallpaper random
while true
do
    feh --bg-scale "$(find /ntfs-data/pics/wall -type f | shuf -n1)"
    sleep 15m
done &

#font
xset +fp /usr/share/fonts/local
xset fp rehash

#Disable touchpad tapping and scrolling when typing
syndaemon -t -i 2 &

#WM
wifi(){
    STATUS="X`iwgetid`"
    if test "$STATUS" != "X" ; then
        ESSID="`iwgetid |awk -F ":" '{print $2}'`"
        #LINK="`awk '/wlan0:/ {print $3}' /proc/net/wireless |sed -e 's/\.//g'`"
        echo " $ESSID "
        #todo: add up / down
    fi
} 
# - Start
while true; do
    getbat=`acpi -b | awk '{ print $4 }' | tr -d ','`
    getvol=`amixer get Master | tail -1 |awk '{print $4}' | tr -d '[]'`
    getdate=`date +"%a%d%b%R"`
xsetroot -name "Bat$getbat Vol$getvol $getdate"

done &
exec dwm
