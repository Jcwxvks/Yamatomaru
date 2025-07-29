setwd("D:/Biomedical Data Science/BMDSIS/krusei_depth")
files <- list.files(path = "D:/Biomedical Data Science/BMDSIS/krusei_depth/CSVs", pattern = "\\.csv$", full.names = TRUE)
library(dplyr)

for(i in 1:length(files)){
  df <- read.csv(files[i], row.names = 1)
  df <- df %>%
    group_by(seqnames.track.) %>%
    mutate(
      avg_read_depth = mean(all_range_means, na.rm = TRUE), 
      depth_ratio = all_range_means / avg_read_depth
    ) %>%
    ungroup()%>%
    arrange(desc(depth_ratio))%>%
    distinct(Gene.name, .keep_all = TRUE) %>%
    filter(!is.na(Gene.name))
  
  write.csv(df, gsub(".depth.csv", ".annotated.csv", files[i]), row.names = F)
}
