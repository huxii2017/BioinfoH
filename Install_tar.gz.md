install_tar.gz.sh

#eg. screen

#step1.download in ~/install/
wget http://ftp.gnu.org/gnu/screen/screen-4.6.2.tar.gz

#step2.decompress
tar zxvf screen-4.6.2.tar.gz

#step3.
cd screen-4.6.2/

#step4.
./configure --prefix=`pwd`

#step5.
make

#step6.
make install

#step7.add a PATH to ~/.bash_profile
export PATH=~/install/screen-4.6.2:$PATH

#step8. source
source ~/.bash_profile
