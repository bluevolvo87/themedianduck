suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(ggimage))

suppressPackageStartupMessages(library(ggplotify))

suppressPackageStartupMessages (library(gridExtra)) # For grid of figures
library(ggrepel) #Repelling labels

tm_colour_vec <- c("#938c34",  "#800000", "#000000")

# Typewriter font.
suppressPackageStartupMessages(library(showtext))
font_add_google("Special Elite", "elite")
showtext_auto()


# GGplot specifics
theme_set(theme_gray(base_size = 18))

library(htmltools)
library(reactable)
library(sparkline)
library(ggnewscale)
library(cowplot)

library(magick)