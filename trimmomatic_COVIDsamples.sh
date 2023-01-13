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

### file input & directory
fullname=$1   #collects string of input file from 1st argument (*_1.fastq.gz)

fullfilename="${fullname##*/}"
filename_trunc="${fullfilename%-TRNA_R1.fastq.gz}"
filename="${filename_trunc##NS.1100.00*.NEBNext_dual_i7_*NEBNext_dual_i5_*.}"


indirectory="${fullname%/*}"
subdirectory="GENCODE"

filename_fastq2=$(printf "$indirectory"/*"$filename"*_R2.fastq.gz)



#########################

java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.36.jar \
	PE \
	-threads 4 \
	-phred33 \
	"$fullname" \
	"$filename_fastq2" \
	/home/camp/kazacha/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/Scratch/trimmed.reads/"$filename"_1.fq \
	/dev/null \
	/home/camp/kazacha/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/Scratch/trimmed.reads/"$filename"_2.fq \
	/dev/null \
	ILLUMINACLIP:/home/camp/kazacha/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/Trimmomatic/Trimmomatic.TruSeq3-PE-2plusuniversal.fa:2:40:10:2:true \
	SLIDINGWINDOW:3:20 \
	MINLEN:35 \
>& /home/camp/kazacha/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/Scratch/trimming.logs/"$filename".trim.log


gzip /home/camp/kazacha/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/Scratch/trimmed.reads/"$filename"_1.fq
gzip /home/camp/kazacha/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/Scratch/trimmed.reads/"$filename"_2.fq



### fastQC to test for successful removal of adapter
ml load FastQC

fastqc ~/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/Scratch/trimmed.reads/"$filename"_1.fq.gz
fastqc ~/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/Scratch/trimmed.reads/"$filename"_2.fq.gz
