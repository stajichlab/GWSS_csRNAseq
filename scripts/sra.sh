#!/usr/bin/bash
#SBATCH --out sra_download.log -p stajichlab
module load aspera
module load sratoolkit/2.10.5
module unload perl
for ACC in $(cat SRA_PRJNA415461.txt)
do
	fastq-dump -X 5 --split-e '@$ac/$ri' --skip-technical $ACC
	break
done
