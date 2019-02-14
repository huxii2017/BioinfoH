# bowtie 短序列比对工具详解

常见的短序列比对工具有很多，如fasta、blast、bowtie、shrimp、soap等。每个工具都有其自身的优点，但同时也具备了一些缺点。权衡利弊，我选择bowtie作为主要的短序列比对工具。它速度很快，比对结果也容易理解。
现在举个例子来探讨bowtie的使用方法：现在有GENOME.fa、高通量测序数据Reads.fa，我们希望将Reads.fa比对到基因组GENOME.fa上。
## (一）、对Reference文件(GENOME.fa)建库

> bowtie-build GENOME.fa GENOME.fa

建库步骤可能需要1h甚至几个小时，建议在后台执行：
nohup bowtie-build GENOME.fa GENOME.fa &
## (二）、将Reads.fa比对到GENOME.fa上，只能比对到正链，且匹配到基因组不多于20个不同位置，允许有1个错配（参数见下）

> bowtie -f -a -m 20 -v 1 --al Reads_aligned --un Reads_unaligned --norc GENOME.fa Reads.fa Reads.bwt 2> log

注：
-f 指定query文件为fasta格式
-a 保留所有比对结果
-m 指定最大比对到基因组的次数
-v 允许最大错配数，为[0-2]
--al 能map到GENOME的reads，fasta格式
--un 不能map到GENOME的reads，fasta格式
--norc 不输出匹配到负链的结果；如果不想输出比对到正链的结果，则用"--nofw"。不指定该选项则正负链结果都输出
后面依次写上GENOME索引文件，Reads文件，输出结果文件Reads.bwt，日志文件log。
--best、--strata参考 https://www.plob.org/article/932.html
## (三）、bowtie输出结果的说明

> sample001_x75 + Chr1 12453 ATCGGCCAATTACGGACTTAA IIIIIIIIIIIIIIIIIIIII 4 9:G>T
    1           2  3      4            5                6                  7   8

1. query id
2. "+"表示正向match；"-"表示对query作反向互补后match
3. reference id
4. 第2列为"+"时，表示query 第一个碱基map到reference(5'->3')上的位置，0-based(以0开始)；第2列为"-"时，表示query的反向互补序列第一 个碱基map到reference(5'->3')上的位置，0-based(以0开始)
5. 如果第2列为"+"，则和query序列一致；否则，和query序列反向互补
6. 质量文件，如果query文件为fasta格式，则无法获取质量文件，用I代替，I的数量与query序列长度一致
7. 当前query能map到GENOME的4个不同位置
8. 如果存在第8列，表示有mismatch。第8列可以分为三个部分，最左端的数字，中间的碱基为reference碱基，最右端的碱基为query碱基，下面分情况讨论：
第2列为"+"时：最左端的数字9表示query从5'端数起，第10个碱基为"T"，而对应的reference为"G";
第2列为"-"时：最左端的数字9表示query先作反向互补，然后从3'端数起，第10个碱基为"T"，而对应的reference为"G";
 原文链接：http://blog.sina.com.cn/s/blog_4b91a9e50101mmqi.html

bowtie2 短序列比对工具详解

 

## 懒人必看

对参考序列构建index

bowtie2-build genome.fasta index

尝试使用前10000个reads进行比对

bowtie2 -u 10000 -p 8 -x index -1reads1.fq -2 reads2.fq -S out.sam

使用8个线程进行比对

bowtie2 -p 8 -x index -1 reads1.fq -2reads2.fq -S out.sam

比对的sam结果中添加了read group信息

bowtie2 -p 8 --rg-id sample01 --rg"PL:ILLUMINA" --rg "SM:sample01" -x index -1 reads1.fq -2reads2.fq -S out.sam

常用的参数进行比对，可以更改其中的参数获得更好的结果

bowtie2 -q --phred33 --sensitive--end-to-end -I 0 -X 500 --fr --un unpaired --al aligned --un-conc unconc --al-concalconc -p 6 --reorder -x <bt2-idx> {-1 <m1gt; -2 <m2> | -U<r>} -S [<hit>]

用法：

bowtie2 [options]* -x <bt2-idx> {-1<m1> -2 <m2> | -U <r>} -S [<hit>]

bowtie2-build用法

bowtie2-build默认情况下将fasta文件换成index的数据库。

bowtie2-build <fasta文件> <要生成的索引文件前缀名>

## 必须参数：

-x <bt2-idx>由bowtie2-build所生成的索引文件的前缀。首先 在当前目录搜寻，然后在环境变量BOWTIE2_INDEXES中制定的文件夹中搜寻。

-1 <m1>双末端测寻对应的文件1。可以为多个文件，并用逗号分开；多个文件必须和-2<m2>中制定的文件一一对应。比如:"-1flyA_1.fq,flyB_1.fq -2 flyA_2.fq,flyB

_2.fq".测序文件中的reads的长度可以不一样。

-2 <m2>双末端测寻对应的文件2.

-U <r>非双末端测寻对应的文件。可以为多个文件，并用逗号分开。测序文件中的reads的长度可以不一样。

-S <hit>所生成的SAM格式的文件前缀。默认是输入到标准输出。

以下是可选参数：

## 输入参数

-q输入的文件为FASTQ格式文件，此项为默认值。

-qseq输入的文件为QSEQ格式文件。

-f 输入的文件为FASTA格式文件。选择此项时，表示--ignore-quals也被选择了。

-r输入的文件中，每一行代表一条序列，没有序列名和测序质量等。选择此项时，表示--ignore-quals也被选择了。

-c后直接为比对的reads序列，而不是包含序列的文件名。序列间用逗号隔开。选择此项时，表示—ignore-quals也被选择了。

-s/--skip <int> input的reads中，跳过前<int>个reads或者pairs。

-u/--qupto <int>只比对前<int>个reads或者pairs（在跳过前<int>个reads或者pairs后）。Default: no limit.

-5/--trim5 <int>剪掉5'端<int>长度的碱基，再用于比对。(default:0).

-3/--trim3 <int>剪掉3'端<int>长度的碱基，再用于比对。(default:0).

--phred33输入的碱基质量等于ASCII码值加上33.在最近的illuminapipiline中得以运用。最低碱基质量是“#”。

--phred64输入的碱基质量等于ASCII码值加上64.最低碱基质量是“B”。

--solexa-quals将Solexa的碱基质量转换为Phred。在老的GAPipeline版本中得以运用。Default: off.

 --int-quals输入文件中的碱基质量为用“”分隔的数值，而不是ASCII码。比如40 4030 40...。Default: off.

 –end-to-end模式下的预设参数

--very-fast Same as: -D 5 -R 1 -N 0 -L 22-i S,0,2.50

--fast Same as: -D 10 -R 2 -N 0 -L 22 -iS,0,2.50

--sensitive Same as: -D 15 -R 2 -N 0 -L 22-i S,1,1.15 (default in --end-to-endmode)

--very-sensitive Same as: -D 20 -R 3 -N 0-L 20 -i S,1,0.50

–loca模式下的预设参数

--very-fast-local Same as: -D 5 -R 1 -N 0-L 25 -i S,1,2.00

--fast-local Same as: -D 10 -R 2 -N 0 -L 22-i S,1,1.75

--sensitive-local Same as: -D 15 -R 2 -N 0-L 20 -i S,1,0.75 (default in --local mode)

--very-sensitive-local Same as: -D 20 -R 3-N 0 -L 20 -i S,1,0.50

 ## 比对参数：

-N <int>进行种子比对时允许的mismatch数.可以设为0或者1.Default:0.

 

-L <int>设定种子的长度.

 

************************************************************

## 功能选项

给bowtie的一些参数设定值的时候，使用一个计算公式代替，于是值的大小与比对序列的长

度成一定关系。<func>有三部分组成: (a)计算方法,包括常数(C),线性(L),平方根(S)和

自然对数(G); (b)一个常数; (c)一个系数.

例如:

<func>为L,-0.4,-0.6则计算公式为: f(x)= -0.4 + -0.6 * x

<func> 为G,1,5.4则计算公式为: f(x)= 1.0 + 5.4 * ln(x)

************************************************************

 

-i <func>设定两个相邻种子间所间距的碱基数。

************************************************************

例如：如果read的长度为30,种子的长度为10,相邻种子的间距为6,则提取出的种子如下

所示：

Read:     TAGCTACGCTCTACGCTATCATGCATAAAC

Seed 1 fw: TAGCTACGCT

Seed 1 rc: AGCGTAGCTA

Seed 2 fw:       CGCTCTACGC

Seed 2 rc:       GCGTAGAGCG

Seed 3 fw:             ACGCTATCAT

Seed 3 rc:             ATGATAGCGT

Seed 4 fw:                   TCATGCATAA

Seed 4 rc:                   TTATGCATGA

************************************************************

 在--end-to-end模式中默认值为”-iS,1,1.15”.即表示f(x) = 1 + 1.15 *sqrt(x).如果read长度为100,则相邻种子的间距为12.

 

--n-ceil <func>设定read中允许含有不确定碱基(非GTAC,通常为N)的最大数目.Default: L,0,0.15.计算公式为: f(x) =0 + 0.15 * x,表示长度为100的read最多运行存在15个不确定碱基.一旦不确定碱基数超过15,则该条read会被过滤掉.

 

--dpad <int> Default: 15.

 

--gbar <int>在read头尾<int>个碱基内不允许gap.Default: 4.

 --ignore-quals计算错配罚分的时候不考虑碱基质量.当输入序列的模式为-f, -r或者-c的时候,该设置自动成为默认设置.

 

--nofw/--norc –nofw设定read不和前导链(forwardreference strand)进行比对;

 --norc设定不和后随链(reverse-complementreference strand)进行比对.

Default: both strands enabled.

 

--end-to-end比对是将整个read和参考序列进行比对.该模式--ma的值为0.该模式为默认模式, --local模式冲突.

 

--local该模式下对read进行局部比对,从而, read两端的一些碱基不比对，从而使比对得分满足要求.该模式下 –ma默认为2.

 

## 得分罚分参数

--ma <int>设定匹配得分.--local模式下每个read上碱基和参考序列上碱基匹配,则加<int>分.在—end-to-end模式中无效. Default: 2.

 

--mp MX,MN设定错配罚分.其中MX为所罚最高分, MN为所罚最低分.默认设置下罚分与碱基质量相关.罚分遵循的公式为: MN + floor( (MX-MN)(MIN(Q, 40.0)/40.0) ).其中Q为碱基的质量值.如果设置了—ignore-qual参数,则错配总是罚最高分. Default:MX = 6, MN = 2.

 

--np <int>当匹配位点中read,reference上有不确定碱基(比如N)时所设定的罚分值.Default: 1.

 

--rdg <int1>,<int2>设置在read上打开gap罚分<int1>,延长gap罚分<int2>.Default: 5, 3.

 

--rfg <int1>,<int2>设置在reference上打开gap罚分<int1>,延长gap罚分<int2>. Default: 5, 3.

 

--score-min <func>设定成为有效比对的最小分值.在—end-to-end模式下默认值为:L,-0.6,-0.6;在--local模式下默认值为:G,20,8.

 

## 报告参数

-k <int>默认设置下,bowtie2搜索出了一个read不同的比对结果,并报告其中最好的比对结果(如果好几个最好的比对结果得分一致,则随机挑选出其中一个).而在该模式下,bowtie2最多搜索出一个read<int>个比对结果,并将这些结果按得分降序报告出来.

 

-a和-k参数一样,不过不限制搜索的结果数目.并将所有的比对结果都按降序报告出来.此参数和-k参数冲突.值得注意的是:如果基因组含有很多重复序列时,该参数会导致程序

运行极其缓慢.

 

## Effort参数

-D <int>比对时,将一个种子延长后得到比对结果,如果不产生更好的或次好的比对结果,则该次比对失败.当失败次数连续达到<int>次后,则该条read比对结束. Bowtie2才会继续进行下去. Default: 15.当具有-k或-a参数,则该参数所产生的限制会自动调整.

 

-R <int>如果一个read所生成的种子在参考序列上匹配位点过多.当每个种子平均匹配超过300个位置,则通过一个不同的偏移来重新生成种子进行比对. <int>则是重新生成种子

的次数. Default: 2.

 

## Paired-end参数

-I/--minins <int> 设定最小的插入片段长度.Default: 0.

 

-X/--maxins <int> 设定最长的插入片段长度.Default: 500.

 

--fr/--rf/--ff 设定上下游reads和前导链paired-end比对的方向. --fr: 匹配时，read1在5'端上游, 和前导链一致, read2在3'下游, 和前导链反向互补. 或者read2在上游, read1在下游反向互补; --rf: read1在5'端上游, 和前导链反向互补, read2在3'端下游, 和前导链一致; --ff:两条reads都和前导链一致. Default: --fr. 默认设置适合于Illumina的paired-end测序数据; 若是mate-paired, 则要选择—rf参数.

 

--no-mixed 默认设置下, 一对reads不能成对比对到参考序列上,则单独对每个read进行比对. 该选项则阻止此行为.

 

--no-discordant 默认设置下, 一对reads不能和谐比对(concordantalignment,即满足-I, -X, --fr/--rf/--ff的条件)到参考序列上, 则搜寻其不和谐比对(disconcordant alignment, 即两条reads都能独一无二地比对到参考序列上, 但是不满足-I,-X,--fr/--rf/--ff的条件). 该选项阻止此行为.

 

--dovetail read1和read2的关系为dovetail的时候,该状况算为和谐比对. 默认情况下dovetail不算和谐比对.

 

--no-contain read1和read2的关系为包含的时候, 该状况不算为和谐比对. 默认情况下包含关系算为和谐比对.

 

--no-overlap read1和read2的关系为有重叠的时候, 该状况不算为和谐比对. 默认情况下两个reads重叠算为和谐比对.

 

## 输出参数

-t/--time --un <path> 将unpaired reads写入到<path>.

--un-gz <path> 将unpairedreads写入到<path>, gzip压缩.

--un-bz2 <path> 将unpairedreads写入到<path>, bz2压缩.

 

--al <path> 将至少能比对1次以上的unpairedreads写入<path>.

--al-gz <path> ... ,gzip压缩.

--al-bz2 <path> ... ,bz2压缩.

 

--un-conc <path> 将不能和谐比对的paired-endreads写入<path>.

--un-conc-gz <path> ... ,gzip压缩.

--un-conc-bz2 <path> ... ,bz2压缩.

 

--al-conc <path> 将至少能和谐比对一次以上的paired-endreads写入<path>.

--al-conc-gz <path> ... ,gzip压缩.

--al-conc-bz2 <path>... ,bz2压缩.

 

--quiet 安静模式,除了比对错误和一些严重的错误, 不在屏幕上输出任何东西.

 

--met-file <path> 将bowtie2的检测信息(metrics)写入文件<path>.用于debug.Default: metrics disabled.

 

--met-stderr <path> 将bowtie2的检测信息(metrics)写入标准错误文件句柄. 和上一个选项不冲突. Default: metrics disabled.

 

--met <int> 每隔<int>秒写入一次metrics记录. Default:1.

 

 ## Sam 参数

--no-unal不记录没比对上的reads.

 

--no-hd不记录SAM header lines (以@开头).

 

--no-sq不记录@SQ的SAM headerlines.

 

--rg-id <text>设定read groupID为text。在SAM文件的头中增加一行@RG，在输出的SAM文件中添加Tag "RG:Z:text"。

 

--rg <text>使用text作为@RG的一列，比如"SM:Pool1"。在@RG中加入多列，则多次使用该参数即可。在进行Variant calling的过程中需要@RG头，SM信息和Tag RG。

 

## 性能参数

-o/--offrate <int> 无视index的offrate值, 以<int>取代之. Index默认的<int>值为5. <int>值必须大于index的offrate值, 同时<int>越大, 耗时越长，耗内存越少.

 

-p/--threads NTHREADS 设置线程数.Default: 1

 

--reorder 多线程运算时, 比对结果在顺序上会和文件中reads的顺序不一致, 使用该选项, 则使其一致.

 

--mm 使用内存定位的I/O来载入index, 而不是常规的文件I/O. 从而使多个bowtie程序共用内存中同样的index, 节约内存消耗.

 

## 其它参数：

--qc-filter 滤除QSEQ fileter filed为非0的reads. 仅当有—qseq选项时有效.Default: off.

 

--seed <int>使用<int>作为随机数产生的种子.Default: 0.

 

--version打印程序版本并退出

 

-h/--help 打印用法信息并推出
