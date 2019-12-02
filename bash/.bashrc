#
# ~/.bashrc
#
# 20190822 - installed
#   # stow bash -t ~ -d ~/config/ # brings in too much. just want this file
#   ln -s ~/config/.bashrc ~/

# where is .bashrc actually stored?  probably $HOME/config/bash
_BASHCFGDIR=$(cd $(dirname $(readlink -f ~/.bashrc)); pwd)

# where to find binaires outside of package manager
# includes local python (pyenv), perl (cpanm), ~/bin, ~/.local/bin
. $_BASHCFGDIR/paths.bash


# If not running interactively, be done -- only handle paths
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

# need that to source additional settings
. $_BASHCFGDIR/PS1.bash
. $_BASHCFGDIR/aliases.bash

## bash settings
[ -n "$DISPLAY" ] && xset b off # no system bell if running X
HISTSIZE=10000
shopt -s histappend
shopt -s cmdhist    # multi-line command written as one line in history file
