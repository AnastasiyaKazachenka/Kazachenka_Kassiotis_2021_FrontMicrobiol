#! /bin/bash

#####################################################

#SBATCH --job-name=feature_counting

#SBATCH --ntasks=8
#SBATCH --cpus-per-task=32
#SBATCH --mem=80G
#SBATCH --time=1-00:05


######################################################


#use 
#sbatch ~/shellscripts/feature_counting_allinone.sh 

### featurecounts
# -B option says to only count reads which have both ends mapped!
# did not use stranded counting (-s)
# -t 2 allows to use two cores

module load Subread/1.5.0-p1-foss-2016b



#skip commands if file already exists from a previous run
if [ ! -s /home/camp/kazacha/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/chimera_finder/Desai_et_al/all.counts ]; then
	featureCounts -p -C -B --primary -a ~/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/gencode.v29/gencode.v29.basic.annotation.gtf \
	-o /home/camp/kazacha/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/chimera_finder/Desai_et_al/Desai_et_al_4samples.counts \
	~/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/chimera_finder/STAR_output/Desai_et_al/*.bam >> /home/camp/kazacha/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/Scratch/mapping/Desai_et_al_4samples.txt 2>&1
#	gzip /home/camp/kazacha/workinuing/CURRENT.MEMBERS/Anastasiya.Kazachenka/Scratch/genecounts/all.counts 
else
	echo "gene level counting was skipped since file already exists"
fi

