library(tidyverse)
library(phylotools)
library(reshape2)
library(dplyr)
library(stringr)

`%!in%` <- negate(`%in%`)

# Set working directory
path <- "/Users/greningerlab03/Desktop/TP0865_all_fastq/raw_fastq/merged/fastas/" 
fastas <- list.files("/Users/greningerlab03/Desktop/TP0865_all_fastq/raw_fastq/merged/fastas", pattern=".fasta")


df <- as.data.frame(matrix(nrow=0, ncol=4))
colnames(df) <- c("seq.name", "seq.text", "n", "merged_reads")


#i <- fastas[1]
for (i in fastas[0:length(fastas)]) { #seq243 errored for some reason, had seqeunce. But was P3 so meh. 
  print(match(i, fastas))
  f <- phylotools::read.fasta(paste0(path, i))
  g <- f %>% group_by(seq.text) %>% summarize(n=n()) %>% arrange(desc(n))
  g$sample <- i
  g$merged_reads <- sum(g$n)
  df <- rbind(df, g)
}

write_csv(df, "~/Desktop/merged_reads.csv")

#remove anything that has Ns: 
df2 <- df %>% filter(!str_detect(seq.text, "N"))

#remove anything without <0.1% abundance (arbitrary, just to make calculations easier)
df2$perc <- df2$n*100 / df2$merged_reads
df3 <- df2 %>% filter(perc > 0.1)

unique_vars <- df3 %>% group_by(seq.text) %>% summarize(n_samples=n())
unique_vars$name <- paste0("vars", str_pad(rownames(unique_vars), 4, side="left", pad=0))

df4 <- left_join(unique_vars, df3)
#remove all P3s
#df4 <- df4 %>% filter(!str_detect(sample, "P3"))
df4$sample <- gsub(".fasta", "", df4$sample)
df4$sample <- gsub("_merged", "", df4$sample)
delim <- as.data.frame(str_split_fixed(df4$sample, "_", 2))
df4$merge_strictness <- delim$V2
df4$sample <- delim$V1
df4$seq.name <- paste0(df4$sample, "__", df4$merge_strictness, "__perc", round(df4$perc, 1), "__", df4$name)

delim2 <- as.data.frame(str_split_fixed(df4$sample, "-", 4))
ctrl <- df4 %>% filter(str_detect(sample, "CS") | str_detect(sample, "LS"))
biop <- df4 %>% filter(sample %!in% ctrl$sample)

biop_loose_P1 <- biop %>% filter(str_detect(sample, "P1")) %>% filter(merge_strictness == "loose") %>% filter(perc >1)
biop_loose_P2 <- biop %>% filter(str_detect(sample, "P2")) %>% filter(merge_strictness == "loose") %>% filter(perc >1)

dir.create("~/Desktop/sample_analysis")
dat2fasta(data.frame(seq.name=biop_loose_P1$seq.name, seq.text=biop_loose_P1$seq.text), "~/Desktop/sample_analysis/biopsies_loose_P1.fasta")
dat2fasta(data.frame(seq.name=biop_loose_P2$seq.name, seq.text=biop_loose_P2$seq.text), "~/Desktop/sample_analysis/biopsies_loose_P2.fasta")

ctrl_loose_P1 <- ctrl %>% filter(str_detect(sample, "P1")) %>% filter(merge_strictness == "loose") %>% filter(perc >1)
ctrl_loose_P2 <- ctrl %>% filter(str_detect(sample, "P2")) %>% filter(merge_strictness == "loose") %>% filter(perc >1)

dir.create("~/Desktop/ctrl_analysis")
dat2fasta(data.frame(seq.name=ctrl_loose_P1$seq.name, seq.text=ctrl_loose_P1$seq.text), "~/Desktop/ctrl_analysis/ctrl_loose_P1.fasta")
dat2fasta(data.frame(seq.name=ctrl_loose_P2$seq.name, seq.text=ctrl_loose_P2$seq.text), "~/Desktop/ctrl_analysis/ctrl_loose_P2.fasta")

# manually observe sequence of interest (>1 % in more than 1 replicate)
# variant sequence ID with >1% in more than 1 replicate
id <- c(3483, 4161, 4186, 3466, 1643, 3128, 1612, 3942, 3946, 4743, 4753, 4626, 4652, 4662, 4094, 3459, 3462, 1643, 3128, 4705, 4708, 4764)
id2 <- paste0("vars", id)

all_data <- rbind(biop, ctrl) 
plot <- all_data %>% filter(merge_strictness == "loose")
cast <- dcast(plot, name ~ sample, value.var="perc")

# Sequence variants present in all sample
write_csv(cast, "~/Desktop/amplicon_vars_per_sample.csv")
