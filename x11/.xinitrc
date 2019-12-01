#!/usr/bin/env bash
# hdmi tv overscan obscures screen corners
case $HOSTNAME in
   kt)
      # old TV with overscan issue VGA setting
      xrandr | grep -q HDMI-1\ connected &&
      xrandr --output HDMI-1 --mode 1920x1080i \
        --transform 1.05,0,-49,0,1.06,-31,0,0,1 \
        --panning 1920x1080 \
        --pos 0x0 \
        --left-of DVI-D-1;;
esac

# make sure xbindkeys can find everything in the path
source $HOME/.bashrc
xbindkeys  # TODO: use lighter sxhc?
easystroke &
# window management only if needed (could call .xinitrc from i3/config)
pgrep i3 || i3
