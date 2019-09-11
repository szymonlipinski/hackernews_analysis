library(tidyverse)
library(vroom)

dataDir <- "/home/data/hn"

data <- as_tibble(data.frame())

for(fname in list.files(dataDir)) {
  fpath <- file.path(dataDir, fname)
  print(paste("Reading file ", fpath))
  
  df <- vroom(fpath)
  
  print(object.size(df), units = "auto", standard = "SI")
  data <- data %>% rbind(df)
  print(object.size(data), units = "auto", standard = "SI")
  rm(df)
}

# removing duplicates
print("Removing duplicates")
data <- data %>% distinct(.keep_all=TRUE)

write_csv(data, "data.csv", col_names=TRUE)

rm(data)