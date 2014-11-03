# load data into data.frame
df <- read.csv('http://www.football-data.co.uk/mmz4281/1314/E0.csv')

# munge data into format compatible with glm function
df <- apply(df, 1, function(row){
  data.frame(team=c(row['HomeTeam'], row['AwayTeam']),
             opponent=c(row['AwayTeam'], row['HomeTeam']),
             goals=c(row['FTHG'], row['FTAG']),
             home=c(1, 0))
})
df <- do.call(rbind, df)

# ensure we've not ended up with factors!
df$goals <- as.numeric(as.character(df$goals))

# fit the model
model <- glm(goals ~ home + team + opponent, 
             family=poisson(link=log), data=df)

# let's make some predictions!
av_home_goals <- predict(model, 
                      data.frame(home=1, team="Man City", 
                                 opponent="Man United"), 
                      type="response")

av_away_goals <- predict(model, 
                      data.frame(home=0, team="Man United", 
                                 opponent="Man City"), 
                      type="response")

# get probabilities per goal
home_goals <- dpois(0:10, av_home_goals) 
away_goals <- dpois(0:10, av_away_goals)

# convert probability vectors into score matrix
m <- home_goals %o% away_goals

# get probabilities for home, draw, away win
draw <- sum(diag(m))
away <- sum(m[upper.tri(m)])
home <- sum(m[lower.tri(m)])










