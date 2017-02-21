#!/bin/bash -l
#
#SBATCH --mail-user=dhtaft@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=Step1
#SBATCH --error=Step1.err
#SBATCH --partition=med
#SBATCH --account=millsgrp

#Please see start of Step1 for directions on how to use these scripts
#Please edit reverse files to match names of your files

#Put in name of REVERSE read here
reverse1="Lstud1_S1_L001_R2_001.fastq"
#If you have more than 1 set of fastq files, remove # sign from following lines and insert file names
reverse2="Lstud2_S1_L001_R2_001.fastq"
reverse3="Lstud3_S1_L001_R2_001.fastq"
#reverse4="FILE4R2.fastq"

module load perlbrew/5.16.0 fastx/0.0.14

cwd=$(pwd)

#Trim out reverse primer.  If using a primer other than GGACTACHVGGGTWTCTAAT, please adjust accordingly
fastx_trimmer -f 21 -i $reverse1 -o trimmed_reverse1.fastq &&
fastx_trimmer -f 21 -i $reverse2 -o trimmed_reverse2.fastq &&
fastx_trimmer -f 21 -i $reverse3 -o trimmed_reverse3.fastq &&
#fastx_trimmer -f 21 -i $reverse4 -o trimmed_reverse4.fastq &&

sbatch -p med -A millsgrp -t 7-00:00:00 --mem 15000 Step1_Pear_serial.sh

