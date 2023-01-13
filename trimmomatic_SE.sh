#!/bin/sh

#SBATCH --job-name=trimming
#SBATCH --ntasks=4 #number of cores
#SBATCH --nodes=1 # Ensure that all cores are on one machine 
#SBATCH --time=0-59:05 #time limit of zero requests no limit. Other formats are allowed 
#SBATCH --mem-per-cpu=4096 #memory per core in MB
#SBATCH -o /home/camp/kazacha/log.files/trim%u%j.stout # File to which STDOUT will be written 
#SBATCH -e /home/camp/kazacha/log.files/trim%u%j.sterr # File to which STDERR will be written 


### sbatch for example as
#sbatch ~/shellscripts/trimpe-gzip-TruSeq3.sbatch.sh /home/camp/kazacha/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/fastq/GEO531A1_S1_L001_R1_001.fastq.gz
#parallel 'sbatch ~/shellscripts/trimpe-gzip-TruSeq3.sbatch.sh {}' :::  /home/camp/kazacha/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/fastq/*R1_001.fastq.gz
#trimmomatic does accept gzipped files
#be careful not to use "{}" if the file path contains escape quotes \


module load Trimmomatic

f="$1"
f1="${f%%.fastq.gz*}"
f2="${f1##*/}"

java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.36.jar \
	SE \
	-threads 4 \
	-phred33 \
	"$f" \
	/home/camp/kazacha/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/Scratch/trimmed.reads/"$f2"_trimmed.fq \
	ILLUMINACLIP:/home/camp/kazacha/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/Trimmomatic/RiboProf-SE.fa:2:30:10 \
	SLIDINGWINDOW:3:15 \
	MINLEN:34 \
>& /home/camp/kazacha/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/Scratch/trimming.logs/"$f2".trim.log


gzip /home/camp/kazacha/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/Scratch/trimmed.reads/"$f2"_trimmed.fq



### fastQC to test for successful removal of adapter
ml load FastQC

fastqc ~/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/Scratch/trimmed.reads/"$f2"_trimmed.fq.gz
