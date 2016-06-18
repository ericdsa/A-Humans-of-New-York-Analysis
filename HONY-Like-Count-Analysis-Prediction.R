"
This program collects the 100 most recent posts of Humans of New York from Facebook.
It calculates a fit for the posts and predicts the next 20 posts. Finally, it plots 
the original like counts and average like count on a webpage via GoogleVis, which 
formats it like a Google Chart.
"

# loads necessary library and token
library(Rfacebook)
library(googleVis)

# gets range of dates to pull posts from
current_date = Sys.Date()
one_year_ago = as.Date(-365, Sys.Date())
number_posts = 100

# pulls all posts of Humans of New York from current date to one year ago
HONY <- getPage(page="humansofnewyork", n = number_posts, since=one_year_ago, until=current_date)

# selects likes count from posts
Likes <- rev(HONY$likes_count)

# stores likes count data in a time series
HONYTS <- ts(data=Likes, frequency = 10)

# makes a fit for NYTS and predicts future values
posts_forward <- number_posts / 5
fit <- arima(HONYTS, order = c(1,0,0), list(order = c(2,1,0), period = 10))
fore <- predict(fit, n.ahead = posts_forward)
upper_bound <- fore$pred + 0.5 * fore$se
lower_bound <- fore$pred - 0.5 * fore$se

# stores time series as vectors for scatter plot usage
forecast_vector <- as.vector(fore$pred)
upper_vector <- as.vector(upper_bound)
lower_vector <- as.vector(lower_bound)

# forecast list
Likes <- append(Likes, rep(NA, posts_forward))
Prediction <- append(rep(NA, number_posts), forecast_vector)
Upper_Bound <- append(rep(NA, number_posts), upper_vector)
Lower_Bound <- append(rep(NA, number_posts), lower_vector)
scatter_data <- data.frame(x=c(1:(number_posts+posts_forward)), Likes, Prediction, Upper_Bound, Lower_Bound)
scatter_chart <- gvisScatterChart(scatter_data, options = list(legend = "{position: 'right'}",
                                                               pointSize = 0,
                                                               lineWidth = 2,
                                                               title = "Likes Count",
                                                               vAxis = "{title: 'Number of Likes'}",
                                                               hAxis = "{title: 'Post Number', viewWindowMode:'explicit', viewWindow:{min:0, max:125}}",
                                                               width = 1200,
                                                               height = 600,
                                                               series = "{
                                                                 0:{color: 'blue', visibleInLegend: true},
                                                                 1:{color: 'green', visibleInLegend: true},
                                                                 2:{color: 'orange', visibleInLegend: true},
                                                                 3:{color: 'red', visibleInLegend: true}
                                                               }"))

plot(scatter_chart)
