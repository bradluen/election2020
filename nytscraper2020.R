# GitHub:
# https://github.com/bradluen/election2020

scrapenyt = function(state, url){
require(dplyr)
require(rvest)
#url = "https://www.nytimes.com/interactive/2020/11/03/us/elections/results-indiana.html"
webpage = read_html(url)
tbls = html_nodes(webpage, "table")
#this.table = tbls[grep("Monroe", tbls, ignore.case = TRUE)]
this.table = tbls[2]
df = html_table(this.table, fill = TRUE)[[1]]
# Truncate last row
df = df[-nrow(df),]
# Remove duplicate columns
df = df [, !duplicated(colnames(df))]
# Remove blank rows
df = dplyr::filter(df, Margin != "—")
# Change "Tied"
df$Margin = recode(df$Margin, "Tied" = "Biden +0")
# Get numeric margin
results.list = strsplit(as.character(df$Margin), " ")
results.list = matrix(unlist(results.list), byrow = T, ncol = 2)
results.list[, 2] = gsub("<", "+", results.list[, 2])
df$Winner2020 = as.factor(results.list[, 1])
df$Margin2020 = as.numeric(results.list[, 2]) *
  ifelse(df$Winner2020 == "Biden", 1, -1)
# Get numeric voted reported
df$counted = gsub("%", "", df$`Est. votes reported`)
df$counted = gsub(">", "", df$counted)
df$counted = as.numeric(df$counted)
df$votes = as.numeric(gsub(",", "", df$`Total votes`))
df$state = state
# Make sure first column is called "County"
names(df)[1] = "County"
# Keep only necessary columns
df = dplyr::select(df, state, County, Margin2020, votes, counted)
return(df)
}
