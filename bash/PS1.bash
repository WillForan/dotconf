# -*- mode: sh -*-
# vim: filetype=sh

####pretty prompt
# transform hostname into a "unique" color
colnum=$(echo $(whoami)$(hostname) | ruby -ne 'puts $_.split("").map {|x| x.ord}.reduce(:+) % 256')
# info on one line
  blue="\[[38;5;27m\]"
  pink="\[[38;5;197m\]"
 green="\[[38;5;121m\]"
purple="\[\e[1;35m\]"
yellow="\[[1;33m\]"
invert="\[\e[7m\]"
 nocol="\[[0m\]"
hostco="\[\e[48;5;${colnum}m\]"
hostcoi="\[\e[38;5;${colnum}m\]"

# reset color after pushing enter
# https://wiki.archlinux.org/index.php/Color_Bash_Prompt#Tips_and_tricks
#trap 'echo -ne "\e[0m"' DEBUG

if [ "$TERM" == "linux" ]; then
  blue="\[[1;34m\]"
  pink="\[[1;31m\]"
 green="\[[1;32m\]"
fi

case $TERM in 
  *xterm*) x11title="\[\033]0;\u@\h:\w\007\]";;
        *) x11title="";;
esac
#PS1="$yellow$(jobs|wc -l|sed -e '/^0$/d;s/$/ /')$pink$(date +%H:%M) $green\h$nocol:\[\e[3m\]$blue\w$nocol\n$purple»$nocol "
#PS1="$pink\t $green\h$nocol:\[\e[3m\]$blue\w$nocol\n$purple»$nocol "
PS1="$x11title$hostcoi#$pink\t ${green}$(hostname|cut -d. -f1 )$nocol:\[\e[3m\]$blue\w$nocol\n$hostco $nocol"


