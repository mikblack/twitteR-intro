## Helper functions to process tweets and perform sentiment analysis
## Code downloaded/adapted from:
##   https://github.com/pablobarbera/social-media-workshop
#install.packages('tm')
# function to clean the text
clean_tweets <- function(text){
  # loading required packages
  lapply(c("tm", "stringr"), require, c=T, q=T)
  # avoid encoding issues by dropping non-unicode characters
  utf8text <- iconv(text, to='UTF-8', sub = "byte")
  # remove punctuation and convert to lower case
  words <- removePunctuation(utf8text)
  words <- tolower(words)
  # spliting in words
  words <- str_split(words, " ")
  return(words)
}

# a function to classify individual tweets
classify <- function(words, pos.words, neg.words){
  # count number of positive and negative word matches
  pos.matches <- sum(words %in% pos.words)
  neg.matches <- sum(words %in% neg.words)
  return(pos.matches - neg.matches)
}

# but we want to aggregate over many tweets...
classifier <- function(text, pos.words, neg.words){
  # classifier
  scores <- unlist(lapply(text, classify, pos.words, neg.words))
  n <- length(scores)
  positive <- as.integer(length(which(scores>0))/n*100)
  negative <- as.integer(length(which(scores<0))/n*100)
  neutral <- 100 - positive - negative
  cat(n, "tweets:", positive, "% positive,",
      negative, "% negative,", neutral, "% neutral")
}

