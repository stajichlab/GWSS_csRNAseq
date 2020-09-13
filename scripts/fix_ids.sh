#!/usr/bin/bash
#SBATCH -p short -n 48 -N 1 --mem 24gb

module unload perl
module load parallel
fixid() {
	file=$1
	pigz -dc $1.gz | perl -p -e 's/^(\@SRR\S+)\s+(\d+)\/(\d+)/$1\/$3/' > $1
}
export -f fixid
parallel -j 32 fixid {.} ::: $(ls SRR*/SRR*_[12].fastq.gz)
cat */*_1.fastq | pigz -c > Hv_RNASeq_1.fq.gz
cat */*_2.fastq | pigz -c > Hv_RNASeq_2.fq.gz
