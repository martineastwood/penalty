library(RMySQL)

con <- dbConnect(MySQL(),
                 user = 'xxxxxxx',
                 password = 'xxxxxxxx',
                 host = 'xxxxxxxx',
                 dbname='xxxxxxxx')
df <- dbGetQuery(con, "select * from massey_example")

num_teams <- length(unique(c(df$team1, df$team2)))
num_games <- nrow(df)
teams <- unique(c(df$team1, df$team2))

X <- matrix(0, nrow=num_teams, ncol=num_teams)
for(i in 1:nrow(df)){
    h <- match(df$team1[i], teams)
    a <- match(df$team2[i], teams)
    X[h, a] <- X[h, a] - 1
    X[a, h] <- X[a, h] - 1
}

for(i in 1:nrow(X)){
    X[i, i] <- abs(sum(X[i, ]))
}
X[nrow(X), ] <- 1

y <- sapply(teams, function(x, df){
    home <- subset(df, team1 == x)
    away <- subset(df, team2 == x)
    goals_for <- sum(home$team1_goals) + sum(away$team2_goals)
    goals_away <- sum(home$team2_goals) + sum(away$team1_goals)
    goals_for - goals_away
}, df=df)
y[length(y)] <- 0

goals_for <- sapply(teams, function(x, df){
    home <- subset(df, team1 == x)
    away <- subset(df, team2 == x)
    home_goals <- sum(home$team1_goals)
    away_goals <- sum(away$team2_goals)
    home_goals + away_goals
}, df=df)

ratings <- solve(X, y)
names(ratings) <- teams

g <- matrix(0, nrow=num_teams, ncol=num_teams)
for(i in 1:nrow(df)){
    h <- match(df$team1[i], teams)
    a <- match(df$team2[i], teams)
    g[h, a] <- g[h, a] + 1
    g[a, h] <- g[a, h] + 1
}
for(i in 1:nrow(g)){
    g[i, i] <- sum(g[i, ])
}

grpf <- as.data.frame((diag(g) * ratings) - goals_for)
row.names(grpf) <- teams

def_ratings <- solve(g, grpf[ ,1])
off_ratings <- ratings - def_ratings

