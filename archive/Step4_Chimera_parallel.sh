#!/bin/bash -l
#
#SBATCH --mail-user=dhtaft@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=step4
#SBATCH --error=step4.err
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

cwd=$(pwd)

parallel_identify_chimeric_seqs.py -i $cwd/swarm_otu/pynast_aligned/rep_set_aligned.fasta -a $cwd/swarm_otu/pynast_aligned/rep_set_aligned.fasta -o $cwd/swarm_otu/chimeric_seqs.txt ;

sbatch -p med -A millsgrp Step5_filter_serial.sh
