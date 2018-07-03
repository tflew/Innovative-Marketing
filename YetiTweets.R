library(twitteR)
library(ROAuth)
library(httr)
library(csv)
library(tidytext)
library(tidyverse)
library(lubridate)
library(stringr)
library(tm)
library(ggplot2)


# Set API Keys
api_key <- "Insert Key"
api_secret <- "Insert Secret"
access_token <- "Access Token"
access_token_secret <- "Access Token Secret"
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)


# Grab latest tweets
yeti_timeline <- userTimeline("Yeticoolers", n=3200)


#Convert List to data frame
df <- do.call("rbind", lapply(yeti_timeline,as.data.frame))

#Clean text
df$text <- tolower(df$text)
clean_tweet = gsub("&amp", "", df$text)
clean_tweet = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", clean_tweet)
clean_tweet = gsub("@\\w+", "", clean_tweet)
clean_tweet = gsub("[[:punct:]]", "", clean_tweet)
clean_tweet = gsub("[[:digit:]]", "", clean_tweet)
clean_tweet = gsub("http\\w+", "", clean_tweet)
clean_tweet = gsub("[ \t]{2,}", "", clean_tweet)
clean_tweet = gsub("^\\s+|\\s+$", "", clean_tweet) 
df$text <- clean_tweet

df$year_month <- substr(df$created, start=1, stop=7)
df$year <- substr(df$year_month, start=1, stop=4)
df$month <- substr(df$year_month, start=6, stop=7)

tweets <- df$text

#Create Corpus of Tweets
v <- VectorSource(tweets)
docs <- Corpus(v)
docs <- tm_map(docs, PlainTextDocument)
docs <- tm_map(docs, content_transformer(function(x) iconv(x, to='ASCII', sub='byte')))
docs <- tm_map(docs, content_transformer(function(x) tolower(x)))

docs <- tm_map(docs, removeWords, stopwords('en'))
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, stripWhitespace)

tweets <- as.character(unlist(docs$content))

df$text <- tweets


write.csv(df, file="Final_Yeti_Tweets2.csv")
