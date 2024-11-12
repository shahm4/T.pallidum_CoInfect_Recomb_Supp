#!/bin/bash

# Recombination Analysis
# Workflow for adaptor trimming and merging reads

# Create necessary directories for merged files and FASTA outputs
mkdir -p merged/fastas

# Trim and merge reads
for i in *R1.fastq.gz; do
    # Extract the base name from the R1 file
    base=$(basename "$i" _R1.fastq.gz)
    
    # Check if corresponding R2 file exists
    if [[ -f "${base}_R2.fastq.gz" ]]; then
        # Merge reads using bbmerge.sh
        bbmerge.sh in="${base}_R1.fastq.gz" in2="${base}_R2.fastq.gz" out="./merged/${base}_merged_loose.fastq.gz" adapters=adapters.fasta loose=t
        
        # Check if merging was successful
        if [[ $? -ne 0 ]]; then
            echo "Error merging files for ${base}. Skipping to next."
            continue
        fi
        
    else
        echo "Warning: Corresponding R2 file for ${base} not found. Skipping."
    fi
done

# Convert merged FASTQ files to FASTA format using seqtk
for j in ./merged/*.fastq.gz; do
    # Extract the base name from the merged FASTQ file
    base2=$(basename "$j" .fastq.gz)
    
    # Convert FASTQ to FASTA using any2fasta
    any2fasta "$j" > "./merged/fastas/${base2}.fasta"
    
    # Check if conversion was successful
    if [[ $? -ne 0 ]]; then
        echo "Error converting ${j} to FASTA format."
    fi
done

echo "Workflow completed successfully."
