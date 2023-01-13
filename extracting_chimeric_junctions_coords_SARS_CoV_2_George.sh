#! /bin/bash

#####################################################

#SBATCH --job-name=bbsplit

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=80G
#SBATCH --time=12:00:00

######################################################


f="$1"
f1="${f%%Chimeric.out.junction*}"
f2="${f1##*/}"


cat "$1" | awk '$1=="NC_045512v2" && $4!="NC_045512v2" {print $4,$5}' | sort | uniq > coords_set1_"$f2".csv
cat "$1" | awk '$1!="NC_045512v2" && $4=="NC_045512v2" {print $1,$2}' | sort | uniq > coords_set2_"$f2".csv

cat coords_set1_"$f2".csv coords_set2_"$f2".csv | sort | uniq > chimeric_junctions_coords_"$f2".csv

rm coords_set1_"$f2".csv
rm coords_set2_"$f2".csv

awk '{print $1,$2,$2}' chimeric_junctions_coords_"$f2".csv | awk '$3+=1' > chimeric_junctions_coords_"$f2".tsv

sed -e 's/ /\t/g' chimeric_junctions_coords_"$f2".tsv > chimeric_junctions_coords_"$f2".bed

rm chimeric_junctions_coords_"$f2".tsv
rm chimeric_junctions_coords_"$f2".csv

###overlaping gencode29

module load BEDTools/2.26.0-foss-2016b

sort -k1,1 -k2,2n chimeric_junctions_coords_"$f2".bed > chimeric_junctions_coords_"$f2".sorted.bed
grep -v "chrM" chimeric_junctions_coords_"$f2".sorted.bed > chimeric_junctions_coords_"$f2"_nochrM.sorted.bed

bedtools intersect -a chimeric_junctions_coords_"$f2".sorted.bed -b ~/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/gencode.v29/genes_gencode.v29.basic.annotation.bed -u > intragenic_junctions_"$f2".bed
bedtools intersect -a chimeric_junctions_coords_"$f2".sorted.bed -b ~/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/gencode.v29/exons_UTRs_gencode.v29.basic.annotation.V2.bed  -u > exon_or_UTR_junctions_"$f2".bed
bedtools intersect -a chimeric_junctions_coords_"$f2".sorted.bed -b ~/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/gencode.v29/exons_UTRs_gencode.v29.basic.annotation.V2.bed  -wb > exon_or_UTR_junctions_names_"$f2".bed
bedtools intersect -a chimeric_junctions_coords_"$f2".sorted.bed -b ~/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/gencode.v29/genes_gencode.v29.basic.annotation.bed -wb > intragenic_junctions_gene_names_"$f2".bed

bedtools intersect -a chimeric_junctions_coords_"$f2"_nochrM.sorted.bed -b ~/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/gencode.v29/exons_UTRs_gencode.v29.basic.annotation.V2.bed  -wb > exon_or_UTR_junctions_names_"$f2"_nochrM.bed
bedtools intersect -a chimeric_junctions_coords_"$f2"_nochrM.sorted.bed -b ~/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/gencode.v29/exons_UTRs_gencode.v29.basic.annotation.V2.bed  -u > exon_or_UTR_junctions_"$f2"_nochrM.bed
bedtools intersect -a chimeric_junctions_coords_"$f2"_nochrM.sorted.bed -b ~/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/gencode.v29/genes_gencode.v29.basic.annotation.bed -wb > intragenic_junctions_gene_names_"$f2"_nochrM.bed
bedtools intersect -a chimeric_junctions_coords_"$f2"_nochrM.sorted.bed -b ~/working/CURRENT.MEMBERS/Anastasiya.Kazachenka/gencode.v29/genes_gencode.v29.basic.annotation.bed -u > intragenic_junctions_"$f2"_nochrM.bed


cat intragenic_junctions_gene_names_"$f2"_nochrM.bed | awk '{print $7}' | sort | uniq -c| sort -k1,1rn | awk '{print $2,$1}' > genes_containing_junctions_"$f2"_nochrM.txt
cat exon_or_UTR_junctions_names_"$f2"_nochrM.bed | awk '{print $7}' | sort | uniq -c| sort -k1,1rn | awk '{print $2,$1}' > exon_or_UTR_containing_junctions_"$f2"_nochrM.txt
