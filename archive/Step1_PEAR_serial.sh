#!/bin/bash -l
#
#SBATCH --mail-user=dhtaft@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=Step1
#SBATCH --error=Step1.err
#SBATCH --partition=med
#SBATCH --account=millsgrp

# PLEASE REMEMBER TO CHANGE EMAIL BEFORE SUBMITTING
# This file should be saved in the same directory as your raw .fastq files.  PEAR barcode files should be text tab delimited with unix endings
# Do not edit name of reverse files if you ran the prestep file.
# Barcode files should be saved in same working directory as raw .fastq files
# This script can handle up to 4 sets of fastq files
# This script assumes sequencing of the V4 region of 16S using 8 bp barcodes and 515F/806R primers
# This script assumes that Diana has a current version of the 97_otu files for assigning taxonomy in her folder on the farm
# Please place this script file AND all other step script files into your current working directory with the forward fastq(s), reverse fastq(s), 
#             barcode file (s), and mapping file

module load perlbrew/5.16.0 fastx/0.0.14 pear/0.9.8

cwd=$(pwd)
mkdir $cwd/demultiplex/

#Forward fastq 1
forward1="Lstud1_S1_L001_R1_001.fastq"
#Reverse fastq 1
reverse1="trimmed_reverse1.fast1"
#barcode file
bar1="barcode_run1.txt"
#QIIME mapping file, should be 1 combined file for ALL samples 
#concatenate mapping files if multiple sets of fastq files being used, and delete values under barcode header
#should run validate_mapping_file.py prior to use here
map="lactation_map.txt"

#If you have more than 1 set of fastq files, remove # sign from following lines and insert file names
#forward2="Lstud2_S1_L001_R1_001.fastq"
#reverse2="trimmed_reverse2.fastq"
#bar2="barcode_run2.txt"
#forward3="Lstud3_S1_L001_R1_001.fastq"
#reverse3="trimmed_reverse3.fastq"
#bar3="barcode_run3.txt"
#forward4="FILE4R1.fastq"
#reverse4="trimmed_reverse4.fastq"
#bar4="barcode4.txt"

#STEP 1:  Merge the paired end reads
pear -f $cwd/$forward1 -r $cwd/$reverse1 -o $cwd/pear -v 120 -m 380 -n 250
#If you have more than 1 set of fastq files, remove the # signs.  DO NOT CHANGE ANYTHING ELSE
#pear -f $cwd/$forward2 -r $cwd/$reverse2 -o $cwd/pear2 -v 120 -m 380 -n 250
#pear -f $cwd/$forward3 -r $cwd/$reverse3 -o $cwd/pear3 -v 120 -m 380 -n 250
#pear -f $cwd/$forward4 -r $cwd/$reverse4 -o $cwd/pear4 -v 120 -m 380 -n 250

#STEP 2:  Demultiplex the fastq files
fastx_barcode_splitter.pl --bcfile $cwd/$bar1 --prefix $cwd/demultiplex/ --suffix .fastq --bol < $cwd/pear.assembled.fastq
#If you have more than 1 set of fastq files, remove the # signs.  DO NOT CHANGE ANYTHING ELSE
#fastx_barcode_splitter.pl --bcfile $cwd/$bar2 --prefix $cwd/demultiplex/ --suffix .fastq --bol < $cwd/pear2.assembled.fastq
#fastx_barcode_splitter.pl --bcfile $cwd/$bar3 --prefix $cwd/demultiplex/ --suffix .fastq --bol < $cwd/pear3.assembled.fastq
#fastx_barcode_splitter.pl --bcfile $cwd/$bar4 --prefix $cwd/demultiplex/ --suffix .fastq --bol < $cwd/pear4.assembled.fastq 

#STEP 3: Call parallel code to trim barcodes. REMEMBER TO DEFINE MAPPING FILE IN STEPS 3 AND 5!!!
sbatch -p med -A millsgrp Step2_Trim_parallel.sh -N 1 -n 24
