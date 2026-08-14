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

# Save the Date!

# Who's Who?

## Richard Osman's House of Games

## Off Menu

<!-- C1 Start -->
:::: {style="display: flex;"}

::: {style="flex-basis: 25%"}

```{r, fig.cap = "C1"}
#knitr::include_graphics(NULL)
```

:::

::: {style="flex-basis: 75%"}

## Contestant 1
**[Age (at time of first studio recording):]{.ul}** 

**[Occupation:]{.ul}** 

**[ROHOG History (ROHOGH):]{.ul}** 


**[My personal commentary:]{.ul}**


**[Overall personal opinion:]{.ul}**

**[Most Similar Contestant (in my opinion):]{.ul}** 
:::


::::
<!-- C1 End -->

<!-- C2 Start-->
:::: {style="display: flex;"}

::: {style="flex-basis: 75%; justify-content: flex-end;"}


## Contestant 2
**[Age (at time of first studio recording):]{.ul}** 

**[Occupation:]{.ul}** 

**[ROHOG History (ROHOGH):]{.ul}** 



**[My personal commentary:]{.ul}**


**[Overall personal opinion:]{.ul}**

**[Most Similar Contestant (in my opinion):]{.ul}** 

:::

::: {style="flex-basis: 25%"}

```{r, fig.cap = "C2"}
#knitr::include_graphics(NULL)
```
:::

::::
<!-- C2 End -->



# What Have We Learnt Today?

:::{.infobox .today}
We've learnt that:

- Little
- Alex 
- Horne
:::