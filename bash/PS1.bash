# -*- mode: sh -*-
# vim: filetype=sh

####pretty prompt
# transform hostname into a "unique" color
#colnum=$(echo $(whoami)$(hostname) | ruby -ne 'puts $_.split("").map {|x| x.ord}.reduce(:+) % 256')
# perl is ~16ms. hard code vaules for known hosts
colnum=$(
 case $USER$HOSTNAME in
    foranwyogert) echo 39;;
    foranwrhea) echo 96;;
    *) perl -se '$x+=$_ for map {ord} split //, $X; END{print $x%256;}' -- -X="$USER$HOSTNAME";;
 esac
   )
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
_hostname=$(hostname|cut -d. -f1 )

prev_cmd_in_title(){
   echo -ne "\033]2;$_hostinfo:$PWD "
   history 1 | sed -z "s/^ *[0-9]* *//g;s/\n//g"
   echo -ne "\007";
}

case $TERM in
  *xterm*|alacritty)
     _hostinfo="$USER@$_hostname"
     _x11title="\[\033]0;$_hostinfo:\w\007\]"
     # 20211201 - add the running program to the title
     # https://stackoverflow.com/questions/5076127/bash-update-terminal-title-by-running-a-second-command/7110386#7110386
     # useful to id long running verbose output, but also finding eg. 'mpv'
     # NB. $PWD is not the same as \w: /home/... vs ~
     # NB. trap also executed in capture subshells! $_ is modified
     #  echo $(echo hi) && echo $_ # hi\n     \003.... hi
     #  similiar w/ xdotool set_window --name "test" $WINDOWID;
     #  instead use noop ':' with previous $_ to reinstantiate. 
     trap '__prevarg="$_"; prev_cmd_in_title; : "$__prevarg"' DEBUG

     # 20231126 - background color per host
     case $HOSTNAME in
        rhea)   BGCOLOR=292222;;
        reese)  BGCOLOR=222229;;
        yogert) BGCOLOR=222222;;
        *) printf -v BGCOLOR "%02x%02x%02x"  $((colnum%51))  $((colnum%25+25)) $((colnum%33+18));;
     esac
     printf '\e]11;#%s\007' "$BGCOLOR"
     ;;
  *) _x11title="";;
esac
#PS1="$yellow$(jobs|wc -l|sed -e '/^0$/d;s/$/ /')$pink$(date +%H:%M) $green\h$nocol:\[\e[3m\]$blue\w$nocol\n$purple»$nocol "
#PS1="$pink\t $green\h$nocol:\[\e[3m\]$blue\w$nocol\n$purple»$nocol "
PS1="$_x11title$hostcoi#$pink\t ${green}$_hostname$nocol:\[\e[3m\]$blue\w$nocol\n$hostco $nocol"


