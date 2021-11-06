library(readr)

url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/breast-cancer-wisconsin.data"
df <- read_table(url, col_names=FALSE)
dplyr::glimpse(df)


write_csv(df,"wisconsin_original.csv")