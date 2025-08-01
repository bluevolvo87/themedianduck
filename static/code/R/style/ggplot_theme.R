# Defining a standardised plotting theme for ggplot

quack_theme <- function(){
    theme_gray() +
        theme(
        text = element_text(family = "elite", size = 20), #Font is typewriter based, and base size 20
        legend.position = 'bottom' #Legend displayed at the bottom
        )
    }