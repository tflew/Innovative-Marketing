library(dplyr)
library(stringr)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)

text <- readLines(file.choose())
docs <- Corpus(VectorSource(text))
inspect(docs)
dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)
head(d, 10)

set.seed(1234)
wordcloud(words = d$word, freq = d$freq, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

barplot(d[1:10,]$freq, las = 2, names.arg = d[1:10,]$word,
        col ="lightblue", main =" 2015 Most Frequent Words",
        ylab = "Word frequencies")
