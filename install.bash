#!/usr/bin/env bash

#
# install dot files and configs.
#   * pull git dependencies if not already there
#   * use stow or ln (.bashrc) to link up configurations
#
# safe to rerun
#   * stow will error out instead of overwrite.
#   * git will skip if folder exists


set -euo pipefail
trap 'e=$?; [ $e -ne 0 ] && echo "$0 exited in error"' EXIT
cd $(dirname $0)
CFGDIR=$(pwd)
! test -d $HOME/bin  && mkdir $_

#
# 20190822WF - init
# 20210123   - add dryrun
# 20210625   - use upbin, add autokey-gtk to syspkg
#

[ -n "${DRYRUN:-}" ] && DRYRUN=echo || DRYRUN=

# wf-utils used by i3 and xbindkeys
# fuzzy_arg used by bashrc
# plum used in xbindkeys
UTILDIR=$HOME/src/utils
[ ! -d $UTILDIR ] && mkdir -p $UTILDIR
for gitpkg in wf-utils fuzzy_arg plum; do
   [ ! -d "$UTILDIR/$gitpkg" ] && git clone https://github.com/WillForan/$gitpkg $UTILDIR/$gitpkg
done

if [ -r /etc/arch-release ] && ! command -v yay >/dev/null; then
  yay_ver=10.2.3 # 20210614
  curl -L https://github.com/Jguer/yay/releases/download/v$yay_ver/yay_${yay_ver}_x86_64.tar.gz > yay.tar.gz
  tar -xzvf yay.tar.gz
  mv yay*/yay $HOME/bin
  rm -r yay*/ yay.tar.gz
fi

# check for needed system packages
SYSPKGS=(fasd fzf rofi easystroke xbindkeys i3 xdotool dynamic-colors stow sshpass syncthing autokey-gtk)
# pip install keepmenu
# also want libinput-guesture and manager if have a touchpad. NB. probably need to install xorg-xinput
command -v xinput && xinput list | grep -qi touchpad && SYSPKG+=("libinput-gestures")
for syspkg in ${SYSPKGS}; do
   command -v $syspkg >/dev/null && continue
   echo "missing system package '$syspkg'. use the package manager to get it (yay -S $syspkg || apt install $syspkg)" 
   exit 1
done

# run upbin $PKG for each package
for d in $CFGDIR/*/; do
   pkg=$(basename $d)
   $DRYRUN $CFGDIR/bin/upbin $pkg
done
