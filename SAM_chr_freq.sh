#! /bin/bash

#####################################################

#SBATCH --job-name=bbsplit

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=80G
#SBATCH --time=12:00:00

######################################################


module load SAMtools/1.3.1-foss-2016b #in case it was not loaded in environment

f="$1"
f1="${f%%Aligned.out.sam*}"
f2="${f1##*/}"

samtools view --threads 10 "$1" | cut -f 3 | sort | uniq -c | sort -nr | sed -e 's/^ *//;s/ /\t/' | awk 'OFS="\t" {print $2,$1}' | sort -n -k1,1 > "$f2"_Chr_freqs.txt
