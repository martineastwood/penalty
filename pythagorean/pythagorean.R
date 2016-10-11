library(XML)
library(ggplot2)

setwd('xxxxxxxxxx')

source(paste0(getwd(), '/pythagorean_theme.R'))

competition='English Premier League'
url='http://www.statto.com/football/stats/england/premier-league/2014-2015/table'

df <- readHTMLTable(url, header=TRUE, stringsAsFactors=FALSE)[[1]]
df <- df[2:nrow(df), c(2, 3, 8, 9, 24)]
names(df) <- c('team', 'played', 'goals_for', 'goals_away', 'points')
row.names(df) <- NULL

df$goals_for <- as.numeric(df$goals_for)
df$goals_away <- as.numeric(df$goals_away)
df$played <- as.numeric(df$played)
df$points <- as.numeric(df$points)

df$pythag <- round(df$goals_for^1.22990463163253 / 
                     (df$goals_for^1.16792760632132 + df$goals_away^1.20053157314425) *
                     2.29761008220905 * df$played, 2)

df$residual <- round(df$points - df$pythag, 2)

df <- df[order(df$residual, decreasing = TRUE), ]

df$team <- factor(as.character(df$team), levels = as.character(df$team))
df$team <- factor(df$team, levels=rev(levels(df$team)) )

palette <- ifelse(df$residual < 0, 
                  rgb(239/245, 14/256, 0/256, 1), 
                  rgb(65/245, 157/256, 40/256, 1))

labels <- ifelse(df$residual > 0, paste0('+', df$residual), df$residual)
text_pos <- ifelse(df$residual < 0, -0.5, 0.5)
axis_pos <- ifelse(df$residual < 0, 0.2, -0.2)
axis_hjust <- ifelse(rev(df$residual) > 0, 1, 0)

ggplot(df, aes(y=residual, x=team, fill=team)) +
  geom_bar(stat='identity') +
  coord_flip() + 
  scale_fill_manual(values=rev(palette)) +
  guides(fill=FALSE) +
  scale_x_discrete(name="") +
  scale_y_continuous(name="Difference between actual and expected points") +
  geom_text(aes(x=team, y=residual+text_pos, 
                ymax=residual, label=labels), 
            position = position_dodge(width=1), 
            face='bold',
            size=5,
            colour = pythag_colours$text) +
  theme_pythag() +
  geom_text(aes(x=team, y=axis_pos, ymax=residual, label=team), 
            position = position_dodge(width=1),
            hjust = axis_hjust, 
            face='bold',
            size=5,
            colour = pythag_colours$text) +
  ggtitle(paste0(competition, '\n', 'Difference Between Expected And Actual Points'))

ggsave(paste0(competition, ".png"))