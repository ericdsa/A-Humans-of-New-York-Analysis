This program collects posts from a public page (Humans of New York), predicts the like count for the next posts, and performs text mining on the most recent posts.

The like count prediction works in the following process:
1) Collects the 100 most recent posts of Humans of New York from Facebook (NOTE: needs a valid Facebook API key not included in this repository)
2) Calculates a fit for the posts and predicts the next 20 posts.
3) Plots the original like counts and average like count on a webpage via GoogleVis, which formats it like a Google Chart.

The text mining works in the following process:
1) Collects messages and puts them in a corpus
2) Cleans the corpus for punctuation, common english words, and other instances of extra characters
3) Creates a wordcloud based on the frequency of words
