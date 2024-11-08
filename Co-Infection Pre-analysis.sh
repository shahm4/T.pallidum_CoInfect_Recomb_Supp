#Co-Infection Pre-Analysis

##Co-Infection Variant Calling Analysis
#!/bin/bash

# Unzip fastq.gz files
gunzip *.fastq.gz

# Build bowtie2 index from FASTA (assuming TP0865_Gastric_P3ref.fasta exists)
# Adjust FASTA file and Output file name accordingly!
bowtie2-build TP0865_P2ref.fasta TP0865_P2ref

# Downsample and trim fastq files
for R1_fastq in *_R1.fastq; do
    base=$(basename $R1_fastq _R1.fastq)
    
    # Downsample R1 and R2 fastq files
    seqtk sample -s 100 ${base}_R1.fastq 10000 > ${base}_DS_R1.fastq
    seqtk sample -s 100 ${base}_R2.fastq 10000 > ${base}_DS_R2.fastq
    
    # Trim downsampled fastq files
    trimmomatic PE -threads 16 ${base}_DS_R1.fastq ${base}_DS_R2.fastq \
    ${base}_trim_R1.fastq ${base}_trim_unpaired_R1.fastq \
    ${base}_trim_R2.fastq ${base}_trim_unpaired_R2.fastq \
    ILLUMINACLIP:/usr/local/opt/trimmomatic/share/trimmomatic/adapters/Concatenated.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:75
    
    # Clean up intermediate files
    rm ${base}_DS_R1.fastq ${base}_DS_R2.fastq
done

# Process downsampled and trimmed fastq files with bowtie2
for R1_trim_fastq in *_trim_R1.fastq; do
    base=$(basename $R1_trim_fastq _trim_R1.fastq)
    
    # Run bowtie2 alignment
    bowtie2 -x TP0865_P2ref -1 ${base}_trim_R1.fastq -2 ${base}_trim_R2.fastq -N 0 -p 20 > ${base}.sam 
    
    # Convert sam to bam
    samtools view -bS ${base}.sam > ${base}.bam
    
    # Sort bam file
    samtools sort -o ${base}.sorted.bam ${base}.bam
    
    # Optionally, remove intermediate files
    rm ${base}.sam ${base}.bam ${base}_trim_unpaired_R1.fastq ${base}_trim_unpaired_R2.fastq
done

# Optionally, gzip fastq files again
gzip *.fastq

mv *_trim_R1.fastq.gz /Users/greningerlab03/Desktop/fastq/P2ref/P2_trimmed
mv *_trim_R2.fastq.gz /Users/greningerlab03/Desktop/fastq/P2ref/P2_trimmed
mv *.sorted.bam /Users/greningerlab03/Desktop/fastq/P2ref/P2_mapped


READ ME:
1) Unzipping and indexing: The script starts by unzipping all .fastq.gz files and then builds the bowtie2 index from TP0865_Gastric_P3ref.fasta.
2) Downsampling and trimming: It then loops through each _R1.fastq file to downsample using seqtk and trim using trimmomatic. Intermediate files 
   from downsampling are cleaned up after trimming.
3) Bowtie2 alignment: Next, it processes the trimmed and downsampled fastq files with bowtie2 for alignment. SAM files are generated and then 
   converted to BAM format and sorted using samtools.
4) Cleanup: Intermediate files (such as SAM, BAM, trimmed fastq files) are optionally removed to save disk space after sorting.
5) Gzipping: Finally, all remaining .fastq files are gzipped again to maintain data organization.






