---
title: 'Strength in Data: Connecting to the Taskmaster Database'
author: Christopher Nam
date: '2024-07-10'
slug: []
categories: ["Getting Started", "Introduction", "Beginner", "Setup"]
tags:
  - Introduction
  - Setup
  - Beginner
  - Getting Started
draft: no
output:
  blogdown::html_page:
    toc: true
    toc_depth: 1
---



# Your Task

> Successfully connect to the Taskmaster database from within `R`. Fastest wins; your time starts now!

# Introduction and Objective

This article provides an overview of *Trabajo de las Mesas*, a pivotal Taskmaster database that will be central to performing a multitude of analysis and questions that we may want to answer regarding Taskmaster. TOC

The article will also provide guidance on how to connect to the database from within <R>.

# *Trabajo de las Mesas* Database

[*Trabajo de las Mesas*](https://tdlm.fly.dev/) (TdlM^\[Taskmaster fanatics will know that this is in reference to the hint in S2E5's task *Build a bridge for the potato.*, which has since become one of key pieces of advice for all Taskmaster contestants. It has been suitably adapted for working on data tables in a database, rather than a piece of furniture.\]) provides a plethora of data associated with Taskmaster in a database format. Data included in the database includes information pertaining to a series, episode, conntestant, task attempts, and even profanity uttered by a contestant.

The exhaustive nature of the data truly opens the door to potential questions we may want to answer in the Taskmaster universe. For this reasons, I am immensely grateful to the contributors of this project.

## Data Quality

As with any analysis and modelling project, the insights and conclusions generated are only as good as the data supplied to it.

I do not know the specifics regarding how this data is collated and reviewed (my intention is that there will be a future article dedicated to this), but believe the data is inputted by fellow (hardcore) Taskmaster fans from [taskmaster.info](https://taskmaster.info/), an equally exhaustive Taskmaster resource. .

For now, and to not derail me from my initial interest and excitement on The Median Duck project, I will assume that the data is of high quality (accurate, consistent etc.).

If there are any instances where the data quality is suspect, and/or a contradictory insight or conclusion is identified, a deep dive will likely occurr and the deep dive process will like provide useful insight for any inspiring individuals hoping to get into data analytics more.

## Why This Datasource?

As the Taskmaster is a global phenomena, there is no doubt other datasources that could be used for this project. Most noticeably, Jack Bernhadt has an exhaustive [Google sheet document](https://docs.google.com/spreadsheets/d/1Us84BGInJw8Ef32xCVSVNo1W5mjri9CpUffYfLnq5xA/edit?usp=sharing) in which similar analysis and modelling could be performed.

However, for the purposes of this project, being able to query from database has several advantages. This includes:

-   Quality: Data being in a structured tabular format which often leads to better data quality
-   Manipulations: Greater manipulation and transformations could potentially be employed (joins, group bys etc)
-   Automation, Repeatability and Scalabilty: if we wanted to repeat the same or similar analysis but on a new subset of data (for example updated data due to a new series being broadcast, or new parameters being employed), it is more convenient to do this in a structured data source such as a database.

However, a database approach is by no means perfect either. The barrier to entry is considerably higher than data stored in a spreadsheet (both adding, manipulating and analysing data), and spreadsheets are good for ad-hoc, interactive analysis.

Considering overall vision of The Median Duck, I believe that a database approach is ideal.

## Potential Areas to Explore in the Future

-   Greater understanding of how the data is being collected.
    -   Is it manual, and are their quality checks in place? Is there any opportunity to automate?
    -   Can we introduce a SLA (service level agreement) of when the data can be expected to be populated. Data associated with more recent seasons don't appear to be present, despite being broadcasted already.
    -   Introduction of an ETL timestamp.
-   Generate a data dictionary page
    -   What tables are available, samples of the data, what the table pertains to, and key columns.
-   A dashboard on data quality.
    -   A highlevel overview of the quality and how recent the data is.

# Connecting to the Database from `R`

## Downloading the `.db` file

It is possible to view and query these the numerous tables in TdlM from the [website itself](https://tdlm.fly.dev/). However, this does not lead to intuitively to repeatable and reproduceable analysis. Connecting to the database from a statistical programming language such as `R` or `python`, naturally leads to repeatablility and reproduceability.

I opting choosing to choose `R` for this project due to my familarity with it, and the high level visualisations and modelling that can be employed.

The tables displayed on the website are powered from the following [database file](https://tdlm.fly.dev/taskmaster.db) which can downloaded and stored locally. The following code chunk downloads the database file locally (based on the repo directory); a corresponding folder location will be created if it does not already exist.


```r
# URL where Database file resides. We will download from here.
db_url <- "https://tdlm.fly.dev/taskmaster.db"

# Where the data will be stored locally
repo_root_dir <- getwd()
db_file_name <- "taskmaster.db"
data_dir <- "Data"

db_data_location <- file.path(repo_root_dir, data_dir, db_file_name)


# Create Data Directory if does not exist
if(!file.exists(file.path(repo_root_dir, data_dir))){
    dir.create(file.path(repo_root_dir, data_dir))
}

# Download file specified by URL, save in the local destination.
if(!file.exists(db_data_location)){
    download.file(url = db_url, destfile = db_data_location, mode = "wb")
}
```

## Connecting to the `.db` file

Now that the database file has been successfully downloaded, we can start to connect to it from `R` directory. The `DBI` package will be employed to establish this connection.


```r
package_name <- "RSQLite"

if(!require(package_name, character.only = TRUE)){
    install.packages(package_name, character.only = TRUE)
} else{
    library(package_name, character.only = TRUE)    
}
```

```
## Loading required package: RSQLite
```

```r
# Driver used to establish database connection
sqlite_driver <- dbDriver("SQLite")

# Making the connection 
tm_db <- dbConnect(sqlite_driver, dbname = db_data_location)
```

If successful, we should be able to list all the tables included in the database.


```r
# List all tables that are available in the database
dbListTables(tm_db)
```

```
##  [1] "attempts"           "discrepancies"      "episode_scores"    
##  [4] "episodes"           "intros"             "measurements"      
##  [7] "normalized_scores"  "objectives"         "people"            
## [10] "podcast"            "profanity"          "series"            
## [13] "series_scores"      "special_locations"  "task_briefs"       
## [16] "task_readers"       "task_winners"       "tasks"             
## [19] "tasks_by_objective" "team_tasks"         "teams"             
## [22] "title_coiners"      "title_stats"
```

## Querying the Database

Now that we are successfully able to connect to the database, we are able to write queries and execute them directly from `R` to access the data. For example:

### A Basic `SELECT` query


```r
# A Basic Select query  on the series table.
query <- "SELECT * FROM series LIMIT 10"

dbGetQuery(tm_db, query)
```

```
##    id     name episodes champion  air_start    air_end studio_start studio_end
## 1  -7  CoC III        0       NA 2024-??-?? 2024-??-??   2023-11-28 2023-11-28
## 2  -6 NYT 2024        0       NA 2024-01-01 2024-01-01   2023-11-27 2023-11-27
## 3  -5 NYT 2023        1       96 2023-01-01 2023-01-01   2022-11-22 2022-11-22
## 4  -4   CoC II        1       87 2022-06-23 2022-06-23   2021-09-15 2021-09-15
## 5  -3 NYT 2022        1       73 2022-01-01 2022-01-01         <NA>       <NA>
## 6  -2 NYT 2021        1       62 2021-01-01 2021-01-01         <NA>       <NA>
## 7  -1      CoC        2       29 2017-12-13 2017-12-20   2017-11-20 2017-11-20
## 8   1 Series 1        6        4 2015-07-28 2015-09-01   2015-03-23 2015-03-25
## 9   2 Series 2        5       11 2016-06-21 2016-07-19         <NA>       <NA>
## 10  3 Series 3        5       16 2016-10-04 2016-11-01         <NA>       <NA>
##    points tasks special TMI
## 1      NA    NA       1  88
## 2      NA    NA       1  87
## 3      76     5       1  66
## 4      66     5       1  46
## 5      68     5       1  47
## 6      62     5       1  12
## 7     164    10       1   6
## 8     436    32       0   1
## 9     417    28       0   2
## 10    386    27       0   3
```

### Advanced query

A more involved query involving `JOIN` and date manipulation


```r
# A join, and data manipulation
query <- "SELECT ts.name,
ts.special as special_flag,
tp.name as champion_name,
tp.seat as chamption_seat,
DATE(ts.studio_end) as studio_end, 
DATE(ts.air_start) as air_start, 
JULIANDAY(ts.air_start) - JULIANDAY(ts.studio_end) as broadcast_lag_days
FROM series ts
LEFT JOIN people tp
ON ts.id = tp.series
AND ts.champion = tp.id
WHERE ts.special <> 1
"

results <- dbGetQuery(tm_db, query)
results
```

```
##         name special_flag    champion_name chamption_seat studio_end  air_start
## 1   Series 1            0  Josh Widdicombe              2 2015-03-25 2015-07-28
## 2   Series 2            0   Katherine Ryan              4       <NA> 2016-06-21
## 3   Series 3            0      Rob Beckett              4       <NA> 2016-10-04
## 4   Series 4            0    Noel Fielding              5       <NA> 2017-04-25
## 5   Series 5            0     Bob Mortimer              2 2017-07-06 2017-09-13
## 6   Series 6            0     Liza Tarbuck              3 2018-03-28 2018-05-02
## 7   Series 7            0   Kerry Godliman              3 2018-07-25 2018-09-05
## 8   Series 8            0      Lou Sanders              3 2019-03-27 2019-05-08
## 9   Series 9            0        Ed Gamble              2 2019-07-24 2019-09-04
## 10 Series 10            0  Richard Herring              5 2020-07-29 2020-10-15
## 11 Series 11            0    Sarah Kendall              5       <NA> 2021-03-18
## 12 Series 12            0 Morgana Robinson              4       <NA> 2021-09-23
## 13 Series 13            0     Sophie Duker              5 2021-09-22 2022-04-14
## 14 Series 14            0    Dara Ó Briain              1 2022-05-05 2022-09-29
## 15 Series 15            0       Mae Martin              5 2022-09-28 2023-03-30
## 16 Series 16            0     Sam Campbell              3 2023-05-12 2023-09-21
##    broadcast_lag_days
## 1                 125
## 2                  NA
## 3                  NA
## 4                  NA
## 5                  69
## 6                  35
## 7                  42
## 8                  42
## 9                  42
## 10                 78
## 11                 NA
## 12                 NA
## 13                204
## 14                147
## 15                183
## 16                132
```

The results of this query already indicate interesting insights, namely that 204 days (approximately 29 weeks) occurred between the studio record and first air date for Series 13, which is a noticeable deviation from prior seasons (greater broadcast lag). Future series also seem delayed, although to a lesser extent. Could the pandemic have initiated this lag? Or where there other production changes that led to this lag?

# Times Up!

And that concludes this task! Hopefully you've been able to connect to the TdlM database directly through `R` and potentially inspired to start performing your own analysis.
