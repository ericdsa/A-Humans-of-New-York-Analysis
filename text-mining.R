"
This program collects the 100 most recent posts of Humans of New York from Facebook.
It then calculates a fit based on the ARIMA model, predicts the like counts for the 
next 20 posts, and an error bound. Finally, it plots: Original like count, prediction,
and error bound.
"

# loads necessary libraries and token
library(Rfacebook)
library(tm)
library(wordcloud)

# load oauth token
load("./oauth-tokens/fb_oauth")

# gets range of dates to pull posts from
current_date = Sys.Date()
one_year_ago = as.Date(-365, Sys.Date())
number_posts = 100

# pulls all posts of Humans of New York from current date to one year ago
HONY <- getPage(page="humansofnewyork", fb_oauth, n = number_posts, since=one_year_ago, until=current_date)

# stores messages in posts in a corpus
messages <- as.data.frame(HONY["message"])
messages_corpus <- Corpus(VectorSource(messages))

# clean the corpus by mapping text mining functions
messages_corpus <- tm_map(messages_corpus, tolower)
messages_corpus <- tm_map(messages_corpus, removePunctuation)
messages_corpus <- tm_map(messages_corpus, removeWords, stopwords("english"))
messages_corpus <- tm_map(messages_corpus, stemDocument)
messages_corpus <- tm_map(messages_corpus, PlainTextDocument)

# store word vs frequency data
messages_tdm <- TermDocumentMatrix(messages_corpus)
messages_matrix <- as.matrix(messages_tdm)
wordFreq <- sort(rowSums(messages_matrix), decreasing = TRUE)

# plot a wordcloud
wordcloud(words = names(wordFreq), freq = wordFreq, min.freq = 10, random.order = F)
