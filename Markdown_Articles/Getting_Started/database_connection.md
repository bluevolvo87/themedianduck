Strength in Data: Connecting to the Taskmaster Database
================
Christopher Nam
May 23rd 2024

- [Introduction and Objective](#introduction-and-objective)
- [Your Task](#your-task)
- [*Trabajo de las Mesas* Database](#trabajo-de-las-mesas-database)
- [Connecting to the Database from
  `R`](#connecting-to-the-database-from-r)
- [Advanced query](#advanced-query)
- [Times Up!](#times-up)

# Introduction and Objective

This article provides an overview of *Trabajo de las Mesas*, a pivotal
Taskmaster database that will be central to performing a multitude of
analysis and questions that we may want to answer regarding Taskmaster.

The article will also provide guidance on how to connect to the database
from within <R>.

# Your Task

Successfully connect to the Taskmaster database from within `R`. Fastest
wins; your time starts now!l

# *Trabajo de las Mesas* Database

*[Trabajo de las Mesas](https://tdlm.fly.dev/)* (TdlM[^1]) provides a
plethora of data associated with Taskmaster in a database format. Data
included in the database includes information pertaining to a series,
episode, conntestant, task attempts, and even profanity uttered by a
contestant.

The exhaustive nature of the data truly opens the door to potential
questions we may want to answer in the Taskmaster universe. For this
reasons, I am immensely grateful to the contributors of this project.

## Data Quality

As with any analysis and modelling project, the insights and conclusions
generated are only as good as the data supplied to it.

I do not know the specifics regarding how this data is collated and
reviewed (my intention is that there will be a future article dedicated
to this), but believe the data is inputted by fellow (hardcore)
Taskmaster fans from [taskmaster.info](https://taskmaster.info/), an
equally exhaustive Taskmaster resource. .

For now, and to not derail me from my initial interest and excitement on
The Median Duck project, I will assume that the data is of high quality
(accurate, consistent etc.).

If there are any instances where the data quality is suspect, and/or a
contradictory insight or conclusion is identified, a deep dive will
likely occurr and the deep dive process will like provide useful insight
for any inspiring individuals hoping to get into data analytics more.

## Why This Datasource?

As the Taskmaster is a global phenomena, there is no doubt other
datasources that could be used for this project. Most noticeably, Jack
Bernhadt has an exhaustive \[Google sheet document\]
(<https://docs.google.com/spreadsheets/d/1Us84BGInJw8Ef32xCVSVNo1W5mjri9CpUffYfLnq5xA/edit?usp=sharing>)
in which similar analysis and modelling could be performed.

However, for the purposes of this project, being able to query from
database has several advantages. This includes: \* Quality: Data being
in a structured tabular format which often leads to better data quality
\* Manipulations: Greater manipulation and transformations could
potentially be employed (joins, group bys etc) \* Automation,
Repeatability and Scalabilty: if we wanted to repeat the same or similar
analysis but on a new subset of data (for example updated data due to a
new series being broadcast, or new parameters being employed), it is
more convenient to do this in a structured data source such as a
database.

However, a database approach is by no means perfect either. The barrier
to entry is considerably higher than data stored in a spreadsheet (both
adding, manipulating and analysing data), and spreadsheets are good for
ad-hoc, interactive analysis.

Considering overall vision of The Median Duck, I believe that a database
approach is ideal.

## Potential Areas to Explore in the Future

- Greater understanding of how the data is being collected.
  - Is it manual, and are their quality checks in place? Is there any
    opportunity to automate?
  - Can we introduce a SLA (service level agreement) of when the data
    can be expected to be populated. Data associated with more recent
    seasons don’t appear to be present, despite being broadcasted
    already.
  - Introduction of an ETL timestamp.
- Generate a data dictionary page
  - What tables are available, samples of the data, what the table
    pertains to, and key columns.
- A dashboard on data quality.
  - A highlevel overview of the quality and how recent the data is.

# Connecting to the Database from `R`

## Downloading the `.db` file

It is possible to view and query these the numerous tables in TdlM from
the [website itself](https://tdlm.fly.dev/). However, this does not lead
to intuitively to repeatable and reproduceable analysis. Connecting to
the database from a statistical programming language such as `R` or
`python`, naturally leads to repeatablility and reproduceability.

I opting choosing to choose `R` for this project due to my familarity
with it, and the high level visualisations and modelling that can be
employed.

The tables displayed on the website are powered from the following
[database file](https://tdlm.fly.dev/taskmaster.db) which can downloaded
and stored locally. The following code chunk downloads the database file
locally (based on the repo directory); a corresponding folder location
will be created if it does not already exist.

``` r
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

Now that the database file has been successfully downloaded, we can
start to connect to it from `R` directory. The `DBI` package will be
employed to establish this connection.

``` r
package_name <- "RSQLite"

if(!require(package_name, character.only = TRUE)){
    install.packages(package_name, character.only = TRUE)
} else{
    library(package_name, character.only = TRUE)    
}
```

    ## Loading required package: RSQLite

``` r
# Driver used to establish database connection
sqlite_driver <- dbDriver("SQLite")

# Making the connection 
tm_db <- dbConnect(sqlite_driver, dbname = db_data_location)
```

If successful, we should be able to list all the tables included in the
database.

``` r
# List all tables that are available in the database
dbListTables(tm_db)
```

    ##  [1] "attempts"           "discrepancies"      "episode_scores"    
    ##  [4] "episodes"           "intros"             "measurements"      
    ##  [7] "normalized_scores"  "objectives"         "people"            
    ## [10] "podcast"            "profanity"          "series"            
    ## [13] "series_profanity"   "series_scores"      "special_locations" 
    ## [16] "task_briefs"        "task_readers"       "task_winners"      
    ## [19] "tasks"              "tasks_by_objective" "team_tasks"        
    ## [22] "teams"              "title_coiners"      "title_stats"

## Querying the Database

Now that we are successfully able to connect to the database, we are
able to write queries and execute them directly from `R` to access the
data. For example:

### A Basic `SELECT` query

``` r
# A Basic Select query  on the series table.
query <- "SELECT * FROM series LIMIT 10"

results <- dbGetQuery(tm_db, query)
```

``` r
results
```

<div data-pagedtable="false">

<script data-pagedtable-source type="application/json">
{"columns":[{"label":["id"],"name":[1],"type":["int"],"align":["right"]},{"label":["name"],"name":[2],"type":["chr"],"align":["left"]},{"label":["episodes"],"name":[3],"type":["int"],"align":["right"]},{"label":["champion"],"name":[4],"type":["int"],"align":["right"]},{"label":["air_start"],"name":[5],"type":["chr"],"align":["left"]},{"label":["air_end"],"name":[6],"type":["chr"],"align":["left"]},{"label":["studio_start"],"name":[7],"type":["chr"],"align":["left"]},{"label":["studio_end"],"name":[8],"type":["chr"],"align":["left"]},{"label":["points"],"name":[9],"type":["int"],"align":["right"]},{"label":["tasks"],"name":[10],"type":["int"],"align":["right"]},{"label":["special"],"name":[11],"type":["int"],"align":["right"]},{"label":["TMI"],"name":[12],"type":["int"],"align":["right"]}],"data":[{"1":"-7","2":"CoC III","3":"0","4":"NA","5":"2024-??-??","6":"2024-??-??","7":"2023-11-28","8":"2023-11-28","9":"NA","10":"NA","11":"1","12":"88"},{"1":"-6","2":"NYT 2024","3":"0","4":"NA","5":"2024-01-01","6":"2024-01-01","7":"2023-11-27","8":"2023-11-27","9":"NA","10":"NA","11":"1","12":"87"},{"1":"-5","2":"NYT 2023","3":"1","4":"96","5":"2023-01-01","6":"2023-01-01","7":"2022-11-22","8":"2022-11-22","9":"76","10":"5","11":"1","12":"66"},{"1":"-4","2":"CoC II","3":"1","4":"87","5":"2022-06-23","6":"2022-06-23","7":"2021-09-15","8":"2021-09-15","9":"66","10":"5","11":"1","12":"46"},{"1":"-3","2":"NYT 2022","3":"1","4":"73","5":"2022-01-01","6":"2022-01-01","7":"NA","8":"NA","9":"68","10":"5","11":"1","12":"47"},{"1":"-2","2":"NYT 2021","3":"1","4":"62","5":"2021-01-01","6":"2021-01-01","7":"NA","8":"NA","9":"62","10":"5","11":"1","12":"12"},{"1":"-1","2":"CoC","3":"2","4":"29","5":"2017-12-13","6":"2017-12-20","7":"2017-11-20","8":"2017-11-20","9":"164","10":"10","11":"1","12":"6"},{"1":"1","2":"Series 1","3":"6","4":"4","5":"2015-07-28","6":"2015-09-01","7":"2015-03-23","8":"2015-03-25","9":"436","10":"32","11":"0","12":"1"},{"1":"2","2":"Series 2","3":"5","4":"11","5":"2016-06-21","6":"2016-07-19","7":"NA","8":"NA","9":"417","10":"28","11":"0","12":"2"},{"1":"3","2":"Series 3","3":"5","4":"16","5":"2016-10-04","6":"2016-11-01","7":"NA","8":"NA","9":"386","10":"27","11":"0","12":"3"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>

</div>

# Advanced query

A more involved query involving `JOIN` and date manipulation

``` r
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
"

results <- dbGetQuery(tm_db, query)
```

``` r
results
```

<div data-pagedtable="false">

<script data-pagedtable-source type="application/json">
{"columns":[{"label":["name"],"name":[1],"type":["chr"],"align":["left"]},{"label":["special_flag"],"name":[2],"type":["int"],"align":["right"]},{"label":["champion_name"],"name":[3],"type":["chr"],"align":["left"]},{"label":["chamption_seat"],"name":[4],"type":["int"],"align":["right"]},{"label":["studio_end"],"name":[5],"type":["chr"],"align":["left"]},{"label":["air_start"],"name":[6],"type":["chr"],"align":["left"]},{"label":["broadcast_lag_days"],"name":[7],"type":["dbl"],"align":["right"]}],"data":[{"1":"CoC III","2":"1","3":"NA","4":"NA","5":"2023-11-28","6":"NA","7":"NA"},{"1":"NYT 2024","2":"1","3":"NA","4":"NA","5":"2023-11-27","6":"2024-01-01","7":"35"},{"1":"NYT 2023","2":"1","3":"Mo Farah","4":"4","5":"2022-11-22","6":"2023-01-01","7":"40"},{"1":"CoC II","2":"1","3":"Richard Herring","4":"5","5":"2021-09-15","6":"2022-06-23","7":"281"},{"1":"NYT 2022","2":"1","3":"Adrian Chiles","4":"1","5":"NA","6":"2022-01-01","7":"NA"},{"1":"NYT 2021","2":"1","3":"Shirley Ballas","4":"5","5":"NA","6":"2021-01-01","7":"NA"},{"1":"CoC","2":"1","3":"Josh Widdicombe","4":"2","5":"2017-11-20","6":"2017-12-13","7":"23"},{"1":"Series 1","2":"0","3":"Josh Widdicombe","4":"2","5":"2015-03-25","6":"2015-07-28","7":"125"},{"1":"Series 2","2":"0","3":"Katherine Ryan","4":"4","5":"NA","6":"2016-06-21","7":"NA"},{"1":"Series 3","2":"0","3":"Rob Beckett","4":"4","5":"NA","6":"2016-10-04","7":"NA"},{"1":"Series 4","2":"0","3":"Noel Fielding","4":"5","5":"NA","6":"2017-04-25","7":"NA"},{"1":"Series 5","2":"0","3":"Bob Mortimer","4":"2","5":"2017-07-06","6":"2017-09-13","7":"69"},{"1":"Series 6","2":"0","3":"Liza Tarbuck","4":"3","5":"2018-03-28","6":"2018-05-02","7":"35"},{"1":"Series 7","2":"0","3":"Kerry Godliman","4":"3","5":"2018-07-25","6":"2018-09-05","7":"42"},{"1":"Series 8","2":"0","3":"Lou Sanders","4":"3","5":"2019-03-27","6":"2019-05-08","7":"42"},{"1":"Series 9","2":"0","3":"Ed Gamble","4":"2","5":"2019-07-24","6":"2019-09-04","7":"42"},{"1":"Series 10","2":"0","3":"Richard Herring","4":"5","5":"2020-07-29","6":"2020-10-15","7":"78"},{"1":"Series 11","2":"0","3":"Sarah Kendall","4":"5","5":"NA","6":"2021-03-18","7":"NA"},{"1":"Series 12","2":"0","3":"Morgana Robinson","4":"4","5":"NA","6":"2021-09-23","7":"NA"},{"1":"Series 13","2":"0","3":"Sophie Duker","4":"5","5":"2021-09-22","6":"2022-04-14","7":"204"},{"1":"Series 14","2":"0","3":"Dara Ó Briain","4":"1","5":"2022-05-05","6":"2022-09-29","7":"147"},{"1":"Series 15","2":"0","3":"Mae Martin","4":"5","5":"2022-09-28","6":"2023-03-30","7":"183"},{"1":"Series 16","2":"0","3":"Sam Campbell","4":"3","5":"2023-05-12","6":"2023-09-21","7":"132"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>

</div>

The results of this query already indicate interesting insights, namely
that 204 days (approximately 29 weeks) occurred between the studio
record and first air date for Series 13, which is a noticeable deviation
from prior seasons (greater broadcast lag). Future series also seem
delayed, although to a lesser extent. Could the pandemic have initiated
this lag? Or where there other production changes that led to this lag?

# Times Up!

And that concludes this task! Hopefully you’ve been able to connect to
the TdlM database directly through `R` and potentially inspired to start
performing your own analysis.

[^1]: Taskmaster fanatics will know that this is in reference to the
    hint in S2E5’s task *Build a bridge for the potato.*, which has
    since become one of key pieces of advice for all Taskmaster
    contestants. It has been suitably adapted for working on data tables
    in a database, rather than a piece of furniture.
