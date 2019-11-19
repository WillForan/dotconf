#
# ~/.bashrc
#
# 20190822 - installed
#   # stow bash -t ~ -d ~/config/ # brings in too much. just want this file
#   ln -s ~/config/.bashrc ~/

# extra binaries
export PATH="$HOME/bin:$HOME/src/utils/plum:$PATH"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# ctrl-r for alt-. using \ea or ^x^a
source $HOME/src/utils/fuzzy_arg/fuzzy_arg.bash
#  \en for new file list
source $HOME/src/utils/fuzzy_arg/fuzzy_new_complete.bash

# fzf keys
#  CTRL-R - Paste the selected command from history into the command line
#  ALT-C - cd into the selected directory
. /usr/share/fzf/key-bindings.bash

# autojump aliases: z a sd sf d f
# N.B. 's' alias overwritten to 'ssh' later
eval "$(fasd --init auto)"

# change color scheme using uses 'dynamic-colors-git'
bind -x '"\el":"dynamic-colors cycle"'

# where is .bashrc actually stored?  probably $HOME/config/bash
# need that to source additional settings
_BASHCFGDIR=$(cd $(dirname $(readlink -f ~/.bashrc)); pwd)
. $_BASHCFGDIR/PS1.bash
. $_BASHCFGDIR/aliases.bash

## bash settings
[ -n "$DISPLAY" ] && xset b off # no system bell if running X
HISTSIZE=10000
shopt -s histappend
shopt -s cmdhist    # multi-line command written as one line in history file

# perl
#cpanm --local-lib=~/perl5 local::lib &&
eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
