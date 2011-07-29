#!/usr/bin/python3
# coding: utf-8
import re
from datetime import datetime
from subprocess import *
from decimal import Decimal

def run_cmd(cmd):
    return Popen(cmd, stdout=PIPE).communicate()[0].decode("utf-8").strip()

def get_mpd():
    try:
        interim = run_cmd(["ncmpcpp", "--now-playing"]).split()[1:]
        for entry in interim:
            old_entry=entry
            entry = entry+" "
            interim[interim.index(old_entry)]=entry

        status = ''.join(interim)
    except OSError:
        return ''

    if "Cannot connect" in status or not status:
        status = "Not playing"

    return "\x02î\x01{status}  ".format(status=status)

def get_volume():
    try:
        mix = run_cmd(["/home/bryan/.bin/volctrl"])
    except:
        return ''

    volume = int(mix.split('\n')[1].lstrip('[').split('%')[0])

    icon = "í"
    if volume == 0:
        return "\x05ê Muted  "
    if volume < 66:
        icon = "ì"
    if volume < 33:
        icon = "ë"

    return "\x02{icon}\x01{volume}%  ".format(icon=icon, volume=str(volume))

def get_temp():
    icon = "þ"
    curTemp = run_cmd(["sensors"]).split('\n')
    for line in curTemp:
        if line.startswith('Core 0') == True:
            core0Temp = line.split()[2].lstrip('+').split('.')[0]
        elif line.startswith('Core 1') == True:
            core1Temp = line.split()[2].lstrip('+').split('.')[0]
    vidTemp = run_cmd(["nvidia-settings","-tq","[gpu:0]/GpuCoreTemp"])
    return "\x02{icon}\x01{core0Temp}° {core1Temp}° {vidTemp}°".format(icon=icon, core0Temp=core0Temp, core1Temp=core1Temp, vidTemp=vidTemp)

def get_mem_usage():
    icon = "ü"
    cmd=getoutput("free -m -t | tail -n 1 | awk '{total=$2} {used=$3} END {print used}  {print total}'").split()
    used=cmd[1]
    total=cmd[0]
    mem_perc=(Decimal(used)/Decimal(total)*100).quantize(Decimal("0"))
    return "\x02{icon}\x01{mem_perc}%".format(icon=icon,mem_perc=str(mem_perc))

def get_cpu_usage():
    icon = "û"
    cmd=getoutput('cat /proc/loadavg | cut -d " " -f1')
    cpu_perc=(Decimal(cmd)*100).quantize(Decimal(0))
    return "\x02{icon}\x01{cpu_perc}%".format(icon=icon,cpu_perc=str(cpu_perc))
def get_mail():
    icon = "ÿ"
    unread=run_cmd(["sh", "/home/bryan/.bin/checkmail.sh"])
    return "\x02{icon}\x01{unread}".format(icon=icon, unread=str(unread))

def get_date():
    date = datetime.now().strftime("%m/%d/%Y")
    return date

def get_time():
    time = datetime.now().strftime("%I:%M %P")
    return "\x02 {0}\x01".format(time)

print(
#    get_mail()   +
    get_mpd()   +
    get_volume() +
    get_temp() +
    get_cpu_usage() +
    get_mem_usage() +
    get_time()
)

