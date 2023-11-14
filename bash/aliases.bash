# generic 
alias l='ls -tlc --color=auto'
alias s='ssh -AY'
alias m="mosh"
alias ls='ls --color=auto'
alias g='grep -P --color=auto'
alias G='git'
alias dt='sudo dmesg|tail'
alias v='vim'
alias t='tmux -u -2'
alias wh='which'
alias bn="basename"
alias dn="dirname"
alias x='xargs -r'
alias px='env_parallel -X -r'
alias feh='feh --keep-zoom-vp -. -Z --zoom full'
# prefer: use pavucontrol config profile = hdmi
alias playhdmi='SDL_AUDIODRIVER="alsa" AUDIODEV="hw:0,3" ffplay'

# inside emacs open new file # 20210401
alias en="emacsclient -n"
# 20230809
alias rslack="ssh h -t tmux -2u a -t work"

# browse with images
alias w3m='w3m -sixel -o display_image=1 -o display_link_number=1'
alias w3g='surfraw google'
# https://search.marginalia.nu/search?query=w3m
alias w3sm='surfraw marginalia'

# play music not cover art
alias mpv="mpv --no-audio-display"

# readline wrapper around lisp (20210526)
alias sbcl="rlwrap sbcl"

# package managemnet
if command -v yay >/dev/null; then
  alias i='yay --noconfirm -S'
  alias pq='yay --color auto -Ss'
elif command -v apt >/dev/null; then 
  alias i='sudo apt install'
  alias pq='apt search'
fi

# git - status short with no untracked. gs is ghostscript
alias gsuno='git status -s -uno'

# calendar
alias cala='gcalcli  --calendar "Meetings" --calendar "Will Foran" --calendar "LNCD Journal Club" --calendar "fun! run! climb!" agenda'
alias calq='gcalcli --calendar "Will Foran" quick'

# system
alias zzz='sudo systemctl suspend'

# functions
n() { ls -tlc $@|head;}
sp() { host=$1; shift; sshpass -f ~/passwd/ssh/$host ssh $host $@; }
# which directory - 20200919
wd() { [ $# -lt 1 ] && pwd || dirname $(which $1);}
# 20231021 - gcm moved to own script

# 20210421 - cd to a file.
# doesnt work on symlinks (no easy way to tell if its a file or dir
c() { [ $# -gt 0 -a -f "$1" ] && cd "$(dirname "$1")" || cd "$1"; }
cdx() {
   local d
   [ $# -eq 0 ] && d="$HOME" || d="$1"
   [ $d = "-" ] && cd - && return
   [ ! -r "$1" ] && mkdir -p "$1"
   cd "$1"
}

ip_list_local(){
   ssh admin@192.168.1.1 "
     /sbin/arp -a|
     sed -n 's/.*\(192.168.1.[0-9]\+\).*/\1/p'|
     while read ip; do
        ping -W 1 -c 1 \$ip >/dev/null && echo \$ip;
     done"
}
ew3m(){ emacsclient -c -n -e "(w3m-goto-url \"$1\")"; }
alias ed='rlwrap -Ac /usr/bin/ed -v -p"$(tput setaf 12)*$(tput sgr0) "'

