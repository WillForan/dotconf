#!/usr/bin/env bash
case $HOSTNAME in
   kt)
      # old TV with overscan issue VGA setting
      xrandr | grep -q HDMI-1\ connected &&
      xrandr --output HDMI-1 --mode 1920x1080i \
        --transform 1.05,0,-49,0,1.06,-31,0,0,1 \
        --panning 1920x1080 \
        --pos 0x0 \
        --left-of DVI-D-1;;
   yogert)
      xrandr | grep -q HDMI1\ connected &&
      xrandr --output HDMI1 --above LVDS1 --mode 1360x768
      libinput-gestures-setup restart
      #synid=$(xinput list|perl -lne 'print $1 and exit if /Synaptics.*id=(\d+)/i')
      #xinput set-prop $synid 303 1 # enable tap
      xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1
      (sudo ifconfig wlp0s26u1u4i2 up;
      iwlist wlp0s26u1u4i2 scanning|grep abraham_linksys -q && wifi || sudo ifconfig wlp0s26u1u4i2 down) &
      ;;
  s2)
      # hdmi only if we have it
      xrandr | grep -q HDMI1\ connected &&
         xrandr --output HDMI1 --mode 1280x720 --output LVDS1 --off ||
         xrandr --output LVDS1 --mode 1366x768
      ;;

esac
# make sure xbindkeys can find everything in the path
source $HOME/.bashrc

# no bell
xset b off
#setxkbmap -layout us -option ctrl:nocaps
# capslock is control
setxkbmap -layout us -option "caps:ctrl_modifier"

# TODO: use lighter sxhc?
xbindkeys
# mouse gesture actions (plum)
#easystroke & # commented out (20200515)
# composite manager if needed (20200515)
command -v picom && picom &
# window management only if needed 
# could call .xinitrc from i3/config
pgrep i3 || i3
