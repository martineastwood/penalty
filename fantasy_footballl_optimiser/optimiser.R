library(lpSolve)
library(stringr)
library(RCurl)
library(jsonlite)
library(plyr)

# scrape the data
df <- ldply(1:521, function(x){
  # Scrape responsibly kids, we don't want to ddos
  # the Fantasy Premier League's website
  Sys.sleep(0.10)
  print(sprintf('Scraping player %s', x))
  url <- sprintf("http://fantasy.premierleague.com/web/api/elements/%s/?format=json", x)
  json <- fromJSON(getURL(url))
  json$now_cost <- json$now_cost / 10
  data.frame(json[names(json) %in% c('web_name', 'team_name', 'type_name', 
                                     'now_cost', 'total_points')])
})
# Tidy it up as Evra still in there
df <- subset(df, !web_name %in% c('Evra'))

# The vector to optimize on
objective <- df$total_points

# Fitting Constraints
num_gk <- 2
num_def <- 5
num_mid <- 5
num_fwd <- 3
max_cost <- 100

# Create vectors to constrain by position
df$Goalkeeper <- ifelse(df$type_name == "Goalkeeper", 1, 0)
df$Defender <- ifelse(df$type_name == "Defender", 1, 0)
df$Midfielder <- ifelse(df$type_name == "Midfielder", 1, 0)
df$Forward <- ifelse(df$type_name == "Forward", 1, 0)

# Create constraint vectors to constrain by max number of players allowed per team
team_constraint <- unlist(lapply(unique(df$team_name), function(x, df){
  ifelse(df$team_name==x, 1, 0)
}, df=df))

# next we need the constraint directions
const_dir <- c("=", "=", "=", "=", rep("<=", 21))

# Now put the complete matrix together
const_mat <- matrix(c(df$Goalkeeper, df$Defender, df$Midfielder, df$Forward, 
                      df$now_cost, team_constraint), 
                    nrow=(5 + length(unique(df$team_name))), byrow=TRUE)
const_rhs <- c(num_gk, num_def, num_mid, num_fwd, max_cost, rep(3, 20))

# then solve the matrix
x <- lp ("max", objective, const_mat, const_dir, const_rhs, all.bin=TRUE, all.int=TRUE)

# And this is our team!
print(arrange(df[which(x$solution==1),], desc(Goalkeeper), desc(Defender), 
              desc(Midfielder), desc(Forward), desc(total_points)))
print(str_c('Total Price: ', sum(df[which(x$solution==1), 'now_cost'])))
print(str_c('Total Points: ', sum(df[which(x$solution==1), 'total_points'])))