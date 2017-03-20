# MillsLabQIIME
Code used by the Mills lab for 16S rRNA gene sequencing analysis

To use, please load all batch files into the directory containing your PEAR barcode file, your QIIME mapping file, and your Illumina output fastq files.  Edit Step 1, 3, and 5 to contain your file names.  Please edit the email line to your email for all files.

9/19/16 - The current version of the pipeline used swarm OTU picking and chimera checking.  Data should be 250 PE Illumina sequencing reads of the V4 region of the 16S rRNA gene.  We currently use 8 bp barcodes. Separate batch files parallelize steps that can be run in parallel.
