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
  curl -L https://github.com/Jguer/yay/releases/download/v9.4.2/yay_9.4.2_x86_64.tar.gz > yay.tar.gz
  tar -xzvf yay.tar.gz
  mv yay*/yay $HOME/bin
  rm -r yay*/ yay.tar.gz
fi

# check for needed system packages
SYSPKGS=(fasd fzf rofi easystroke xbindkeys i3 xdotool dynamic-colors passhole stow sshpass syncthing)
# also want libinput-guesture and manager if have a touchpad. NB. probably need to install xorg-xinput
command -v xinput && xinput list | grep -qi touchpad && SYSPKG+=("libinput-gestures")
for syspkg in ${SYSPKGS}; do
   command -v $syspkg >/dev/null && continue
   echo "missing system package '$syspkg'. use the package manager to get it (yay -S $syspkg || apt install $syspkg)" 
   exit 1
done

# TODO: run upbin $PKG for each package

# just want bashrc, not the other source files
[ ! -h ~/.bashrc ] && ln -s $CFGDIR/bash/.bashrc ~/.bashrc

# for all packages (not */ because bash, maybe others soon)
for pkg in vim xbindkeys x11 R i3 easystroke mail; do
   $DRYRUN stow $pkg -t ~ -d ~/config/
done

$DRYRUN stow emacs -t ~/.emacs.d/
$DRYRUN stow bin -t ~/bin/
$DRYRUN stow libinput-gestures/ -t ~/.config
$DRYRUN stow greenclip/ -t ~/.config

# system config. need sudo/root
$DRYRUN sudo stow dynamic-colors -t /usr/share/dynamic-colors/ -d ~/config/


