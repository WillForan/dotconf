#
# ~/.bashrc
#
# 20190822 - installed
#   # stow bash -t ~ -d ~/config/ # brings in too much. just want this file
#   ln -s ~/config/.bashrc ~/

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# extra binaries
export PATH="$HOME/bin:$HOME/src/utils/plum:$PATH"

# ctrl-r for alt-. using \ea or ^x^a
source $HOME/src/utils/fuzzy_arg/fuzzy_arg.bash
#  \en for new file list
source $HOME/src/utils/fuzzy_arg/fuzzy_new_complete.bash

# autojump aliases: z a sd sf d f
# N.B. 's' alias overwritten to 'ssh' later
eval "$(fasd --init auto)"

# where is .bashrc actually stored?  probably $HOME/config/bash
# need that to source additional settings
_BASHCFGDIR=$(cd $(dirname $(readlink -f ~/.bashrc)); pwd)
. $_BASHCFGDIR/PS1.bash
. $_BASHCFGDIR/aliases.bash

