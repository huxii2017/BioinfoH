Bismark.sh

# test file: /lustre/huxi/test/02_bismark/test_data.fastq

#00 Build index[preparation]

bismark_genome_preparation --bowtie2 --verbose /lustre/huxi/reference_genome/hg19/ > log

mv /lustre/huxi/reference_genome/hg19/Bisulfite_Genome/ /lustre/huxi/index/bismark/
cp /lustre/huxi/reference_genome/hg19/hg19.fa /lustre/huxi/index/bismark/


#01 Alignment [single end]
# official usage
bismark --genome /lustre/huxi/index/bismark/ /lustre/huxi/test/02_bismark/test_data.fastq
# bowtie2 default[options] : -L 20 -N 0 output:bam
# learn from [liull]'s pipline
mkdir /lustre/huxi/test/02_bismark/01_Alignment
bismark --bowtie2 -N 0 -L 20 --quiet --un --ambiguous --sam \
 -o /lustre/huxi/test/02_bismark/01_Alignment \
 /lustre/huxi/index/bismark/ \
 /lustre/huxi/test/02_bismark/test_data.fastq

#-N 0 在比对的时候允许0个错误
#-L 20 在比对的时候建立的seed的大小是20
#--quiet 不输出在比对的时候的比对流程
#--ambiguous 如果有一个序列匹配到了多个位置，则会保存在 xxxx_ambiguous_reads.fq.gz
#--un 多处匹配的reads信息不写入输出的fq中
#--sam 输出的格式为sam

#02 Deduplicate_bismark 
deduplicate_bismark -s /lustre/huxi/test/02_bismark/01_Alignment/test_data_bismark_bt2.sam \
--sam --output_dir /lustre/huxi/test/02_bismark/02_deduplicate/
# -s single end
# -p pair end
# --sam outputfile

#03 bismark_methylation_extractor 
lustre/home/huxi/install/bismark_v0.22.1/bismark_methylation_extractor \
    -s \
    --comprehensive \
    --bedGraph \
    --counts \
    --buffer_size 20G \
    --report \
    --cytosine_report \
    --genome_folder /lustre/huxi/index/bismark/ \
    /lustre/huxi/test/02_bismark/02_deduplicate/test_data_bismark_bt2.deduplicated.sam \
    -o /lustre/huxi/test/02_bismark/03_bismark_methylation_extractor/ \
    

#lustre/home/huxi/install/bismark_v0.22.1/bismark_methylation_extractor 写入脚本需要软件的绝对路径【针对集群非root用户的免安装自启动软件包】
#-p : 输入的文件是pair-end
#--comprehensive 将可能的甲基化信息都输出，包括CHG,CHH,CpG
#--no_overlap：对于双端读取，read_1和read_2理论上是可能重叠的。这个选项避免了重复的甲基化计算了2次。虽然这消除了对序列片段中心更多甲基化的计算偏差。
#--bedGraph:输出bedGraph文件
#--cytosine_report：指报道全基因组所有的CpG。
#--counts:指在bedGraph中有每个C上甲基化reads和非甲基化reads的数目(在--cytosine_report指定的情况下。)
#--buffer_size 指定的内存去计算甲基化信息
#--report ：会有一个甲基化的summary
#--genome_folder:后跟着参考基因组的位置
#-o:输出的文件路径

#04 bismark2report
cd /lustre/huxi/test/02_bismark/03_bismark_methylation_extractor/
bismark2report --alignment_report test_data_bismark_bt2.deduplicated.CpG_report.txt --dir ../

#05 unix_sort
