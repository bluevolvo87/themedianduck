---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: true
output:
  blogdown::html_page:
    toc: true
    toc_depth: 1
description: ""
---


```{r, echo = FALSE, include = FALSE}
library(here)
here("static")

preamble_dir <- here("static", "code", "R", "preamble")
preamble_file  <- "post_preamble.R"

source(file.path(preamble_dir, preamble_file))
source(file.path(preamble_dir, "database_preamble.R"))
source(file.path(preamble_dir, "graphics_preamble.R"))
source(file.path(preamble_dir, "google_sheets.R"))

style_dir <- here("static", "code", "R", "style")
source(file.path(style_dir, "ggplot_theme.R"))
source(file.path(style_dir, "reactable_theme.R"))
```


# Your Task

# Episode Recap

# Series Scoreboard Tracker

# Gamble's Gamble

# What Have We Learnt Today?

:::{.infobox .today}
We've learnt that:

- Little
- Alex 
- Horne
:::