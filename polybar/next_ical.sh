#!/usr/bin/env bash
# get next calendar event and either show colorized for polybar or do some action
# 20240620WF - init
get_next(){
  /usr/bin/python3 -m khal list --format "{start-time}	{title}	{description}" --day-format "" now 2d
}
cal_polybar(){
   # underbar color based on min until event 0-5=red, 5-15=bright, 15+=gray
   perl -F'\t' -slanE '
   $tm=$F[0]; $tl=$F[1];
   $min=(qx/date -d $tm +%s/ - $now)/60;
   $color=$min<5?"ff0000":($min<15?"990000":"333333");
   say "%{u#$color}%{+u}$tm $tl";
   exit; # show only one event
   
   # if no input need an empty line to clear any previous event
   END{say "" if $.==0;}' -- -now=$(date +%s)
}
cal_act(){
   cut -f3 |tee >(xclip -i) | grep -Po 'http[^ ]*(zoom|teams)[^ ]*' | xargs -n1 -r echo xdg-open
}

if [[ "$(caller)" == "0 "* ]]; then
   case "${1:-polybar}" in
      polybar) get_next|cal_polybar;;
      act) get_next|sed 1d| cal_act;;
      *) echo "unknown command '$1'"; exit 1;;
   esac
fi
