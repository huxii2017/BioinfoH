

### featureCounts命令（可以同时counts多个bam文件，并将结果写入一个txt文件，例如物种1的全基因组信息注释文件为1.gtf；从mapping步骤获得4个bam文件，则命令为如下所示）  

```
featureCounts -T 6 -s 0 -p -t exon -g gene_id -a 1.gtf -o featureCounts.txt 1.bam 2.bam 3.bam 4.bam
```  

注意：参数-s主要是只测序文库是否具有链特异性，有三个选项，分别是0，1，2，与构建文库的方式有关。一般情况下，随机引物反转录扩增的构建文库方法参数为0.  

详情可见http://onetipperday.sterding.com/2012/07/how-to-tell-which-library-type-to-use.html






以下操作均在R中进行

### 清空变量&data  

```R
rm(list=ls())
```
## step1 edgR 数据导入  

```R
library(edgeR)
setwd("~/BioII/lulab_b/huxi/mapping1")
mydata <- read.table("al_counts.txt",header = T,quote = '\t',skip = 1)
sampleNames <- c("CK_0_1","CK_0_2","ND_0.5_1","ND_0.5_2","ND_1_1","ND_1_2","ND_3_1","ND_3_2","ND_6_1","ND_6_2","ND_12_1","ND_12_2")
names(mydata)[7:18] <- sampleNames
head(mydata)
```  


## step2 Counts矩阵
`
countMatrix <- as.matrix(mydata[7:18])
rownames(countMatrix) <- mydata$Geneid
head(countMatrix)
`

## DESeq2方法如下
### 构建dds矩阵
`
library(DESeq2)
condition <- factor(c(rep("CK",2),rep("ND_0.5",2),rep("ND_1",2),rep("ND_3",2),rep("ND_6",2),rep("ND_12",2)),levels = c("CK","ND_0.5","ND_1","ND_3","ND_6","ND_12"))
countData <- countMatrix[,1:12]
colData <- data.frame(row.names = colnames(countMatrix),condition)
dds <- DESeq2::DESeqDataSetFromMatrix(countData,colData,design= ~ condition)
head(dds)
`
### DESeq标准化dds矩阵
`
dds2 <- DESeq2::DESeq(dds)
DESeq2::resultsNames(dds2)
res <- DESeq2::results(dds2)
DESeq2::summary.DESeqResults(res)
`
### 提取差异分析结果
`
table(res$padj<0.05)
res <- res[order(res$padj),]
diff_gene_deseq2 <- subset(res, padj < 0.05 & (log2FoldChange > 1 |log2FoldChange < -1 ))
diff_gene_deseq2 <- row.names(diff_gene_deseq2)
resdata <- merge(as.data.frame(res),as.data.frame(counts(dds2,normalize = TRUE)),by ="row.names",sort = FALSE)
write.csv(resdata,file = "CKvsND.csv",row.names = F)


plotMA(res,ylim=c(-5,5))
topGene <- rownames(res)[which.min(res$padj)]
with(res[topGene,],{
  points(baseMean,log2FoldChange,col="dodgerblue",cex=2,lwd=2)
  text(baseMean,log2FoldChange,topGene,pos = 2,col="dodgerblue")
  })
`

#以下方法还没没成功
#step3 创建DEGlist 
group <- factor(c("CK_0_1","CK_0_2","ND_0.5_1","ND_0.5_2","ND_1_1","ND_1_2","ND_3_1","ND_3_2","ND_6_1","ND_6_2","ND_12_1","ND_12_2"))
y <- DGEList(counts = countMatrix,group = group)
y
#step4 过滤
keep <- rowSums(cpm(y)>1) >=2
y1 <- y[keep, ,keep.lib.sizes=FALSE]
y1
#step5 标准化处理
y2 <- calcNormFactors(y1)
y2
#step6 设计矩阵
subGroup <- factor(substring(colnames(countMatrix),1,6))
design <- model.matrix(~ subGroup+group)
rownames(design) <- colnames(y2)
design
#step7 评估离散度
y3 <- estimateDisp(y2,design,robust = TRUE)
y3$common.dispersion
plotBCV(y3)
#差异表达基因
