#!/usr/bin/bash
#SBATCH -p short --mem 128gb -N 1 -n 32 --out logs/STAR_csRNAseq.%a.log -J csRNA_STAR

module load STAR
module load homer
CPU=1
if [ $SLURM_CPUS_ON_NODE ]; then
    CPU=$SLURM_CPUS_ON_NODE
fi

N=${SLURM_ARRAY_TASK_ID}

if [ -z $N ]; then
    N=$1
    if [ -z $N ]; then
        echo "Need an array id or cmdline val for the job"
        exit
    fi
fi

INDIR=csRNASeq
OUTDIR=results/STAR
IDX=genome/STAR
SAMPLEFILE=samples.tsv
GENOME=$(realpath genome/Homalodisca_vitripennis.A6A7A9_masurca_v1.masked_RModeler.fasta)
GFF=$(realpath ../annotation/annotate/Homalodisca_vitripennis.A6A7A9_masurca_v1/annotate_results/Homalodisca_vitripennis_A6A7A9_masurca_v1.gff3)
GTF=genome/Homalodisca_vitripennis_A6A7A9_masurca_v1.gtf
if [ ! -f $GTF ]; then
	grep -P "\texon\t" Homalodisca_vitripennis_A6A7A9_masurca_v1.gff3 | perl -p -e 's/ID=[^;]+;Parent=([^;]+);/gene_id $1/' > Homalodisca_vitripennis_A6A7A9_masurca_v1.gtf
fi
if [ ! -d $IDX ]; then
	STAR --runThreadN $CPU --runMode genomeGenerate --genomeDir $IDX --genomeFastaFiles $GENOME --sjdbGTFfile $GTF --genomeChrBinNbits 16
fi
mkdir -p $OUTDIR

tail -n +2 $SAMPLEFILE |  sed -n ${N}p | while read SAMPLE FILE	TYPE
do
 OUTNAME=$SAMPLE
 STAR --outSAMstrandField intronMotif --runThreadN $CPU --outMultimapperOrder Random --outSAMmultNmax 1 \
	--outFilterMultimapNmax 10000 --limitOutSAMoneReadBytes 10000000 \
	 --genomeDir $IDX --outFileNamePrefix $OUTDIR/$OUTNAME. --readFilesIn $INDIR/${FILE}_R1_001.fastq.gz.trimmed
 makeTagDirectory $OUTDIR/${OUTNAME}-tagDir/ $OUTDIR/$OUTNAME.Aligned.out.sam -genome $GENOME -checkGC -fragLength 150 -single
done
