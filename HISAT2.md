# HISAT2 使用指南
备注：gff3转化成gtf格式文件的方法：
``` gffread -T -o 1.gtf 1.gff3```

## step1 建立index
```hisat2_extract_exons.py 1.gtf > 1.exons
#调用脚本hisat_extract_exons.py,转化文件格式
hisat2_extract_splice_sites.py 1.gtf > 1.ss
#调用脚本hisat2_extract_splice_sites.py
hisat2-build -p 4 0.fa --ss 1.ss --exon 1.exons Index_name
#建立索引
```
## step2 mapping

