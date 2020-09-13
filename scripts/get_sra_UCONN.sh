#!/usr/bin/bash
#SBATCH -p stajichlab 

module load aspera

~/bin/sra_download.pl -ascp -id $ASPERAKEY SRA_PRJNA415461.txt
