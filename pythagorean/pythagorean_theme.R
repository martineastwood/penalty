require(grid)

pythag_colours <- list(background = rgb(236/256, 236/256, 236/256, 1),
                       text = rgb(56/256, 56/256, 56/256, 1),
                       line = rgb(101/256, 101/256, 101/256, 1))

theme_pythag <- function (base_size = 16, base_family = "") 
{
    theme_bw(base_size = base_size, 
               base_family = base_family) %+replace% 
        theme(rect = element_rect(fill = pythag_colours$background, 
                                  linetype = 0, 
                                  colour = NA,
                                  size = 0.5),
              text = element_text(family = 'Helvetica', 
                                  face = "bold",
                                  colour = pythag_colours$text, 
                                  size = base_size,
                                  hjust = 0.5, 
                                  vjust = 0.5, 
                                  angle = 0, 
                                  lineheight = 0.9),
              axis.title = element_blank(),
              axis.text.y = element_blank(),
              axis.ticks = element_blank(),
              axis.line.y = element_blank(),
              axis.line.x = element_blank(),
              axis.text.x = element_blank(),
              panel.background = element_rect(),
              panel.grid = element_line(colour = NULL),
              panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              plot.title = element_text())
}