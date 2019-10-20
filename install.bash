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

#
# 20190822WF - init
#

# wf-utils used by i3 and xbindkeys
# fuzzy_arg used by bashrc
# plum used in xbindkeys
UTILDIR=$HOME/src/utils
[ ! -d $UTILDIR ] && mkdir -p $UTILDIR
for gitpkg in wf-utils fuzzy_arg plum; do
   [ ! -d "$UTILDIR/$gitpkg" ] && git clone https://github.com/WillForan/$gitpkg $UTILDIR/$gitpkg
done

# check for needed system packages
SYSPKGS=(fasd fzf rofi easystroke xbindkeys i3 xdotool dynamic-colors passhole)
for syspkg in ${SYSPKGS}; do
   command -v $syspkg >/dev/null && continue
   echo "missing system package '$syspkg'. use the package manager to get it (pacman -S $syspkg || apt install $syspkg)" 
   exit 1
done

# just want bashrc, not the other source files
[ ! -h ~/.bashrc ] && ln -s $CFGDIR/bash/.bashrc ~/.bashrc

# for all packages (not */ because bash, maybe others soon)
for pkg in vim xbindkeys x11 R i3 easystroke; do
   stow $pkg -t ~ -d ~/config/
done

# system config. need sudo/root
stow dynamic-colors -t /usr/share/dynamic-colors/ -d ~/config/

stow emacs -t ~/.emacs.d/
stow bin -t ~/bin/


