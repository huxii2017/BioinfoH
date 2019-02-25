# step1 cutadpt_preprocess
path：/BioII/lulab_b/wangsiqi/exRNA/exRNA-panel/s-smart/02.181022-CRC
## 去除接头
-u 3 -u -75 -a AAAAAAAAAAGATCGGAAGAGCACACGTCTGAACTCCAGTCAC --trim-n -o 01.preprocess/smart_1.cutadapt_1.fastq 00.rawdata/smart_1.fq.gz

=== Summary ===

Total reads processed:              27,405,337
Reads with adapters:                14,207,479 (51.8%)
Reads written (passing filters):    27,405,337 (100.0%)

Total basepairs processed: 4,110,800,550 bp
Total written (filtered):  1,502,671,443 bp (36.6%)

## 去除polyA 以及tooshort reads
-a AAAAAAAA -m 16 --too-short-output=01.preprocess/smart_1.tooShort.fastq -o 01.preprocess/smart_1.cutadapt_2.fastq 01.preprocess/smart_1.cutadapt_1.fastq

=== Summary ===

Total reads processed:              27,405,337
Reads with adapters:                12,863,959 (46.9%)
Reads that were too short:           6,573,977 (24.0%)
Reads written (passing filters):    20,831,360 (76.0%)

Total basepairs processed: 1,502,671,443 bp
Total written (filtered):  1,253,728,634 bp (83.4%)

