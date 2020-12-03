# Merge code

url = "https://github.com/favstats/USElection2020-EdisonResearch-Results/raw/main/data/latest/presidential.csv"
results2020 = read.csv(url)

megafile = read.table("eday-covid.txt", header = TRUE)

library(dplyr)
results = left_join(results2020, megafile, by = "fips")

