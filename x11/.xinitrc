#!/usr/bin/env bash

samsung_tv(){
   # 20201129 - overscan issues for upstars tv
   xrandr --output HDMI1 --mode 1280x720 --transform 1.04,0,-27,0,1.05,-14,0,0,1 --panning 1280x720 --pos 0x0 $@
}

### keyboard settings
## xcape
# cap released with no other key is escape
# [20211026]
# left shift -> (  -- ideally lispy mode picks up the other side
# right shift -> -  [20211026] { (Shift_R|braceleft)
# use editor/bash bindings to match pair
# set time out to be quicker than .5s default. less accidental presses
# 20211219 rigth alt (mode_switch) is delete. b/c kinesis del remapped to super
# 20220108 left alt backspace for non-kenisis keyboards
# 20221015 get curly { with left control (was on shift 20211026?)
command -v xcape >/dev/null && ! pgrep xcape &&
 xcape -e '#66=Escape;Shift_L=parenleft;Shift_R=minus;#108=Delete;Alt_L=BackSpace;Control_L=Shift_L|bracketleft' -t 150
# see also: space2ctrl (s2cctl start), and for wayland evscript

## CAPSLOCK and APL
# 20211022 - xcape/setxkbmap order seems to matter. setxkbmap last
# apl chars using right alt + key
# capslock is control (combined with apl 20211028)
setxkbmap -layout us,apl -variant ,dyalog \
   -option grp:switch -option caps:ctrl_modifier -option compose:menu
# could undo
#setxkbmap -layout us -option ctrl:nocaps

# right click keyboard "menu" is hyper (for emacs keybindings)
xmodmap -e "keysym Menu = Hyper_L"

test -r ~/.Xdefaults && xrdb -merge $_

case $HOSTNAME in
   reese)
      # 20221031 - reese on main config file after SSD upgrade
      test -n $(xinput --list|grep A4Tech|grep -Po '(?<=id=)\d+') &&
         xinput --set-button-map $_ 3 2 1
      #xrandr --output DVI-0 --rotate left  --right-of VGA-0
      #xrandr --output DVI-I-1 --rotate left  --right-of VGA-1
      xrandr --output VGA-1 --mode 1920x1080 --output HDMI-2 --right-of VGA-1
      xrandr --output HDMI-1 --rotate left


      nitrogen --restore &
      # work computer probably needs to lock itself
      xautolock -time 10 -locker "i3lock-fancy -p -g" -detectsleep &
      $HOME/src/utils/activitywatch/aw-qt &
      ;;
   kt)
      #xrandr --output HDMI-0 --rotate right --left-of DVI-D-0
      xrandr  --output DVI-D-0 --mode 1680x1050 --rotate right --output HDMI-0 --mode 1920x1080 --rotate normal --left-of DVI-D-0
      # 20200815 - moved upstairs
      #xrandr --output DVI-D-0 --rotate normal --left-of HDMI-0
      # 20200526 - new curbed samsung w/ HDMI-DV1
      # xrandr --output HDMI-1 --mode 1920x1080;;
      # # old TV with overscan issue VGA setting
      # xrandr | grep -q HDMI-1\ connected &&
      # xrandr --output HDMI-1 --mode 1920x1080i \
      #   --transform 1.05,0,-49,0,1.06,-31,0,0,1 \
      #   --panning 1920x1080 \
      #   --pos 0x0 \
      #   --left-of DVI-D-1;;
      $HOME/.fehbg &
      #(cd $HOME/Photos/wallpaper/ &&
      # feh --bg-scale shozo_shimamoto.jpeg  JeanGiraud_Moebius_canyon.png)
      # joystick to keys. also see morse.bash in .xbinkkeysrc
      antimicrox --tray  &
      nohup sbcl --eval '(load "~/bin/fpedal.lisp")' --non-interactive --quit &

      # 20211113 - cheap track ball mouse for left hand. swap left and right push
      # xinput set-prop "$mouse" 292 1 # 'Middle Emulation Enabled' (from reese, also see  xinput list-props $mouse)
      test -n $(xinput --list|grep A4Tech|grep -Po '(?<=id=)\d+') && xinput --set-button-map $_ 3 2 1

      # 20211111 - no display manager so systemctl fails. run manually
      # 20211114 - now using nodm. leaving here for refrence (systemctl --user start greenclip)
      # pgrep greenclip || greenclip daemon &
      # 20220111 - kinesis keyboard want alt back. remove apl layout
      
      # done for all (removed 20221031)
      # setxkbmap -layout us -option # reset
      # setxkbmap -layout us -option "caps:ctrl_modifier"

      # 20230219 - suspend to save power and quiet fan
      # only after work hours and if cpu usage is low
      # added after enabling wake-on-lan (wake_kt)
      xautolock -time 30 -locker "zzz_idle" -detectsleep &
      ;;
   yogert)
      xrandr --output LVDS1 --mode 1600x900
      xrandr | grep -q HDMI1\ connected &&
      xrandr --output HDMI1 --above LVDS1 --mode 1360x768
      xinput --map-to-output 'ELAN Touchscreen' LVDS1
      libinput-gestures-setup restart &
      #synid=$(xinput list|perl -lne 'print $1 and exit if /Synaptics.*id=(\d+)/i')
      #xinput set-prop $synid 303 1 # enable tap
      xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1
      (sudo ifconfig wlp0s26u1u4i2 up;
      iwlist wlp0s26u1u4i2 scanning|grep abraham_linksys -q && wifi || sudo ifconfig wlp0s26u1u4i2 down) &
      nitrogen --restore &
      # 20230505: '/opt/paloaltonetworks/globalprotect/PanGPA start' is running
      #  parent is bash running .xinitrc. where in here!? 'systemctl disable gpd'
      #  maybe from /etc/profile.d/PanMSInit.sh
      cbatticon &

      # barrierc  --enable-drag-drop --disable-crypto -f 192.168.1.75 &
      ;;
  x260)
      # disable gaps here rather than in config. like gaps for all other hosts
      (while ! pgrep i3; do sleep 1; done; i3-msg gaps outer all set 0; i3-msg gaps inner all set 0) &
      cbatticon &
      dunst &
      nitrogen --restore &
      autokey-gtk &
      # 20250504 - guix load path causes problems
      EMACSLOADPATH= emacsclient -a'' -c &
      ;;
  s2)
      # 'systemctl --user start greenclip' cannot find Xorg. so run deamon here
      # 20210707  - greenclip eats cpu. probably dont need it here
      # greenclip daemon &

      # book server. needs gui first. http by plugin
      pgrep -f calibre || $_ &
      # hdmi only if we have it
      xrandr | grep -q HDMI1\ connected &&
          samsung_tv --output LVDS1 --off ||
          xrandr --output LVDS1 --mode 1366x768
     ;;
  cn60-guix)
     #xrandr --output DP-1 --left-of HDMI-1 --mode 1920x1080 --rotate right
     xrandr --output DP-1 --mode 1920x1080 --rotate normal --left-of HDMI-1 --output HDMI-1 --rotate right
     ;;
esac

# no bell
xset b off

# clipboard manager: greenclip
#  systemctl --user start greenclip.service
# NB. consumes cpu/power (constant polling to not break X11 clipboard ownership)

# make sure xbindkeys can find everything in the path
source $HOME/.bashrc
xbindkeys
# TODO: use lighter sxhc?

# 20210108 - add facny notification deamon
command -v deadd-notification-center && $_ &
# 20221228 - time tracking. activitymonitor not mature enough? using proprietary 
command -v rescuetime && $_ &
# 20230329 - local only time tracking
command -v  aw-qt && $_ &
# 20230121 - screenshots. if daemon not running, copy/paste takes forever
command -v flameshot && $_ &

# mouse gesture actions (plum)
#easystroke & # commented out (20200515)
# composite manager if needed (20200515)
# enabled again (20210111)  need for DeskDockServer (and maybe citrix?)
command -v picom && picom -bi .95 # -b =daemon, -i1 = inactive opacity disabled
# window management only if needed 
# could call .xinitrc from i3/config
(sleep 5; pgrep -af autokey.gtkui || /usr/bin/python -m autokey.gtkui) &

command -v left-track-mouse && $_
pgrep i3 || i3
