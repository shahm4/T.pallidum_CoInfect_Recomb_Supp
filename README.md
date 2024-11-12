# Disseminated syphilis with concurrent infection by and recombination between two _Treponema pallidum_ strains
Lieberman, N. et al. 2024

## **Supplemental Data:**

**TableS1.xlsx** contains the following data:
  1. ddPCR primer/probe sequences
  2. TP0865 primer sequences
  3. TP0865 indexing sequences

**BioSample_Metadata.xlsx** contains the following data:
  1. Sample IDs
  2. Sample Type
  3. Amplicon Region
  4. BioSample Accession
  5. Fastq IDs

**trim_and_merge.sh** : used to trim and merge raw fastq before converting to fasta for TP0865 recombination analysis

**recombination_analysis.R** : used to generate .csv output of variant sequence IDs using fasta files previously generated


### **Whole Genome Sequencing (WGS)**

Sequenced with 2x151bp reads on Illumina Novaseq 6000 or Nextseq 2000. Reads were mapped to SS14 reference NC_021508.1. 

Subsequent analysis was done by reprocessing _T.pallidum_ WGS reads using iterative competitive mapping with Bowtie2 to both Nichols (NC_021490.1) and SS14 (NC_021508.1) references. Variants were called with freebayes v.1.0.2 followed by deduplication with Picard MarkDuplicates, with a sequencing depth of 10. Consensus sequences contextualized by adding them to phylogeny of sequences from Seattle, WA from 2021-22.

* Refer to Reference Files folder for fastas

### Digital droplet PCR (ddPCR)

_dnaA/TP0001_, _tp47/TP0574_, and _TP0136_: Discriminated between Nichols and SS14 Lineages

* Refer to TableS1.xlsx for sequences

### _TP0865_ PCR amplification

To determine linkage between the recombinant regions in TP0865, we designed a pair of overlapping amplicons: Amplicon “A” amplifies a fragment of TP0865 that included a portion of the N-terminal “hatch” domain, the invariant ECL1, and the highly recombinant ECL2. Amplicon “B” amplifies ECL2, ECL3, and ECL4. 

* Refer to file Biosample_Metadata.xlsx : Samples were labelled as P1 and P2 respectively to account for internal quality control. Amplicon B is labelled as P1 and Amplicon A is labelled as P2. 
