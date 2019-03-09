# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

#set about cmd_ll
alias ls='ls -hla'

#set about teminal_color
PS1="\[\e[32m\][\u\[\e[36m\]@\[\e[32m\]\h \W\[\e[32m\]]\\$\[\e[0m\] \[\e[31m\]\d \[\e[33m\]\t
\[\e[31m\]\w
\\$\[\e[0m\]"
