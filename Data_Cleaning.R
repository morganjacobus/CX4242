df_ga <- subset(df, state_text=="Georgia", select = description:value)
df_toy <- subset(df,description=='Accommodation and Food Services' & group_name == 'Age',select= description:value)
df_toy_cleaned <- subset(df_toy, description.1 != "not reported")
df_toy_cleaned$indicator <- 1
groups <- unique(df_toy_cleaned["description.1"])

industry <- unique(df$description)
predictors <- unique(df$group_name)

colnames.1 <-  as.vector(groups[["description.1"]])
colnames.2 <- c("value")
colnames.3 <- c(colnames.1,colnames.2)

df.new = data.frame(matrix(ncol = length(colnames.3),nrow=nrow(df_toy_cleaned)))
colnames(df.new) <- colnames.3

for (row in 1:nrow(df_toy_cleaned)) {
    temp <- df_toy_cleaned[row,"description.1"]
    dafw <- df_toy_cleaned[row,"value"]
    ind <- df_toy_cleaned[row,'indicator']
    row.vals <- vector(mode='numeric',length = length(df.new))
    names(row.vals) <- colnames.3
    for (i in 1:length(colnames.3)) {
      if (temp == colnames.3[i]) {
        row.vals[i] <- 1
      } else {row.vals[i] <- 0}
    }
    
    row.vals[length(colnames.3)] <- dafw
    df.new[row,] <- row.vals
}                       