# step1 cutadpt_preprocess
path：/BioII/lulab_b/wangsiqi/exRNA/exRNA-panel/s-smart/02.181022-CRC
## 去除接头
cutadapt -u 3 -u -75 -a AAAAAAAAAAGATCGGAAGAGCACACGTCTGAACTCCAGTCAC --trim-n -o 01.preprocess/smart_1.cutadapt_1.fastq 00.rawdata/smart_1.fq.gz

=== Summary ===

Total reads processed:              27,405,337
Reads with adapters:                14,207,479 (51.8%)
Reads written (passing filters):    27,405,337 (100.0%)

Total basepairs processed: 4,110,800,550 bp
Total written (filtered):  1,502,671,443 bp (36.6%)

## 去除polyA 以及tooshort reads
cutadapt -a AAAAAAAA -m 16 --too-short-output=01.preprocess/smart_1.tooShort.fastq -o 01.preprocess/smart_1.cutadapt_2.fastq 01.preprocess/smart_1.cutadapt_1.fastq

=== Summary ===

Total reads processed:              27,405,337
Reads with adapters:                12,863,959 (46.9%)
Reads that were too short:           6,573,977 (24.0%)
Reads written (passing filters):    20,831,360 (76.0%)

Total basepairs processed: 1,502,671,443 bp
Total written (filtered):  1,253,728,634 bp (83.4%)

# step2 Mapping》》脚本文件：/BioII/lulab_b/wangsiqi/exRNA/exRNA-panel/s-smart/02.181022-CRC/Snakefile.bk 
## map1_remove_rRNA
ID:bowtie2      PN:bowtie2      VN:2.2.9        CL:"/Share/home/wangsiqi/apps/bowtie2-2.2.9/bowtie2-align-s --wrapper basic-0 -p 4 --sensitive -x /Share/home/wangsiqi/projects/00.reference/Genome/human_hg38/rsem.index/rRNA 01.preprocess/smart_1.cutadapt_2.fastq --passthrough" #from smart_1.rRNA.sam

bowtie2 -p 4 --sensitive --no-unal --un {output.no_rRNA} -x {params.index} {input.fastq} -S {output.sam} > {log.log}

## map2_miRNA
ID:bowtie2      PN:bowtie2      VN:2.2.9        CL:"/Share/home/wangsiqi/apps/bowtie2-2.2.9/bowtie2-align-s --wrapper basi
c-0 -p 4 --sensitive --norc -x /Share/home/wangsiqi/projects/00.reference/Genome/human_hg38/rsem.index/miRNA 02.mapping/smart_1/remove_rRNA/smart_1.no_rRNA.fastq --passthrough" #from smart_1.miRNA.sam
                
bowtie2 -p {params.cpu} --sensitive --norc --no-unal --un {output.unAlign} -x {params.index} {input.fastq} -S {output.sam} 
           </br>   rsem-tbam2gbam {params.index} {output.sam} {output.tbam2gbam}

## map3_piRNA

bowtie2 -p {params.cpu} --sensitive --norc --no-unal --un {output.unAlign} -x {params.index} {input.fastq} -S {output.sam} 
           </br>   rsem-tbam2gbam {params.index} {output.sam} {output.tbam2gbam}

## map4_Y_RNA

bowtie2 -p {params.cpu} --sensitive --norc --no-unal --un {output.unAlign} -x {params.index} {input.fastq} -S {output.sam}
            </br>       rsem-tbam2gbam {params.index} {output.sam} {output.tbam2gbam}
## map5_srpRNA
bowtie2 -p {params.cpu} --sensitive --norc --no-unal --un {output.unAlign} -x {params.index} {input.fastq} -S {output.sam}
            </br>       rsem-tbam2gbam {params.index} {output.sam} {output.tbam2gbam}

## map6_tRNA
bowtie2 -p {params.cpu} --sensitive --norc --no-unal --un {output.unAlign} -x {params.index} {input.fastq} -S {output.sam}
             </br>      rsem-tbam2gbam {params.index} {output.sam} {output.tbam2gbam}

## map7_snRNA

## map8_snoRNA

## map9_lncRNA

## map10_mRNA

## map11_tucp

## map12_hg38other

# counts

