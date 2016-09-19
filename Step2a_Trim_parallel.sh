#!/bin/bash -l
#
#SBATCH --mail-user=dhtaft@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=step2a
#SBATCH --error=step2a.err
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

module load perlbrew/5.16.0 fastx/0.0.14

cwd=$(pwd)

#Part 1:  Remove barcode and forward primer
trim () {
	local file=$1
	name=$(echo $file | cut -f 1 -d '.')
	fastx_trimmer -f 30 -i $file -o $name.trimmed.fastq
}
for file in $cwd/demultiplex/*.fastq; do trim "$file" & done

sbatch -p med -A millsgrp -N 1 -n 24 Step2b_Clip_parallel.sh
