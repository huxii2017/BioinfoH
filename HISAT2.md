# HISAT2 使用指南

准备例如某个物种1的参考基因组文件共有以下几种：
全基因组fasta文件——1.fa
全基因组注释文件——1.gff3

备注：gff3转化成gtf格式文件的方法：
``` gffread -T -o 1.gtf 1.gff3```

## step1 建立index

```hisat2_extract_exons.py 1.gtf > 1.exons
#调用脚本hisat_extract_exons.py,创建exons比对源

hisat2_extract_splice_sites.py 1.gtf > 1.ss
#调用脚本hisat2_extract_splice_sites.py，创建splice比对源

hisat2-build -p 4 1.fa --ss 1.ss --exon 1.exons Index_name
#建立索引（注意各文件及索引路径）

```
## step2 mapping（output file.sam）
如果有多个文件需要处理，可以将mapping的命令批量写在一个.txt或者.sh文件中，然后用scrren后台挂起运行，例如有4个单端测序的fastaq文件需要mapping：
``` vi hisat2.sh 
#新建并打开一个shell文本编辑器,按a建进入insert编辑模式，写入以下命令：
hisat2 -x Index_name -U 1.fastq -S 1.sam 2>log
hisat2 -x Index_name -U 2.fastq -S 2.sam 2>log
hisat2 -x Index_name -U 3.fastq -S 3.sam 2>log
hisat2 -x Index_name -U 4.fastq -S 4.sam 2>log
#然后先按esc退出insert模式，输入：wq，保存并离开hisat2.sh 

screen -S hisat2 #新建一个名字为hisat2的窗口
parallel -j 8 < hisat2.sh #平行运行8行命令，开始运行，然后按下control+a+d，暂时退出当前窗口
screen -ls #查看进程是否attach
screen -r hisat2 #恢复hisat2运行状态
top或者htop #查看进程是否开始运行
```



## step3 sam to bam

```samtools sort -O bam -@ 5 -o file.bam file.sam
#此处是将sam格式的文件进行转换，实质是进行一定程度的压缩，是文件变小
```


