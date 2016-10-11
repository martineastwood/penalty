library(lpSolve)
library(RCurl)
library(stringr)
library(jsonlite)
library(dplyr)

df <- "https://fantasy.premierleague.com/drf/bootstrap-static" %>% 
  getURL %>% 
  fromJSON %>% 
  .$elements %>% 
  data.frame %>% 
  mutate(now_cost = now_cost / 10)

# The vector to optimize on
objective <- df$total_points

# Fitting Constraints
num_gk <- 2
num_def <- 5
num_mid <- 5
num_fwd <- 3
max_cost <- 100

# Create vectors to constrain by position
df$Goalkeeper <- ifelse(df$element_type == "1", 1, 0)
df$Defender <- ifelse(df$element_type == "2", 1, 0)
df$Midfielder <- ifelse(df$element_type == "3", 1, 0)
df$Forward <- ifelse(df$element_type == "4", 1, 0)

# Create constraint vectors to constrain by max number of players allowed per team
team_constraint <- unlist(lapply(unique(df$team_code), function(x, df){
  ifelse(df$team_code==x, 1, 0)
}, df=df))

# next we need the constraint directions
const_dir <- c("=", "=", "=", "=", rep("<=", 21))

# Now put the complete matrix together
const_mat <- matrix(c(df$Goalkeeper, df$Defender, df$Midfielder, df$Forward, 
                      df$now_cost, team_constraint), 
                    nrow=(5 + length(unique(df$team_code))), byrow=TRUE)
const_rhs <- c(num_gk, num_def, num_mid, num_fwd, max_cost, rep(3, 20))

# then solve the matrix
x <- lp ("max", objective, const_mat, const_dir, const_rhs, all.bin=TRUE, all.int=TRUE)

# And this is our team!
solution <- df %>% 
  mutate(solution = x$solution) %>% 
  filter(solution == 1) %>% 
  select(web_name, element_type, now_cost, total_points) %>% 
  arrange(element_type) 

print(solution)

solution %>% summarise(total_price = sum(now_cost)) %>% print
solution %>% summarise(total_proints = sum(total_points)) %>% print

