# generic 
alias l='ls -tlc --color=auto'
alias s='ssh -AY'
alias ls='ls --color=auto'
alias g='egrep --color=auto'
alias dt='sudo dmesg|tail'
alias v='vim'

# package managemnet
alias i='yay --noconfirm -S'
alias q='yay -Ss'

# functions
n() { ls -tlc $@|head;}
sp() { sshpass -f ~/passwd/ssh/$1 ssh $1; }

localips(){
   ssh admin@192.168.1.1 "
     /sbin/arp -a|
     sed -n 's/.*\(192.168.1.[0-9]\+\).*/\1/p'|
     while read ip; do
        ping -W 1 -c 1 \$ip >/dev/null && echo \$ip;
     done"
}
