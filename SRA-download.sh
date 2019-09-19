sra-download.sh

>> There are Three Tools: aspera，wget，The SRA Toolkit

#方法一 aspera 

#下载
wget http://download.asperasoft.com/download/sw/connect/3.7.4/aspera-connect-3.7.4.147727-linux-64.tar.gz
 
tar zxvf aspera-connect-3.7.4.147727-linux-64.tar.gz
 
# 安装
bash aspera-connect-3.7.4.147727-linux-64.sh
 
# 查看是否有.aspera文件夹
cd # 去根目录
ls -a # 如果看到.aspera文件夹，代表安装成功
 
# 永久添加环境变量
echo 'export PATH=~/.aspera/connect/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
 
# 查看帮助文档
ascp --help


https://sra-download.ncbi.nlm.nih.gov/sos/sra-pub-run-1/SRR306434/SRR306434.3

#使用 eg.地址不可用，因为属于云储存
ascp -v -i ~/.aspera/connect/etc/asperaweb_id_dsa.openssh -k 1 -T -l200m anonftp@ftp-private.ncbi.nlm.nih.gov:/sos/sra-pub-run-1/SRR306434/SRR306434.3 /lustre/huxi/test/data_01/

#方法二 wget
wget http://

#方法三 The SRA Toolkit
#download
wget -P ~/install/ https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.9.6/sratoolkit.2.9.6-ubuntu64.tar.gz

tar zvxf ~/install/sratoolkit.2.9.6-ubuntu64.tar.gz -C ~/install

#add $PATH in .bash_profile
echo 'export PATH=~/install/sratoolkit.2.9.6-ubuntu64/bin:$PATH'  >> ~/.bash_profile
source ~/.bash_profile

#prefetch 注：download file will put in this auto-generation path like "~/ncbi/public/sra/" 
prefetch {sra NO.xxxx}

