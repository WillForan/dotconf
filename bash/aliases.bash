# generic 
alias l='ls -tlc --color=auto'
alias s='ssh -AY'
alias ls='ls --color=auto'
alias g='egrep --color=auto'
alias dt='sudo dmesg|tail'
alias playhdmi='SDL_AUDIODRIVER="alsa" AUDIODEV="hw:0,3" ffplay'

# package managemnet
alias i='yay --noconfirm -S'
alias q='yay --color auto -Ss'

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
alias work="sshpass -f ~/passwd/ssh/p ssh -t p '~/private/sshpass-1.06/sshpass -f ~/passwd/m ssh -t m ssh -o StrictHostKeyChecking=no foranw@10.145.64.121'"
# 

