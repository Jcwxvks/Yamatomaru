options(repos = "https://cloud.r-project.org/")
setwd("D:/Biomedical Data Science/BMDSIS/krusei_depth")
files <- list.files(path = "D:/Biomedical Data Science/BMDSIS/krusei_depth", pattern = "\\.txt$", full.names = TRUE)
genes_of_interest <- read.csv("Genes-of-interests-Ckrusei.csv")
gff <- "C_krusei.gff"

samtools_depth_mean_coverage <- function(samtools_depth_file, gff_file){  
  cluster <- read.table(samtools_depth_file)  
  library(rtracklayer)
  track <- import(gff_file)
  print(head(track))
  cluster_ranges <- data.frame(seqnames(track), start(track), end(track), track$Name)  
  all_range_means <- numeric()
  for(i in 1:nrow(cluster_ranges)){
    range_of_interest <- cluster_ranges$start.track[i] : cluster_ranges$end.track[i]
    subset1 <- subset(cluster, subset = cluster_ranges$seqnames.track[i] == cluster$V1 & cluster$V2 %in% range_of_interest)
    range_mean <- mean(subset1$V3)
    all_range_means <- c(all_range_means, range_mean)
    print(i)
  }  
  cluster_ranges <- cbind(cluster_ranges, all_range_means)
  return(cluster_ranges)
}

for(file in files){
  cluster_ranges <- samtools_depth_mean_coverage(file, gff)
  cluster_ranges <- merge(cluster_ranges, genes_of_interest, by.x = "track.Name", by.y = "Ckrusei.ID", all.x = T)
  write.csv(cluster_ranges, paste0(file,".csv"))
}
