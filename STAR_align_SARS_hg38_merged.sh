#! /bin/bash

#####################################################

#SBATCH --job-name=chimeric_finder

#SBATCH --ntasks=4
#SBATCH --cpus-per-task=32
#SBATCH --time=12:00:00

######################################################


module load STAR/2.7.1a-foss-2019a

f="$1"
f1="${f%%_trimmed.fq.gz*}"
f2="${f1##*/}"

echo "$fname"
echo "$fullpath"

STAR --runThreadN 32 \
--genomeDir ./STAR_index_SARS_hg38_150bp \
--readFilesCommand zcat \
--outFileNamePrefix ./STAR_output/"$f2" \
--readFilesIn  "$1" \
--chimOutType SeparateSAMold Junctions \
--chimSegmentMin 50 \
--chimScoreJunctionNonGTAG 0 \
--chimJunctionOverhangMin 50 \
--alignSJstitchMismatchNmax -1 -1 -1 -1
