#!/bin/bash -l
#
#SBATCH --mail-user=me@ucdavis.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=step5
#SBATCH --error=step5.err
#SBATCH --partition=med
#SBATCH --account=millsgrp

# PLEASE REMEMBER TO CHANGE EMAIL BEFORE SUBMITTING
# This file should be saved in the same directory as your raw .fastq files.  PEAR barcode files should be text tab delimited with unix endings
# Barcode files should be saved in same working directory as raw .fastq files
# This script can handle up to 4 sets of fastq files
# This script assumes sequencing of the V4 region of 16S using 8 bp barcodes and 515F/806R primers
# This script assumes that kmkalangrp drive has a current version of 97_otus in the 16S_ITS_references folder
# Please place this script file AND all other step script files into your current working directory with the forward fastq(s), reverse fastq(s), 
#             barcode file (s), and mapping file

module load R matplotlib numpy qiime/1.9.1
map="mapping.txt"
cwd=$(pwd)

filter_alignment.py -i $cwd/swarm_otu/pynast_aligned/rep_set_aligned.fasta -o $cwd/swarm_otu/filter_alignment_with_chimera ;

assign_taxonomy.py -i $cwd/swarm_otu/rep_set.fna -t /group/kmkalangrp/16S_ITS_references/97_otus/97_otu_taxonomy.txt -r /group/kmkalangrp/16S_ITS_references/97_otus/97_otus.fasta -o $cwd/swarm_otu/assigned_taxonomy ;

make_otu_table.py -i $cwd/swarm_otu/seqs_otus.txt -o $cwd/swarm_otu/otu_table_with_chimera.biom -e $cwd/swarm_otu/pynast_aligned/rep_set_failures.fasta ;

biom add-metadata -i $cwd/swarm_otu/otu_table_with_chimera.biom -o $cwd/swarm_otu/otu_table_with_chimera_w_tax.biom --observation-metadata-fp $cwd/swarm_otu/assigned_taxonomy/rep_set_tax_assignments.txt --observation-header OTUID,taxonomy --sc-separated taxonomy ;

make_phylogeny.py -i $cwd/swarm_otu/filter_alignment_with_chimera/rep_set_aligned_pfiltered.fasta -o $cwd/swarm_otu/filter_alignment_with_chimera/rep_set_aligned_with_chimera_pfiltered.tre ;

beta_diversity.py -i $cwd/swarm_otu/otu_table_with_chimera_w_tax.biom -t $cwd/swarm_otu/filter_alignment_with_chimera/rep_set_aligned_with_chimera_pfiltered.tre -o $cwd/swarm_otu/unifrac ;

summarize_taxa.py -o $cwd/swarm_otu/summary_relative_with_chimera/ -i $cwd/swarm_otu/otu_table_with_chimera_w_tax.biom -m $cwd/$map ;

beta_diversity_through_plots.py -i $cwd/swarm_otu/otu_table_with_chimera.biom -m $cwd/$map -o $cwd/swarm_otu/Beta_filter_with_chimera -t $cwd/swarm_otu/filter_alignment_with_chimera/*pfiltered.tre --color_by_all_fields ;

make_emperor.py -i $cwd/swarm_otu/Beta_filter_with_chimera/weighted_unifrac_pc.txt -o $cwd/swarm_otu/Beta_filter_with_chimera/weighted_unifrac_emperor_pcoa_plots/ -m $cwd/$map --ignore_missing_samples --add_unique_columns ;

biom convert -i $cwd/swarm_otu/otu_table_with_chimera_w_tax.biom -o $cwd/swarm_otu/otu_table_with_chimera_w_tax.txt --to-tsv --header-key taxonomy ;

