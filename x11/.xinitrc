#!/usr/bin/env bash
      



      # NB. indent and newlines  b/c hdmi tv overscan obscures screen corners
      xrandr|grep -q 'HDMI-1 con' &&
        xrandr --output HDMI-1 --mode 1920x1080i --transform 1.05,0,-49,0,1.06,-31,0,0,1 --panning 1920x1080 --pos 0x0
      # make sure xbindkeys can find everything in the path
      source $HOME/.bashrc
      # capslock is control
      setxkbmap -layout us -option ctrl:nocaps
      # TODO: use lighter sxhc?
      xbindkeys
      easystroke &
      # window management
      i3
#xrandr --output HDMI1 --above LVDS1 --mode 1360x768
