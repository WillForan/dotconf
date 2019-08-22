# generic 
alias l='ls -tlc --color=auto'
alias s='ssh'
alias ls='ls --color=auto'
alias g='egrep --color=auto'
alias dt='sudo dmesg|tail'

# package managemnet
alias i='yay --noconfirm -S'
alias q='yay -Ss'

# functions
n() { ls -tlc $@|head;}
sp() { sshpass -f ~/passwd/ssh/$1 ssh $1; }
