#
# ~/.bashrc
#
# 20190822 - installed
#   # stow bash -t ~ -d ~/config/ # brings in too much. just want this file
#   ln -s ~/config/.bashrc ~/

export LANG="en_US.UTF-8"

# where is .bashrc actually stored?  probably $HOME/config/bash
_BASHCFGDIR=$(cd "$(dirname "$(readlink -f ~/.bashrc)")"; pwd)

SLOWSHELL=1 # load /etc/bashrc, perlbrew
[ -n "${SLOWSHELL}" ] && [ -r /etc/bashrc ] && . /etc/bashrc


# 20230519 - guix sd
#export GUIX_PROFILE="$HOME/.guix-profile"
#test -r "$GUIX_PROFILE/etc/profile" && source "$_"
# 20240209; 20240319 updated again
#GUIX_PROFILE="/home/foranw/.config/guix/current"
#if [ -e $GUIX_PROFILE ]; then
#  . "$GUIX_PROFILE/etc/profile"
#  export PATH="$HOME/.guix-profile//bin:$PATH"
#fi

# 20240524 - on reese emacs 30 from source
[ -d $HOME/src/utils/emacs/src/ ] && PATH="$HOME/src/utils/emacs/src/:$PATH"



# where to find binaires outside of package manager
# includes local python (pyenv), perl (cpanm), ~/bin, ~/.local/bin
. "$_BASHCFGDIR/paths.bash"

# where to get music from
test -r "$HOME/passwd/config/mpd_host" && export MPD_HOST=$(cat "$_")


# If not running interactively, be done -- only handle paths
# need that to source additional settings
[[ $- != *i* ]] && export PS1="$ " && return



# autojump aliases: z a sd sf d f
# N.B. 's' alias overwritten to 'ssh' later
# 20231028 - cache fasd. it's half the laod time of interactive bash!
command -v fasd >& /dev/null && {
   FASD_SRC="${XDG_CACHE_DIR:-$HOME/.cache}/fasd.$(basename "$SHELL")"
   # bash specific. 'fasd --init auto' runs another interal eval
   test -r "$FASD_SRC" || fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install > "$FASD_SRC"
   source "$FASD_SRC"
}

# get aliases after fasd (rewrite s to ssh insead of fasd)
. $_BASHCFGDIR/aliases.bash

# . $_BASHCFGDIR/xsh

## internet search via surfraw
# also see alias for enabling sixel imagse and line number
export BROWSER=w3m

## bash settings
HISTSIZE=10000
shopt -s histappend
shopt -s cmdhist    # multi-line command written as one line in history file

# GNU parallel
command -v env_parallel >/dev/null && source $(which env_parallel.bash)

test -d /opt/ni_tools/lncdtools && export PATH="$PATH:$_"

# 20231026  - julia doesn't want to be packaged. use their own dl on reese
test -d /opt/ni_tools/julia-1.9.3/bin &&
   export PATH="/opt/ni_tools/julia-1.9.3/bin:$PATH"


# set up tab completion for AFNI programs
if [ -f $HOME/.afni/help/all_progs.COMP.bash ]
then
   . $HOME/.afni/help/all_progs.COMP.bash
fi
export AFNI_FONTSIZE=MINUS

export XDG_RUNTIME_DIR='/run/user/1000'

# curl -L https://install.perlbrew.pl | bash
# 20231105 - slow. only use when slowshell
test -n "${SLOWSHELL:-}" -a -r "$HOME/perl5/perlbrew/etc/bashrc"  &&
   . "$_"

# freesurfer setup
setup_freesurfer(){
 export FREESURFER_HOME=/opt/ni_tools/freesurfer
 source $FREESURFER_HOME/SetUpFreeSurfer.sh
}

test -d "$HOME/.cargo/bin" && export PATH="$_:$PATH"
test -e "$HOME/.cargo/env" && . "$_" || :

# quantify time usage/tracking
test -r /opt/ni_tools/bash-wakatime/bash-wakatime.sh && . $_
test -r /usr/share/bash-wakatime/bash-wakatime.sh && source "$_"

test -r "$HOME/.config/tea/autocomplete.sh" &&
   PROG=tea source "$_" || :

test -r /usr/share/bash-completion/completions/git-bug && source "$_"

# Automatically added by the Guix install script.
if [ -n "$GUIX_ENVIRONMENT" ]; then
    if [[ $PS1 =~ (.*)"\\$" ]]; then
        PS1="${BASH_REMATCH[1]} [env]\\\$ "
    fi
fi

### term setup
# 20231028 - moved to bottom b/c PS1 xterm prompt trap runs on all commands!
# kitty terminal
#command -v kitty >/dev/null &&
#   source <(kitty + complete setup bash)

# if emacs, set term. but dont set bindings
# 20240917 - EAT handles normal terminal stuff just fine
if [ -n "$INSIDE_EMACS" -a -z "$EAT_SHELL_INTEGRATION_DIR" ]; then
    export TERM=eterm-color \
           EDITOR='emacsclient -n'
    alias pass='EDITOR=emacsclient pass'
    PS1="\t \w\n\$ "
elif [ "$TERM" == "dumb" ]; then
    export PS1="$ "
else
    # fzf keys
    #  CTRL-R - Paste the selected command from history into the command line
    #  ALT-C - cd into the selected directory
    test -r /usr/share/fzf/key-bindings.bash && source $_
    # debian
    test -r /usr/share/doc/fzf/examples/key-bindings.bash && source $_

    # history expand with space. !![space] ^tyop^typo[space]
    #bind Space:magic-space

    # change color scheme using uses 'dynamic-colors-git'
    #bind -x '"\el":"dynamic-colors cycle"'
    bind -x '"\el":"dynamic-colors fuzzyall"'

    # ctrl-r for alt-. using \ea or ^x^a
    source "$HOME/src/utils/fuzzy_arg/fuzzy_arg.bash"
    #  \en for new file list
    source "$HOME/src/utils/fuzzy_arg/fuzzy_new_complete.bash"

    # gitmoji
    _bash_insert() { perl -le 'ioctl(STDIN,0x5412,$_) for split "", join " ", @ARGV' -- "$@";}
    gitmoji_bash() { _bash_insert "$(gitmoji-select echo)"; }
    bind -x '"\eG":"gitmoji_bash"'

    [ -n "$DISPLAY" ] && xset b off # no system bell if running X

    # autopair eating spaces
    if ! [[ $HOSTNAME =~ reese ]]; then
       export BASH_AUTOPAIR_BACKSPACE=1 # sideffect: disables bind-tty-special-chars
       test -r "$HOME/src/utils/bash-autopairs/autopairs.sh" && source "$_"
    fi

    # 20231105 autin - sqlite3 based history
    # w/  204.9 ms … 244.4 ms (using bash-preexec) 20231211 blesh very slow
    # w/o 187.9 ms … 237.1 ms
    command -v atuin >/dev/null && {
      [[ -f /usr/share/bash-preexec/bash-preexec.sh ]] && source /usr/share/bash-preexec/bash-preexec.sh
      #[[ -f /usr/share/blesh/ble.sh ]] && source /usr/share/blesh/ble.sh
      [[ -f "$_BASHCFGDIR/atuin.init.sh" ]] || atuin init bash > "$_"
      # NB. local changes make C-r not full screen and remove atuin 'up' binding
      source "$_BASHCFGDIR/atuin.init.sh"

      # fzf still nice to have around
      bind -m emacs-standard '"\e\C-r": "\C-e \C-u\C-y\ey\C-u`__fzf_history__`\e\C-e\er"'
    }

    # last to avoid DEBUG TRAP performance penelty for every command run
    . "$_BASHCFGDIR/PS1.bash"

    if [ -n "$EAT_SHELL_INTEGRATION_DIR" ]; then
       : source "$EAT_SHELL_INTEGRATION_DIR/bash"
       EDITOR='emacsclient -n'
    fi
fi
