# Defining a standardised plotting theme for ggplot

quack_theme <- function(){
    theme_gray() +
        theme(
        text = element_text(family = "elite", size = 20), #Font is typewriter based, and base size 20
        plot.title = element_text(hjust = 0, lineheight = 0.5),
        plot.subtitle = element_text(hjust = 0, size = 14, lineheight = 1),
        legend.position = 'bottom' #Legend displayed at the bottom
        ) 
}

library(RColorBrewer)