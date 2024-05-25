Strength in Data: Connecting to the Taskmaster Database
================
Christopher Nam
May 23rd 2024

# Introduction and Objective

This article provides an overview of *Trabajo de las Mesas*, a
Taskmaster database that will be central to performing a multitude of
analysis and questions that we may want to answer regarding Taskmaster.

The article will also provide guidance on how to connect to the database
from within <R>.

# Your Task

Successfully connect to the Taskmaster database from within `R`. Fastest
wins; your time starts now!l

# *Trabajo de las Mesas* Database

*\[Trabajo de las Mesas\] (TdlM)*(<https://tdlm.fly.dev/>)[^1] provides
a plethora of data associated with Taskmaster in a database format. Data
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
download.file(url = db_url, destfile = db_data_location, mode = "wb")
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
    ## [13] "series_scores"      "special_locations"  "task_briefs"       
    ## [16] "task_readers"       "task_winners"       "tasks"             
    ## [19] "tasks_by_objective" "team_tasks"         "teams"             
    ## [22] "title_coiners"      "title_stats"

## Querying the Database

Now that we are successfully able to connect to the database, we are
able to write queries and execute them directly from `R` to access the
data. For example:

### A Basic `SELECT` query

``` r
# A Basic Select query  on the series table.
query <- "SELECT * FROM series LIMIT 10"

dbGetQuery(tm_db, query)
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

results
```

    ##         name special_flag    champion_name chamption_seat studio_end  air_start
    ## 1    CoC III            1             <NA>             NA 2023-11-28       <NA>
    ## 2   NYT 2024            1             <NA>             NA 2023-11-27 2024-01-01
    ## 3   NYT 2023            1         Mo Farah              4 2022-11-22 2023-01-01
    ## 4     CoC II            1  Richard Herring              5 2021-09-15 2022-06-23
    ## 5   NYT 2022            1    Adrian Chiles              1       <NA> 2022-01-01
    ## 6   NYT 2021            1   Shirley Ballas              5       <NA> 2021-01-01
    ## 7        CoC            1  Josh Widdicombe              2 2017-11-20 2017-12-13
    ## 8   Series 1            0  Josh Widdicombe              2 2015-03-25 2015-07-28
    ## 9   Series 2            0   Katherine Ryan              4       <NA> 2016-06-21
    ## 10  Series 3            0      Rob Beckett              4       <NA> 2016-10-04
    ## 11  Series 4            0    Noel Fielding              5       <NA> 2017-04-25
    ## 12  Series 5            0     Bob Mortimer              2 2017-07-06 2017-09-13
    ## 13  Series 6            0     Liza Tarbuck              3 2018-03-28 2018-05-02
    ## 14  Series 7            0   Kerry Godliman              3 2018-07-25 2018-09-05
    ## 15  Series 8            0      Lou Sanders              3 2019-03-27 2019-05-08
    ## 16  Series 9            0        Ed Gamble              2 2019-07-24 2019-09-04
    ## 17 Series 10            0  Richard Herring              5 2020-07-29 2020-10-15
    ## 18 Series 11            0    Sarah Kendall              5       <NA> 2021-03-18
    ## 19 Series 12            0 Morgana Robinson              4       <NA> 2021-09-23
    ## 20 Series 13            0     Sophie Duker              5 2021-09-22 2022-04-14
    ## 21 Series 14            0    Dara Ó Briain              1 2022-05-05 2022-09-29
    ## 22 Series 15            0       Mae Martin              5 2022-09-28 2023-03-30
    ## 23 Series 16            0     Sam Campbell              3 2023-05-12 2023-09-21
    ##    broadcast_lag_days
    ## 1                  NA
    ## 2                  35
    ## 3                  40
    ## 4                 281
    ## 5                  NA
    ## 6                  NA
    ## 7                  23
    ## 8                 125
    ## 9                  NA
    ## 10                 NA
    ## 11                 NA
    ## 12                 69
    ## 13                 35
    ## 14                 42
    ## 15                 42
    ## 16                 42
    ## 17                 78
    ## 18                 NA
    ## 19                 NA
    ## 20                204
    ## 21                147
    ## 22                183
    ## 23                132

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

``` r
dbListTables(tm_db)
```

    ##  [1] "attempts"           "discrepancies"      "episode_scores"    
    ##  [4] "episodes"           "intros"             "measurements"      
    ##  [7] "normalized_scores"  "objectives"         "people"            
    ## [10] "podcast"            "profanity"          "series"            
    ## [13] "series_scores"      "special_locations"  "task_briefs"       
    ## [16] "task_readers"       "task_winners"       "tasks"             
    ## [19] "tasks_by_objective" "team_tasks"         "teams"             
    ## [22] "title_coiners"      "title_stats"

``` r
dbGetQuery(tm_db, 'SELECT * FROM profanity LIMIT 5')
```

    ##   id series episode task speaker    roots
    ## 1  1      1       1    1       6 ["shit"]
    ## 2  2      1       1    1       6 ["piss"]
    ## 3  3      1       1    1       2 ["shit"]
    ## 4  4      1       1    2       6 ["shit"]
    ## 5  5      1       1    2       2 ["shit"]
    ##                                                                                            quote
    ## 1                 I think we can all agree it's the shittest present in the history of humanity.
    ## 2                                          You know the granules? The snow density is piss-poor.
    ## 3                    And the winner of this competition will have to take all of that shit home.
    ## 4                                  And then when I threw it I was like, "Holy shit, that has..."
    ## 5 I've got an image of you at an all-you-can-eat buffet just kicking the shit out of everything.
    ##   studio
    ## 1      1
    ## 2      1
    ## 3      1
    ## 4      1
    ## 5      1

``` r
teams_tbl <- dbGetQuery(tm_db, 'SELECT * FROM profanity')
```

    ## Warning: Column `speaker`: mixed type, first seen values of type integer,
    ## coercing other values of type string

``` r
teams_tbl
```

    ##        id series episode task speaker
    ## 1       1      1       1    1       6
    ## 2       2      1       1    1       6
    ## 3       3      1       1    1       2
    ## 4       4      1       1    2       6
    ## 5       5      1       1    2       2
    ## 6       6      1       1    2       6
    ## 7       7      1       1    3       7
    ## 8       8      1       1    3       6
    ## 9       9      1       1    3       7
    ## 10     10      1       1    3       2
    ## 11     11      1       1    3       7
    ## 12     12      1       1    3       4
    ## 13     13      1       1    4       4
    ## 14     14      1       1    6       2
    ## 15     15      1       1    6       6
    ## 16     16      1       2    7       6
    ## 17     17      1       2    7       6
    ## 18     18      1       2    7       5
    ## 19     19      1       2    7       6
    ## 20     20      1       2    8       5
    ## 21     21      1       2    8       2
    ## 22     22      1       2    8       2
    ## 23     23      1       2    9       2
    ## 24     24      1       2    9       2
    ## 25     25      1       2    9       6
    ## 26     26      1       2    9       2
    ## 27     27      1       2    9       6
    ## 28     28      1       2    9       6
    ## 29     29      1       2    9       6
    ## 30     30      1       2   10       3
    ## 31     31      1       2   10       6
    ## 32     32      1       2   11       4
    ## 33     33      1       2   11       4
    ## 34     34      1       3   12       2
    ## 35     35      1       3   12       2
    ## 36     36      1       3   12       2
    ## 37     37      1       3   12       6
    ## 38     38      1       3   12       2
    ## 39     39      1       3   13       6
    ## 40     40      1       3   13       6
    ## 41     41      1       3   14       4
    ## 42     42      1       3   14       2
    ## 43     43      1       3   14       2
    ## 44     44      1       3   15       7
    ## 45     45      1       3   15       2
    ## 46     46      1       3   15       2
    ## 47     47      1       3   16       6
    ## 48     48      1       3   16       6
    ## 49     49      1       3   16       6
    ## 50     50      1       3   16       7
    ## 51     51      1       3   16       6
    ## 52     52      1       3   16       2
    ## 53     53      1       3   17       6
    ## 54     54      1       4   19       2
    ## 55     55      1       4   19       6
    ## 56     56      1       4   19       6
    ## 57     57      1       4   21       7
    ## 58     58      1       4   21       2
    ## 59     59      1       4   20       6
    ## 60     60      1       4   21       6
    ## 61     61      1       4   21       7
    ## 62     62      1       4   23       6
    ## 63     63      1       4   23       7
    ## 64     64      1       4   23       7
    ## 65     65      1       4   23       7
    ## 66     66      1       4   23       7
    ## 67     67      1       4   23       7
    ## 68     68      1       4   23       6
    ## 69     69      1       4   24       7
    ## 70     70      1       4   24       4
    ## 71     71      1       4   24       6
    ## 72     72      1       4   24       6
    ## 73     73      1       4   24       6
    ## 74     74      1       4   24       6
    ## 75     75      1       4   24       6
    ## 76     76      1       4   26       4
    ## 77     77      1       4   26       2
    ## 78     78      1       5   27       2
    ## 79     79      1       5   27       2
    ## 80     80      1       5   27       2
    ## 81     81      1       5   27       6
    ## 82     82      1       5   28       6
    ## 83     83      1       5   28       6
    ## 84     84      1       5   28       2
    ## 85     85      1       5   28       7
    ## 86     86      1       5   30       4
    ## 87     87      1       5   30       4
    ## 88     88      1       5   31       2
    ## 89     89      1       6   33       2
    ## 90     90      1       6   33       6
    ## 91     91      1       6   34       6
    ## 92     92      1       6   34       6
    ## 93     93      1       6   34       5
    ## 94     94      1       6   34       2
    ## 95     95      1       6   35       5
    ## 96     96      1       6   35       5
    ## 97     97      1       6   35       6
    ## 98     98      1       6   35       6
    ## 99     99      1       6   35       6
    ## 100   100      1       6   36       5
    ## 101   101      1       6   36       4
    ## 102   102      1       6   36       6
    ## 103   103      1       6   37       5
    ## 104   104      1       6   37       1
    ## 105   105      2       7   38       8
    ## 106   106      2       7   38       9
    ## 107   107      2       7   38      10
    ## 108   108      2       7   39       9
    ## 109   109      2       7   39      10
    ## 110   110      2       7   39       9
    ## 111   111      2       7   39      10
    ## 112   112      2       7   39       8
    ## 113   113      2       7   40      10
    ## 114   114      2       7   40      10
    ## 115   115      2       7   40       2
    ## 116   116      2       7   40       9
    ## 117   117      2       7   40       8
    ## 118   118      2       7   41       9
    ## 119   119      2       7   41       9
    ## 120   120      2       7   41       9
    ## 121   121      2       7   41       2
    ## 122   122      2       7   41       8
    ## 123   123      2       7   41      10
    ## 124   124      2       7   41      10
    ## 125   125      2       8   43       9
    ## 126   126      2       8   44      10
    ## 127   127      2       8   44      10
    ## 128   128      2       8   44      10
    ## 129   129      2       8   45       2
    ## 130   130      2       8   45       8
    ## 131   131      2       8   45       8
    ## 132   132      2       8   45       2
    ## 133   133      2       8   46       2
    ## 134   134      2       8   47       2
    ## 135   135      2       8   48      11
    ## 136   136      2       8   48      11
    ## 137   137      2       9   49       2
    ## 138   138      2       9   50       9
    ## 139   139      2       9   50      12
    ## 140   140      2       9   50       2
    ## 141   141      2       9   50      10
    ## 142   142      2       9   50      10
    ## 143   143      2       9   51       2
    ## 144   144      2       9   52       2
    ## 145   145      2       9   52       2
    ## 146   146      2       9   53       8
    ## 147   147      2       9   53       4
    ## 148   148      2       9   53       9
    ## 149   149      2       9   53       8
    ## 150   150      2       9   53       8
    ## 151   151      2       9   54      10
    ## 152   152      2      10   56       8
    ## 153   153      2      10   56       8
    ## 154   154      2      10   56      10
    ## 155   155      2      10   56       1
    ## 156   156      2      10   56       2
    ## 157   157      2      10   56       8
    ## 158   158      2      10   56       2
    ## 159   159      2      10   56      11
    ## 160   160      2      10   56      11
    ## 161   161      2      10   56      11
    ## 162   162      2      10   56       2
    ## 163   163      2      10   57       9
    ## 164   164      2      10   57       9
    ## 165   165      2      10   57      10
    ## 166   166      2      10   57       1
    ## 167   167      2      10   57       9
    ## 168   168      2      10   57       9
    ## 169   169      2      10   57       1
    ## 170   170      2      10   57       2
    ## 171   171      2      10   57       8
    ## 172   172      2      10   57       1
    ## 173   173      2      10   59       8
    ## 174   174      2      10   59       8
    ## 175   175      2      10   59      11
    ## 176   176      2      10   59       9
    ## 177   177      2      10   59       9
    ## 178   178      2      10   59       8
    ## 179   179      2      10   59       2
    ## 180   180      2      10   59      10
    ## 181   181      2      10   59      10
    ## 182   182      2      10   59       2
    ## 183   183      2      10   59       2
    ## 184   184      2      10   60       8
    ## 185   185      2      11   61       2
    ## 186   186      2      11   61       2
    ## 187   187      2      11   61       2
    ## 188   188      2      11   62      11
    ## 189   189      2      11   62       2
    ## 190   190      2      11   62       8
    ## 191   191      2      11   62       8
    ## 192   192      2      11   62       9
    ## 193   193      2      11   62      12
    ## 194   194      2      11   63       9
    ## 195   195      2      11   64       2
    ## 196   196      2      11   64      10
    ## 197   197      2      11   64       8
    ## 198   198      2      11   64       9
    ## 199   199      2      11   64       9
    ## 200   200      2      11   65      11
    ## 201   201      2      11   65       2
    ## 202   202      3      12   67       2
    ## 203   203      3      12   67      16
    ## 204   204      3      12   67       2
    ## 205   205      3      12   67       2
    ## 206   206      3      12   67      17
    ## 207   207      3      12   68       2
    ## 208   208      3      12   68      15
    ## 209   209      3      12   68      16
    ## 210   210      3      12   69      15
    ## 211   211      3      12   69       2
    ## 212   212      3      12   69       2
    ## 213   213      3      13   71       2
    ## 214   214      3      13   71       2
    ## 215   215      3      13   73      16
    ## 216   216      3      13   73      16
    ## 217   217      3      13   73      16
    ## 218   218      3      13   73      16
    ## 219   219      3      13   73      13
    ## 220   220      3      13   73       2
    ## 221   221      3      13   74      16
    ## 222   222      3      13   75      15
    ## 223   223      3      13   75      15
    ## 224   224      3      13   75      15
    ## 225   225      3      13   75       2
    ## 226   226      3      13   75       2
    ## 227   227      3      13   75      13
    ## 228   228      3      13   75      13
    ## 229   229      3      13   76      16
    ## 230   230      3      14   77       2
    ## 231   231      3      14   77       2
    ## 232   232      3      14   78       2
    ## 233   233      3      14   78      15
    ## 234   234      3      14   78      13
    ## 235   235      3      14   79      16
    ## 236   236      3      14   79      14
    ## 237   237      3      14   79      13
    ## 238   238      3      14   80       2
    ## 239   239      3      14   81      17
    ## 240   240      3      14   81      16
    ## 241   241      3      14   82      13
    ## 242   242      3      15   84       2
    ## 243   243      3      15   88       2
    ## 244   244      3      15   88      15
    ## 245   245      3      16   NA       2
    ## 246   246      3      16   89       2
    ## 247   247      3      16   90      16
    ## 248   248      3      16   90      16
    ## 249   249      3      16   90      16
    ## 250   250      3      16   90      16
    ## 251   251      3      16   90       2
    ## 252   252      3      16   90      14
    ## 253   253      3      16   91      16
    ## 254   254      3      16   91      16
    ## 255   255      3      16   91      16
    ## 256   256      3      16   91      16
    ## 257   257      3      16   92       2
    ## 258   258      3      16   92      16
    ## 259   259      3      16   93      13
    ## 260   260      4      17   94      19
    ## 261   261      4      17   95       2
    ## 262   262      4      17   95       2
    ## 263   263      4      17   95       2
    ## 264   264      4      17   96       2
    ## 265   265      4      17   97      19
    ## 266   266      4      17   97      22
    ## 267   267      4      17   98       2
    ## 268   268      4      18   99      22
    ## 269   269      4      18   99       2
    ## 270   270      4      18  100      19
    ## 271   271      4      18  101       2
    ## 272   272      4      18  102      20
    ## 273   273      4      18  102      21
    ## 274   274      4      18  102      18
    ## 275   275      4      18  102      21
    ## 276   276      4      18  102       2
    ## 277   277      4      18  104       2
    ## 278   278      4      19  105       2
    ## 279   279      4      19  105      18
    ## 280   280      4      19  105       2
    ## 281   281      4      19  106      18
    ## 282   282      4      19  107      22
    ## 283   283      4      19  107      19
    ## 284   284      4      19  108      19
    ## 285   285      4      19  108       2
    ## 286   286      4      19  108      19
    ## 287   287      4      19  108       2
    ## 288   288      4      19  108       2
    ## 289   289      4      19  109      22
    ## 290   290      4      19  109       2
    ## 291   291      4      19  109       2
    ## 292   292      4      19  109      18
    ## 293   293      4      19  111      19
    ## 294   294      4      19  111      22
    ## 295   295      4      20  112       2
    ## 296   296      4      20  112      18
    ## 297   297      4      20  113      22
    ## 298   298      4      20  113      22
    ## 299   299      4      20  113      19
    ## 300   300      4      20  113       2
    ## 301   301      4      20  114       2
    ## 302   302      4      20  116       2
    ## 303   303      4      20  116       2
    ## 304   304      4      20  117      19
    ## 305   305      4      21  118      19
    ## 306   306      4      21  118       2
    ## 307   307      4      21  118       2
    ## 308   308      4      21  119      22
    ## 309   309      4      21  121      19
    ## 310   310      4      21  121       2
    ## 311   311      4      21  122       2
    ## 312   312      4      21  123       2
    ## 313   313      4      22  125       2
    ## 314   314      4      22  126      19
    ## 315   315      4      22  126      19
    ## 316   316      4      22  126       2
    ## 317   317      4      22  126      19
    ## 318   318      4      22  127      22
    ## 319   319      4      22  127      22
    ## 320   320      4      22  127       2
    ## 321   321      4      22  127       1
    ## 322   322      4      22  128      21
    ## 323   323      4      22  128      21
    ## 324   324      4      22  128      21
    ## 325   325      4      22  128      21
    ## 326   326      4      22  131      22
    ## 327   327      4      22  131       2
    ## 328   328      4      22  132      19
    ## 329   329      4      23  133       2
    ## 330   330      4      23  133      19
    ## 331   331      4      23  134      19
    ## 332   332      4      23  135      22
    ## 333   333      4      23  135       2
    ## 334   334      4      23  136       2
    ## 335   335      4      23  137       2
    ## 336   336      4      23  137       2
    ## 337   337      4      23  138      21
    ## 338   338      4      23  138      18
    ## 339   339      4      24  142      19
    ## 340   340      4      24  142      19
    ## 341   341      4      24  142      18
    ## 342   342      4      24  143      19
    ## 343   343      4      24  144       2
    ## 344   344      4      24  144       2
    ## 345   345      4      24  144       2
    ## 346   346      4      24  144       2
    ## 347   347      4      24  144      22
    ## 348   348      4      24  144       2
    ## 349   349      4      24  145      21
    ## 350   350      5      25  146       2
    ## 351   351      5      25  146       2
    ## 352   352      5      25  147      23
    ## 353   353      5      25  147       2
    ## 354   354      5      25  147      24
    ## 355   355      5      25  148      23
    ## 356   356      5      25  148      23
    ## 357   357      5      25  148      24
    ## 358   358      5      25  149      23
    ## 359   359      5      25  150      26
    ## 360   360      5      25  150      23
    ## 361   361      5      25  150       2
    ## 362   362      5      26  151       2
    ## 363   363      5      26  152      26
    ## 364   364      5      26  152      23
    ## 365   365      5      26  153      24
    ## 366   366      5      26  153      24
    ## 367   367      5      26  153       2
    ## 368   368      5      26  153       2
    ## 369   369      5      26  153      26
    ## 370   370      5      26  153       2
    ## 371   371      5      26  153       2
    ## 372   372      5      26  153       2
    ## 373   373      5      26  154      26
    ## 374   374      5      26  154      26
    ## 375   375      5      26  154      26
    ## 376   376      5      26  155      24
    ## 377   377      5      26  155       2
    ## 378   378      5      26  155      27
    ## 379   379      5      26  155      27
    ## 380   380      5      26  155      23
    ## 381   381      5      26  155       2
    ## 382   382      5      26  155      25
    ## 383   383      5      26  155       2
    ## 384   384      5      26  156      26
    ## 385   385      5      26  156       2
    ## 386   386      5      27  158      26
    ## 387   387      5      27  158       2
    ## 388   388      5      27  158       2
    ## 389   389      5      27  158       2
    ## 390   390      5      27  158      25
    ## 391   391      5      27  158      26
    ## 392   392      5      27  158      25
    ## 393   393      5      27  158      24
    ## 394   394      5      27  158      24
    ## 395   395      5      27  158       2
    ## 396   396      5      27  158       2
    ## 397   397      5      27  158       2
    ## 398   398      5      27  159      24
    ## 399   399      5      27  160       2
    ## 400   400      5      27  161      26
    ## 401   401      5      28  162       2
    ## 402   402      5      28  162       2
    ## 403   403      5      28  162      24
    ## 404   404      5      28  163      26
    ## 405   405      5      28  163      27
    ## 406   406      5      28  163      24
    ## 407   407      5      28  163      25
    ## 408   408      5      28  163      24
    ## 409   409      5      28  163       2
    ## 410   410      5      28  164      24
    ## 411   411      5      28  166       2
    ## 412   412      5      28  168      23
    ## 413   413      5      29  170       2
    ## 414   414      5      29  170       2
    ## 415   415      5      29  171      26
    ## 416   416      5      29  172       2
    ## 417   417      5      29  172      24
    ## 418   418      5      29  172       2
    ## 419   419      5      29  172       2
    ## 420   420      5      29  172       2
    ## 421   421      5      29  172       2
    ## 422   422      5      29  173       2
    ## 423   423      5      29  173       2
    ## 424   424      5      29  174      23
    ## 425   425      5      29  174      26
    ## 426   426      5      29  174      26
    ## 427   427      5      29  174      27
    ## 428   428      5      29  175      25
    ## 429   429      5      30  176       2
    ## 430   430      5      30  177       2
    ## 431   431      5      30  178      23
    ## 432   432      5      30  178      25
    ## 433   433      5      30  179      23
    ## 434   434      5      30  180       2
    ## 435   435      5      30  180      26
    ## 436   436      5      30  180      26
    ## 437   437      5      30  180       1
    ## 438   438      5      30  180       2
    ## 439   439      5      30  180       2
    ## 440   440      5      30  181      24
    ## 441   441      5      30  181      26
    ## 442   442      5      31  184      23
    ## 443   443      5      31  184      24
    ## 444   444      5      31  184      24
    ## 445   445      5      31  184      27
    ## 446   446      5      31  185      26
    ## 447   447      5      31  185       2
    ## 448   448      5      31  185       2
    ## 449   449      5      31  185      24
    ## 450   450      5      31  185      24
    ## 451   451      5      31  187      23
    ## 452   452      5      31  187       2
    ## 453   453      5      31  187       2
    ## 454   454      5      31  187      23
    ## 455   455      5      31  188       2
    ## 456   456      5      31  188      26
    ## 457   457      5      31  188      25
    ## 458   458      5      31  188      23
    ## 459   459      5      31  188      23
    ## 460   460      5      31  188       2
    ## 461   461      5      31  188       2
    ## 462   462      5      32  189      25
    ## 463   463      5      32  190      26
    ## 464   464      5      32  190      24
    ## 465   465      5      32  190      24
    ## 466   466      5      32  190       2
    ## 467   467      5      32  190       2
    ## 468   468      5      32  190      27
    ## 469   469      5      32  191      27
    ## 470   470      5      32  191      24
    ## 471   471      5      32  191      23
    ## 472   472      5      32  191      24
    ## 473   473      5      32  191      24
    ## 474   474      5      32  191      24
    ## 475   475      5      32  191      25
    ## 476   476      5      32  191       2
    ## 477   477      5      32  191       2
    ## 478   478      5      32  191       2
    ## 479   479      5      32  193      24
    ## 480   480      5      32  193       2
    ## 481   481      5      32  193       2
    ## 482   482      5      32  194      26
    ## 483   483     -1      33  195      31
    ## 484   484     -1      33  195      32
    ## 485   485     -1      33  195      32
    ## 486   486     -1      33  195       2
    ## 487   487     -1      33  196      32
    ## 488   488     -1      33  196       2
    ## 489   489     -1      33  197      30
    ## 490   490     -1      33  197      30
    ## 491   491     -1      33  199      31
    ## 492   492     -1      33  199       2
    ## 493   493     -1      34  201      29
    ## 494   494     -1      34  202      28
    ## 495   495     -1      34  202      30
    ## 496   496     -1      34  202       2
    ## 497   497     -1      34  202      29
    ## 498   498     -1      34  202       2
    ## 499   499     -1      34  203      29
    ## 500   500     -1      34  203      29
    ## 501   501     -1      34  203       2
    ## 502   502     -1      34  203       2
    ## 503   503     -1      34  203      32
    ## 504   504     -1      34  203      31
    ## 505   505     -1      34  204      28
    ## 506   506     -1      34  204      30
    ## 507   507     -1      34  204      30
    ## 508   508     -1      34  204      30
    ## 509   509     -1      34  204       2
    ## 510   510     -1      34  204       2
    ## 511   511     -1      34  205      28
    ## 512   512      6      35  206       2
    ## 513   513      6      35  206       2
    ## 514   514      6      35  207      36
    ## 515   515      6      35  207      34
    ## 516   516      6      35  207       2
    ## 517   517      6      35  207      36
    ## 518   518      6      35  207      36
    ## 519   519      6      35  207      36
    ## 520   520      6      35  207       2
    ## 521   521      6      35  207       2
    ## 522   522      6      35  207      36
    ## 523   523      6      35  208      34
    ## 524   524      6      35  208       1
    ## 525   525      6      35  208      34
    ## 526   526      6      35  208      34
    ## 527   527      6      35  208      36
    ## 528   528      6      35  208      36
    ## 529   529      6      35  208      36
    ## 530   530      6      35  208      34
    ## 531   531      6      35  208      36
    ## 532   532      6      35  208      34
    ## 533   533      6      35  208       2
    ## 534   534      6      35  208      35
    ## 535   535      6      35  210      36
    ## 536   536      6      35  210      34
    ## 537   537      6      35  210      36
    ## 538   538      6      35  210      33
    ## 539   539      6      36  212      34
    ## 540   540      6      36  212      34
    ## 541   541      6      36  213      34
    ## 542   542      6      36  213      34
    ## 543   543      6      36  213      34
    ## 544   544      6      36  213      34
    ## 545   545      6      36  213      34
    ## 546   546      6      36  213       2
    ## 547   547      6      36  213      36
    ## 548   548      6      36  216       2
    ## 549   549      6      36  216      34
    ## 550   550      6      36  216       2
    ## 551   551      6      36  216       2
    ## 552   552      6      36  216      34
    ## 553   553      6      36  216       2
    ## 554   554      6      36  216      34
    ## 555   555      6      36  216       2
    ## 556   556      6      36  217      34
    ## 557   557      6      37  218       2
    ## 558   558      6      37  218      34
    ## 559   559      6      37  218      34
    ## 560   560      6      37  218       2
    ## 561   561      6      37  219      33
    ## 562   562      6      37  219      33
    ## 563   563      6      37  219      33
    ## 564   564      6      37  219      33
    ## 565   565      6      37  219      33
    ## 566   566      6      37  219      33
    ## 567   567      6      37  219      33
    ## 568   568      6      37  219      33
    ## 569   569      6      37  219      34
    ## 570   570      6      37  219      34
    ## 571   571      6      37  219       2
    ## 572   572      6      37  219      34
    ## 573   573      6      37  219      34
    ## 574   574      6      37  219      34
    ## 575   575      6      37  219      34
    ## 576   576      6      37  219      36
    ## 577   577      6      37  219       2
    ## 578   578      6      37  220      34
    ## 579   579      6      37  220      34
    ## 580   580      6      37  220      34
    ## 581   581      6      37  220      34
    ## 582   582      6      37  220      34
    ## 583   583      6      37  220       2
    ## 584   584      6      37  220      36
    ## 585   585      6      37  220      36
    ## 586   586      6      37  220      36
    ## 587   587      6      37  220       2
    ## 588   588      6      37  221      36
    ## 589   589      6      37  221      36
    ## 590   590      6      37  221      36
    ## 591   591      6      37  221       2
    ## 592   592      6      37  222      36
    ## 593   593      6      37  222      34
    ## 594   594      6      37  222       2
    ## 595   595      6      38   NA       2
    ## 596   596      6      38   NA       2
    ## 597   597      6      38   NA       1
    ## 598   598      6      38  223      34
    ## 599   599      6      38  224      34
    ## 600   600      6      38  224       2
    ## 601   601      6      38  224      34
    ## 602   602      6      38  224      34
    ## 603   603      6      38  224      36
    ## 604   604      6      38  224      36
    ## 605   605      6      38  228      36
    ## 606   606      6      38  228      37
    ## 607   607      6      38  228      34
    ## 608   608      6      38  229      34
    ## 609   609      6      39  230       2
    ## 610   610      6      39  230       2
    ## 611   611      6      39  231      34
    ## 612   612      6      39  233      36
    ## 613   613      6      39  233       1
    ## 614   614      6      39  233       2
    ## 615   615      6      39  233      34
    ## 616   616      6      39  233       2
    ## 617   617      6      39  233       2
    ## 618   618      6      39  233      34
    ## 619   619      6      39  234      36
    ## 620   620      6      39  234      36
    ## 621   621      6      39  234      36
    ## 622   622      6      39  234      36
    ## 623   623      6      39  234      36
    ## 624   624      6      39  234      36
    ## 625   625      6      40  236       2
    ## 626   626      6      40  236       2
    ## 627   627      6      40  237      35
    ## 628   628      6      40  237      34
    ## 629   629      6      40  237      34
    ## 630   630      6      40  237      36
    ## 631   631      6      40  238      34
    ## 632   632      6      40  238      36
    ## 633   633      6      40  238      36
    ## 634   634      6      40  238       2
    ## 635   635      6      40  239      34
    ## 636   636      6      40  239       2
    ## 637   637      6      40  240      34
    ## 638   638      6      40  240       2
    ## 639   639      6      40  240      33
    ## 640   640      6      40  240      34
    ## 641   641      6      40  240      34
    ## 642   642      6      40  240      35
    ## 643   643      6      40  240      36
    ## 644   644      6      40  240      36
    ## 645   645      6      40  240      36
    ## 646   646      6      40  240      36
    ## 647   647      6      41  242      36
    ## 648   648      6      41  242      36
    ## 649   649      6      41  243      34
    ## 650   650      6      41  243      34
    ## 651   651      6      41  244      34
    ## 652   652      6      41  244       2
    ## 653   653      6      41  244       2
    ## 654   654      6      41  244       2
    ## 655   655      6      41  244       2
    ## 656   656      6      41  244      36
    ## 657   657      6      41  245      34
    ## 658   658      6      41  245      33
    ## 659   659      6      41  245      34
    ## 660   660      6      41  245       1
    ## 661   661      6      41  245      37
    ## 662   662      6      41  245      35
    ## 663   663      6      41  245      35
    ## 664   664      6      41  245       2
    ## 665   665      6      41  245       1
    ## 666   666      6      41  246      33
    ## 667   667      6      41  246      35
    ## 668   668      6      41  246      36
    ## 669   669      6      41  246      36
    ## 670   670      6      41  247      36
    ## 671   671      6      41  247      36
    ## 672   672      6      42  248      36
    ## 673   673      6      42  248       2
    ## 674   674      6      42  249      34
    ## 675   675      6      42  250      34
    ## 676   676      6      42  250      34
    ## 677   677      6      42  250      34
    ## 678   678      6      42  250       2
    ## 679   679      6      42  250      34
    ## 680   680      6      42  250       2
    ## 681   681      6      42  251       2
    ## 682   682      6      42  251      35
    ## 683   683      6      42  251       2
    ## 684   684      6      42  251       2
    ## 685   685      6      42  252      36
    ## 686   686      6      42  252      34
    ## 687   687      6      42  253      36
    ## 688   688      6      43  254      34
    ## 689   689      6      43  254       2
    ## 690   690      6      43  255      34
    ## 691   691      6      43  255      37
    ## 692   692      6      43  255      34
    ## 693   693      6      43  255      37
    ## 694   694      6      43  255      34
    ## 695   695      6      43  255      36
    ## 696   696      6      43  255      36
    ## 697   697      6      43  255      36
    ## 698   698      6      43  256      36
    ## 699   699      6      43  256      34
    ## 700   700      6      43  256      33
    ## 701   701      6      43  258       2
    ## 702   702      6      43  258       2
    ## 703   703      6      43  259      35
    ## 704   704      6      43  259       1
    ## 705   705      6      44  261       2
    ## 706   706      6      44  261      34
    ## 707   707      6      44  261       2
    ## 708   708      6      44  261      34
    ## 709   709      6      44  261      35
    ## 710   710      6      44  261      36
    ## 711   711      6      44  262      35
    ## 712   712      6      44  262      34
    ## 713   713      6      44  263      34
    ## 714   714      6      44  263       2
    ## 715   715      6      44  263       2
    ## 716   716      6      44  263      35
    ## 717   717      6      44  263      35
    ## 718   718      7      45  265       2
    ## 719   719      7      45  267      38
    ## 720   720      7      45  267      41
    ## 721   721      7      45  267      38
    ## 722   722      7      45  267      42
    ## 723   723      7      45  268      42
    ## 724   724      7      45  268      42
    ## 725   725      7      46   NA       2
    ## 726   726      7      46  270       2
    ## 727   727      7      46  271      41
    ## 728   728      7      46  271      39
    ## 729   729      7      46  272      38
    ## 730   730      7      46  272       2
    ## 731   731      7      46  272      38
    ## 732   732      7      46  274       1
    ## 733   733      7      46  274       2
    ## 734   734      7      47  277      38
    ## 735   735      7      47  277      39
    ## 736   736      7      47  278       2
    ## 737   737      7      47  279      39
    ## 738   738      7      47  279       2
    ## 739   739      7      47  279       2
    ## 740   740      7      47  279       2
    ## 741   741      7      47  279      41
    ## 742   742      7      47  279       2
    ## 743   743      7      47  280      38
    ## 744   744      7      47  280       2
    ## 745   745      7      47  280      42
    ## 746   746      7      47  280      42
    ## 747   747      7      48   NA       2
    ## 748   748      7      48   NA       2
    ## 749   749      7      48  282       2
    ## 750   750      7      48  282      40
    ## 751   751      7      48  282       2
    ## 752   752      7      48  282       2
    ## 753   753      7      48  282      38
    ## 754   754      7      48  282       2
    ## 755   755      7      48  282      38
    ## 756   756      7      48  282       2
    ## 757   757      7      48  282       2
    ## 758   758      7      48  283       2
    ## 759   759      7      48  283      42
    ## 760   760      7      48  283      42
    ## 761   761      7      48  283      38
    ## 762   762      7      48  283       2
    ## 763   763      7      48  284       2
    ## 764   764      7      48  284      42
    ## 765   765      7      48  284       2
    ## 766   766      7      48  284      40
    ## 767   767      7      48  285      41
    ## 768   768      7      48  285      41
    ## 769   769      7      48  285      40
    ## 770   770      7      49  288      41
    ## 771   771      7      49  289       2
    ## 772   772      7      49  289      40
    ## 773   773      7      49  289       1
    ## 774   774      7      49  289       2
    ## 775   775      7      49  289      42
    ## 776   776      7      49  289       2
    ## 777   777      7      49  289      39
    ## 778   778      7      49  290      38
    ## 779   779      7      49  290       2
    ## 780   780      7      49  290      41
    ## 781   781      7      49  290      41
    ## 782   782      7      49  290      41
    ## 783   783      7      49  290       2
    ## 784   784      7      49  292       2
    ## 785   785      7      49  293      40
    ## 786   786      7      49  293       2
    ## 787   787      7      50   NA       2
    ## 788   788      7      50  294       2
    ## 789   789      7      50  294       2
    ## 790   790      7      50  294       2
    ## 791   791      7      50  294       2
    ## 792   792      7      50  294      39
    ## 793   793      7      50  296      38
    ## 794   794      7      50  296      42
    ## 795   795      7      50  296       2
    ## 796   796      7      50  296      41
    ## 797   797      7      50  296       2
    ## 798   798      7      50  297       2
    ## 799   799      7      50  298      38
    ## 800   800      7      50  298      38
    ## 801   801      7      50  298      38
    ## 802   802      7      50  298      42
    ## 803   803      7      50  299      42
    ## 804   804      7      51  300      40
    ## 805   805      7      51  300       2
    ## 806   806      7      51  300      42
    ## 807   807      7      51  300       2
    ## 808   808      7      51  300       2
    ## 809   809      7      51  301      41
    ## 810   810      7      51  301      39
    ## 811   811      7      51  302      42
    ## 812   812      7      51  303      41
    ## 813   813      7      51  303      38
    ## 814   814      7      51  303      38
    ## 815   815      7      51  304      41
    ## 816   816      7      51  305       2
    ## 817   817      7      52  306       2
    ## 818   818      7      52  306       2
    ## 819   819      7      52  306       2
    ## 820   820      7      52  307      39
    ## 821   821      7      52  307       2
    ## 822   822      7      52  308       2
    ## 823   823      7      52  308      42
    ## 824   824      7      52  309      38
    ## 825   825      7      52  309       2
    ## 826   826      7      52  309       2
    ## 827   827      7      52  309      42
    ## 828   828      7      52  309       2
    ## 829   829      7      52  309      42
    ## 830   830      7      52   NA       2
    ## 831   831      7      53  311       2
    ## 832   832      7      53  311      38
    ## 833   833      7      53  311       2
    ## 834   834      7      53  311       2
    ## 835   835      7      53  311       2
    ## 836   836      7      53  312      42
    ## 837   837      7      53  312      42
    ## 838   838      7      53  312      42
    ## 839   839      7      53  312      42
    ## 840   840      7      53  312      42
    ## 841   841      7      53  313      38
    ## 842   842      7      53  313       2
    ## 843   843      7      53  314       2
    ## 844   844      7      53  314      38
    ## 845   845      7      53  314      40
    ## 846   846      7      53  314      38
    ## 847   847      7      53  314      38
    ## 848   848      7      53  314       2
    ## 849   849      7      53  314      38
    ## 850   850      7      53  314       2
    ## 851   851      7      53  315      39
    ## 852   852      7      53  315      39
    ## 853   853      7      53  315       2
    ## 854   854      7      54  317       2
    ## 855   855      7      54  318      42
    ## 856   856      7      54  319       2
    ## 857   857      7      54  319      38
    ## 858   858      7      54  320      42
    ## 859   859      7      54  320       2
    ## 860   860      7      54  320       2
    ## 861   861      7      54  320      38
    ## 862   862      7      54  320      38
    ## 863   863      7      54  321      38
    ## 864   864      7      54  321      38
    ## 865   865      7      54  321      38
    ## 866   866      7      54  321      38
    ## 867   867      7      54  321      38
    ## 868   868      7      54  321      38
    ## 869   869      7      54  321      40
    ## 870   870      7      54  321      41
    ## 871   871      7      54  321      41
    ## 872   872      7      54  321      41
    ## 873   873      7      54  322      39
    ## 874   874      8      55  323       2
    ## 875   875      8      55  323      45
    ## 876   876      8      55  324      46
    ## 877   877      8      55  324       2
    ## 878   878      8      55  325      44
    ## 879   879      8      55  325      44
    ## 880   880      8      55  326      47
    ## 881   881      8      55  326      47
    ## 882   882      8      55  326      44
    ## 883   883      8      56  329       2
    ## 884   884      8      56  330       2
    ## 885   885      8      56  331      47
    ## 886   886      8      56  332       2
    ## 887   887      8      56  333      44
    ## 888   888      8      56  333      44
    ## 889   889      8      57  335       2
    ## 890   890      8      57  336       2
    ## 891   891      8      57  337      43
    ## 892   892      8      57  337      43
    ## 893   893      8      57  337       2
    ## 894   894      8      57  338      44
    ## 895   895      8      57  338      45
    ## 896   896      8      57  339      43
    ## 897   897      8      57  339      46
    ## 898   898      8      57  339      46
    ## 899   899      8      58  340       2
    ## 900   900      8      58  342       2
    ## 901   901      8      58  344      44
    ## 902   902      8      59  347      44
    ## 903   903      8      59  347      44
    ## 904   904      8      59  347      43
    ## 905   905      8      59  347      43
    ## 906   906      8      59  347      46
    ## 907   907      8      59  348      44
    ## 908   908      8      59  348      44
    ## 909   909      8      59  351       2
    ## 910   910      8      60  352       2
    ## 911   911      8      60  352      43
    ## 912   912      8      60  354      45
    ## 913   913      8      60  355      43
    ## 914   914      8      60  355      43
    ## 915   915      8      60  355      47
    ## 916   916      8      60  355      46
    ## 917   917      8      60  355      45
    ## 918   918      8      61   NA       2
    ## 919   919      8      61   NA       2
    ## 920   920      8      61  359      43
    ## 921   921      8      61  359      43
    ## 922   922      8      61  359      43
    ## 923   923      8      61  359      46
    ## 924   924      8      61  360      44
    ## 925   925      8      61  361      43
    ## 926   926      8      61  361      45
    ## 927   927      8      61  361       1
    ## 928   928      8      61  361       2
    ## 929   929      8      62  363      46
    ## 930   930      8      62  364      44
    ## 931   931      8      62  364       2
    ## 932   932      8      62  364      46
    ## 933   933      8      62  364       2
    ## 934   934      8      62  364       2
    ## 935   935      8      62  364      45
    ## 936   936      8      62  365      44
    ## 937   937      8      62  365      43
    ## 938   938      8      62  365      45
    ## 939   939      8      62  365      43
    ## 940   940      8      62  365      43
    ## 941   941      8      62  366       2
    ## 942   942      8      62  366      44
    ## 943   943      8      62  366      44
    ## 944   944      8      63  368      46
    ## 945   945      8      63  368       2
    ## 946   946      8      63  369      46
    ## 947   947      8      63  369       2
    ## 948   948      8      63  372      45
    ## 949   949      8      63  372      45
    ## 950   950      8      63  372      43
    ## 951   951      8      63  372       2
    ## 952   952      8      63  372       1
    ## 953   953      8      63  372      44
    ## 954   954      8      63  373      43
    ## 955   955      8      64  374      43
    ## 956   956      8      64  375      43
    ## 957   957      8      64  375      44
    ## 958   958      8      64  375      44
    ## 959   959      8      64  376      44
    ## 960   960      8      64  376      44
    ## 961   961      8      64  376      44
    ## 962   962      8      64  376      44
    ## 963   963      8      64  376      46
    ## 964   964      8      64  376       2
    ## 965   965      8      64  377      44
    ## 966   966      8      64  377      46
    ## 967   967      8      64  378      43
    ## 968   968      8      64  378      43
    ## 969   969      9      65  379      48
    ## 970   970      9      65  380      51
    ## 971   971      9      65  380       2
    ## 972   972      9      65  381      49
    ## 973   973      9      65  381      50
    ## 974   974      9      65  381      48
    ## 975   975      9      65  381      52
    ## 976   976      9      65  381      48
    ## 977   977      9      65  381      52
    ## 978   978      9      65  381      48
    ## 979   979      9      65  381      52
    ## 980   980      9      65  381       2
    ## 981   981      9      65  382       2
    ## 982   982      9      65  383      48
    ## 983   983      9      65  383      50
    ## 984   984      9      66   NA       2
    ## 985   985      9      66  384       2
    ## 986   986      9      66  385      52
    ## 987   987      9      66  385      52
    ## 988   988      9      66  386      48
    ## 989   989      9      66  386      52
    ## 990   990      9      66  386      51
    ## 991   991      9      66  386      48
    ## 992   992      9      66  386       2
    ## 993   993      9      66  386       1
    ## 994   994      9      66  386      49
    ## 995   995      9      66  387      50
    ## 996   996      9      66  387       2
    ## 997   997      9      66  387      50
    ## 998   998      9      66  387      50
    ## 999   999      9      66  388      49
    ## 1000 1000      9      67  389       2
    ## 1001 1001      9      67  389       2
    ## 1002 1002      9      67  389      48
    ## 1003 1003      9      67  389       1
    ## 1004 1004      9      67  389       2
    ## 1005 1005      9      67  389       2
    ## 1006 1006      9      67  390      49
    ## 1007 1007      9      67  390       2
    ## 1008 1008      9      67  390      52
    ## 1009 1009      9      67  391      52
    ## 1010 1010      9      67  391      52
    ## 1011 1011      9      67  391       2
    ## 1012 1012      9      67  392      51
    ## 1013 1013      9      67  393      51
    ## 1014 1014      9      67  393      49
    ## 1015 1015      9      67  393       2
    ## 1016 1016      9      67  393      50
    ## 1017 1017      9      67  393       2
    ## 1018 1018      9      67  393      48
    ## 1019 1019      9      67  393      52
    ## 1020 1020      9      67  394      48
    ## 1021 1021      9      67  394       2
    ## 1022 1022      9      67  394      48
    ## 1023 1023      9      67  394      52
    ## 1024 1024      9      68  395       2
    ## 1025 1025      9      68  396      48
    ## 1026 1026      9      68  397      49
    ## 1027 1027      9      68  398      48
    ## 1028 1028      9      68  398      52
    ## 1029 1029      9      68  398       2
    ## 1030 1030      9      68  398      49
    ## 1031 1031      9      68  399      49
    ## 1032 1032      9      68  399      52
    ## 1033 1033      9      68  399       2
    ## 1034 1034      9      69  400       2
    ## 1035 1035      9      69  400      48
    ## 1036 1036      9      69  400       2
    ## 1037 1037      9      69  400      49
    ## 1038 1038      9      69  401      51
    ## 1039 1039      9      69  401      52
    ## 1040 1040      9      69  401      49
    ## 1041 1041      9      69  402      48
    ## 1042 1042      9      69  402      48
    ## 1043 1043      9      69  402      48
    ## 1044 1044      9      69  402      48
    ## 1045 1045      9      69  402      52
    ## 1046 1046      9      69  403       0
    ## 1047 1047      9      69  403       2
    ## 1048 1048      9      69  403      49
    ## 1049 1049      9      69  404      49
    ## 1050 1050      9      70  405      48
    ## 1051 1051      9      70  406      48
    ## 1052 1052      9      70  406       1
    ## 1053 1053      9      70  406      11
    ## 1054 1054      9      70  406       1
    ## 1055 1055      9      70  407      50
    ## 1056 1056      9      70  409      50
    ## 1057 1057      9      70  409       2
    ## 1058 1058      9      70  409      48
    ## 1059 1059      9      70  409      52
    ## 1060 1060      9      71  410      48
    ## 1061 1061      9      71  410      48
    ## 1062 1062      9      71  410       1
    ## 1063 1063      9      71  410      51
    ## 1064 1064      9      71  410      49
    ## 1065 1065      9      71  410       2
    ## 1066 1066      9      71  410      50
    ## 1067 1067      9      71  410       2
    ## 1068 1068      9      71  411      49
    ## 1069 1069      9      71  411      49
    ## 1070 1070      9      71  411      49
    ## 1071 1071      9      71  411      48
    ## 1072 1072      9      71  411      52
    ## 1073 1073      9      71  411      48
    ## 1074 1074      9      71  411      50
    ## 1075 1075      9      71  412      48
    ## 1076 1076      9      71  412      50
    ## 1077 1077      9      71  412      52
    ## 1078 1078      9      71  412      52
    ## 1079 1079      9      71  412       2
    ## 1080 1080      9      71  412      50
    ## 1081 1081      9      71  412       2
    ## 1082 1082      9      71  412      50
    ## 1083 1083      9      71  413      48
    ## 1084 1084      9      71  413      48
    ## 1085 1085      9      71  413      52
    ## 1086 1086      9      71  413      52
    ## 1087 1087      9      71  414      48
    ## 1088 1088      9      71  414      50
    ## 1089 1089      9      71  414      50
    ## 1090 1090      9      71  414       2
    ## 1091 1091      9      72  415      50
    ## 1092 1092      9      72  415       2
    ## 1093 1093      9      72  416      50
    ## 1094 1094      9      72  416      50
    ## 1095 1095      9      72  417      48
    ## 1096 1096      9      72  417      50
    ## 1097 1097      9      72  417       2
    ## 1098 1098      9      72  417       1
    ## 1099 1099      9      72  417       2
    ## 1100 1100      9      72  417       2
    ## 1101 1101      9      73  421      48
    ## 1102 1102      9      73  421      49
    ## 1103 1103      9      73  422      48
    ## 1104 1104      9      73  422      50
    ## 1105 1105      9      73  422      50
    ## 1106 1106      9      73  422      49
    ## 1107 1107      9      73  423      49
    ## 1108 1108      9      73  423       2
    ## 1109 1109      9      73  424      49
    ## 1110 1110      9      73  424      49
    ## 1111 1111      9      73  424      50
    ## 1112 1112      9      74  425       2
    ## 1113 1113      9      74  426      48
    ## 1114 1114      9      74  426      48
    ## 1115 1115      9      74  426       2
    ## 1116 1116      9      74  426      48
    ## 1117 1117      9      74  426      50
    ## 1118 1118      9      74  426       2
    ## 1119 1119      9      74  426      51
    ## 1120 1120      9      74  426       2
    ## 1121 1121      9      74  426      49
    ## 1122 1122      9      74  426       2
    ## 1123 1123      9      74  427      50
    ## 1124 1124      9      74  427      50
    ## 1125 1125      9      74  428      49
    ## 1126 1126      9      74  428      51
    ## 1127 1127      9      74  428       2
    ## 1128 1128      9      74  428      50
    ## 1129 1129      9      74  428      49
    ## 1130 1130      9      74  428      50
    ## 1131 1131      9      74  428      49
    ## 1132 1132      9      74  428      49
    ## 1133 1133      9      74  428      49
    ## 1134 1134      9      74  428      49
    ## 1135 1135      9      74  429      48
    ## 1136 1136      9      74  429      48
    ## 1137 1137      9      74  429      51
    ## 1138 1138     10      75  431       2
    ## 1139 1139     10      75  431       2
    ## 1140 1140     10      75  431       2
    ## 1141 1141     10      75  432      54
    ## 1142 1142     10      75  432      53
    ## 1143 1143     10      75  432      56
    ## 1144 1144     10      75  433       2
    ## 1145 1145     10      75  433       2
    ## 1146 1146     10      75  433       2
    ## 1147 1147     10      75  434      54
    ## 1148 1148     10      75  435      55
    ## 1149 1149     10      75  435      55
    ## 1150 1150     10      76  436       2
    ## 1151 1151     10      76  436       2
    ## 1152 1152     10      76  437      56
    ## 1153 1153     10      76  437       2
    ## 1154 1154     10      76  437       1
    ## 1155 1155     10      76  437       2
    ## 1156 1156     10      76  438      54
    ## 1157 1157     10      76  439      56
    ## 1158 1158     10      76  439       2
    ## 1159 1159     10      76  439      55
    ## 1160 1160     10      76  439       1
    ## 1161 1161     10      76  439      54
    ## 1162 1162     10      76  439      54
    ## 1163 1163     10      76  440       1
    ## 1164 1164     10      77  443       2
    ## 1165 1165     10      77  443       2
    ## 1166 1166     10      77  443      56
    ## 1167 1167     10      77  443       2
    ## 1168 1168     10      77  444      55
    ## 1169 1169     10      77  444      57
    ## 1170 1170     10      77  444       2
    ## 1171 1171     10      77  444      56
    ## 1172 1172     10      77  444      53
    ## 1173 1173     10      77  445      56
    ## 1174 1174     10      78  447      56
    ## 1175 1175     10      78  448      56
    ## 1176 1176     10      78  448      56
    ## 1177 1177     10      78  448      57
    ## 1178 1178     10      78  448       2
    ## 1179 1179     10      78  448      54
    ## 1180 1180     10      78  450      56
    ## 1181 1181     10      78  450      54
    ## 1182 1182     10      78  450      55
    ## 1183 1183     10      78  450       2
    ## 1184 1184     10      78  451       2
    ## 1185 1185     10      79  453       2
    ## 1186 1186     10      79  453      53
    ## 1187 1187     10      79  453       2
    ## 1188 1188     10      79  454      56
    ## 1189 1189     10      79  454      56
    ## 1190 1190     10      79  454      54
    ## 1191 1191     10      79  454       2
    ## 1192 1192     10      79  455      53
    ## 1193 1193     10      79  455       2
    ## 1194 1194     10      79  455       2
    ## 1195 1195     10      79  455      57
    ## 1196 1196     10      79  455      56
    ## 1197 1197     10      79  456      54
    ## 1198 1198     10      79  457      56
    ## 1199 1199     10      79  457      53
    ## 1200 1200     10      79  457      53
    ## 1201 1201     10      79  457      53
    ## 1202 1202     10      79  457      53
    ## 1203 1203     10      80  459      53
    ## 1204 1204     10      80  459       1
    ## 1205 1205     10      80  459       1
    ## 1206 1206     10      80  459       2
    ## 1207 1207     10      80  459       2
    ## 1208 1208     10      80  459      56
    ## 1209 1209     10      80  459       2
    ## 1210 1210     10      80  460      54
    ## 1211 1211     10      80  460       2
    ## 1212 1212     10      80  461      53
    ## 1213 1213     10      80  461      53
    ## 1214 1214     10      80  461      55
    ## 1215 1215     10      80  462      56
    ## 1216 1216     10      80  462       2
    ## 1217 1217     10      80  462      57
    ## 1218 1218     10      81  464      53
    ## 1219 1219     10      81  464      53
    ## 1220 1220     10      81  464      53
    ## 1221 1221     10      81  465      53
    ## 1222 1222     10      81  465      53
    ## 1223 1223     10      81  466      56
    ## 1224 1224     10      81  466       2
    ## 1225 1225     10      81  466       2
    ## 1226 1226     10      81  467       2
    ## 1227 1227     10      81  467      53
    ## 1228 1228     10      81  467       2
    ## 1229 1229     10      82  470      53
    ## 1230 1230     10      82  470       2
    ## 1231 1231     10      82  470      55
    ## 1232 1232     10      82  470      55
    ## 1233 1233     10      82  471      55
    ## 1234 1234     10      82  471      57
    ## 1235 1235     10      82  471       1
    ## 1236 1236     10      82  471      57
    ## 1237 1237     10      82  471       2
    ## 1238 1238     10      83  474      56
    ## 1239 1239     10      83  475      55
    ## 1240 1240     10      83  475      53
    ## 1241 1241     10      83  475      53
    ## 1242 1242     10      83  475      53
    ## 1243 1243     10      83  475      57
    ## 1244 1244     10      83  476      57
    ## 1245 1245     10      83  476      56
    ## 1246 1246     10      83  476      53
    ## 1247 1247     10      83  477      56
    ## 1248 1248     10      83  477      53
    ## 1249 1249     10      83  477      53
    ## 1250 1250     10      83  477      53
    ## 1251 1251     10      83  477      55
    ## 1252 1252     10      83  478      55
    ## 1253 1253     10      84  479       2
    ## 1254 1254     10      84  479      56
    ## 1255 1255     10      84  480       2
    ## 1256 1256     10      84  480      56
    ## 1257 1257     10      84  480      56
    ## 1258 1258     10      84  480      56
    ## 1259 1259     10      84  480      56
    ## 1260 1260     10      84  480      54
    ## 1261 1261     10      84  480      55
    ## 1262 1262     10      84  481      56
    ## 1263 1263     10      84  481      53
    ## 1264 1264     10      84  482      56
    ## 1265 1265     10      84  482      56
    ## 1266 1266     10      84  482      56
    ## 1267 1267     10      84  482      56
    ## 1268 1268     10      84  482      53
    ## 1269 1269     10      84  483      53
    ## 1270 1270     10      84  483      53
    ## 1271 1271     -2      85  485      61
    ## 1272 1272     -2      85  485      61
    ## 1273 1273     -2      85  486      61
    ## 1274 1274     -2      85  486      61
    ## 1275 1275     -2      85  486       2
    ## 1276 1276     -2      85  486       2
    ## 1277 1277     -2      85  486       2
    ## 1278 1278     -2      85  487      61
    ## 1279 1279     -2      85  487      61
    ## 1280 1280     -2      85  487       2
    ## 1281 1281     -2      85  487      60
    ## 1282 1282     -2      85  487       2
    ## 1283 1283     -2      85  488      60
    ## 1284 1284     -2      85  488      61
    ## 1285 1285     -2      85  488      61
    ## 1286 1286     -2      85  488      61
    ## 1287 1287     -2      85  489       2
    ## 1288 1288     -2      85  489      60
    ## 1289 1289     -2      85  489      58
    ## 1290 1290     -2      85  489      58
    ## 1291 1291     11      86  491      65
    ## 1292 1292     11      86  491      64
    ## 1293 1293     11      86  493      65
    ## 1294 1294     11      86  494      64
    ## 1295 1295     11      87  495      64
    ## 1296 1296     11      87  495      64
    ## 1297 1297     11      87  496      65
    ## 1298 1298     11      87  496       2
    ## 1299 1299     11      87  497      64
    ## 1300 1300     11      87  497      65
    ## 1301 1301     11      87  497      65
    ## 1302 1302     11      87  497      64
    ## 1303 1303     11      87  498      64
    ## 1304 1304     11      88  500       2
    ## 1305 1305     11      88  501      65
    ## 1306 1306     11      88  502       2
    ## 1307 1307     11      88  503       2
    ## 1308 1308     11      88  503       1
    ## 1309 1309     11      88  503      64
    ## 1310 1310     11      88  504      65
    ## 1311 1311     11      88  504       2
    ## 1312 1312     11      89  505      66
    ## 1313 1313     11      89  506      67
    ## 1314 1314     11      89  506      67
    ## 1315 1315     11      89  508      64
    ## 1316 1316     11      89  508      67
    ## 1317 1317     11      89  509       2
    ## 1318 1318     11      90  511      65
    ## 1319 1319     11      90  512      64
    ## 1320 1320     11      90  512      64
    ## 1321 1321     11      90  513      63
    ## 1322 1322     11      90  513      63
    ## 1323 1323     11      90  513      64
    ## 1324 1324     11      90  513      64
    ## 1325 1325     11      90  513      64
    ## 1326 1326     11      90  513      64
    ## 1327 1327     11      90  514      63
    ## 1328 1328     11      90  514      64
    ## 1329 1329     11      91  515      67
    ## 1330 1330     11      91  515       2
    ## 1331 1331     11      91  515      64
    ## 1332 1332     11      91  517      64
    ## 1333 1333     11      91  517       2
    ## 1334 1334     11      91  517       1
    ## 1335 1335     11      91  517       1
    ## 1336 1336     11      91  518      64
    ## 1337 1337     11      91  518      64
    ## 1338 1338     11      91  518       2
    ## 1339 1339     11      91  519      64
    ## 1340 1340     11      91  519      67
    ## 1341 1341     11      91  519      67
    ## 1342 1342     11      91  521      64
    ## 1343 1343     11      92  523      67
    ## 1344 1344     11      92  523       2
    ## 1345 1345     11      92  523      67
    ## 1346 1346     11      92  523       2
    ## 1347 1347     11      92  523      65
    ## 1348 1348     11      92  524       2
    ## 1349 1349     11      92  525      65
    ## 1350 1350     11      93  527       2
    ## 1351 1351     11      93  528      67
    ## 1352 1352     11      93  528      67
    ## 1353 1353     11      93  528      64
    ## 1354 1354     11      93  529      65
    ## 1355 1355     11      93  529       1
    ## 1356 1356     11      93  529      64
    ## 1357 1357     11      93  530      65
    ## 1358 1358     11      93  530      65
    ## 1359 1359     11      93  530      67
    ## 1360 1360     11      93  531       2
    ## 1361 1361     11      94  533       2
    ## 1362 1362     11      94  533      67
    ## 1363 1363     11      94  534      67
    ## 1364 1364     11      94  534       2
    ## 1365 1365     11      94  534       2
    ## 1366 1366     11      94  534      64
    ## 1367 1367     11      94  534       2
    ## 1368 1368     11      94  534      64
    ## 1369 1369     11      94  534       2
    ## 1370 1370     11      94  534       2
    ## 1371 1371     11      94  534      65
    ## 1372 1372     11      94  535       2
    ## 1373 1373     11      95  537       2
    ## 1374 1374     11      95  538      67
    ## 1375 1375     11      95  538      64
    ## 1376 1376     11      95  538      64
    ## 1377 1377     11      95  538      64
    ## 1378 1378     11      95  538       2
    ## 1379 1379     11      95  538       2
    ## 1380 1380     11      95  538      64
    ## 1381 1381     11      95  538       1
    ## 1382 1382     11      95  538       1
    ## 1383 1383     11      95  538      65
    ## 1384 1384     11      95  539      64
    ## 1385 1385     11      95  539      64
    ## 1386 1386     11      95  540       2
    ## 1387 1387     11      95  540       2
    ## 1388 1388     11      95  540      63
    ## 1389 1389     11      95  540      64
    ## 1390 1390     11      95  540       2
    ## 1391 1391     12      96  543      71
    ## 1392 1392     12      96  543      69
    ## 1393 1393     12      96  543      69
    ## 1394 1394     12      96  543      71
    ## 1395 1395     12      96  543       2
    ## 1396 1396     12      96  544      69
    ## 1397 1397     12      96  544      69
    ## 1398 1398     12      96  544      69
    ## 1399 1399     12      96  544      68
    ## 1400 1400     12      96  544      71
    ## 1401 1401     12      96  544      71
    ## 1402 1402     12      96  544      70
    ## 1403 1403     12      96  544       2
    ## 1404 1404     12      96  544      69
    ## 1405 1405     12      96  544      71
    ## 1406 1406     12      96  545       2
    ## 1407 1407     12      96  545      71
    ## 1408 1408     12      96  545      71
    ## 1409 1409     12      96  545      69
    ## 1410 1410     12      96  546      71
    ## 1411 1411     12      97  547       2
    ## 1412 1412     12      97  547      71
    ## 1413 1413     12      97  548      70
    ## 1414 1414     12      97  548       2
    ## 1415 1415     12      97  548      70
    ## 1416 1416     12      97  548      71
    ## 1417 1417     12      97  548      70
    ## 1418 1418     12      97  548      70
    ## 1419 1419     12      97  548       2
    ## 1420 1420     12      97  549      68
    ## 1421 1421     12      97  549      70
    ## 1422 1422     12      97  549       1
    ## 1423 1423     12      97  549      69
    ## 1424 1424     12      97  549      69
    ## 1425 1425     12      97  550      70
    ## 1426 1426     12      97  550      71
    ## 1427 1427     12      97  550      70
    ## 1428 1428     12      97  550      70
    ## 1429 1429     12      98  552      71
    ## 1430 1430     12      98  552      70
    ## 1431 1431     12      98  553       2
    ## 1432 1432     12      98  553      69
    ## 1433 1433     12      98  554      69
    ## 1434 1434     12      98  554      70
    ## 1435 1435     12      98  554      71
    ## 1436 1436     12      98  555      72
    ## 1437 1437     12      98  556      69
    ## 1438 1438     12      98  556      69
    ## 1439 1439     12      99  557       2
    ## 1440 1440     12      99  558      70
    ## 1441 1441     12      99  558      68
    ## 1442 1442     12      99  559      70
    ## 1443 1443     12      99  559      70
    ## 1444 1444     12      99  559      70
    ## 1445 1445     12      99  560      71
    ## 1446 1446     12      99  560      70
    ## 1447 1447     12      99  560      69
    ## 1448 1448     12      99  560      70
    ## 1449 1449     12      99  560      70
    ## 1450 1450     12      99  560      71
    ## 1451 1451     12      99  561       2
    ## 1452 1452     12      99  561       2
    ## 1453 1453     12      99  561       2
    ## 1454 1454     12     100  562       2
    ## 1455 1455     12     100  563      70
    ## 1456 1456     12     100  563      70
    ## 1457 1457     12     100  563      69
    ## 1458 1458     12     100  563      69
    ## 1459 1459     12     100  564      71
    ## 1460 1460     12     100  565      70
    ## 1461 1461     12     100  565      70
    ## 1462 1462     12     101  568      69
    ## 1463 1463     12     101  568      71
    ## 1464 1464     12     101  570      70
    ## 1465 1465     12     101  570      71
    ## 1466 1466     12     101  571       2
    ## 1467 1467     12     101  571      71
    ## 1468 1468     12     101  571      71
    ## 1469 1469     12     102  572       2
    ## 1470 1470     12     102  572      70
    ## 1471 1471     12     102  572       2
    ## 1472 1472     12     102  572      70
    ## 1473 1473     12     102  572       2
    ## 1474 1474     12     102  573      71
    ## 1475 1475     12     102  573       2
    ## 1476 1476     12     102  573      71
    ## 1477 1477     12     102  573       1
    ## 1478 1478     12     102  574      71
    ## 1479 1479     12     102  575      71
    ## 1480 1480     12     102  575      72
    ## 1481 1481     12     102  576      70
    ## 1482 1482     12     102  576      70
    ## 1483 1483     12     102  576      70
    ## 1484 1484     12     103  577      71
    ## 1485 1485     12     103  577       2
    ## 1486 1486     12     103  578      69
    ## 1487 1487     12     103  578      68
    ## 1488 1488     12     103  578      71
    ## 1489 1489     12     103  579      70
    ## 1490 1490     12     103  579      70
    ## 1491 1491     12     103  579      70
    ## 1492 1492     12     103  579      70
    ## 1493 1493     12     103  579       2
    ## 1494 1494     12     103  580      71
    ## 1495 1495     12     103  580       2
    ## 1496 1496     12     103  581       2
    ## 1497 1497     12     103  582      69
    ## 1498 1498     12     104  584      70
    ## 1499 1499     12     104  584      69
    ## 1500 1500     12     104  586       2
    ## 1501 1501     12     104  586       2
    ## 1502 1502     12     105  588      68
    ## 1503 1503     12     105  589      70
    ## 1504 1504     12     105  589       2
    ## 1505 1505     12     105  590       2
    ## 1506 1506     12     105  591      70
    ## 1507 1507     12     105  591      70
    ## 1508 1508     12     105  591       1
    ## 1509 1509     12     105  591       2
    ## 1510 1510     12     105  591       2
    ## 1511 1511     12     105  592       2
    ## 1512 1512     -3     106  597       2
    ## 1513 1513     -3     106  597      73
    ## 1514 1514     -3     106  597       2
    ## 1515 1515     -3     106  597      73
    ## 1516 1516     -3     106  597       1
    ## 1517 1517     -3     106  597      73
    ## 1518 1518     -3     106  597       2
    ## 1519 1519     13     107  598       2
    ## 1520 1520     13     107  598       2
    ## 1521 1521     13     107  598       2
    ## 1522 1522     13     107  598       2
    ## 1523 1523     13     107  599      78
    ## 1524 1524     13     107  599      80
    ## 1525 1525     13     107  599      81
    ## 1526 1526     13     107  600      80
    ## 1527 1527     13     107  600      80
    ## 1528 1528     13     107  600       2
    ## 1529 1529     13     107  600      80
    ## 1530 1530     13     108  603      79
    ## 1531 1531     13     108  603       2
    ## 1532 1532     13     108  604      79
    ## 1533 1533     13     108  604      81
    ## 1534 1534     13     108  604       2
    ## 1535 1535     13     108  605       2
    ## 1536 1536     13     108  605      82
    ## 1537 1537     13     108  605       2
    ## 1538 1538     13     108  605      79
    ## 1539 1539     13     108  606      80
    ## 1540 1540     13     108  606      80
    ## 1541 1541     13     109   NA       2
    ## 1542 1542     13     109  608      81
    ## 1543 1543     13     109  608       2
    ## 1544 1544     13     109  608       2
    ## 1545 1545     13     109  609      80
    ## 1546 1546     13     109  609      81
    ## 1547 1547     13     109  609       2
    ## 1548 1548     13     109  610      80
    ## 1549 1549     13     109  610      80
    ## 1550 1550     13     109  611      80
    ## 1551 1551     13     109  611      80
    ## 1552 1552     13     109  611      80
    ## 1553 1553     13     109  611      80
    ## 1554 1554     13     109  612      81
    ## 1555 1555     13     109  612       2
    ## 1556 1556     13     109  612      80
    ## 1557 1557     13     109  612      81
    ## 1558 1558     13     110  614      81
    ## 1559 1559     13     110  615       2
    ## 1560 1560     13     110  615      79
    ## 1561 1561     13     110  616       2
    ## 1562 1562     13     110  616      82
    ## 1563 1563     13     110  616       1
    ## 1564 1564     13     110  616      81
    ## 1565 1565     13     110  617      81
    ## 1566 1566     13     111  621      81
    ## 1567 1567     13     111  621      81
    ## 1568 1568     13     111  622      81
    ## 1569 1569     13     111  622      81
    ## 1570 1570     13     111  622       2
    ## 1571 1571     13     111  623      81
    ## 1572 1572     13     111  623      80
    ## 1573 1573     13     111  623       2
    ## 1574 1574     13     112  626       2
    ## 1575 1575     13     112  626       2
    ## 1576 1576     13     112  627      81
    ## 1577 1577     13     112  627      81
    ## 1578 1578     13     112  627      81
    ## 1579 1579     13     112  628      80
    ## 1580 1580     13     112  628      78
    ## 1581 1581     13     112  629       2
    ## 1582 1582     13     112  629      81
    ## 1583 1583     13     112  630      78
    ## 1584 1584     13     113  632      81
    ## 1585 1585     13     113  633      82
    ## 1586 1586     13     113  633       2
    ## 1587 1587     13     113  634       2
    ## 1588 1588     13     113  634      80
    ## 1589 1589     13     113  635      81
    ## 1590 1590     13     113  635       2
    ## 1591 1591     13     113  636      82
    ## 1592 1592     13     113  636      80
    ## 1593 1593     13     114  638      79
    ## 1594 1594     13     114  638       2
    ## 1595 1595     13     114  639      81
    ## 1596 1596     13     114  639      81
    ## 1597 1597     13     114  640      80
    ## 1598 1598     13     114  640       2
    ## 1599 1599     13     114  641       2
    ## 1600 1600     13     115  642       2
    ## 1601 1601     13     115  643      81
    ## 1602 1602     13     115  645      79
    ## 1603 1603     13     115  645      80
    ## 1604 1604     13     115  646      79
    ## 1605 1605     13     115  646      81
    ## 1606 1606     13     116  647      78
    ## 1607 1607     13     116  647       2
    ## 1608 1608     13     116  648      81
    ## 1609 1609     13     116  648      80
    ## 1610 1610     13     116  648      80
    ## 1611 1611     13     116  648      82
    ## 1612 1612     13     116  650      80
    ## 1613 1613     13     116  650      80
    ## 1614 1614     13     116  650      80
    ## 1615 1615     13     116  651       2
    ## 1616 1616     -4     117  653      85
    ## 1617 1617     -4     117  653       2
    ## 1618 1618     -4     117  653       2
    ## 1619 1619     -4     117  653       2
    ## 1620 1620     -4     117  654       2
    ## 1621 1621     -4     117  654      86
    ## 1622 1622     -4     117  654      83
    ## 1623 1623     -4     117  654       2
    ## 1624 1624     -4     117  654       2
    ## 1625 1625     -4     117  655      84
    ## 1626 1626     -4     117  655       2
    ## 1627 1627     -4     117  655       2
    ## 1628 1628     -4     117  655      86
    ## 1629 1629     -4     117  655       2
    ## 1630 1630     -4     117  655      84
    ## 1631 1631     -4     117  656       2
    ## 1632 1632     -4     117  656      83
    ## 1633 1633     -4     117  657       2
    ## 1634 1634     -4     117  657      84
    ## 1635 1635     14     118  659      90
    ## 1636 1636     14     118  659      88
    ## 1637 1637     14     118  659      88
    ## 1638 1638     14     118  659      88
    ## 1639 1639     14     118  659      88
    ## 1640 1640     14     118  659       2
    ## 1641 1641     14     118  660       2
    ## 1642 1642     14     118  660      91
    ## 1643 1643     14     118  661      91
    ## 1644 1644     14     118  661      88
    ## 1645 1645     14     118  661      88
    ## 1646 1646     14     118  662       2
    ## 1647 1647     14     118  662       2
    ## 1648 1648     14     119  663      92
    ## 1649 1649     14     119  665      88
    ## 1650 1650     14     119  665      90
    ## 1651 1651     14     119  665       2
    ## 1652 1652     14     119  665      92
    ## 1653 1653     14     119  665       2
    ## 1654 1654     14     119  666      90
    ## 1655 1655     14     119  666      92
    ## 1656 1656     14     119  666      91
    ## 1657 1657     14     119  666      92
    ## 1658 1658     14     119  666      89
    ## 1659 1659     14     119  666      90
    ## 1660 1660     14     119  666      90
    ## 1661 1661     14     119  667      90
    ## 1662 1662     14     119  667      90
    ## 1663 1663     14     119  667       2
    ## 1664 1664     14     119  667      90
    ## 1665 1665     14     119  667      92
    ## 1666 1666     14     119  667      91
    ## 1667 1667     14     119  667       2
    ## 1668 1668     14     120  669      92
    ## 1669 1669     14     120  669       2
    ## 1670 1670     14     120  670      91
    ## 1671 1671     14     120  670      92
    ## 1672 1672     14     120  670      90
    ## 1673 1673     14     120  670      90
    ## 1674 1674     14     120  670      89
    ## 1675 1675     14     120  670      89
    ## 1676 1676     14     120  670      90
    ## 1677 1677     14     120  670      90
    ## 1678 1678     14     120  671      91
    ## 1679 1679     14     120  671      92
    ## 1680 1680     14     120  671      92
    ## 1681 1681     14     120  671      92
    ## 1682 1682     14     120  671      92
    ## 1683 1683     14     120  671      89
    ## 1684 1684     14     120  671       2
    ## 1685 1685     14     120  671      92
    ## 1686 1686     14     120  671      90
    ## 1687 1687     14     120  672      92
    ## 1688 1688     14     120  672       1
    ## 1689 1689     14     120  672      90
    ## 1690 1690     14     120  672      90
    ## 1691 1691     14     120  672      90
    ## 1692 1692     14     120  672       2
    ## 1693 1693     14     120  672       2
    ## 1694 1694     14     120  673       2
    ## 1695 1695     14     120  673       1
    ## 1696 1696     14     121  675      89
    ## 1697 1697     14     121  675      91
    ## 1698 1698     14     121  675      90
    ## 1699 1699     14     121  675      92
    ## 1700 1700     14     121  676      92
    ## 1701 1701     14     121  676      90
    ## 1702 1702     14     121  676      90
    ## 1703 1703     14     121  677      90
    ## 1704 1704     14     121  677      92
    ## 1705 1705     14     121  677       2
    ## 1706 1706     14     121  678       2
    ## 1707 1707     14     121  678      89
    ## 1708 1708     14     122  679       2
    ## 1709 1709     14     122  680      90
    ## 1710 1710     14     122  680      90
    ## 1711 1711     14     122  680      90
    ## 1712 1712     14     122  681      90
    ## 1713 1713     14     122  681      89
    ## 1714 1714     14     122  682      90
    ## 1715 1715     14     122  682      89
    ## 1716 1716     14     122  682      92
    ## 1717 1717     14     122  682       2
    ## 1718 1718     14     122  682      90
    ## 1719 1719     14     122  682      91
    ## 1720 1720     14     122  683       2
    ## 1721 1721     14     123  684      91
    ## 1722 1722     14     123  685      90
    ## 1723 1723     14     123  685       2
    ## 1724 1724     14     123  685      92
    ## 1725 1725     14     123  685      88
    ## 1726 1726     14     123  685       2
    ## 1727 1727     14     123  686      88
    ## 1728 1728     14     123  687      91
    ## 1729 1729     14     123  687      89
    ## 1730 1730     14     123  687      92
    ## 1731 1731     14     123  687      90
    ## 1732 1732     14     124  689      89
    ## 1733 1733     14     124  689       2
    ## 1734 1734     14     124  689       2
    ## 1735 1735     14     124  689       2
    ## 1736 1736     14     124  689       2
    ## 1737 1737     14     124  690      90
    ## 1738 1738     14     124  690      88
    ## 1739 1739     14     124  691      91
    ## 1740 1740     14     124  692      91
    ## 1741 1741     14     124  692      91
    ## 1742 1742     14     124  692      92
    ## 1743 1743     14     124  693      89
    ## 1744 1744     14     124  693       2
    ## 1745 1745     14     125  695      92
    ## 1746 1746     14     125  695      88
    ## 1747 1747     14     125  695       2
    ## 1748 1748     14     125  697      88
    ## 1749 1749     14     125  697      90
    ## 1750 1750     14     125  697       2
    ## 1751 1751     14     125  697      91
    ## 1752 1752     14     125  698      92
    ## 1753 1753     14     125  698       2
    ## 1754 1754     14     126  700      92
    ## 1755 1755     14     126  700       2
    ## 1756 1756     14     126  702      90
    ## 1757 1757     14     126  702      92
    ## 1758 1758     14     126  702      89
    ## 1759 1759     14     126  702      89
    ## 1760 1760     14     126  702      89
    ## 1761 1761     14     126  702      88
    ## 1762 1762     14     126  703       2
    ## 1763 1763     14     126  703      92
    ## 1764 1764     14     126  703       2
    ## 1765 1765     14     127  706      90
    ## 1766 1766     14     127  707      90
    ## 1767 1767     14     127  707      91
    ## 1768 1768     14     127  707      90
    ## 1769 1769     14     127  707       2
    ## 1770 1770     14     127  707      92
    ## 1771 1771     14     127  707       1
    ## 1772 1772     14     127  708      92
    ## 1773 1773     14     127  708      88
    ## 1774 1774     14     127  708      90
    ## 1775 1775     14     127  709      91
    ## 1776 1776     14     127  709       2
    ## 1777 1777     14     127  710       2
    ## 1778 1778     14     127  710      90
    ## 1779 1779     -5     128  712      97
    ## 1780 1780     -5     128  712      97
    ## 1781 1781     -5     128  712       2
    ## 1782 1782     -5     128  713      95
    ## 1783 1783     -5     128  713       2
    ## 1784 1784     -5     128  714      95
    ## 1785 1785     -5     128  714      94
    ## 1786 1786     -5     128  714      97
    ## 1787 1787     -5     128  714      97
    ## 1788 1788     -5     128  714      97
    ## 1789 1789     -5     128  714       2
    ## 1790 1790     -5     128  714      97
    ## 1791 1791     -5     128  715      97
    ## 1792 1792     -5     128  715      97
    ## 1793 1793     -5     128  715      95
    ## 1794 1794     15     129   NA       2
    ## 1795 1795     15     129  717       2
    ## 1796 1796     15     129  717       2
    ## 1797 1797     15     129  717       2
    ## 1798 1798     15     129  718     100
    ## 1799 1799     15     129  718       2
    ## 1800 1800     15     129  718     101
    ## 1801 1801     15     129  718     100
    ## 1802 1802     15     129  718     100
    ## 1803 1803     15     129  718       2
    ## 1804 1804     15     129  719     100
    ## 1805 1805     15     129  719       1
    ## 1806 1806     15     129  719     102
    ## 1807 1807     15     129  719     102
    ## 1808 1808     15     129  719       2
    ## 1809 1809     15     130  721       2
    ## 1810 1810     15     130  722     100
    ## 1811 1811     15     130  723       2
    ## 1812 1812     15     130  723       2
    ## 1813 1813     15     130  723      98
    ## 1814 1814     15     130  723       2
    ## 1815 1815     15     130  723     100
    ## 1816 1816     15     130  723     100
    ## 1817 1817     15     130  725     101
    ## 1818 1818     15     130  725     101
    ## 1819 1819     15     130  725     101
    ## 1820 1820     15     131  726       2
    ## 1821 1821     15     131  726       2
    ## 1822 1822     15     131  726       2
    ## 1823 1823     15     131  726     101
    ## 1824 1824     15     131  726     102
    ## 1825 1825     15     131  726       2
    ## 1826 1826     15     131  728     102
    ## 1827 1827     15     131  728      98
    ## 1828 1828     15     131  728     101
    ## 1829 1829     15     131  728     102
    ## 1830 1830     15     131  728     102
    ## 1831 1831     15     132  732     100
    ## 1832 1832     15     132  732     101
    ## 1833 1833     15     132  732       2
    ## 1834 1834     15     132  732      98
    ## 1835 1835     15     132  733     100
    ## 1836 1836     15     132  733       2
    ## 1837 1837     15     132  734     100
    ## 1838 1838     15     132  734     100
    ## 1839 1839     15     132  734     100
    ## 1840 1840     15     132  734      98
    ## 1841 1841     15     132  734       2
    ## 1842 1842     15     132  735     101
    ## 1843 1843     15     132  735       1
    ## 1844 1844     15     132  735      98
    ## 1845 1845     15     132  735       2
    ## 1846 1846     15     132  735     101
    ## 1847 1847     15     133   NA       2
    ## 1848 1848     15     133  738      98
    ## 1849 1849     15     133  738      98
    ## 1850 1850     15     133  738     101
    ## 1851 1851     15     133  738     101
    ## 1852 1852     15     133  739      98
    ## 1853 1853     15     133  740      98
    ## 1854 1854     15     134  741       2
    ## 1855 1855     15     134  742       2
    ## 1856 1856     15     134  742      98
    ## 1857 1857     15     134  742       2
    ## 1858 1858     15     134  742       2
    ## 1859 1859     15     134  743     102
    ## 1860 1860     15     134  743     102
    ## 1861 1861     15     134  744     100
    ## 1862 1862     15     134  745     100
    ## 1863 1863     15     135  747     100
    ## 1864 1864     15     135  747     100
    ## 1865 1865     15     135  748     100
    ## 1866 1866     15     135  748     101
    ## 1867 1867     15     135  748      98
    ## 1868 1868     15     135  748      98
    ## 1869 1869     15     135  749      99
    ## 1870 1870     15     135  749     100
    ## 1871 1871     15     135  749     100
    ## 1872 1872     15     136  751      99
    ## 1873 1873     15     136  751      98
    ## 1874 1874     15     136  752     100
    ## 1875 1875     15     136  752     102
    ## 1876 1876     15     136  752     101
    ## 1877 1877     15     136  753     100
    ## 1878 1878     15     136  754      98
    ## 1879 1879     15     136  755      98
    ## 1880 1880     15     137  757     100
    ## 1881 1881     15     137  757     100
    ## 1882 1882     15     137  757     102
    ## 1883 1883     15     137  757      99
    ## 1884 1884     15     137  758     100
    ## 1885 1885     15     137  758      99
    ## 1886 1886     15     137  758      98
    ## 1887 1887     15     137  758       2
    ## 1888 1888     15     137  759     100
    ## 1889 1889     15     137  759      98
    ## 1890 1890     15     137  759     100
    ## 1891 1891     15     137  759      98
    ## 1892 1892     15     138  761       2
    ## 1893 1893     15     138  761      99
    ## 1894 1894     15     138  761      99
    ## 1895 1895     15     138  762     100
    ## 1896 1896     15     138  762     101
    ## 1897 1897     15     138  762     101
    ## 1898 1898     15     138  763     102
    ## 1899 1899     15     138  763     100
    ## 1900 1900     15     138  763     100
    ## 1901 1901     15     138  764      98
    ## 1902 1902     15     138  764      99
    ## 1903 1903     15     138  766       2
    ## 1904 1904     16     139  768     107
    ## 1905 1905     16     139  768     105
    ## 1906 1906     16     139  768     105
    ## 1907 1907     16     139  768     105
    ## 1908 1908     16     139  768     106
    ## 1909 1909     16     139  768       1
    ## 1910 1910     16     139  769     106
    ## 1911 1911     16     139  769       2
    ## 1912 1912     16     139  770     104
    ## 1913 1913     16     139  770     104
    ## 1914 1914     16     139  771     106
    ## 1915 1915     16     139  771     107
    ## 1916 1916     16     139  771     104
    ## 1917 1917     16     140  772     107
    ## 1918 1918     16     140  772       2
    ## 1919 1919     16     140  772       2
    ## 1920 1920     16     140  772       2
    ## 1921 1921     16     140  772       2
    ## 1922 1922     16     140  772       2
    ## 1923 1923     16     140  774     106
    ## 1924 1924     16     140  774       1
    ## 1925 1925     16     140  774       2
    ## 1926 1926     16     140  774     107
    ## 1927 1927     16     140  775       2
    ## 1928 1928     16     140  776     104
    ## 1929 1929     16     140  776       2
    ## 1930 1930     16     141  778       2
    ## 1931 1931     16     141  778       2
    ## 1932 1932     16     141  779       2
    ## 1933 1933     16     141  780     107
    ## 1934 1934     16     141  780     105
    ## 1935 1935     16     141  781     103
    ## 1936 1936     16     141  781       2
    ## 1937 1937     16     141  781     107
    ## 1938 1938     16     141  781       1
    ## 1939 1939     16     141  781     105
    ## 1940 1940     16     141  781       1
    ## 1941 1941     16     141  781       1
    ## 1942 1942     16     141  781     107
    ## 1943 1943     16     141  781     105
    ## 1944 1944     16     141  781       1
    ## 1945 1945     16     141  781       2
    ## 1946 1946     16     141  781       1
    ## 1947 1947     16     141  781       2
    ## 1948 1948     16     141  782       2
    ## 1949 1949     16     142  785     104
    ## 1950 1950     16     142  785       2
    ## 1951 1951     16     142  785     106
    ## 1952 1952     16     142  785       2
    ## 1953 1953     16     142  786     106
    ## 1954 1954     16     142  786     104
    ## 1955 1955     16     142  786       2
    ## 1956 1956     16     142  786       2
    ## 1957 1957     16     142  787     106
    ## 1958 1958     16     143  789     106
    ## 1959 1959     16     143  790     107
    ## 1960 1960     16     143  790     105
    ## 1961 1961     16     143  790     105
    ## 1962 1962     16     143  791     106
    ## 1963 1963     16     143  791     106
    ## 1964 1964     16     143  791     106
    ## 1965 1965     16     143  791     104
    ## 1966 1966     16     143  791       2
    ## 1967 1967     16     143  791       2
    ## 1968 1968     16     143  791     105
    ## 1969 1969     16     143  792     107
    ## 1970 1970     16     143  792     107
    ## 1971 1971     16     143  792     106
    ## 1972 1972     16     143  792     105
    ## 1973 1973     16     143  793     104
    ## 1974 1974     16     144  794       2
    ## 1975 1975     16     144  795     106
    ## 1976 1976     16     144  796     107
    ## 1977 1977     16     144  796     104
    ## 1978 1978     16     144  796     107
    ## 1979 1979     16     144  796       2
    ## 1980 1980     16     144  796       2
    ## 1981 1981     16     144  797       2
    ## 1982 1982     16     144  798     104
    ## 1983 1983     16     144  798       2
    ## 1984 1984     16     144  798       2
    ## 1985 1985     16     144  798       2
    ## 1986 1986     16     145  799       0
    ## 1987 1987     16     145  799     107
    ## 1988 1988     16     145  799     107
    ## 1989 1989     16     145  799       2
    ## 1990 1990     16     145  800     107
    ## 1991 1991     16     145  800       2
    ## 1992 1992     16     145  800     107
    ## 1993 1993     16     145  800     104
    ## 1994 1994     16     145  800       2
    ## 1995 1995     16     145  800     105
    ## 1996 1996     16     145  801     107
    ## 1997 1997     16     145  801     106
    ## 1998 1998     16     145  801     106
    ## 1999 1999     16     145  801     106
    ## 2000 2000     16     145  801     107
    ## 2001 2001     16     145  801     106
    ## 2002 2002     16     145  801       2
    ## 2003 2003     16     145  801     107
    ## 2004 2004     16     145  801     104
    ## 2005 2005     16     146  806     107
    ## 2006 2006     16     146  806       2
    ## 2007 2007     16     146  806     105
    ## 2008 2008     16     146  807     106
    ## 2009 2009     16     146  807       2
    ## 2010 2010     16     146  808     106
    ## 2011 2011     16     147  810       2
    ## 2012 2012     16     147  810       2
    ## 2013 2013     16     147  810       2
    ## 2014 2014     16     147  810       2
    ## 2015 2015     16     147  811     106
    ## 2016 2016     16     147  811       2
    ## 2017 2017     16     147  811     105
    ## 2018 2018     16     147  811     105
    ## 2019 2019     16     147  811     105
    ## 2020 2020     16     147  811       2
    ## 2021 2021     16     147  811       2
    ## 2022 2022     16     147  811     106
    ## 2023 2023     16     147  811       1
    ## 2024 2024     16     147  813     105
    ## 2025 2025     16     147  813     106
    ## 2026 2026     16     147  813     106
    ## 2027 2027     16     147  814     104
    ## 2028 2028     16     147  814     104
    ## 2029 2029     16     148  815       2
    ## 2030 2030     16     148  815       2
    ## 2031 2031     16     148  815       2
    ## 2032 2032     16     148  815       2
    ## 2033 2033     16     148  815       2
    ## 2034 2034     16     148  816     107
    ## 2035 2035     16     148  817     105
    ## 2036 2036     16     148  817     105
    ## 2037 2037     16     148  817       1
    ## 2038 2038     16     148  817     105
    ## 2039 2039     16     148  817       1
    ## 2040 2040     16     148  817     103
    ## 2041 2041     16     148  818     107
    ##                                            roots
    ## 1                                       ["shit"]
    ## 2                                       ["piss"]
    ## 3                                       ["shit"]
    ## 4                                       ["shit"]
    ## 5                                       ["shit"]
    ## 6                                      ["bitch"]
    ## 7                                       ["shit"]
    ## 8                                       ["shit"]
    ## 9                                       ["shit"]
    ## 10                                      ["shit"]
    ## 11                                    ["Christ"]
    ## 12                                      ["wank"]
    ## 13                                      ["shit"]
    ## 14                                      ["hell"]
    ## 15                                      ["shit"]
    ## 16                                      ["shit"]
    ## 17                                      ["piss"]
    ## 18                                      ["piss"]
    ## 19                                      ["shit"]
    ## 20                                      ["shit"]
    ## 21                             ["Christ","shit"]
    ## 22                                    ["Christ"]
    ## 23                                    ["Christ"]
    ## 24                                      ["fuck"]
    ## 25                                      ["hell"]
    ## 26                                      ["fuck"]
    ## 27                                      ["shit"]
    ## 28                                      ["shit"]
    ## 29                        ["shit","shit","shit"]
    ## 30                                      ["shit"]
    ## 31                                      ["shit"]
    ## 32                                      ["fuck"]
    ## 33                                    ["Christ"]
    ## 34                                      ["shit"]
    ## 35                                      ["shit"]
    ## 36                                      ["fuck"]
    ## 37                                      ["fuck"]
    ## 38                                      ["fuck"]
    ## 39                                      ["fuck"]
    ## 40                                      ["fuck"]
    ## 41                                      ["fuck"]
    ## 42                                      ["hell"]
    ## 43                                      ["fuck"]
    ## 44                                      ["shit"]
    ## 45                                   ["bastard"]
    ## 46                                      ["fuck"]
    ## 47                                      ["fuck"]
    ## 48                                      ["hell"]
    ## 49                                   ["bollock"]
    ## 50                            ["bollock","fuck"]
    ## 51                                      ["piss"]
    ## 52                                      ["shit"]
    ## 53                                      ["fuck"]
    ## 54                                      ["tits"]
    ## 55                                      ["shit"]
    ## 56                                      ["shit"]
    ## 57                                      ["fuck"]
    ## 58                                      ["fuck"]
    ## 59                                      ["shit"]
    ## 60                                      ["damn"]
    ## 61                                      ["damn"]
    ## 62                                      ["hell"]
    ## 63                                      ["fuck"]
    ## 64                                      ["wank"]
    ## 65                                      ["wank"]
    ## 66                                      ["shit"]
    ## 67                                      ["fuck"]
    ## 68                                    ["Christ"]
    ## 69                                      ["shit"]
    ## 70                                      ["fuck"]
    ## 71                                      ["shit"]
    ## 72                                      ["fuck"]
    ## 73                                      ["fuck"]
    ## 74                                      ["shit"]
    ## 75                                      ["shit"]
    ## 76                                      ["wank"]
    ## 77                                      ["wank"]
    ## 78                                      ["hell"]
    ## 79                                      ["hell"]
    ## 80                                      ["fuck"]
    ## 81                                     ["bitch"]
    ## 82                                      ["shit"]
    ## 83                                     ["prick"]
    ## 84                                      ["piss"]
    ## 85                                      ["piss"]
    ## 86                                      ["shit"]
    ## 87                                      ["fuck"]
    ## 88                                      ["shit"]
    ## 89                                      ["shit"]
    ## 90                                     ["prick"]
    ## 91                                      ["shit"]
    ## 92                               ["shit","shit"]
    ## 93                                      ["shit"]
    ## 94                                      ["shit"]
    ## 95                                  ["ass/arse"]
    ## 96                                  ["ass/arse"]
    ## 97                                      ["shit"]
    ## 98                                      ["shit"]
    ## 99                                      ["shit"]
    ## 100                                     ["shit"]
    ## 101                                     ["fuck"]
    ## 102                                     ["fuck"]
    ## 103                                     ["fuck"]
    ## 104                                     ["fuck"]
    ## 105                                     ["fuck"]
    ## 106                                     ["shit"]
    ## 107                                     ["shit"]
    ## 108                                     ["shit"]
    ## 109                                    ["prick"]
    ## 110                                     ["fuck"]
    ## 111                                     ["fuck"]
    ## 112                              ["fuck","shit"]
    ## 113                                  ["bastard"]
    ## 114                                  ["bastard"]
    ## 115                                     ["shit"]
    ## 116                                     ["piss"]
    ## 117                                     ["fuck"]
    ## 118                                     ["shit"]
    ## 119                                 ["ass/arse"]
    ## 120                                 ["ass/arse"]
    ## 121                                 ["ass/arse"]
    ## 122                                     ["fuck"]
    ## 123                                     ["shit"]
    ## 124                                     ["fuck"]
    ## 125                                     ["fuck"]
    ## 126                                     ["shit"]
    ## 127                                     ["fuck"]
    ## 128                                    ["whore"]
    ## 129                                     ["fuck"]
    ## 130                                    ["prick"]
    ## 131                                     ["fuck"]
    ## 132                                     ["shit"]
    ## 133                                     ["shit"]
    ## 134                                     ["dick"]
    ## 135                                     ["fuck"]
    ## 136                                     ["fuck"]
    ## 137                                     ["fuck"]
    ## 138                                     ["shit"]
    ## 139                                     ["fuck"]
    ## 140                                     ["fuck"]
    ## 141                                     ["shit"]
    ## 142                                     ["fuck"]
    ## 143                                     ["shit"]
    ## 144                                     ["shit"]
    ## 145                                     ["shit"]
    ## 146                                     ["hell"]
    ## 147                              ["fuck","hell"]
    ## 148                                     ["shit"]
    ## 149                                     ["shit"]
    ## 150                                     ["shit"]
    ## 151                                     ["fuck"]
    ## 152                                     ["shit"]
    ## 153                                  ["bastard"]
    ## 154                                  ["bastard"]
    ## 155                              ["dick","dick"]
    ## 156                                     ["dick"]
    ## 157                                     ["shit"]
    ## 158                                     ["shit"]
    ## 159                                     ["fuck"]
    ## 160                                    ["bitch"]
    ## 161                                    ["bitch"]
    ## 162                                     ["dick"]
    ## 163                                     ["shit"]
    ## 164                                     ["fuck"]
    ## 165                              ["fuck","hell"]
    ## 166                                 ["ass/arse"]
    ## 167                                 ["ass/arse"]
    ## 168                                 ["ass/arse"]
    ## 169                                 ["ass/arse"]
    ## 170                                 ["ass/arse"]
    ## 171                                     ["shit"]
    ## 172                                     ["shit"]
    ## 173                                     ["fuck"]
    ## 174                                     ["fuck"]
    ## 175                                    ["bitch"]
    ## 176                                     ["shit"]
    ## 177                                     ["shit"]
    ## 178                                     ["piss"]
    ## 179                                     ["shit"]
    ## 180                                  ["bastard"]
    ## 181                                     ["shit"]
    ## 182                                     ["fuck"]
    ## 183                                     ["shit"]
    ## 184                                  ["bastard"]
    ## 185                                     ["shit"]
    ## 186                                     ["fuck"]
    ## 187                                     ["fuck"]
    ## 188                                  ["bastard"]
    ## 189                                    ["prick"]
    ## 190                                     ["fuck"]
    ## 191                                     ["shit"]
    ## 192                                     ["shit"]
    ## 193                                     ["fuck"]
    ## 194                                     ["piss"]
    ## 195                                     ["fuck"]
    ## 196                                     ["shit"]
    ## 197                                     ["fuck"]
    ## 198                                     ["shit"]
    ## 199                                     ["shit"]
    ## 200                                     ["fuck"]
    ## 201                                     ["fuck"]
    ## 202                                     ["shit"]
    ## 203                                     ["shit"]
    ## 204                                     ["shit"]
    ## 205                                     ["fuck"]
    ## 206                                     ["shit"]
    ## 207                                     ["shit"]
    ## 208                                     ["shit"]
    ## 209                                     ["fuck"]
    ## 210                                  ["bastard"]
    ## 211                                  ["bastard"]
    ## 212                                  ["bastard"]
    ## 213                                     ["shit"]
    ## 214                                     ["fuck"]
    ## 215                                  ["bastard"]
    ## 216                                  ["bastard"]
    ## 217                                    ["pussy"]
    ## 218                          ["fuck","ass/arse"]
    ## 219                                     ["dick"]
    ## 220                                     ["dick"]
    ## 221                                     ["shit"]
    ## 222                                     ["piss"]
    ## 223                        ["bastard","bastard"]
    ## 224                                  ["bastard"]
    ## 225                                  ["bastard"]
    ## 226                                  ["bastard"]
    ## 227                              ["damn","hell"]
    ## 228                                  ["bollock"]
    ## 229                                     ["fuck"]
    ## 230                                     ["shit"]
    ## 231                                     ["piss"]
    ## 232                                 ["ass/arse"]
    ## 233                                  ["bastard"]
    ## 234                                     ["damn"]
    ## 235                                     ["hell"]
    ## 236                                     ["piss"]
    ## 237                                     ["damn"]
    ## 238                                   ["Christ"]
    ## 239                                     ["shit"]
    ## 240                                     ["piss"]
    ## 241                              ["fuck","hell"]
    ## 242                                     ["fuck"]
    ## 243                                     ["fuck"]
    ## 244                    ["fuck","fuck","bastard"]
    ## 245                                     ["shit"]
    ## 246                                    ["prick"]
    ## 247                                     ["fuck"]
    ## 248                                     ["fuck"]
    ## 249                                     ["fuck"]
    ## 250                                     ["shit"]
    ## 251                                     ["fuck"]
    ## 252                                     ["hell"]
    ## 253                              ["fuck","fuck"]
    ## 254                                     ["fuck"]
    ## 255                                     ["fuck"]
    ## 256                                     ["fuck"]
    ## 257                                     ["shit"]
    ## 258                                     ["shit"]
    ## 259                                     ["damn"]
    ## 260                                     ["fuck"]
    ## 261                                     ["shit"]
    ## 262                                     ["fuck"]
    ## 263                                     ["shit"]
    ## 264                                     ["fuck"]
    ## 265                                     ["fuck"]
    ## 266                                   ["bugger"]
    ## 267                                     ["fuck"]
    ## 268                                     ["shit"]
    ## 269                                     ["fuck"]
    ## 270                                     ["fuck"]
    ## 271                                     ["fuck"]
    ## 272                                     ["hell"]
    ## 273                                     ["hell"]
    ## 274                                     ["fuck"]
    ## 275                                  ["bollock"]
    ## 276                                     ["fuck"]
    ## 277                                   ["Christ"]
    ## 278                                     ["fuck"]
    ## 279                                     ["shit"]
    ## 280                                     ["shit"]
    ## 281                                     ["fuck"]
    ## 282                                     ["shit"]
    ## 283                                    ["bitch"]
    ## 284                                    ["prick"]
    ## 285                                    ["prick"]
    ## 286                                    ["prick"]
    ## 287                                   ["Christ"]
    ## 288                            ["prick","prick"]
    ## 289                                     ["hell"]
    ## 290                                     ["fuck"]
    ## 291                                     ["shit"]
    ## 292                                     ["shit"]
    ## 293                                     ["shit"]
    ## 294                                     ["piss"]
    ## 295                                     ["shit"]
    ## 296                                     ["fuck"]
    ## 297                                     ["fuck"]
    ## 298                                     ["twat"]
    ## 299                                     ["shit"]
    ## 300                                     ["fuck"]
    ## 301                                     ["shit"]
    ## 302                                     ["dick"]
    ## 303                                     ["shit"]
    ## 304                              ["fuck","fuck"]
    ## 305                                     ["shit"]
    ## 306                                     ["shit"]
    ## 307                                     ["fuck"]
    ## 308                                     ["dick"]
    ## 309                                     ["fuck"]
    ## 310                                     ["piss"]
    ## 311                                     ["fuck"]
    ## 312                                     ["fuck"]
    ## 313                                     ["fuck"]
    ## 314                                     ["fuck"]
    ## 315                                     ["fuck"]
    ## 316                                     ["fuck"]
    ## 317                                     ["shit"]
    ## 318                                  ["bastard"]
    ## 319                                     ["fuck"]
    ## 320                                     ["cunt"]
    ## 321                                     ["cunt"]
    ## 322                                  ["bollock"]
    ## 323                                  ["bollock"]
    ## 324                                  ["bollock"]
    ## 325                                  ["bollock"]
    ## 326                                     ["fuck"]
    ## 327                                     ["fuck"]
    ## 328                                     ["fuck"]
    ## 329                                     ["fuck"]
    ## 330                                     ["fuck"]
    ## 331                                     ["shit"]
    ## 332                                     ["damn"]
    ## 333                                     ["fuck"]
    ## 334                                     ["piss"]
    ## 335                                     ["dick"]
    ## 336                                     ["fuck"]
    ## 337                                  ["bollock"]
    ## 338                                     ["fuck"]
    ## 339                             ["fuck","prick"]
    ## 340                                     ["fuck"]
    ## 341                                     ["fuck"]
    ## 342                                     ["shit"]
    ## 343                                     ["fuck"]
    ## 344                                     ["fuck"]
    ## 345                                     ["fuck"]
    ## 346                                     ["fuck"]
    ## 347                                     ["fuck"]
    ## 348                                     ["fuck"]
    ## 349                                     ["fuck"]
    ## 350                                     ["shit"]
    ## 351                                    ["prick"]
    ## 352                                     ["wank"]
    ## 353                                     ["hell"]
    ## 354                                 ["ass/arse"]
    ## 355                                   ["Christ"]
    ## 356                                     ["shit"]
    ## 357                                     ["shit"]
    ## 358                                     ["shit"]
    ## 359                              ["piss","shit"]
    ## 360                                    ["prick"]
    ## 361                                     ["fuck"]
    ## 362                                   ["Christ"]
    ## 363                              ["shit","piss"]
    ## 364                                     ["damn"]
    ## 365                                     ["fuck"]
    ## 366                                     ["shit"]
    ## 367                                     ["shit"]
    ## 368                                     ["shit"]
    ## 369                              ["shit","piss"]
    ## 370                                     ["shit"]
    ## 371                                   ["Christ"]
    ## 372                                     ["shit"]
    ## 373                                     ["damn"]
    ## 374                              ["shit","piss"]
    ## 375                                     ["fuck"]
    ## 376                                     ["piss"]
    ## 377                                     ["piss"]
    ## 378                                     ["piss"]
    ## 379                                     ["piss"]
    ## 380                                     ["piss"]
    ## 381                                     ["piss"]
    ## 382                              ["fuck","hell"]
    ## 383                                     ["piss"]
    ## 384                                     ["shit"]
    ## 385                                     ["shit"]
    ## 386                                     ["dick"]
    ## 387                                     ["dick"]
    ## 388                                     ["piss"]
    ## 389                                    ["prick"]
    ## 390                                   ["Christ"]
    ## 391                                     ["shit"]
    ## 392                                   ["Christ"]
    ## 393                                     ["fuck"]
    ## 394                                     ["shit"]
    ## 395                                     ["hell"]
    ## 396                                     ["hell"]
    ## 397                                     ["fuck"]
    ## 398                                     ["fuck"]
    ## 399                                     ["fuck"]
    ## 400                                     ["shit"]
    ## 401                                     ["fuck"]
    ## 402                                     ["shit"]
    ## 403                                     ["fuck"]
    ## 404                                     ["shit"]
    ## 405                                     ["piss"]
    ## 406                                     ["shit"]
    ## 407                                     ["shit"]
    ## 408                                     ["fuck"]
    ## 409                                     ["fuck"]
    ## 410                              ["fuck","shit"]
    ## 411                                     ["fuck"]
    ## 412                                     ["hell"]
    ## 413                                     ["fuck"]
    ## 414                                     ["fuck"]
    ## 415                                     ["shit"]
    ## 416                                   ["Christ"]
    ## 417                                     ["shit"]
    ## 418                                     ["fuck"]
    ## 419                                     ["shit"]
    ## 420                                     ["shit"]
    ## 421                                     ["shit"]
    ## 422                                     ["dick"]
    ## 423                                 ["ass/arse"]
    ## 424                                     ["fuck"]
    ## 425                              ["piss","shit"]
    ## 426                                     ["fuck"]
    ## 427                                   ["bugger"]
    ## 428                                     ["fuck"]
    ## 429                                     ["shit"]
    ## 430                                   ["Christ"]
    ## 431                                     ["fuck"]
    ## 432                                    ["prick"]
    ## 433                                     ["fuck"]
    ## 434                                     ["fuck"]
    ## 435                                     ["fuck"]
    ## 436                                     ["fuck"]
    ## 437                                     ["fuck"]
    ## 438                                     ["fuck"]
    ## 439                                     ["fuck"]
    ## 440                                     ["fuck"]
    ## 441                              ["shit","piss"]
    ## 442                                     ["shit"]
    ## 443                                     ["fuck"]
    ## 444                                     ["fuck"]
    ## 445                                     ["shit"]
    ## 446                                     ["shit"]
    ## 447                                     ["shit"]
    ## 448                                     ["shit"]
    ## 449                                     ["shit"]
    ## 450                                     ["shit"]
    ## 451                                     ["fuck"]
    ## 452                                     ["shit"]
    ## 453                                     ["shit"]
    ## 454                                    ["bitch"]
    ## 455                                     ["fuck"]
    ## 456                       ["damn","damn","hell"]
    ## 457                                    ["prick"]
    ## 458                                    ["prick"]
    ## 459                                    ["prick"]
    ## 460                                    ["prick"]
    ## 461                                     ["dick"]
    ## 462                                     ["hell"]
    ## 463                              ["piss","shit"]
    ## 464                              ["damn","fuck"]
    ## 465                                     ["fuck"]
    ## 466                                     ["fuck"]
    ## 467                                     ["fuck"]
    ## 468                                 ["ass/arse"]
    ## 469                                 ["ass/arse"]
    ## 470                                     ["piss"]
    ## 471                                     ["shit"]
    ## 472                                     ["piss"]
    ## 473                                     ["piss"]
    ## 474                              ["fuck","piss"]
    ## 475                                     ["piss"]
    ## 476                                     ["piss"]
    ## 477                                     ["piss"]
    ## 478                                     ["piss"]
    ## 479                                     ["fuck"]
    ## 480                                     ["fuck"]
    ## 481                                     ["fuck"]
    ## 482                                     ["shit"]
    ## 483                                     ["fuck"]
    ## 484                                     ["shit"]
    ## 485                              ["shit","shit"]
    ## 486                                     ["shit"]
    ## 487                                     ["shit"]
    ## 488                                     ["shit"]
    ## 489                                     ["shit"]
    ## 490                                     ["shit"]
    ## 491                                     ["fuck"]
    ## 492                                     ["fuck"]
    ## 493                                     ["piss"]
    ## 494                                     ["fuck"]
    ## 495                                     ["fuck"]
    ## 496                                     ["fuck"]
    ## 497                                     ["fuck"]
    ## 498                                     ["fuck"]
    ## 499                                   ["Christ"]
    ## 500                                     ["fuck"]
    ## 501                              ["fuck","hell"]
    ## 502                                     ["fuck"]
    ## 503                                     ["fuck"]
    ## 504                                     ["fuck"]
    ## 505                                  ["bastard"]
    ## 506                                     ["fuck"]
    ## 507                                     ["damn"]
    ## 508                                     ["shit"]
    ## 509                                   ["Christ"]
    ## 510                            ["Christ","fuck"]
    ## 511                                     ["fuck"]
    ## 512                                     ["fuck"]
    ## 513                                     ["shit"]
    ## 514                                     ["shit"]
    ## 515                                     ["shit"]
    ## 516                                     ["shit"]
    ## 517                                     ["dick"]
    ## 518                                     ["fuck"]
    ## 519                                     ["fuck"]
    ## 520                                     ["shit"]
    ## 521                                     ["shit"]
    ## 522                                     ["shit"]
    ## 523                                     ["shit"]
    ## 524                                 ["ass/arse"]
    ## 525                                 ["ass/arse"]
    ## 526                                 ["ass/arse"]
    ## 527                              ["piss","fuck"]
    ## 528                                     ["shit"]
    ## 529                                     ["fuck"]
    ## 530                                     ["shit"]
    ## 531                                     ["fuck"]
    ## 532                                     ["fuck"]
    ## 533                                   ["Christ"]
    ## 534                                 ["ass/arse"]
    ## 535                                     ["fuck"]
    ## 536                                     ["shit"]
    ## 537                                     ["shit"]
    ## 538                                     ["shit"]
    ## 539                                 ["ass/arse"]
    ## 540                                     ["fuck"]
    ## 541                                     ["shit"]
    ## 542                                     ["fuck"]
    ## 543                                     ["fuck"]
    ## 544                                     ["fuck"]
    ## 545                                     ["shit"]
    ## 546                                     ["fuck"]
    ## 547                                     ["fuck"]
    ## 548                                     ["shit"]
    ## 549                                     ["shit"]
    ## 550                                     ["shit"]
    ## 551                                     ["hell"]
    ## 552                              ["fuck","shit"]
    ## 553                                     ["shit"]
    ## 554                                     ["shit"]
    ## 555                                     ["shit"]
    ## 556                                     ["fuck"]
    ## 557                                     ["piss"]
    ## 558                                     ["shit"]
    ## 559                                     ["shit"]
    ## 560                                     ["fuck"]
    ## 561                                 ["ass/arse"]
    ## 562                                     ["cock"]
    ## 563                                     ["dick"]
    ## 564                                     ["shit"]
    ## 565                                 ["ass/arse"]
    ## 566                                     ["piss"]
    ## 567                              ["shit","twat"]
    ## 568                                     ["wank"]
    ## 569                                     ["shit"]
    ## 570                                     ["shit"]
    ## 571                                     ["shit"]
    ## 572                                     ["shit"]
    ## 573                                     ["shit"]
    ## 574                                     ["shit"]
    ## 575                              ["fuck","hell"]
    ## 576                                     ["fuck"]
    ## 577                                     ["hell"]
    ## 578                                     ["shit"]
    ## 579                                     ["fuck"]
    ## 580                                     ["fuck"]
    ## 581                                     ["fuck"]
    ## 582                                     ["fuck"]
    ## 583                                   ["bugger"]
    ## 584                                     ["fuck"]
    ## 585                                  ["bollock"]
    ## 586                                     ["shit"]
    ## 587                                     ["fuck"]
    ## 588                                     ["shit"]
    ## 589                                     ["fuck"]
    ## 590                                     ["fuck"]
    ## 591                                     ["shit"]
    ## 592                                    ["bitch"]
    ## 593                                     ["fuck"]
    ## 594                                   ["Christ"]
    ## 595                                     ["hell"]
    ## 596                                     ["fuck"]
    ## 597                                     ["shit"]
    ## 598                                     ["shit"]
    ## 599                                     ["shit"]
    ## 600                                     ["hell"]
    ## 601                                     ["piss"]
    ## 602                              ["fuck","fuck"]
    ## 603                                     ["fuck"]
    ## 604                                     ["fuck"]
    ## 605                                   ["Christ"]
    ## 606                                     ["hell"]
    ## 607                                     ["fuck"]
    ## 608                                     ["fuck"]
    ## 609                                     ["fuck"]
    ## 610                                   ["Christ"]
    ## 611                                     ["hell"]
    ## 612                                     ["dick"]
    ## 613                                     ["dick"]
    ## 614                                     ["dick"]
    ## 615                                     ["piss"]
    ## 616                                     ["shit"]
    ## 617                                     ["piss"]
    ## 618                                     ["fuck"]
    ## 619                                     ["fuck"]
    ## 620                                     ["fuck"]
    ## 621                              ["fuck","hell"]
    ## 622                                     ["shit"]
    ## 623                                     ["fuck"]
    ## 624                                     ["shit"]
    ## 625                                   ["Christ"]
    ## 626                                   ["Christ"]
    ## 627                                     ["hell"]
    ## 628                                     ["shit"]
    ## 629                                     ["fuck"]
    ## 630                                     ["damn"]
    ## 631                                     ["fuck"]
    ## 632                                     ["piss"]
    ## 633                                     ["fuck"]
    ## 634                                     ["piss"]
    ## 635                              ["fuck","shit"]
    ## 636                                     ["fuck"]
    ## 637                                     ["shit"]
    ## 638                                   ["Christ"]
    ## 639                                     ["hell"]
    ## 640                                     ["fuck"]
    ## 641                                     ["shit"]
    ## 642                                     ["shit"]
    ## 643                                  ["bastard"]
    ## 644                                    ["prick"]
    ## 645                                  ["bastard"]
    ## 646                                     ["fuck"]
    ## 647                                 ["ass/arse"]
    ## 648                                 ["ass/arse"]
    ## 649                                     ["fuck"]
    ## 650                                     ["shit"]
    ## 651                                     ["dick"]
    ## 652                                     ["dick"]
    ## 653                                     ["dick"]
    ## 654                                     ["dick"]
    ## 655                                     ["piss"]
    ## 656                                     ["piss"]
    ## 657                              ["fuck","hell"]
    ## 658                                     ["shit"]
    ## 659                                  ["bollock"]
    ## 660                                  ["bollock"]
    ## 661                                  ["bollock"]
    ## 662                                  ["bollock"]
    ## 663                                  ["bollock"]
    ## 664                                  ["bollock"]
    ## 665                                  ["bollock"]
    ## 666                                   ["bugger"]
    ## 667                                     ["damn"]
    ## 668                                     ["fuck"]
    ## 669                              ["fuck","hell"]
    ## 670                                     ["fuck"]
    ## 671                                     ["fuck"]
    ## 672                              ["fuck","hell"]
    ## 673                                   ["Christ"]
    ## 674                                     ["shit"]
    ## 675                                     ["shit"]
    ## 676                                     ["shit"]
    ## 677                                     ["shit"]
    ## 678                                     ["shit"]
    ## 679                                     ["shit"]
    ## 680                                     ["hell"]
    ## 681                                     ["shit"]
    ## 682                                     ["cock"]
    ## 683                                     ["cock"]
    ## 684                                     ["cock"]
    ## 685                                     ["fuck"]
    ## 686                                     ["fuck"]
    ## 687                                     ["fuck"]
    ## 688                                     ["shit"]
    ## 689                                     ["shit"]
    ## 690                                     ["fuck"]
    ## 691                                    ["bitch"]
    ## 692                                     ["shit"]
    ## 693                                    ["bitch"]
    ## 694                                    ["bitch"]
    ## 695                                     ["fuck"]
    ## 696                                     ["fuck"]
    ## 697                              ["fuck","fuck"]
    ## 698                                     ["dick"]
    ## 699                                     ["fuck"]
    ## 700                                     ["shit"]
    ## 701                                     ["piss"]
    ## 702                                   ["Christ"]
    ## 703                                 ["ass/arse"]
    ## 704                                 ["ass/arse"]
    ## 705                                     ["fuck"]
    ## 706                                     ["shit"]
    ## 707                                     ["shit"]
    ## 708                                 ["ass/arse"]
    ## 709                                   ["bugger"]
    ## 710                           ["shit","bollock"]
    ## 711                                   ["bugger"]
    ## 712                                     ["shit"]
    ## 713                                     ["fuck"]
    ## 714                                     ["fuck"]
    ## 715                                     ["fuck"]
    ## 716                                 ["ass/arse"]
    ## 717                                 ["ass/arse"]
    ## 718                                     ["fuck"]
    ## 719                                     ["damn"]
    ## 720                                     ["dick"]
    ## 721                                     ["shit"]
    ## 722                                     ["shit"]
    ## 723                                     ["cock"]
    ## 724                                  ["bollock"]
    ## 725                                     ["fuck"]
    ## 726                                   ["Christ"]
    ## 727                                     ["dick"]
    ## 728                                     ["shit"]
    ## 729                                     ["dick"]
    ## 730                                     ["dick"]
    ## 731                                     ["fuck"]
    ## 732                                   ["Christ"]
    ## 733                                 ["ass/arse"]
    ## 734                                     ["fuck"]
    ## 735                                     ["shit"]
    ## 736                                   ["Christ"]
    ## 737                                     ["fuck"]
    ## 738                                     ["shit"]
    ## 739                                    ["prick"]
    ## 740                                   ["Christ"]
    ## 741                                     ["shit"]
    ## 742                                     ["shit"]
    ## 743                                     ["fuck"]
    ## 744                              ["fuck","hell"]
    ## 745                                     ["shit"]
    ## 746                                     ["hell"]
    ## 747                                   ["Christ"]
    ## 748                                     ["fuck"]
    ## 749                                   ["Christ"]
    ## 750                                     ["fuck"]
    ## 751                                     ["fuck"]
    ## 752                                     ["fuck"]
    ## 753                                     ["fuck"]
    ## 754                                    ["prick"]
    ## 755                                    ["pussy"]
    ## 756                                     ["hell"]
    ## 757                                    ["pussy"]
    ## 758                                   ["Christ"]
    ## 759                                    ["prick"]
    ## 760                                     ["fuck"]
    ## 761                              ["fuck","hell"]
    ## 762                                     ["fuck"]
    ## 763                              ["fuck","hell"]
    ## 764                                     ["tits"]
    ## 765                                     ["tits"]
    ## 766                                     ["tits"]
    ## 767                                     ["shit"]
    ## 768                                     ["damn"]
    ## 769                                     ["shit"]
    ## 770                                     ["shit"]
    ## 771                                     ["shit"]
    ## 772                                     ["fuck"]
    ## 773                                     ["hell"]
    ## 774                                   ["Christ"]
    ## 775                                     ["shit"]
    ## 776                                     ["shit"]
    ## 777                                     ["fuck"]
    ## 778                                     ["shit"]
    ## 779                                   ["Christ"]
    ## 780                                     ["shit"]
    ## 781                                     ["fuck"]
    ## 782                                     ["shit"]
    ## 783                                     ["hell"]
    ## 784                                     ["hell"]
    ## 785                                     ["shit"]
    ## 786                                     ["fuck"]
    ## 787                                     ["hell"]
    ## 788                              ["fuck","hell"]
    ## 789                                     ["fuck"]
    ## 790                                    ["prick"]
    ## 791                                    ["prick"]
    ## 792                                     ["fuck"]
    ## 793                                     ["shit"]
    ## 794                                     ["shit"]
    ## 795                                     ["hell"]
    ## 796                                     ["shit"]
    ## 797                                   ["Christ"]
    ## 798                                     ["fuck"]
    ## 799                                     ["damn"]
    ## 800                                 ["ass/arse"]
    ## 801                                 ["ass/arse"]
    ## 802                                     ["dick"]
    ## 803                                     ["fuck"]
    ## 804                                     ["shit"]
    ## 805                                     ["fuck"]
    ## 806                                     ["fuck"]
    ## 807                                     ["shit"]
    ## 808                                     ["shit"]
    ## 809                                     ["damn"]
    ## 810                                     ["hell"]
    ## 811                                     ["fuck"]
    ## 812                                     ["fuck"]
    ## 813                                     ["fuck"]
    ## 814                                     ["shit"]
    ## 815                                     ["shit"]
    ## 816                                     ["shit"]
    ## 817                                   ["Christ"]
    ## 818                              ["fuck","hell"]
    ## 819                                   ["Christ"]
    ## 820                                 ["ass/arse"]
    ## 821                                 ["ass/arse"]
    ## 822                                     ["shit"]
    ## 823                                  ["bollock"]
    ## 824                                     ["fuck"]
    ## 825                                     ["fuck"]
    ## 826                                     ["fuck"]
    ## 827                                     ["fuck"]
    ## 828                                     ["fuck"]
    ## 829                                     ["shit"]
    ## 830                                     ["shit"]
    ## 831                                     ["hell"]
    ## 832                              ["tits","dick"]
    ## 833                                    ["prick"]
    ## 834                                     ["dick"]
    ## 835                                     ["shit"]
    ## 836                                     ["fuck"]
    ## 837                              ["piss","shit"]
    ## 838                                     ["fuck"]
    ## 839                              ["fuck","hell"]
    ## 840                                     ["shit"]
    ## 841                                     ["fuck"]
    ## 842                                   ["Christ"]
    ## 843                                   ["Christ"]
    ## 844                                     ["damn"]
    ## 845                                     ["shit"]
    ## 846                                     ["fuck"]
    ## 847                                     ["shit"]
    ## 848                                     ["shit"]
    ## 849                                 ["ass/arse"]
    ## 850                                     ["shit"]
    ## 851                                     ["fuck"]
    ## 852                                     ["fuck"]
    ## 853                                     ["fuck"]
    ## 854                                    ["prick"]
    ## 855                                     ["fuck"]
    ## 856                                     ["fuck"]
    ## 857                                     ["shit"]
    ## 858                                     ["shit"]
    ## 859                                   ["Christ"]
    ## 860                                     ["shit"]
    ## 861                                     ["fuck"]
    ## 862                                     ["fuck"]
    ## 863                                     ["damn"]
    ## 864                                     ["shit"]
    ## 865                                     ["shit"]
    ## 866                                     ["fuck"]
    ## 867                          ["fuck","ass/arse"]
    ## 868                                     ["damn"]
    ## 869                                     ["piss"]
    ## 870                                     ["shit"]
    ## 871                                     ["fuck"]
    ## 872                                     ["fuck"]
    ## 873                                     ["fuck"]
    ## 874                                     ["fuck"]
    ## 875                                     ["slut"]
    ## 876                                     ["twat"]
    ## 877                                     ["twat"]
    ## 878                                     ["shit"]
    ## 879                                     ["fuck"]
    ## 880                                     ["shit"]
    ## 881                                     ["shit"]
    ## 882                                     ["hell"]
    ## 883                                     ["tits"]
    ## 884                                     ["shit"]
    ## 885                                     ["shit"]
    ## 886                                     ["hell"]
    ## 887                                     ["fuck"]
    ## 888                                     ["hell"]
    ## 889                                     ["shit"]
    ## 890                                     ["piss"]
    ## 891                                     ["fuck"]
    ## 892                                     ["damn"]
    ## 893                                     ["fuck"]
    ## 894                                     ["fuck"]
    ## 895                                     ["shit"]
    ## 896                       ["shit","shit","shit"]
    ## 897                                     ["fuck"]
    ## 898                                     ["fuck"]
    ## 899                                     ["shit"]
    ## 900                                     ["piss"]
    ## 901                                     ["shit"]
    ## 902                                     ["fuck"]
    ## 903                                     ["fuck"]
    ## 904                                     ["shit"]
    ## 905                                     ["fuck"]
    ## 906                                     ["fuck"]
    ## 907                                     ["shit"]
    ## 908                                   ["Christ"]
    ## 909                                   ["Christ"]
    ## 910                                   ["Christ"]
    ## 911                                     ["fuck"]
    ## 912                                     ["fuck"]
    ## 913                                     ["damn"]
    ## 914                                     ["fuck"]
    ## 915                                     ["piss"]
    ## 916                                     ["dick"]
    ## 917                                     ["hell"]
    ## 918                              ["fuck","hell"]
    ## 919                                     ["fuck"]
    ## 920                                     ["fuck"]
    ## 921                                     ["fuck"]
    ## 922                                     ["damn"]
    ## 923                                     ["hell"]
    ## 924                              ["fuck","hell"]
    ## 925                                     ["dick"]
    ## 926                                     ["shit"]
    ## 927                                     ["shit"]
    ## 928                              ["shit","shit"]
    ## 929                                     ["shit"]
    ## 930                                     ["shit"]
    ## 931                                     ["shit"]
    ## 932                                   ["bugger"]
    ## 933                                   ["Christ"]
    ## 934                                     ["shit"]
    ## 935                                     ["fuck"]
    ## 936                                     ["shit"]
    ## 937                                     ["shit"]
    ## 938                                     ["shit"]
    ## 939                                   ["Christ"]
    ## 940                                     ["fuck"]
    ## 941                                     ["dick"]
    ## 942                                     ["fuck"]
    ## 943                                   ["Christ"]
    ## 944                                     ["fuck"]
    ## 945                                   ["Christ"]
    ## 946                                     ["dick"]
    ## 947                                     ["fuck"]
    ## 948                                     ["shit"]
    ## 949                                     ["shit"]
    ## 950                                     ["damn"]
    ## 951                                     ["fuck"]
    ## 952                                 ["ass/arse"]
    ## 953                                     ["hell"]
    ## 954                                     ["damn"]
    ## 955                                     ["shit"]
    ## 956                                     ["fuck"]
    ## 957                                     ["wank"]
    ## 958                                     ["fuck"]
    ## 959                                   ["Christ"]
    ## 960                                     ["shit"]
    ## 961                              ["fuck","fuck"]
    ## 962                                     ["fuck"]
    ## 963                                     ["dick"]
    ## 964                                     ["dick"]
    ## 965                              ["fuck","hell"]
    ## 966                                     ["fuck"]
    ## 967                                   ["Christ"]
    ## 968                       ["fuck","fuck","fuck"]
    ## 969                                     ["shit"]
    ## 970                                     ["fuck"]
    ## 971                                     ["fuck"]
    ## 972                                   ["Christ"]
    ## 973                          ["fuck","ass/arse"]
    ## 974                                  ["bollock"]
    ## 975                                     ["fuck"]
    ## 976                                     ["fuck"]
    ## 977                                     ["fuck"]
    ## 978                                     ["shit"]
    ## 979                                     ["fuck"]
    ## 980                                     ["shit"]
    ## 981                                     ["shit"]
    ## 982                                     ["fuck"]
    ## 983                                     ["fuck"]
    ## 984                                 ["ass/arse"]
    ## 985                                     ["shit"]
    ## 986                                     ["damn"]
    ## 987                                     ["fuck"]
    ## 988                                  ["bollock"]
    ## 989                                     ["fuck"]
    ## 990                                     ["shit"]
    ## 991                                  ["bollock"]
    ## 992                                     ["shit"]
    ## 993                                  ["bollock"]
    ## 994                                     ["fuck"]
    ## 995                                     ["shit"]
    ## 996                                     ["fuck"]
    ## 997                                     ["fuck"]
    ## 998                                     ["fuck"]
    ## 999                                     ["fuck"]
    ## 1000                                    ["shit"]
    ## 1001                                    ["shit"]
    ## 1002                                    ["shit"]
    ## 1003                                    ["dick"]
    ## 1004                                    ["dick"]
    ## 1005                                    ["dick"]
    ## 1006                             ["fuck","hell"]
    ## 1007                                    ["fuck"]
    ## 1008                                ["ass/arse"]
    ## 1009                                    ["fuck"]
    ## 1010                                    ["damn"]
    ## 1011                                    ["fuck"]
    ## 1012                                    ["fuck"]
    ## 1013                                    ["fuck"]
    ## 1014                                ["ass/arse"]
    ## 1015                                    ["fuck"]
    ## 1016                             ["fuck","fuck"]
    ## 1017                                  ["Christ"]
    ## 1018                     ["ass/arse","ass/arse"]
    ## 1019                                    ["shit"]
    ## 1020                                    ["piss"]
    ## 1021                                    ["piss"]
    ## 1022                                    ["shit"]
    ## 1023                                    ["fuck"]
    ## 1024                                    ["fuck"]
    ## 1025                                    ["shit"]
    ## 1026                                    ["fuck"]
    ## 1027                                 ["bollock"]
    ## 1028                                    ["fuck"]
    ## 1029                                ["ass/arse"]
    ## 1030                                    ["fuck"]
    ## 1031                                    ["shit"]
    ## 1032                                    ["damn"]
    ## 1033                                    ["shit"]
    ## 1034                                    ["piss"]
    ## 1035                                    ["piss"]
    ## 1036                                    ["piss"]
    ## 1037                                    ["piss"]
    ## 1038                                    ["shit"]
    ## 1039                                    ["damn"]
    ## 1040                                    ["shit"]
    ## 1041                                 ["bollock"]
    ## 1042                                    ["fuck"]
    ## 1043                                 ["bollock"]
    ## 1044                                    ["fuck"]
    ## 1045                                    ["shit"]
    ## 1046                                    ["hell"]
    ## 1047                                    ["fuck"]
    ## 1048                                    ["fuck"]
    ## 1049                                    ["fuck"]
    ## 1050                                    ["fuck"]
    ## 1051                                    ["cock"]
    ## 1052                                    ["cock"]
    ## 1053                             ["cock","cock"]
    ## 1054                       ["bollock","bollock"]
    ## 1055                                 ["bollock"]
    ## 1056                                    ["fuck"]
    ## 1057                                  ["Christ"]
    ## 1058                                    ["piss"]
    ## 1059                             ["fuck","shit"]
    ## 1060                                    ["shit"]
    ## 1061                                ["ass/arse"]
    ## 1062                                ["ass/arse"]
    ## 1063                                    ["shit"]
    ## 1064                                    ["shit"]
    ## 1065                                  ["Christ"]
    ## 1066                                    ["fuck"]
    ## 1067                                    ["shit"]
    ## 1068                             ["fuck","shit"]
    ## 1069                                    ["twat"]
    ## 1070                             ["fuck","hell"]
    ## 1071                                 ["bollock"]
    ## 1072                                    ["fuck"]
    ## 1073                                    ["fuck"]
    ## 1074                                    ["fuck"]
    ## 1075                                    ["shit"]
    ## 1076                                    ["fuck"]
    ## 1077                                    ["shit"]
    ## 1078                                    ["dick"]
    ## 1079                                    ["shit"]
    ## 1080                             ["fuck","piss"]
    ## 1081                             ["fuck","fuck"]
    ## 1082                                    ["piss"]
    ## 1083                                    ["fuck"]
    ## 1084                                    ["fuck"]
    ## 1085                                    ["fuck"]
    ## 1086                                    ["damn"]
    ## 1087                                    ["shit"]
    ## 1088                                    ["piss"]
    ## 1089                                    ["shit"]
    ## 1090                                  ["Christ"]
    ## 1091                                    ["cock"]
    ## 1092                                    ["dick"]
    ## 1093                                ["ass/arse"]
    ## 1094                                 ["bollock"]
    ## 1095                                 ["bollock"]
    ## 1096                                    ["twat"]
    ## 1097                                    ["twat"]
    ## 1098                                    ["twat"]
    ## 1099                                    ["twat"]
    ## 1100                                  ["Christ"]
    ## 1101                                 ["bollock"]
    ## 1102                                    ["shit"]
    ## 1103                                    ["fuck"]
    ## 1104                                    ["fuck"]
    ## 1105                                    ["fuck"]
    ## 1106                                    ["fuck"]
    ## 1107                                    ["fuck"]
    ## 1108                                  ["Christ"]
    ## 1109                                    ["fuck"]
    ## 1110                                   ["prick"]
    ## 1111                                    ["fuck"]
    ## 1112                                  ["Christ"]
    ## 1113                                ["ass/arse"]
    ## 1114                                    ["cock"]
    ## 1115                                  ["Christ"]
    ## 1116                                ["ass/arse"]
    ## 1117                                 ["bollock"]
    ## 1118                         ["dick","ass/arse"]
    ## 1119                                    ["dick"]
    ## 1120                                    ["fuck"]
    ## 1121                                    ["fuck"]
    ## 1122                                    ["fuck"]
    ## 1123                                 ["bollock"]
    ## 1124                                    ["shit"]
    ## 1125                                    ["fuck"]
    ## 1126                                    ["fuck"]
    ## 1127                                    ["fuck"]
    ## 1128                                 ["bastard"]
    ## 1129                                   ["prick"]
    ## 1130                                    ["fuck"]
    ## 1131                                    ["dick"]
    ## 1132                                    ["fuck"]
    ## 1133                                    ["fuck"]
    ## 1134                                    ["fuck"]
    ## 1135                                    ["fuck"]
    ## 1136                                 ["bollock"]
    ## 1137                                    ["shit"]
    ## 1138                                    ["shit"]
    ## 1139                                    ["fuck"]
    ## 1140                                    ["shit"]
    ## 1141                                    ["piss"]
    ## 1142                                    ["fuck"]
    ## 1143                                    ["shit"]
    ## 1144                                    ["shit"]
    ## 1145                                    ["damn"]
    ## 1146                                    ["fuck"]
    ## 1147                                    ["damn"]
    ## 1148                                    ["fuck"]
    ## 1149                                  ["bugger"]
    ## 1150                                  ["Christ"]
    ## 1151                                    ["fuck"]
    ## 1152                                    ["shit"]
    ## 1153                                    ["shit"]
    ## 1154                                    ["shit"]
    ## 1155                                    ["shit"]
    ## 1156                                    ["hell"]
    ## 1157                                    ["shit"]
    ## 1158                                    ["fuck"]
    ## 1159                             ["fuck","hell"]
    ## 1160                                ["ass/arse"]
    ## 1161                                ["ass/arse"]
    ## 1162                                    ["shit"]
    ## 1163                                    ["shit"]
    ## 1164                                    ["fuck"]
    ## 1165                                 ["bastard"]
    ## 1166                                    ["fuck"]
    ## 1167                                    ["shit"]
    ## 1168                                    ["piss"]
    ## 1169                                 ["bollock"]
    ## 1170                                    ["piss"]
    ## 1171                                    ["fuck"]
    ## 1172                                    ["fuck"]
    ## 1173                                    ["damn"]
    ## 1174                                ["ass/arse"]
    ## 1175                                    ["shit"]
    ## 1176                                    ["hell"]
    ## 1177                                    ["cock"]
    ## 1178                                ["ass/arse"]
    ## 1179                                ["ass/arse"]
    ## 1180                                    ["fuck"]
    ## 1181                                    ["hell"]
    ## 1182                                    ["fuck"]
    ## 1183                                    ["fuck"]
    ## 1184                                    ["fuck"]
    ## 1185                                    ["fuck"]
    ## 1186                                    ["fuck"]
    ## 1187                                    ["fuck"]
    ## 1188                                    ["shit"]
    ## 1189                                    ["shit"]
    ## 1190                                    ["shit"]
    ## 1191                                  ["Christ"]
    ## 1192                             ["fuck","piss"]
    ## 1193                                    ["shit"]
    ## 1194                                    ["shit"]
    ## 1195                                    ["shit"]
    ## 1196                                   ["bitch"]
    ## 1197                                    ["shit"]
    ## 1198                                    ["shit"]
    ## 1199 ["wank","fuck","shit","cunt","tits","cock"]
    ## 1200                                    ["cock"]
    ## 1201                                    ["wank"]
    ## 1202                                    ["shit"]
    ## 1203                                    ["fuck"]
    ## 1204                                    ["fuck"]
    ## 1205                                    ["fuck"]
    ## 1206                             ["fuck","fuck"]
    ## 1207                                    ["fuck"]
    ## 1208                                    ["shit"]
    ## 1209                                    ["fuck"]
    ## 1210                                    ["wank"]
    ## 1211                                    ["hell"]
    ## 1212                                    ["fuck"]
    ## 1213                             ["fuck","hell"]
    ## 1214                                 ["bastard"]
    ## 1215                                    ["hell"]
    ## 1216                                  ["Christ"]
    ## 1217                                    ["fuck"]
    ## 1218                                  ["bugger"]
    ## 1219                                    ["fuck"]
    ## 1220                                 ["bollock"]
    ## 1221                                    ["fuck"]
    ## 1222                                    ["fuck"]
    ## 1223                                    ["shit"]
    ## 1224                     ["ass/arse","ass/arse"]
    ## 1225                                    ["shit"]
    ## 1226                                    ["fuck"]
    ## 1227                             ["fuck","hell"]
    ## 1228                                    ["shit"]
    ## 1229                                    ["fuck"]
    ## 1230                                    ["fuck"]
    ## 1231                                    ["fuck"]
    ## 1232                                    ["fuck"]
    ## 1233                                    ["fuck"]
    ## 1234                                    ["fuck"]
    ## 1235                                    ["damn"]
    ## 1236                                    ["damn"]
    ## 1237                                    ["wank"]
    ## 1238                                ["ass/arse"]
    ## 1239                                    ["fuck"]
    ## 1240                                    ["fuck"]
    ## 1241                                    ["fuck"]
    ## 1242                      ["fuck","fuck","fuck"]
    ## 1243                                    ["shit"]
    ## 1244                                    ["fuck"]
    ## 1245                                    ["shit"]
    ## 1246                                    ["fuck"]
    ## 1247                             ["fuck","hell"]
    ## 1248                             ["fuck","hell"]
    ## 1249                                    ["shit"]
    ## 1250                                    ["fuck"]
    ## 1251                                    ["fuck"]
    ## 1252                                    ["fuck"]
    ## 1253                                 ["bastard"]
    ## 1254                                    ["shit"]
    ## 1255                                    ["hell"]
    ## 1256                                    ["shit"]
    ## 1257                                    ["shit"]
    ## 1258                                    ["shit"]
    ## 1259                                    ["shit"]
    ## 1260                                    ["damn"]
    ## 1261                                    ["fuck"]
    ## 1262                                    ["hell"]
    ## 1263                                    ["fuck"]
    ## 1264                                    ["fuck"]
    ## 1265                                    ["shit"]
    ## 1266                                    ["shit"]
    ## 1267                                    ["shit"]
    ## 1268                                    ["fuck"]
    ## 1269                                    ["fuck"]
    ## 1270                                    ["fuck"]
    ## 1271                                    ["piss"]
    ## 1272                                    ["piss"]
    ## 1273                                 ["bastard"]
    ## 1274                                 ["bastard"]
    ## 1275                                 ["bastard"]
    ## 1276                                    ["fuck"]
    ## 1277                                  ["Christ"]
    ## 1278                                    ["fuck"]
    ## 1279                                    ["fuck"]
    ## 1280                                    ["fuck"]
    ## 1281                                    ["shit"]
    ## 1282                                    ["shit"]
    ## 1283                                  ["Christ"]
    ## 1284                                    ["fuck"]
    ## 1285                                    ["shit"]
    ## 1286                                    ["fuck"]
    ## 1287                                    ["shit"]
    ## 1288                                  ["Christ"]
    ## 1289                                    ["fuck"]
    ## 1290                                    ["fuck"]
    ## 1291                                    ["shit"]
    ## 1292                                    ["shit"]
    ## 1293                                 ["bollock"]
    ## 1294                                    ["fuck"]
    ## 1295                                    ["shit"]
    ## 1296                                    ["shit"]
    ## 1297                        ["bugger","bastard"]
    ## 1298                                    ["hell"]
    ## 1299                                    ["damn"]
    ## 1300                                    ["twat"]
    ## 1301                                    ["cock"]
    ## 1302                                    ["fuck"]
    ## 1303                                    ["shit"]
    ## 1304                                  ["Christ"]
    ## 1305                                    ["shit"]
    ## 1306                                    ["hell"]
    ## 1307                                    ["fuck"]
    ## 1308                                    ["fuck"]
    ## 1309                                    ["shit"]
    ## 1310                                   ["prick"]
    ## 1311                                  ["Christ"]
    ## 1312                                 ["bastard"]
    ## 1313                                    ["shit"]
    ## 1314                                    ["fuck"]
    ## 1315                                    ["shit"]
    ## 1316                                    ["fuck"]
    ## 1317                                ["ass/arse"]
    ## 1318                                 ["bastard"]
    ## 1319                                   ["prick"]
    ## 1320                                    ["fuck"]
    ## 1321                                    ["hell"]
    ## 1322                                    ["fuck"]
    ## 1323                                    ["fuck"]
    ## 1324                             ["shit","shit"]
    ## 1325                                    ["shit"]
    ## 1326                                    ["fuck"]
    ## 1327                                    ["damn"]
    ## 1328                                    ["fuck"]
    ## 1329                                    ["shit"]
    ## 1330                             ["shit","shit"]
    ## 1331                                    ["piss"]
    ## 1332                                    ["shit"]
    ## 1333                                    ["shit"]
    ## 1334                                    ["piss"]
    ## 1335                                    ["shit"]
    ## 1336                                    ["fuck"]
    ## 1337                                    ["dick"]
    ## 1338                                    ["fuck"]
    ## 1339                             ["dick","dick"]
    ## 1340                                   ["prick"]
    ## 1341                                    ["hell"]
    ## 1342                                    ["shit"]
    ## 1343                                    ["fuck"]
    ## 1344                                    ["fuck"]
    ## 1345                                    ["fuck"]
    ## 1346                                    ["fuck"]
    ## 1347                                    ["fuck"]
    ## 1348                                    ["shit"]
    ## 1349                                    ["hell"]
    ## 1350                                    ["shit"]
    ## 1351                                    ["fuck"]
    ## 1352                                    ["fuck"]
    ## 1353                                    ["fuck"]
    ## 1354                                    ["piss"]
    ## 1355                                    ["piss"]
    ## 1356                                    ["fuck"]
    ## 1357                                    ["twat"]
    ## 1358                                    ["shit"]
    ## 1359                                    ["fuck"]
    ## 1360                                    ["fuck"]
    ## 1361                                    ["fuck"]
    ## 1362                                    ["shit"]
    ## 1363                                   ["bitch"]
    ## 1364                                   ["bitch"]
    ## 1365                        ["ass/arse","bitch"]
    ## 1366                        ["ass/arse","bitch"]
    ## 1367                                    ["piss"]
    ## 1368                                    ["shit"]
    ## 1369                                   ["prick"]
    ## 1370                                    ["shit"]
    ## 1371                                    ["shit"]
    ## 1372                                    ["shit"]
    ## 1373                                    ["shit"]
    ## 1374                                    ["shit"]
    ## 1375                                    ["shit"]
    ## 1376                                    ["fuck"]
    ## 1377                             ["fuck","shit"]
    ## 1378                                    ["shit"]
    ## 1379                                    ["dick"]
    ## 1380                                    ["dick"]
    ## 1381                                  ["bugger"]
    ## 1382                                ["ass/arse"]
    ## 1383                                ["ass/arse"]
    ## 1384                                    ["shit"]
    ## 1385                                    ["shit"]
    ## 1386                                 ["bollock"]
    ## 1387                                    ["fuck"]
    ## 1388                                    ["hell"]
    ## 1389                                    ["shit"]
    ## 1390                                    ["fuck"]
    ## 1391                                 ["bastard"]
    ## 1392                                    ["hell"]
    ## 1393                                    ["hell"]
    ## 1394                                    ["fuck"]
    ## 1395                                    ["fuck"]
    ## 1396                                    ["damn"]
    ## 1397                                    ["fuck"]
    ## 1398                                    ["shit"]
    ## 1399                                    ["shit"]
    ## 1400                                 ["bastard"]
    ## 1401                                    ["fuck"]
    ## 1402                                    ["dick"]
    ## 1403                                    ["fuck"]
    ## 1404                                    ["shit"]
    ## 1405                                    ["piss"]
    ## 1406                                    ["shit"]
    ## 1407                                    ["dick"]
    ## 1408                                    ["fuck"]
    ## 1409                                    ["fuck"]
    ## 1410                                    ["fuck"]
    ## 1411                                    ["shit"]
    ## 1412                                    ["piss"]
    ## 1413                                    ["shit"]
    ## 1414                                    ["shit"]
    ## 1415                                ["ass/arse"]
    ## 1416                                ["ass/arse"]
    ## 1417                                ["ass/arse"]
    ## 1418                     ["ass/arse","ass/arse"]
    ## 1419                                ["ass/arse"]
    ## 1420                             ["shit","shit"]
    ## 1421                             ["shit","shit"]
    ## 1422                                    ["shit"]
    ## 1423                                    ["fuck"]
    ## 1424                                    ["shit"]
    ## 1425                                    ["shit"]
    ## 1426                             ["fuck","hell"]
    ## 1427                                    ["shit"]
    ## 1428                                    ["shit"]
    ## 1429                                    ["shit"]
    ## 1430                                    ["shit"]
    ## 1431                                    ["hell"]
    ## 1432                                    ["damn"]
    ## 1433                                    ["fuck"]
    ## 1434                                    ["shit"]
    ## 1435                                    ["fuck"]
    ## 1436                                   ["pussy"]
    ## 1437                                   ["bitch"]
    ## 1438                                    ["hell"]
    ## 1439                                    ["shit"]
    ## 1440                                    ["shit"]
    ## 1441                                 ["bastard"]
    ## 1442                                    ["dick"]
    ## 1443                                    ["dick"]
    ## 1444                                    ["shit"]
    ## 1445                                ["ass/arse"]
    ## 1446                                    ["shit"]
    ## 1447                                    ["fuck"]
    ## 1448                                    ["fuck"]
    ## 1449                             ["shit","shit"]
    ## 1450                                    ["fuck"]
    ## 1451                                    ["shit"]
    ## 1452                                    ["shit"]
    ## 1453                                  ["Christ"]
    ## 1454                                    ["shit"]
    ## 1455                                ["ass/arse"]
    ## 1456                                    ["shit"]
    ## 1457                                    ["damn"]
    ## 1458                                    ["fuck"]
    ## 1459                                ["ass/arse"]
    ## 1460                                    ["shit"]
    ## 1461                                    ["shit"]
    ## 1462                                    ["fuck"]
    ## 1463                                    ["fuck"]
    ## 1464                                    ["fuck"]
    ## 1465                                    ["fuck"]
    ## 1466                                    ["shit"]
    ## 1467   ["bollock","bollock","bollock","bollock"]
    ## 1468                                 ["bollock"]
    ## 1469                                    ["shit"]
    ## 1470                                    ["shit"]
    ## 1471                                    ["shit"]
    ## 1472                                    ["shit"]
    ## 1473                                  ["Christ"]
    ## 1474                                ["ass/arse"]
    ## 1475                                ["ass/arse"]
    ## 1476                                ["ass/arse"]
    ## 1477                                    ["cock"]
    ## 1478                                    ["shit"]
    ## 1479                                    ["fuck"]
    ## 1480                                    ["shit"]
    ## 1481                                 ["bastard"]
    ## 1482                                    ["shit"]
    ## 1483                                    ["shit"]
    ## 1484                                ["ass/arse"]
    ## 1485                                ["ass/arse"]
    ## 1486                                  ["Christ"]
    ## 1487                                    ["shit"]
    ## 1488                                    ["shit"]
    ## 1489                                 ["bollock"]
    ## 1490                                 ["bastard"]
    ## 1491                                    ["shit"]
    ## 1492                                    ["shit"]
    ## 1493                                    ["shit"]
    ## 1494                                    ["shit"]
    ## 1495                                    ["shit"]
    ## 1496                                    ["shit"]
    ## 1497                                    ["damn"]
    ## 1498                             ["shit","shit"]
    ## 1499                                    ["damn"]
    ## 1500                                    ["hell"]
    ## 1501                                ["ass/arse"]
    ## 1502                                    ["cock"]
    ## 1503                                    ["fuck"]
    ## 1504                                    ["hell"]
    ## 1505                                    ["fuck"]
    ## 1506                                    ["shit"]
    ## 1507                                ["ass/arse"]
    ## 1508                                ["ass/arse"]
    ## 1509                                  ["Christ"]
    ## 1510                                    ["damn"]
    ## 1511                                    ["damn"]
    ## 1512                                    ["shit"]
    ## 1513                                    ["dick"]
    ## 1514                                  ["Christ"]
    ## 1515                                 ["bastard"]
    ## 1516                                 ["bastard"]
    ## 1517                                    ["hell"]
    ## 1518                                  ["Christ"]
    ## 1519                                    ["piss"]
    ## 1520                                    ["shit"]
    ## 1521                                    ["shit"]
    ## 1522                                    ["shit"]
    ## 1523                                    ["fuck"]
    ## 1524                                    ["damn"]
    ## 1525                                    ["piss"]
    ## 1526                                  ["Christ"]
    ## 1527                                    ["fuck"]
    ## 1528                                    ["tits"]
    ## 1529                                    ["shit"]
    ## 1530                                    ["hell"]
    ## 1531                                    ["shit"]
    ## 1532                                    ["twat"]
    ## 1533                                    ["shit"]
    ## 1534                                    ["shit"]
    ## 1535                                    ["shit"]
    ## 1536                                    ["piss"]
    ## 1537                                    ["piss"]
    ## 1538                                    ["piss"]
    ## 1539                                    ["hell"]
    ## 1540                                    ["shit"]
    ## 1541                                   ["prick"]
    ## 1542                                    ["damn"]
    ## 1543                                    ["cock"]
    ## 1544                             ["fuck","fuck"]
    ## 1545                                    ["shit"]
    ## 1546                                    ["fuck"]
    ## 1547                                    ["fuck"]
    ## 1548                                 ["bastard"]
    ## 1549                                    ["dick"]
    ## 1550                                    ["fuck"]
    ## 1551                                    ["shit"]
    ## 1552                                    ["fuck"]
    ## 1553                                ["ass/arse"]
    ## 1554                                    ["shit"]
    ## 1555                                    ["fuck"]
    ## 1556                                  ["bugger"]
    ## 1557                                    ["fuck"]
    ## 1558                                    ["piss"]
    ## 1559                                    ["fuck"]
    ## 1560                                    ["fuck"]
    ## 1561                                    ["fuck"]
    ## 1562                                    ["damn"]
    ## 1563                                    ["damn"]
    ## 1564                                ["ass/arse"]
    ## 1565                             ["shit","fuck"]
    ## 1566                                    ["hell"]
    ## 1567                                    ["hell"]
    ## 1568                                    ["shit"]
    ## 1569                                    ["dick"]
    ## 1570                                    ["dick"]
    ## 1571                                    ["damn"]
    ## 1572                   ["prick","prick","prick"]
    ## 1573                                   ["prick"]
    ## 1574                                   ["prick"]
    ## 1575                     ["fuck","fuck","prick"]
    ## 1576                                    ["shit"]
    ## 1577                                    ["fuck"]
    ## 1578                                    ["piss"]
    ## 1579                                   ["prick"]
    ## 1580                                    ["shit"]
    ## 1581                                    ["fuck"]
    ## 1582                                    ["damn"]
    ## 1583                                    ["shit"]
    ## 1584                                   ["bitch"]
    ## 1585                                    ["shit"]
    ## 1586                                ["ass/arse"]
    ## 1587                                    ["fuck"]
    ## 1588                                    ["shit"]
    ## 1589                                    ["shit"]
    ## 1590                                    ["cock"]
    ## 1591                                    ["shit"]
    ## 1592                                    ["fuck"]
    ## 1593                             ["shit","hell"]
    ## 1594                                    ["hell"]
    ## 1595                                    ["fuck"]
    ## 1596                                    ["fuck"]
    ## 1597                                    ["fuck"]
    ## 1598                                    ["fuck"]
    ## 1599                                ["ass/arse"]
    ## 1600                                    ["hell"]
    ## 1601                                    ["damn"]
    ## 1602                                    ["fuck"]
    ## 1603                                ["ass/arse"]
    ## 1604                                    ["fuck"]
    ## 1605                                    ["piss"]
    ## 1606                                    ["shit"]
    ## 1607                                    ["shit"]
    ## 1608                                    ["damn"]
    ## 1609                                    ["hell"]
    ## 1610                                  ["bugger"]
    ## 1611                                ["ass/arse"]
    ## 1612                                    ["damn"]
    ## 1613                                    ["shit"]
    ## 1614                                    ["fuck"]
    ## 1615                                    ["fuck"]
    ## 1616                                    ["hell"]
    ## 1617                                 ["bastard"]
    ## 1618                                    ["shit"]
    ## 1619                                  ["Christ"]
    ## 1620                                    ["dick"]
    ## 1621                                    ["fuck"]
    ## 1622                                    ["dick"]
    ## 1623                                    ["shit"]
    ## 1624                             ["fuck","dick"]
    ## 1625                                ["ass/arse"]
    ## 1626                                ["ass/arse"]
    ## 1627                                    ["shit"]
    ## 1628                                    ["fuck"]
    ## 1629                                  ["Christ"]
    ## 1630                                  ["Christ"]
    ## 1631                                    ["shit"]
    ## 1632                                    ["shit"]
    ## 1633                             ["fuck","hell"]
    ## 1634                             ["fuck","fuck"]
    ## 1635                                    ["hell"]
    ## 1636                                    ["hell"]
    ## 1637                                  ["Christ"]
    ## 1638                                    ["hell"]
    ## 1639                                    ["shit"]
    ## 1640                                    ["fuck"]
    ## 1641                                ["ass/arse"]
    ## 1642                                    ["shit"]
    ## 1643                                    ["damn"]
    ## 1644                                ["ass/arse"]
    ## 1645                                  ["Christ"]
    ## 1646                                    ["piss"]
    ## 1647                                    ["fuck"]
    ## 1648                                    ["shit"]
    ## 1649                                ["ass/arse"]
    ## 1650                                 ["bollock"]
    ## 1651                                ["ass/arse"]
    ## 1652                                  ["bugger"]
    ## 1653                                  ["bugger"]
    ## 1654                                    ["fuck"]
    ## 1655                                  ["bugger"]
    ## 1656                                    ["damn"]
    ## 1657                                    ["fuck"]
    ## 1658                                    ["piss"]
    ## 1659                             ["fuck","hell"]
    ## 1660                                    ["fuck"]
    ## 1661                                    ["fuck"]
    ## 1662                                    ["wank"]
    ## 1663                                    ["fuck"]
    ## 1664                                    ["fuck"]
    ## 1665                                    ["tits"]
    ## 1666                                    ["hell"]
    ## 1667                                    ["tits"]
    ## 1668                                    ["dick"]
    ## 1669                                    ["piss"]
    ## 1670                                    ["shit"]
    ## 1671                                    ["shit"]
    ## 1672                                    ["fuck"]
    ## 1673                             ["fuck","hell"]
    ## 1674                                ["ass/arse"]
    ## 1675                                    ["fuck"]
    ## 1676                                    ["fuck"]
    ## 1677                                    ["fuck"]
    ## 1678                                    ["damn"]
    ## 1679                                    ["fuck"]
    ## 1680                                    ["fuck"]
    ## 1681                                    ["shit"]
    ## 1682                           ["bugger","hell"]
    ## 1683                                    ["fuck"]
    ## 1684                                    ["fuck"]
    ## 1685                                    ["fuck"]
    ## 1686                                  ["Christ"]
    ## 1687                                    ["shit"]
    ## 1688                                    ["fuck"]
    ## 1689                                    ["fuck"]
    ## 1690                                    ["shit"]
    ## 1691                                    ["fuck"]
    ## 1692                                    ["fuck"]
    ## 1693                                    ["twat"]
    ## 1694                                    ["fuck"]
    ## 1695                                    ["fuck"]
    ## 1696                                    ["fuck"]
    ## 1697                                    ["hell"]
    ## 1698                                    ["fuck"]
    ## 1699                                    ["dick"]
    ## 1700                                    ["shit"]
    ## 1701                                    ["fuck"]
    ## 1702                                    ["fuck"]
    ## 1703                                   ["prick"]
    ## 1704                                    ["shit"]
    ## 1705                                    ["fuck"]
    ## 1706                                    ["hell"]
    ## 1707                                    ["fuck"]
    ## 1708                                  ["Christ"]
    ## 1709                                    ["fuck"]
    ## 1710                                    ["shit"]
    ## 1711                                    ["fuck"]
    ## 1712                                    ["fuck"]
    ## 1713                                    ["shit"]
    ## 1714                                    ["piss"]
    ## 1715                                    ["fuck"]
    ## 1716                             ["shit","fuck"]
    ## 1717                                    ["fuck"]
    ## 1718                                 ["bastard"]
    ## 1719                                    ["damn"]
    ## 1720                                    ["shit"]
    ## 1721                                    ["shit"]
    ## 1722                                    ["fuck"]
    ## 1723                                    ["fuck"]
    ## 1724                                    ["shit"]
    ## 1725                                ["ass/arse"]
    ## 1726                                    ["fuck"]
    ## 1727                                    ["fuck"]
    ## 1728                             ["hell","shit"]
    ## 1729                                    ["fuck"]
    ## 1730                                  ["bugger"]
    ## 1731                                  ["Christ"]
    ## 1732                                    ["piss"]
    ## 1733                                   ["prick"]
    ## 1734                                    ["shit"]
    ## 1735                                    ["fuck"]
    ## 1736                                  ["Christ"]
    ## 1737                                    ["hell"]
    ## 1738                             ["hell","fuck"]
    ## 1739                             ["damn","damn"]
    ## 1740                                    ["hell"]
    ## 1741                                    ["damn"]
    ## 1742                             ["shit","shit"]
    ## 1743                                    ["shit"]
    ## 1744                                    ["shit"]
    ## 1745                                  ["Christ"]
    ## 1746                                  ["Christ"]
    ## 1747                                   ["prick"]
    ## 1748                                  ["Christ"]
    ## 1749                                    ["piss"]
    ## 1750                                    ["fuck"]
    ## 1751                                    ["hell"]
    ## 1752                             ["wank","cock"]
    ## 1753                                    ["piss"]
    ## 1754                                    ["piss"]
    ## 1755                                    ["fuck"]
    ## 1756                                    ["piss"]
    ## 1757                                    ["dick"]
    ## 1758                                ["ass/arse"]
    ## 1759                                    ["dick"]
    ## 1760                                    ["shit"]
    ## 1761                                    ["shit"]
    ## 1762                                    ["fuck"]
    ## 1763                                    ["shit"]
    ## 1764                                  ["Christ"]
    ## 1765                                    ["shit"]
    ## 1766                           ["fuck","Christ"]
    ## 1767                                    ["hell"]
    ## 1768                                    ["fuck"]
    ## 1769                                    ["shit"]
    ## 1770                                  ["bugger"]
    ## 1771                                  ["bugger"]
    ## 1772                                    ["tits"]
    ## 1773                                  ["Christ"]
    ## 1774                                    ["shit"]
    ## 1775                                    ["hell"]
    ## 1776                                  ["Christ"]
    ## 1777                                    ["fuck"]
    ## 1778                                    ["fuck"]
    ## 1779                                    ["fuck"]
    ## 1780                             ["fuck","hell"]
    ## 1781                                    ["shit"]
    ## 1782                                    ["shit"]
    ## 1783                                    ["shit"]
    ## 1784                                    ["fuck"]
    ## 1785                                 ["bollock"]
    ## 1786                                    ["fuck"]
    ## 1787                             ["fuck","hell"]
    ## 1788                                    ["fuck"]
    ## 1789                                    ["fuck"]
    ## 1790                                ["ass/arse"]
    ## 1791                                    ["fuck"]
    ## 1792                                    ["fuck"]
    ## 1793                                    ["fuck"]
    ## 1794                                   ["prick"]
    ## 1795                                  ["Christ"]
    ## 1796                                    ["shit"]
    ## 1797                                    ["fuck"]
    ## 1798                                    ["damn"]
    ## 1799                                   ["prick"]
    ## 1800                                    ["damn"]
    ## 1801                                    ["fuck"]
    ## 1802                                    ["hell"]
    ## 1803                                    ["damn"]
    ## 1804                                 ["bastard"]
    ## 1805                                   ["bitch"]
    ## 1806                                    ["piss"]
    ## 1807                                    ["piss"]
    ## 1808                                    ["piss"]
    ## 1809                                  ["Christ"]
    ## 1810                                    ["hell"]
    ## 1811                                  ["Christ"]
    ## 1812                                    ["damn"]
    ## 1813                                    ["shit"]
    ## 1814                             ["fuck","shit"]
    ## 1815                                    ["shit"]
    ## 1816                                    ["fuck"]
    ## 1817                                    ["fuck"]
    ## 1818                                    ["shit"]
    ## 1819                                    ["fuck"]
    ## 1820                                    ["hell"]
    ## 1821                             ["fuck","hell"]
    ## 1822                                    ["shit"]
    ## 1823                                    ["shit"]
    ## 1824                                    ["shit"]
    ## 1825                                    ["fuck"]
    ## 1826                                    ["fuck"]
    ## 1827                             ["fuck","fuck"]
    ## 1828                                    ["shit"]
    ## 1829                                    ["fuck"]
    ## 1830                                    ["fuck"]
    ## 1831                                    ["fuck"]
    ## 1832                                    ["damn"]
    ## 1833                                    ["fuck"]
    ## 1834                                    ["fuck"]
    ## 1835                                    ["fuck"]
    ## 1836                                    ["shit"]
    ## 1837                                    ["shit"]
    ## 1838                                ["ass/arse"]
    ## 1839                         ["bugger","bugger"]
    ## 1840                                    ["fuck"]
    ## 1841                                    ["piss"]
    ## 1842                                    ["shit"]
    ## 1843                                    ["shit"]
    ## 1844                                    ["piss"]
    ## 1845                                    ["shit"]
    ## 1846                                    ["fuck"]
    ## 1847                                   ["pussy"]
    ## 1848                                    ["fuck"]
    ## 1849                                    ["fuck"]
    ## 1850                                    ["shit"]
    ## 1851                                    ["fuck"]
    ## 1852                                 ["bastard"]
    ## 1853                                    ["fuck"]
    ## 1854                                    ["shit"]
    ## 1855                             ["fuck","hell"]
    ## 1856                                  ["Christ"]
    ## 1857                    ["fuck","hell","Christ"]
    ## 1858                                  ["Christ"]
    ## 1859                                    ["wank"]
    ## 1860                                    ["fuck"]
    ## 1861                                    ["hell"]
    ## 1862                                    ["fuck"]
    ## 1863                                    ["fuck"]
    ## 1864                                    ["shit"]
    ## 1865                                  ["Christ"]
    ## 1866                                    ["fuck"]
    ## 1867                                    ["fuck"]
    ## 1868                                    ["fuck"]
    ## 1869                                  ["Christ"]
    ## 1870                                    ["fuck"]
    ## 1871                                    ["fuck"]
    ## 1872                                    ["damn"]
    ## 1873                                    ["fuck"]
    ## 1874                                    ["fuck"]
    ## 1875                                    ["fuck"]
    ## 1876                                    ["fuck"]
    ## 1877                                  ["bugger"]
    ## 1878                                    ["fuck"]
    ## 1879                                    ["fuck"]
    ## 1880                                    ["fuck"]
    ## 1881                                    ["shit"]
    ## 1882                                    ["shit"]
    ## 1883                                    ["fuck"]
    ## 1884                             ["shit","fuck"]
    ## 1885                                    ["shit"]
    ## 1886                                 ["bastard"]
    ## 1887                                    ["shit"]
    ## 1888                                    ["shit"]
    ## 1889                                    ["shit"]
    ## 1890                                    ["shit"]
    ## 1891                                    ["fuck"]
    ## 1892                                    ["shit"]
    ## 1893                                    ["damn"]
    ## 1894                                    ["shit"]
    ## 1895                                 ["bastard"]
    ## 1896                                    ["shit"]
    ## 1897                                    ["shit"]
    ## 1898                                  ["Christ"]
    ## 1899                             ["fuck","fuck"]
    ## 1900                                    ["fuck"]
    ## 1901                                    ["fuck"]
    ## 1902                                    ["fuck"]
    ## 1903                                    ["damn"]
    ## 1904                                  ["Christ"]
    ## 1905                                    ["shit"]
    ## 1906                                    ["shit"]
    ## 1907                                    ["shit"]
    ## 1908                                    ["shit"]
    ## 1909                                    ["shit"]
    ## 1910                                    ["shit"]
    ## 1911                                    ["shit"]
    ## 1912                                    ["hell"]
    ## 1913                                    ["shit"]
    ## 1914                                    ["shit"]
    ## 1915                                    ["shit"]
    ## 1916                                 ["bastard"]
    ## 1917                                    ["cock"]
    ## 1918                                    ["cock"]
    ## 1919                                    ["cock"]
    ## 1920                                 ["bastard"]
    ## 1921                                  ["Christ"]
    ## 1922                                    ["cock"]
    ## 1923                                    ["cock"]
    ## 1924                                    ["hell"]
    ## 1925                                    ["hell"]
    ## 1926                                    ["hell"]
    ## 1927                                    ["shit"]
    ## 1928                                    ["shit"]
    ## 1929                                    ["hell"]
    ## 1930                                  ["Christ"]
    ## 1931                                    ["dick"]
    ## 1932                                    ["damn"]
    ## 1933                                   ["bitch"]
    ## 1934                                    ["fuck"]
    ## 1935                                    ["fuck"]
    ## 1936                                    ["fuck"]
    ## 1937                                 ["bastard"]
    ## 1938                                 ["bastard"]
    ## 1939                                    ["damn"]
    ## 1940                                 ["bastard"]
    ## 1941                                 ["bastard"]
    ## 1942                                 ["bastard"]
    ## 1943                                    ["damn"]
    ## 1944                                 ["bastard"]
    ## 1945                                 ["bastard"]
    ## 1946                                 ["bastard"]
    ## 1947                                 ["bastard"]
    ## 1948                                 ["bastard"]
    ## 1949                                  ["bugger"]
    ## 1950                                  ["bugger"]
    ## 1951                                    ["damn"]
    ## 1952                                   ["prick"]
    ## 1953                                    ["cock"]
    ## 1954                                    ["fuck"]
    ## 1955                                    ["hell"]
    ## 1956                                    ["hell"]
    ## 1957                                    ["shit"]
    ## 1958                                ["ass/arse"]
    ## 1959                                 ["bastard"]
    ## 1960                                    ["fuck"]
    ## 1961                                    ["hell"]
    ## 1962                                 ["bollock"]
    ## 1963                                 ["bollock"]
    ## 1964                                 ["bollock"]
    ## 1965                                 ["bollock"]
    ## 1966                                 ["bollock"]
    ## 1967                                  ["Christ"]
    ## 1968                                 ["bastard"]
    ## 1969                                    ["shit"]
    ## 1970                                    ["fuck"]
    ## 1971                                    ["hell"]
    ## 1972                                    ["hell"]
    ## 1973                                    ["fuck"]
    ## 1974                                    ["hell"]
    ## 1975                                    ["shit"]
    ## 1976                           ["shit","Christ"]
    ## 1977                                    ["fuck"]
    ## 1978                                    ["tits"]
    ## 1979                                    ["hell"]
    ## 1980                                    ["tits"]
    ## 1981                                    ["shit"]
    ## 1982                                    ["fuck"]
    ## 1983                                    ["damn"]
    ## 1984                                    ["damn"]
    ## 1985                                    ["fuck"]
    ## 1986                                 ["bastard"]
    ## 1987                                    ["shit"]
    ## 1988                                    ["shit"]
    ## 1989                                    ["shit"]
    ## 1990                                    ["piss"]
    ## 1991                             ["piss","piss"]
    ## 1992                             ["fuck","hell"]
    ## 1993                             ["fuck","hell"]
    ## 1994                                    ["fuck"]
    ## 1995                                    ["shit"]
    ## 1996                                    ["hell"]
    ## 1997                                    ["shit"]
    ## 1998                                    ["shit"]
    ## 1999                                  ["Christ"]
    ## 2000                                    ["shit"]
    ## 2001                                    ["fuck"]
    ## 2002                                    ["fuck"]
    ## 2003                                    ["hell"]
    ## 2004                                    ["fuck"]
    ## 2005                             ["fuck","hell"]
    ## 2006                                    ["hell"]
    ## 2007                                    ["fuck"]
    ## 2008                                    ["damn"]
    ## 2009                                    ["damn"]
    ## 2010                                ["ass/arse"]
    ## 2011                                    ["shit"]
    ## 2012                                    ["shit"]
    ## 2013                                    ["shit"]
    ## 2014                                    ["shit"]
    ## 2015                                   ["bitch"]
    ## 2016                                   ["bitch"]
    ## 2017                                    ["hell"]
    ## 2018                                    ["hell"]
    ## 2019                                    ["piss"]
    ## 2020                                    ["shit"]
    ## 2021                                   ["bitch"]
    ## 2022                                   ["bitch"]
    ## 2023                                   ["bitch"]
    ## 2024                      ["fuck","fuck","fuck"]
    ## 2025                                    ["cock"]
    ## 2026                                    ["shit"]
    ## 2027                                    ["tits"]
    ## 2028                                    ["cock"]
    ## 2029                                  ["Christ"]
    ## 2030                                    ["piss"]
    ## 2031                                    ["shit"]
    ## 2032                                    ["fuck"]
    ## 2033                                  ["Christ"]
    ## 2034                                ["ass/arse"]
    ## 2035                                  ["Christ"]
    ## 2036                                  ["Christ"]
    ## 2037                                  ["Christ"]
    ## 2038                                  ["Christ"]
    ## 2039                                  ["Christ"]
    ## 2040                                    ["cunt"]
    ## 2041                                    ["shit"]
    ##                                                                                                                                                                                                                                                                                                            quote
    ## 1                                                                                                                                                                                                                                 I think we can all agree it's the shittest present in the history of humanity.
    ## 2                                                                                                                                                                                                                                                          You know the granules? The snow density is piss-poor.
    ## 3                                                                                                                                                                                                                                    And the winner of this competition will have to take all of that shit home.
    ## 4                                                                                                                                                                                                                                                  And then when I threw it I was like, "Holy shit, that has..."
    ## 5                                                                                                                                                                                                                 I've got an image of you at an all-you-can-eat buffet just kicking the shit out of everything.
    ## 6                                                                                                                                                                                                                                                                                                Son of a bitch!
    ## 7                                                                                                                                                                                                                                                                                                     Horseshit.
    ## 8                                                                                                                                                                                                                                                                                     What a pile of horse shit.
    ## 9                                                                                                                                                                                                                                                                       And I am absolutely dogshit at painting.
    ## 10                                                                                                                                                                                                                                                                            The top three are absolutely shit.
    ## 11                                                                                                                                                                                                                                                                                             Ow, Jesus Christ!
    ## 12                                                                                                                                                                                                                                                                                     Stop being such a wanker.
    ## 13                                                                                                                                                                                                                                                                                     That's absolute bullshit.
    ## 14                                                                                                                                                                                                                                                               Alex, what the hell are we gonna do about this?
    ## 15                                                                                                                                                                                                                                              On the plus side, I don't have that dogshit snow globe any more.
    ## 16                                                                                                                                                                                                                                                    The category is not "shit that would be great at a party".
    ## 17                                                                                                                                                                                                                                                   Old pisshead here's just got a massive bottle of champagne.
    ## 18                                                                                                                                                                                                                                                                                           I'm not a pisshead!
    ## 19                                                                                                                                                                                                                                                                                        This is bullshit, man.
    ## 20                                                                                                                                                                                                                                                                  Feels like being Bond, but sort of shittier.
    ## 21                                                                                                                                                                                                                  I mean, Jesus Christ, I thought you'd only stood catatonic with a shit sign for ten minutes.
    ## 22                                                                                                                                                                                                                                                                                                 Jesus Christ!
    ## 23                                                                                                                                                                                                                                                                                             Oh, Jesus Christ.
    ## 24                                                                                                                                                                                                                                                                                 It's not the fucking X-Files.
    ## 25                                                                                                                                                                                                                                                                          I still can't‒what the hell is that?
    ## 26                                                                                                                                                                                                                                                      We've just seen a film of you breaching the fucking pie!
    ## 27                                                                                                                                                                                                                                                                             'Cause it ended up being dogshit!
    ## 28                                                                                                                                                                                                                                                 But you would've thought that dog shit was steak, to be fair.
    ## 29                                                                                                                                                                                                                                                        This is bullshit, man. Utter bullshit. Utter bullshit.
    ## 30                                                                                                                                                                                                                                                                                                  It was shit.
    ## 31                                                                                                                                                                                                                                            ♪ Tree Wizard, magical hands and‒holy shit, it's another balloon ♪
    ## 32                                                                                                                                                                                                                                                                             Oh, fuck this. I'm just gambling.
    ## 33                                                                                                                                                                                                                                                                                        Oh, for Christ's sake.
    ## 34                                                                                                                                                                                                             I like to give people a chance to justify their decisions, but I will say this: it's shit, go on.
    ## 35                                                                                                                                                                                                                                                                                 Now I feel like a total shit.
    ## 36                                                                                                                                                                                                                         I went, "Good luck, everyone. Boop!" to Romesh and he went, "What the fuck was that?"
    ## 37                                                                                                                                                                                                                                                                              But what the fuck was that, man?
    ## 38                                                                                                                                                                                                                                                He won't speak to you 'cause you didn't read his fucking book.
    ## 39                                                                                                                                                                                                                                                                                                     Fuck you!
    ## 40                                                                                                                                                                                                                                                                                         Fuck you! Oh, my god!
    ## 41                                                                                                                                                                                                                                                                               Come on, colour in, you fucker.
    ## 42                                                                                                                                                                                                                                                           He seemed to cover a hell of a distance, didn't he?
    ## 43                                                                                                                                                                                               It's a really good painting, but why on earth do I want a picture of you? It's absolutely fucking preposterous.
    ## 44                                                                                                                                                                                                                                  Yeah, sure. But I worry that usually if you go first, it's the shittest one.
    ## 45                                                                                                                                                                                         And the main use of them, of course, is I'll be able to see if there's any of those bastard pregnant women behind me.
    ## 46                                                                                                                                                                                                                                                                                          Is it real? Fuck me!
    ## 47                                                                                                                                                                                                                                                                                                         Fuck.
    ## 48                                                                                                                                                                                                                                                                             I don't know what the hell to do.
    ## 49                                                                                                                                                                                                                                                                                                 Oh, bollocks.
    ## 50                                                                                                                                                                                                                                                                                     Bollocks. Crap. Fuck off.
    ## 51                                                                                                                                                                                                                                                              Like, you're really pissing me off tonight, man.
    ## 52                                                                                                                                                                                                                                                                                     I'm amazed I give a shit.
    ## 53                                                                                                                                                                                                                                                                                                     Fuck you.
    ## 54                                                                                                                                                                                                                                                     Looks like a badger that's sniffing its tits, doesn't it?
    ## 55                                                                                                                                                                                                                       Well, it doesn't have a happy ending unfortunately, 'cause he is a shithead now, but...
    ## 56                                                                                                                                                                                                                                                                                Are you shitting me right now?
    ## 57                                                                                                                                                                                                                                                                                      Are you a fucking child?
    ## 58                                                                                                                                                                                                                                             Sadly for you, I am a child who's in charge of this fucking show.
    ## 59                                                                                                                                                                                                                                                      Now I'm gonna try and smash the shit out the rest of it.
    ## 60                                                                                                                                                                                                                                                          I gotta be honest with you, I feel pretty damn good.
    ## 61                                                                                                                                                                                                                                              What I did was an inventive way of getting rid of this damn ice.
    ## 62                                                                                                                                                                                                                                                            What does that mean? What the hell does that mean?
    ## 63                                                                                                                                                                                                                                                                                  Fucking hard to get a point.
    ## 64                                                                                                                                                                                                                                                                                                   You wanker.
    ## 65                                                                                                                                                                                                                                                                                                       Wanker.
    ## 66                                                                                                                                                                                                                                                                                           Shit in the bucket?
    ## 67                                                                                                                                                                                                                                                                            Touching our heads? Fucking idiot.
    ## 68                                                                                                                                                                                                                                                   Oh, for Christ's sake. It's doing my head in already, this.
    ## 69                                                                                                                                                                                                                                            I don't wanna sort of "spoiler alert" my VT, but I was shit at it.
    ## 70                                                                                                                                                                                                                                                                            I mean, there's fuck-all in there.
    ## 71                                                                                                                                                                                                                                                                                                     Oh, shit!
    ## 72                                                                                                                                                                                                                                                                                                         Fuck!
    ## 73                                                                                                                                                                                                                                                                                                  Oh, fuck me!
    ## 74                                                                                                                                                                                                                                                                                                     Oh, shit.
    ## 75                                                                                                                                                                                                                                                                                                     Oh, shit.
    ## 76                                                                                                                                                                                                                                                                               Yank Bank? Or... or Wank Plank.
    ## 77                                                                                                                                                                                                                                                               I don't think he'd respond to "the Wank Plank".
    ## 78                                                                                                                                                                                                                                                                   £600 is a hell of a start though, isn't it?
    ## 79                                                                                                                                                                                                                                                                  Nearly four grand. It's a hell of an opener.
    ## 80                                                                                                                                                                                                                                                        Well, that's you well and truly fucked then, isn't it?
    ## 81                                                                                                                                                                                                                                                                                    Well, deal with it, bitch!
    ## 82                                                                                                                                                                                                         When he turned up he said, "You'll never guess, some crazy shithead wanted me to go to Camber Sands."
    ## 83                                                                                                                                                                                                                                                    Do you understand why I can't deal with Mo? Mo is a prick!
    ## 84                                                                                                                                                                                                                                                             How long did you piss around with those balloons?
    ## 85                                                                                                                                                                                                                                                             Pissed around for about... half an hour, I think.
    ## 86                                                                                                                                                                                                                                                                               Oh, shit, watch out, watch out!
    ## 87                                                                                                                                                                                                                                                                    Come on, Rois, put some fuckin' effort in.
    ## 88                                                                                                                                                                                                                                                                                       And a cheap, shit ring.
    ## 89                                                                                                                                                                                                                                              Yes, please, Greg. That's why we came, to see you shit yourself.
    ## 90                                                                                                                                                                                                                                                                      It's backfired, I look like a prick now.
    ## 91                                                                                                                                                                                                                                                                                                         Shit.
    ## 92                                                                                                                                                                                                                                                                                                   Shit. Shit!
    ## 93                                                                                                                                                                                                                                                                              I think you're all shit at golf.
    ## 94                                                                                                                                                                                                                                               It sounds like even professional golf players are shit at golf.
    ## 95                                                                                                                                                                                                                                                                                                 Hit his arse.
    ## 96                                                                                                                                                                                                                                                                                                 Hit his arse!
    ## 97                                                                                                                                                                                                                                                                    "Oh, shit! Paddling pool, out of nowhere!"
    ## 98                                                                                                                                                                                                                                                         It is a lot shitter than I thought it was gonna look.
    ## 99                                                                                                                                                                                                              And then I waited for the reveal and then there was none and then we had to defend that dogshit.
    ## 100                                                                                                                                                                                                                                                                                                Shit the bed!
    ## 101                                                                                                                                                                                                                                                                                                Oh, fuck off!
    ## 102                                                                                                                                                                                                                                                                                         Oh, for fuck's sake!
    ## 103                                                                                                                                                                                                                                                                                 Can the floor get fucked up?
    ## 104                                                                                                                                                                                                                                             Yeah, it doesn't say whether the floor can get fucked up or not.
    ## 105                                                                                                                                                                                                                                                                                          Just fucking awful.
    ## 106                                                                                                                                                                                                                                                                                                        Shit.
    ## 107                                                                                                                                                                                                                          I can't believe we're believing that Joe Wilkinson is married and I'm gettin' shit.
    ## 108                                                                                                                                                                                                                                                                                                    Ah, shit!
    ## 109                                                                                                                                                                                                                                                                                                       Prick!
    ## 110                                                                                                                                                                                                                                                                                          Fucking hate hills.
    ## 111                                                                                                                                                                                                                                                                                              Fuck you, Alex.
    ## 112                                                                                                                                                                                                                                                                                                  Fuck! Shit!
    ## 113                                                                                                                                                                                                                                                                                                     Bastard.
    ## 114                                                                                                                                                                                                                                                                                                     Bastard!
    ## 115                                                                                                                                                                                                                                                                            How long did the shit Dalek take?
    ## 116                                                                                                                                                                                                                                                                         And then I thought, "Piece of piss."
    ## 117                                                                                                                                                                                                                                                                      This is fucking harsh, I'm just saying!
    ## 118                                                                                                                                                                                                                                                                                                   Nej? Shit!
    ## 119                                                                                                                                                                                                                                                                                It sounded like arse-licking.
    ## 120                                                                                                                                                                                                                                                                                        Yeah. Arse-licking...
    ## 121                                                                                                                                                                                                                  The only thing you managed to establish was that he didn't have an opinion on arse-licking.
    ## 122                                                                                                                                                                                                                                                                                     Croupier! Fucking idiot.
    ## 123                                                                                                                                                                                                                                                                                      Shit. Is he unemployed?
    ## 124                                                                                                                                                                                                                                                                                                Motherfucker!
    ## 125                                                                                                                                                                                                                                                                                                        Fuck!
    ## 126                                                                                                                                                                                                                                                                                                    Oh, shit.
    ## 127                                                                                                                                                                                                                                                                                                Motherfucker!
    ## 128                                                                                                                                                                                                                                            I'm not gonna hoover it off the table like some egg-hungry whore.
    ## 129                                                                                                                                                                                                                            It's no more disturbing than seeing a peanut fucked up by a train, though, is it?
    ## 130                                                                                                                                                                                                                                                                    ♪ Then I let that little prick go again ♪
    ## 131                                                                                                                                                                                                                                                                          ♪ Motherfucker bit my finger, bro ♪
    ## 132                                                                                                                                                                                                                                                                    Ah, Joe. It's gonna be shit, innit, mate?
    ## 133                                                                                                                                                                                                                  If I'd have just seen the picture, I'd have said it was shit, but up close it's incredible.
    ## 134                                                                                                                                                                                                                                                                        Like she's the dick in this scenario.
    ## 135                                                                                                                                                                                                                                                                                       Oh, you little fucker!
    ## 136                                                                                                                                                                                                                                                                                    Get in the fucking thing!
    ## 137                                                                                                                                                                                                                                               If I am attending, I'm gonna be fucking awesome at that party.
    ## 138                                                                                                                                                                                                                                                                                                        Shit.
    ## 139                                                                                                                                                                                                                                                                        Of Amersham, we don't give two fucks.
    ## 140                                                                                                                                                                                                                                                                    Jugglers, we don't give a fuck about you.
    ## 141                                                                                                                                                                                                                                                                                                   Holy shit.
    ## 142                                                                                                                                                                                                                                                    Still less impressed than the fucking photo of an éclair.
    ## 143                                                                                                                                                                                                                                          I mean, I recognise that as a load of shit loosely thrown together.
    ## 144                                                                                                                                                                                                                     I just don't like that sort of novelty bullshit, but you pulled it back with the sweets.
    ## 145                                                                                                                                                                                                                                                              Yeah, but it makes me look like a shit, dunnit?
    ## 146                                                                                                                                                                                                                                                                                     What fresh hell is this?
    ## 147                                                                                                                                                                                                                                                                                                Fuckin' hell.
    ## 148                                                                                                                                                                                                                                                                                07... shit, what's my number?
    ## 149                                                                                                                                                                                                                                                                                              An onion? Shit.
    ## 150                                                                                                                                                                                                                                                                           Oh, shit. Osman's got longer legs.
    ## 151                                                                                                                                                                                                                                                                                              Fuckin' rabbit.
    ## 152                                                                                                                                                                                                                                                                                    Come on, you little shit.
    ## 153                                                                                                                                                                                                                                                                                 Come on, you ginger bastard.
    ## 154                                                                                                                                                                                                                                                                                Oh, you are a little bastard!
    ## 155                                                                                                                                                                                                                                                 Jon also called the cat a dick and then he called me a dick.
    ## 156                                                                                                                                                                                                                                                                                  Why did he call you a dick?
    ## 157                                                                                                                                                                                                                                                     And it's some ginger piece of shit in a tree, who cares?
    ## 158                                                                                                                                                                                                                                                              You are calling the cat a ginger piece of shit?
    ## 159                                                                                                                                                                                                                                                                                    Where's this fucking cat?
    ## 160                                                                                                                                                                                                                                                                                              Son of a bitch!
    ## 161                                                                                                                                                                                                                                                                                "Son of a bitch!", like that.
    ## 162                                                                                                                                                                                                                                                             Not as bad as calling you a dick, though, is it?
    ## 163                                                                                                                                                                                                                                                                                                 Right. Shit.
    ## 164                                                                                                                                                                                                                                                                                                    Ah, fuck!
    ## 165                                                                                                                                                                                                                                                                                                Fuckin' hell.
    ## 166                                                                                                                                                                                                                                                                 Is there some pineapple hidden in your arse?
    ## 167                                                                                                                                                                                                                                                                      There is pineapple in my arse. Correct.
    ## 168                                                                                                                                                                                                                                         Would it be possible for everyone not to look at my arse as I leave?
    ## 169                                                                                                                                                                                                                                                  Could everyone not look at Joe's arse as he leaves, please?
    ## 170                                                                                                                                                                                                                                        So that was the strategy, yeah? Arse, crotch. Bish, bash, bosh. Done.
    ## 171                                                                                                                                                                                                                                                                                            I ate a shitload.
    ## 172                                                                                                                                                                                                                                                                             Oh, yeah, and he ate a shitload.
    ## 173                                                                                                                                                                                                                                                                                   Nice. Fucking loving that.
    ## 174                                                                                                                                                                                                                                                                                  I think it's fucking great.
    ## 175                                                                                                                                                                                                        It looked like you could build something, but you genuinely had to use gaffer tape and a bossy bitch.
    ## 176                                                                                                                                                                                                                                                                       This is gonna be horse shit, isn't it?
    ## 177                                                                                                                                                                                                                                                                     It could be... this could be horse shit.
    ## 178                                                                                                                                                                                                          I just assumed, when you played that first clip, that you cut out how genuinely pissed off Joe was.
    ## 179                                                                                                                                                                                                                                                      In the first second you said everything was horse shit.
    ## 180                                                                                                                                                                                                                                                                                      Oh, you little bastard.
    ## 181                                                                                                                                                                                                                                               Slight worries about the plan... and whether or not it's shit.
    ## 182                                                                                                                                                                                                                                          Well, I mean, honestly don't know what the fuck was going on there.
    ## 183                                                                                                                                                                                                                                                                Do you want me to pass judgment on this shit?
    ## 184                                                                                                                                                                                                                                                      I'm gonna dance to the Average White Band, you bastard.
    ## 185                                                                                                                                                                                                                                                                      It looks like a shitty milk-bottle top.
    ## 186                                                                                                                                                                                                                            In third place, I'm putting Jon's Roman coin, just 'cause they're worth fuck-all.
    ## 187                                                                                                                                                                                                                        If you think that women are more important than Jocky Wilson, you fucking come to me.
    ## 188                                                                                                                                                                                                                                                                                             Oh, you bastard!
    ## 189                                                                                                                                                                                              Bam! I get the job done as quickly as possible, even when some prick takes the wheels off the shopping trolley.
    ## 190                                                                                                                                                                                                                                                                              There's a fucking bridge there.
    ## 191                                                                                                                                                                                                                                                                                                        Shit!
    ## 192                                                                                                                                                                                                                                                                                                      Shit...
    ## 193                                                                                                                                                                                                                                                                                         Got no wheels. Fuck!
    ## 194                                                                                                                                                                                                                                                                                                Oh, piss off!
    ## 195                                                                                                                                                                                                                                                      You got to the P-O and thought, "Fuck it. Pony, right?"
    ## 196                                                                                                                                                                                                                                                                                            Such a shit idea.
    ## 197                                                                                                                                                                                                                                                                                          What the fuck, man?
    ## 198                                                                                                                                                                                                                                                                                           Ah! Ah! Holy shit.
    ## 199                                                                                                                                                                                                                                                                                  Oh, don't let mine be shit.
    ## 200                                                                                                                                                                                                                                                                                              What the fuck?!
    ## 201                                                                                                                                                                                                                                                                                 Alright, well, fuck it then.
    ## 202                                                                                                                                                                                                                             I did ask Alex if he could make sure there was a lot of goose shit on the track.
    ## 203                                                                                                                                                                                                                                                                 I'm gonna be covered in goose shit, ain't I?
    ## 204                                                                                                                                                                                                   I don't know why drinking a massive coffee and then rolling around in goose shit would make you feel sick.
    ## 205                                                                                                                                                                                                                                                    When is a step not a step? When it's on a fucking hurdle.
    ## 206                                                                                                                                                                                                                                                                                           Ooh, so much shit!
    ## 207                                                                                                                                                                                                                           In first place, with an incredible shitty, sicky performance, it's Rob the Roller.
    ## 208                                                                                                                                                                                                                                                              It's like finding a pea in a... haystack. Shit!
    ## 209                                                                                                                                                                                                                                                            And then when I finish, fucking bang it on there.
    ## 210                                                                                                                                                                                                                                                                                     Bastard's crying, innit?
    ## 211                                                                                                                                                                                                 Right at the end, just as the final image of a snowman was in place, he said, "The bastard's crying, innit?"
    ## 212                                                                                                                                                                                                                                                                            Let's have a look at the bastard.
    ## 213                                                                                                                                                                                                                    It would have been nice if you could have taken some time to scrub that bird shit off it.
    ## 214                                                                                                                                                                                                                                           I'm putting Paul Chowdhry for putting some fucking melon in a box.
    ## 215                                                                                                                                                                                                                   Why's there spunk on your phone, Alex? No wonder you've been locked up, you dirty bastard.
    ## 216                                                                                                                                                                                                                                                                           911 to get in this little bastard.
    ## 217                                                                                                                                                                                                                                                                                           Not a pussy, mate.
    ## 218                                                                                                                                                                                                                                                                                    Oh, you fucking arsehole.
    ## 219                                                                                                                                                                                                                                                                                  We are a trio of dickheads.
    ## 220                                                                                                                                                                                                                                                                 Three great minds... or a trio of dickheads.
    ## 221                                                                                                                                                                                                                                                                             Ugh. Cheap, vinegary shit, that.
    ## 222                                                                                                                                                                                                                                                                                       Taking the piss, mate.
    ## 223                                                                                                                                                                                                                                                  These balloons are bastards, mate. They're bastards, innit?
    ## 224                                                                                                                                                                                                                                                                                                     Bastard!
    ## 225                                                                                                                                                                                                                               And nice to see you're consistent with your use of the word "bastard" as well.
    ## 226                                                                                                                                                                                                                                       Last episode, you called a rabbit covered in a Slush Puppie a bastard.
    ## 227                                                                                                                                                                                                                                                                                            Damn you to hell!
    ## 228                                                                                                                                                                                                                                                                                                    Bollocks!
    ## 229                                                                                                                                                                                                                                                                                                Oh, fuck off!
    ## 230                                                                                                                                                                                                                                                                 I mean, that would scare the shit out of me.
    ## 231                                                                                                                                                                                                                        He's not gonna help me do an accurate piss in the middle of the night, though, is he?
    ## 232                                                                                                                                                                                                                                                                                               From his arse?
    ## 233                                                                                                                                                                                                                                                                Al Murray's gonna win this, that fat bastard.
    ## 234                                                                                                                                                                                                                                                                                                 Oh, damn it!
    ## 235                                                                                                                                                                                                                                                                                                 Bloody hell.
    ## 236                                                                                                                                                                                                   I read "domino rally" as a rally of dominoes in the same way that I saw "sweat" as sweat rather than piss.
    ## 237                                                                                                                                                                                                                                                                          Oh, you absolute bell-end! Damn it!
    ## 238                                                                                                                                                                                                                                                                                    Oh, Christ. I've no idea.
    ## 239                                                                                                                                                                                                                                                                                      Are you... shitting me?
    ## 240                                                                                                                                                                                                                                                                    Oh, you didn't piss in the tray, did you?
    ## 241                                                                                                                                                                                                                                                                                            Oh, fucking hell.
    ## 242                                                                                                                                                                                                            What did you think were the chances of that plane flying with your fucking sock wrapped round it?
    ## 243                                                                                                                                                                                                                                                                          Are you joking? I fucking love him.
    ## 244                                                                                                                                                                                                                                                                    Oh, for fuck's sake, you fucking bastard!
    ## 245                                                                                                                                                                                                                                                                      I mean, that is the shittest prize yet.
    ## 246                                                                                                                                                                                                                                                                   Pebbles looks like a bit of a prick to me.
    ## 247                                                                                                                                                                                                                                                                                           Why the fuck peas?
    ## 248                                                                                                                                                                                                                                                                  Yeah, I just lost all control. Oh, fuck me!
    ## 249                                                                                                                                                                                                                                                                                         Oh, for fuck's sake.
    ## 250                                                                                                                                                                                                                                             And it was so cold. I was shitting meself, I was dropping water.
    ## 251                                                                                                                                                                                                                                                                              "Yo yo, the motherfuckin' FIP."
    ## 252                                                                                                                                                                                                                                                                       Right, what the hell have we got here?
    ## 253                                                                                                                                                                                                                                                                                     Fucking fuck off, plane!
    ## 254                                                                                                                                                                                                                                                           How am I supposed to do this with a fucking plane?
    ## 255                                                                                                                                                                                                                                                                                     Oh, thank fuck for that.
    ## 256                                                                                                                                                                                                                                                                      I was like, "Fuck's sake!" Dah-dah-dah!
    ## 257                                                                                                                                                                                                 The point is, you did a genuinely good film and I honestly thought it was gonna be horse shit, so well done.
    ## 258                                                                                                                                                                                                                                        Yeah, the story of that was belt some shit out of some fruit and veg.
    ## 259                                                                                                                                                                                                                                                                                                     Damn it!
    ## 260                                                                                                                                                                                                                                                                    I'm not gonna bother, then. Fuck charity!
    ## 261                                                                                                                                                                                                 It was like someone choreographing a ballet and then coming out onto the stage afterwards and having a shit.
    ## 262                                                                                                                                                                                                 That is drawing a line under your Bake Off career. "You want me to destroy a cake? Fuck you, cake. I'm off."
    ## 263                                                                                                                                                                                                                                                                                          Hashtag tough shit!
    ## 264                                                                                                                                                                                                                                                                    I don't need to judge who's fucking last!
    ## 265                                                                                                                                                                                                                                                                                                    Ah! Fuck.
    ## 266                                                                                                                                                                                                                                                                      How am I gonna make these buggers fell?
    ## 267                                                                                                                                                                                                                           I did not in my wildest fantasies think antone else would choose fucking tweezers!
    ## 268                                                                                                                                                                                                                                                                            It's all gone to shit since then.
    ## 269                                                                                                                                                                                                                                              You shut your fucking mouths! I will put him last! I mean that.
    ## 270                                                                                                                                                                                                                                                                                                    Fuck off.
    ## 271                                                                                                                                                                                                                                                             Lolly, your system was absolute fucking madness.
    ## 272                                                                                                                                                                                                                                                                                   What the hell is going on?
    ## 273                                                                                                                                                                                                                                                                       Bloody hell, this is tricky, isn't it?
    ## 274                                                                                                                                                                                                                                                                                       What fucking nonsense.
    ## 275                                                                                                                                                                                                                                                                               Then it would've‒aw, bollocks!
    ## 276                                                                                                                                                                                                                                                            And then in the end, fuck it, fill a funnel full.
    ## 277                                                                                                                                                                                                                                                                                                Jesus Christ!
    ## 278                                                                                                                                                                                                                                                                                     Get off the fucking bus!
    ## 279                                                                                                                                                                                                                                  I have [heard of the sky], but in Britain the sky is generally really shit.
    ## 280                                                                                                                                                                                                                                                                                              Yeah, all shit.
    ## 281                                                                                                                                                                                                                                                     There are no clouds and that is the whole fucking point!
    ## 282                                                                                                                                                                                                                                                                                          One hour. Oh, shit.
    ## 283                                                                                                                                                                                                                                                                         "And tiny bitch-puppet, Alex Horne."
    ## 284                                                                                                                                                                                                                                       I was scared of the one that barked at me when I left. He was a prick.
    ## 285                                                                                                                                                                                                                                                                                        Some dogs are pricks.
    ## 286                                                                                                                                                                                                                                                                 Oh, we're friends now, aren't we, you prick?
    ## 287                                                                                                                                                                                                                                                                                                Jesus Christ!
    ## 288                                                                                                                                                                                                      It's not fair. I mean, that dog was a prick, Joe was right. But chickens, across the board, are pricks.
    ## 289                                                                                                                                                                                                                                                                                    What the hell's going on?
    ## 290                                                                                                                                                                                                                                                               It's not point-worthy, so... fuckin' leave it.
    ## 291                                                                                                                                                                                  You wanna see how to move water from one fishbowl to another, you go to Joe Lycett, okay, and you don't listen to bullshit.
    ## 292                                                                                                                                                                                                                                                                         Can I say that's a really shit idea?
    ## 293                                                                                                                                                                                                                                                                                                        Shit!
    ## 294                                                                                                                                                                                                                                                              I could just drink this and then piss in there.
    ## 295                                                                                                                                                                                                                                           Everything he's brought in has been universally judged to be shit.
    ## 296                                                                                                                                                                                                                                                         Because why the fuck would Hugh Dennis be wearing...
    ## 297                                                                                                                                                                                                                                                                                   That sun's fucking bright!
    ## 298                                                                                                                                                                                                                                               I tell you who it won't be, that twat who dresses like a crow.
    ## 299                                                                                                                                                                                                                                                                                                        Shit.
    ## 300                                                                                                                                                                                   He was dropping a plumb line for absolute accuracy, Which is what all dads do before they totally miss the fucking bucket.
    ## 301                                                                                                                                                                                                                                                                        However, on this occasion, horseshit.
    ## 302                                                                                                                                                                                                                 The sadness inherent within that story was slightly diluted by the weird... dick-cone horse.
    ## 303                                                                                                                                                                                                                                                                          That is some pretty Las Vegas shit.
    ## 304                                                                                                                                                                                                                                                                                                  Fuck. Fuck.
    ## 305                                                                                                                                                                                                                                                                  And he was taking a shit in the auditorium.
    ## 306                                                                                                                                                                                                                                                          Sorry, don't give a shit about the peas in the pod.
    ## 307                                                                                                                                                                                                                                                                               They can fucking deal with it.
    ## 308                                                                                                                                                                                                                                                                      Why didn't you stop me, then, you dick?
    ## 309                                                                                                                                                                                                                                                                                          Fucking cling film!
    ## 310                                                                                                                                                                                                                                   And then he just stood there, pissing water into a bath while Rome burned.
    ## 311                                                                                                                                                                                                                                             Even though he got it into a small hole, it was fucking rubbish.
    ## 312                                                                                                                                                                                                                                      Say what you want about Alex Horne, he's on pauses like a fucking puma.
    ## 313                                                                                                                                                                                                                                               They're not an endangered species, they're fucking everywhere.
    ## 314                                                                                                                                                                                                                                                                              Get fucking through it, Stuart!
    ## 315                                                                                                                                                                                                                                                                                                        Fuck.
    ## 316                                                                                                                                                                                                                                  And then you started to get cross and you said, "Get fucking through, Stu!"
    ## 317                                                                                                                                                                                                                                           I wasn't anticipating that the blender would be as shit as it was.
    ## 318                                                                                                                                                                                                                                                                             Bastard. This is the tricky bit.
    ## 319                                                                                                                                                                                                                                                                                 This bag's fucking hopeless.
    ## 320                                                                                                                                                                                                                                                        And of course that's Mel's equivalent of... megacunt.
    ## 321                                                                                                                                                                                                                                                                                                    Megacunt.
    ## 322                                                                                                                                                                                                                                                                                                Oh, bollocks.
    ## 323                                                                                                                                                                                                                                                                                                Oh, bollocks!
    ## 324                                                                                                                                                                                                                                                                                                Oh, bollocks!
    ## 325                                                                                                                                                                                                                                                                                Bollocks. This is horrendous!
    ## 326                                                                                                                                                                                                                                                                              Mind your own fucking business.
    ## 327                                                                                                                                                                                                                                                                Listen, I'm telling you now: you fucked that.
    ## 328                                                                                                                                                                                                                                                                                 I think you're fucked, Noel.
    ## 329                                                                                                                                                                                             And I was gonna put you in second, but now you've got all fuckin' aggy, you can have third. That's how it works!
    ## 330                                                                                                                                                                                                                                                                                     Oh, thank fuck for that.
    ## 331                                                                                                                                                                                                                                                                                                        Shit.
    ## 332                                                                                                                                                                                                                                                                                      Could you see me? Damn.
    ## 333                                                                                                                                                                                                                                   But tigers tend to blend in, they don't wear a fucking yellow boiler suit.
    ## 334                                                                                                                                                                                                               Incredible dialogue between you two, hampered as you were by a seemingly half-pissed skeleton.
    ## 335                                                                                                                                                                                                                                                                                   The old classic dick-hand.
    ## 336                                                                                                                                                                                                                                                                                                     Fuck me!
    ## 337                                                                                                                                                                                                                                                                                                    Bollocks.
    ## 338                                                                                                                                                                                                                                                                              It's just a big fucking banana.
    ## 339                                                                                                                                                                                                                                                                                           You fucking prick.
    ## 340                                                                                                                                                                                                                                                                                            Fucking horrible.
    ## 341                                                                                                                                                                                                                                                                  What fucking Marks & Spencers do you go to?
    ## 342                                                                                                                                                                                                                                                                                        Piece of shit, innit?
    ## 343                                                                                                                                                                                                                                                                                                    Fuck yes.
    ## 344                                                                                                                                                                                                                                                                               I'm going to the fucking yurt.
    ## 345                                                                                                                                                                                                                                                 It was certainly a surprise for the fucking duck, wasn't it?
    ## 346                                                                                                                                                                                                                                                     I mean, this may be pertinent: who the fuck was Morello?
    ## 347                                                                                                                                                                                                                                 We did get Tim Key a marriage licence, so I am... fucking married to a duck.
    ## 348                                                                                                                                                                                                                                            They're married as long he takes the duck to Hawaii and fucks it.
    ## 349                                                                                                                                                                                                                                              But I don't know what fucking size everyone else is gonna draw!
    ## 350                                                                                                                                                                                                                                                                                                        Shit.
    ## 351                                                                                                                                                                                                                                                                         Right, let's smoke these pricks out.
    ## 352                                                                                                                                                                                                                                                          You're like, "I'm gonna have to wank this guy off."
    ## 353                                                                                                                                                                                                                                                                                           Hell of an opener!
    ## 354                                                                                                                                                                                                                                                                           Can you turn your arse towards me?
    ## 355                                                                                                                                                                                                                                           I mean, don't avert your eyes like you're disgusted. Jesus Christ!
    ## 356                                                                                                                                                                                                                                                                           Well, I didn't shit myself, Sally.
    ## 357                                                                                                                                                                                                                                                                                          Didn't have a shit.
    ## 358                                                                                                                                                                                                                                                                                                       Shite.
    ## 359                                                                                                                                                                                                                                                                                               Piss and shit!
    ## 360                                                                                                                                                                                                                                                                                               Oh, you prick!
    ## 361                                                                                                                                                                                                                                                And we've learnt that Mark Watson looks like a fucking heron.
    ## 362                                                                                                                                                                                                                                                                                                Jesus Christ!
    ## 363                                                                                                                                                                                                                                                                                               Shitting piss!
    ## 364                                                                                                                                                                                                                                                                                                     Damn it!
    ## 365                                                                                                                                                                                                                               And she said it had never needed painting since, 'cause it fuckin' burnt down.
    ## 366                                                                                                                                                                                                                                                                                            Shit, it's thick!
    ## 367                                                                                                                                                                                                                                               And my favourite quote of the show so far: "Shit, it's thick!"
    ## 368                                                                                                                                                                              I think there's a bigger issue for us to discuss and that's the fact that the leprechaun appears to be smeared in its own shit.
    ## 369                                                                                                                                                                                                                                                                                           Oh, shit and piss!
    ## 370                                                                                                                                                                                                                                                                                         Absolute horse shit.
    ## 371                                                                                                                                                                                                                                            Jesus Christ! Rainbows have only got one physical characteristic.
    ## 372                                                                                                                                                                                                                                              But I can't prove that leprechauns don't smear shit everywhere.
    ## 373                                                                                                                                                                                                                                                                                                     Damn it!
    ## 374                                                                                                                                                                                                                                                                                           Oh, shit and piss!
    ## 375                                                                                                                                                                                                                                      When you got that grill out, I was like, "This guy's a fuckin' genius."
    ## 376                                                                                                                                                                                                                                            All green apart from one that's yellow, and that's the piss bomb.
    ## 377                                                                                                                                                                                                                                                       Interesting suggestion, have one balloon full of piss?
    ## 378                                                                                                                                                                                                                                       We agreed that Bob was going to gently piss a tiny bit into a balloon.
    ## 379                                                                                                                                                                                                                                                                              That's the one with piss in it!
    ## 380                                                                                                                                                                                                                                                                                      That's the one of piss!
    ## 381                                                                                                                                                                                                                                                                      Presumably, from a piss-drenched woman.
    ## 382                                                                                                                                                                                                                                                                                          Fuckin' hell. Mate!
    ## 383                                                                                                                                                                                                                                                    And, you know, Sally took a faceful of piss for the show.
    ## 384                                                                                                                                                                                                                                                                                                    Oh, shit!
    ## 385                                                                                                                                                                                                                                                There was doubt in my mind 'cause, well, his painting's shit.
    ## 386                                                                                                                                                                                                                                                                                        A big old robot dick.
    ## 387                                                                                                                                                                                                                                                                       From big old robot dicks to the rules.
    ## 388                                                                                                                                                                                                                 So, in summary, Aisling entered the room, she got pissed... and turned the tube upside-down.
    ## 389                                                                                                                                                                                                                                                                                Yeah, let's see these pricks.
    ## 390                                                                                                                                                                                                                                                                                         Ah, Christ on toast.
    ## 391                                                                                                                                                                                                                                                                               Is there clingfilm? Holy shit!
    ## 392                                                                                                                                                                                                                                                               I mean, that must be enough, surely to Christ.
    ## 393                                                                                                                                                                                                                                                                                               Ooh, fuck off!
    ## 394                                                                                                                                                                                                                                                                   That's a shitty moment, for me, wasn't it?
    ## 395                                                                                                                                                                                                                                                                         It was a hell of a performance, Bob.
    ## 396                                                                                                                                                                                                                                                              But was it a hell of a performance timing-wise?
    ## 397                                                                                                                                                                                                                                                                                                  Fuckin'...!
    ## 398                                                                                                                                                                                                                                                                               And I'm a fucking businessman!
    ## 399                                                                                                                                                                                                                                                            Brilliant throwing, too fucked to get on a table.
    ## 400                                                                                                                                                                                                                                                                                                    Oh, shit!
    ## 401                                                                                                                                                                                                                                                 "We're not gonna play another gig." Why not fucking grow up?
    ## 402                                                                                                                                                                                                                                                                                                        Shit!
    ## 403                                                                                                                                                                                                                                                                     If you get that, you got the big fucker.
    ## 404                                                                                                                                                                                                                                                 How much would you give me to take a shit in this right now?
    ## 405                                                                                                                                                                                                                                                               I'll just get him pissed. What about absinthe?
    ## 406                                                                                                                                                                                                                                                                                                        Shit!
    ## 407                                                                                                                                                                                                                          And you know that because of the surprise in Alex's eyes that it wasn't total shit.
    ## 408                                                                                                                                                                                                                                                                                                   Ooh, fuck!
    ## 409                                                                                                                                                                                                                        [Alex] told me behind your back that it tasted, and I quote, "fuck-all like Marmite".
    ## 410                                                                                                                                                                                                                                                                                          I was fuckin' shit.
    ## 411                                                                                                                                                                                                                                                                                         Absolutely fuck-all.
    ## 412                                                                                                                                                                                                                                                                                       What the hell is that?
    ## 413                                                                                                                                                                                                                                  The last thing I said as I left that gig was, "Who loses fucking trousers?"
    ## 414                                                                                                                                                                                                                                  Mark I'm gonna put in last place because, uh, he stole my fucking trousers.
    ## 415                                                                                                                                                                                                                                                                                     Come on, you stony shit!
    ## 416                                                                                                                                                                                                                                                             I mean, Jesus Christ, it's incredible, isn't it?
    ## 417                                                                                                                                                                                                                                                                                               Shit! Really?!
    ## 418                                                                                                                                                                                                                                 You water cooler moment was, well, it was fucking a water cooler, wasn't it?
    ## 419                                                                                                                                                                                                                                            In slow motion, that's one of the shittest things I've ever seen.
    ## 420                                                                                                                                                                                                                                     You know, that was so shit that I think people will be talking about it.
    ## 421                                                                                                                                                                                                                                      So Kumar, through his own shitness, has come second for the first time.
    ## 422                                                                                                                                                                                                                                                                        And yet page 12, "I have a big dick."
    ## 423                                                                                                                                                                                                                                                                             You can kiss my ass, all of you.
    ## 424                                                                                                                                                                                                                                                                           We kept going for so fucking long!
    ## 425                                                                                                                                                                                                                                                                                               Piss and shit!
    ## 426                                                                                                                                                                                                                                                                                                   The fuck?!
    ## 427                                                                                                                                                                                                                                                                                          Oh, you... buggers.
    ## 428                                                                                                                                                                                                                                                      Four and five, but who knows what the fucking truth is?
    ## 429                                                                                                                                                                                                                                                             Considering I don't give a shit about the pig...
    ## 430                                                                                                                                                                                                                                                                         Jesus Christ. We're not your friend.
    ## 431                                                                                                                                                                                                                                                                                                Ow! Oh, fuck!
    ## 432                                                                                                                                                                                                                                                                  You do feel sort of a bit of a prick, yeah.
    ## 433                                                                                                                                                                                                                                             So I posted the fucking pineapple... to Ireland... to my mother.
    ## 434                                                                                                                                                                                                             I sort of admire that you thought, "Fuck it, I'm gonna run at the door, let's see what happens."
    ## 435                                                                                                                                                                                                                                                                                         Oh, you bubbly fuck!
    ## 436                                                                                                                                                                                                                                                             The candle went out 'cause I said "bubbly fuck".
    ## 437                                                                                                                                                                                                                                        It was literally "bubbly fuck" that put the candle out, it's amazing.
    ## 438                                                                                                                                                                                                                                                     That's such a spectacular way to bow out, "bubbly fuck".
    ## 439                                                                                                                                                                                                                       Old "bubbly fuck", I'm tempted to give you more than two points, but I'm not going to.
    ## 440                                                                                                                                                                                                                                                                                                   Fuck that.
    ## 441                                                                                                                                                                                                                                                                                           Oh, shit and piss!
    ## 442                                                                                                                                                                                                                                                             Why have you brought me to this bloody shithole?
    ## 443                                                                                                                                                                                                                                                                                               Oh, fucking...
    ## 444                                                                                                                                                                                                                                                                         Oh, fuck. I never got through there.
    ## 445                                                                                                                                                                                                                                      Right at the end, I went, "Shit, I should have used this as a compass!"
    ## 446                                                                                                                                                                                                                                                                                                    Oh, shit!
    ## 447                                                                                                                                                                                                                                                                                   And Nish went, "Oh, shit!"
    ## 448                                                                                                                                                                                                                                     That was some pretty powerful motivational shit you were shouting there.
    ## 449                                                                                                                                                                                                                                                                                    Oh, they are heavy. Shit!
    ## 450                                                                                                                                                                                                                                                            It's not me being a shithouse. I can't get any...
    ## 451                                                                                                                                                                                                                                                                                        I fucking loved that.
    ## 452                                                                                                                                                                                                                                                                          And then you're forced to eat shit.
    ## 453                                                                                                                                                                                                                                                                                     In the form of dog shit.
    ## 454                                                                                                                                                                                                                                                                        "From this other bitch I was seeing."
    ## 455                                                                                                                                                                                                                                                                                                    Fuck off!
    ## 456                                                                                                                                                                                                                                                                    Damn you! Damn you, I'll see you in Hell!
    ## 457                                                                                                                                                                                                                                                Why can't I get the coat hanger on there? Come on, you prick!
    ## 458                                                                                                                                                                                                                                                                                          Come on, you prick!
    ## 459                                                                                                                                                                                                                                                                                     You stupid monkey prick!
    ## 460                                                                                                                                                                                                                                                    Aisling was shouting, "Get down there, you monkey prick."
    ## 461                                                                                                                                                                                                                                                                 Le chat il fait mort, et alex c'est un dick.
    ## 462                                                                                                                                                                                                                                            I know, in fact, 'cause it was a hell of a hassle to get it here.
    ## 463                                                                                                                                                                                                                                                                                               Piss and shit!
    ## 464                                                                                                                                                                                                                                                                                 Oh, damn, I've fucked it up!
    ## 465                                                                                                                                                                                                                                                                                               Oh, fuck. Yes.
    ## 466                                                                                                                                                                                                                                                         "Oh, no, I've fucked it!" I think I'm quoting there.
    ## 467                                                                                                                                                                                                                                          As it left your hand, you knew from the swing, "Oh, that's fucked."
    ## 468                                                                                                                                                                                                                                                           I could draw all over your arse, a pastoral scene.
    ## 469                                                                                                                                                                                                                                                                        I've caved his skull in with my arse.
    ## 470                                                                                                                                                                                                                                                                                               Units of piss.
    ## 471                                                                                                                                                                                                                                   Two men are going to explain to me, and rightly so, why my maths are shit.
    ## 472                                                                                                                                                                                                                       If you're thinking of collecting vast amounts of piss, go up to Dumfries and Galloway.
    ## 473                                                                                                                                                                                                                            They're absolutely accurate 'cause I was looking into purchasing gallons of piss.
    ## 474                                                                                                                                                                                                                                                          I thought, "Fuck it, I'll fill his boat with piss."
    ## 475                                                                                                                                                                                                                    So people in Dumfries and Galloway piss about ten times as much as people in East Sussex?
    ## 476                                                                                                                                                                                                              If I have to die and the final thing in my head is the image of Bob Mortimer harvesting piss...
    ## 477                                                                                                                                                                                                                                                              I'm gonna put Bob's piss graph in second place.
    ## 478                                                                                                                                                                                                                                                 I come from near Birmingham and I piss like a big old whale.
    ## 479                                                                                                                                                                                                                                                                          ♪ Rosalind's a fucking nightmare! ♪
    ## 480                                                                                                                                                                                                                         That is one of the bravest lines in rock history, "Rosalind is a fucking nightmare".
    ## 481                                                                                                                                                                                               It also really delighted me hearing a very nice woman have "Rosalind is a fucking nightmare" sung in her face.
    ## 482                                                                                                                                                                                                                                                                                                    Oh, shit!
    ## 483                                                                                                                                                                                                                                                             No, she said, "Greg's gonna fucking murder you."
    ## 484                                                                                                                                                                                                                                   I bought these on my honeymoon, um, at an airpoirt, because I shit myself.
    ## 485                                                                                                                                                                                 It was embarrassing shitting yourself anyway... I went, "'Cause I've shit myself." And then she went to me, "Oh, not again."
    ## 486                                                                                                                                                                                                                                               Next, I'm gonna put a man who did an actual shit in his pants.
    ## 487                                                                                                                                                                                                                                                                       Bit of a shithole, West London, innit?
    ## 488                                                                                                                                                                                                                                      Thank God some other people stepped up and did a really shit job of it.
    ## 489                                                                                                                                                                                                                                                                                       Shit! This won't blow!
    ## 490                                                                                                                                                                                                                                                                                                OK. Oh, shit!
    ## 491                                                                                                                                                                                                                                                                      This is a fucking dyslexic's nightmare.
    ## 492                                                                                                                                                                                                                  What I love about this is, you're all laughing, but someone's gonna lose their fucking job.
    ## 493                                                                                                                                                                                                                                                            But they're just pissing around outside a toilet!
    ## 494                                                                                                                                                                                                                                               200,000 divided by forty equals... well, I don't fucking know.
    ## 495                                                                                                                                                                                                                                                                                          Oh, my fucking god!
    ## 496                                                                                                                                                                                                          Bob, I believe that the first conclusion that Einstein reached was "E equals I don't fucking know".
    ## 497                                                                                                                                                                                                                                                                        Second one's not? Yes, it fucking is.
    ## 498                                                                                                                                                                                                                                                And then you went straight to, "I'm gonna fuck this case up."
    ## 499                                                                                                                                                                                                                                                                                             Je. Sus. Christ.
    ## 500                                                                                                                                                                                                                                                                     Noel Fielding is the fucking mask-maker.
    ## 501                                                                                                                                                                                                                                                                    "I want a palette of jams." Fuckin' hell.
    ## 502                                                                                                                                                                                                                                                                              It was your fucking mask, mate.
    ## 503                                                                                                                                                                                                                                                                                He's got fucking glue on his!
    ## 504                                                                                                                                                                                                                                      Yours looks like a sort of naan matador gone wrong. Fuckin' horrifying!
    ## 505                                                                                                                                                                                                                                                             I'm sprinkling unsalted peanuts. Messy bastards.
    ## 506                                                                                                                                                                                                                                                                                              Fucking... God!
    ## 507                                                                                                                                                                                                                                                 One minute, 45 seconds? This is no good for a mess. Damn it!
    ## 508                                                                                                                                                                                                                                                                                         Shit! Is Alan there?
    ## 509                                                                                                                                                                                                                                                                                                Jesus Christ.
    ## 510                                                                                                                                                    But Jesus Christ, if for the sake of an entertainment show on Dave, Katherine Ryan's prepared to fuck her own family up, she's gonna get the five points.
    ## 511                                                                                                                                                                                                                                                                                         Where is the fucker?
    ## 512                                                                                                                                                                                                                                                  And let's get this on record now, [teachers] know fuck-all.
    ## 513                                                                                                                                                                                                                                                                         Hey, tough shit. I'm the Taskmaster.
    ## 514                                                                                                                                                                                                                                                                                And I have to be... Oh, shit.
    ## 515                                                                                                                                                                                                                                                                          It looks shit, even in slow motion!
    ## 516                                                                                                                                                                                                                                                                                               Oh, it's shit.
    ## 517                                                                                                                                                                                                                                                         Come on, mate. You're making us look like dickheads!
    ## 518                                                                                                                                                                                                                                                                                           Good fucking Lord.
    ## 519                                                                                                                                                                                                                                                                      Dangerous, sexy. The fuckin' lot, that.
    ## 520                                                                                                                                                                                                                                                    We established a baseline with yours. It was shit, right?
    ## 521                                                                                                                                                                                                                                         Or did he come back round, 'cause it was so shit that he actually...
    ## 522                                                                                                                                                                                                                                                                                                        Shit!
    ## 523                                                                                                                                                                                                                                                      You don't mean, like, Psycho kind of... Hitchcock shit.
    ## 524                                                                                                                                                                                                                                                    We've grouped the two younger men together, Russ and Ass.
    ## 525                                                                                                                                                                                                                                                             No, Ass is cool, but only my mates call me that.
    ## 526                                                                                                                                                                                                                                                                     We're mates, but not on a Ass level yet.
    ## 527                                                                                                                                                                                                                                                               Everything's piss-poor. Let's not fuck around.
    ## 528                                                                                                                                                                                                                                                                                                        Shit.
    ## 529                                                                                                                                                                                                                                                                     Yeah, fine. Blood and fucking acid. Ugh.
    ## 530                                                                                                                                                                                                                                                                                                  Shit, ouch.
    ## 531                                                                                                                                                                                                                                                                            Ugh, it stings and fucking hurts.
    ## 532                                                                                                                                                                                                                                                                So... that's why I fucked it up. I'm a lemon.
    ## 533                                                                                                                                                                                                                                                                                            Jesus Christ, no.
    ## 534                                                                                                                                                                                                                                                                                           Couldn't be arsed.
    ## 535                                                                                                                                                                                                                                                                      Fuck it, fine, I'm taking them off too.
    ## 536                                                                                                                                                                                                                                                                                                    Oh, shit!
    ## 537                                                                                                                                                                                                                                                                                                Oh, ah, shit!
    ## 538                                                                                                                                                                                                                                                                                                        Shit.
    ## 539                                                                                                                                                                                                                                                                                  What's that up my arsehole?
    ## 540                                                                                                                                                                                                                                                                                         Oh, for fuck's sake.
    ## 541                                                                                                                                                                                                                                                                                               Shit at darts.
    ## 542                                                                                                                                                                                                                                                                                                    Ah, fuck.
    ## 543                                                                                                                                                                                                                                                                                                  Four. Fuck.
    ## 544                                                                                                                                                                                                                                                                                                   Ugh, fuck.
    ## 545                                                                                                                                                                                                                                                                                        Sixteen. That's shit.
    ## 546                                                                                                                                                                                                                                                                                  And then a ten, and "Fuck!"
    ## 547                                                                                                                                                                                                                                                                                      Fuckin' in for a penny.
    ## 548                                                                                                                                                                                                                                                                            Liza kicked the shit out of hers.
    ## 549                                                                                                                                                                                              He died alone in a bag, you smashed the shit out of him, you brainwashed him in some cult, and you lynched him.
    ## 550                                                                                                                                                                                                                                                             Let's have a look at Asim's, and if it's shit...
    ## 551                                                                                                                                                                                                                                                                       Woo-hoo! There's gonna be hell to pay.
    ## 552                                                                                                                                                                                                                                                                          Fucking... loads of dangerous shit!
    ## 553                                                                                                                                                                                                                   And you're taking directing to a new level as well, by adding "and shit" after everything.
    ## 554                                                                                                                                                                                                                                                                                 I just try my best and shit.
    ## 555                                                                                                                                                                                                                           I love the idea of Spielberg pitching E.T.: "Oh, he's got a long finger and shit."
    ## 556                                                                                                                                                                                                                                                                                                 Fuck's sake.
    ## 557                                                                                                                                                                                                                                                              Because instead of water, they use piss, right?
    ## 558                                                                                                                                                                                                                                               My thing is basically I like to go to, like, museums and shit.
    ## 559                                                                                                                                                                                                                                             And I just took pictures of me doing stupid shit around museums.
    ## 560                                                                                                                                                                                                                                      And you've tried to frill it up by offering "fucking about in museums."
    ## 561                                                                                                                                                                                                                                                                                                   "Asshole."
    ## 562                                                                                                                                                                                                                                                                                                  "Cocknose."
    ## 563                                                                                                                                                                                                                                                                                                  "Dickweed."
    ## 564                                                                                                                                                                                                                                                                                 "Erection, fanny, gobshite."
    ## 565                                                                                                                                                                                                                                                                                                   "Lameass."
    ## 566                                                                                                                                                                                                                                                                                                      "Piss."
    ## 567                                                                                                                                                                                                                                                                                  "Shitbag, twat, underwear."
    ## 568                                                                                                                                                                                                                                                                                  "Wanker, X-rated, yanking."
    ## 569                                                                                                                                                                                                                                              It's called "Upset Tummy, aka The Shits", based on real events.
    ## 570                                                                                                                                                                                                                                                                    "Vomiting, shitting, from every orifice."
    ## 571                                                                                                                                                                                                                            I believe I'm correct in saying that on that day you did actually have the shits.
    ## 572                                                                                                                                                                                                      I had, yeah. Literally, I had the shits, and I thought, "you know, they say write about what you know".
    ## 573                                                                                                                                                                                                                                                                                 I knew that I had the shits.
    ## 574                                                                                                                                                                                                                                                                Well, you know, I used to rap and shit, so...
    ## 575                                                                                                                                                                                                                                                               I nearly shat myself again then. Fucking hell.
    ## 576                                                                                                                                                                                                                                                                 "'Fuck off!' roared Alex, grabbing the axe."
    ## 577                                                                                                                                                                                                                                                                       I don't know what the hell's going on.
    ## 578                                                                                                                                                                                                                                                                                             Oh, that's shit.
    ## 579                                                                                                                                                                                                                                                                                How the fuck did that happen?
    ## 580                                                                                                                                                                                                                                                                                 Cheers. Ugh, fucking brakes.
    ## 581                                                                                                                                                                                                                                                                          I was fucking knackered after that.
    ## 582                                                                                                                                                                                                                                 This is the weirdest fucking family portrait you will ever see in your life.
    ## 583                                                                                                                                                                                                                                                           An then you buggered a toy lizard... with a drill.
    ## 584                                                                                                                                                                                                                                                                                         Oh, for fuck's sake.
    ## 585                                                                                                                                                                                                                                                             Bollocks! I thought I'd absolutely smashed that.
    ## 586                                                                                                                                                                                                                                                                                               Piece of shit.
    ## 587                                                                                                                                                                                                                                                        Can't beat a genuine and heartfelt "for fuck's sake."
    ## 588                                                                                                                                                                                                                                              No wonder they're always crying, look at this shit they're fed.
    ## 589                                                                                                                                                                                                                                                                        To provide something fucking hideous.
    ## 590                                                                                                                                                                                                                                                                                                        Fuck!
    ## 591                                                                                                                                                                                                                                    I don't think this is unfair to say that Asim has been consistently shit.
    ## 592                                                                                                                                                                                                                                                                                              Son of a bitch!
    ## 593                                                                                                                                                                                                                                                                                                Oh, fuck off.
    ## 594                                                                                                                                                                                                                                                            Jesus Christ, it's like you wanted to lose today.
    ## 595                                                                                                                                                                                                                                                                                            The hell is this?
    ## 596                                                                                                                                                                                                                                                                                                No, fuck you!
    ## 597                                                                                                                                                                                                                                                                    I don't give a shit, just make it silver!
    ## 598                                                                                                                                                                                                                                                                                             Some ghost shit.
    ## 599                                                                                                                                                                                                                         I mean, the manliest thing I can think of is just, like, beating the shit out of it.
    ## 600                                                                                                                                                                                                                                                                                             Hell of a start.
    ## 601                                                                                                                                                                                                                                             But when I talk about my feelings, everyone just takes the piss.
    ## 602                                                                                                                                                                                                                                   So I thought I'd fuckin' do a robot, right? Fuckin', you know what I mean?
    ## 603                                                                                                                                                                                                                                                                                             What the fffuck!
    ## 604                                                                                                                                                                                                                                                                     Till, of course, she FUCKS YOUR BROTHER!
    ## 605                                                                                                                                                                                                                                                                                                      Christ.
    ## 606                                                                                                                                                                                                                        Look, I don't know what the hell that is, but this is not me touching the pint glass.
    ## 607                                                                                                                                                                                                                                                       I don't know. I was just fucking winging it, wasn't I?
    ## 608                                                                                                                                                                                                                                                                                         Oh, for fuck's sake.
    ## 609                                                                                                                                                                                                                                                                                     I'd probably fuck it up.
    ## 610                                                                                                                                                                                                                                                                                                Jesus Christ.
    ## 611                                                                                                                                                                                                                                                                                                 Bloody hell.
    ## 612                                                                                                                                                                                                                                                                                       Only if they're dicks.
    ## 613                                                                                                                                                                                                                               I stopped the clock after their hundredth hop, 'cause I'm not, I'm not a dick.
    ## 614                                                                                                                                                                                                                                                                                         No, we're not dicks.
    ## 615                                                                                                                                                                                                                                                                                          H. Urinating. Piss.
    ## 616                                                                                                                                                                                                                                          Right, so there was about seven minutes of bullshit from these two.
    ## 617                                                                                                                                                                                                                                                                                        "H. Urinating. Piss."
    ## 618                                                                                                                                                                                                                                                                           We won, though, innit? So fuck it.
    ## 619                                                                                                                                                                                                                                                                                               Fuckin' right.
    ## 620                                                                                                                                                                                                                                                                                       One, two, three, fuck!
    ## 621                                                                                                                                                                                                                                                                      One, two, fucking hell. This is tricky.
    ## 622                                                                                                                                                                                                                                                                                                  Argh, shit.
    ## 623                                                                                                                                                                                                                                                                                              Oh, fucking...!
    ## 624                                                                                                                                                                                                                          I mean, I respect you, I think you're extraordinary, but that is a sea of bullshit.
    ## 625                                                                                                                                                                                                                                                                                                Jesus Christ.
    ## 626                                                                                                                                                                                                                                                                                                Jesus Christ.
    ## 627                                                                                                                                                                                                                                                                       Nobody knows what the hell's going on.
    ## 628                                                                                                                                                                                                                                                                       Oh, shit. It's actually blowing it up!
    ## 629                                                                                                                                                                                                                                                                                    Oh, fuck. It's gone down.
    ## 630                                                                                                                                                                                                There must be an Amish bloke out there who has a sex ritual, and I'll be damned if it doesn't look like that.
    ## 631                                                                                                                                                                                                                                                                                             Oh, fuck. Sorry!
    ## 632                                                                                                                                                                                                                                                                  We're gonna piss this. This is a good idea.
    ## 633                                                                                                                                                                                                                                                                                         Ah, fuck! Oh, sorry.
    ## 634                                                                                                                                                                                                                                                            And it was, and I quote, "We're gonna piss this."
    ## 635                                                                                                                                                                                                                                                                      And all they fucking do is repeat shit.
    ## 636                                                                                                                                                                                                                                                                                Just fucking improvised that.
    ## 637                                                                                                                                                                                                                                                                                       Shitloads of balloons.
    ## 638                                                                                                                                                                                                                                                                               Jesus Christ, that was moving.
    ## 639                                                                                                                                                                                                                                                                                             Oh, bloody hell.
    ## 640                                                                                                                                                                                                                                                                                                 Fuck's sake.
    ## 641                                                                                                                                                                                                                                                                                                    Oh, shit.
    ## 642                                                                                                                                                                                                                                                                                             Oh, you shitter.
    ## 643                                                                                                                                                                                                                                                                                             Oh, you bastard.
    ## 644                                                                                                                                                                                                                                                                                             Argh, you PRICK!
    ## 645                                                                                                                                                                                                                                                               I'm just gonna have to Sellotape this bastard.
    ## 646                                                                                                                                                                                                                                                           Not that, mate, for fuck‒these girls are starving.
    ## 647                                                                                                                                                                                                                                                                    The other day, I was scratching my ass...
    ## 648                                                                                                                                                                                                                        Suddenly, I got a text of a photo of me scratching my arse that said, "Busy, are we?"
    ## 649                                                                                                                                                                                                                                                                                                        Fuck.
    ## 650                                                                                                                                                                                                                                                                                                 That's shit.
    ## 651                                                                                                                                                                                                                                                                              I'm not... okay, that's a dick.
    ## 652                                                                                                                                                                                                                                                                         You then announced, "That's a dick."
    ## 653                                                                                                                                                                                                                                                          Now I think that's your version of "that's a dick."
    ## 654                                                                                                                                                                                                                                                                  Touch-wise, is it a dick, is it a trombone?
    ## 655                                                                                                                                                                                                                        As far as I can work out, it's a Pokémon symbol, a pair of glasses, and a pissed E.T.
    ## 656                                                                                                                                                                                                                Possibly Oscar Pistorius, because that could be an Oscar, and you've covered the bra in piss.
    ## 657                                                                                                                                                                                                                                                                                Fucking hell. It's like Jaws.
    ## 658                                                                                                                                                                                                                                                                                 Guppy, kind of... shit fish.
    ## 659                                                                                                                                                                                                                                                                                           Eight-bollock cat.
    ## 660                                                                                                                                                                                                                                                                                           Eight-bollock cat.
    ## 661                                                                                                                                                                                                                                                                                                    Bollocks?
    ## 662                                                                                                                                                                                                                                                                                           Eight-bollocked...
    ## 663                                                                                                                                                                                                                                                                                         Eight-bollocked cat.
    ## 664                                                                                                                                                                                                                     I would have bet my life that you wouldn't have been able to convey eight-bollocked cat.
    ## 665                                                                                                                                                                                                          It was Tim who got that, and you said the word "bollock", and you were so surprised that you swore.
    ## 666                                                                                                                                                                                                                                                                                                  Oh, bugger!
    ## 667                                                                                                                                                                                                                                                                                                  Damn right.
    ## 668                                                                                                                                                                                                                                                                                            Fuck, that's hot.
    ## 669                                                                                                                                                                                                                                                                                                Fucking hell.
    ## 670                                                                                                                                                                                                                                                                                                    Oh, fuck!
    ## 671                                                                                                                                                                                                                                                                                          Oh, fuck off, Alex!
    ## 672                                                                                                                                                                                                                         It'd be a good exclamation. Instead of saying "fuckin' hell", "big-toe bobble hat!".
    ## 673                                                                                                                                                                                                                          Jesus Christ, I don't think I've heard "water boatman" since a 1981 science lesson.
    ## 674                                                                                                                                                                                                                    Yeah, I mean, what I did there was a shit version... of what Tim, Tim did the real thing.
    ## 675                                                                                                                                                                                                                                                                                                    Oh, shit.
    ## 676                                                                                                                                                                                                                                                             Oh, you're a dog person. Shit, I'm a cat person.
    ## 677                                                                                                                                                                                                                                                                                 And we found shit in common.
    ## 678                                                                                                                                                                                                                                                                              Just found some shit in common.
    ## 679                                                                                                                                                                                                                                                                                        Shit in common, yeah.
    ## 680                                                                                                                                                                                                                                                         I'm gonna give him all five points. To hell with it.
    ## 681                                                                                                                                                                                                                                                That sort of bullshit's gonna work on Carol, not on me, mate.
    ## 682                                                                                                                                                                                                                         The first cock and balls recorded is in that place that got covered with... Pompeii.
    ## 683                                                                                                                                                                                                                                            It's easy to forget that, um, you've just drawn a cock and balls.
    ## 684                                                                                                                                                                                                                                           I'm gonna put the cock and balls in second place with four points.
    ## 685                                                                                                                                                                                                                                                                                               Oh, fucking...
    ## 686                                                                                                                                                                                                                                                                                                    Oh, fuck!
    ## 687                                                                                                                                                                                                                                                                                       Fuck. This is bad, eh?
    ## 688                                                                                                                                                                                                                                     Can I ask a question? Has it done a Fruittella shit or is that its tail?
    ## 689                                                                                                                                                                                                                                              My gut feeling, and I could be wrong, is this is gonna be shit.
    ## 690                                                                                                                                                                                                                                                                                                        Fuck!
    ## 691                                                                                                                                                                                                                                                                                              Son of a bitch.
    ## 692                                                                                                                                                                                                                                                                                                        Shit.
    ## 693                                                                                                                                                                                                                                                                    Very American, as well. "Son of a bitch!"
    ## 694                                                                                                                                                                                                                                                I'm officially out of The Bubble Brothers. Ya son of a bitch!
    ## 695                                                                                                                                                                                                                                                                       It's fucking... 'cause you spent ages.
    ## 696                                                                                                                                                                                                                                                                                          God, you fucking...
    ## 697                                                                                                                                                                                                                                                                                  Oh, fucking... Fuck it all.
    ## 698                                                                                                                                                                                                                                                         Just say it, don't sing. Dick! We know it's raining.
    ## 699                                                                                                                                                                                                                                     Tim Vine, right, is a lovely man, wonderful man, but he's fucking weird.
    ## 700                                                                                                                                                                                                                                                        ♪ Happy people in the house, make you do weird shit ♪
    ## 701                                                                                                                                                                                                                                                               Get a bucket, smash it in, do a piss gag. Bam.
    ## 702                                                                                                                                                                                                                                                                         Jesus Christ, I wanna take him home!
    ## 703                                                                                                                                                                                                                                                            I think so, I can't be arsed going down any more.
    ## 704                                                                                                                                                                                                                                                             Fair enough. Can't be arsed to pick up any more.
    ## 705                                                                                                                                                                                                                                                             And then I have to fucking high-five them. What?
    ## 706                                                                                                                                                                                                                                                                                           Oh, shit, my ring.
    ## 707                                                                                                                                                                                                                                                                                              "Shit my ring."
    ## 708                                                                                                                                                                                                                                                                                             Not my arsehole.
    ## 709                                                                                                                                                                                                                                                                                                      Bugger!
    ## 710                                                                                                                                                                                                                                                                                              Shit! Bollocks!
    ## 711                                                                                                                                                                                                                                                                      Bugger it. No wonder they get that one.
    ## 712                                                                                                                                                                                                                                                                                                    Oh, shit.
    ## 713                                                                                                                                                                                                                                                                    ♪ Tall motherfucker with the ivory hair ♪
    ## 714                                                                                                                                                                                                           "The tall motherfucker with the ivory hair," I think is the nicest thing anyone's ever said to me.
    ## 715                                                                                                                                                                                                                                                                       So, if my sister's watching, fuck you.
    ## 716                                                                                                                                                                                                             And then I'm going to ask you to take yourself somewhere private and put your bare arse into it.
    ## 717                                                                                                                                                                                                                                     It might be the only time in your life you put your bare arse in a cake.
    ## 718                                                                                                                                                                                                                                                             Peter, looks like it's fucking true, doesn't it?
    ## 719                                                                                                                                                                                                                                                                                        The goddamn stingers.
    ## 720                                                                                                                                                                             I just wanted to make an homage to one of the greatest Asian entertainers in history, and also you get to see my dick and balls.
    ## 721                                                                                                                                                                                                                                                                                  Oh, shit. That is too high.
    ## 722                                                                                                                                                                                                                                                                                   Back-stabbing little shit.
    ## 723                                                                                                                                                                                Were you also partly thinking, "Everyone's gonna be so focused on my cock and balls, they won't actually see what I'm doing"?
    ## 724                                                                                                                                                                                                                                                                                                    Bollocks!
    ## 725                                                                                                                                                                                                                                                                        That is gonna fucking hurt, isn't it?
    ## 726                                                                                                                                                                                                                                                                                                Jesus Christ.
    ## 727                                                                                                                                                                                                                                                 I also regret saying "oral tradition" while my dick was out.
    ## 728                                                                                                                                                                                                                                                                    No, because it had done some bad... shit.
    ## 729                                                                                                                                                                                                                                                                  That's the task, don't look at Wang's dick?
    ## 730                                                                                                                                                                                                                                  A lovely hug from the ladies, and you exclusively talked about Phil's dick.
    ## 731                                                                                                                                                                                                                                                                                                     Fuck me.
    ## 732                                                                                                                                                                                                                                                                 It's like Michael J. Fox or Jesus H. Christ.
    ## 733                                                                                                                                                                                                                                           Gotta be pleased with that, you being all smartarse with your map.
    ## 734                                                                                                                                                                                                                                                                                                    Fuck off!
    ## 735                                                                                                                                                                                                                                                             They're all quite shit, the prizes, aren't they?
    ## 736                                                                                                                                                                                                                                                                                  Jesus Christ, what's wrong?
    ## 737                                                                                                                                                                                                                                                                       I don't know and I don't fucking know.
    ## 738                                                                                                                                                                                                     "Great, this is an opportunity for me to drop dog shit onto the face of a friend I've had for 15 years."
    ## 739                                                                                                                                                                                                                                                                              Well, you're a very rude prick.
    ## 740                                                                                                                                                                                                                                                                                Phil... I mean, Jesus Christ.
    ## 741                                                                                                                                                                                                                                                                  I'm sorry I didn't shit on your face, Greg.
    ## 742                                                                                                                                                                                                                               My least favourite noise was the sound of dog shit being dropped onto my face.
    ## 743                                                                                                                                                                                                                                                                                                Oh, fuck you.
    ## 744                                                                                                                                                                                                                                                                                                Fucking hell.
    ## 745                                                                                                                                                                                                                                                People say my ADHD makes me shit at problem-solving. No, sir!
    ## 746                                                                                                                                                                                                                                                                                                 Bloody hell.
    ## 747                                                                                                                                                                                                                                                                    Jesus Christ! Can we just get on with it?
    ## 748                                                                                                                                                                                                            Alex gets these few moments to say whatever he wants and this is what he's chosen to fucking say.
    ## 749                                                                                                                                                                                                                                                                                           Jesus Christ, yes!
    ## 750                                                                                                                                                                                                                 I sometimes just don't watch films, like the Matrix, 'cause I can't be fucked to plug it in.
    ## 751                                                                                                                                                                                                                                                Gonna write that quote down. "Can't be fucked to plug it in."
    ## 752                                                                                                                                                                                                                                                      Godliman sums things up again: "Bosh! Can't be fucked!"
    ## 753                                                                                                                                                                                                                                                                               Can't be fucked to plug it in.
    ## 754                                                                                                                                                                                                          It's confusing how you're getting away with using this picture and still getting laughs, you prick.
    ## 755                                                                                                                                                                                                                                                                            Oh, just open the box, you pussy!
    ## 756                                                                                                                                                                                                                                                                            What the hell was that all about?
    ## 757                                                                                                                                                                                                                                              I'm sorry, James, and this isn't because you called me a pussy.
    ## 758                                                                                                                                                                                                                                                                                                Jesus Christ!
    ## 759                                                                                                                                                                                                                                          I wish that prick was electrocuted in the studio if I flicked that.
    ## 760                                                                                                                                                                                                                                                                  Take that, you fizzy fuck, now, aren't you?
    ## 761                                                                                                                                                                                                                                                                                                Fucking hell.
    ## 762                                                                                                                                                                                                                                                         "Did you enjoy that, Kerry?" "No, I fuckin' didn't."
    ## 763                                                                                                                                                                                                                                                                                                Fuckin' hell.
    ## 764                                                                                                                                                                                                                                                   All you've done is shove a bloody Brillo Pad in your tits.
    ## 765                                                                                                                                                                                                                    When Rhod accused you of putting a Brillo Pad on your tits, James Acaster went like this.
    ## 766                                                                                                                                                                                                                                                                   That was mainly 'cause of the word "tits".
    ## 767                                                                                                                                                                                                                                                                                                    Oh, shit!
    ## 768                                                                                                                                                                                                                                                                                 Hot damn! We're in business.
    ## 769                                                                                                                                                                                                                                                                                   Oh! Oh! Not so shit, then.
    ## 770                                                                                                                                                                                                                        I don't think anyone's gonna have a worse gift than literal shit on the toilet paper.
    ## 771                                                                                                                                                                                                                                                                          That was shit... on so many levels.
    ## 772                                                                                                                                                                                                                                                                                         All right, fuck you.
    ## 773                                                                                                                                                                                                                                                                                                 Bloody hell.
    ## 774                                                                                                                                                                                                                                                                                                Jesus Christ!
    ## 775                                                                                                                                                                                                                                                                          At the time, I was shitting myself.
    ## 776                                                                                                                                                                                                                       My heart was genuinely pounding and yet I'm still thinking about how shit Kerry's was.
    ## 777                                                                                                                                                                                                                                       I asked for a fucking hot air balloon and they wouldn't give it to me!
    ## 778                                                                                                                                                                                                                                                                                                 That's shit.
    ## 779                                                                                                                                                                                                                                                                         I mean, Jesus Christ, where do I...?
    ## 780                                                                                                                                                                                                                                                                               Ah, shit! That wasn't too bad!
    ## 781                                                                                                                                                                                                                                                                                          Fuck, look at that!
    ## 782                                                                                                                                                                                                                                                                                     Oh, shit. That was okay.
    ## 783                                                                                                                                                                                                                                                                     "Y'all"? What the hell's happened there?
    ## 784                                                                                                                                                                                                                                                                                    How the hell was it done?
    ## 785                                                                                                                                                                                                                                                                             OK, so we're just dangling shit.
    ## 786                                                                                                                                                                                                                                                                    I'll be watching you like a fucking hawk!
    ## 787                                                                                                                                                                                                                                                                           It's gonna be one hell of a night.
    ## 788                                                                                                                                                                                                                                                                                            Oh, fucking hell.
    ## 789                                                                                                                                                                                                      You think that's going to go up and it's like Bullseye, there's gonna be a fucking camper van up there?
    ## 790                                                                                                                                                                                                                                                                                                    Ya prick.
    ## 791                                                                                                                                                                                                             I'm giving you four points 'cause the pie looks nice, and I can't wait to see this prick eat it.
    ## 792                                                                                                                                                                                                                                                                                       Yeah, we fucking have!
    ## 793                                                                                                                                                                                                                                              Oh, shit! I should've gone for something more varied than this.
    ## 794                                                                                                                                                                                                                                                                                         Arms I forgot. Shit!
    ## 795                                                                                                                                                                                                                                                                      What the hell's that oblong on my face?
    ## 796                                                                                                                                                                                                                                                                      That's shit. That's really bad. Please.
    ## 797                                                                                                                                                                                                                                                          But Jesus Christ, if I could give you ten, I would.
    ## 798                                                                                                                                                                                                                                                    "Right, I see what we're doin'. Fuck, let's do it. Bosh!"
    ## 799                                                                                                                                                                                                                                                                   That is a goddamn miracle that I did that.
    ## 800                                                                                                                                                                                                                                           "How do you want me to transport the rest?" I'd go, "Up your ass."
    ## 801                                                                                                                                                                                                                                                                  "Try not to break 'em. Smallest arse wins."
    ## 802                                                                                                                                                                                                                                                                                                 Such a dick!
    ## 803                                                                                                                                                                                                                                                                           No, pass it up, you fucking idiot!
    ## 804                                                                                                                                                                                                                                                        Okay, I see where you're coming from. That it's shit.
    ## 805                                                                                                                                                                                                                                                             The glove puppets were my sister's, so fuck you.
    ## 806                                                                                                                                                                                                            Well, I think that "fuck you" should be directed at your mother, because she said you'd say that.
    ## 807                                                                                                                                                                                                                                          It seems they're just an old pair of glasses and a lot of bullshit.
    ## 808                                                                                                                                                                                                                                                                                These three, absolutely shit.
    ## 809                                                                                                                                                                                                                                                                                                    Hot damn!
    ## 810                                                                                                                                                                                                                                                                                                 Bloody hell.
    ## 811                                                                                                                                                                                                                                                                               I mean, this is fucking agony.
    ## 812                                                                                                                                                                                                                                                                     He named me foreman and then fucked off.
    ## 813                                                                                                                                                                                                                            And then just kind of looked at us like, "What the fuck you gonna do about that?"
    ## 814                                                                                                                                                                                                                              I didn't know he'd also gone, "Oh, the perfect stuff." And then done that shit!
    ## 815                                                                                                                                                                                                                                                                                                   Holy shit!
    ## 816                                                                                                                                                                                                                                                                                                        Shit.
    ## 817                                                                                                                                                                                                                                                                                                Jesus Christ!
    ## 818                                                                                                                                                                                                                                                                                                Fucking hell.
    ## 819                                                                                                                                                                                                                                     And good luck to Kettering. If that's the best you've got, Jesus Christ!
    ## 820                                                                                                                                                                                                                                                           Well, you can't compete with Alex's arse, can you?
    ## 821                                                                                                                                                                                                                                                                          It wasn't just Alex's arse, was it?
    ## 822                                                                                                                                                                                                                                                                   No. Oh, no, you were both absolutely shit.
    ## 823                                                                                                                                                                                                                                                                                                    Bollocks.
    ## 824                                                                                                                                                                                                                                                          Oh, yes! Played into my hands here, mate. Fuck you.
    ## 825                                                                                                                                                                                                                                               Another one of your catchphrases coming out there: "Fuck you."
    ## 826                                                                                                                                                                                                                                                                  "Fuck you." "Babay." "I'm punk." "Suck it."
    ## 827                                                                                                                                                                                                                                                                                      What the fuck was that?
    ## 828                                                                                                                                                                                                                                                                                         Fucking "diddly-do".
    ## 829                                                                                                                                                                                                                                                              Whizzes round and shoots her shitting face off!
    ## 830                                                                                                                                                                                                                            Be careful who you're charitable to or you might get your shitting face shot off.
    ## 831                                                                                                                                                                                                                                                         There better be a hell of a punchline to this story.
    ## 832                                                                                                                                                                                                                                                 Off the top of my head, I've got witch's tits and two dicks.
    ## 833                                                                                                                                                                                                                                                You've had your money's worth out of that picture, you prick!
    ## 834                                                                                                                                                                                                                                                           I'm vaguely intrigued by the whole two-dick thing.
    ## 835                                                                                                                                                                                                                    You just brought a pile of sand in and then tried some sort of microscope bullshit on us.
    ## 836                                                                                                                                                                                                                                                                              That can fuck off, for a start.
    ## 837                                                                                                                                                                                                                                                                              Pissing little slotty red shit.
    ## 838                                                                                                                                                                                                                                                                God, how do you get into a fucking swear box?
    ## 839                                                                                                                                                                                                                                                                                            Oh, fucking hell!
    ## 840                                                                                                                                                                                                                                                                                      Oh, shit! Rhod Gilbert.
    ## 841                                                                                                                                                                                                                                                                                                  Hula. Fuck.
    ## 842                                                                                                                                                                                                                                                                  Ah, Jesus Christ! You traitorous old woman!
    ## 843                                                                                                                                                                                                                                                                                                Jesus Christ!
    ## 844                                                                                                                                                                                                                                                                        Ho ho! That's a goddamn snooker ball!
    ## 845                                                                                                                                                                                                                                      It's always scary when you leave Rhod till last. He does... crazy shit.
    ## 846                                                                                                                                                                                                                                              Funny who you're prepared to bend for, isn't it, you fucking...
    ## 847                                                                                                                                                                                                                                                                 Do you know what? I can't believe this shit!
    ## 848                                                                                                                                                                                                                                                 And you got two points for that hula-hoop bullshit up there.
    ## 849                                                                                                                                                                                                                                       Yeah, well, now you can back into a satsuma and shove it up your arse.
    ## 850                                                                                                                                                                                                                                                                                    Because of all this shit.
    ## 851                                                                                                                                                                                                                                                               We have to measure the six foot fucking eight.
    ## 852                                                                                                                                                                                                                                                                                                    Oh, fuck!
    ## 853                                                                                                                                                                                                                                             And this is the greatest opening to any sport: "One, two, fuck."
    ## 854                                                                                                                                                                                                                                                                  Um, I'm gonna give one point to this prick.
    ## 855                                                                                                                                                                                                                                                                               Yeah, I'm not a fucking idiot.
    ## 856                                                                                                                                                                                                                                                            What are you, some sort of fuckin' egg whisperer?
    ## 857                                                                                                                                                                                                                                                                            It's made of rubber or some shit.
    ## 858                                                                                                                                                                                                                                                                                          You, sir, are shit.
    ## 859                                                                                                                                                                                                                                                                    As a spectacle, Jesus Christ, incredible.
    ## 860                                                                                                                                                                                                                    This is gonna be the worst one ever to judge. Let's hope that James's is absolutely shit.
    ## 861                                                                                                                                                                                                                                                                                                    Fuck you!
    ## 862                                                                                                                                                                                                                                                                                                    Fuck you!
    ## 863                                                                                                                                                                                                                                                                             Where's the goddamn end of this?
    ## 864                                                                                                                                                                                                                                                                                                    Oh, shit!
    ## 865                                                                                                                                                                                                                                                       You piece of shit, Alex! This is the worst one so far.
    ## 866                                                                                                                                                                                                                                                                                              Fuck you, argh.
    ## 867                                                                                                                                                                                                                                                                                           Fucking arseholes!
    ## 868                                                                                                                                                                                                                                                                                              Oh, goddamn it!
    ## 869                                                                                                                                                                                                                                                                                       I'm really pissed off.
    ## 870                                                                                                                                                                                                                      For once, being really shit at one task automatically made me suddenly good at another.
    ## 871                                                                                                                                                                                                                                                                                No, that was fucking kickass.
    ## 872                                                                                                                                                                                                                                                          We'd love to hate that, but that was fucking great.
    ## 873                                                                                                                                                                                                                                                                       Ooh! Sneaky little fucker, aren't you?
    ## 874                                                                                                                                                                                                                                                                                                    Fuck off!
    ## 875                                                                                                                                                                                                                                                                         Four sluts, that's what I'm hearing!
    ## 876                                                                                                                                                                                                                                                              I'm known for looking like a twat on The Chase.
    ## 877                                                                                                                                                                                                                                                                          I don't think you look like a twat.
    ## 878                                                                                                                                                                                                                                                                                                        Shit!
    ## 879                                                                                                                                                                                                                                                                                                        Fuck!
    ## 880                                                                                                                                                                                                                                                                                       Oh, I am shit at this!
    ## 881                                                                                                                                                                                                                                                                                        Down, up... Oh, shit.
    ## 882                                                                                                                                                                                                                                                                         I don't know what the hell that was.
    ## 883                                                                                                                                                                                                It's a lovely reminder of childhood, listening to crackly radio while you snuggle up to your mum's feet-tits.
    ## 884                                                                                                                                                                                                                              Then, obviously, Liphook's shit. That gets two points, it doesn't deserve them.
    ## 885                                                                                                                                                                                                                                                                                                    Ah, shit.
    ## 886                                                                                                                                                                                                                                                                 I mean, what the hell? What were you doing?!
    ## 887                                                                                                                                                                                                                                                                                                     Fuck it.
    ## 888                                                                                                                                                                                                                                                             It's honestly... just dehumanising. Bloody hell.
    ## 889                                                                                                                                                                                                                                                      What have you got, Sian, because that's obviously shit!
    ## 890                                                                                                                                                                                                                             with three points, I'm going to give the hot, thin, high stream of piss volcano.
    ## 891                                                                                                                                                                                                                                                                                                 Skirt? Fuck!
    ## 892                                                                                                                                                                                                                                                                                                     Damn it!
    ## 893                                                                                                                                                                                                                      You can't go on any quiz show ever because you give an answer, and then you go, "Fuck!"
    ## 894                                                                                                                                                                                                                                                                                          ♪ Fuck off, Alex. ♪
    ## 895                                                                                                                                                                                                                                                                     I got your car, I threw some shit on it.
    ## 896                                                                                                                                                                                                                                           It's a piece of shit! This piece of shit! This piece of shit, ugh!
    ## 897                                                                                                                                                                                                                                                                                               Oh, fuck, yes!
    ## 898                                                                                                                                                                                      I said I'll only mention my injured shoulder when my injured shoulder is actually fucking affecting how I'm performing.
    ## 899                                                                                                                                                                                                                                                                    Iain's already got the doctor shit-faced.
    ## 900                                                                                                                                                                                                                                                     In the one clip we saw, you did look maybe a bit pissed.
    ## 901                                                                                                                                                                                                                               So far it looks like the first bit of a really shit Olympics Opening Ceremony.
    ## 902                                                                                                                                                                                                                                                           That's what... Fuck, I mean, that's made it worse!
    ## 903                                                                                                                                                                                                                                                                                  This is a fucking disaster.
    ## 904                                                                                                                                                                                                                                                                                             Oh, you... shit!
    ## 905                                                                                                                                                                                                                                                "You may not leave the room." Fuck it, let's do that as well.
    ## 906                                                                                                                                                                                                    I'm thinking as long as I get sand into the bucket then at least some fuckwit's gonna disqualify himself.
    ## 907                                                                                                                                                                                                                                                                                                    Oh, shit.
    ## 908                                                                                                                                                                                                                                                                                                  Oh, Christ.
    ## 909                                                                                                                                                                                                                                                                                                Jesus Christ!
    ## 910                                                                                                                                                                                                                            I don't mind a window. I think that's your strongest effort so far. Jesus Christ!
    ## 911                                                                                                                                                                                                                                                                              He brought in a fucking window!
    ## 912                                                                                                                                                                                                                                                                                             Fucking the man!
    ## 913                                                                                                                                                                                                                                                                                I wanted a goddamn pen, Greg.
    ## 914                                                                                                                                                                                                                                                                              Look, you fucking did! You did!
    ## 915                                                                                                                                                                                                                                                                                               Piece of piss.
    ## 916                                                                                                                                                                                                                            I'm an absolute dickhead at every other task. That one should be in my territory.
    ## 917                                                                                                                                                                                                                                                                           Flippin' hell, you didn't tell me!
    ## 918                                                                                                                                                                                                                                                                                          Fuckin' hell, Alex.
    ## 919                                                                                                                                                                                                                                                                                                        Fuck.
    ## 920                                                                                                                                                                                                                                                                                             For fuck's sake!
    ## 921                                                                                                                                                                                                                                                                                                     Fuck it.
    ## 922                                                                                                                                                                                                                                                                                                     Damn it!
    ## 923                                                                                                                                                                                   The temptation is to assume that the others will go hell for leather trying to accumulate as many Pink Ladies as possible.
    ## 924                                                                                                                                                                                                                                                                                                Fucking hell.
    ## 925                                                                                                                                                                                                                                     Only I, right, only I can donate to charity and make it look... dickish.
    ## 926                                                                                                                                                                                                                                                                                   You're full of horse shit.
    ## 927                                                                                                                                                                                                                                                   Sorry, sorry. Lou's just saying you're full of horse shit.
    ## 928                                                                                                                                                                                                                                        I don't know if it's shit or good. I don't know if it's shit or good.
    ## 929                                                                                                                                                                                                                                I had no idea until I did Taskmaster that I was actually as thick as pigshit.
    ## 930                                                                                                                                                                                                       It's like a sort of metaphor for just life and the future, isn't it? Could be different, but all shit.
    ## 931                                                                                                                                                                                                    Nice that in this episode Joe finally works out that this entire show is a metaphor for how shit life is.
    ## 932                                                                                                                                                                                                                                                           Not going to bugger it up any more than I have to.
    ## 933                                                                                                                                                                                                                                                                                                      Christ!
    ## 934                                                                                                                                                                                                                                                                                                It's so shit!
    ## 935                                                                                                                                                                                                                                                           Fuck off! Honestly, I can't actually believe this.
    ## 936                                                                                                                                                                                                                                                                                        The clothing is shit.
    ## 937                                                                                                                                                                                                                                                                                                        Shit!
    ## 938                                                                                                                                                                                                                                                                                        Shit. Yellow, yellow!
    ## 939                                                                                                                                                                                                                                                                   Quick, catch something, for Christ's sake!
    ## 940                                                                                                                                                                                                                                                                                               What the fuck!
    ## 941                                                                                                                                                                                                                  Another "Mummy" followed by, erm, making it look like you've got a big dick between your...
    ## 942                                                                                                                                                                                                                                                                                                 Oh, fuck me!
    ## 943                                                                                                                                                                                                                                                                                                Oh, Christ...
    ## 944                                                                                                                                                                                                                             Number three, it protects you from having children because no one will fuck you.
    ## 945                                                                                                                                                                                                                                                                                                Jesus Christ.
    ## 946                                                                                                                                                                                                                                                                                       Oh, come on, you dick!
    ## 947                                                                                                                                                                                                                     Iain has often been the person who's gone, "Right, I'm going in. Let's fuckin' do this!"
    ## 948                                                                                                                                                                                                                                                                                   Thank you. Oh, shit, uh...
    ## 949                                                                                                                                                                                                                                                                         Shit, we threw the banana skin away.
    ## 950                                                                                                                                                                                                                                                                                  It was in the goddamn task!
    ## 951                                                                                                                                                                                                                                          I mean, the other team‒it looked like the end of the fucking world.
    ## 952                                                                                                                                                                                                                                            At one point, she shouted, "Get up my arse and wriggle!" to Paul.
    ## 953                                                                                                                                                                                                                        If you saw that in a cathedral in sort of southern Spain, you'd think, "Bloody hell."
    ## 954                                                                                                                                                                                                                                                                                                     Damn it!
    ## 955                                                                                                                                                                                                                                          Wait till you get your knees up, you will eliminate that next shit.
    ## 956                                                                                                                                                                                                                                                                          Where the fuck has this come from?!
    ## 957                                                                                                                                         I'm so fed up of putting in, like, loads and loads of just genuinely, like, physical effort into the tasks and then these other people find some s‒wanky workaround.
    ## 958                                                                                                                                                                                                                                                                                  Put some fucking effort in!
    ## 959                                                                                                                                                                                                                                                                                                  Oh, Christ.
    ## 960                                                                                                                                                                                                                                                                                                        Shit!
    ## 961                                                                                                                                                                                                                                                                                     Fuck! Come on. Fuck you!
    ## 962                                                                                                                                                                                                                                                                        I hated every fucking second of that.
    ## 963                                                                                                                                                                                                                                 I've got an injured shoulder and, more than that, I am an absolute dickhead.
    ## 964                                                                                                                                                                                                                                                                      That's not fair, you're not a dickhead.
    ## 965                                                                                                                                                                                                                                                                        Fuckin' hell! Was that the mannequin?
    ## 966                                                                                                                                                                                                                                                 But somehow or another I just fucked it up from the word go.
    ## 967                                                                                                                                                                                                                                                                                                Jesus Christ!
    ## 968                                                                                                                                                                                                                                                                                Fuck off! Fuck off! Fuck off!
    ## 969                                                                                                                                                                                                                                                                   It’s stressful when you’ve had a big shit.
    ## 970                                                                                                                                                                                                                                                                                         Oh, for fuck’s sake.
    ## 971                                                                                                                                                                                                                            Then, half an aubergine in, you went, "Oh, fuck this, they’re going in my pants."
    ## 972                                                                                                                                                                                                                                                                                                  Oh, Christ.
    ## 973                                                                                                                                                                                                             Oh, fuck it, I’m going to accuse this of being a dodo 'cause I can't be arsed to go any further.
    ## 974                                                                                                                                                                                                                                                                                                Oh, bollocks.
    ## 975                                                                                                                                                                                                                                                                   Fuck that. That’s lavender. That's violet.
    ## 976                                                                                                                                                                                                                                                                That just tastes of... what the fuck is that?
    ## 977                                                                                                                                                                                                                                                                                                   Fuck. Off.
    ## 978                                                                                                                                                                                                                                                                                   Do they all taste of shit?
    ## 979                                                                                                                                                                                                                                                                                                    Fuck off!
    ## 980                                                                                                                                                                                                                                                                        Sounds like absolute horseshit to me.
    ## 981                                                                                                                                                                                                                                             I wasn't expecting the bush woman; it scared the shit out of me.
    ## 982                                                                                                                                                                                                                                                                                   Oh, have I fucked this up?
    ## 983                                                                                                                                                                                                                                                                              I’ve finished me fucking snake!
    ## 984                                                                                                                                                                            And to my left, a man who Tina Turner once described as simply the best. And, in a separate conversation, as a complete arsehole.
    ## 985                                                                                                                                                                                                                                                               Yeah but that's not the bag, the bag was shit.
    ## 986                                                                                                                                                                                                                                                                                                     Damn it.
    ## 987                                                                                                                                                                                                                                                                                                        Fuck.
    ## 988                                                                                                                                                                                                                                                      Is this going to be some kind of Sudoku-style bollocks?
    ## 989                                                                                                                                                                                                                                                 Three's gotta be upside down. This is a mind-fuck, actually.
    ## 990                                                                                                                                                                                                                                                                       This is gonna look absolutely dogshit.
    ## 991                                                                                                                                                                                                                                                                                         Tiny bit of bollock.
    ## 992                                                                                                                                                                                                                                                                        That is some kind of Sudoku bullshit.
    ## 993                                                                                                                                                                                                       And he says normal person but just below the lip, right in the middle, that's a little bit of bollock.
    ## 994                                                                                                                                                                                                                                                                    David, why the fuck are you talking now?!
    ## 995                                                                                                                                                                                                                                                                          Guantanamo Bay. Oh, G, sorry. Shit.
    ## 996                                                                                                                                                                                                     We're essentially watching The Real Marigold Hotel up there, when you've stopped for a fucking sandwich!
    ## 997                                                                                                                                                                                                                                                                       It told us to make a fucking sandwich.
    ## 998                                                                                                                                                                                                                                      I did know we were doing it against the clock and I didn't give a fuck!
    ## 999                                                                                                                                                                                                                                                                                        Oh, you motherfucker.
    ## 1000                                                                                                                                                                                                                                                                            It's absolutely shit, well done.
    ## 1001                                                                                                                                                                                                                                                                                 It's absolutely shit, Ivor!
    ## 1002                                                                                                                                                                                                                                                                                               It's so shit.
    ## 1003                                                                                                                                                                                                                                                                                     The stick and the dick?
    ## 1004                                                                                                                                                                                                                                                                                     The stick and the dick.
    ## 1005                                                                                                                                                                                                                                               As so often in life I do, I'm gonna put dick in second place.
    ## 1006                                                                                                                                                                                                                                                                                           Oh, fucking hell.
    ## 1007                                                                                                                                                                                                                                                                         And Jo simply couldn't give a fuck.
    ## 1008                                                                                                                                                                                                                                                                              Whaaa! No, I'm such a dumbass.
    ## 1009                                                                                                                                                                                                                                                                           Oh no, it's on the fucking thing.
    ## 1010                                                                                                                                                                                                                                                                          No! I nailed it to the damn table!
    ## 1011                                                                                                                                                                                                                                                                         Rose, what the fuck was your thing?
    ## 1012                                                                                                                                                                                                                                                                        I had a fucking horrible time on it.
    ## 1013                                                                                                                                                                                                                                                                                        Fuck. How'd that go?
    ## 1014                                                                                                                                                                                                                                                  Why have you done it like this, Ed, you absolute arsehole.
    ## 1015                                                                                                                                                                                                                                                             Okay, I don't know where to fucking start here.
    ## 1016                                                                                                                                                                                                                          Yeah, and didn't fucking eat it. Just got on with it, like a quiet, nerdy fuckwit.
    ## 1017                                                                                                                                                                                                                                                                                               Jesus Christ.
    ## 1018                                                                                                                                                                                                                                                It just says Broad Arse now. Do you want a Broad Arse Award?
    ## 1019                                                                                                                                                                                                                                                                                 What do you mean? Oh, shit.
    ## 1020                                                                                                                                                                                                                                                                                           Can I piss in it?
    ## 1021                                                                                                                                                                                                                                                  That wouldn't be water, David, would it? It would be piss.
    ## 1022                                                                                                                                                                                                                                                                                                       Shit!
    ## 1023                                                                                                                                                                                                                                                                               Whaaa! That was fucking sand!
    ## 1024                                                                                                                                                                                                                                                         Why am I opening a fucking library all of a sudden?
    ## 1025                                                                                                                                                                                                                                                                                                       Shit.
    ## 1026                                                                                                                                                                                                                 I've got three sensitivity levels. And I'll be honest, I'm on my top fucking one right now!
    ## 1027                                                                                                                                                                                                                                                                    That was a mistake, wasn't it? Bollocks.
    ## 1028                                                                                                                                                                                                                                                                                          It's a tube, fuck.
    ## 1029                                                                                                                                                                                                                                                                            Drink receptacles, my sweet ass.
    ## 1030                                                                                                                                                                                                                                                                                   Fuck it, I call 'em cups.
    ## 1031                                                                                                                                                                                                                                                                                          Absolute bullshit.
    ## 1032                                                                                                                                                                                                                                                                                         Ughhh, God damn it.
    ## 1033                                                                                                                                                                                                                                                                                       Could not be shitter.
    ## 1034                                                                                                                                                                                                                            Yeah, because I like my sweeties with a thin coating of multiple layers of piss.
    ## 1035                                                                                                                                                                                                                                                            Who's pissing in the pick 'n' mix in your house?
    ## 1036                                                                                                                                                                                                                            They did a test, didn't they, on mints. There was 400 types of piss on the mint.
    ## 1037                                                                                                                                                                                                                                                           I didn't know there were that many types of piss.
    ## 1038                                                                                                                                                                                                                                                            Or do you, like, do this? That was a shit laugh.
    ## 1039                                                                                                                                                                                                                                                                                                God damn it.
    ## 1040                                                                                                                                                                                                                                                     Turns out I am shit at lasso. Don't look at your watch!
    ## 1041                                                                                                                                                                                                                                                         Oh bollocks, right, that's alright, that's alright.
    ## 1042                                                                                                                                                                                                                                                                                                   Oh, fuck!
    ## 1043                                                                                                                                                                                                                                                                                                   Bollocks.
    ## 1044                                                                                                                                                                                                                                                   Well, that's not very nice, I didn't fucking torture you.
    ## 1045                                                                                                                                                                                                                                                                                  Oh, it's Taskmaster, shit.
    ## 1046                                                                                                                                                                                                         I didn't, but I've learned a hell of a lot more in life than I would've ever learned at university.
    ## 1047                                                                                                                                                                                                             I thought I was gonna come here and someone was gonna ask me if I'd ever been to fucking Penge.
    ## 1048                                                                                                                                                                                                               You didn't have a system because you just walked in, didn't give a fuck, and then left again!
    ## 1049                                                                                                                                                                                                                                                                                          Fuck you, Matafeo!
    ## 1050                                                                                                                                                                                                                                                                You know why, because I fucking hate fields.
    ## 1051                                                                                                                                                                                                                                                        I'm just gonna say the words 'my cock', and move on.
    ## 1052                                                                                                                                                                                                                                                                    I wanna find out if he went cock or not.
    ## 1053                                                                                                                                                                                                         Love that your first thought was cock, you made a cock, and at the last second put it on your head.
    ## 1054                                                                                                                                                                                                    You did say at the time, the wig was the dog's bollocks. You kept saying "the wig's the dog's bollocks".
    ## 1055                                                                                                                                                                                                                                                                                             Bollocks, Alex.
    ## 1056                                                                                                                                                                                                                                                                                             Well, fuck off.
    ## 1057                                                                                                                                                                                                                                                                                               Jesus Christ.
    ## 1058                                                                                                                                                                                                                                                                                       Stop taking the piss.
    ## 1059                                                                                                                                                                                                                                                                                                 Fuck! Shit!
    ## 1060                                                                                                                                                                                                                                                                                  I didn't even need a shit.
    ## 1061                                                                                                                                                                                                      I believe there used to be, like, Henry VIII used to have a bloke who actually wiped his arse for him.
    ## 1062                                                                                                                                                                                                                                          Uhh, Henry VIII had a person who wiped his arse for him, yes, yes.
    ## 1063                                                                                                                                                                                                                     I'll show you where she keeps it, she keeps it in the shittest room in the whole house.
    ## 1064                                                                                                                                                                                                                                                           Yeah, but it looks like she wouldn't give a shit.
    ## 1065                                                                                                                                                                                                                                                                                               Jesus Christ.
    ## 1066                                                                                                                                                                                                                                                                                 Oh, fuck it, I wish it was.
    ## 1067                                                                                                                                                                                                                                I find this incredible, that I'm giving five points to a piece of shit roll.
    ## 1068                                                                                                                                                                                                                                                                                Are you fucking shitting me?
    ## 1069                                                                                                                                                                                                                                                          ♪ Why didn't you do this first, you stupid twat? ♪
    ## 1070                                                                                                                                                                                                                                                                                               Fucking hell!
    ## 1071                                                                                                                                                                                                                                                                                                   Bollocks.
    ## 1072                                                                                                                                                                                                                                                                        I'm gonna stick to my guns, fuck it.
    ## 1073                                                                                                                                                                                                                                                            Well there you are, I liberated the fucking egg!
    ## 1074                                                                                                                                                                                                                            I have a lot of joy in my life, just not standing on a bit of fucking wasteland.
    ## 1075                                                                                                                                                                                                                                                         I think possibly I'm going to make this quite shit.
    ## 1076                                                                                                                                                                                                                                                              That's what fucking Mount Rushmore looks like.
    ## 1077                                                                                                                                                                                                                                                                                                       Shit!
    ## 1078                                                                                                                                                                                                                                                               Oh, God. I've made the nose look like a dick.
    ## 1079                                                                                                                                                                                                                                                                It is shit in context, though, Jo, isn't it?
    ## 1080                                                                                                                                                                                                                                                     I don't want your fucking pity point! Piss off with it.
    ## 1081                                                                                                                                                                                                                                                   Well, you're fuckin' havin' it. You're fuckin' havin' it.
    ## 1082                                                                                                                                                                                                                                                                                                   Piss off!
    ## 1083                                                                                                                                                                                                                                                                                     Fuck, that really hurt.
    ## 1084                                                                                                                                                                                                                                                                                           Ah fuck, come on.
    ## 1085                                                                                                                                                                                                                                                                                                       Fuck!
    ## 1086                                                                                                                                                                                                                                                        God damn it, I hate you so much. I hate you so much!
    ## 1087                                                                                                                                                                                                                                                                                                       Shit!
    ## 1088                                                                                                                                                                                                                                                                        Piece of piss, ladies and gentlemen.
    ## 1089                                                                                                                                                                                                                                                                                         Just having a shit.
    ## 1090                                                                                                                                                                                                                                                                                               Jesus Christ.
    ## 1091                                                                                                                                                                                                                                                      So he's having to transport his cock in a wheelbarrow?
    ## 1092                                                                                                                                                                                                                                                                          Tiny gnome, big dick, four points.
    ## 1093                                                                                                                                                                                                                                        But then again, I'm quite lazy so I can't be arsed to walk very far.
    ## 1094                                                                                                                                                                                                                                                                             Oh bollocks, that was terrible.
    ## 1095                                                                                                                                                                                                                                                                                               Oh. Bollocks.
    ## 1096                                                                                                                                                                                                                                         ♪ Alex is great, Greg is a twat. Alex is thin, Greg's really fat. ♪
    ## 1097                                                                                                                                                                                                                                                                                                Just a twat.
    ## 1098                                                                                                                                                                                                                                                             Yeah, it was "twat" that came first, wasn't it?
    ## 1099                                                                                                                                                                                                                                                                                          Just, just a twat.
    ## 1100                                                                                                                                                                                                                                                                                               Jesus Christ.
    ## 1101                                                                                                                                                                                                                                                                       I don't understand all this bollocks.
    ## 1102                                                                                                                                                                                                                                                                                       Are you shitting me?!
    ## 1103                                                                                                                                                                                                                                                                                        Oh, for fuck's sake!
    ## 1104                                                                                                                                                                                                                                                                     Why won't my earring work? Oh, fuck it.
    ## 1105                                                                                                                                                                                                                                                                                                   Fuck off!
    ## 1106                                                                                                                                                                                                                                                                                            Yeah, fuck that.
    ## 1107                                                                                                                                                                                                       I'll tell you what would be nice, maybe some tissues to clean off all the fucking blood off my knees.
    ## 1108                                                                                                                                                                                                                                                                                               Jesus Christ.
    ## 1109                                                                                                                                                                                                                                                                        What the living fuck have you done?!
    ## 1110                                                                                                                                                                                                                                                                                           David, you prick!
    ## 1111                                                                                                                                                                                                                                                                                                 Fuck knows.
    ## 1112                                                                                                                                                                                                                                                                                               Jesus Christ.
    ## 1113                                                                                                                                                                                                                                          And obviously the first thing I think is to shove this up my arse.
    ## 1114                                                                                                                                                                                                                               Here I am trying to think of the second thin I can do. Balance it on my cock.
    ## 1115                                                                                                                                                                                                                                                                                               Jesus Christ.
    ## 1116                                                                                                                                                                                                                                                                  I knew I should have shoved it up my arse.
    ## 1117                                                                                                                                                                                                                                                                   Oh bollocks, my chickpea's disintegrated.
    ## 1118                                                                                                                                                                                                                                                             Balance it on your dick, stick it up your arse.
    ## 1119                                                                                                                                                                                                                                                             These are my dicks and I balanced them on them.
    ## 1120                                                                                                                                                                                                            It's so preposterous because during it I genuinely found myself grieving for a fucking chickpea.
    ## 1121                                                                                                                                                                                                                                How do you feel that ten minutes later I dug that chickpea up and fucked it?
    ## 1122                                                                                                                                                                                                                    Anyone who subsequently exhumes that corpse and fucks it gets four sweet points from me.
    ## 1123                                                                                                                                                                                                                                                       Bollocks. Come here, we need to get some of that out.
    ## 1124                                                                                                                                                                                                                                                  'Cause I thought I might have a shit while it was brewing.
    ## 1125                                                                                                                                                                                  Were you just thinking, "Why have they saved this boring task for the end of the series?" Because fuck me, strap in, mate.
    ## 1126                                                                                                                                                                                                                                                                                     "Complete..." Oh, fuck.
    ## 1127                                                                                                                                                                                                                                                      Good news, though: you know where your fucking hip is.
    ## 1128                                                                                                                                                                                                                                                                                         You little bastard!
    ## 1129                                                                                                                                                                                                                                                                                           Get in, ya prick!
    ## 1130                                                                                                                                                                                                                                                                              Fuck's sake. I mean, oh, dear.
    ## 1131                                                                                                                                                                                                                                    If you ask me that one more time, I am shoving this jigsaw up your dick.
    ## 1132                                                                                                                                                                                                                                                                                           Go fuck yourself.
    ## 1133                                                                                                                                                                                                                                                                  That was the worst day of my fucking life!
    ## 1134                                                                                                                                                                                                                                                                                                Fucking fly!
    ## 1135                                                                                                                                                                                                                                                               I don't know what the fuck any of that meant.
    ## 1136                                                                                                                                                                                                                                                                                               Oh, bollocks.
    ## 1137                                                                                                                                                                                                                                                                                           Oh yeah, oh shit!
    ## 1138                                                                                                                                                                                                                                                                                  That's absolute horseshit.
    ## 1139                                                                                                                                                                                                                                                          Someone was pouring Gaviscon onto a fucking kebab?
    ## 1140                                                                                                                                                                                                                                        It doesn't look like a chicken wing. It looks like a slug or a shit.
    ## 1141                                                                                                                                                                                                                                                       It looks like Goldilocks came back proper pissed off.
    ## 1142                                                                                                                                                                                                                                                                                              Two? Oh, fuck.
    ## 1143                                                                                                                                                                                                                                                                                                 Oh, shit...
    ## 1144                                                                                                                                                                                                                           Otherwise it's no points again, this is gonna be the shittest series of all time.
    ## 1145                                                                                                                                                                                                                                                                          I thought it was pretty damn fine.
    ## 1146                                                                                                                                                                                                                        "I've got this white tiger, what should I do?" "Just stick it in the fucking hedge."
    ## 1147                                                                                                                                                                                                                                                                                                  Goddamnit!
    ## 1148                                                                                                                                                                                                                                                                              Oh, fuck it! Excuse me. Sorry.
    ## 1149                                                                                                                                                                                                                                                                                                 Oh, bugger!
    ## 1150                                                                                                                                                                                                                                                         Oh, Jesus Christ. These are some of the worst ever.
    ## 1151                                                                                                                                                                                                                                                                                        Oh, for fuck's sake.
    ## 1152                                                                                                                                                                                                                                                          It was in the candle. That's some next-level shit.
    ## 1153                                                                                                                                                                                                                                                           Mawaan said, "Whoa, that's some next-level shit."
    ## 1154                                                                                                                                                                                                                                                                                    So, previous-level shit.
    ## 1155                                                                                                                                                                                                                                                                                       It's next-level shit!
    ## 1156                                                                                                                                                                                                                                                                                  Bloody hell, it's working.
    ## 1157                                                                                                                                                                                                                                                                                                     Shit...
    ## 1158                                                                                                                                                                                                                                                He was thinking laterally and I like that, but he fucked up.
    ## 1159                                                                                                                                                                                                                                                                                               Fucking hell.
    ## 1160                                                                                                                                                                                                                                         He knew it was happening, he referred to his arse as his old fella.
    ## 1161                                                                                                                                                                                                                                                                                           Oh, you arsehole!
    ## 1162                                                                                                                                                                                                                                                   That's proper reach-for-the-stars, next-level shit, that.
    ## 1163                                                                                                                                                                                                                                        I mean, the listening of some of these guys, it was next-level shit.
    ## 1164                                                                                                                                                                                                             Imagine Lionel Richie watching this going, "Is that my legacy, walking on the fucking ceiling?"
    ## 1165                                                                                                                                                                                                                                                  The poor bastards have to Blu-Tack their fruit to a plate!
    ## 1166                                                                                                                                                                                                                                                                              Why, you selfish motherfucker!
    ## 1167                                                                                                                                                                                                                                                           I know, it's shit! It's worse than yours, I know.
    ## 1168                                                                                                                                                                                                                                                                                           Oh, piss on that.
    ## 1169                                                                                                                                                                                                                                                                                               Ah, bollocks.
    ## 1170                                                                                                                                                                                It was only Katherine, at one point inexplicably saying "Piss on that", that stopped me from running into traffic during it.
    ## 1171                                                                                                                                                                                                                         What the fuck. Wait, is this... is this not gone... have you got nighttime cameras?
    ## 1172                                                                                                                                                                                                                                                                                            Oh, fuck's sake!
    ## 1173                                                                                                                                                                                                                                                                                              Argh! Damn it!
    ## 1174                                                                                                                                                                                                                                                                That looks more like an arse than your cake.
    ## 1175                                                                                                                                                                                                                                                                                                   Oh, shit.
    ## 1176                                                                                                                                                                                                                                                                                      What the hell is this?
    ## 1177                                                                                                                                                                                                                                                                        That's the scary thing! Three cocks.
    ## 1178                                                                                                                                                                                                     Like when you were pulling yourself around on a boat all huffin' and puffin' with your big dad-ass out.
    ## 1179                                                                                                                                                                                                                 "Make this phone ring, not shove it up your arse and pretend you're going through customs."
    ## 1180                                                                                                                                                                                                                                                                 Didn't wanna fuck with the specimen, innit?
    ## 1181                                                                                                                                                                                                                                                   You know what? Just for the hell of it, put the shoes on.
    ## 1182                                                                                                                                                                                                          I just think if I'm gonna win, I should go to the full amount, because some fucker's gonna. Sorry.
    ## 1183                                                                                                                                                                                                                                              Did you really think he was gonna jump off that fucking winch?
    ## 1184                                                                                                                                                                                                                                                               Not kiwi versus tomato! It's fucking madness!
    ## 1185                                                                                                                                                                                                                                                                           And I was like, "What the fuck?!"
    ## 1186                                                                                                                                                                                                                                                                                                       Fuck!
    ## 1187                                                                                                                                                                                                                 I mean, the only thing of merit in the whole task yet again was her use of the word "fuck".
    ## 1188                                                                                                                                                                                                                                                                  Oh, shit, man, I'm so bad at multitasking.
    ## 1189                                                                                                                                                                                                                                                                           Shit, I know more than I thought.
    ## 1190                                                                                                                                                                                                                                              It just looks like that cat that shits in me yard every night.
    ## 1191                                                                                                                                                                                                                                                                                           Oh, Jesus Christ.
    ## 1192                                                                                                                                                                                                                       I can never be bothered to queue for the fucking Portaloo. I just piss where I stand.
    ## 1193                                                                                                                                                                                                                                                                                         Just shit yourse...
    ## 1194                                                                                                                                                                                                            I know that PRO magazine have a policy of their cover model is always just about to have a shit.
    ## 1195                                                                                                                                                                                                                                                            Because I don't believe in any of that bullshit.
    ## 1196                                                                                                                                                                                                                                                    "I'm a sexy badass bitch." I added that last bit myself.
    ## 1197                                                                                                                                                                                                                                                                      I'm gonna be shitting pips for a week.
    ## 1198                                                                                                                                                                                                                                                                                     Yeah, I just know shit.
    ## 1199                                                                                                                                                                                                                                                     Wank, fuck, shit, cunt, bums, tits, cock, task, mask...
    ## 1200                                                                                                                                                                                                                                                                                                      Cocks.
    ## 1201                                                                                                                                                                                                                                                                                                      Wanks.
    ## 1202                                                                                                                                                                                                                                                                                                      Shits.
    ## 1203                                                                                                                                                                                                                                                                                                Fuck's sake!
    ## 1204                                                                                                                                                                                                                                                                         You've called it The Fuck "Sa-keh".
    ## 1205                                                                                                                                                                                                                                                                                                  Fuck Sake?
    ## 1206                                                                                                                                                                                                                     I liked Fuck "Sak-eh" better than Fuck Sake. It was just you with your clever wordplay.
    ## 1207                                                                                                                                                                                                                                               Well, if you bought that in a pub, you would say "Fuck sake!"
    ## 1208                                                                                                                                                                                                                                            No, I'd never drink that shit. It's literally out the bin, dude.
    ## 1209                                                                                                                                                                                                                             Two points goes to For Fuck Sake, and one point because it was a glass of milk.
    ## 1210                                                                                                                                                                                                                                                                                                     Wanker!
    ## 1211                                                                                                                                                                                                                                                                I don't know what the hell's going on there.
    ## 1212                                                                                                                                                                                                                                                                                                   Oh, fuck!
    ## 1213                                                                                                                                                                                                                                                                                               Fuckin' hell.
    ## 1214                                                                                                                                                                                                                                                               Little bastard. There's a hole in the bottom.
    ## 1215                                                                                                                                                                                                                                                                                      What the hell is that?
    ## 1216                                                                                                                                                                                                                                                                                       I mean, Jesus Christ!
    ## 1217                                                                                                                                                                                                                                                                                       It's a fucking thing.
    ## 1218                                                                                                                                                                                                                                                                                    Come on, little buggers.
    ## 1219                                                                                                                                                                                                                                                      If that's what the future looks like, it can fuck off.
    ## 1220                                                                                                                                                                                                                                                                                               Ah, bollocks.
    ## 1221                                                                                                                                                                                                                                                                                                       Fuck!
    ## 1222                                                                                                                                                                                                                                                            Nobody's ever spoken fucking backwards, Richard!
    ## 1223                                                                                                                                                                                                                                                           It's, like, legit glass, innit? Yeah, shit, okay.
    ## 1224                                                                                                                                                                                              I've been a real arsehole this series. And if I wasn't an arsehole to you, it would look like I favored you...
    ## 1225                                                                                                                                                                                                                        But then Katherine so overshadowed it, I now think the washing machine thing's shit!
    ## 1226                                                                                                                                                                                                                                                                               I haven't got a fucking clue.
    ## 1227                                                                                                                                                                                                                                                                                               Fucking hell.
    ## 1228                                                                                                                                                                                                                                                                                                   Bullshit.
    ## 1229                                                                                                                                                                                                                                                                     That's fucking great, what I just done.
    ## 1230                                                                                                                                                                                                                                                                        Yeah, she's gonna fuck you up, mate.
    ## 1231                                                                                                                                                                                                                                                                                                  Fuck that!
    ## 1232                                                                                                                                                                                                                                                                   What's the fucking cow there for, anyway?
    ## 1233                                                                                                                                                                                                                                                                               Everyone, chill the fuck out!
    ## 1234                                                                                                                                                                                                                                                                                                   Oh, fuck.
    ## 1235                                                                                                                                                                                                                                                                                         But it's damn rude.
    ## 1236                                                                                                                                                                                                                                                                                    Aye, but it's damn rude!
    ## 1237                                                                                                                                                                                                                                                                    "I was playing Wanking Man in a Bush..."
    ## 1238                                                                                                                                                                                                                                                I hear what you're saying, it looks like an elephant's arse.
    ## 1239                                                                                                                                                                                                                                                                                                Oh, fuck it.
    ## 1240                                                                                                                                                                                                                                                                                                   Fuck! No!
    ## 1241                                                                                                                                                                                                                                                                              That's his mate, Gareth. Fuck!
    ## 1242                                                                                                                                                                                                                                                                                       Ah! Fuck, fuck, fuck!
    ## 1243                                                                                                                                                                                                                                                                        Oh, shit. Forgot about the doorbell.
    ## 1244                                                                                                                                                                                                                                                                                        Oh, for fuck's sake.
    ## 1245                                                                                                                                                                                                                                                                      Shit, I've got rid of all the oranges!
    ## 1246                                                                                                                                                                                                                                                                                                       Fuck!
    ## 1247                                                                                                                                                                                                                                                                                         Fuckin' hell, okay.
    ## 1248                                                                                                                                                                                                                                                                                           Oh, fuckin' hell!
    ## 1249                                                                                                                                                                                                                                                                                                   Oh, shit!
    ## 1250                                                                                                                                                                                                                                                                                                   Oh, fuck.
    ## 1251                                                                                                                                                                                                                                                                                                       Fuck.
    ## 1252                                                                                                                                                                                                                                                                              Fuck off, I'm not telling you.
    ## 1253                                                                                                                                                                                                                                                                                         You smooth bastard.
    ## 1254                                                                                                                                                                                                                                                                     Yeah, that's some freaky shit, come on.
    ## 1255                                                                                                                                                                                                                                                                               Where the hell have you been?
    ## 1256                                                                                                                                                                                                                                                                                                 Oh... shit.
    ## 1257                                                                                                                                                                                                                                                           Come on, spider. Oh, oh, shit, I'm missing a leg.
    ## 1258                                                                                                                                                                                                                                                                        Has anyone seen a leg? Oh, shit. OK.
    ## 1259                                                                                                                                                                                                                                                                              Shit, I dropped it on the way.
    ## 1260                                                                                                                                                                                                                                                                                   The goddamn string broke!
    ## 1261                                                                                                                                                                                                                                              "Put these wellies on the spider's feet." What fucking spider?
    ## 1262                                                                                                                                                                                                                                                                                              What the hell?
    ## 1263                                                                                                                                                                                                                                                                                            For fuck's sake!
    ## 1264                                                                                                                                                                                                                                                                 Oh, fuck's sake. They're weak hangers, man.
    ## 1265                                                                                                                                                                                                                                                                                                   Oh, shit!
    ## 1266                                                                                                                                                                                                                                                                       Oh, shit, I'm running out of hangers.
    ## 1267                                                                                                                                                                                                                                                                    He's a piece of shit, isn't he, Bernard?
    ## 1268                                                                                                                                                                                                                                                                                                 Oh, fuck...
    ## 1269                                                                                                                                                                                                                                                                                                       Fuck.
    ## 1270                                                                                                                                                                                                                                                                                                       Fuck!
    ## 1271                                                                                                                                                                                                                                           Doesn't matter how pissed I am, one-eye Gabrielle, I can't sleep.
    ## 1272                                                                                                                                                                                                                                          So at the end of the night, pissed, one eye, dreams can come true.
    ## 1273                                                                                                                                                                                                                                                                                      He's a filthy bastard.
    ## 1274                                                                                                                                                                                                                                                                                  That... is filthy bastard.
    ## 1275                                                                                                                                                                                                                                                                                     That is filthy bastard.
    ## 1276                                                                                                                                                                                                                                   You bet big on that cactus being through the doughnut. And you fucked it.
    ## 1277                                                                                                                                                                                                                                                       Christ, it really does work, having a news presenter.
    ## 1278                                                                                                                                                                                                                                                                                I fucking know what you are.
    ## 1279                                                                                                                                                                                                                                                                            What colour's your fucking hat?!
    ## 1280                                                                                                                                                                                                                                                                              "I fucking know what you are!"
    ## 1281                                                                                                                                                                                                                                 People are talkin' an awful lot of shite today, I'll tell ya that for free.
    ## 1282                                                                                                                                                                                                He's a good salesman, isn't he? It doesn't matter what horseshit's up on the screen, I start to believe him.
    ## 1283                                                                                                                                                                                                                                                                                                 Oh, Christ.
    ## 1284                                                                                                                                                                                                                                                                                 Lightest tower... oh, fuck.
    ## 1285                                                                                                                                                                                                                                                                           Let's doll it up, then. Oh, shit!
    ## 1286                                                                                                                                                                                                                                                                                                Fuck's sake.
    ## 1287                                                                                                                                                                                                                                   It was simple, it was a tower, it was beautiful, and it wasn't horseshit.
    ## 1288                                                                                                                                                                                                                                                                                                 Oh, Christ.
    ## 1289                                                                                                                                                                                                                                                        Well, it's fucking... you're in my way, aren't you?!
    ## 1290                                                                                                                                                                                                                                     That's 'cause I'm the only one that's firing in that fucking direction.
    ## 1291                                                                                                                                                                                                                                                                          Oh, shit. I've dropped everything!
    ## 1292                                                                                                                                                                                                                                           I'm not going to clap that, that was, that's bullshit. That's it.
    ## 1293                                                                                                                                                                                                                                                                                                   Bollocks.
    ## 1294                                                                                                                                                                                                                                                                                  Go and fuck up Mike's one!
    ## 1295                                                                                                                                                                                                 I'm sick of trying to be like, "Oh, I'm gonna bring in a shoe that sings." I'm not doing that shit no more.
    ## 1296                                                                                                                                                                                                                               It's that whimsy and ahh, it's, "Oh, look, it's a vessel," and all this shit.
    ## 1297                                                                                                                                                                                                                                                                         Oh, you bugger! Oh, you... bastard!
    ## 1298                                                                                                                                                                                                                                                             That would be one hell of an ending to a dance.
    ## 1299                                                                                                                                                                                                                                                                                                   Oh, damn.
    ## 1300                                                                                                                                                                                                                                                                          Fool? Me? I'll give you, you twat.
    ## 1301                                                                                                                                                                                                                                                                                      I'll show you my cock.
    ## 1302                                                                                                                                                                                                                                                                        I disagree... I... hate... it. Fuck.
    ## 1303                                                                                                                                                                                                                                                            You didn't know how that shit was moving, didja?
    ## 1304                                                                                                                                                                                                                                                                                               Jesus Christ.
    ## 1305                                                                                                                                                                                                                                                                                            Oh, shit! Sorry.
    ## 1306                                                                                                                                                                                                                                                                               It was one hell of an opener.
    ## 1307                                                                                                                                                                                                                                                   So, what you're saying is Charlotte absolutely fucked it?
    ## 1308                                                                                                                                                                                                                         Well, I wouldn't have used those words, no, I would have said completely fucked it.
    ## 1309                                                                                                                                                                                                                                                                                                   Oh, shit.
    ## 1310                                                                                                                                                                                                                                                                     Oh! Polly Put the Kettle On, you prick!
    ## 1311                                                                                                                                                                                                                                                                                             Are you Christ?
    ## 1312                                                                                                                                                                                                                         Charlotte is really there, but all of those old bastards have been superimposed in.
    ## 1313                                                                                                                                                                                                                                                                 Oh, shit, that's, that's not going to work.
    ## 1314                                                                                                                                                                                                                                                                      Fucking, come on. Yeah, yeah, it's in.
    ## 1315                                                                                                                                                                                                                   Being in that house for so long, you kind of just wanna start ripping shit off the walls.
    ## 1316                                                                                                                                                                                                                                                                  Oh, fuck! No! No, no. Did that just touch?
    ## 1317                                                                                                                                                                                                                                            And very wise, stopping to dry the top of a bucket with her ass.
    ## 1318                                                                                                                                                                                                                                                                                            Oh, you bastard.
    ## 1319                                                                                                                                                                                                                                                                                      I'm such a dumb prick.
    ## 1320                                                                                                                                                                                                                                                                                                Ow, fuck it.
    ## 1321                                                                                                                                                                                                                                                                                       What the hell's that?
    ## 1322                                                                                                                                                                                                                                                                             Oh, fuck. There's that egg. OK.
    ## 1323                                                                                                                                                                                                                                                                                Urgh! What the fuck is that?
    ## 1324                                                                                                                                                                                                                                                       It's like, shit, oh, well, we've got shit on a plate.
    ## 1325                                                                                                                                                                                                                                                    People at Channel 4 watching people eat shit on a plate.
    ## 1326                                                                                                                                                                                                                                       I got very unprofessional... and I just decided to fuck the place up.
    ## 1327                                                                                                                                                                                                                                                                              Oh, I'm gonna get you... Damn!
    ## 1328                                                                                                                                                                                                                                                                                   Fuck, it is tense, innit?
    ## 1329                                                                                                                                                                                                                                                                                 Yeah, it's a piece of shit.
    ## 1330                                                                                                                                                                                                                                                             I couldn't give a shit. I couldn't give a shit.
    ## 1331                                                                                                                                                                                                                      He's like, "Oh, look, yeah, I'm a lion", and he was blue. And it really pissed me off.
    ## 1332                                                                                                                                                                                                                                                      He's sitting under a tree, thinking of tasks and shit.
    ## 1333                                                                                                                                                                                                                                           The idea of me sitting under a tree thinking of tasks and shit...
    ## 1334                                                                                                                                                                                                                Well, Sarah said "This is a piece of piss. There's his little piggy nose," and she did this.
    ## 1335                                                                                                                                                                                                                               Jamali said it was so good you could take it to a gallery and sell this shit.
    ## 1336                                                                                                                                                                                                                                                                   Is it cool if I just start fuckin' it up?
    ## 1337                                                                                                                                                                                                                                                                                Yeah, it hit me in the dick.
    ## 1338                                                                                                                                                                                                                                           And is this your sloag? "Is it OK for me to start fucking it up?"
    ## 1339                                                                                                                                                                                                                        And it wasn't like TV, "Oh, no, it hit my dick." No, it hit me straight in the dick.
    ## 1340                                                                                                                                                                                                                                                                                              Oh, you prick!
    ## 1341                                                                                                                                                                                                                                                                                     What the hell is that?!
    ## 1342                                                                                                                                                                                                                                                                                Aw, shit. All right, well...
    ## 1343                                                                                                                                                                                                                                                                        Uh, mash the... Oh, for fuck's sake.
    ## 1344                                                                                                                                                                                                                                And Sarah became the most Australian person on Earth, "Aw, for fuck's sake!"
    ## 1345                                                                                                                                                                                                                                   What's a verb that starts with Y? Yell at a zebra. Ah, you fucking zebra!
    ## 1346                                                                                                                                                                                                                          You also made it into the Taskmaster book of quotes with, "Ah, you fucking zebra."
    ## 1347                                                                                                                                                                                                                                                                    Who tells you to attack a fucking lemon?
    ## 1348                                                                                                                                                                                                                                                                                 Re-babushka a load of shit.
    ## 1349                                                                                                                                                                                                                                                         I am dying to know what the hell was going on here.
    ## 1350                                                                                                                                                                                                                                          So they're either all good or they're all shit. It doesn't matter.
    ## 1351                                                                                                                                                                                                                                                                                                   Ah, fuck!
    ## 1352                                                                                                                                                                                                                                                                                                    Fuck it.
    ## 1353                                                                                                                                                                                                                                                 Oh, my god, so dry! No chutney or nothin', fuckin'... done.
    ## 1354                                                                                                                                                                                                                                                           We're still pissing in the dark, aren't we, here?
    ## 1355                                                                                                                                                                                                                               Yeah, but, even if you're pissing in the dark, you know roughly where to aim.
    ## 1356                                                                                                                                                                                                                                                                                     Yeah, I fucked that up.
    ## 1357                                                                                                                                                                                                 Well, good afternoon, ladies and gentlemen. This is Captain Perigan Twatcustard, welcome aboard the flight.
    ## 1358                                                                                                                                                                                                                                                But seriously if you do need a shit, please use the toilets.
    ## 1359                                                                                                                                                                                                                                                                          How does this fucking thing work?!
    ## 1360                                                                                                                                                                                                                                                                                                       Fuck!
    ## 1361                                                                                                                                                                                                                                          You heard that we want you to fuck an island up and kill everyone.
    ## 1362                                                                                                                                                                                                                                                                                 Oh, no. Oh, no! Shit, guys!
    ## 1363                                                                                                                                                                                                                                        Yeah, and then you go in to film and you just get this little bitch.
    ## 1364                                                                                                                                                                                                                                                                                  Awful, hairy little bitch.
    ## 1365                                                                                                                                                                                                                                                                                      He's a punk-ass bitch.
    ## 1366                                                                                                                                                                                                                                                                                 He's a punk-ass bitch, man.
    ## 1367                                                                                                                                                                                                                      It's pissing it down with rain and we've got you muttering "please" under your breath.
    ## 1368                                                                                                                                                                                                                                                                                                   Ah, shit!
    ## 1369                                                                                                                                                                                                                                                                                     ... done, you... prick.
    ## 1370                                                                                                                                                                                                                                    I don't know anyone else in that situation who wouldn't say, "Oh, shit!"
    ## 1371                                                                                                                                                                                                                                                                                                   Bullshit!
    ## 1372                                                                                                                                                                                                                           But at least a human response from you when it fell down, you shouted "bullshit!"
    ## 1373                                                                                                                                                                                                                                            I would absolutely shit myself and I would go looking for Sarah.
    ## 1374                                                                                                                                                                                                                                                                                       Shit! Oh, my god. No!
    ## 1375                                                                                                                                                                                                                                        One of the few jobs I had, my auntie used to make me photocopy shit.
    ## 1376                                                                                                                                                                                                                                                 I totally fucked up... I thought Dara O'Brian was the host!
    ## 1377                                                                                                                                                                                                       Fuck, mate, that, that was a lot of pressure. I actually forgot for a second. I was like, "ah, shit".
    ## 1378                                                                                                                                                                                                 And that directly contrasts with, "One of the few jobs I've had, my auntie used to make me photocopy shit."
    ## 1379                                                                                                                                                                                                                                                           For me, it looks like a dragonfly with two dicks.
    ## 1380                                                                                                                                                                                                                        I do wanna argue with you, but it kind of does look like a dragonfly with two dicks.
    ## 1381                                                                                                                                                                                                                                                                                         Oh, you mad bugger.
    ## 1382                                                                                                                                                                                                                                                        Five bellies, two faces, but my face is the... arse.
    ## 1383                                                                                                                                                                                                                                                              Two quid an hour? You're playing the arsehole!
    ## 1384                                                                                                                                                                                                                                                                   Oh, by this time, I was sick of his shit.
    ## 1385                                                                                                                                                                                                                                                            Shit. It's error, 'cause it's weighing too much.
    ## 1386                                                                                                                                                                                                                                                           Even in victory, your teammate gets a bollocking.
    ## 1387                                                                                                                                                                                                                                                                                                  The fuck?!
    ## 1388                                                                                                                                                                                                                                                                                               This is hell!
    ## 1389                                                                                                                                                                                                                                                                     They're like stinging nettles and shit.
    ## 1390                                                                                                                                                                                                                   You wouldn't have "activated Jamali" at all if he hadn't said "What the fuck am I doing?"
    ## 1391                                                                                                                                                                                                                                                                     So I've got to find the little bastard.
    ## 1392                                                                                                                                                                                                                                                      Where the hell would a ball‒would probably be in here?
    ## 1393                                                                                                                                                                                                                                                                      Okay, where the hell haven't I looked?
    ## 1394                                                                                                                                                                                                                                             I've just seen him, the little fucker, but I don't have a ball!
    ## 1395 I'm gonna give Morgana a bonus point for her attempt, before we even give her a score. You would think it was because you set a trap for Alex, which I really enjoyed and thought, "I'm gonna give her an extra point for that, it's so clever", but it's not. It's 'cause you called Alex a little fucker.
    ## 1396                                                                                                                                                                                                                                                                         I think I want it six, uh, damn it.
    ## 1397                                                                                                                                                                                                                                                                                      Whoa, fuck! OK, sorry.
    ## 1398                                                                                                                                                                                                                                                                                                   Oh, shit!
    ## 1399                                                                                                                                                                                                                                                                              Oh, look at all this shit! OK.
    ## 1400                                                                                                                                                                                                                                                            Guys, is this a wind... oh, you little bastards!
    ## 1401                                                                                                                                                                                                                                                                               Oh, I've got no fucking gold.
    ## 1402                                                                                                                                                                                                                                       It was a very nice break from running around like a dickhead all day.
    ## 1403                                                                                                                                                                                                                                                              Unlike Desiree who, er, shouted, "Whoa! Fuck!"
    ## 1404                                                                                                                                                                                                                                              Just really bullshitted that one. Did that come out all right?
    ## 1405                                                                                                                                                                                                                                            But you're still a little bit pissed off, so hence the eyebrows.
    ## 1406                                                                                                                                                                                           I'm gonna give Morgana two points, and it's basically because Desiree really bullshitted her way to three points.
    ## 1407                                                                                                                                                                                                                                                                                Ooh, missed by a bee's dick!
    ## 1408                                                                                                                                                                                                                                                                                        Ah, for fuck's sake!
    ## 1409                                                                                                                                                                                                                                                                                    What the fuck was that?!
    ## 1410                                                                                                                                                                                                                                                                                        No, for fuck's sake.
    ## 1411                                                                                                                                                                                                                                              They seem like a great couple. Really got their shit together.
    ## 1412                                                                                                                                                                                             I know that, you know, you're gonna piss off a lot of people at home if you don't give me at least five points.
    ## 1413                                                                                                                                                                                                                                                                                Oh, shit. I've got a friend.
    ## 1414                                                                                                                                                                                                                                                    Yeah, this is more of your very, very eloquent bullshit.
    ## 1415                                                                                                                                                                                                                                                                                 Do you have any arse bread?
    ## 1416                                                                                                                                                                                                                                                                                       I do have arse bread!
    ## 1417                                                                                                                                                                                                                                                                        She's well known for the arse bread.
    ## 1418                                                                                                                                                                                                                                                     Arse bread was on my face. That was arse bread you saw.
    ## 1419                                                                                                                                                                                                                            I'm going to give the Arse Bread Tragedy... I'm gonna give them all five points.
    ## 1420                                                                                                                                                                                                                                Oh, you absolute... shitbag. Don't know why the word "shitbag" came to mind.
    ## 1421                                                                                                                                                                                                                                              All the things you gave me, it all is shit. Write "shit" down.
    ## 1422                                                                                                                                                                                                                                                                                                 Shit, yeah.
    ## 1423                                                                                                                                                                                                                                                                          Yep, that's what the fuck that is!
    ## 1424                                                                                                                                                                                                                                       And then this shit is actually, like, oatmeal... I don't know, death.
    ## 1425                                                                                                                                                                                                                                                                           Oh, shit, this is gonna be messy.
    ## 1426                                                                                                                                                                                                                                                                            Oh, that's better. Fuckin' hell.
    ## 1427                                                                                                                                                                                            I'd like to make this sound more scientific than it's about to be, but... we're just gonna make this shit green.
    ## 1428                                                                                                                                                                                                                              Well, at this point, I might as well just get messy. Enjoy ourselves and shit.
    ## 1429                                                                                                                                                                                                                            They don't make them like they used to. It's, it's built like a brick shithouse.
    ## 1430                                                                                                                                                                                         All the time, we're being bombarded with shit and opinions that be messing up your psyche and your emotional state.
    ## 1431                                                                                                                                                                                                                                                        I'm sure you'll both be very happy together in Hell.
    ## 1432                                                                                                                                                                                                                                                                                                    Damn it.
    ## 1433                                                                                                                                                                                                                                                                                How the fuck do I move that?
    ## 1434                                                                                                                                                                                          'Cause water's very fundamental to building sand bridges, ain't it? I'm sure that was on Countryfile or some shit.
    ## 1435                                                                                                                                                                                                                                                                                       I don't fucking know.
    ## 1436                                                                                                                                                                                                                                                                    "I always said the pussy was dangerous."
    ## 1437                                                                                                                                                                                                                  In this one, the house really decided, like, "We want this bitch out." So it turned on me.
    ## 1438                                                                                                                                                                                                                                          Ooh, snake. Walk like an Egyptian. But there's snake down in Hell.
    ## 1439                                                                                                                                                                                     I'm giving a man who found an old wig in his attic five points. That's Taskmaster and if you don't like it, tough shit!
    ## 1440                                                                                                                                                                                                                                                                                                       Shit!
    ## 1441                                                                                                                                                                                                                                                                                    Stop, you bastard! Stop!
    ## 1442                                                                                                                                                                                                                           And then when my colleagues came in, the kids would be like, "You're a dickhead!"
    ## 1443                                                                                                                                                                                                                       So I was like, "Yeah, I'm like the coolest up there and everyone else is a dickhead."
    ## 1444                                                                                                                                                                                                             You see how I did that? Flicked it... ow, shit! That's not so cool but I burnt myself for real.
    ## 1445                                                                                                                                                                                                                                                The whole thing was a pain in the arse, this one, wasn't it?
    ## 1446                                                                                                                                                                                                                                                                                 The worst shit I've ever...
    ## 1447                                                                                                                                                                                                                                                                                        Fuck me in the face!
    ## 1448                                                                                                                                                                                                                                                                                  Who the fuck is Veronica?!
    ## 1449                                                                                                                                                                                                                             ♪ This task... is shit. Got four hours to get to the end... task is bullshit! ♪
    ## 1450                                                                                                                                                                                                                                                           Oh, my god, you've only gone and fucking done it!
    ## 1451                                                                                                                                                                                                                                          I loved your song, which I believe was called "This Task Is Shit".
    ## 1452                                                                                                                                                                                                                     You don't think, uh, the song "This Task Is Shit" is going to hold up against that, no?
    ## 1453                                                                                                                                                                                                                                                                                               Jesus Christ!
    ## 1454                                                                                                                                                                                                                  Victoria, listen, across this series you have been consistently a sensational bullshitter.
    ## 1455                                                                                                                                                                                                                                                Or what it looks like after my ass has smushed it to pieces?
    ## 1456                                                                                                                                                                                                                                                                              Oh, my god. Look at this shit.
    ## 1457                                                                                                                                                                                                                                    Where's the damn cakes? Where are the cakes? Where are you hiding cakes?
    ## 1458                                                                                                                                                                                                                                                                    Oh, fuck you if that's the right answer.
    ## 1459                                                                                                                                                                                                                                                                                               You arsehole!
    ## 1460                                                                                                                                                                                                                 Should I tell you how I knew he was gonna do it? 'Cause of them shit-flickers, that's what.
    ## 1461                                                                                                                                                                                                   Never seen him aggressive in his life, and then he blasted that door. I shit myself when I was sat there.
    ## 1462                                                                                                                                                                                                                                                                                                       Fuck!
    ## 1463                                                                                                                                                                                                                                                                                              Little fucker.
    ## 1464                                                                                                                                                                                                                                      Now I'm here in this chair and I don't know what the fuck is going on.
    ## 1465                                                                                                                                                                                                                                                                                                       Fuck!
    ## 1466                                                                                                                                                                                                                                I know that you like this, this novelty bullshit, so convert it if you want.
    ## 1467                                                                                                                                                                                                                                                     Bollocks. Bollocks. Bollocks! So close to not bollocks.
    ## 1468                                                                                                                                                                                                                                                                                                 Bollocks...
    ## 1469                                                                                                                                                                                            The concept's ridiculous. Is the hair ridiculous? I was trying to start a heated debate but no one gives a shit.
    ## 1470                                                                                                                                                                                                                             ... Alton Towers in the summer, full of kids all shitting all over the place...
    ## 1471                                                                                                                                                                                                                                                      On school trips, you've seen kids shitting themselves?
    ## 1472                                                                                                                                                                                                                                                                                               Shitty Sajid.
    ## 1473                                                                                                                                                                                                                                                                                                 Oh, Christ!
    ## 1474                                                                                                                                                                                                                                                                                     Oh, you're an arsehole!
    ## 1475                                                                                                                                                                                                                                                       You turned it upside down. You called it an arsehole.
    ## 1476                                                                                                                                                                                                                                                 Actually I think it was the ball I was calling an arsehole.
    ## 1477                                                                                                                                                                                                                                                So Desiree was the slowest, 19 minutes with the cock system.
    ## 1478                                                                                                                                                                                                                                                                                  Scared the shit out of me.
    ## 1479                                                                                                                                                                                                                                                                                            Oh, you fuckers.
    ## 1480                                                                                                                                                                                                                                                                                  Come out, you little shit.
    ## 1481                                                                                                                                                                                                                                                                              Huh? Ah, ya bastard. OK. Line.
    ## 1482                                                                                                                                                                                                                                     I think Vic was describing Shitty Saj from earlier on in that anecdote.
    ## 1483                                                                                                                                                                                                                   And the thing I remember about Saj when he shit himself on the log flume, he was smiling.
    ## 1484                                                                                                                                                                                                                                                                                                 Arse cream.
    ## 1485                                                                                                                                                                                                                                                                        Two points for Morgana's arse cream.
    ## 1486                                                                                                                                                                                                                                                                                           OK. Jesus Christ.
    ## 1487                                                                                                                                                                                                                                                                                                   Oh, shit.
    ## 1488                                                                                                                                                                                                                                                                                            Aww, shitsticks.
    ## 1489                                                                                                                                                                                                                                              I've had my bollocks permanently damaged from this game, so...
    ## 1490                                                                                                                                                                                                                                                                    Outstanding player, but a dirty bastard.
    ## 1491                                                                                                                                                                                                                                                                                     Khan is shitting in it.
    ## 1492                                                                                                                                                                                                                                                                                 This is a really shit game.
    ## 1493                                                                                                                                                                                                                                                           He said it's a really shit game at the end there.
    ## 1494                                                                                                                                                                                                                                     You know, when you throw enough shit at the wall, something will stick.
    ## 1495                                                                                                                                                                                                                               "I hope I don't get the shit kicked out of me in a car park and lose an eye."
    ## 1496                                                                                                                                                                                                                                                                     I am genuinely shitting myself up here.
    ## 1497                                                                                                                                                                                                                                                                                                       Damn!
    ## 1498                                                                                                                                                                                                                                  No, it's really urgent shit, brother. That's why, it's really urgent shit.
    ## 1499                                                                                                                                                                                                                                                   Damn, we were so close. We almost had it all, Dave. Fine.
    ## 1500                                                                                                                                                                                                                                                      You asking him to blow on your neck was hell for Alex.
    ## 1501                                                                                                                                                                                  If it's any consolation, Guz, you putting ice down your back and then it dripping into your arse crack gave me goosebumps.
    ## 1502                                                                                                                                                                                                                                                                            My cock can do that, by the way.
    ## 1503                                                                                                                                                                                                                                                           I was gonna dash that fuckin' Ribena at his head!
    ## 1504                                                                                                                                                                                                                                                                      I don't know what the hell's going on.
    ## 1505                                                                                                                                                                                                                           Well, you would be getting loads of marks if it wasn't for Desiree fucking it up.
    ## 1506                                                                                                                                                                                                                          Let's leave it on after breaking shit in your house all the time. Came off anyway.
    ## 1507                                                                                                                                                                                                                                                                                        It's a long-ass day.
    ## 1508                                                                                                                                                                                                                                                                                       It is a long-ass day.
    ## 1509                                                                                                                                                                                                                                                                                               Jesus Christ.
    ## 1510                                                                                                                                                                                                                                                                      It's pretty damn sweet, if you ask me.
    ## 1511                                                                                                                                                                                                                                Victoria's... pretty damn weak proposal, but it was a fairly sweet response.
    ## 1512                                                                                                                                                                                                                                                             I'll give Sayeeda two points for her shit tree.
    ## 1513                                                                                                                                                                                                                     Ooh, "Basic recipe 28, plain pudding mixture." That's what you like, no dicking around.
    ## 1514                                                                                                                                                                                                                                                                              Jesus Christ, the woman's mad.
    ## 1515                                                                                                                                                                                                                                                                    I've just drunk all the bastard vinegar.
    ## 1516                                                                                                                                                                                                                                         Adrian drank all the bastard vinegar at nine minutes, five seconds.
    ## 1517                                                                                                                                                                                                                                                                                           Ooh, bloody hell.
    ## 1518                                                                                                                                                                                                                                                                                             Oh, Christ, OK.
    ## 1519                                                                                                                                                                                                                                                                       Your trophy's been pissed on already.
    ## 1520                                                                                                                                                                                                                                                             Write down "Judi Love, incredible bullshitter."
    ## 1521                                                                                                                                                                                                                          I think that's because Judi did such a good job of bullshitting me about the tape.
    ## 1522                                                                                                                                                                                                                                      Great news about your shit sofa: you've got three sweet points for it.
    ## 1523                                                                                                                                                                                                                                                        I can see it, okay? They're not ducks. Fucking hens.
    ## 1524                                                                                                                                                                                                                                                                                   Turn around. God damn it.
    ## 1525                                                                                                                                                                                                                                                       What's in it for you is I'm not gonna get pissed off.
    ## 1526                                                                                                                                                                                                                                                                                               Christ alive!
    ## 1527                                                                                                                                                                                                                                                                           Woodpeckers must be hard as fuck.
    ## 1528                                                                                                                                                                                                                                             I've eaten a lot of crisps. Yeah. I've got big, I got big tits?
    ## 1529                                                                                                                                                                                                                                                                Oh, my word! That is... phenomenal bullshit.
    ## 1530                                                                                                                                                                                                                                          I think they would be going, "Who the hell is this guy?" You know.
    ## 1531                                                                                                                                                                                                                                                                   He's brought something totally shit in...
    ## 1532                                                                                                                                                                                                                                                                         Oh, my god, you absolute twat face.
    ## 1533                                                                                                                                                                                                                                                                                                  Ooh, shit.
    ## 1534                                                                                                                                                                                                                                                             It would've been less of a shit show, would it?
    ## 1535                                                                                                                                                                                                                                                  The other two, I mean, literally scare the shit out of me.
    ## 1536                                                                                                                                                                                                                                           You could've pissed in the bottle or something to make it yellow.
    ## 1537                                                                                                                                                                                                                                                The hooded man in the original isn't pissing against a wall.
    ## 1538                                                                                                                                                                                      That's what I thought, but I hadn't seen that, so otherwise I'd have changed that to say you look like you're pissing.
    ## 1539                                                                                                                                                                                                                                                                   So what... what the hell's going on here?
    ## 1540                                                                                                                                                                                                                                                                                                   Ah, shit.
    ## 1541                                                                                                                                                                                                                                               For want of a more sophisticated response, the guy's a prick.
    ## 1542                                                                                                                                                                                                                                                                 Surely that gets a damn point or something!
    ## 1543                                                                                                                                                                                                I put it to you, Bridget, that you've deliberately chosen a stopcock because it's got the word "cock" in it.
    ## 1544                                                                                                                                                                                                                                   I'm sorry, pleasant fucker didn't do it for me. Pleasant fucker? Come on.
    ## 1545                                                                                                                                                                                                                                         This is Dolly the Sheep. Didn't name that one, no one gives a shit.
    ## 1546                                                                                                                                                                                            My art draws the emotion after I've done it, with just simple sand and a fucking crown... what else do you need?
    ## 1547                                                                                                                                                                                                                       I'll tell you what you need, one point. And you can thank me for it. Fucking rubbish!
    ## 1548                                                                                                                                                                                                                                                                                You bastards are going last.
    ## 1549                                                                                                                                                                                                                         Well, 'cause I was expecting Captain Dickhead here to just keep lighting 'em again.
    ## 1550                                                                                                                                                                                                                                                                          You can go fuck yourself, you can.
    ## 1551                                                                                                                                                                                                                                                          Oh, my god, it's not even on full power, you shit.
    ## 1552                                                                                                                                                                                                                                                  I don't even care about the points, this is fuckin' great.
    ## 1553                                                                                                                                                                                                                                                                               Stick your duck up your arse.
    ## 1554                                                                                                                                                                                                          "As a team, put one of your faces and one of your legs through the hole." I'm not doing that shit.
    ## 1555                                                                                                                                                                                                                                                                                                       Fuck!
    ## 1556                                                                                                                                                                                                                                                                                                     Bugger!
    ## 1557                                                                                                                                                                                                                                                                                        Oh, for fuck's sake.
    ## 1558                                                                                                                                                                                                                                                                                No, no, don't take the piss.
    ## 1559                                                                                                                                                                                                                                                                               Get your fuckin' hand off me!
    ## 1560                                                                                                                                                                                                                                                                                      Eat your fucking worm!
    ## 1561                                                                                                                                                                                                                                                         We all heard you say, "Just eat your fucking worm!"
    ## 1562                                                                                                                                                                                                                                            God damn. If Sophie Duker wins Taskmaster, we all win her, papa.
    ## 1563                                                                                                                                                                                                                                                                   Yeah, I mean, it started with "God damn."
    ## 1564                                                                                                                                                                                                                                                                                  A rass is like... an arse.
    ## 1565                                                                                                                                                                                                                                            Look at this shit! Look at this. My nail has fuckin' popped off!
    ## 1566                                                                                                                                                                                                                                                                               What the hell was I thinking?
    ## 1567                                                                                                                                                                                                                                                   Can I just say, I didn't know what the hell was going on.
    ## 1568                                                                                                                                                                                                                                                 This shit ain't getting wet, okay. I need you to know that.
    ## 1569                                                                                                                                                                                                                                                           It's floating like two dicks! Why is it floating?
    ## 1570                                                                                                                                                                          Obviously Judi's gone straight into the Taskmaster book of quotes by saying of a bunch of bananas, "It's floating like two dicks."
    ## 1571                                                                                                                                                                                                                                                              So where's the phone? Where's the damn phone?!
    ## 1572                                                                                                                                                                                                                      Get on the stick, you prick! Get on the stick, you prick! You prick, get on the stick!
    ## 1573                                                                                                                                                                                                                                                                   I enjoyed, "Get on the stick, you prick."
    ## 1574                                                                                                                                                                                                                                                       You could imagine some prick coming up with it, yeah.
    ## 1575                                                                                                                                                                                                                                   Oh, "welcome to the Cement Mixer Bar", fuck. Fuck you, ya hipster pricks.
    ## 1576                                                                                                                                                                                                                                                                                                   Oh, shit.
    ## 1577                                                                                                                                                                                                                                                                                                     Fuck...
    ## 1578                                                                                                                                                                                                                                                                                         I am so pissed off.
    ## 1579                                                                                                                                                                                                                                        Some chocolate has been stolen, and it was one of you greedy pricks.
    ## 1580                                                                                                                                                                                                                                   Before we go any further, chairman, some gobshite's blocking the Bentley.
    ## 1581                                                                                                                                                                                                                                                               I mean, what sort of fucking opener was that?
    ## 1582                                                                                                                                                                                                                                                                                                    Damn it.
    ## 1583                                                                                                                                                                                                                                                                                                       Shit!
    ## 1584                                                                                                                                                                                                When you can fry four of them at the same time evenly and they come out golden—hello, I'm that bitch. Hello.
    ## 1585                                                                                                                                                                                                                                                                                   Shit. Is this a full one?
    ## 1586                                                                                                                                                                                                                                          I mean, the obvious highlight is Ardal's arse lid that he created.
    ## 1587                                                                                                                                                                                                                                                             You didn't know who I fucking was a minute ago!
    ## 1588                                                                                                                                                                                                                                                                                Oh, shit. That's 65 already.
    ## 1589                                                                                                                                                                                                                                                                        I mean, honestly, look at that shit.
    ## 1590                                                                                                                                                                It really does feel like an evolution from us childishly drawing cock and balls on windows, as I've done, I'm ashamed to say, so many times.
    ## 1591                                                                                                                                                                                                                                                                                        I don't give a shit.
    ## 1592                                                                                                                                                                                                                                                                                       Oh, now you fuck up?!
    ## 1593                                                                                                                                                                                                                                                                         "Learn Swedish." Oh, shitting hell!
    ## 1594                                                                                                                                                                                                                                                   Erm, the song. I mean, where the hell did that come from?
    ## 1595                                                                                                                                                                                                                                                                                        Oh, for fuck's sake.
    ## 1596                                                                                                                                                                                                                                                                                                  Fuck this.
    ## 1597                                                                                                                                                                                                                                                                                   There's no fucking shoes!
    ## 1598                                                                                                                                                                                                                               "There's no fucking shoes." "I don't understand what's happening" times five.
    ## 1599                                                                                                                                                                                                                                                  She's right, you can get big-ass frogs, but it's academic.
    ## 1600                                                                                                                                                                                                                                            I don't know what the hell she's brought in. I still don't know.
    ## 1601                                                                                                                                                                                                                                                    I was surprised at how much I looked like the damn fish.
    ## 1602                                                                                                                                                                                                                                               And, well, I stepped out of the barn and fucked myself, so...
    ## 1603                                                                                                                                                                                                                                      I'm thinking how could I disguise me arse as a head, is that possible?
    ## 1604                                                                                                                                                                                                                                                                                               Oh, fuck off.
    ## 1605                                                                                                                                                                                                                                                                                             I'm pissed off.
    ## 1606                                                                                                                                                                                                                                                                                                   Oh, shit.
    ## 1607                                                                                                                                                                                                          But I've got to recognise what an amazing bullshitter Judi Love is. I'm gonna give her two points.
    ## 1608                                                                                                                                                                                                                                                                                    What is that damn smell?
    ## 1609                                                                                                                                                                                                                                                                     Oh, there it is. What the hell is that?
    ## 1610                                                                                                                                                                                                                                                                                                     Bugger.
    ## 1611                                                                                                                                                                                                                                                   It's slightly fizzy. It tastes like ass. Is it Dr Pepper?
    ## 1612                                                                                                                                                                                                                                                                                             Oh, goddamn it.
    ## 1613                                                                                                                                                                                                                                                                      Track six, er, a humming or some shit.
    ## 1614                                                                                                                                                                                                                                              ♪ In a high five stand-off, we'll take your fucking hand off ♪
    ## 1615                                                                                                                                                                                                                                             Yeah, I know that, just one of them isn't on your fucking head.
    ## 1616                                                                                                                                                                                                                                                         Well, bottom line is, that is a hell of a sandwich.
    ## 1617                                                                                                                                                                                                                                                                                  Right, you smooth bastard.
    ## 1618                                                                                                                                                                                                                                                                                Herring is shitting himself.
    ## 1619                                                                                                                                                                                                                                                                                               Jesus Christ!
    ## 1620                                                                                                                                                                                                                      I barely noticed that you had put a grape on a pulley system... powered by a dickhead.
    ## 1621                                                                                                                                                                                                                                                                                It's a fucking angel cherub.
    ## 1622                                                                                                                                                                                                             But the only thing from the weapon that Officer Dickhead could find was the stalk of the grape.
    ## 1623                                                                                                                                                                                                           A, you've learnt to suck up to me, which I appreciate. And B, you've learnt not to do shit stuff.
    ## 1624                                                                                                                                                                                                                               We can go the other way if you want. If you wanna be a fucking dick about it.
    ## 1625                                                                                                                                                                                                                                                        I knew it was your brand to get your arse out, so...
    ## 1626                                                                                                                                                                                                                I thought, "Well, nothing's gonna be less wonderful than Alex's arse through a deer's nose."
    ## 1627                                                                                                                                                                                                                        Ease down, mate. You might just have scraped above this pile of shit, but pipe down.
    ## 1628                                                                                                                                                                                                                                                               Thank you. There is, there fucking is, Kerry.
    ## 1629                                                                                                                                                                                                                                                                                                Ooh, Christ.
    ## 1630                                                                                                                                                                                                                                                                                               Jesus Christ.
    ## 1631                                                                                                                                                                                                                                               There was someone in every year, wasn't there? "Mine's shit."
    ## 1632                                                                                                                                                                                                                                                                                                   Oh, shit!
    ## 1633                                                                                                                                                                                                                                                                                        Fuckin' hell, Kerry.
    ## 1634                                                                                                                                                                                                                                                         Fuck you! Unbelievable. Acting my fucking face off.
    ## 1635                                                                                                                                                                                                                          What the hell is that? Like, an elf wears that, but there's no elves in Australia.
    ## 1636                                                                                                                                                                                                                                                                             What the hell would be in this?
    ## 1637                                                                                                                                                                                                                                                                                           Oh, Jesus Christ.
    ## 1638                                                                                                                                                                                                                                                                                Carroty goat, what the hell?
    ## 1639                                                                                                                                                                                                                                                                    Oh, shite. It has gone badly, hasn't it?
    ## 1640                                                                                                                                                                                                                                                                                   What the fuck's going on?
    ## 1641                                                                                                                                                                                                                          I would say once a week I do that and I look at myself and go, "You fat arsehole."
    ## 1642                                                                                                                                                                                                                                                                                         LeBron James. Shit.
    ## 1643                                                                                                                                                                                                                                                                                               Oh, damn! OK.
    ## 1644                                                                                                                                                                                                                                                         Why would you want a foot sticking out of its arse?
    ## 1645                                                                                                                                                                                                                                                                            Oh, Jesus Christ, three of them.
    ## 1646                                                                                                                                                                                                                                                                    I'm absolutely pissed on the adrenaline.
    ## 1647                                                                                                                                                                                                                                                                            No, quite right, John. Fuck him.
    ## 1648                                                                                                                                                                                                   It's six foot tall and frightens the shit out of me twice a week, maybe. It's awful. Please take it away.
    ## 1649                                                                                                                                                                                                                                                                 "Get your arse off this." It's not on this.
    ## 1650                                                                                                                                                                                                                                           Right, that's bollocks. That, apparently, is "home" in Wingdings.
    ## 1651                                                                                                                                                                                                                                                     There's quite an arse theme within your response, Fern.
    ## 1652                                                                                                                                                                                                                                              "Leave." "Sod off." It says "go away." This says "bugger off".
    ## 1653                                                                                                                                                                                                                  Gloria Gaynor should have been more aggressive. She should have said, "Go on, bugger off."
    ## 1654                                                                                                                                                                                                                                                                                     Fuck. Guys, here we go.
    ## 1655                                                                                                                                                                                                                                                   There's another little bugger. There he is, hello. Hello.
    ## 1656                                                                                                                                                                                                                                                                                                Oh, damn it!
    ## 1657                                                                                                                                                                                                                                                                                    Fucked that one up. Bye!
    ## 1658                                                                                                                                                                                                A lot of surgeons are alcoholics, so it probably feels like they have big hands on an especially pissed day.
    ## 1659                                                                                                                                                                                                                                                                                               Fucking hell.
    ## 1660                                                                                                                                                                                                                           Yeah, what that picture doesn't show is that I've got flippers for fucking hands!
    ## 1661                                                                                                                                                                                                                                                                                    What the fuck's in that?
    ## 1662                                                                                                                                                                                                                                                                                        You absolute wanker!
    ## 1663                                                                                                                                                                                                     "What the fuck is that?" "Did you hear that? Well, what dropped?" "You can't even buy them that small."
    ## 1664                                                                                                                                                                                                                                       There is only one size of duck. I don't know what the fuck they were.
    ## 1665                                                                                                                                                                                                                                                            I can't see me pockets 'cause of me tits. Sorry.
    ## 1666                                                                                                                                                                                                                                                                        What the hell?! I didn't get any in.
    ## 1667                                                                                                                                                                                   I mean, if I'm honest, I don't know what I thought 'cause all I can hear is, "I can't see my pockets because of my tits."
    ## 1668                                                                                                                                                                                                                             People in hotels think you should be up at eight o'clock, 'cause they're dicks.
    ## 1669                                                                                                                                                                                                                                                 All right, Dara. This should be a piece of piss, I imagine?
    ## 1670                                                                                                                                                                                                                                                                                      Two minutes? OK. Shit.
    ## 1671                                                                                                                                                                                                                                                                                                   Ah, shit!
    ## 1672                                                                                                                                                                                                                                                                       Oh, God, what the fuck are you doing?
    ## 1673                                                                                                                                                                                                                                                                                           Oh, fucking hell.
    ## 1674                                                                                                                                                                                                                                                                             Just move up nearer to my arse.
    ## 1675                                                                                                                                                                                                                                                                                            Ah, fuck's sake.
    ## 1676                                                                                                                                                                                                                                                                                  We've been fucking robbed.
    ## 1677                                                                                                                                                                                                                                                                      There's so much fucking sand in there.
    ## 1678                                                                                                                                                                                                                                                                 Goddamn! What's been going on in this room?
    ## 1679                                                                                                                                                                                                                                                                                      What the fuck is that?
    ## 1680                                                                                                                                                                                                                                                                                       That is fucking vile.
    ## 1681                                                                                                                                                                                                                                                                     I don't do olives. Tiny, shitty grapes.
    ## 1682                                                                                                                                                                                                                                                                                            Oh, bugger hell.
    ## 1683                                                                                                                                                                                                                                                                       Fucking salt and petrol or something.
    ## 1684                                                                                                                                                                                                         Sarah, the very first thing you said after you tasted one is, and I quote, "What the fuck is that?"
    ## 1685                                                                                                                                                                                                                                                                     Like, "Ooh, what the fuck is that? Mm."
    ## 1686                                                                                                                                                                                                                                                                                           Oh, Jesus Christ!
    ## 1687                                                                                                                                                                                                                                                           Mine's better. Mine's always better. That's shit.
    ## 1688                                                                                                                                                                                                                                                                                            Oh, fuck's sake.
    ## 1689                                                                                                                                                                                                                                                                                                   Oh, fuck!
    ## 1690                                                                                                                                                                                                                                                                                                   Oh, shit.
    ## 1691                                                                                                                                                                                                                                                                               Something's fucking happened!
    ## 1692                                                                                                                                                                                                                                                                     You whispered to yourself, "Fuck sake."
    ## 1693                                                                                                                                                                                                                               I particularly liked the... romance of that with this twat in the background.
    ## 1694                                                                                                                                                                                                                 He really did try, but someone didn't put enough power into their fucking throws, did they?
    ## 1695                                                                                                                                                                                                                                                                                                Fuck's sake.
    ## 1696                                                                                                                                                                                                                                                                                           Ugh, fuck's sake.
    ## 1697                                                                                                                                                                                                                                                                                What the hell am I gonna do?
    ## 1698                                                                                                                                                                                                                                                                                                       Fuck!
    ## 1699                                                                                                                                                                                                                                               Oh, my god, I've found it! Oh, you dicks! Oh, I hate you all.
    ## 1700                                                                                                                                                                                                                                                                                          That's fulla shit.
    ## 1701                                                                                                                                                                                                                                                                             Fuck is that? What's happening?
    ## 1702                                                                                                                                                                                                                                                                                                       Fuck.
    ## 1703                                                                                                                                                                                                                                                 ♪ The lady on the phone said, "What? Get here, you prick" ♪
    ## 1704                                                                                                                                                                                                                                                                                                   Oh, shit.
    ## 1705                                                                                                                                                                                                                                 Who was it who said you sound awful at singing? Well, fuck you, ex-partner.
    ## 1706                                                                                                                                                                                    It's probably that I'm not street enough to appreciate rap, and also I don't know what the hell Dara was going on about.
    ## 1707                                                                                                                                                                                                                                                                                                   Oh, fuck.
    ## 1708                                                                                                                                                                                                                                                                                               Jesus Christ.
    ## 1709                                                                                                                                                                                                                                                              Fuck me, imagine I get this. Genuine pleasure.
    ## 1710                                                                                                                                                                                                                                                                                                       Shit!
    ## 1711                                                                                                                                                                                                                                                                                                Oh, fuck it!
    ## 1712                                                                                                                                                                                                                                                                                                   Oh, fuck.
    ## 1713                                                                                                                                                                                                                          I just said to John, "Who did that shit drawing?" And he was like, "That was you."
    ## 1714                                                                                                                                                                                                                                                                             I can do that, easy. Piss-easy.
    ## 1715                                                                                                                                                                                                                                                                                                   Fuck off.
    ## 1716                                                                                                                                                         It really annoys me, 'cause I think, "Oh, it's just shit", and then I'll do some and I'll be like, "Oh, I feel a bit better", then I think, "Fuck!"
    ## 1717                                                                                                                                                                                If I was giving bonus points out anymore, which I don't do, you'd be getting one for telling Alex to fuck off so poetically.
    ## 1718                                                                                                                                                                                                                                                                                       Go on, you...bastard.
    ## 1719                                                                                                                                                                                                                                                You know, I just wanted to give you the whole damn Olympics.
    ## 1720                                                                                                                                                                                                                  I shouldn't give clues, but this is the shittest impression of that animal I've ever seen.
    ## 1721                                                                                                                                                                                                                                                                                              Shit is weird.
    ## 1722                                                                                                                                                                                                                                                                             Fuck this. No, you're mad. Huh?
    ## 1723                                                                                                                                                                                                                                                           I quote John during the actual task: "Fuck this!"
    ## 1724                                                                                                                                                                                                                                                                                         Gives me the shits?
    ## 1725                                                                                                                                                                                                                                                                                                       Arse.
    ## 1726                                                                                                                                                                                                                                  We've caught the moment where Dara realized that he's totally fucked this.
    ## 1727                                                                                                                                                                                                                                                             And you all had a big fuckin' party about that.
    ## 1728                                                                                                                                                                                                                                                         What the hell? Alex? Shit. Okay, I need to go back.
    ## 1729                                                                                                                                                                                                                                                                                                Fuck's sake!
    ## 1730                                                                                                                                                                                                                                                                                                Ooh, bugger.
    ## 1731                                                                                                                                                                                                                                                                                   Christ, what was I doing?
    ## 1732                                                                                                                                                                          If you're a comedian, one of the things you need... is the skill of holding in your piss for long amounts of time on car journeys.
    ## 1733                                                                                                                                                                                                                                                                                         Look at this prick.
    ## 1734                                                                                                                                                                                                                                                                                                       Shit.
    ## 1735                                                                                                                                                                                                                                                         That is gonna get beaten by a fucking sailor's hat.
    ## 1736                                                                                                                                                                                                                                                                                                 Oh, Christ.
    ## 1737                                                                                                                                                                                                                                                                                                Bloody hell.
    ## 1738                                                                                                                                                                                                                                                           Oh, I went hell for leather. Fuck those balloons!
    ## 1739                                                                                                                                                                                                                                                                                    Oof, god damn. God damn.
    ## 1740                                                                                                                                                                                                                                                                                          Yo. What the hell?
    ## 1741                                                                                                                                                                                                                                                                                                   Oh, damn.
    ## 1742                                                                                                                                                                                                                                                                                            Ooh, shit, shit.
    ## 1743                                                                                                                                                                                                                                                                                                   Oh, shit.
    ## 1744                                                                                                                                                                                                                                                                                                   Oh, shit!
    ## 1745                                                                                                                                                                                                                                                                                Jesus Christ! We've done it!
    ## 1746                                                                                                                                                                                                                                                                                            Christ almighty!
    ## 1747                                                                                                                                                                                                                                                  You wouldn't take some prick with a blow-up walking stick.
    ## 1748                                                                                                                                                                                                                                                                                           Oh, Jesus Christ.
    ## 1749                                                                                                                                                                                                                                              It's around here. You started... pissing yourself around here.
    ## 1750                                                                                                                                                                                           And that affected your system here of looking for your hands when you had your own fucking hands in front of you?
    ## 1751                                                                                                                                                                                                                                                                                           What in the hell?
    ## 1752                                                                                                                                                                                                                                    I genuinely just thought it was funny to look like I was wanking a cock.
    ## 1753                                                                                                                                                                                                                                                                               I'm pissed with anticipation.
    ## 1754                                                                                                                                                                                                                                       Is this longer than a minute? Oh, I thought you were taking the piss.
    ## 1755                                                                                                                                                                                              This is what I wrote down: "Dara looks like he's gonna turn his head inside-out, but the speed of the fucker!"
    ## 1756                                                                                                                                                                                                                                             Mine was, do you know what? Mine's piss-easy, there's no lines.
    ## 1757                                                                                                                                                                                                                                                                                               Oh, you dick.
    ## 1758                                                                                                                                                                                                                                    "My cat died last year, but I don't miss it because it was an arsehole."
    ## 1759                                                                                                                                                                                                             "But when she went into the home, she made me take it, even though he was always a dick to me."
    ## 1760                                                                                                                                                                                                                                             "I check my phone. Seven missed calls from the home. Oh, shit."
    ## 1761                                                                                                                                                                                                                                       Initially when I opened it, I said, "Oh, shit, there's nothing here."
    ## 1762                                                                                                                                                                                                                                 And Munya, well, to use an old showbiz term, he's fucked you over big time.
    ## 1763                                                                                                                                                                                                                                               I can paint with a big brush, and if I shit meself, I'm fine.
    ## 1764                                                                                                                                                                                                                                                                                               Jesus Christ!
    ## 1765                                                                                                                                                                                                                                                                                    Er, ooh, er, ee... shit!
    ## 1766                                                                                                                                                                                                                                                                                             Fucking Christ.
    ## 1767                                                                                                                                                                                                                                                                                What the hell? They're fake!
    ## 1768                                                                                                                                                                                                                                           "Eat the grape"? Oh, fuck. There's no way that was there earlier.
    ## 1769                                                                                                                                                                                                                                                                               Obviously absolute horseshit.
    ## 1770                                                                                                                                                                                                                                                            Aw, buggeration! That would've been really good.
    ## 1771                                                                                                                                                                                                                 You've just said "buggeration" as well, so it'd be good if you put another coin back in it.
    ## 1772                                                                                                                                                                                                                                                                 You're gonna get my tits on your shoulders.
    ## 1773                                                                                                                                                                                                                                                                                               Jesus Christ.
    ## 1774                                                                                                                                                                                                                                                                                                   No! Shit!
    ## 1775                                                                                                                                                                                                                                                       MUNYA: Oh, yeah! What the hell? Did I order Vaseline?
    ## 1776                                                                                                                                                                                                                                                                                               Jesus Christ.
    ## 1777                                                                                                                                                                                                                                                                                               Ooh, fuck it!
    ## 1778                                                                                                                                                                                                                                                                                                    Fuck it.
    ## 1779                                                                                                                                                                                                                                              So, yeah, the pen and paper is fucking useless then, isn't it?
    ## 1780                                                                                                                                                                                                                                                                                           Oh, fucking hell.
    ## 1781                                                                                                                                                                                                                                                     Let's talk about how shit your pirate impressions were.
    ## 1782                                                                                                                                                                                                                                                                                            That is so shit.
    ## 1783                                                                                                                                                                                                                                                                                             Nah, it's shit.
    ## 1784                                                                                                                                                                                                                        And I was actually buying time 'cause I didn't know what the fuck carp pellets were.
    ## 1785                                                                                                                                                                                                                                                                                               Oh, bollocks.
    ## 1786                                                                                                                                                                                                                                                                                                 Argh! Fuck!
    ## 1787                                                                                                                                                                                                                                                                                               Fucking hell.
    ## 1788                                                                                                                                                                                                                                                                                  Yes! Fuck you, Greg James.
    ## 1789                                                                                                                                                                                          Well, I was worried about your career when you were just the weird jerky clockwork lady who kept shouting, "Fuck!"
    ## 1790                                                                                                                                                                                              The thing is you never see your own arse from any other angle, really, than the one you choose to see it from.
    ## 1791                                                                                                                                                                                                                                                                                                   Oh, fuck!
    ## 1792                                                                                                                                                                                                                                                                                     Fuck! Give us a minute.
    ## 1793                                                                                                                                                                                                                                                                                        Oh, for fuck's sake.
    ## 1794                                                                                                                                                                                                                                                                  And now it's over to prick-tionary corner.
    ## 1795                                                                                                                                                                                                                                           Christ almighty. It's very rare I've got nothing negative to say.
    ## 1796                                                                                                                                                                                                                                                     I watched it and I felt it as well. I felt it was shit.
    ## 1797                                                                                                                                                                        The one place you lost me was when you started crying at the end 'cause I thought, "Okay, well, Mae's lost their fucking mind here."
    ## 1798                                                                                                                                                                                                                                                                                         Damn and blast you!
    ## 1799                                                                                                                                                                                                                                         I've said it before, I'll say it again, Frankie, the guy's a prick.
    ## 1800                                                                                                                                                                                                                                                                                          Damn, that's neat!
    ## 1801                                                                                                                                                                No tricks? I mean, the awful trick would be if, at the end of all this, you said, "Now wind it all back up", and I say, "Fuck off, you sod."
    ## 1802                                                                                                                                                                                                                                                                                            Oh, bloody hell.
    ## 1803                                                                                                                                                                                                                              I put that, uh, "Mae lost their goddamn mind", is what I wrote down initially.
    ## 1804                                                                                                                                                                                                                                                                                        OK, OK, you bastard.
    ## 1805                                                                                                                                                                                           Some of the other things she said was, "Back, back. Come on, pony. Calm the flip down, Jenny. Spin, bitch, spin."
    ## 1806                                                                                                                                                                                                                                                                                   Whoa. Yes! Piece of piss.
    ## 1807                                                                                                                                                                                                                                              I don't... I've never said "piece of piss," that's so English.
    ## 1808                                                                                                                                                                                                                                                                        Even "piece of piss" felt dignified.
    ## 1809                                                                                                                                                                                                                                                        Jesus Christ. Are we the meat, or are we the viewer?
    ## 1810                                                                                                                                                                                                                                                     Bloody hell. Yes, it's more complicated than you think.
    ## 1811                                                                                                                                                                                                                                                         Oh, Christ, that is so hard, I enjoyed all of them.
    ## 1812                                                                                                                                                                                                                        And I'm gonna give Frankie and Mae four points. I've literally lost my goddamn mind.
    ## 1813                                                                                                                                                                                                                         As the clever one, you start planning and I go and get a whole load of random shit.
    ## 1814                                                                                                                                                                                              Yeah, let's get them out of the way, being all nice to each other. Then we can get onto this fucking shitshow.
    ## 1815                                                                                                                                                                                                                                                                     It looks like there's shit on this one.
    ## 1816                                                                                                                                                                                                                                                                         I-I'm putting this down. Fuck that.
    ## 1817                                                                                                                                                                                                                                            Yeah, the first three! And then the fourth one was fucking sick!
    ## 1818                                                                                                                                                                                                                                                                                                Shit's sake!
    ## 1819                                                                                                                                                                                                                                                                                                       Fuck.
    ## 1820                                                                                                                                                                                                                                                       How the hell can I score a chocolate face above this?
    ## 1821                                                                                                                                                                                                                                                                                               Fuckin' hell.
    ## 1822                                                                                                                                                                                                                                                     So it's just between the glasses... and that shit cape.
    ## 1823                                                                                                                                                                                                                                                                             I don't think mine's that shit.
    ## 1824                                                                                                                                                                                                                                                 I don't think mine's that shit, and I designed them myself.
    ## 1825                                                                                                                                                                                                                                                                                       Oh, get fucked, mate.
    ## 1826                                                                                                                                                                                                                                  "The conveyor belt will start moving in three minutes from now." OK. Fuck!
    ## 1827                                                                                                                                                                                                                                                      Oh, I fucking... they're not going in the fucking hat!
    ## 1828                                                                                                                                                                                                                                                                                                   Ah, shit!
    ## 1829                                                                                                                                                                                                                                                                                               No, no. Fuck!
    ## 1830                                                                                                                                                                                                                                                                               No, no, fuck, I lost it. Yes.
    ## 1831                                                                                                                                                                                                                                    There would be a way. There would be a fucking way and I haven't got it!
    ## 1832                                                                                                                                                                                                                                                                               There's some damn good beats.
    ## 1833                                                                                                                                                                                                                                   I mean, honestly, Kiell, you are having a fucking nightmare on this show.
    ## 1834                                                                                                                                                                                                                  That's clearly where I've gone wrong with fishing... I should be throwing the fucking rod.
    ## 1835                                                                                                                                                                                                                                         There's only one thing for this, then: decorate the fuck out of it.
    ## 1836                                                                                                                                                                                               Mae's boat looked like the most buoyant object ever created, but it is "one shit boat", is what I wrote down.
    ## 1837                                                                                                                                                                                                                                              Oh, I'm not standing for this. I'm not standing for this shit!
    ## 1838                                                                                                                                                                                                                                                                   It's not fair to penalise the short arse.
    ## 1839                                                                                                                                                                                                                                                                                  Bugger. Bugger! Poor show.
    ## 1840                                                                                                                                                                                                                                                                                    Has fucking John got it?
    ## 1841                                                                                                                                                                                                                                                                        I won't be pissing against the door.
    ## 1842                                                                                                                                                                                                                                                                 I don't wanna get this shit in my trainers.
    ## 1843                                                                                                                                                                                                                                                                    Why would you get shit in your trainers?
    ## 1844                                                                                                                                                                                                                                                             It's like having a really worryingly long piss.
    ## 1845                                                                                                                                                                                                                     Do you know, I thought this was gonna be shit telly but I'm actually quite enjoying it.
    ## 1846                                                                                                                                                                                                                                                                                                   Fuck off!
    ## 1847                                                                                                                                                                                                                                    "If I ever meet him at a TV event, I'm gonna teach that pussy to dance."
    ## 1848                                                                                                                                                                                                                                                                                  And what the fuck is that?
    ## 1849                                                                                                                                                                                                                                                                              What was the fucking last one?
    ## 1850                                                                                                                                                                                                                                                                                                       Shit.
    ## 1851                                                                                                                                                                                                                                                                           I'm gonna fucking kick off, Alex.
    ## 1852                                                                                                                                                                                                                                                         What did I tell you not to do?! You greedy bastard!
    ## 1853                                                                                                                                                                                          We're both going to lose this episode, and someone is gonna go up there and win 70 grand on a fucking scratchcard.
    ## 1854                                                                                                                                                                                                                                       End of sentence. It's shit. That is... that is a disappointing start.
    ## 1855                                                                                                                                                                                                                                                                                               Fuckin' hell.
    ## 1856                                                                                                                                                                                                                                                                                 No, Andy! Oh, Jesus Christ!
    ## 1857                                                                                                                                                                                                                               And then Frankie, fucking hell... that "Jesus Christ" was genuinely too much.
    ## 1858                                                                                                                                                                                    When Frankie shouted "Jesus Christ", I actually out loud went, "Oh, my god!" And therefore he must take the five points.
    ## 1859                                                                                                                                                                                                                                                          It looks like I'm wanking off an egg with my foot.
    ## 1860                                                                                                                                                                                                                                                                 Oh, god, it really does. No, fuck this. OK.
    ## 1861                                                                                                                                                                                                                                                     Kicking the ball with my golden shoes. Oh, bloody hell!
    ## 1862                                                                                                                                                                                                                                                                                            Yeah, fuck this.
    ## 1863                                                                                                                                                                                                                                                                                  Oh, fuck it, pulp the egg!
    ## 1864                                                                                                                                                                                                                                                                       Oh, shit! Why didn't I think of that?
    ## 1865                                                                                                                                                                                                                              Oh, Jesus Christ, that's the most disgusting thing I've ever eaten in my life.
    ## 1866                                                                                                                                                                                                                                            I... I wasn't putting fucking broccoli jelly babies in my mouth.
    ## 1867                                                                                                                                                                                                                                                                                  Really fuckin' unpleasant.
    ## 1868                                                                                                                                                 You know, a lot of plane crashes happen because the copilot is too scared to say to the brash pilot, "Look, we're gonna hit the fucking ground here, mate."
    ## 1869                                                                                                                                                                                                                                                                                           Christ! The time!
    ## 1870                                                                                                                                                                                                                                            I'm gonna cook that fucking potato 'cause it's got to be edible.
    ## 1871                                                                                                                                                                                                                                                   I don't think I clapped, I don't think I fucking clapped.
    ## 1872                                                                                                                                                                                                                        I've had very few points for LOLs-based prize tasks, so here's some goddamn feeling.
    ## 1873                                                                                                                                                                                                                                                                                           Who gives a fuck?
    ## 1874                                                                                                                                                                                                                                                                            Oh, not more fucking pineapples.
    ## 1875                                                                                                                                                                                                                                                                                                  Ahh! Fuck!
    ## 1876                                                                                                                                                                                                                                                                                                Fuck's sake.
    ## 1877                                                                                                                                                                                                                                       I know that a lot will depend on this, so I'm going to go big bugger.
    ## 1878                                                                                                                                                                                                                                                          That's more than your bowl and your fuckin' spoon.
    ## 1879                                                                                                                                                                                                                                                                                                   Aw, fuck.
    ## 1880                                                                                                                                                                                                                                                                   Are you doing a stamp? Fucking brilliant.
    ## 1881                                                                                                                                                                                                                                                                                   Why am I so shit at this?
    ## 1882                                                                                                                                                                                                                                                                  Oh, shit. We got some yellow on the mango.
    ## 1883                                                                                                                                                                                                            Smaller team, wetter conditions, better outside-the-box thinking... give us some fucking points.
    ## 1884                                                                                                                                                                                                                                                                              Shit! Fuck! Why did I do that?
    ## 1885                                                                                                                                                                                                                                                                               Dan Jones is a piece of shit.
    ## 1886                                                                                                                                                                                                                                             All we know is that he was some sort of brutal English bastard.
    ## 1887                                                                                                                                                                                        But because I enjoyed both your lecutres, despite them being clearly horse shit, I'm gonna give you two points each.
    ## 1888                                                                                                                                                                                                                                                                           There's quite a lot of bird shit.
    ## 1889                                                                                                                                                                                                                                                                         Did you actually shit in some milk?
    ## 1890                                                                                                                                                                                                                                                                               I'm just going to write shit.
    ## 1891                                                                                                                                                                                                                                                         You just couldn't shut the fuck up, could you, Ivo?
    ## 1892                                                                                                                                                                                                                             "I'm coming to your shit party in six years! I'm gonna do a poo in the carpet."
    ## 1893                                                                                                                                                                                                                                                                                      Take that, damn pooch!
    ## 1894                                                                                                                                                                                                                                                                                      I hate this woke shit.
    ## 1895                                                                                                                                                                                                                                                                      I bet no other bastard used that hose.
    ## 1896                                                                                                                                                                                                                                                       Oh, shit! Oh, my god. Ah! Make it shop. The children!
    ## 1897                                                                                                                                                                                                                                                                                                       Shit!
    ## 1898                                                                                                                                                                                                                                                                                                 Oh, Christ.
    ## 1899                                                                                                                                                                                                                                I've done the fucking sum wrong. I've done the fucking sum wrong, haven't I?
    ## 1900                                                                                                                                                                                                                                                                                    You fucking weird freak.
    ## 1901                                                                                                                                                                                                                                                                       ♪ Dog walker, go the fuck to sleep. ♪
    ## 1902                                                                                                                                                                                                                                                                       ♪ Dog walker, go the fuck to sleep. ♪
    ## 1903                                                                                                                                                                                                               Damn, they fought hard. And for one of them, their tenacious tasking was actually worthwhile.
    ## 1904                                                                                                                                                                                                                                                                          Oh, Christ. Oh, yeah, here we are.
    ## 1905                                                                                                                                                                                                                                                                                      Oh, am I...? Oh, shit.
    ## 1906                                                                                                                                                                                                                                                                                                   Oh, shit.
    ## 1907                                                                                                                                                                                                                                                                                     This is bullshit, dude.
    ## 1908                                                                                                                                                                                                                                                                   What an absolute shower of shits you are.
    ## 1909                                                                                                                                                                                                                   You also quoted the Bible. Er, "you absolute shower of shits", that's Book of Revelation.
    ## 1910                                                                                                                                                                                                                                                                                            You shit giblet.
    ## 1911                                                                                                                                                                                                                                               I enjoyed you calling him a "shit giblet", though. Very nice.
    ## 1912                                                                                                                                                                                                                                                                               "Or a flamingo?" Bloody hell.
    ## 1913                                                                                                                                                                                                                                                                             Don't touch the beak? Ah, shit.
    ## 1914                                                                                                                                                                                                                                                                            Oh, it's very... you utter shit!
    ## 1915                                                                                                                                                                                                                                                                                                       Shit.
    ## 1916                                                                                                                                                                                                                                                               Oh, sh‒no, you can see it's not. Oh, bastard.
    ## 1917                                                                                                                                                                                                                                                              It's the sign of... Cock Pond, Clapham Common.
    ## 1918                                                                                                                                                                                                                                                                                           I like Cock Pond.
    ## 1919                                                                                                                                                                                                                                                                    Sue, pond full of cocks‒can you beat it?
    ## 1920                                                                                                                                                                                                                                             Is there a, erm, landlord or a landlady at the Dog and Bastard?
    ## 1921                                                                                                                                                                                                                                                                   Jesus Christ, that is low-rent, isn't it?
    ## 1922                                                                                                                                                                                                                                                        And, unbelievably, I'm giving Cock Pond four points.
    ## 1923                                                                                                                                                                                                                                                                                             Cock and balls.
    ## 1924                                                                                                                                                                                                                                         And then she's done a cheeky bit of ocean and a cheeky bit of Hell.
    ## 1925                                                                                                                                                                                                                                                               That's a cheeky tick. Erm, why is Hell there?
    ## 1926                                                                                                                                                                                                                                                                                      Well, Hell is... here.
    ## 1927                                                                                                                                                                                                                                    I think you were hampered by bad actors. They all looked bored shitless.
    ## 1928                                                                                                                                                                                                                                                                                                   Oh, shit.
    ## 1929                                                                                                                                                                                                                                                                     But how the hell am I gonna score that?
    ## 1930                                                                                                                                                                                                                                                                                               Jesus Christ.
    ## 1931                                                                                                                                                                                                                          Why would a small dog be given a chew, and why does that chew look like two dicks?
    ## 1932                                                                                                                                                                            Julian has developed an incredible technique for saying things to Alex that are seemingly innocent, but then yet are so damning.
    ## 1933                                                                                                                                                                                                                                                                                     It stings like a bitch.
    ## 1934                                                                                                                                                                                                                                                                                                   Oh, fuck.
    ## 1935                                                                                                                                                                                                                                                                            "Fuck Pig", I used to be called.
    ## 1936                                                                                                                                                                                                                                                            And then, out of nowhere, "Oh, hello, Fuck Pig".
    ## 1937                                                                                                                                                                                                                                                                                              Chain Bastard.
    ## 1938                                                                                                                                                                                                                                                                           Why are you called Chain Bastard?
    ## 1939                                                                                                                                                                                                                                                                                                    Damn it!
    ## 1940                                                                                                                                                                                                                                                                                              Chain Bastard.
    ## 1941                                                                                                                                                                                                                                                                                    Ah. Is it Chain Bastard?
    ## 1942                                                                                                                                                                                                                                                                                        It is Chain Bastard.
    ## 1943                                                                                                                                                                                                                                                                                                    Damn it!
    ## 1944                                                                                                                                                                                                                                                                                              Chain Bastard.
    ## 1945                                                                                                                                                          Even when you essentially hold someone against their will and give yourself the name Chain Bastard... you just still seem really fun and friendly.
    ## 1946                                                                                                                                                                                                                                                   I was surprised that Chain Bastard was applying feathers.
    ## 1947                                                                                                                                                                                                                                                                              Chain Bastard gets two points.
    ## 1948                                                                                                                                                                                                                                                             You're really up against it now, Chain Bastard.
    ## 1949                                                                                                                                                                                                                                                                                      You're a mucky bugger!
    ## 1950                                                                                                                                                                                                                                                                               Lucy, "Oh, you mucky bugger."
    ## 1951                                                                                                                                                                                                                                                                                     Damn, that smells good!
    ## 1952                                                                                                                                                                                                                                                                                   I'm feeling a real prick.
    ## 1953                                                                                                                                                                                                          This is one of the most exhausting things I've ever done. Why didn't I just draw a cock and balls?
    ## 1954                                                                                                                                                                                                                                                                        I was doing fucking poppies, I know.
    ## 1955                                                                                                                                                                                                                                             That is a hell of an opener, Sam. It's gonna take some beating.
    ## 1956                                                                                                                                                                                                                                                                                                Bloody hell.
    ## 1957                                                                                                                                                                                                                                                                                       Genuinely a shit pet.
    ## 1958                                                                                                                                                                                                                                               And then, my dog got hold of Terry and ate the ass out of it.
    ## 1959                                                                                                                                                                                                                                                                                       Come on, you bastard!
    ## 1960                                                                                                                                                                                                                                                                                          Fuck, that sucked.
    ## 1961                                                                                                                                                                                                                                                                                              Hell's Angels.
    ## 1962                                                                                                                                                                                                                                                      This one has a massive eye-bollock. It's just massive.
    ## 1963                                                                                                                                                                                                                                               So if you're low-down, the beaver's eye-bollock will see you.
    ## 1964                                                                                                                                                                                                                                                                      I've got a beaver with an eye-bollock!
    ## 1965                                                                                                                                                                                                                                                                                     Big Billy Big Bollocks.
    ## 1966                                                                                                                                                                                                                                                                                     Big Billy Big Bollocks?
    ## 1967                                                                                                                                                                                                                                                                                               Jesus Christ.
    ## 1968                                                                                                                                                                                                                                                                Ah, lookie here, fellas, a two-eyed bastard.
    ## 1969                                                                                                                                                                                                                                                                                                That's shit.
    ## 1970                                                                                                                                                                                                                  Is that where the bloody candle starts growing a fucking mouth and starts doing it for me?
    ## 1971                                                                                                                                                                                                                                                        How the hell does that hap...? What have I created?!
    ## 1972                                                                                                                                                                                                                                                   Yeah, that was a hell of a task, man. That was fantastic.
    ## 1973                                                                                                                                                                                                                                                                                                Fuck's sake!
    ## 1974                                                                                                                                                                                                                                                                  This is gonna be a hell of a noise, right?
    ## 1975                                                                                                                                                                                                                                                                                 Busy little shit, isn't it?
    ## 1976                                                                                                                                                                                                                                                                                       Oh, shit. Oh, Christ.
    ## 1977                                                                                                                                                                                                                                                                                        Oh, for fuck's sake.
    ## 1978                                                                                                                                                                                                                                                                                                       Tits!
    ## 1979                                                                                                                                                                                                                                                        Sam, I don't know how the hell you got to flamingos.
    ## 1980                                                                                                                                                                                                                                            I've written down, "Can I have a clip of Susan shouting 'tits'?"
    ## 1981                                                                                                                                                                                                                  Sometimes you should just see it and judge it on face value, 'cause now I think it's shit.
    ## 1982                                                                                                                                                                                                                                                                                                   Fuck you.
    ## 1983                                                                                                                                                                                                                                                                                             Damn you, RADA.
    ## 1984                                                                                                                                                                                                                                                                                             Damn you, RADA.
    ## 1985                                                                                                                                                                                                                            If this Australian has three pineapples on him, I am gonna lose my fucking mind.
    ## 1986                                                                                                                                                                                                                                                             Come on, come on. Groan, you feckless bastards!
    ## 1987                                                                                                                                                                                                                                                                      And here are a few of the shit prizes.
    ## 1988                                                                                                                                                                                                                                      They're all so shit that all these guys actually gave them back to me.
    ## 1989                                                                                                                                                                                                                       I'm gonna give her 4 points for her very clever idea of getting her shit prizes back.
    ## 1990                                                                                                                                                                                                                                                                                       OK. Ah, ooh. Piss it!
    ## 1991                                                                                                                                                                                                                     I really think that "piss it" is an underrated exclamation. I really enjoyed "piss it".
    ## 1992                                                                                                                                                                                                                                              I can't work under these conditions. Oh, my God. Fuckin' hell!
    ## 1993                                                                                                                                                                                                                                                                                        Fuckin' hell! Sorry.
    ## 1994                                                                                                                                                                                                                                                                  Yeah, you've really fucked Sam over there.
    ## 1995                                                                                                                                                                                                                                                                                        Oh, shit, there's...
    ## 1996                                                                                                                                                                                                                                                                                 Now, what the hell is that?
    ## 1997                                                                                                                                                                                                                                                                I loved it. I was shit at it but I loved it.
    ## 1998                                                                                                                                                                                                                                                                                   Come on, you little shit!
    ## 1999                                                                                                                                                                                                                                                                                                 Oh, Christ.
    ## 2000                                                                                                                                                                                                                                                                                                   Oh, shit.
    ## 2001                                                                                                                                                                                                                                                                                              Little fucker.
    ## 2002                                                                                                                                                                                                                                                                              "Take it, you little fucker."?
    ## 2003                                                                                                                                                                                                                                                                      It caught me by surprise, bloody hell.
    ## 2004                                                                                                                                                                                                                                                                                               Oh, fuck you.
    ## 2005                                                                                                                                                                                                                                                                                          Ahh! Fucking hell!
    ## 2006                                                                                                                                                                                                                                                        What the hell have you both got in for Sam Campbell?
    ## 2007                                                                                                                                                                                                                                                                                                Oh, fuck it.
    ## 2008                                                                                                                                                                                                                                                                               Damn your syntactical vortex!
    ## 2009                                                                                                                                                                                                                                          Erm, what I wrote about you, Sue, is you "lost your goddamn mind".
    ## 2010                                                                                                                                                                                   I just really liked the idea of stuffing a massive stick up a mannequin's arse and rotating it like a rotisserie chicken.
    ## 2011                                                                                                                                                                          You've just given me an awful insight into your upbringing, and then you brought me a plate full of shit, that's what you've done.
    ## 2012                                                                                                                                                                                                                                        Can you beat a plateful of shit, a taped security number, a soldier?
    ## 2013                                                                                                                                                                                                                                                   I think it might have the edge over a plate full of shit.
    ## 2014                                                                                                                                                                                                         It'll come as little surprise that the thing I want to take home least is a big pile of mouse shit.
    ## 2015                                                                                                                                                                                                                                                                              Oh, I'm gonna push this bitch.
    ## 2016                                                                                                                                                                                                                           There were things that surprised me about the intro: "I'm gonna push this bitch."
    ## 2017                                                                                                                                                                                                                                                                                              What the hell?
    ## 2018                                                                                                                                                                                                                                                                               What the hell? That was good!
    ## 2019                                                                                                                                                                                                                                                                            His hat was pissing me off, man.
    ## 2020                                                                                                                                                                                                                                                                      He's a spiteful little shit, isn't he?
    ## 2021                                                                                                                                                                                                                                                                             You really did push that bitch.
    ## 2022                                                                                                                                                                                                                                                         She was an exhausted bitch by the time we finished.
    ## 2023                                                                                                                                                                                                                                              She pushed the bitch for a total of 11 minutes and 43 seconds.
    ## 2024                                                                                                                                                                                                                                                                                       Oh, fuck, fuck! Fuck.
    ## 2025                                                                                                                                                                                                                                    And then I just thought, "I have just become the biggest cock on Earth."
    ## 2026                                                                                                                                                                                                                                                You look so nice, but underneath it all, you're just a shit.
    ## 2027                                                                                                                                                                                                                                                                                            Cheesecake tits.
    ## 2028                                                                                                                                                                                                                                                             A penis, brackets cock ring or cheese triangle.
    ## 2029                                                                                                                                                                                                                                                                                               Jesus Christ.
    ## 2030                                                                                                                                                                                                                                                                        They've all got beaver piss in them?
    ## 2031                                                                                                                                                                                                                           Genuinely might make me feel moved with an urn that's got "shit" written on it...
    ## 2032                                                                                                                                                                                                                                                                                                   Fuck 'em.
    ## 2033                                                                                                                                                                                                                                                                                               Jesus Christ.
    ## 2034                                                                                                                                                                                                                                                    Erm, bite it apart and then shove the rest up your arse.
    ## 2035                                                                                                                                                                                                                                                                         May the power of Christ compel you.
    ## 2036                                                                                                                                                                                                                                                                         May the power of Christ compel you.
    ## 2037                                                                                                                                                                                                                                                                         May the power of Christ compel you.
    ## 2038                                                                                                                                                                                                                                                                         May the power of Christ compel you.
    ## 2039                                                                                                                                                                                                                                                                         May the power of Christ compel you.
    ## 2040                                                                                                                                                                                                                                                                                           "Punch the Cunt".
    ## 2041                                                                                                                                                                                                                                                                             Running a business is bullshit.
    ##      studio
    ## 1         1
    ## 2         1
    ## 3         1
    ## 4         1
    ## 5         1
    ## 6         1
    ## 7         0
    ## 8         0
    ## 9         0
    ## 10        1
    ## 11        0
    ## 12        1
    ## 13        0
    ## 14        1
    ## 15        1
    ## 16        1
    ## 17        1
    ## 18        1
    ## 19        1
    ## 20        0
    ## 21        1
    ## 22        1
    ## 23        1
    ## 24        1
    ## 25        0
    ## 26        1
    ## 27        1
    ## 28        1
    ## 29        1
    ## 30        1
    ## 31        0
    ## 32        1
    ## 33        1
    ## 34        1
    ## 35        1
    ## 36        1
    ## 37        1
    ## 38        1
    ## 39        0
    ## 40        0
    ## 41        0
    ## 42        1
    ## 43        1
    ## 44        1
    ## 45        1
    ## 46        1
    ## 47        0
    ## 48        0
    ## 49        0
    ## 50        0
    ## 51        1
    ## 52        1
    ## 53        1
    ## 54        1
    ## 55        1
    ## 56        1
    ## 57        1
    ## 58        1
    ## 59        0
    ## 60        0
    ## 61        1
    ## 62        0
    ## 63        0
    ## 64        0
    ## 65        0
    ## 66        0
    ## 67        0
    ## 68        0
    ## 69        1
    ## 70        0
    ## 71        0
    ## 72        0
    ## 73        0
    ## 74        0
    ## 75        0
    ## 76        1
    ## 77        1
    ## 78        1
    ## 79        1
    ## 80        1
    ## 81        1
    ## 82        1
    ## 83        1
    ## 84        1
    ## 85        1
    ## 86        0
    ## 87        0
    ## 88        1
    ## 89        1
    ## 90        1
    ## 91        0
    ## 92        0
    ## 93        1
    ## 94        1
    ## 95        0
    ## 96        0
    ## 97        1
    ## 98        1
    ## 99        1
    ## 100       0
    ## 101       1
    ## 102       0
    ## 103       1
    ## 104       1
    ## 105       1
    ## 106       1
    ## 107       1
    ## 108       0
    ## 109       0
    ## 110       0
    ## 111       0
    ## 112       0
    ## 113       0
    ## 114       0
    ## 115       1
    ## 116       1
    ## 117       1
    ## 118       0
    ## 119       0
    ## 120       0
    ## 121       1
    ## 122       0
    ## 123       0
    ## 124       0
    ## 125       1
    ## 126       0
    ## 127       0
    ## 128       1
    ## 129       1
    ## 130       0
    ## 131       0
    ## 132       1
    ## 133       1
    ## 134       1
    ## 135       0
    ## 136       0
    ## 137       1
    ## 138       0
    ## 139       0
    ## 140       1
    ## 141       0
    ## 142       0
    ## 143       1
    ## 144       1
    ## 145       1
    ## 146       0
    ## 147       0
    ## 148       0
    ## 149       0
    ## 150       0
    ## 151       0
    ## 152       0
    ## 153       0
    ## 154       0
    ## 155       1
    ## 156       1
    ## 157       1
    ## 158       1
    ## 159       0
    ## 160       0
    ## 161       1
    ## 162       1
    ## 163       0
    ## 164       0
    ## 165       0
    ## 166       0
    ## 167       0
    ## 168       0
    ## 169       0
    ## 170       1
    ## 171       1
    ## 172       1
    ## 173       0
    ## 174       0
    ## 175       1
    ## 176       0
    ## 177       0
    ## 178       1
    ## 179       1
    ## 180       0
    ## 181       0
    ## 182       1
    ## 183       1
    ## 184       1
    ## 185       1
    ## 186       1
    ## 187       1
    ## 188       0
    ## 189       1
    ## 190       0
    ## 191       0
    ## 192       0
    ## 193       0
    ## 194       0
    ## 195       1
    ## 196       0
    ## 197       1
    ## 198       0
    ## 199       1
    ## 200       1
    ## 201       1
    ## 202       1
    ## 203       0
    ## 204       1
    ## 205       1
    ## 206       0
    ## 207       1
    ## 208       0
    ## 209       0
    ## 210       0
    ## 211       1
    ## 212       1
    ## 213       1
    ## 214       1
    ## 215       0
    ## 216       0
    ## 217       0
    ## 218       0
    ## 219       0
    ## 220       1
    ## 221       0
    ## 222       0
    ## 223       0
    ## 224       0
    ## 225       1
    ## 226       1
    ## 227       0
    ## 228       0
    ## 229       1
    ## 230       1
    ## 231       1
    ## 232       1
    ## 233       0
    ## 234       1
    ## 235       1
    ## 236       1
    ## 237       0
    ## 238       1
    ## 239       0
    ## 240       1
    ## 241       1
    ## 242       1
    ## 243       1
    ## 244       0
    ## 245       1
    ## 246       1
    ## 247       0
    ## 248       0
    ## 249       0
    ## 250       1
    ## 251       1
    ## 252       0
    ## 253       0
    ## 254       0
    ## 255       0
    ## 256       1
    ## 257       1
    ## 258       1
    ## 259       1
    ## 260       1
    ## 261       1
    ## 262       1
    ## 263       1
    ## 264       1
    ## 265       0
    ## 266       0
    ## 267       1
    ## 268       1
    ## 269       1
    ## 270       0
    ## 271       1
    ## 272       0
    ## 273       0
    ## 274       0
    ## 275       0
    ## 276       1
    ## 277       1
    ## 278       1
    ## 279       1
    ## 280       1
    ## 281       1
    ## 282       0
    ## 283       0
    ## 284       1
    ## 285       1
    ## 286       0
    ## 287       1
    ## 288       1
    ## 289       0
    ## 290       1
    ## 291       1
    ## 292       1
    ## 293       0
    ## 294       0
    ## 295       1
    ## 296       1
    ## 297       0
    ## 298       1
    ## 299       0
    ## 300       1
    ## 301       1
    ## 302       1
    ## 303       1
    ## 304       1
    ## 305       1
    ## 306       1
    ## 307       1
    ## 308       1
    ## 309       0
    ## 310       1
    ## 311       1
    ## 312       1
    ## 313       1
    ## 314       0
    ## 315       0
    ## 316       1
    ## 317       1
    ## 318       0
    ## 319       0
    ## 320       1
    ## 321       1
    ## 322       0
    ## 323       0
    ## 324       0
    ## 325       0
    ## 326       1
    ## 327       1
    ## 328       1
    ## 329       1
    ## 330       1
    ## 331       0
    ## 332       0
    ## 333       1
    ## 334       1
    ## 335       1
    ## 336       1
    ## 337       1
    ## 338       1
    ## 339       0
    ## 340       1
    ## 341       1
    ## 342       0
    ## 343       1
    ## 344       1
    ## 345       1
    ## 346       1
    ## 347       1
    ## 348       1
    ## 349       1
    ## 350       1
    ## 351       1
    ## 352       1
    ## 353       1
    ## 354       0
    ## 355       0
    ## 356       1
    ## 357       1
    ## 358       0
    ## 359       1
    ## 360       1
    ## 361       1
    ## 362       1
    ## 363       0
    ## 364       1
    ## 365       0
    ## 366       0
    ## 367       1
    ## 368       1
    ## 369       0
    ## 370       1
    ## 371       1
    ## 372       1
    ## 373       0
    ## 374       0
    ## 375       1
    ## 376       0
    ## 377       1
    ## 378       1
    ## 379       0
    ## 380       0
    ## 381       1
    ## 382       0
    ## 383       1
    ## 384       1
    ## 385       1
    ## 386       0
    ## 387       1
    ## 388       1
    ## 389       1
    ## 390       0
    ## 391       0
    ## 392       0
    ## 393       0
    ## 394       0
    ## 395       1
    ## 396       1
    ## 397       1
    ## 398       0
    ## 399       1
    ## 400       1
    ## 401       1
    ## 402       1
    ## 403       1
    ## 404       0
    ## 405       0
    ## 406       0
    ## 407       1
    ## 408       1
    ## 409       1
    ## 410       0
    ## 411       1
    ## 412       1
    ## 413       1
    ## 414       1
    ## 415       0
    ## 416       1
    ## 417       1
    ## 418       1
    ## 419       1
    ## 420       1
    ## 421       1
    ## 422       1
    ## 423       1
    ## 424       1
    ## 425       0
    ## 426       1
    ## 427       0
    ## 428       1
    ## 429       1
    ## 430       1
    ## 431       0
    ## 432       1
    ## 433       1
    ## 434       1
    ## 435       0
    ## 436       0
    ## 437       1
    ## 438       1
    ## 439       1
    ## 440       1
    ## 441       1
    ## 442       0
    ## 443       0
    ## 444       0
    ## 445       1
    ## 446       0
    ## 447       1
    ## 448       1
    ## 449       0
    ## 450       0
    ## 451       1
    ## 452       1
    ## 453       1
    ## 454       1
    ## 455       1
    ## 456       1
    ## 457       1
    ## 458       1
    ## 459       1
    ## 460       1
    ## 461       1
    ## 462       1
    ## 463       0
    ## 464       0
    ## 465       1
    ## 466       1
    ## 467       1
    ## 468       0
    ## 469       0
    ## 470       0
    ## 471       1
    ## 472       1
    ## 473       1
    ## 474       1
    ## 475       1
    ## 476       1
    ## 477       1
    ## 478       1
    ## 479       0
    ## 480       1
    ## 481       1
    ## 482       1
    ## 483       1
    ## 484       1
    ## 485       1
    ## 486       1
    ## 487       0
    ## 488       1
    ## 489       0
    ## 490       0
    ## 491       1
    ## 492       1
    ## 493       1
    ## 494       0
    ## 495       0
    ## 496       1
    ## 497       0
    ## 498       1
    ## 499       0
    ## 500       0
    ## 501       1
    ## 502       1
    ## 503       1
    ## 504       1
    ## 505       0
    ## 506       0
    ## 507       0
    ## 508       0
    ## 509       1
    ## 510       1
    ## 511       1
    ## 512       1
    ## 513       1
    ## 514       0
    ## 515       1
    ## 516       1
    ## 517       0
    ## 518       0
    ## 519       0
    ## 520       1
    ## 521       1
    ## 522       1
    ## 523       0
    ## 524       1
    ## 525       1
    ## 526       1
    ## 527       0
    ## 528       0
    ## 529       0
    ## 530       0
    ## 531       0
    ## 532       1
    ## 533       1
    ## 534       1
    ## 535       1
    ## 536       1
    ## 537       1
    ## 538       1
    ## 539       1
    ## 540       1
    ## 541       0
    ## 542       0
    ## 543       0
    ## 544       0
    ## 545       0
    ## 546       1
    ## 547       0
    ## 548       1
    ## 549       1
    ## 550       1
    ## 551       1
    ## 552       0
    ## 553       1
    ## 554       1
    ## 555       1
    ## 556       1
    ## 557       1
    ## 558       1
    ## 559       1
    ## 560       1
    ## 561       0
    ## 562       0
    ## 563       0
    ## 564       0
    ## 565       0
    ## 566       0
    ## 567       0
    ## 568       0
    ## 569       0
    ## 570       0
    ## 571       1
    ## 572       1
    ## 573       1
    ## 574       1
    ## 575       1
    ## 576       0
    ## 577       1
    ## 578       0
    ## 579       0
    ## 580       0
    ## 581       1
    ## 582       1
    ## 583       1
    ## 584       0
    ## 585       0
    ## 586       0
    ## 587       1
    ## 588       0
    ## 589       0
    ## 590       0
    ## 591       1
    ## 592       1
    ## 593       1
    ## 594       1
    ## 595       1
    ## 596       1
    ## 597       1
    ## 598       1
    ## 599       0
    ## 600       1
    ## 601       0
    ## 602       1
    ## 603       0
    ## 604       0
    ## 605       0
    ## 606       0
    ## 607       1
    ## 608       1
    ## 609       1
    ## 610       1
    ## 611       0
    ## 612       0
    ## 613       1
    ## 614       1
    ## 615       0
    ## 616       1
    ## 617       1
    ## 618       1
    ## 619       0
    ## 620       0
    ## 621       0
    ## 622       0
    ## 623       0
    ## 624       1
    ## 625       1
    ## 626       1
    ## 627       0
    ## 628       0
    ## 629       0
    ## 630       1
    ## 631       0
    ## 632       0
    ## 633       0
    ## 634       1
    ## 635       1
    ## 636       1
    ## 637       0
    ## 638       1
    ## 639       0
    ## 640       0
    ## 641       0
    ## 642       0
    ## 643       0
    ## 644       0
    ## 645       0
    ## 646       0
    ## 647       1
    ## 648       1
    ## 649       0
    ## 650       0
    ## 651       0
    ## 652       1
    ## 653       1
    ## 654       1
    ## 655       1
    ## 656       0
    ## 657       0
    ## 658       0
    ## 659       0
    ## 660       0
    ## 661       0
    ## 662       0
    ## 663       0
    ## 664       1
    ## 665       1
    ## 666       0
    ## 667       1
    ## 668       0
    ## 669       0
    ## 670       1
    ## 671       1
    ## 672       1
    ## 673       1
    ## 674       1
    ## 675       0
    ## 676       0
    ## 677       1
    ## 678       1
    ## 679       1
    ## 680       1
    ## 681       1
    ## 682       1
    ## 683       1
    ## 684       1
    ## 685       1
    ## 686       1
    ## 687       0
    ## 688       1
    ## 689       1
    ## 690       0
    ## 691       0
    ## 692       0
    ## 693       1
    ## 694       1
    ## 695       0
    ## 696       0
    ## 697       0
    ## 698       0
    ## 699       1
    ## 700       0
    ## 701       1
    ## 702       1
    ## 703       1
    ## 704       1
    ## 705       1
    ## 706       0
    ## 707       1
    ## 708       1
    ## 709       0
    ## 710       0
    ## 711       0
    ## 712       0
    ## 713       0
    ## 714       1
    ## 715       1
    ## 716       0
    ## 717       0
    ## 718       1
    ## 719       0
    ## 720       1
    ## 721       0
    ## 722       1
    ## 723       1
    ## 724       1
    ## 725       1
    ## 726       1
    ## 727       1
    ## 728       1
    ## 729       0
    ## 730       1
    ## 731       0
    ## 732       1
    ## 733       1
    ## 734       1
    ## 735       1
    ## 736       1
    ## 737       1
    ## 738       1
    ## 739       1
    ## 740       1
    ## 741       1
    ## 742       1
    ## 743       0
    ## 744       1
    ## 745       0
    ## 746       1
    ## 747       1
    ## 748       1
    ## 749       1
    ## 750       1
    ## 751       1
    ## 752       1
    ## 753       1
    ## 754       1
    ## 755       1
    ## 756       1
    ## 757       1
    ## 758       1
    ## 759       0
    ## 760       0
    ## 761       0
    ## 762       1
    ## 763       1
    ## 764       1
    ## 765       1
    ## 766       1
    ## 767       0
    ## 768       0
    ## 769       1
    ## 770       1
    ## 771       1
    ## 772       1
    ## 773       0
    ## 774       1
    ## 775       1
    ## 776       1
    ## 777       1
    ## 778       0
    ## 779       1
    ## 780       0
    ## 781       0
    ## 782       0
    ## 783       1
    ## 784       1
    ## 785       1
    ## 786       1
    ## 787       1
    ## 788       1
    ## 789       1
    ## 790       1
    ## 791       1
    ## 792       1
    ## 793       0
    ## 794       0
    ## 795       1
    ## 796       1
    ## 797       1
    ## 798       1
    ## 799       0
    ## 800       0
    ## 801       0
    ## 802       0
    ## 803       1
    ## 804       1
    ## 805       1
    ## 806       1
    ## 807       1
    ## 808       1
    ## 809       1
    ## 810       1
    ## 811       0
    ## 812       1
    ## 813       1
    ## 814       1
    ## 815       1
    ## 816       1
    ## 817       1
    ## 818       1
    ## 819       1
    ## 820       1
    ## 821       1
    ## 822       1
    ## 823       0
    ## 824       0
    ## 825       1
    ## 826       1
    ## 827       0
    ## 828       1
    ## 829       0
    ## 830       1
    ## 831       1
    ## 832       1
    ## 833       1
    ## 834       1
    ## 835       1
    ## 836       0
    ## 837       0
    ## 838       0
    ## 839       0
    ## 840       0
    ## 841       0
    ## 842       1
    ## 843       1
    ## 844       0
    ## 845       1
    ## 846       1
    ## 847       1
    ## 848       1
    ## 849       1
    ## 850       1
    ## 851       0
    ## 852       0
    ## 853       1
    ## 854       1
    ## 855       0
    ## 856       1
    ## 857       0
    ## 858       0
    ## 859       1
    ## 860       1
    ## 861       0
    ## 862       0
    ## 863       0
    ## 864       0
    ## 865       0
    ## 866       0
    ## 867       0
    ## 868       0
    ## 869       0
    ## 870       1
    ## 871       1
    ## 872       1
    ## 873       1
    ## 874       1
    ## 875       1
    ## 876       1
    ## 877       1
    ## 878       0
    ## 879       0
    ## 880       0
    ## 881       0
    ## 882       1
    ## 883       1
    ## 884       1
    ## 885       0
    ## 886       1
    ## 887       0
    ## 888       0
    ## 889       1
    ## 890       1
    ## 891       0
    ## 892       0
    ## 893       1
    ## 894       0
    ## 895       0
    ## 896       1
    ## 897       1
    ## 898       1
    ## 899       1
    ## 900       1
    ## 901       1
    ## 902       0
    ## 903       0
    ## 904       0
    ## 905       0
    ## 906       1
    ## 907       0
    ## 908       0
    ## 909       1
    ## 910       1
    ## 911       1
    ## 912       1
    ## 913       1
    ## 914       1
    ## 915       1
    ## 916       1
    ## 917       0
    ## 918       1
    ## 919       1
    ## 920       0
    ## 921       0
    ## 922       0
    ## 923       0
    ## 924       0
    ## 925       0
    ## 926       1
    ## 927       1
    ## 928       1
    ## 929       1
    ## 930       0
    ## 931       1
    ## 932       0
    ## 933       1
    ## 934       1
    ## 935       1
    ## 936       0
    ## 937       0
    ## 938       0
    ## 939       0
    ## 940       0
    ## 941       1
    ## 942       0
    ## 943       0
    ## 944       1
    ## 945       1
    ## 946       0
    ## 947       1
    ## 948       0
    ## 949       0
    ## 950       0
    ## 951       1
    ## 952       1
    ## 953       1
    ## 954       1
    ## 955       1
    ## 956       1
    ## 957       1
    ## 958       1
    ## 959       0
    ## 960       0
    ## 961       0
    ## 962       1
    ## 963       1
    ## 964       1
    ## 965       0
    ## 966       1
    ## 967       1
    ## 968       1
    ## 969       1
    ## 970       0
    ## 971       1
    ## 972       0
    ## 973       0
    ## 974       0
    ## 975       0
    ## 976       0
    ## 977       0
    ## 978       0
    ## 979       0
    ## 980       1
    ## 981       1
    ## 982       1
    ## 983       1
    ## 984       1
    ## 985       1
    ## 986       0
    ## 987       0
    ## 988       0
    ## 989       0
    ## 990       0
    ## 991       0
    ## 992       1
    ## 993       1
    ## 994       1
    ## 995       0
    ## 996       1
    ## 997       1
    ## 998       1
    ## 999       1
    ## 1000      1
    ## 1001      1
    ## 1002      1
    ## 1003      1
    ## 1004      1
    ## 1005      1
    ## 1006      0
    ## 1007      1
    ## 1008      0
    ## 1009      0
    ## 1010      0
    ## 1011      1
    ## 1012      1
    ## 1013      0
    ## 1014      0
    ## 1015      1
    ## 1016      1
    ## 1017      1
    ## 1018      0
    ## 1019      0
    ## 1020      1
    ## 1021      1
    ## 1022      1
    ## 1023      1
    ## 1024      1
    ## 1025      0
    ## 1026      1
    ## 1027      0
    ## 1028      0
    ## 1029      1
    ## 1030      1
    ## 1031      1
    ## 1032      1
    ## 1033      1
    ## 1034      1
    ## 1035      1
    ## 1036      1
    ## 1037      1
    ## 1038      0
    ## 1039      0
    ## 1040      0
    ## 1041      0
    ## 1042      0
    ## 1043      0
    ## 1044      1
    ## 1045      0
    ## 1046      0
    ## 1047      1
    ## 1048      1
    ## 1049      1
    ## 1050      1
    ## 1051      0
    ## 1052      1
    ## 1053      1
    ## 1054      1
    ## 1055      1
    ## 1056      1
    ## 1057      1
    ## 1058      1
    ## 1059      1
    ## 1060      1
    ## 1061      1
    ## 1062      1
    ## 1063      1
    ## 1064      1
    ## 1065      1
    ## 1066      1
    ## 1067      1
    ## 1068      0
    ## 1069      0
    ## 1070      0
    ## 1071      0
    ## 1072      0
    ## 1073      1
    ## 1074      1
    ## 1075      0
    ## 1076      1
    ## 1077      0
    ## 1078      0
    ## 1079      1
    ## 1080      1
    ## 1081      1
    ## 1082      1
    ## 1083      0
    ## 1084      0
    ## 1085      0
    ## 1086      0
    ## 1087      1
    ## 1088      1
    ## 1089      1
    ## 1090      1
    ## 1091      1
    ## 1092      1
    ## 1093      0
    ## 1094      0
    ## 1095      0
    ## 1096      0
    ## 1097      1
    ## 1098      1
    ## 1099      1
    ## 1100      1
    ## 1101      0
    ## 1102      1
    ## 1103      0
    ## 1104      0
    ## 1105      1
    ## 1106      0
    ## 1107      0
    ## 1108      1
    ## 1109      1
    ## 1110      1
    ## 1111      1
    ## 1112      1
    ## 1113      0
    ## 1114      0
    ## 1115      1
    ## 1116      0
    ## 1117      0
    ## 1118      1
    ## 1119      1
    ## 1120      1
    ## 1121      1
    ## 1122      1
    ## 1123      0
    ## 1124      1
    ## 1125      1
    ## 1126      0
    ## 1127      1
    ## 1128      0
    ## 1129      0
    ## 1130      0
    ## 1131      0
    ## 1132      0
    ## 1133      1
    ## 1134      1
    ## 1135      1
    ## 1136      1
    ## 1137      1
    ## 1138      1
    ## 1139      1
    ## 1140      1
    ## 1141      0
    ## 1142      0
    ## 1143      1
    ## 1144      1
    ## 1145      1
    ## 1146      1
    ## 1147      0
    ## 1148      1
    ## 1149      1
    ## 1150      1
    ## 1151      1
    ## 1152      0
    ## 1153      1
    ## 1154      1
    ## 1155      1
    ## 1156      0
    ## 1157      1
    ## 1158      1
    ## 1159      0
    ## 1160      1
    ## 1161      0
    ## 1162      1
    ## 1163      1
    ## 1164      1
    ## 1165      1
    ## 1166      0
    ## 1167      1
    ## 1168      0
    ## 1169      0
    ## 1170      1
    ## 1171      0
    ## 1172      0
    ## 1173      0
    ## 1174      1
    ## 1175      0
    ## 1176      0
    ## 1177      0
    ## 1178      1
    ## 1179      0
    ## 1180      1
    ## 1181      0
    ## 1182      0
    ## 1183      1
    ## 1184      1
    ## 1185      1
    ## 1186      0
    ## 1187      1
    ## 1188      0
    ## 1189      0
    ## 1190      0
    ## 1191      1
    ## 1192      1
    ## 1193      1
    ## 1194      1
    ## 1195      1
    ## 1196      1
    ## 1197      0
    ## 1198      1
    ## 1199      1
    ## 1200      1
    ## 1201      1
    ## 1202      1
    ## 1203      0
    ## 1204      0
    ## 1205      0
    ## 1206      1
    ## 1207      1
    ## 1208      0
    ## 1209      1
    ## 1210      0
    ## 1211      1
    ## 1212      0
    ## 1213      0
    ## 1214      0
    ## 1215      1
    ## 1216      1
    ## 1217      1
    ## 1218      0
    ## 1219      1
    ## 1220      1
    ## 1221      0
    ## 1222      1
    ## 1223      0
    ## 1224      1
    ## 1225      1
    ## 1226      1
    ## 1227      1
    ## 1228      1
    ## 1229      0
    ## 1230      1
    ## 1231      0
    ## 1232      0
    ## 1233      0
    ## 1234      0
    ## 1235      0
    ## 1236      0
    ## 1237      1
    ## 1238      1
    ## 1239      0
    ## 1240      0
    ## 1241      0
    ## 1242      0
    ## 1243      0
    ## 1244      0
    ## 1245      0
    ## 1246      0
    ## 1247      0
    ## 1248      0
    ## 1249      0
    ## 1250      0
    ## 1251      0
    ## 1252      1
    ## 1253      1
    ## 1254      1
    ## 1255      1
    ## 1256      0
    ## 1257      0
    ## 1258      0
    ## 1259      0
    ## 1260      0
    ## 1261      0
    ## 1262      0
    ## 1263      1
    ## 1264      0
    ## 1265      0
    ## 1266      0
    ## 1267      0
    ## 1268      0
    ## 1269      1
    ## 1270      1
    ## 1271      1
    ## 1272      1
    ## 1273      0
    ## 1274      1
    ## 1275      1
    ## 1276      1
    ## 1277      1
    ## 1278      0
    ## 1279      0
    ## 1280      1
    ## 1281      1
    ## 1282      1
    ## 1283      1
    ## 1284      0
    ## 1285      0
    ## 1286      0
    ## 1287      1
    ## 1288      1
    ## 1289      1
    ## 1290      1
    ## 1291      0
    ## 1292      1
    ## 1293      0
    ## 1294      1
    ## 1295      1
    ## 1296      1
    ## 1297      0
    ## 1298      1
    ## 1299      0
    ## 1300      0
    ## 1301      0
    ## 1302      0
    ## 1303      1
    ## 1304      1
    ## 1305      0
    ## 1306      1
    ## 1307      1
    ## 1308      1
    ## 1309      1
    ## 1310      1
    ## 1311      1
    ## 1312      1
    ## 1313      0
    ## 1314      0
    ## 1315      1
    ## 1316      0
    ## 1317      1
    ## 1318      0
    ## 1319      0
    ## 1320      0
    ## 1321      0
    ## 1322      0
    ## 1323      0
    ## 1324      0
    ## 1325      0
    ## 1326      1
    ## 1327      1
    ## 1328      1
    ## 1329      1
    ## 1330      1
    ## 1331      1
    ## 1332      0
    ## 1333      1
    ## 1334      1
    ## 1335      1
    ## 1336      0
    ## 1337      0
    ## 1338      1
    ## 1339      1
    ## 1340      0
    ## 1341      0
    ## 1342      1
    ## 1343      0
    ## 1344      1
    ## 1345      0
    ## 1346      1
    ## 1347      0
    ## 1348      1
    ## 1349      1
    ## 1350      1
    ## 1351      0
    ## 1352      0
    ## 1353      0
    ## 1354      0
    ## 1355      0
    ## 1356      0
    ## 1357      0
    ## 1358      0
    ## 1359      0
    ## 1360      1
    ## 1361      1
    ## 1362      0
    ## 1363      1
    ## 1364      1
    ## 1365      1
    ## 1366      1
    ## 1367      1
    ## 1368      0
    ## 1369      1
    ## 1370      1
    ## 1371      0
    ## 1372      1
    ## 1373      1
    ## 1374      0
    ## 1375      0
    ## 1376      0
    ## 1377      1
    ## 1378      1
    ## 1379      1
    ## 1380      1
    ## 1381      1
    ## 1382      1
    ## 1383      1
    ## 1384      1
    ## 1385      0
    ## 1386      1
    ## 1387      1
    ## 1388      0
    ## 1389      0
    ## 1390      1
    ## 1391      0
    ## 1392      0
    ## 1393      0
    ## 1394      0
    ## 1395      1
    ## 1396      0
    ## 1397      0
    ## 1398      0
    ## 1399      0
    ## 1400      0
    ## 1401      0
    ## 1402      1
    ## 1403      1
    ## 1404      1
    ## 1405      1
    ## 1406      1
    ## 1407      0
    ## 1408      0
    ## 1409      0
    ## 1410      1
    ## 1411      1
    ## 1412      1
    ## 1413      0
    ## 1414      1
    ## 1415      0
    ## 1416      0
    ## 1417      1
    ## 1418      1
    ## 1419      1
    ## 1420      0
    ## 1421      0
    ## 1422      0
    ## 1423      0
    ## 1424      0
    ## 1425      0
    ## 1426      0
    ## 1427      0
    ## 1428      0
    ## 1429      1
    ## 1430      1
    ## 1431      1
    ## 1432      0
    ## 1433      0
    ## 1434      0
    ## 1435      0
    ## 1436      0
    ## 1437      1
    ## 1438      1
    ## 1439      1
    ## 1440      0
    ## 1441      0
    ## 1442      1
    ## 1443      1
    ## 1444      0
    ## 1445      1
    ## 1446      1
    ## 1447      0
    ## 1448      0
    ## 1449      0
    ## 1450      0
    ## 1451      1
    ## 1452      1
    ## 1453      1
    ## 1454      1
    ## 1455      0
    ## 1456      0
    ## 1457      0
    ## 1458      0
    ## 1459      1
    ## 1460      1
    ## 1461      1
    ## 1462      0
    ## 1463      0
    ## 1464      0
    ## 1465      0
    ## 1466      1
    ## 1467      1
    ## 1468      1
    ## 1469      1
    ## 1470      1
    ## 1471      1
    ## 1472      1
    ## 1473      1
    ## 1474      0
    ## 1475      1
    ## 1476      1
    ## 1477      1
    ## 1478      0
    ## 1479      0
    ## 1480      0
    ## 1481      1
    ## 1482      1
    ## 1483      1
    ## 1484      1
    ## 1485      1
    ## 1486      0
    ## 1487      0
    ## 1488      1
    ## 1489      0
    ## 1490      0
    ## 1491      0
    ## 1492      0
    ## 1493      1
    ## 1494      1
    ## 1495      1
    ## 1496      1
    ## 1497      1
    ## 1498      0
    ## 1499      0
    ## 1500      1
    ## 1501      1
    ## 1502      1
    ## 1503      1
    ## 1504      1
    ## 1505      1
    ## 1506      0
    ## 1507      0
    ## 1508      0
    ## 1509      1
    ## 1510      1
    ## 1511      1
    ## 1512      1
    ## 1513      0
    ## 1514      1
    ## 1515      0
    ## 1516      1
    ## 1517      0
    ## 1518      1
    ## 1519      1
    ## 1520      1
    ## 1521      1
    ## 1522      1
    ## 1523      0
    ## 1524      0
    ## 1525      0
    ## 1526      0
    ## 1527      1
    ## 1528      1
    ## 1529      1
    ## 1530      1
    ## 1531      1
    ## 1532      0
    ## 1533      0
    ## 1534      1
    ## 1535      1
    ## 1536      1
    ## 1537      1
    ## 1538      1
    ## 1539      0
    ## 1540      0
    ## 1541      1
    ## 1542      1
    ## 1543      1
    ## 1544      1
    ## 1545      0
    ## 1546      1
    ## 1547      1
    ## 1548      0
    ## 1549      1
    ## 1550      0
    ## 1551      0
    ## 1552      0
    ## 1553      0
    ## 1554      1
    ## 1555      1
    ## 1556      1
    ## 1557      1
    ## 1558      0
    ## 1559      1
    ## 1560      0
    ## 1561      1
    ## 1562      0
    ## 1563      1
    ## 1564      1
    ## 1565      1
    ## 1566      0
    ## 1567      1
    ## 1568      0
    ## 1569      0
    ## 1570      1
    ## 1571      0
    ## 1572      0
    ## 1573      1
    ## 1574      1
    ## 1575      1
    ## 1576      0
    ## 1577      0
    ## 1578      1
    ## 1579      0
    ## 1580      0
    ## 1581      1
    ## 1582      1
    ## 1583      1
    ## 1584      1
    ## 1585      0
    ## 1586      1
    ## 1587      1
    ## 1588      0
    ## 1589      0
    ## 1590      1
    ## 1591      1
    ## 1592      1
    ## 1593      0
    ## 1594      1
    ## 1595      0
    ## 1596      0
    ## 1597      0
    ## 1598      1
    ## 1599      1
    ## 1600      1
    ## 1601      1
    ## 1602      1
    ## 1603      0
    ## 1604      1
    ## 1605      1
    ## 1606      1
    ## 1607      1
    ## 1608      0
    ## 1609      0
    ## 1610      0
    ## 1611      0
    ## 1612      0
    ## 1613      0
    ## 1614      0
    ## 1615      1
    ## 1616      1
    ## 1617      1
    ## 1618      1
    ## 1619      1
    ## 1620      1
    ## 1621      1
    ## 1622      1
    ## 1623      1
    ## 1624      1
    ## 1625      1
    ## 1626      1
    ## 1627      1
    ## 1628      1
    ## 1629      1
    ## 1630      1
    ## 1631      1
    ## 1632      0
    ## 1633      1
    ## 1634      1
    ## 1635      0
    ## 1636      0
    ## 1637      0
    ## 1638      0
    ## 1639      0
    ## 1640      1
    ## 1641      1
    ## 1642      0
    ## 1643      0
    ## 1644      0
    ## 1645      0
    ## 1646      1
    ## 1647      1
    ## 1648      1
    ## 1649      0
    ## 1650      0
    ## 1651      1
    ## 1652      0
    ## 1653      1
    ## 1654      0
    ## 1655      0
    ## 1656      0
    ## 1657      0
    ## 1658      0
    ## 1659      0
    ## 1660      1
    ## 1661      0
    ## 1662      0
    ## 1663      1
    ## 1664      1
    ## 1665      0
    ## 1666      0
    ## 1667      1
    ## 1668      1
    ## 1669      1
    ## 1670      0
    ## 1671      0
    ## 1672      0
    ## 1673      1
    ## 1674      0
    ## 1675      0
    ## 1676      0
    ## 1677      0
    ## 1678      0
    ## 1679      0
    ## 1680      0
    ## 1681      0
    ## 1682      0
    ## 1683      0
    ## 1684      1
    ## 1685      1
    ## 1686      0
    ## 1687      0
    ## 1688      0
    ## 1689      0
    ## 1690      0
    ## 1691      0
    ## 1692      1
    ## 1693      1
    ## 1694      1
    ## 1695      1
    ## 1696      0
    ## 1697      0
    ## 1698      0
    ## 1699      0
    ## 1700      0
    ## 1701      0
    ## 1702      0
    ## 1703      0
    ## 1704      1
    ## 1705      1
    ## 1706      1
    ## 1707      1
    ## 1708      1
    ## 1709      0
    ## 1710      0
    ## 1711      0
    ## 1712      0
    ## 1713      1
    ## 1714      0
    ## 1715      0
    ## 1716      1
    ## 1717      1
    ## 1718      0
    ## 1719      0
    ## 1720      1
    ## 1721      1
    ## 1722      0
    ## 1723      1
    ## 1724      0
    ## 1725      0
    ## 1726      1
    ## 1727      1
    ## 1728      0
    ## 1729      0
    ## 1730      0
    ## 1731      1
    ## 1732      1
    ## 1733      1
    ## 1734      1
    ## 1735      1
    ## 1736      1
    ## 1737      0
    ## 1738      1
    ## 1739      0
    ## 1740      0
    ## 1741      0
    ## 1742      0
    ## 1743      1
    ## 1744      1
    ## 1745      0
    ## 1746      0
    ## 1747      1
    ## 1748      0
    ## 1749      0
    ## 1750      1
    ## 1751      0
    ## 1752      1
    ## 1753      1
    ## 1754      0
    ## 1755      1
    ## 1756      0
    ## 1757      0
    ## 1758      0
    ## 1759      0
    ## 1760      0
    ## 1761      1
    ## 1762      1
    ## 1763      0
    ## 1764      1
    ## 1765      0
    ## 1766      0
    ## 1767      0
    ## 1768      0
    ## 1769      1
    ## 1770      0
    ## 1771      0
    ## 1772      0
    ## 1773      0
    ## 1774      0
    ## 1775      0
    ## 1776      1
    ## 1777      1
    ## 1778      1
    ## 1779      0
    ## 1780      0
    ## 1781      1
    ## 1782      0
    ## 1783      1
    ## 1784      1
    ## 1785      0
    ## 1786      0
    ## 1787      0
    ## 1788      0
    ## 1789      1
    ## 1790      1
    ## 1791      1
    ## 1792      1
    ## 1793      1
    ## 1794      1
    ## 1795      1
    ## 1796      1
    ## 1797      1
    ## 1798      0
    ## 1799      1
    ## 1800      0
    ## 1801      0
    ## 1802      0
    ## 1803      1
    ## 1804      0
    ## 1805      1
    ## 1806      0
    ## 1807      1
    ## 1808      1
    ## 1809      1
    ## 1810      0
    ## 1811      1
    ## 1812      1
    ## 1813      0
    ## 1814      1
    ## 1815      0
    ## 1816      0
    ## 1817      1
    ## 1818      1
    ## 1819      1
    ## 1820      1
    ## 1821      1
    ## 1822      1
    ## 1823      1
    ## 1824      1
    ## 1825      1
    ## 1826      0
    ## 1827      0
    ## 1828      0
    ## 1829      0
    ## 1830      0
    ## 1831      0
    ## 1832      1
    ## 1833      1
    ## 1834      1
    ## 1835      0
    ## 1836      1
    ## 1837      1
    ## 1838      0
    ## 1839      0
    ## 1840      0
    ## 1841      1
    ## 1842      1
    ## 1843      1
    ## 1844      1
    ## 1845      1
    ## 1846      1
    ## 1847      1
    ## 1848      0
    ## 1849      0
    ## 1850      0
    ## 1851      1
    ## 1852      0
    ## 1853      1
    ## 1854      1
    ## 1855      1
    ## 1856      0
    ## 1857      1
    ## 1858      1
    ## 1859      0
    ## 1860      0
    ## 1861      0
    ## 1862      1
    ## 1863      0
    ## 1864      1
    ## 1865      0
    ## 1866      1
    ## 1867      0
    ## 1868      1
    ## 1869      0
    ## 1870      0
    ## 1871      1
    ## 1872      1
    ## 1873      1
    ## 1874      0
    ## 1875      0
    ## 1876      1
    ## 1877      0
    ## 1878      1
    ## 1879      1
    ## 1880      0
    ## 1881      0
    ## 1882      0
    ## 1883      1
    ## 1884      0
    ## 1885      1
    ## 1886      0
    ## 1887      1
    ## 1888      0
    ## 1889      1
    ## 1890      0
    ## 1891      1
    ## 1892      1
    ## 1893      1
    ## 1894      1
    ## 1895      0
    ## 1896      0
    ## 1897      0
    ## 1898      0
    ## 1899      0
    ## 1900      0
    ## 1901      0
    ## 1902      0
    ## 1903      1
    ## 1904      0
    ## 1905      0
    ## 1906      0
    ## 1907      0
    ## 1908      0
    ## 1909      1
    ## 1910      0
    ## 1911      1
    ## 1912      0
    ## 1913      0
    ## 1914      1
    ## 1915      1
    ## 1916      1
    ## 1917      1
    ## 1918      1
    ## 1919      1
    ## 1920      1
    ## 1921      1
    ## 1922      1
    ## 1923      1
    ## 1924      1
    ## 1925      1
    ## 1926      1
    ## 1927      1
    ## 1928      1
    ## 1929      1
    ## 1930      1
    ## 1931      1
    ## 1932      1
    ## 1933      1
    ## 1934      0
    ## 1935      0
    ## 1936      1
    ## 1937      0
    ## 1938      0
    ## 1939      0
    ## 1940      0
    ## 1941      0
    ## 1942      0
    ## 1943      0
    ## 1944      0
    ## 1945      1
    ## 1946      1
    ## 1947      1
    ## 1948      1
    ## 1949      0
    ## 1950      1
    ## 1951      0
    ## 1952      1
    ## 1953      0
    ## 1954      1
    ## 1955      1
    ## 1956      1
    ## 1957      1
    ## 1958      1
    ## 1959      0
    ## 1960      0
    ## 1961      1
    ## 1962      0
    ## 1963      1
    ## 1964      1
    ## 1965      1
    ## 1966      1
    ## 1967      1
    ## 1968      0
    ## 1969      0
    ## 1970      0
    ## 1971      0
    ## 1972      1
    ## 1973      1
    ## 1974      1
    ## 1975      0
    ## 1976      0
    ## 1977      0
    ## 1978      0
    ## 1979      1
    ## 1980      1
    ## 1981      1
    ## 1982      1
    ## 1983      1
    ## 1984      1
    ## 1985      1
    ## 1986      1
    ## 1987      1
    ## 1988      1
    ## 1989      1
    ## 1990      0
    ## 1991      1
    ## 1992      0
    ## 1993      0
    ## 1994      1
    ## 1995      0
    ## 1996      0
    ## 1997      1
    ## 1998      0
    ## 1999      0
    ## 2000      0
    ## 2001      0
    ## 2002      1
    ## 2003      1
    ## 2004      1
    ## 2005      0
    ## 2006      1
    ## 2007      0
    ## 2008      0
    ## 2009      1
    ## 2010      1
    ## 2011      1
    ## 2012      1
    ## 2013      1
    ## 2014      1
    ## 2015      0
    ## 2016      1
    ## 2017      0
    ## 2018      0
    ## 2019      1
    ## 2020      1
    ## 2021      1
    ## 2022      1
    ## 2023      1
    ## 2024      0
    ## 2025      1
    ## 2026      1
    ## 2027      1
    ## 2028      1
    ## 2029      1
    ## 2030      1
    ## 2031      1
    ## 2032      1
    ## 2033      1
    ## 2034      1
    ## 2035      0
    ## 2036      0
    ## 2037      0
    ## 2038      0
    ## 2039      0
    ## 2040      1
    ## 2041      0

``` r
dim(teams_tbl)
```

    ## [1] 2041    8

``` r
summary(teams_tbl)
```

    ##        id           series          episode            task      
    ##  Min.   :   1   Min.   :-5.000   Min.   :  1.00   Min.   :  1.0  
    ##  1st Qu.: 511   1st Qu.: 5.000   1st Qu.: 34.00   1st Qu.:204.0  
    ##  Median :1021   Median : 8.000   Median : 67.00   Median :396.5  
    ##  Mean   :1021   Mean   : 8.271   Mean   : 70.17   Mean   :399.2  
    ##  3rd Qu.:1531   3rd Qu.:12.000   3rd Qu.:108.00   3rd Qu.:603.8  
    ##  Max.   :2041   Max.   :16.000   Max.   :148.00   Max.   :818.0  
    ##                                                   NA's   :15     
    ##     speaker          roots              quote               studio      
    ##  Min.   :  0.00   Length:2041        Length:2041        Min.   :0.0000  
    ##  1st Qu.:  2.00   Class :character   Class :character   1st Qu.:0.0000  
    ##  Median : 34.00   Mode  :character   Mode  :character   Median :1.0000  
    ##  Mean   : 36.44                                         Mean   :0.5674  
    ##  3rd Qu.: 63.00                                         3rd Qu.:1.0000  
    ##  Max.   :107.00                                         Max.   :1.0000  
    ## 

``` r
library(tidyverse)
```

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ dplyr     1.1.4     ✔ readr     2.1.5
    ## ✔ forcats   1.0.0     ✔ stringr   1.5.1
    ## ✔ ggplot2   3.5.1     ✔ tibble    3.2.1
    ## ✔ lubridate 1.9.3     ✔ tidyr     1.3.1
    ## ✔ purrr     1.0.2     
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

``` r
series_profanity <- teams_tbl %>% 
    group_by(series) %>%
    summarise(no_episodes = dplyr::n_distinct(episode),
    sum_profanity_series = dplyr::n()
                                   ) %>%
    mutate(profanity_per_episode = sum_profanity_series/no_episodes)


dbWriteTable(tm_db, "series_profanity", series_profanity)

#dbWriteTable(tm_db, "teams", teams)
#head(teams)
```

``` r
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

``` r
dbGetQuery(tm_db, "SELECT sp.*,
           ts.name, 
           ts.champion,
           tp.name as champion_name,
           ts.special,
           ts.episodes
           FROM series_profanity sp 
           LEFT JOIN series ts 
           ON sp.series = ts.id
           LEFT JOIN people tp
           ON sp.series = tp.series
           AND ts.champion = tp.id
          ")
```

    ##    series no_episodes sum_profanity_series profanity_per_episode      name
    ## 1      -5           1                   15              15.00000  NYT 2023
    ## 2      -4           1                   19              19.00000    CoC II
    ## 3      -3           1                    7               7.00000  NYT 2022
    ## 4      -2           1                   20              20.00000  NYT 2021
    ## 5      -1           2                   29              14.50000       CoC
    ## 6       1           6                  104              17.33333  Series 1
    ## 7       2           5                   97              19.40000  Series 2
    ## 8       3           5                   58              11.60000  Series 3
    ## 9       4           8                   90              11.25000  Series 4
    ## 10      5           8                  133              16.62500  Series 5
    ## 11      6          10                  206              20.60000  Series 6
    ## 12      7          10                  156              15.60000  Series 7
    ## 13      8          10                   95               9.50000  Series 8
    ## 14      9          10                  169              16.90000  Series 9
    ## 15     10          10                  133              13.30000 Series 10
    ## 16     11          10                  100              10.00000 Series 11
    ## 17     12          10                  121              12.10000 Series 12
    ## 18     13          10                   97               9.70000 Series 13
    ## 19     14          10                  144              14.40000 Series 14
    ## 20     15          10                  110              11.00000 Series 15
    ## 21     16          10                  138              13.80000 Series 16
    ##    champion    champion_name special episodes
    ## 1        96         Mo Farah       1        1
    ## 2        87  Richard Herring       1        1
    ## 3        73    Adrian Chiles       1        1
    ## 4        62   Shirley Ballas       1        1
    ## 5        29  Josh Widdicombe       1        2
    ## 6         4  Josh Widdicombe       0        6
    ## 7        11   Katherine Ryan       0        5
    ## 8        16      Rob Beckett       0        5
    ## 9        22    Noel Fielding       0        8
    ## 10       24     Bob Mortimer       0        8
    ## 11       35     Liza Tarbuck       0       10
    ## 12       40   Kerry Godliman       0       10
    ## 13       45      Lou Sanders       0       10
    ## 14       49        Ed Gamble       0       10
    ## 15       57  Richard Herring       0       10
    ## 16       67    Sarah Kendall       0       10
    ## 17       71 Morgana Robinson       0       10
    ## 18       82     Sophie Duker       0       10
    ## 19       88    Dara Ó Briain       0       10
    ## 20      102       Mae Martin       0       10
    ## 21      105     Sam Campbell       0       10

``` r
dbGetQuery(tm_db, "SELECT * FROM people")
```

    ##      id series seat                    name        dob gender hand team
    ## 1     1     NA   NA              Alex Horne 1978-09-10      M    R   NA
    ## 2     2     NA   NA             Greg Davies 1968-05-14      M    R   NA
    ## 3     3      1    1           Frank Skinner 1957-01-28      M    R    1
    ## 4     4      1    2         Josh Widdicombe 1983-04-08      M    R    2
    ## 5     5      1    3           Roisin Conaty 1979-03-26      F    R    2
    ## 6     6      1    4      Romesh Ranganathan 1978-03-27      M    R    2
    ## 7     7      1    5                 Tim Key 1976-09-02      M    R    1
    ## 8     8      2    1               Doc Brown 1977-09-21      M    R    4
    ## 9     9      2    2           Joe Wilkinson 1975-05-02      M    R    4
    ## 10   10      2    3          Jon Richardson 1982-09-26      M    R    3
    ## 11   11      2    4          Katherine Ryan 1983-06-30      F    R    4
    ## 12   12      2    5           Richard Osman 1970-11-28      M    R    3
    ## 13   13      3    1               Al Murray 1968-05-10      M    R    6
    ## 14   14      3    2             Dave Gorman 1971-03-02      M    R    6
    ## 15   15      3    3           Paul Chowdhry 1974-08-21      M    R    6
    ## 16   16      3    4             Rob Beckett 1986-01-02      M    R    5
    ## 17   17      3    5             Sara Pascoe 1981-05-22      F    R    5
    ## 18   18      4    1             Hugh Dennis 1962-02-13      M    R    7
    ## 19   19      4    2              Joe Lycett 1988-07-05      M    L    8
    ## 20   20      4    3           Lolly Adefope 1990-09-14      F    L    8
    ## 21   21      4    4            Mel Giedroyc 1968-06-05      F    R    7
    ## 22   22      4    5           Noel Fielding 1973-05-21      M    R    8
    ## 23   23      5    1             Aisling Bea 1984-03-16      F    R   10
    ## 24   24      5    2            Bob Mortimer 1959-05-23      M    R   10
    ## 25   25      5    3             Mark Watson 1980-02-13      M    L    9
    ## 26   26      5    4              Nish Kumar 1985-08-26      M    R    9
    ## 27   27      5    5          Sally Phillips 1970-05-10      F    R   10
    ## 28   28     -1    1            Bob Mortimer 1959-05-23      M    R   NA
    ## 29   29     -1    2         Josh Widdicombe 1983-04-08      M    R   NA
    ## 30   30     -1    3          Katherine Ryan 1983-06-30      F    R   NA
    ## 31   31     -1    4           Noel Fielding 1973-05-21      M    R   NA
    ## 32   32     -1    5             Rob Beckett 1986-01-02      M    R   NA
    ## 33   33      6    1            Alice Levine 1986-07-08      F    R   11
    ## 34   34      6    2           Asim Chaudhry 1986-11-24      M    R   12
    ## 35   35      6    3            Liza Tarbuck 1964-11-21      F    R   12
    ## 36   36      6    4          Russell Howard 1980-03-23      M    R   11
    ## 37   37      6    5                Tim Vine 1967-03-04      M    R   12
    ## 38   38      7    1           James Acaster 1985-01-09      M    R   14
    ## 39   39      7    2        Jessica Knappett 1984-11-28      F    R   13
    ## 40   40      7    3          Kerry Godliman 1973-11-17      F    R   13
    ## 41   41      7    4               Phil Wang 1990-01-22      M    R   14
    ## 42   42      7    5            Rhod Gilbert 1968-10-18      M    R   14
    ## 43   43      8    1           Iain Stirling 1988-01-27      M    R   16
    ## 44   44      8    2              Joe Thomas 1983-10-28      M    R   15
    ## 45   45      8    3             Lou Sanders 1985-11-24      F    R   16
    ## 46   46      8    4              Paul Sinha 1970-05-28      M    R   16
    ## 47   47      8    5             Sian Gibson 1976-07-30      F    R   15
    ## 48   48      9    1           David Baddiel 1964-05-28      M    R   17
    ## 49   49      9    2               Ed Gamble 1986-03-11      M    R   18
    ## 50   50      9    3                Jo Brand 1957-07-23      F    R   17
    ## 51   51      9    4                Katy Wix 1980-02-28      F    R   18
    ## 52   52      9    5            Rose Matafeo 1992-02-25      F    R   18
    ## 53   53     10    1        Daisy May Cooper 1986-08-01      F    R   21
    ## 54   54     10    2            Johnny Vegas 1970-09-05      M    R   22
    ## 55   55     10    3     Katherine Parkinson 1978-03-09      F    R   22
    ## 56   56     10    4           Mawaan Rizwan 1992-08-18      M    R   22
    ## 57   57     10    5         Richard Herring 1967-07-12      M    R   21
    ## 58   58     -2    1             John Hannah 1962-04-23      M    R   NA
    ## 59   59     -2    2    Krishnan Guru-Murthy 1970-04-05      M    R   NA
    ## 60   60     -2    3         Nicola Coughlan 1987-01-09      F    R   NA
    ## 61   61     -2    4        Rylan Clark-Neal 1988-10-25      M    R   NA
    ## 62   62     -2    5          Shirley Ballas 1960-09-06      F    R   NA
    ## 63   63     11    1       Charlotte Ritchie 1989-08-29      F    R   26
    ## 64   64     11    2           Jamali Maddix 1991-04-08      M    L   26
    ## 65   65     11    3                Lee Mack 1968-08-04      M    R   25
    ## 66   66     11    4            Mike Wozniak 1979-11-08      M    R   25
    ## 67   67     11    5           Sarah Kendall 1976-08-03      F    R   26
    ## 68   68     12    1             Alan Davies 1966-03-06      M    R   27
    ## 69   69     12    2           Desiree Burch 1979-01-26      F    R   28
    ## 70   70     12    3                Guz Khan 1986-01-24      M    R   28
    ## 71   71     12    4        Morgana Robinson 1982-05-07      F    R   28
    ## 72   72     12    5 Victoria Coren Mitchell 1972-08-18      F    R   27
    ## 73   73     -3    1           Adrian Chiles 1967-03-21      M    R   NA
    ## 74   74     -3    2       Claudia Winkleman 1972-01-15      F    R   NA
    ## 75   75     -3    3          Jonnie Peacock 1993-05-28      M    R   NA
    ## 76   76     -3    4            Lady Leshurr 1987-12-15      F    R   NA
    ## 77   77     -3    5           Sayeeda Warsi 1971-03-28      F    R   NA
    ## 78   78     13    1          Ardal O'Hanlon 1965-10-08      M    R   29
    ## 79   79     13    2        Bridget Christie 1971-08-17      F    R   30
    ## 80   80     13    3            Chris Ramsey 1986-08-03      M    R   29
    ## 81   81     13    4               Judi Love 1980-06-04      F    R   30
    ## 82   82     13    5            Sophie Duker 1990-01-26      F    R   30
    ## 83   83     -4    1               Ed Gamble 1986-03-11      M    R   NA
    ## 84   84     -4    2          Kerry Godliman 1973-11-17      F    R   NA
    ## 85   85     -4    3            Liza Tarbuck 1964-11-21      F    R   NA
    ## 86   86     -4    4             Lou Sanders 1985-11-24      F    R   NA
    ## 87   87     -4    5         Richard Herring 1967-07-12      M    R   NA
    ## 88   88     14    1           Dara Ó Briain 1972-02-04      M    R   32
    ## 89   89     14    2              Fern Brady 1986-05-26      F    R   32
    ## 90   90     14    3             John Kearns 1987-04-10      M    R   32
    ## 91   91     14    4           Munya Chawawa 1992-12-29      M    L   31
    ## 92   92     14    5          Sarah Millican 1975-05-29      F    R   31
    ## 93   93     -5    1     Amelia Dimoldenberg 1994-01-30      F    R   NA
    ## 94   94     -5    2         Carol Vorderman 1960-12-24      F    R   NA
    ## 95   95     -5    3              Greg James 1985-12-17      M    R   NA
    ## 96   96     -5    4                Mo Farah 1983-03-23      M    R   NA
    ## 97   97     -5    5     Rebecca Lucy Taylor 1986-10-15      F    R   NA
    ## 98   98     15    1           Frankie Boyle 1972-08-16      M    R   33
    ## 99   99     15    2              Ivo Graham 1990-09-05      M    R   33
    ## 100 100     15    3            Jenny Eclair 1960-03-16      F    R   34
    ## 101 101     15    4       Kiell Smith-Bynoe 1989-03-05      M    R   34
    ## 102 102     15    5              Mae Martin 1987-05-02     NB    R   34
    ## 103 103     16    1            Julian Clary 1959-05-25      M    L   36
    ## 104 104     16    2           Lucy Beaumont 1983-08-10      F    R   36
    ## 105 105     16    3            Sam Campbell 1991-09-19      M    R   36
    ## 106 106     16    4             Sue Perkins 1969-09-22      F    L   35
    ## 107 107     16    5            Susan Wokoma 1987-12-31      F    R   35
    ## 108 108     -6    1          Deborah Meaden 1959-02-11      F    R   NA
    ## 109 109     -6    2           Kojey Radical 1993-01-04      M    R   NA
    ## 110 110     -6    3              Lenny Rush 2009-03-18      M    R   NA
    ## 111 111     -6    4         Steve Backshall 1973-04-21      M    R   NA
    ## 112 112     -6    5                Zoe Ball 1970-11-23      F    R   NA
    ## 113 113     -7    1           Dara Ó Briain 1972-02-04      M    R   NA
    ## 114 114     -7    2       Kiell Smith-Bynoe 1989-03-05      M    R   NA
    ## 115 115     -7    3        Morgana Robinson 1982-05-07      F    R   NA
    ## 116 116     -7    4           Sarah Kendall 1976-08-03      F    R   NA
    ## 117 117     -7    5            Sophie Duker 1990-01-26      F    R   NA
    ##     champion TMI
    ## 1          0  32
    ## 2          0  19
    ## 3          0  56
    ## 4          1  69
    ## 5          0  15
    ## 6          0  48
    ## 7          0  34
    ## 8          0  11
    ## 9          0  70
    ## 10         0  49
    ## 11         1  52
    ## 12         0  44
    ## 13         0  43
    ## 14         0  27
    ## 15         0  13
    ## 16         1   8
    ## 17         0  46
    ## 18         0  20
    ## 19         0  40
    ## 20         0   2
    ## 21         0  24
    ## 22         1  21
    ## 23         0   7
    ## 24         1  42
    ## 25         0  65
    ## 26         0  36
    ## 27         0  47
    ## 28         0  42
    ## 29         0  69
    ## 30         0  52
    ## 31         0  21
    ## 32         0   8
    ## 33         0  39
    ## 34         0  12
    ## 35         1  59
    ## 36         0  33
    ## 37         0  63
    ## 38         0   1
    ## 39         0  35
    ## 40         1  26
    ## 41         0  64
    ## 42         0  25
    ## 43         0  57
    ## 44         0  60
    ## 45         1  54
    ## 46         0  55
    ## 47         0  23
    ## 48         0   5
    ## 49         1  22
    ## 50         0  10
    ## 51         0  72
    ## 52         0  41
    ## 53         0  16
    ## 54         0  61
    ## 55         0  45
    ## 56         0  51
    ## 57         1  31
    ## 58         0  30
    ## 59         0  28
    ## 60         0  18
    ## 61         0  14
    ## 62         0   6
    ## 63         0 173
    ## 64         0 174
    ## 65         0 175
    ## 66         0 176
    ## 67         1 177
    ## 68         0 240
    ## 69         0 241
    ## 70         0 242
    ## 71         1 243
    ## 72         0 244
    ## 73         0 318
    ## 74         0 319
    ## 75         0 321
    ## 76         0 320
    ## 77         0 322
    ## 78         0 308
    ## 79         0 309
    ## 80         0 310
    ## 81         0 311
    ## 82         1 312
    ## 83         0  22
    ## 84         0  26
    ## 85         0  59
    ## 86         0  54
    ## 87         0  31
    ## 88         1 378
    ## 89         0 379
    ## 90         0 380
    ## 91         0 381
    ## 92         0 382
    ## 93         0 414
    ## 94         0 415
    ## 95         0 416
    ## 96         0 417
    ## 97         0 418
    ## 98         0 391
    ## 99         0 392
    ## 100        0 393
    ## 101        0 394
    ## 102        1 395
    ## 103        0 454
    ## 104        0 455
    ## 105        1 456
    ## 106        0 457
    ## 107        0 458
    ## 108        0 512
    ## 109        0 513
    ## 110        0 514
    ## 111        0 515
    ## 112        0 516
    ## 113        0 378
    ## 114        0 394
    ## 115        0 243
    ## 116        0 177
    ## 117        0 312

## Future Ideas

- Standard queries to join data into the most exhaustive/comprehensive
  dataset \*\* Data at the (series, episode, task, contestant) level.
- Dashboard to provide insight as to when the database was last updated.
  \*\* What is the latest episode that we have data for? \*\* What is
  the latest ETL stamp.

You can also embed plots, for example:

![](database_connection_files/figure-gfm/pressure-1.png)<!-- -->

Note that the `echo = FALSE` parameter was added to the code chunk to
prevent printing of the R code that generated the plot.

[^1]: Taskmaster fanatics will know that this is in reference to the
    hint in S2E5’s task *Build a bridge for the potato.*, which has
    since become one of key pieces of advice for all Taskmaster
    contestants. It has been suitably adapted for working on data tables
    in a database, rather than a piece of furniture.
