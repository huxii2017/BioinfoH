# BioinfoH
Learn a little bit of knowledge every day, improve every day

### 建立软连接 $ln -s {source file} {aim file} eg.  

``` 
ln -s /lustre/huxi ~ 

```
* 删除软连接
```
cd ~
rm huxi
```

### 设置文件夹权限 $chmod abc {files}  

a=user b=group c=other
rwx:read=4,write=2,eXecute=1 eg.
``` 
chmod 744 /lustre/huxi 
```

### 删除空文件(./) 
```
find . -name "*" -type f -size 0c | xargs -n 1 rm -f
```

### 删除空文件夹
```
find -type d -empty | xargs -n 1 rm -rf
```

### .bash_profile or .bashrc  

``` 
vim .bash_profile 
alias simple_cmd=“comlex_cmd” 
```

#
