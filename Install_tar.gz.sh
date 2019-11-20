install_tar.gz.sh

#eg. screen

#step1.download in ~/install/
wget http://ftp.gnu.org/gnu/screen/screen-4.6.2.tar.gz

#step2.decompress
tar zxvf screen-4.6.2.tar.gz

#step3.
cd screen-4.6.2/

#step4.
pwd #check absolute directory
my_path=/path/to/my_path
./configure --prefix=$my_path

#step5.
make

#step6.
make install

#step7. add a PATH to {~/.bash_profile} 
export PATH=$my_path/bin:$PATH
## add config--Screen prompt
if [ "$TERM" == "screen" ] ; then
    PROMPT_COMMAND='echo -ne  "\033k`uname -n`\033\\"'
fi

#step8. source
source ~/.bash_profile

#step9. .screenrc
touch ~/.screenrc
## vim & insert follows context
#### use .bashrc in screen
shell -$SHELL
# ------------------------------------------------------------------------------
# SCREEN SETTINGS
# ------------------------------------------------------------------------------

startup_message off
#nethack on

#defflow on # will force screen to process ^S/^Q
deflogin on
autodetach on

# turn visual bell on
vbell off
vbell_msg "   Wuff  ----  Wuff!!  "

# define a bigger scrollback, default is 100 lines
scrollback 11024
defscrollback 11024

# ------------------------------------------------------------------------------
# SCREEN KEYBINDINGS
# ------------------------------------------------------------------------------

# Remove some stupid / dangerous key bindings
bind ^k
#bind L
bind ^\
# Make them better
bind \\ quit
bind K kill
bind I login on
bind O login off
bind } history

# ------------------------------------------------------------------------------
# TERMINAL SETTINGS
# ------------------------------------------------------------------------------

# The vt100 description does not mention "dl". *sigh*
termcapinfo vt100 dl=5\E[M

# turn sending of screen messages to hardstatus off
hardstatus on
# Set the hardstatus prop on gui terms to set the titlebar/icon title
termcapinfo xterm*|rxvt*|kterm*|Eterm* hs:ts=\E]0;:fs=\007:ds=\E]0;\007
# use this for the hard status string
hardstatus string "%h%? users: %u%?"
#状态栏
hardstatus alwayslastline "%{=b}%{b}%-w%{.BW}%10>%n*%t%{-}%+w%< %=%{kG}%C%A , %Y-%m-%d"
#标题栏

