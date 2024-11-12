# Disseminated syphilis with concurrent infection by and recombination between two _Treponema pallidum_ strains
Lieberman, N. et al. 2024

## **Supplemental Data:**

**[TableS1.xlsx](./TableS1.xlsx)** contains the following data:
  1. ddPCR primer/probe sequences
  2. TP0865 primer sequences
  3. TP0865 indexing sequences

**[BioSample_Metadata.xlsx](./BioSample_Metadata.xlsx)** contains the following data:
  1. Sample IDs
  2. Sample Type
  3. Amplicon Region
  4. BioSample Accession
  5. Fastq IDs

**[trim_and_merge.sh](./trim_and_merge.sh)** : used to trim and merge raw fastq before converting to fasta for TP0865 recombination analysis

**[recombination_analysis.R](./recombination_analysis.R)** : used to generate .csv output of variant sequence IDs using fasta files previously generated


## **Usage:**
### A. Whole Genome Sequencing (WGS)

The sequencing was performed using 2x151 bp reads on either the Illumina Novaseq 6000 or Nextseq 2000 platforms, with the reads mapped to the SS14 reference (NC_021508.1). 

1. **Reprocessing**: The _T. pallidum_ whole genome sequencing (WGS) reads were reprocessed using iterative competitive mapping with Bowtie2, targeting both the Nichols (NC_021490.1) and SS14 (NC_021508.1) references.
2. **Variant Calling**: Variants were identified using FreeBayes.
3. **Deduplication**: Duplicate reads were removed using Picard MarkDuplicates.
4. **Consensus Sequences**: The resulting consensus sequences were contextualized by incorporating them into a phylogenetic analysis of sequences from Seattle, WA, collected during 2021-22.

* Refer to [Reference Files](./Reference\Files/) folder for fastas

### B. Digital droplet PCR (ddPCR)

_dnaA/TP0001_, _tp47/TP0574_, and _TP0136_ (Discriminated between Nichols and SS14 Lineages)

* Refer to [TableS1.xlsx](./TableS1.xlsx) for sequences

### C. _TP0865_ PCR amplification

To investigate the linkage of recombinant regions in TP0865, we created two overlapping amplicons. 

- **Amplicon A**: This amplicon targets a fragment of TP0865 that encompasses part of the N-terminal "hatch" domain, the invariant ECL1, and the highly recombinant ECL2.
- **Amplicon B**: This amplicon focuses on ECL2, ECL3, and ECL4.

These amplicons are designed to facilitate the analysis of the recombinant regions within TP0865.

1. **Trim and Merge**: Raw fastq files were trimmed and merged using bbMerge.
2. **Fastq to Fasta**: Converting merged fastq files to fasta.
3. **Recombination Analysis**: Aggregate identical sequences, filter out ambiguities and low reads and subsequently calculate proportion of recombinant sequence.

* Refer to file [BioSample_Metadata.xlsx](./BioSample_Metadata.xlsx) : Amplicon B is labelled as P1 and Amplicon A is labelled as P2. 
