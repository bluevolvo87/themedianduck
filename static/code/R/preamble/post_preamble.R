

knitr::opts_chunk$set(echo = FALSE, 
                      error = FALSE,
                      warning = FALSE,
                      message = FALSE,
                      root.dir = "../",
                      tidy = FALSE,
                      class.source = "watch-out",
                      class.output = "watch-out",
                      fig.align = "center",
                      fig.topcaption=TRUE,
                      out.width = "75%",
                      cache = TRUE,
                      cache.lazy = FALSE
                      
)


options(width = 1000)

suppressPackageStartupMessages(library(kableExtra))

# Variable substituion in strings
suppressPackageStartupMessages(library(glue))

library(scales)