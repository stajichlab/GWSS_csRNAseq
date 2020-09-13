library(ggplot2)
library(dplyr)
library(tidyverse)

A.csRNA <- read_tsv("results/STAR/A1.csRNA-tagDir/tagLengthDistribution.txt",col_names=c("TagLength","FractionTags"),skip=1)
A.ctl <- read_tsv("results/STAR/A1.input-tagDir/tagLengthDistribution.txt",col_names=c("TagLength","FractionTags"),skip=1)

D.csRNA <- read_tsv("results/STAR/D8.csRNA-tagDir/tagLengthDistribution.txt",col_names=c("TagLength","FractionTags"),skip=1)
D.ctl <- read_tsv("results/STAR/D8.input-tagDir/tagLengthDistribution.txt",col_names=c("TagLength","FractionTags"),skip=1)


A = bind_rows(list(A.ctl %>% add_column("Source"="A.ctl") ,
          A.csRNA %>% add_column("Source"="A.csRNA") ))

D = bind_rows(list(D.ctl %>% add_column("Source"="D.ctl") ,
                   D.csRNA %>% add_column("Source"="D.csRNA") ))

ALL = bind_rows(list(A,D))

ggplot(ALL, aes(TagLength, FractionTags, color = Source)) +
  geom_point() +
  geom_line()

ggplot(A, aes(TagLength, FractionTags, color = Source)) +
  geom_point() +
  geom_line()

ggplot(D, aes(TagLength, FractionTags, color = Source)) +
  geom_point() +
  geom_line()