#!/bin/bash -l
#
#SBATCH --mail-user=dhtaft@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=step3
#SBATCH --error=step3.err
#SBATCH --partition=med
#SBATCH --account=millsgrp

# PLEASE REMEMBER TO CHANGE EMAIL BEFORE SUBMITTING
# This file should be saved in the same directory as your raw .fastq files.  PEAR barcode files should be text tab delimited with unix endings
# Barcode files should be saved in same working directory as raw .fastq files
# This script can handle up to 4 sets of fastq files
# This script assumes sequencing of the V4 region of 16S using 8 bp barcodes and 515F/806R primers
# This script assumes that Diana has a current version of the 97_otu files for assigning taxonomy in her folder on the farm
# Please place this script file AND all other step script files into your current working directory with the forward fastq(s), reverse fastq(s), 
#             barcode file (s), and mapping file

module load R matplotlib numpy qiime/1.9.1
map="lactation_map.txt"

files=$(ls $cwd/trim_only/*.complete.trim.fastq -m | sed -e 's/, /,/g' | tr -d '\n') 
ls $cwd/trim_only | cut -f 1 -d '.' > test.txt
name=$(cat test.txt | tr -s ' ' | cut -d ' ' -f 2 | tr '\n' ',' | sed 's/,$//')
split_libraries_fastq.py -i $files --sample_ids $name -o $cwd/qiime_split_library --barcode_type 'not-barcoded' -m $cwd/$map ;
rm test.txt

pick_otus.py -i $cwd/qiime_split_library/seqs.fna -m swarm -o $cwd/swarm_otu --denovo_otu_id_prefix OTU --swarm_resolution 4 ;

pick_rep_set.py -i $cwd/swarm_otu/seqs_otus.txt -f $cwd/qiime_split_library/seqs.fna -o $cwd/swarm_otu/rep_set.fna -m most_abundant ;

align_seqs.py -i $cwd/swarm_otu/rep_set.fna -o $cwd/swarm_otu/pynast_aligned ;

sbatch -p med -A millsgrp Step4_OTU_tables_serial.sh
