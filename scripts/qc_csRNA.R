library(ggplot2)
library(dplyr)
library(tidyverse)

cbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

A.csRNA <- read_tsv("results/STAR/A1.csRNA-tagDir/tagLengthDistribution.txt",col_names=c("TagLength","FractionTags"),skip=1)
A.ctl <- read_tsv("results/STAR/A1.input-tagDir/tagLengthDistribution.txt",col_names=c("TagLength","FractionTags"),skip=1)

D.csRNA <- read_tsv("results/STAR/D8.csRNA-tagDir/tagLengthDistribution.txt",col_names=c("TagLength","FractionTags"),skip=1)
D.ctl <- read_tsv("results/STAR/D8.input-tagDir/tagLengthDistribution.txt",col_names=c("TagLength","FractionTags"),skip=1)

pdf("csRNAseq_qc.pdf")
A = bind_rows(list(A.ctl %>% add_column("Source"="A.ctl") ,
          A.csRNA %>% add_column("Source"="A.csRNA") ))

D = bind_rows(list(D.ctl %>% add_column("Source"="D.ctl") ,
                   D.csRNA %>% add_column("Source"="D.csRNA") ))

ALL = bind_rows(list(A,D))

ggplot(ALL, aes(TagLength, FractionTags, color = Source)) +
  geom_point() +
  geom_line() + ggtitle("tagLengthDistribution A & D samples") +   scale_colour_brewer(palette="Set1")

ggplot(A, aes(TagLength, FractionTags, color = Source)) +
  geom_point() +
  geom_line() + ggtitle("tagLengthDistribution A sample") +    scale_colour_brewer(palette="Set1")

ggplot(D, aes(TagLength, FractionTags, color = Source)) +
  geom_point() +
  geom_line() + ggtitle("tagLengthDistribution D sample") +    scale_colour_brewer(palette="Set1")


A.csRNA <- read_tsv("results/STAR/A1.csRNA-tagDir/tagFreqUniq.txt",col_names=TRUE) %>% select("Offset","A","C","G","T") %>% gather("A","C","G","T",key="NT",value="Frequency")
A.ctl <- read_tsv("results/STAR/A1.input-tagDir/tagFreqUniq.txt",col_names=TRUE) %>% select("Offset","A","C","G","T") %>% gather("A","C","G","T",key="NT",value="Frequency")

D.csRNA <- read_tsv("results/STAR/D8.csRNA-tagDir/tagFreqUniq.txt",col_names=TRUE) %>% select("Offset","A","C","G","T") %>% gather("A","C","G","T",key="NT",value="Frequency")
D.ctl <- read_tsv("results/STAR/D8.input-tagDir/tagFreqUniq.txt",col_names=TRUE) %>% select("Offset","A","C","G","T") %>% gather("A","C","G","T",key="NT",value="Frequency")

ggplot(A.csRNA, aes(Offset, Frequency, color = NT)) +
  geom_point() +
  geom_line() + ggtitle("csRNA-seq A sample, NT freq") +    scale_colour_brewer(palette="Set1")

ggplot(A.ctl, aes(Offset, Frequency, color = NT)) +
  geom_point() +
  geom_line() + ggtitle("Control A sample, NT freq") +    scale_colour_brewer(palette="Set1")

ggplot(D.csRNA, aes(Offset, Frequency, color = NT)) +
  geom_point() +
  geom_line() + ggtitle("csRNA-seq D sample, NT freq") +    scale_colour_brewer(palette="Set1")

ggplot(D.ctl, aes(Offset, Frequency, color = NT)) +
  geom_point() +
  geom_line() + ggtitle("Control D sample, NT freq") +    scale_colour_brewer(palette="Set1")
