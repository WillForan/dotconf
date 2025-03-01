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
[ ! -d "$UTILDIR" ] && mkdir -p "$UTILDIR"
for gitpkg in wf-utils fuzzy_arg plum dynamic-colors; do
   [ ! -d "$UTILDIR/$gitpkg" ] && git clone https://github.com/WillForan/$gitpkg $UTILDIR/$gitpkg
done

# bash "plugin" to insert matching "')} sourced by bashrc
test -d "$UTILDIR/bash-autopairs" ||
   git clone https://github.com/nkakouros-original/bash-autopairs "$_"

if [ -r /etc/arch-release ] && ! command -v yay >/dev/null; then
  #yay_ver=10.2.3 # 20210614
  #yay_ver=12.3.5 # 20240404 
  #yay_ver=12.4.1 # 20240918
  yay_ver="$(curl -s https://aur.archlinux.org/packages/yay |grep -Po '(?<=yay )[0-9.]{4,}')"
  curl -L "https://github.com/Jguer/yay/releases/download/v$yay_ver/yay_${yay_ver}_x86_64.tar.gz" > yay.tar.gz
  tar -xzvf yay.tar.gz
  mv yay*/yay "$HOME/bin"
  rm -r yay*/ yay.tar.gz
  export PATH="$HOME/bin:$PATH"
fi

# check for needed system packages
SYSPKGS=(fasd fzf rofi easystroke xbindkeys i3 xdotool dynamic-colors stow sshpass syncthing autokey-gtk ripgrep  inetutils) # silver-searcher-git
# pip install keepmenu
# also want libinput-guesture and manager if have a touchpad. NB. probably need to install xorg-xinput
#      xinput wont run if no X11 instance
command -v xinput && xinput list | grep -qi touchpad && SYSPKG+=("libinput-gestures")
for syspkg in "${SYSPKGS[@]}"; do
   # 20211002 inetutils for hostname, silver-searcher-git for ag
   case $syspkg in silver-searcher-git) testcmd=ag;; inetutils) testcmd=hostname;; *) testcmd=$syspkg;; esac

   echo "# $syspkg"
   command -v $testcmd >/dev/null && continue
   if [ -r /etc/arch-release ]; then
	   ~/bin/yay -S $syspkg --noconfirm
	   continue
   elif [ -r /etc/debian_version ]; then
      [[ $syspkg =~ easystroke ]] && continue
      [[ $syspkg =~ silver-searcher ]] && syspkg=silversearcher-ag
      sudo apt-get -y install $syspkg
      continue
   elif command -v guix >/dev/null; then # || grep -q guix /etc/os-release 2>/dev/null; then
      [[ $syspkg =~ easystroke|autokey-gtk|dynamic-colors ]] && continue
      [[ $syspkg =~ silver-searcher ]] && syspkg=the-silver-searcher
      guix install $syspkg
   else
      echo "missing system package '$syspkg'. use the package manager to get it (yay -S $syspkg || apt install $syspkg)"
      exit 1
   fi
done

# run upbin $PKG for each package
for d in $CFGDIR/*/; do
   pkg=$(basename $d)
   [[ $pkg = app.desktop ]] && continue
   $DRYRUN $CFGDIR/bin/upbin $pkg
done
