#!/bin/sh
#wallpaper random
while true
do
    feh --bg-scale "$(find /ntfs-data/pics/wall -type f | shuf -n1)"
    sleep 1m
done &
#Transparent
xcompmgr&
#font
xset +fp /usr/share/fonts/local
xset fp rehash
#Disable touchpad tapping and scrolling when typing
syndaemon -t -i 2 &
#Start mpd
#mpd ~/.mpd/config
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

batt(){
    ADAPTER="`acpi -a`"
    BATT="`acpi -b | awk '{print $4}'`"
    if test "$ADAPTER" == "" ; then
        echo " Pin"[$BATT];
    else
        if test "$BATT" != "" ; then
            echo " Charge"[$BATT];
        else 
            echo "AC";
        fi
    fi
}

volume(){
      STATUS="`amixer get Master|awk '/Front\ Left:/ {print $5}'`"
      if test "$STATUS" == "" ; then 
        echo "Mute"
      else
        echo $STATUS;
        #echo " `amixer get PCM |awk '/Front\ Left:/ {print $5}' | sed -e 's/\[//g'|sed -e 's/%\]//g'`v"
      fi
    }

cmusstats(){
      if test "X`pgrep cmus`" != "X" ; then 
        TIME="`cmus-remote -Q |awk '/duration/ {print $2}'`"
        CURR="`cmus-remote -Q |awk '/position/ {print $2}'`"
        ARTIST="`cmus-remote -Q |sed -ne '/artist/s/tag artist //pg'`"
        TITLE="`cmus-remote -Q |sed -ne '/title/s/tag title //pg'`"
        echo "$TITLE ($ARTIST) $CURR/$TIME"
      fi
    }

while true; do
  xsetroot -name "`cmusstats` `batt` `wifi``volume` `date '+%a %d-%m-%Y %H:%M'`"
  sleep 1
done &
exec dwm
(sleep 2 && exec conky)&