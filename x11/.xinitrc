#!/usr/bin/env bash

samsung_tv(){
   # 20201129 - overscan issues for upstars tv
   xrandr --output HDMI1 --mode 1280x720 --transform 1.04,0,-27,0,1.05,-14,0,0,1 --panning 1280x720 --pos 0x0 $@
}

case $HOSTNAME in
   kt)
      # 20200815 - moved upstairs
      xrandr --output DVI-D-0 --rotate normal --left-of HDMI-0
      # 20200526 - new curbed samsung w/ HDMI-DV1
      # xrandr --output HDMI-1 --mode 1920x1080;;
      # # old TV with overscan issue VGA setting
      # xrandr | grep -q HDMI-1\ connected &&
      # xrandr --output HDMI-1 --mode 1920x1080i \
      #   --transform 1.05,0,-49,0,1.06,-31,0,0,1 \
      #   --panning 1920x1080 \
      #   --pos 0x0 \
      #   --left-of DVI-D-1;;
      (cd $HOME/Photos/wallpaper/ &&
       feh --bg-scale shozo_shimamoto.jpeg  JeanGiraud_Moebius_canyon.png)
      ;;
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
         samsung_tv --output LVDS1 --off ||
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

test -r ~/.Xdefaults && xrdb -merge $_

# clipboard manager: greenclip
#  systemctl --user start greenclip.service

# TODO: use lighter sxhc?
xbindkeys
# mouse gesture actions (plum)
#easystroke & # commented out (20200515)
# composite manager if needed (20200515)
#command -v picom && picom &
# window management only if needed 
# could call .xinitrc from i3/config
(sleep 5; autokey-gtk) &
pgrep i3 || i3
