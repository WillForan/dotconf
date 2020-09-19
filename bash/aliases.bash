# generic 
alias l='ls -tlc --color=auto'
alias s='ssh -AY'
alias ls='ls --color=auto'
alias g='egrep --color=auto'
alias dt='sudo dmesg|tail'
alias v='vim'
alias t='tmux'
alias wh='which'
alias bn=basename
alias dn=dirname
alias x='xargs -r'
alias px='env_parallel -X -r'
# prefer: use pavucontrol config profile = hdmi
alias playhdmi='SDL_AUDIODRIVER="alsa" AUDIODEV="hw:0,3" ffplay'

# package managemnet
alias i='yay --noconfirm -S'
alias pq='yay --color auto -Ss'

# git - status short with no untracked
alias gs='git status -s -uno'

# functions
n() { ls -tlc $@|head;}
sp() { host=$1; shift; sshpass -f ~/passwd/ssh/$host ssh $host $@; }
# which directory - 20200919
wd() { [ $# -lt 1 ] && pwd || dirname $(which $1);}

ip_list_local(){
   ssh admin@192.168.1.1 "
     /sbin/arp -a|
     sed -n 's/.*\(192.168.1.[0-9]\+\).*/\1/p'|
     while read ip; do
        ping -W 1 -c 1 \$ip >/dev/null && echo \$ip;
     done"
}

# remote ssh
alias work="sshpass -f ~/passwd/ssh/p ssh -t p '~/private/sshpass-1.06/sshpass -f ~/passwd/m ssh -t m ssh -o StrictHostKeyChecking=no  -i /disk/mace2/scan_data/WPC-4951/id foranw@10.145.64.121'"
