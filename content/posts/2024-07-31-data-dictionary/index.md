---
title: "A Data Dic(tionary) pic of TdlM"
author: Christopher Nam
date: '2024-08-31'
slug: tdlm-data-dictionary
categories: []
tags: ["TdlM", "Beginner"]
draft: no
output:
  blogdown::html_page:
    toc: true
    toc_depth: 1
    number_sections: false
    df_print: "default"
    highlighter: tango
---

<link href="{{< blogdown/postref >}}index_files/htmltools-fill/fill.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/htmlwidgets/htmlwidgets.js"></script>

<link href="{{< blogdown/postref >}}index_files/datatables-css/datatables-crosstalk.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/datatables-binding/datatables.js"></script>

<script src="{{< blogdown/postref >}}index_files/jquery/jquery-3.6.0.min.js"></script>

<link href="{{< blogdown/postref >}}index_files/dt-core/css/jquery.dataTables.min.css" rel="stylesheet" />
<link href="{{< blogdown/postref >}}index_files/dt-core/css/jquery.dataTables.extra.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/dt-core/js/jquery.dataTables.min.js"></script>

<link href="{{< blogdown/postref >}}index_files/nouislider/jquery.nouislider.min.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/nouislider/jquery.nouislider.min.js"></script>

<link href="{{< blogdown/postref >}}index_files/selectize/selectize.bootstrap3.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/selectize/selectize.min.js"></script>

<link href="{{< blogdown/postref >}}index_files/crosstalk/css/crosstalk.min.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/crosstalk/js/crosstalk.min.js"></script>

<script src="{{< blogdown/postref >}}index_files/htmlwidgets/htmlwidgets.js"></script>

<link href="{{< blogdown/postref >}}index_files/datatables-css/datatables-crosstalk.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/datatables-binding/datatables.js"></script>

<script src="{{< blogdown/postref >}}index_files/jquery/jquery-3.6.0.min.js"></script>

<link href="{{< blogdown/postref >}}index_files/dt-core/css/jquery.dataTables.min.css" rel="stylesheet" />
<link href="{{< blogdown/postref >}}index_files/dt-core/css/jquery.dataTables.extra.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/dt-core/js/jquery.dataTables.min.js"></script>

<link href="{{< blogdown/postref >}}index_files/crosstalk/css/crosstalk.min.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index_files/crosstalk/js/crosstalk.min.js"></script>

# Your Task

> Obtain a good overview of the tables in the TdLM database, what these tables contain, how these tables are linked together, and which ones are the most important for this project.

# Don’t be a Data Dic (tionary) about this…

This article assumes that you are able to connect to the TdlM database successfully ([database connection post](/themedianduck/2024/07/database-connection)).

A reminder that these are the tables available to us in `TdlM` database are.

``` r
tm_db_tables <- dbListTables(tm_db)
tm_db_tables
```

    ##  [1] "attempts"           "discrepancies"      "episode_scores"     "episodes"           "intros"             "measurements"       "normalized_scores"  "objectives"         "people"             "podcast"            "profanity"          "series"             "series_scores"      "special_locations"  "task_briefs"        "task_readers"       "task_winners"       "tasks"              "tasks_by_objective" "team_tasks"         "teams"              "title_coiners"      "title_stats"

## A Data Dic(tionary) Pic: An Overview of the Plan

To formulate our basic data dictionary, we are going to go one by one through these 23 tables, perform a simple query to sample the data and infer what the table and data pertains to. Basic data summaries will be performed on these tables to get a sense of potential distribution of values, and any missing values.

In the spirit automation, we will be querying each table through a `for` loop, cycling through the tables names provided above. This means we won’t be repeating too much work, and if tables are added or changed in the future, we can re-run the code quickly to obtain new samples for inspection.

Fulll details of the deep dive can be found in the [appendix](#appendix-details)

# Summary of Findings

Based on the [deep dive](#appendix-details), here is a brief summary of each table and a heuristic categorisation (`Tier`) of how important they are to this project.
This categorisation could be used for prioritisation purposes in ensuring that this data is collected in a timely manner, and that we have high quality data for them.[^1]

- **Tier 1:** Essential and fundamental to The Median Duck project. High data quality required to make the project successful. Data Collection of these tables should be prioritised in the case of an emergency.
- **Tier 2:** Currently not essential, but may be required at a later date, particularly once performing additional investigations and deep dives.
- **Tier 3:** Good auxiliary and insights tables, but not essential to The Median Duck.

<div class="datatables html-widget html-fill-item" id="htmlwidget-1" style="width:100%;height:auto;"></div>
<script type="application/json" data-for="htmlwidget-1">{"x":{"filter":"top","vertical":false,"filterHTML":"<tr>\n  <td><\/td>\n  <td data-type=\"factor\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n    <div style=\"width: 100%; display: none;\">\n      <select multiple=\"multiple\" style=\"width: 100%;\" data-options=\"[&quot;Tier 1&quot;,&quot;Tier 2&quot;,&quot;Tier 3&quot;]\"><\/select>\n    <\/div>\n  <\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n  <td data-type=\"character\" style=\"vertical-align: top;\">\n    <div class=\"form-group has-feedback\" style=\"margin-bottom: auto;\">\n      <input type=\"search\" placeholder=\"All\" class=\"form-control\" style=\"width: 100%;\"/>\n      <span class=\"glyphicon glyphicon-remove-circle form-control-feedback\"><\/span>\n    <\/div>\n  <\/td>\n<\/tr>","data":[["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"],["Tier 1","Tier 1","Tier 1","Tier 1","Tier 1","Tier 1","Tier 1","Tier 1","Tier 1","Tier 1","Tier 2","Tier 2","Tier 2","Tier 2","Tier 2","Tier 2","Tier 2","Tier 2","Tier 2","Tier 3","Tier 3","Tier 3","Tier 3"],["attempts","episode_scores","episodes","people","series","series_scores","task_winners","tasks","team_tasks","teams","discrepancies","measurements","normalized_scores","objectives","special_locations","task_briefs","task_readers","tasks_by_objective","title_coiners","intros","podcast","profanity","title_stats"],["Each contestants attempt at a task, the points awarded and the ranking. Presentation order of attempts is also available.","Snapshot of a contestant's score and rank at the end of each episode. Cumulative series and ranking is also present.","Snapshot of episode information (episode of title, winner, number of tasks, number of points awarded).","High level information on contestants, Greg Davies and Alex Horne (gender, DOB, dominant hand). Taskmaster specific information (seat order, champion flag) is also available.","Snapshot of overall series information. Number of episodes, air dates, champion of series, overall points awarded, overall number of tasks.","Snapshot of each contestant's overall score and rank at the end of series. ","Information on who the winner of a task was. Indicators on if it was a team task, and if it was a live task also available.","Highlevel information regarding a task (Location, points awarded, type of task).  No information on a contestant and their attempts is present.","Information on team tasks, the teams performign the task, and if the team won.","Information on the teams (members of team and size), regardless of the tasks themselves.","Table to account for 2 instances of discrepancies in the shows run (so far).","Information on the exact measurable outcome of a task attempt by a contestant.","Table which normalises scores in light of ties, and separating out bonus scores from base task scores.","Auxiliary table of measurements table, explicitly stating the units of measurement and the directional target (most, least, median). ","Information on the special locations based tasks beyond the Taskmaster house and studio.","Informationi on the exact task (long form) that was provided to contestants.","Information on which contestant was shown to be reading the task in the broadcasted episode. Team task and Live task indicators also available.  ","Information on the task and the exact objective of what is deemed a successful task.","Data regarding the episode title, who coined the title (contestant, GD or LAH), task in which the quote originated from.","Information pertaining to the title sequence for each series (which person is featured, and which task it is associated with).","Information pertaining to the Official Taskmaster Podcast (hosted by Ed Gamble).","Table detailing the profanity observed in an episode. Which task did the profanity occur, the offended, the offending works, and the exact quote.","Insights regarding the episode titles (number of words and syllables)"],["task, contestant, series, episode, team, location","episode, contestant, series","series, episode, winner","id, series","id (series), champion","series, contestant","task, winner","series, episode, location","task, team","id, series","contestant, task, episode, series","task, contestant, objective","task, contestant","id","id","task","task, reader","task, objective","episode, coiner, task","series, person, task","guest , topic","series, episode, task, speaker","series, episode"],["","Assuming attempts table feeds into this table.","","","","Assuming attempts and/or episode_scores table feeds into this table.","Assuming attempts feeds into this.","","","","","","","","","","","","","","","",""]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>Tier<\/th>\n      <th>Table<\/th>\n      <th>Brief Description of Table<\/th>\n      <th>Key Columns to Join with Other Columns<\/th>\n      <th>Additional Comments<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"paging":false,"searching":true,"info":true,"scrollY":"500px","columnDefs":[{"orderable":false,"targets":0},{"name":" ","targets":0},{"name":"Tier","targets":1},{"name":"Table","targets":2},{"name":"Brief Description of Table","targets":3},{"name":"Key Columns to Join with Other Columns","targets":4},{"name":"Additional Comments","targets":5}],"order":[],"autoWidth":false,"orderClasses":false,"orderCellsTop":true}},"evals":[],"jsHooks":[]}</script>

The `series` table indicates, `TdlM` only contains data associated with the UK series of Taskmaste (both regular and New Years Treat).

Through this deep dive, I also observed that the data output obtained from this `R` connection, can be less intuitive and comprehensible than that presented throught the Datasette website interface. It is possible that some front end processing is occurring for the website which uses the intrinsic links between the tables to provide intuitive, comprehensible data records. The use of `REFERENCES <table>(id)` in the `CREATE TABLE` statement is likely an indication of how this data linked together.

For example compare the output in the `episode_scores` table, when querying through `R` and through the [Datasette website](https://tdlm.fly.dev/taskmaster/episode_scores?_sort=id&id__lte=55&id__gte=51).

The `episode`, `contestant` columns are numerical in the the `R` output, whilst they are meaning strings in the website output; namely the actual episode titles, and contestants full names.

This indicates some additional work will likely be required in `R` to get data in this in this similarly intuitive and informative manner. Datasette will have the benefit that some of this back end processing has already been performed, and a lower barrier to entry. Saying this, if execute the raw SQL query directly on the Datasette website, we do get the less intuitive data ([link](https://tdlm.fly.dev/taskmaster?sql=select+id%2C+episode%2C+contestant%2C+score%2C+rank%2C+series%2C+srank+from+episode_scores+where+%22id%22+%3E%3D+51+and+%22id%22+%3C%3D+55+order+by+id+limit+101&p1=55&p0=51)).

``` r
query <- "SELECT id, episode, contestant, score, rank, series, srank FROM episode_scores WHERE \"id\" >= 51 AND \"id\" <= 55 ORDER BY id LIMIT 101"
```

<div style="display: flex;">

<div>

Output from the database file through `R`:

<div id="htmlwidget-2" style="width:770px;height:400px;" class="datatables html-widget"></div>
<script type="application/json" data-for="htmlwidget-2">{"x":{"filter":"none","vertical":false,"data":[["1","2","3","4","5"],[51,52,53,54,55],[11,11,11,11,11],[8,9,10,11,12],[12,11,13,13,19],["4","5","2=","2=","1"],[78,69,90,94,86],["4","5","2","1","3"]],"container":"<table class=\"display\">\n  <thead>\n    <tr>\n      <th> <\/th>\n      <th>id<\/th>\n      <th>episode<\/th>\n      <th>contestant<\/th>\n      <th>score<\/th>\n      <th>rank<\/th>\n      <th>series<\/th>\n      <th>srank<\/th>\n    <\/tr>\n  <\/thead>\n<\/table>","options":{"paging":false,"searching":false,"info":false,"columnDefs":[{"className":"dt-right","targets":[1,2,3,4,6]},{"orderable":false,"targets":0},{"name":" ","targets":0},{"name":"id","targets":1},{"name":"episode","targets":2},{"name":"contestant","targets":3},{"name":"score","targets":4},{"name":"rank","targets":5},{"name":"series","targets":6},{"name":"srank","targets":7}],"order":[],"autoWidth":false,"orderClasses":false}},"evals":[],"jsHooks":[]}</script>

</div>

<div>

Output from Datasette website:
<iframe src="https://tdlm.fly.dev/taskmaster/episode_scores?_sort=id&amp;id__lte=55&amp;id__gte=51" width="672" height="400px" data-external="1"></iframe>

</div>

</div>

# Final Thoughts

> There are `10` tables in the `TdlM` database which we consider to be essential to the The Median Duck project.
> These tables are `attempts, episode_scores, episodes, people, series, series_scores, task_winners, tasks, team_tasks, teams`.

# Appendix Details

Comprehensive details on how the data dictionary and heuristic ranking came to be. Data samples and summary statistics also provided.

Be warned, it’s very dry and not for the faint heartened! You do however get to see my coding standards and commentary style however.

``` r
library(Hmisc)  #Library/Function to provide data summaries.

# Initially empty list to contain the data frame samples.
data_sample_list <- list()
sample_size <- 10

# For each table...

# Perform a SELECT * FROM {tbl} query to pull data.

# Randomly sample data using R, and also get summary statistics

# Add data sample to list for easy access.
for (iter in 1:length(tm_db_tables)) {
    tbl <- tm_db_tables[iter]
    select_query <- sprintf("SELECT * FROM %s", tbl)

    set.seed(1234)  # Set seed for reproducibility.

    query_output <- dbGetQuery(tm_db, select_query)

    # Random sample from table
    table_sample <- query_output[sample(1:nrow(query_output), size = sample_size), ]

    # Summary statistics for entire table
    table_summary <- Hmisc::describe(query_output)

    # List of two objects
    table_list <- list(data_sample = table_sample, data_summary = table_summary)

    data_sample_list[[iter]] <- table_list
}


# Give the list items the table names we have queried from
data_sample_list <- setNames(data_sample_list, tm_db_tables)
```

## `attempts`

The [`attempts` table](https://tdlm.fly.dev/taskmaster/attempts) table fundamentally captures each contestants attempt at each task; that is for each `task, contestant` the points awarded from their task attempt (`points`) and their ranking with respect to the other contestants (`rank`).

Information is also provided to the `team` id (if the task is a team task), and the `location` id of where the task was held.

- N.B. `episode` and `series` here denotes the contestant’s cumulative episode and series score respectively.
- `adjustment`is present to adjust for series bias??
- `PO` denotes the `Presentation Order`, the order in which the contestants attempts was presented in the recording. 0 denotes simultaneous presentation of the attempts.

<details>

<summary>

See `attempts` Sample!
</summary>

``` r
data_sample_list[["attempts"]]$data_sample
```

    ##        id task contestant PO base adjustment points rank episode series team location
    ## 3356 3356  693         91  4    5         NA      5   1=       8     97   NA       NA
    ## 3920 3920  808        107  2    5         NA      5   1=      12    104   NA       NA
    ## 3066 3066  635         81 2=    5         NA      5    1      21     99   NA       NA
    ## 3173 3173  657         83  1    0         NA      0 <NA>      11     11   NA       NA
    ## 1004 1004  214         37 1=    1         NA      1   2=      10     21   12       NA
    ## 623   623  133         20  2    3         NA      3    3       3     95   NA       NA
    ## 2953 2953  611         82 1=    4          1      5    2      10     41   NA       NA
    ## 2693 2693  559         69 3=    2         NA      2   4=      11     64   NA       NA
    ## 934   934  199         30  0    4         NA      4   2=      20     20   NA       NA
    ## 400   400   84         15  1    1         NA      1    5       6     49   NA       NA

</details>

<details>

<summary>

See `attempts` Summary!
</summary>

``` r
data_sample_list[["attempts"]]$data_summary
```

    ## query_output 
    ## 
    ##  12  Variables      3975  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     3975        0     3975        1     1988     1988     1325    199.7    398.4    994.5   1988.0   2981.5   3577.6   3776.3 
    ## 
    ## lowest :    1    2    3    4    5, highest: 3971 3972 3973 3974 3975
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## task 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     3975        0      819        1    413.4    413.5      272     44.0     84.0    212.5    414.0    617.0    737.6    778.3 
    ## 
    ## lowest :   1   2   3   4   5, highest: 815 816 817 818 819
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## contestant 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     3975        0      106        1    54.53     54.5       34        9       16       33       51       79      100      104 
    ## 
    ## lowest :   1   3   4   5   6, highest: 103 104 105 106 107
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## PO 
    ##        n  missing distinct 
    ##     3967        8       10 
    ##                                                                       
    ## Value          0     1    1=     2    2=     3    3=     4    4=     5
    ## Frequency    425   386   850   318   316   355   296   330   240   451
    ## Proportion 0.107 0.097 0.214 0.080 0.080 0.089 0.075 0.083 0.060 0.114
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## base 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     3795      180       15    0.966    3.008        3    1.833        0        1        2        3        4        5        5 
    ##                                                                                                     
    ## Value         -5    -2    -1     0     1     2     3     4     5     6     7    10    12    13    15
    ## Frequency      2     2     1   279   511   651   738   717   877     7     1     5     2     1     1
    ## Proportion 0.001 0.001 0.000 0.074 0.135 0.172 0.194 0.189 0.231 0.002 0.000 0.001 0.001 0.000 0.000
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## adjustment 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd 
    ##       63     3912        7    0.584    0.619        1    1.269 
    ##                                                     
    ## Value         -5    -2    -1     1     2     3     5
    ## Frequency      3     2     5    47     4     1     1
    ## Proportion 0.048 0.032 0.079 0.746 0.063 0.016 0.016
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## points 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     3975        0       16    0.969    2.882        3    1.935        0        0        2        3        4        5        5 
    ##                                                                                                           
    ## Value         -5    -4    -2    -1     0     1     2     3     4     5     6     7    10    12    13    15
    ## Frequency      2     1     2     3   444   520   645   740   717   878    12     2     5     2     1     1
    ## Proportion 0.001 0.000 0.001 0.001 0.112 0.131 0.162 0.186 0.180 0.221 0.003 0.001 0.001 0.001 0.000 0.000
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## rank 
    ##        n  missing distinct 
    ##     3510      465        9 
    ##                                                                 
    ## Value          1    1=     2    2=     3    3=     4    4=     5
    ## Frequency    614   397   515   328   470   160   443   120   463
    ## Proportion 0.175 0.113 0.147 0.093 0.134 0.046 0.126 0.034 0.132
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## episode 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     3974        1       31    0.997    9.421        9    6.145        2        3        5        9       13       17       19 
    ## 
    ## lowest : -4  0  1  2  3, highest: 25 26 27 28 30
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## series 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     3974        1      180        1    71.52     70.5    52.22        6       12       32       68      108      136      150 
    ## 
    ## lowest :   0   1   2   3   4, highest: 175 176 179 181 184
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## team 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      475     3500       36    0.999    21.09     21.5    11.56        4        7       13       22       30       34       35 
    ## 
    ## lowest :  1  2  3  4  5, highest: 32 33 34 35 36
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## location 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd 
    ##       50     3925        3    0.271     1.52        0    2.875 
    ##                          
    ## Value         0    5   22
    ## Frequency    45    2    3
    ## Proportion 0.90 0.04 0.06
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

## `discrepancies`

The [`discrepancies` table](https://tdlm.fly.dev/taskmaster/discrepancies) exists
*“to account for the two whole points that have gone misplaced in the history of TMUK”* [^2]

The table has the `series, episode, contestant, task` that caused the discrepancy, and the discrepancy between observed and official (truth??). The data summary shows that there are only 10 observations so this table is unlikely to be a top priority.

<details>

<summary>

See `discrepancies` Sample!
</summary>

``` r
data_sample_list[["discrepancies"]]$data_sample
```

    ##    id contestant task episode series observed official
    ## 10 10         67   NA      NA     11      159      158
    ## 6   6         52   NA      NA      9      160      159
    ## 5   5         51   NA      NA      9      157      158
    ## 4   4         52   NA      72     NA       18       17
    ## 1   1         51  416      NA     NA        2        3
    ## 8   8         67   NA      86     NA       19       18
    ## 2   2         52  416      NA     NA        3        2
    ## 7   7         66   NA      86     NA       16       17
    ## 9   9         66   NA      NA     11      153      154
    ## 3   3         51   NA      72     NA       14       15

</details>

<details>

<summary>

See `discrepancies` Summary!
</summary>

``` r
data_sample_list[["discrepancies"]]$data_summary
```

    ## query_output 
    ## 
    ##  7  Variables      10  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##       10        0       10        1      5.5      5.5    3.667     1.45     1.90     3.25     5.50     7.75     9.10     9.55 
    ##                                                   
    ## Value        1   2   3   4   5   6   7   8   9  10
    ## Frequency    1   1   1   1   1   1   1   1   1   1
    ## Proportion 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## contestant 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd 
    ##       10        0        4    0.939     57.5       59    8.289 
    ##                           
    ## Value       51  52  66  67
    ## Frequency    3   3   2   2
    ## Proportion 0.3 0.3 0.2 0.2
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## task 
    ##        n  missing distinct     Info     Mean 
    ##        2        8        1        0      416 
    ##               
    ## Value      416
    ## Frequency    2
    ## Proportion   1
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## episode 
    ##        n  missing distinct     Info     Mean 
    ##        4        6        2      0.8       79 
    ##                   
    ## Value       72  86
    ## Frequency    2   2
    ## Proportion 0.5 0.5
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## series 
    ##        n  missing distinct     Info     Mean 
    ##        4        6        2      0.8       10 
    ##                   
    ## Value        9  11
    ## Frequency    2   2
    ## Proportion 0.5 0.5
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## observed 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##       10        0       10        1     70.1       81    80.91     2.45     2.90    14.50    18.50   156.00   159.10   159.55 
    ##                                                   
    ## Value        2   3  14  16  18  19 153 157 159 160
    ## Frequency    1   1   1   1   1   1   1   1   1   1
    ## Proportion 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## official 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd 
    ##       10        0        8    0.988     70.1     80.5    80.56 
    ##                                           
    ## Value        2   3  15  17  18 154 158 159
    ## Frequency    1   1   1   2   1   1   2   1
    ## Proportion 0.1 0.1 0.1 0.2 0.1 0.1 0.2 0.1
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

## `episode_scores`

The [`episode_scores` table](https://tdlm.fly.dev/taskmaster/episode_scores) details the total number of points (`score`) awarded for each contestant in an episode, and their ranking within the episode against other contestants (`rank`). The cumulative series score and rank are also provided (`series` and `srank` respectively).[^3]

<details>

<summary>

See `episode_scores` Sample!
</summary>

``` r
data_sample_list[["episode_scores"]]$data_sample
```

    ##      id episode contestant score rank series srank
    ## 284 284      57         46    11    4     40     5
    ## 101 101      21         18    21   1=     83     4
    ## 623 623     125         90     6    5    113    4=
    ## 645 645     129        102    19    1     19     1
    ## 400 400      80         57    12    4     97     2
    ## 98   98      20         20    15    5     58     5
    ## 103 103      21         20    15    4     73     5
    ## 726 726     146        103    15   2=    123     2
    ## 602 602     121         89    15    3     60     3
    ## 326 326      66         48    10    5     24     5

</details>

<details>

<summary>

See `episode_scores` Summary!
</summary>

``` r
data_sample_list[["episode_scores"]]$data_summary
```

    ## query_output 
    ## 
    ##  7  Variables      740  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      740        0      740        1    370.5    370.5      247    37.95    74.90   185.75   370.50   555.25   666.10   703.05 
    ## 
    ## lowest :   1   2   3   4   5, highest: 736 737 738 739 740
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## episode 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      740        0      148        1     74.5     74.5     49.4     8.00    15.00    37.75    74.50   111.25   134.00   141.00 
    ## 
    ## lowest :   1   2   3   4   5, highest: 144 145 146 147 148
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## contestant 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      740        0      105        1    55.68     55.5    34.03      9.0     16.0     34.0     52.5     80.0    100.0    104.0 
    ## 
    ## lowest :   3   4   5   6   7, highest: 103 104 105 106 107
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## score 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      740        0       26    0.995    15.47     15.5    4.767        9       10       13       16       18       21       22 
    ## 
    ## lowest :  3  5  6  7  8, highest: 25 26 27 28 30
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## rank 
    ##        n  missing distinct 
    ##      740        0        9 
    ##                                                                 
    ## Value          1    1=     2    2=     3    3=     4    4=     5
    ## Frequency    123    52   104    41   105    46   108    32   129
    ## Proportion 0.166 0.070 0.141 0.055 0.142 0.062 0.146 0.043 0.174
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## series 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      740        0      166        1    77.45     76.5    52.36     13.0     17.0     37.0     74.5    113.0    142.0    155.0 
    ## 
    ## lowest :   5   6   7   8   9, highest: 174 175 176 181 184
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## srank 
    ##        n  missing distinct 
    ##      740        0        9 
    ##                                                                 
    ## Value          1    1=     2    2=     3    3=     4    4=     5
    ## Frequency    140    16   123    37   121    20   125    22   136
    ## Proportion 0.189 0.022 0.166 0.050 0.164 0.027 0.169 0.030 0.184
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

## `episodes`

The [`episodes` table](https://tdlm.fly.dev/taskmaster/episodes) details key information at the `(series, episode)` level. Information includes the episode title (`title`), the winner of the episode (`winner`), total number of judged tasks in the episode (`tasks`) and total number of points awarded in the episode (`points`). Logistical information on the episode such as whether the episode is a finale or not, and the studio and air date are also available.

It is not clear at the moment as to what the `TMI` represents.

<details>

<summary>

See `episodes` Sample!
</summary>

``` r
data_sample_list[["episodes"]]$data_sample
```

    ##      id series episode                     title winner   air_date studio_date points tasks finale TMI
    ## 28   28      5       4  Residue around the hoof.     25 2017-10-04  2017-07-04     96     7      0  28
    ## 80   80     10       6             Hippopotamus.     56 2020-11-19  2020-07-29     77     5      0  80
    ## 101 101     12       6       A chair in a sweet.     70 2021-10-28        <NA>     76     5      0 267
    ## 111 111     13       5  Having a little chuckle.     78 2022-05-12  2021-09-20     67     5      0 316
    ## 137 137     15       9    A show about pedantry.    101 2023-05-25  2022-09-28     84     5      0 470
    ## 133 133     15       5             Old Honkfoot.    102 2023-04-27  2022-09-26     97     5      0 466
    ## 132 132     15       4   How heavy is the water?    100 2023-04-20  2022-09-23     57     5      0 465
    ## 98   98     12       3 The end of the franchise.     69 2021-10-07        <NA>     80     5      0 264
    ## 103 103     12       8       A couple of Ethels.     68 2021-11-11        <NA>     79     5      0 269
    ## 90   90     11       5            Slap and tong.     63 2021-04-15        <NA>     70     5      0 215

</details>

<details>

<summary>

See `episodes` Summary!
</summary>

``` r
data_sample_list[["episodes"]]$data_summary
```

    ## query_output 
    ## 
    ##  11  Variables      148  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      148        0      148        1     74.5     74.5    49.67     8.35    15.70    37.75    74.50   111.25   133.30   140.65 
    ## 
    ## lowest :   1   2   3   4   5, highest: 144 145 146 147 148
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## series 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      148        0       21    0.996    8.764        9    5.553        1        2        5        9       13       15       16 
    ## 
    ## lowest : -5 -4 -3 -2 -1, highest: 12 13 14 15 16
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## episode 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      148        0       10    0.989    4.966        5    3.286        1        1        2        5        7        9       10 
    ##                                                                       
    ## Value          1     2     3     4     5     6     7     8     9    10
    ## Frequency     21    17    16    16    16    14    13    13    11    11
    ## Proportion 0.142 0.115 0.108 0.108 0.108 0.095 0.088 0.088 0.074 0.074
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## title 
    ##        n  missing distinct 
    ##      148        0      148 
    ## 
    ## lowest : 100% Bosco.              A chair in a sweet.      A coquettish fascinator. A couple of Ethels.      A cuddle.               , highest: Welcome to Rico Face.    What kind of pictures?   Wiley giraffe blower.    You've got no chutzpah.  You tuper super.        
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## winner 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      148        0       78        1    55.77     55.5    34.28    10.35    16.00    34.75    52.50    80.00   101.00   103.65 
    ## 
    ## lowest :   3   4   5   7   8, highest: 103 104 105 106 107
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## air_date 
    ##        n  missing distinct 
    ##      148        0      148 
    ## 
    ## lowest : 2015-07-28 2015-08-04 2015-08-11 2015-08-18 2015-08-25, highest: 2023-10-26 2023-11-02 2023-11-09 2023-11-16 2023-11-23
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## studio_date 
    ##        n  missing distinct 
    ##      108       40       55 
    ## 
    ## lowest : 2015-03-23 2015-03-24 2015-03-25 2017-07-03 2017-07-04, highest: 2023-05-02 2023-05-03 2023-05-04 2023-05-11 2023-05-12
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## points 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      148        0       48    0.998    77.36     76.5     12.2    61.35    65.00    71.00    77.00    82.25    91.30    98.00 
    ## 
    ## lowest :  47  53  57  58  59, highest: 103 106 107 110 120
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## tasks 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd 
    ##      148        0        3    0.565    5.264        5   0.4044 
    ##                             
    ## Value          5     6     7
    ## Frequency    111    35     2
    ## Proportion 0.750 0.236 0.014
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## finale 
    ##        n  missing distinct     Info      Sum     Mean 
    ##      148        0        2    0.289       16   0.1081 
    ## 
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## TMI 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      148        0      148        1    178.2      171      187     8.35    15.70    37.75    74.50   317.25   466.30   503.65 
    ## 
    ## lowest :   1   2   3   4   5, highest: 507 508 509 510 511
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

## `intros`

The [`intros` table](https://tdlm.fly.dev/taskmaster/intros) has information associated with the intro sequence for each series. This intro sequence is assumed to remain the same across all episodes within the same series (except for the end shot which features the episode title).

The intro sequence has been decomposed into which `person` is featured (`person` is not limited to contestants and can include Greg or Little Alex Horne), and the `task` it is taken from. The `clip` field does not seem to have much meaning in its `R` form, but inspecting this data through the Datasette website highlights that this links to a `mp4` of that particular part of the intro on `imgur.com`. [^4]

<details>

<summary>

See `intros` Sample!
</summary>

``` r
data_sample_list[["intros"]]$data_sample
```

    ##      id series clip person              task
    ## 284 284      7   G6      2 Be the Taskmaster
    ## 101 101      3   18     13                86
    ## 400 400     10   26     57               464
    ## 98   98      3   15     15                91
    ## 103 103      3   18     15                86
    ## 602 602     16   15      1               811
    ## 326 326      9    2     51      unidentified
    ## 79   79      3    2     14                68
    ## 270 270      7   19     38               272
    ## 382 382     10   12      1               466

</details>

<details>

<summary>

See `intros` Summary!
</summary>

``` r
data_sample_list[["intros"]]$data_summary
```

    ## query_output 
    ## 
    ##  5  Variables      616  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      616        0      616        1    308.5    308.5    205.7    31.75    62.50   154.75   308.50   462.25   554.50   585.25 
    ## 
    ## lowest :   1   2   3   4   5, highest: 612 613 614 615 616
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## series 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      616        0       16    0.996    8.263      8.5    5.288        1        2        4        8       12       15       16 
    ##                                                                                                           
    ## Value          1     2     3     4     5     6     7     8     9    10    11    12    13    14    15    16
    ## Frequency     38    38    44    49    38    36    41    39    43    36    34    34    37    37    37    35
    ## Proportion 0.062 0.062 0.071 0.080 0.062 0.058 0.067 0.063 0.070 0.058 0.055 0.055 0.060 0.060 0.060 0.057
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## clip 
    ##        n  missing distinct 
    ##      616        0       36 
    ## 
    ## lowest : 1  10 11 12 13, highest: G2 G3 G4 G5 G6
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## person 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      616        0       83    0.994    34.97       33    37.52      1.0      1.0      2.0     24.0     58.5     90.0    101.0 
    ## 
    ## lowest :   0   1   2   3   4, highest: 103 104 105 106 107
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## task 
    ##        n  missing distinct 
    ##      616        0      274 
    ## 
    ## lowest : 101               102               107               113               114              , highest: 92                96                Be the Taskmaster unaired           unidentified     
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

## `measurements`

The [`measurements` table](https://tdlm.fly.dev/taskmaster/measurements) table details for a particular `task, contestant`, the measurable outcome of their attempt.

For example, the duration of the time the task lasted for (either to successful completion, or until failure termination) or the longest distance travelled. The `objective` column provides insight into the units of the measurement and the objective (for example most, least, closest).

Care is likely required on the `measurement` field as to how inconclusive measurements are handed (was not observed and thus measured) and disqualifications.

<details>

<summary>

See `measurements` Sample!
</summary>

``` r
data_sample_list[["measurements"]]$data_sample
```

    ##        id task contestant measurement objective
    ## 1308 1308  551         69         0.0         2
    ## 1872 1872  762        100         3.8         4
    ## 1018 1018  439         57       393.0         2
    ## 1942 1942  785        106       474.0         2
    ## 1125 1125  486         58      1500.0       111
    ## 1004 1004  435         53         8.0       103
    ## 623   623  258         33        20.5        27
    ## 905   905  381         51         0.0        94
    ## 645   645  264         35         0.0        75
    ## 934   934  394         50         0.0        97

</details>

<details>

<summary>

See `measurements` Summary!
</summary>

``` r
data_sample_list[["measurements"]]$data_summary
```

    ## query_output 
    ## 
    ##  5  Variables      2037  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     2037        0     2037        1     1019     1019    679.3    102.8    204.6    510.0   1019.0   1528.0   1833.4   1935.2 
    ## 
    ## lowest :    1    2    3    4    5, highest: 2033 2034 2035 2036 2037
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## task 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     2037        0      391        1    418.9    418.5    279.9       37       73      205      440      627      744      782 
    ## 
    ## lowest :   2   4   6   8   9, highest: 809 811 813 814 819
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## contestant 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     2037        0      106        1    55.33       55    35.27        7       14       32       54       80      101      104 
    ## 
    ## lowest :   1   3   4   5   6, highest: 103 104 105 106 107
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## measurement 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     1819      218      671    0.999   298921      101   597507      0.0      0.5      3.0     16.0    270.0    921.2   1527.3 
    ## 
    ## lowest :     -2143      -128       -40       -35       -33, highest:   4185000  10368000  30305028  30355028 461031285
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## objective 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     2037        0      179    0.967    48.24     45.5    57.37        2        2        2       30       91      139      159 
    ## 
    ## lowest :   1   2   3   4   5, highest: 175 176 177 178 179
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

## `normalized_scores`

The [`normalized_scores` table](https://tdlm.fly.dev/taskmaster/normalized_scores) attempts to normalise scores across `contestants` for a particular `task` in an episode. This normalisation is required when bonus points are awarded in addition to the main tasak, and to handle ranking ties (two or more contestants achieved the same measurement and/or points in a task attempt), different ranking strategies are employed to handle ties.

Columns:

- `base` is the number of points awarded by the Taskmaster without the bonus points. These will typically be valued 0, 1, 2, 3, 4, 5, although the data also suggests it can be negative on a few rare occasions. These are typically when Alex is being particularly mischievous (e.g. lose points if you don’t do the tasks correctly).
- `points` is the number of points awarded including the bonus points or the Taskmaster going rogue.
- `adjustment` is the difference between `points` and `base`.
- `rank` is the ranking of contestant according to the `base` column, that is before bonus points are rewarded.
- `rigid` is the tidiest normalisation of points where 5 points are awarded for 1st, 4 for 2nd etc.
- `spread` evenly distributes the points across the tied contestants.
- `scale` scores are normalised such that no score exceed a maximum of 5. Previously tried to scale scores so that the sum was 15.
- `5+3`, `3+2` and `3½+2½` are normalisation tactics for team tasks.

<details>

<summary>

See `normalized_scores` Sample!
</summary>

``` r
data_sample_list[["normalized_scores"]]$data_sample
```

    ##        id task contestant base adjustment points rank rigid spread scale 5+3 3+2 3½+2½
    ## 3356 3356  693         91    5         NA      5   1=     5    3.5  3.57  NA  NA    NA
    ## 3920 3920  808        107    5         NA      5   1=     5    4.5  4.69  NA  NA    NA
    ## 3066 3066  635         81    5         NA      5    1     5    5.0  5.00  NA  NA    NA
    ## 3173 3173  657         83    0         NA      0 <NA>    NA     NA    NA  NA  NA    NA
    ## 1004 1004  214         37    1         NA      1   2=    NA     NA  1.25   3   2   2.5
    ## 623   623  133         20    3         NA      3    3     3    3.0  3.00  NA  NA    NA
    ## 2953 2953  611         82    4          1      5    2     4    4.0  4.00  NA  NA    NA
    ## 2693 2693  559         69    2         NA      2   4=     2    1.5  1.88  NA  NA    NA
    ## 934   934  199         30    4         NA      4   2=     4    3.0  3.33  NA  NA    NA
    ## 400   400   84         15    1         NA      1    5     1    1.0  1.00  NA  NA    NA

</details>

<details>

<summary>

See `normalized_scores` Summary!
</summary>

``` r
data_sample_list[["normalized_scores"]]$data_summary
```

    ## query_output 
    ## 
    ##  13  Variables      3975  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     3975        0     3975        1     1988     1988     1325    199.7    398.4    994.5   1988.0   2981.5   3577.6   3776.3 
    ## 
    ## lowest :    1    2    3    4    5, highest: 3971 3972 3973 3974 3975
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## task 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     3975        0      819        1    413.4    413.5      272     44.0     84.0    212.5    414.0    617.0    737.6    778.3 
    ## 
    ## lowest :   1   2   3   4   5, highest: 815 816 817 818 819
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## contestant 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     3975        0      106        1    54.53     54.5       34        9       16       33       51       79      100      104 
    ## 
    ## lowest :   1   3   4   5   6, highest: 103 104 105 106 107
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## base 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     3795      180       15    0.966    3.008        3    1.833        0        1        2        3        4        5        5 
    ##                                                                                                     
    ## Value         -5    -2    -1     0     1     2     3     4     5     6     7    10    12    13    15
    ## Frequency      2     2     1   279   511   651   738   717   877     7     1     5     2     1     1
    ## Proportion 0.001 0.001 0.000 0.074 0.135 0.172 0.194 0.189 0.231 0.002 0.000 0.001 0.001 0.000 0.000
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## adjustment 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd 
    ##       63     3912        7    0.584    0.619        1    1.269 
    ##                                                     
    ## Value         -5    -2    -1     1     2     3     5
    ## Frequency      3     2     5    47     4     1     1
    ## Proportion 0.048 0.032 0.079 0.746 0.063 0.016 0.016
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## points 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     3975        0       16    0.969    2.882        3    1.935        0        0        2        3        4        5        5 
    ##                                                                                                           
    ## Value         -5    -4    -2    -1     0     1     2     3     4     5     6     7    10    12    13    15
    ## Frequency      2     1     2     3   444   520   645   740   717   878    12     2     5     2     1     1
    ## Proportion 0.001 0.000 0.001 0.001 0.112 0.131 0.162 0.186 0.180 0.221 0.003 0.001 0.001 0.001 0.000 0.000
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## rank 
    ##        n  missing distinct 
    ##     3510      465        9 
    ##                                                                 
    ## Value          1    1=     2    2=     3    3=     4    4=     5
    ## Frequency    614   397   515   328   470   160   443   120   463
    ## Proportion 0.175 0.113 0.147 0.093 0.134 0.046 0.126 0.034 0.132
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## rigid 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd 
    ##     3104      871        5    0.957    3.235        3    1.566 
    ##                                         
    ## Value          1     2     3     4     5
    ## Frequency    463   563   624   691   763
    ## Proportion 0.149 0.181 0.201 0.223 0.246
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## spread 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd 
    ##     3084      891        9    0.975    3.098        3    1.567 
    ##                                                                 
    ## Value        1.0   1.5   2.0   2.5   3.0   3.5   4.0   4.5   5.0
    ## Frequency    460   120   495   130   514   120   543    92   610
    ## Proportion 0.149 0.039 0.161 0.042 0.167 0.039 0.176 0.030 0.198
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## scale 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     3484      491       53    0.987    3.102        3    1.504        1        1        2        3        4        5        5 
    ## 
    ## lowest : 0.385 0.5   0.714 0.75  0.833, highest: 4.41  4.5   4.62  4.69  5    
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## 5+3 
    ##        n  missing distinct     Info     Mean 
    ##      400     3575        2    0.707     4.24 
    ##                     
    ## Value         3    5
    ## Frequency   152  248
    ## Proportion 0.38 0.62
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## 3+2 
    ##        n  missing distinct     Info     Mean 
    ##      400     3575        2    0.707     2.62 
    ##                     
    ## Value         2    3
    ## Frequency   152  248
    ## Proportion 0.38 0.62
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## 3½+2½ 
    ##        n  missing distinct     Info     Mean 
    ##      400     3575        2    0.707     3.12 
    ##                     
    ## Value       2.5  3.5
    ## Frequency   152  248
    ## Proportion 0.38 0.62
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

## `objectives`

The [`objectives` table](https://tdlm.fly.dev/taskmaster/objectives) is a supplement of the `measurements` table and explicitly details the `units`, the objective (`target`) of a task. The `label` column appears to be a concatenation of `unit` and `target`.

<details>

<summary>

See `objectives` Sample!
</summary>

``` r
data_sample_list[["objectives"]]$data_sample
```

    ##      id              unit target               label
    ## 28   28        sweatdrops   most        sweatdrops ▲
    ## 80   80  understood words   most  understood words ▲
    ## 150 150     wrong guesses  least     wrong guesses ▼
    ## 101 101          balloons   most          balloons ▲
    ## 111 111 centimeters cubed   most centimeters cubed ▲
    ## 137 137             hertz   most             hertz ▲
    ## 133 133        characters   most        characters ▲
    ## 166 166  piled pineapples   most  piled pineapples ▲
    ## 144 144             signs   most             signs ▲
    ## 132 132         questions  least         questions ▼

</details>

<details>

<summary>

See `objectives` Summary!
</summary>

``` r
data_sample_list[["objectives"]]$data_summary
```

    ## query_output 
    ## 
    ##  4  Variables      179  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      179        0      179        1       90       90       60      9.9     18.8     45.5     90.0    134.5    161.2    170.1 
    ## 
    ## lowest :   1   2   3   4   5, highest: 175 176 177 178 179
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## unit 
    ##        n  missing distinct 
    ##      179        0      168 
    ## 
    ## lowest : % sand diverted  % signs obeyed   £                actual facts     alarms          , highest: understood words votes            white circles    wrong guesses    zip-lined items 
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## target 
    ##        n  missing distinct 
    ##      179        0        3 
    ##                                
    ## Value       least median   most
    ## Frequency      42      1    136
    ## Proportion  0.235  0.006  0.760
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## label 
    ##        n  missing distinct 
    ##      179        0      179 
    ## 
    ## lowest : % sand diverted ▲ % signs obeyed ▲  £ ▲               actual facts ▲    alarms ▼         , highest: votes ▲           white circles ▲   wrong guesses ▲   wrong guesses ▼   zip-lined items ▲
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

## `people`

The [`people` table](https://tdlm.fly.dev/taskmaster/people) provides a variety information on both contestants, the Taskmaster and Little Alex Horne. Included information is both Taskmaster specific (which `seat` are they in, the `team` they were part of, whether they were a `champion`), and more general information (`dob`, `gender`, left or right handed (`hand`).

`TMI` is an identifier for the on the `taskmaster.info` website that the data is collated from.

<details>

<summary>

See `people` Sample!
</summary>

``` r
data_sample_list[["people"]]$data_sample
```

    ##      id series seat              name        dob gender hand team champion TMI
    ## 28   28     -1    1      Bob Mortimer 1959-05-23      M    R   NA        0  42
    ## 80   80     13    3      Chris Ramsey 1986-08-03      M    R   29        0 310
    ## 22   22      4    5     Noel Fielding 1973-05-21      M    R    8        1  21
    ## 101 101     15    4 Kiell Smith-Bynoe 1989-03-05      M    R   34        0 394
    ## 108 108     -6    1    Deborah Meaden 1959-02-11      F    R   NA        0 512
    ## 111 111     -6    4   Steve Backshall 1973-04-21      M    R   NA        0 515
    ## 9     9      2    2     Joe Wilkinson 1975-05-02      M    R    4        0  70
    ## 5     5      1    3     Roisin Conaty 1979-03-26      F    R    2        0  15
    ## 38   38      7    1     James Acaster 1985-01-09      M    R   14        0   1
    ## 16   16      3    4       Rob Beckett 1986-01-02      M    R    5        1   8

</details>

<details>

<summary>

See `people` Summary!
</summary>

``` r
data_sample_list[["people"]]$data_summary
```

    ## query_output 
    ## 
    ##  10  Variables      117  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      117        0      117        1       59       59    39.33      6.8     12.6     30.0     59.0     88.0    105.4    111.2 
    ## 
    ## lowest :   1   2   3   4   5, highest: 113 114 115 116 117
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## series 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      115        2       23    0.998    4.696      4.5    8.146       -6       -5       -2        5       11       14       15 
    ## 
    ## lowest : -7 -6 -5 -4 -3, highest: 12 13 14 15 16
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## seat 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd 
    ##      115        2        5     0.96        3        3    1.614 
    ##                               
    ## Value        1   2   3   4   5
    ## Frequency   23  23  23  23  23
    ## Proportion 0.2 0.2 0.2 0.2 0.2
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## name 
    ##        n  missing distinct 
    ##      117        0      102 
    ## 
    ## lowest : Adrian Chiles           Aisling Bea             Al Murray               Alan Davies             Alex Horne             , highest: Susan Wokoma            Tim Key                 Tim Vine                Victoria Coren Mitchell Zoe Ball               
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## dob 
    ##        n  missing distinct 
    ##      117        0      102 
    ## 
    ## lowest : 1957-01-28 1957-07-23 1959-02-11 1959-05-23 1959-05-25, highest: 1992-12-29 1993-01-04 1993-05-28 1994-01-30 2009-03-18
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## gender 
    ##        n  missing distinct 
    ##      117        0        3 
    ##                             
    ## Value          F     M    NB
    ## Frequency     49    67     1
    ## Proportion 0.419 0.573 0.009
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## hand 
    ##        n  missing distinct 
    ##      117        0        2 
    ##                     
    ## Value         L    R
    ## Frequency     7  110
    ## Proportion 0.06 0.94
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## team 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##       80       37       32    0.999    18.23     18.5    12.74     2.00     4.00     8.75    16.50    28.25    33.10    35.00 
    ## 
    ## lowest :  1  2  3  4  5, highest: 32 33 34 35 36
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## champion 
    ##        n  missing distinct     Info      Sum     Mean 
    ##      117        0        2    0.354       16   0.1368 
    ## 
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## TMI 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      117        0      102        1    170.2    174.5    183.8      8.0     14.6     31.0     60.0    320.0    416.4    457.2 
    ## 
    ## lowest :   1   2   5   6   7, highest: 512 513 514 515 516
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

## `podcast`

The [`podcast` table](https://tdlm.fly.dev/taskmaster/podcast) provides information regarding the Official Taskmaster Podcast hosted by Ed Gamble (no the People’s Taskmaster). Information on who the podcast `guest` was, their `rating` for the podcast episode, and the `topic` is available (topic will typically be the latest episode broadcasted).

<details>

<summary>

See `podcast` Sample!
</summary>

``` r
data_sample_list[["podcast"]]$data_sample
```

    ##      id episode guest topic rating
    ## 28   28      28    67    90      5
    ## 80   80      79    78   110      5
    ## 101 101     100    90   120      5
    ## 111 111     110    46    56      5
    ## 137 137     136    82    71      3
    ## 133 133     132    27   137      4
    ## 144 144     143   103   142      5
    ## 132 132     131     0   136      5
    ## 98   98      97    38    53      4
    ## 103 103     102    52   122      4

</details>

<details>

<summary>

See `podcast` Summary!
</summary>

``` r
data_sample_list[["podcast"]]$data_summary
```

    ## query_output 
    ## 
    ##  5  Variables      150  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      150        0      150        1     75.5     75.5    50.33     8.45    15.90    38.25    75.50   112.75   135.10   142.55 
    ## 
    ## lowest :   1   2   3   4   5, highest: 146 147 148 149 150
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## episode 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      150        0      149        1    74.72     74.5    49.99     8.45    15.90    37.25    74.50   111.75   134.10   141.55 
    ## 
    ## lowest :   1   2   3   4   5, highest: 145 146 147 148 149
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## guest 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      150        0       68    0.992    40.54       40    39.61      0.0      0.0      4.0     40.0     67.0     92.3    100.5 
    ## 
    ## lowest :   0   1   2   4   6, highest: 103 104 105 106 107
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## topic 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      150        0      149        1    74.14       74    49.87     7.45    14.90    37.25    74.50   110.75   133.10   140.55 
    ## 
    ## lowest :   0   1   2   3   4, highest: 144 145 146 147 148
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## rating 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      149        1       12     0.72    4.829      4.8    1.632      2.4      3.0      4.0      5.0      5.0      5.0      5.0 
    ##                                                                                               
    ## Value       0.000  1.000  2.000  3.000  3.894  4.000  4.600  5.000  6.000  9.000 10.000 50.000
    ## Frequency       1      4      3     15      1     21      1     97      3      1      1      1
    ## Proportion  0.007  0.027  0.020  0.101  0.007  0.141  0.007  0.651  0.020  0.007  0.007  0.007
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

## `profanity`

The [`profanity` table](https://tdlm.fly.dev/taskmaster/profanity) details the profanity observed on the show. Each record details which `series`, `episode`, `task` the profanity occurred, who was the profanity offender (`speaker`), the offending words (`roots`) and the exact `quote`. Whether the profanity occurred in the studio or not (a pre-recorded task) is also available.

<details>

<summary>

See `profanity` Sample!
</summary>

``` r
data_sample_list[["profanity"]]$data_sample
```

    ##        id series episode task speaker                   roots                                                                                                                      quote studio
    ## 1308 1308     11      88  503       1                ["fuck"]                                        Well, I wouldn't have used those words, no, I would have said completely fucked it.      1
    ## 1872 1872     15     136  751      99                ["damn"]                                       I've had very few points for LOLs-based prize tasks, so here's some goddamn feeling.      1
    ## 1018 1018      9      67  393      48 ["ass/arse","ass/arse"]                                                               It just says Broad Arse now. Do you want a Broad Arse Award?      0
    ## 1942 1942     16     141  781     107             ["bastard"]                                                                                                       It is Chain Bastard.      0
    ## 1125 1125      9      74  428      49                ["fuck"] Were you just thinking, "Why have they saved this boring task for the end of the series?" Because fuck me, strap in, mate.      1
    ## 1004 1004      9      67  389       2                ["dick"]                                                                                                    The stick and the dick.      1
    ## 623   623      6      39  234      36                ["fuck"]                                                                                                            Oh, fucking...!      0
    ## 905   905      8      59  347      43                ["fuck"]                                                              "You may not leave the room." Fuck it, let's do that as well.      0
    ## 645   645      6      40  240      36             ["bastard"]                                                                             I'm just gonna have to Sellotape this bastard.      0
    ## 934   934      8      62  364       2                ["shit"]                                                                                                              It's so shit!      1

</details>

<details>

<summary>

See `profanity` Summary!
</summary>

``` r
data_sample_list[["profanity"]]$data_summary
```

    ## query_output 
    ## 
    ##  8  Variables      2041  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     2041        0     2041        1     1021     1021    680.7      103      205      511     1021     1531     1837     1939 
    ## 
    ## lowest :    1    2    3    4    5, highest: 2037 2038 2039 2040 2041
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## series 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     2041        0       21    0.996    8.271      8.5    5.597        1        2        5        8       12       15       16 
    ## 
    ## lowest : -5 -4 -3 -2 -1, highest: 12 13 14 15 16
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## episode 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     2041        0      148        1    70.17       70    49.61        6       12       34       67      108      132      141 
    ## 
    ## lowest :   1   2   3   4   5, highest: 144 145 146 147 148
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## task 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     2026       15      647        1    399.2      399      274    36.25    67.00   204.00   396.50   603.75   734.00   781.00 
    ## 
    ## lowest :   1   2   3   4   6, highest: 814 815 816 817 818
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## speaker 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     2041        0       99    0.974    36.44       35    37.98        2        2        2       34       63       91      101 
    ## 
    ## lowest :   0   1   2   3   4, highest: 103 104 105 106 107
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## roots 
    ##        n  missing distinct 
    ##     2041        0       69 
    ## 
    ## lowest : ["ass/arse","ass/arse"]                     ["ass/arse","bitch"]                        ["ass/arse"]                                ["bastard","bastard"]                       ["bastard"]                                , highest: ["twat"]                                    ["wank","cock"]                             ["wank","fuck","shit","cunt","tits","cock"] ["wank"]                                    ["whore"]                                  
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## quote 
    ##        n  missing distinct 
    ##     2041        0     1791 
    ## 
    ## lowest : 'Cause I thought I might have a shit while it was brewing.                                                         'Cause it ended up being dogshit!                                                                                  'Cause water's very fundamental to building sand bridges, ain't it? I'm sure that was on Countryfile or some shit. "'Fuck off!' roared Alex, grabbing the axe."                                                                       "And tiny bitch-puppet, Alex Horne."                                                                              
    ## highest: You wouldn't have "activated Jamali" at all if he hadn't said "What the fuck am I doing?"                          You wouldn't take some prick with a blow-up walking stick.                                                         You, sir, are shit.                                                                                                Your trophy's been pissed on already.                                                                              Yours looks like a sort of naan matador gone wrong. Fuckin' horrifying!                                           
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## studio 
    ##        n  missing distinct     Info      Sum     Mean 
    ##     2041        0        2    0.736     1158   0.5674 
    ## 
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

## `series`

The [`series` table](https://tdlm.fly.dev/taskmaster/series) details information at a series level. Information includes the number of `episodes` in the series, the `champion`, the total number of brodcasted `tasks`, and the total number of `points` awarded. Logistical information such as dates associated with the airing and studio record, and whether the series is a `special` is also available.

`TMI` is a id for the `taskmaster.info` website.

Further analysis of this table indicates that only information pertaining to the UK series of Taskmaster (regular and New Years Treat specials), are available.

<details>

<summary>

See `series` Sample!
</summary>

``` r
data_sample_list[["series"]]$data_sample
```

    ##    id      name episodes champion  air_start    air_end studio_start studio_end points tasks special TMI
    ## 16  9  Series 9       10       49 2019-09-04 2019-11-06   2019-07-18 2019-07-24    766    51       0  10
    ## 22 15 Series 15       10      102 2023-03-30 2023-06-01   2022-09-22 2022-09-28    765    50       0  56
    ## 5  -3  NYT 2022        1       73 2022-01-01 2022-01-01         <NA>       <NA>     68     5       1  47
    ## 12  5  Series 5        8       24 2017-09-13 2017-11-01   2017-07-03 2017-07-06    631    44       0   5
    ## 15  8  Series 8       10       45 2019-05-08 2019-07-10   2019-03-21 2019-03-27    749    54       0   9
    ## 9   2  Series 2        5       11 2016-06-21 2016-07-19         <NA>       <NA>    417    28       0   2
    ## 21 14 Series 14       10       88 2022-09-29 2022-12-01   2022-04-28 2022-05-05    796    52       0  55
    ## 6  -2  NYT 2021        1       62 2021-01-01 2021-01-01         <NA>       <NA>     62     5       1  12
    ## 4  -4    CoC II        1       87 2022-06-23 2022-06-23   2021-09-15 2021-09-15     66     5       1  46
    ## 2  -6  NYT 2024        0       NA 2024-01-01 2024-01-01   2023-11-27 2023-11-27     NA    NA       1  87

</details>

<details>

<summary>

See `series` Summary!
</summary>

``` r
data_sample_list[["series"]]$data_summary
```

    ## query_output 
    ## 
    ##  12  Variables      23  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##       23        0       23        1    4.696      4.5    8.443     -5.9     -4.8     -1.5      5.0     10.5     13.8     14.9 
    ## 
    ## lowest : -7 -6 -5 -4 -3, highest: 12 13 14 15 16
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## name 
    ##        n  missing distinct 
    ##       23        0       23 
    ## 
    ## lowest : CoC      CoC II   CoC III  NYT 2021 NYT 2022, highest: Series 5 Series 6 Series 7 Series 8 Series 9
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## episodes 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd 
    ##       23        0        7    0.885    6.435        6    4.466 
    ##                                                     
    ## Value          0     1     2     5     6     8    10
    ## Frequency      2     4     1     2     1     2    11
    ## Proportion 0.087 0.174 0.043 0.087 0.043 0.087 0.478
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## champion 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##       21        2       21        1    55.48     55.5    36.91       11       16       29       57       82       96      102 
    ## 
    ## lowest :   4  11  16  22  24, highest:  87  88  96 102 105
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## air_start 
    ##        n  missing distinct 
    ##       23        0       23 
    ## 
    ## lowest : 2015-07-28 2016-06-21 2016-10-04 2017-04-25 2017-09-13, highest: 2023-01-01 2023-03-30 2023-09-21 2024-??-?? 2024-01-01
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## air_end 
    ##        n  missing distinct 
    ##       23        0       23 
    ## 
    ## lowest : 2015-09-01 2016-07-19 2016-11-01 2017-06-13 2017-11-01, highest: 2023-01-01 2023-06-01 2023-11-23 2024-??-?? 2024-01-01
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## studio_start 
    ##        n  missing distinct 
    ##       16        7       16 
    ##                                                                                                                                                                                           
    ## Value      2015-03-23 2017-07-03 2017-11-20 2018-03-22 2018-07-19 2019-03-21 2019-07-18 2020-07-25 2021-09-15 2021-09-16 2022-04-28 2022-09-22 2022-11-22 2023-05-02 2023-11-27 2023-11-28
    ## Frequency           1          1          1          1          1          1          1          1          1          1          1          1          1          1          1          1
    ## Proportion      0.062      0.062      0.062      0.062      0.062      0.062      0.062      0.062      0.062      0.062      0.062      0.062      0.062      0.062      0.062      0.062
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## studio_end 
    ##        n  missing distinct 
    ##       16        7       16 
    ##                                                                                                                                                                                           
    ## Value      2015-03-25 2017-07-06 2017-11-20 2018-03-28 2018-07-25 2019-03-27 2019-07-24 2020-07-29 2021-09-15 2021-09-22 2022-05-05 2022-09-28 2022-11-22 2023-05-12 2023-11-27 2023-11-28
    ## Frequency           1          1          1          1          1          1          1          1          1          1          1          1          1          1          1          1
    ## Proportion      0.062      0.062      0.062      0.062      0.062      0.062      0.062      0.062      0.062      0.062      0.062      0.062      0.062      0.062      0.062      0.062
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## points 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##       21        2       21        1    545.2      576    319.3       66       68      386      721      766      796      816 
    ## 
    ## lowest :  62  66  68  76 164, highest: 778 795 796 816 837
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## tasks 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##       21        2       13    0.984     37.1       39    21.22        5        5       27       50       51       54       56 
    ##                                                                                         
    ## Value          5    10    27    28    32    44    46    50    51    52    54    56    57
    ## Frequency      4     1     1     1     1     1     1     4     3     1     1     1     1
    ## Proportion 0.190 0.048 0.048 0.048 0.048 0.048 0.048 0.190 0.143 0.048 0.048 0.048 0.048
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## special 
    ##        n  missing distinct     Info      Sum     Mean 
    ##       23        0        2    0.636        7   0.3043 
    ## 
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## TMI 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##       23        0       23        1    31.04       29    32.67      2.1      3.2      6.5     12.0     51.5     71.6     85.6 
    ## 
    ## lowest :  1  2  3  4  5, highest: 56 66 73 87 88
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

## `series_scores`

The [`series_scores` table](https://tdlm.fly.dev/taskmaster/series_scores) provides (`series`, `contestant` information). Namely, this is the `score` at the end of the series, and their overall `rank` within the series.

<details>

<summary>

See `series_scores` Sample!
</summary>

``` r
data_sample_list[["series_scores"]]$data_sample
```

    ##      id series contestant score rank
    ## 28   28     -1         30    35    3
    ## 80   80     13         82   173    1
    ## 22   22      5         24   138    1
    ## 101 101     16        103   155    2
    ## 9     9      2         11    94    1
    ## 5     5      1          7    88    4
    ## 38   38      7         40   176    1
    ## 16   16      4         18   129    4
    ## 4     4      1          6    93   2=
    ## 86   86     14         88   184    1

</details>

<details>

<summary>

See `series_scores` Summary!
</summary>

``` r
data_sample_list[["series_scores"]]$data_summary
```

    ## query_output 
    ## 
    ##  5  Variables      105  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      105        0      105        1       53       53    35.33      6.2     11.4     27.0     53.0     79.0     94.6     99.8 
    ## 
    ## lowest :   1   2   3   4   5, highest: 101 102 103 104 105
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## series 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      105        0       21    0.998    5.762        6    7.418       -4       -3        1        6       11       14       15 
    ## 
    ## lowest : -5 -4 -3 -2 -1, highest: 12 13 14 15 16
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## contestant 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      105        0      105        1       55       55    35.33      8.2     13.4     29.0     55.0     81.0     96.6    101.8 
    ## 
    ## lowest :   3   4   5   6   7, highest: 103 104 105 106 107
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## score 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      105        0       69        1      109      112    64.45     12.0     14.0     68.0    133.0    157.0    167.6    174.0 
    ## 
    ## lowest :   6  10  11  12  13, highest: 174 175 176 181 184
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## rank 
    ##        n  missing distinct 
    ##      105        0        8 
    ##                                                           
    ## Value          1     2    2=     3    3=     4    4=     5
    ## Frequency     21    18     8    16     4    16     4    18
    ## Proportion 0.200 0.171 0.076 0.152 0.038 0.152 0.038 0.171
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

## `special_locations`

The [`special_locations` table](https://tdlm.fly.dev/taskmaster/special_locations) has information for the location based tasks outside of the Taskmaster house. This includes the `name` and the latitude and longitude co-ordinates (`latlong`).

<details>

<summary>

See `special_locations` Sample!
</summary>

``` r
data_sample_list[["special_locations"]]$data_sample
```

    ##    id                             name               latlong
    ## 28 28                  Wormsley Estate -0.9316485,51.6428272
    ## 16 16                 J P S Stationers -0.6131217,51.7036744
    ## 26 26   Gatwick Airport South Terminal -0.1631023,51.1557464
    ## 22 22 Dukes Meadows Golf, Tennis & Ski -0.2653105,51.4737559
    ## 5   5                  Northala Fields -0.3716583,51.5396963
    ## 12 12     Chesham United Football Club  -0.613986,51.6988773
    ## 15 15        Girl Guiding Headquarters -0.6168708,51.7049596
    ## 9   9           Barn Elms Sports Trust -0.2328479,51.4741326
    ## 24 24         Chiltern Open Air Museum -0.5422757,51.6358058
    ## 6   6                Chesham Town Hall -0.6138502,51.7048446

</details>

<details>

<summary>

See `series` Summary!
</summary>

``` r
data_sample_list[["special_locations"]]$data_summary
```

    ## query_output 
    ## 
    ##  3  Variables      28  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##       28        0       28        1     14.5     14.5    9.667     2.35     3.70     7.75    14.50    21.25    25.30    26.65 
    ## 
    ## lowest :  1  2  3  4  5, highest: 24 25 26 27 28
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## name 
    ##        n  missing distinct 
    ##       28        0       28 
    ## 
    ## lowest : All Saints Pastoral Centre     Barn Elms Sports Trust         Barnes Hockey Club             Barnes Sports Club             Buckinghamshire Railway Centre, highest: Thames Riverbank               The Black Horse Inn            White Waltham Airfield         Woodrow High House             Wormsley Estate               
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## latlong 
    ##        n  missing distinct 
    ##       28        0       28 
    ## 
    ## lowest : -0.043288,51.4979182  -0.1631023,51.1557464 -0.2328479,51.4741326 -0.2477399,51.477788  -0.2522033,51.4765784, highest: -0.7557284,51.6302973 -0.7735901,51.4945097 -0.7917774,51.1575941 -0.9280446,51.8644793 -0.9316485,51.6428272
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

## `task_briefs`

The [`task_briefs` table](https://tdlm.fly.dev/taskmaster/task_briefs), as the name suggests provides the exact `brief` that was provided to contestants.

<details>

<summary>

See `task_briefs` Sample!
</summary>

``` r
data_sample_list[["task_briefs"]]$data_sample
```

    ##      id task                                                                                                                                                                                                                                                                                                                                                                                       brief
    ## 284 284  284                 Dramatically alter your appearance.\nMost dramatic alteration wins.\nYou may start altering your appearance when you are inside the lift and the doors are closed.\nYou must stop altering your appearance when the doors open again.\nYou may inspect the contents of the briefcase for five minutes before the lift doors open for the first time.\nYour time starts now.
    ## 101 101  101                                                                                                                                                                                                                                       Paint the best picture of the Taskmaster.\nOnly the paint and brush may touch the mat, easel and canvas.\nYou have 10 minutes.\nYour time starts now.
    ## 623 623  623                                                                                                                    Answer Alex's phone call.\nIf you find a cuddly toy, you must carry it with you until you answer Alex's phone call.\nAlso, you must be making a noise over 50 decibels for at least 50% of the time until you answer Alex's phone.\nFastest wins.\nYour time starts now.
    ## 645 645  645                                                       Poke a part of your body out of the shower curtain and waggle it about for 10 seconds.\nThe Taskmaster will guess what part of the body it is.\nThe biggest part of the body that the Taskmaster incorrectly identifies wins.\nYou must poke your body part out of the shower curtain and waggle it about within the next 15 minutes.
    ## 400 400  400                                                                                                                                                                                                                                                                                                                                                            Bring in the best defunct thing.
    ## 98   98   98                                   Make the most juice.\nYou must pick one fruit and one tool.\nIf you pick the same tool as someone else, you must juice blindfolded.\nIf you pick the same fruit as someone else, you must juice one-handed.\nIf you pick the same fruit and tool as someone else, you must juice blindfolded, one-handed, and bouncing up and down.\nYou have one minute.
    ## 103 103  103                                                                      Without touching the egg or the eggcup, get the egg into the eggcup.\nYou may only use the equipment currently on the table.\nIf you touch a piece of equipment that another contestant touches, you will both receive a one minute time penalty per piece of equipment touched.\nFastest wins.\nYour time starts now.
    ## 726 726  726                                                                                                                                                                                                                                                                                                                                                             Bring in the most heroic thing.
    ## 602 602  602 Count to 13 as a group, each player taking it in turns to say a number.\nEvery time you say an odd number, you must also squat.\nEvery time you say an even number, you must also jump.\nIf you make a mistake, you are out.\nIf you reach 13, or someone is eliminated, other rules will be introduced.\nIf the Taskmaster thinks you have hesitated for too long, you will be eliminated.
    ## 326 326  326                                      Alex is on the bridge in the distance with lights on his head.\nGet as close as you can to Alex without him noticing you.\nAlex will duck down the wall for 10 seconds, then pop up for 10 seconds, then duck down for 10 seconds and so on until he notices you.\nThe task starts when Alex first ducks down behind the wall, in one minute from now.

</details>

<details>

<summary>

See `task_briefs` Summary!
</summary>

``` r
data_sample_list[["task_briefs"]]$data_summary
```

    ## query_output 
    ## 
    ##  3  Variables      819  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      819        0      819        1      410      410    273.3     41.9     82.8    205.5    410.0    614.5    737.2    778.1 
    ## 
    ## lowest :   1   2   3   4   5, highest: 815 816 817 818 819
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## task 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      819        0      819        1      410      410    273.3     41.9     82.8    205.5    410.0    614.5    737.2    778.1 
    ## 
    ## lowest :   1   2   3   4   5, highest: 815 816 817 818 819
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## brief 
    ##        n  missing distinct 
    ##      819        0      819 
    ## 
    ## lowest : Accurately and emotionally recreate a great moment from history using these two traffic cones.
    ## Most accurate and emotional recreation wins.
    ## You've got 30 minutes.
    ## Your time starts now.                                                                                                                                                                Achieve a rally of exactly 24 shots.
    ## You much each take the same amount of shots.
    ## You must be stood at least 6’8” apart from one another.
    ## The object stuck must neither touch the ground nor be held at any point during the rally.
    ## There is a bonus point for the team which uses the most ambitious equipment.
    ## Fastest wins.
    ## Your time starts now. Achieve the greatest splat.
    ## One teammate must be splatted for the splat to be valid.
    ## You have 10 minutes to choose your splatting materials, and then 10 minutes to pull off your splat.
    ## Your time starts now.                                                                                                                                          Achieve the most impressive effect with a single breath.
    ## You must take your breath and achieve your effect within the next 20 minutes.                                                                                                                                                                                                                    Act out the nursery rhymes for the Taskmaster to guess.
    ## Each team has three minutes to act out their nursery rhymes.
    ## Most nursery rhymes guessed by the taskmaster wins.
    ## You must remain silent and on your spots throughout.                                                                                                                          
    ## highest: Write the name of a different animal on each face of your dice.
    ## You have 100 seconds.                                                                                                                                                                                                                                                                     Write the name of a profession in this hole then open the task.
    ## 
    ## Perform an original lullaby for [your profession].
    ## Most soporific profession-specific lullaby wins.
    ## You have 30 minutes.
    ## Your time starts now.                                                                                                                                       Write your name and draw a picture of a happy horse on your overhead projector acetate, upside-down.
    ## You must not rotate or manipulate your acetate.
    ## You have 100 seconds.
    ## Most accurate picture and writing when your acetate is overhead projected wins.                                                                                              Write, illustrate and read out a bedtime story for grown-ups.
    ## Your bedtime story for grown-ups may be no more or fewer than 50 words.
    ## Most engrossing bedtime story for grown-ups wins.
    ## You have one hour.
    ## Your time starts now.                                                                                                                       You will each be given a category.
    ## You each have 10 seconds to say things that fall into that category.
    ## First, you must each predict how many correct answers you will give.
    ## The person who has successfully predicted the highest number wins.                                                                                                        
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

## `task_readers`

The [`task_readers` table](https://tdlm.fly.dev/taskmaster/task_readers) contains information on which contestant (`reader`) read a particular task, whether the task was a `team` task, and if the task was `live` or not.

Note, that a task can have multiple readers associated with it as it is common for multiple readers to be edited together in a show.

<details>

<summary>

See `task_readers` Sample!
</summary>

``` r
data_sample_list[["task_readers"]]$data_sample
```

    ##      id task reader team live
    ## 284 284  785    103    1    0
    ## 101 101  315     40    1    0
    ## 111 111  343     47    1    0
    ## 133 133  388     50    0    1
    ## 98   98  303     39    1    0
    ## 103 103  316     39    0    1
    ## 214 214  615     80    1    0
    ## 90   90  286     38    0    1
    ## 79   79  252     33    0    1
    ## 270 270  755     98    1    1

</details>

<details>

<summary>

See `task_readers` Summary!
</summary>

``` r
data_sample_list[["task_readers"]]$data_summary
```

    ## query_output 
    ## 
    ##  5  Variables      300  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      300        0      300        1    150.5    150.5    100.3    15.95    30.90    75.75   150.50   225.25   270.10   285.05 
    ## 
    ## lowest :   1   2   3   4   5, highest: 296 297 298 299 300
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## task 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      300        0      218        1    435.6      436    272.5    58.75    91.00   238.00   437.50   650.00   755.20   785.10 
    ## 
    ## lowest :   5  11  17  23  26, highest: 806 809 814 818 819
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## reader 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      300        0       86        1    55.08     54.5    36.19     4.00    12.00    33.75    51.00    82.00   101.10   104.05 
    ## 
    ## lowest :   1   3   4   5   6, highest: 103 104 105 106 107
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## team 
    ##        n  missing distinct     Info      Sum     Mean 
    ##      300        0        2    0.746      161   0.5367 
    ## 
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## live 
    ##        n  missing distinct     Info      Sum     Mean 
    ##      300        0        2    0.749      155   0.5167 
    ## 
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

## `task_winners`

The [`task_winners` table](https://tdlm.fly.dev/taskmaster/task_winners) naturally has all the information about the contestant(s) who won the task (`winner`), whether it was a `team` task, and if it was a `live` task or not.

<details>

<summary>

See `task_winners` Sample!
</summary>

``` r
data_sample_list[["task_winners"]]$data_sample
```

    ##        id task winner team live
    ## 1018 1018  805    106    0    0
    ## 1004 1004  796    103    1    0
    ## 623   623  511     64    0    0
    ## 905   905  723     99    1    0
    ## 645   645  527     66    0    0
    ## 934   934  747     99    0    0
    ## 400   400  335     47    0    0
    ## 900   900  721    101    0    0
    ## 98     98   86     13    1    0
    ## 726   726  590     72    1    0

</details>

<details>

<summary>

See `task_winners` Summary!
</summary>

``` r
data_sample_list[["task_winners"]]$data_summary
```

    ## query_output 
    ## 
    ##  5  Variables      1036  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     1036        0     1036        1    518.5    518.5    345.7    52.75   104.50   259.75   518.50   777.25   932.50   984.25 
    ## 
    ## lowest :    1    2    3    4    5, highest: 1032 1033 1034 1035 1036
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## task 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     1036        0      795        1    423.4    423.5    272.9    45.75    91.00   226.00   424.50   633.25   745.50   780.25 
    ## 
    ## lowest :   1   2   3   4   5, highest: 815 816 817 818 819
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## winner 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##     1036        0       99        1     55.8     55.5     34.2       10       16       34       52       80      101      104 
    ## 
    ## lowest :   3   4   5   6   7, highest: 103 104 105 106 107
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## team 
    ##        n  missing distinct     Info      Sum     Mean 
    ##     1036        0        2    0.546      248   0.2394 
    ## 
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## live 
    ##        n  missing distinct     Info      Sum     Mean 
    ##     1036        0        2     0.48      207   0.1998 
    ## 
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

## `tasks`

The [`tasks` table](https://tdlm.fly.dev/taskmaster/tasks) has high level data about tasks that is mostly independent of the contestants and the outcome. This includes the `series` and `episode` that the task featured in, the main `summary` of the task. Categorisation of the task is also available such as whether it is a subjective or objective task, if it is TM UK original, if it was filmed or live.

- The `location` field in this table is not limited to the `special_locations` but also the whereabouts in the TM house, and the studio.
- The `points` field highlights the total number of points distributed to contestants by the Taskmaster.
- `std` is a flag to denote whether the task was standard (one having 5 judged attempts)
- `YT` is a YouTube link to the corresponding episode and timestamp of that particular task.

<details>

<summary>

See `tasks` Sample!
</summary>

``` r
data_sample_list[["tasks"]]$data_sample
```

    ##      id series episode                                                         summary                                                                                             tags           location points std  TMI               YT
    ## 284 284      7      48                                Change your appearance in a lift                   ["solo","filmed","creative","physical","subjective","single-brief","original"]                 17     15   1  284 M0ZbPzHUiAo|1050
    ## 101 101      4      18 Paint a portrait of the Taskmaster without touching the red mat ["solo","filmed","creative","mental","physical","subjective","single-brief","original","handly"]           doorstep     14   1  101  FM73_GZGDbA|832
    ## 623 623     13     111                                        Answer Alex's phone call                      ["solo","filmed","mental","physical","objective","single-brief","original"]             lounge     15   1 1947 UOasWQl-Tww|1813
    ## 645 645     13     115                      Poke a body part out of the shower curtain                    ["solo","filmed","creative","physical","objective","single-brief","original"] behind the caravan     14   1 2001 bPZ47tW4dOQ|1705
    ## 400 400      9      69                                          The best defunct thing                               ["solo","prize","creative","subjective","single-brief","original"]              seats     15   1  401  G_0_mIgC-fw|164
    ## 98   98      4      17                                       Make the most fruit juice                                 ["solo","live","physical","objective","single-brief","original"]              stage     15   1   98 DpV3rweizNA|2322
    ## 103 103      4      18                Put an egg in an egg cup without touching either                      ["solo","filmed","mental","physical","objective","single-brief","original"]                lab     15   1  103 FM73_GZGDbA|1835
    ## 726 726     15     131                                           The most heroic thing                               ["solo","prize","creative","subjective","single-brief","original"]              seats     15   1 2507  7-cPcNMEehU|168
    ## 602 602     13     107                                                     Count to 13                                   ["solo","live","mental","objective","single-brief","original"]              stage     15   1 1871 Tv_q0RMaV6Y|2416
    ## 326 326      8      55                                                Sneak up on Alex                      ["solo","filmed","physical","social","objective","single-brief","original"]                 18     16   1  327 39n5LJel7qk|1708

</details>

<details>

<summary>

See `tasks` Summary!
</summary>

``` r
data_sample_list[["tasks"]]$data_summary
```

    ## query_output 
    ## 
    ##  10  Variables      819  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      819        0      819        1      410      410    273.3     41.9     82.8    205.5    410.0    614.5    737.2    778.1 
    ## 
    ## lowest :   1   2   3   4   5, highest: 815 816 817 818 819
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## series 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      819        0       21    0.996    8.549      8.5    5.522        1        2        5        9       13       15       16 
    ## 
    ## lowest : -5 -4 -3 -2 -1, highest: 12 13 14 15 16
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## episode 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      819        0      148        1    72.18       72    49.65      7.0     14.8     34.5     71.0    110.0    133.0    141.0 
    ## 
    ## lowest :   1   2   3   4   5, highest: 144 145 146 147 148
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## summary 
    ##        n  missing distinct 
    ##      819        0      817 
    ## 
    ## lowest : A photo of an object that looks like you               Achieve an impressive effect with a single breath      Act out nursery rhymes                                 An upside-down condiment self-portrait                 Anchor balloons using bread                           , highest: Write and perform a 30-second jingle                   Write and perform a song about a stranger              Write and perform lyrics for the Taskmaster theme tune Write down things that fit the category                Zipwire items to the Taskmaster                       
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## tags 
    ##        n  missing distinct 
    ##      819        0      200 
    ## 
    ## lowest : ["solo","filmed","creative","combination","single-brief","original","novel-brief"]                             ["solo","filmed","creative","mental","physical","objective","single-brief","adapted"]                          ["solo","filmed","creative","mental","physical","objective","single-brief","original","bonus-points","handly"] ["solo","filmed","creative","mental","physical","objective","single-brief","original","bonus-points"]          ["solo","filmed","creative","mental","physical","objective","single-brief","original"]                        
    ## highest: ["team","split","filmed","mental","physical","subjective","single-brief","original"]                           ["team","split","filmed","mental","social","objective","single-brief","original"]                              ["team","split","filmed","physical","social","objective","multiple-brief","original"]                          ["team","split","filmed","physical","social","objective","single-brief","adapted"]                             ["team","split","filmed","physical","social","objective","single-brief","original"]                           
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## location 
    ##        n  missing distinct 
    ##      819        0       65 
    ## 
    ## lowest : 1             10            11            12            13           , highest: shed entryway split special stage         studio        unknown      
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## points 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      782       37       28    0.913    14.65       15    3.681     5.05    10.00    14.00    15.00    16.00    18.00    20.00 
    ## 
    ## lowest :  0  1  2  3  4, highest: 23 24 25 30 50
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## std 
    ##        n  missing distinct     Info      Sum     Mean 
    ##      819        0        2    0.139      779   0.9512 
    ## 
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## TMI 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      814        5      814        1      926      877    993.8    41.65    82.30   204.25   408.50  1908.75  2519.70  2725.35 
    ## 
    ## lowest :    1    2    3    4    5, highest: 2845 2846 2847 2848 2849
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## YT 
    ##        n  missing distinct 
    ##      819        0      819 
    ## 
    ## lowest : __fkje7NnP4|1210 __fkje7NnP4|162  __fkje7NnP4|1946 __fkje7NnP4|2478 __fkje7NnP4|408 , highest: ZWmqBUj680A|168  ZWmqBUj680A|1806 ZWmqBUj680A|2351 ZWmqBUj680A|430  ZWmqBUj680A|976 
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

## `tasks_by_objective`

The [`tasks_by_objective` table](https://tdlm.fly.dev/taskmaster/tasks_by_objective) provides a high level overview of the task and the `objective` (the `measurement` and desired direction to be deemed successful).

<details>

<summary>

See `tasks_by_objective` Sample!
</summary>

``` r
data_sample_list[["tasks_by_objective"]]$data_sample
```

    ##      id task objective
    ## 284 284  565        35
    ## 336 336  662         1
    ## 406 406  787       173
    ## 101 101  188        54
    ## 111 111  210        60
    ## 393 393  768        48
    ## 133 133  259        73
    ## 400 400  779         2
    ## 388 388  758       168
    ## 98   98  184        51

</details>

<details>

<summary>

See `tasks_by_objective` Summary!
</summary>

``` r
data_sample_list[["tasks_by_objective"]]$data_summary
```

    ## query_output 
    ## 
    ##  3  Variables      425  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      425        0      425        1      213      213      142     22.2     43.4    107.0    213.0    319.0    382.6    403.8 
    ## 
    ## lowest :   1   2   3   4   5, highest: 421 422 423 424 425
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## task 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      425        0      391        1      418    417.5    280.9     37.4     73.8    202.0    439.0    627.0    745.8    781.6 
    ## 
    ## lowest :   2   4   6   8   9, highest: 809 811 813 814 819
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## objective 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      425        0      179    0.968    48.86       46    57.95      2.0      2.0      2.0     32.0     91.0    138.6    159.8 
    ## 
    ## lowest :   1   2   3   4   5, highest: 175 176 177 178 179
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

## `team_tasks`

The [`team_tasks` table](https://tdlm.fly.dev/taskmaster/team_tasks) focuses just on team tasks, the teams involved (`team`), and whether that particular team won (`win`).

<details>

<summary>

See `team_tasks` Sample!
</summary>

``` r
data_sample_list[["team_tasks"]]$data_sample
```

    ##      id task team win
    ## 28   28  155   10   0
    ## 80   80  403   18   1
    ## 150 150  670   32   1
    ## 101 101  481   21   1
    ## 111 111  518   25   1
    ## 137 137  615   29   1
    ## 133 133  606   29   1
    ## 166 166  729   34   0
    ## 144 144  650   30   1
    ## 132 132  590   28   0

</details>

<details>

<summary>

See `team_tasks` Summary!
</summary>

``` r
data_sample_list[["team_tasks"]]$data_summary
```

    ## query_output 
    ## 
    ##  4  Variables      190  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      190        0      190        1     95.5     95.5    63.67    10.45    19.90    48.25    95.50   142.75   171.10   180.55 
    ## 
    ## lowest :   1   2   3   4   5, highest: 186 187 188 189 190
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## task 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      190        0       95        1    448.6    451.5    261.4     60.8    102.0    277.0    462.0    647.8    748.0    776.1 
    ## 
    ## lowest :  23  30  35  53  59, highest: 782 785 796 809 818
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## team 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      190        0       36    0.999    20.99       21     11.6        4        7       13       22       30       34       35 
    ## 
    ## lowest :  1  2  3  4  5, highest: 32 33 34 35 36
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## win 
    ##        n  missing distinct     Info      Sum     Mean 
    ##      190        0        2    0.746      102   0.5368 
    ## 
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

## `teams`

The [`teams` table](https://tdlm.fly.dev/taskmaster/teams) provides information on teams, regardless of the tasks themselves. The contestants who make up the team `members`, the `size` of the team, and whether the team is `irregular` or not, are also outlined.

An `irregular` team occurs on the rare occasion when the a team for a live task differs to the previous tasks (pre-recorded or live). This namely occurred in Series 9 when someone wanted to the see rage of Ed Gamble, and Series 10’s hippogate.

<details>

<summary>

See `teams` Sample!
</summary>

``` r
data_sample_list[["teams"]]$data_sample
```

    ##    id series                      members size initials irregular
    ## 28 28     12     Desiree, Guz and Morgana    3     DG+M         0
    ## 16 16      8           Iain, Lou and Paul    3     IL+P         0
    ## 22 22     10 Johnny, Katherine and Mawaan    3     JK+M         0
    ## 9   9      5                Mark and Nish    2      M+N         0
    ## 5   5      3                 Rob and Sara    2      R+S         0
    ## 6   6      3            Al, Dave and Paul    3     AD+P         0
    ## 35 35     16                Sue and Susan    2      S+S         0
    ## 4   4      2       Doc, Joe and Katherine    3     DJ+K         0
    ## 2   2      1      Josh, Roisin and Romesh    3     JR+R         0
    ## 7   7      4                 Hugh and Mel    2      H+M         0

</details>

<details>

<summary>

See `teams` Summary!
</summary>

``` r
data_sample_list[["teams"]]$data_summary
```

    ## query_output 
    ## 
    ##  6  Variables      36  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##       36        0       36        1     18.5     18.5    12.33     2.75     4.50     9.75    18.50    27.25    32.50    34.25 
    ## 
    ## lowest :  1  2  3  4  5, highest: 32 33 34 35 36
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## series 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##       36        0       16    0.996    8.611      8.5    5.149     1.75     2.50     5.00     9.00    12.00    14.50    15.25 
    ##                                                                                                           
    ## Value          1     2     3     4     5     6     7     8     9    10    11    12    13    14    15    16
    ## Frequency      2     2     2     2     2     2     2     2     4     4     2     2     2     2     2     2
    ## Proportion 0.056 0.056 0.056 0.056 0.056 0.056 0.056 0.056 0.111 0.111 0.056 0.056 0.056 0.056 0.056 0.056
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## members 
    ##        n  missing distinct 
    ##       36        0       36 
    ## 
    ## lowest : Aisling, Bob and Sally Al, Dave and Paul      Alan and Victoria      Alice and Russell      Ardal and Chris       , highest: Lee and Mike           Mark and Nish          Munya and Sarah        Rob and Sara           Sue and Susan         
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## size 
    ##        n  missing distinct     Info     Mean 
    ##       36        0        2    0.751      2.5 
    ##                   
    ## Value        2   3
    ## Frequency   18  18
    ## Proportion 0.5 0.5
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## initials 
    ##        n  missing distinct 
    ##       36        0       35 
    ## 
    ## lowest : A+C  A+R  A+V  AB+S AD+P, highest: L+M  M+N  M+S  R+S  S+S 
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## irregular 
    ##        n  missing distinct     Info      Sum     Mean 
    ##       36        0        2    0.297        4   0.1111 
    ## 
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

## `title_coiners`

The [`title_coiners` table](https://tdlm.fly.dev/taskmaster/title_coiners) archives all episode titles, who was responsible for the title (`coiner`, not limited to contestants and is sometimes blank as it could refer to a general vibe), and during which `task` the title was uttered in.

<details>

<summary>

See `title_coiners` Sample!
</summary>

``` r
data_sample_list[["title_coiners"]]$data_sample
```

    ##      id episode coiner task
    ## 28   28      28     24  163
    ## 80   80      80     NA  462
    ## 101 101     101     72  570
    ## 111 111     111     78  624
    ## 137 137     137     98  757
    ## 133 133     133      2  738
    ## 132 132     132    101  733
    ## 98   98      98      2  555
    ## 103 103     103     70  578
    ## 90   90      90      2  514

</details>

<details>

<summary>

See `title_coiners` Summary!
</summary>

``` r
data_sample_list[["title_coiners"]]$data_summary
```

    ## query_output 
    ## 
    ##  4  Variables      148  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      148        0      148        1     74.5     74.5    49.67     8.35    15.70    37.75    74.50   111.25   133.30   140.65 
    ## 
    ## lowest :   1   2   3   4   5, highest: 144 145 146 147 148
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## episode 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      148        0      148        1     74.5     74.5    49.67     8.35    15.70    37.75    74.50   111.25   133.30   140.65 
    ## 
    ## lowest :   1   2   3   4   5, highest: 144 145 146 147 148
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## coiner 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      142        6       50    0.978    39.76     40.5    42.46      1.0      2.0      2.0     34.0     78.0     98.0    102.9 
    ## 
    ## lowest :   1   2   5   7   9, highest: 102 103 104 105 107
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## task 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      148        0      148        1      423    423.5    272.9    48.05    88.80   224.00   431.00   625.25   739.80   777.90 
    ## 
    ## lowest :   2   9  16  20  31, highest: 797 803 807 812 818
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

## `title_stats`

The [`title_stats` table](https://tdlm.fly.dev/taskmaster/title_stats) is an insights based table providing various on the statistics on the episode titles, namely the number of `words` and `syllables` in the title.

<details>

<summary>

See `title_stats` Sample!
</summary>

``` r
data_sample_list[["title_stats"]]$data_sample
```

    ##      id series episode                     title words syllables
    ## 28   28      5       4  Residue around the hoof.     4         7
    ## 80   80     10       6             Hippopotamus.     1         5
    ## 101 101     12       6       A chair in a sweet.     5         5
    ## 111 111     13       5  Having a little chuckle.     4         7
    ## 137 137     15       9    A show about pedantry.     4         7
    ## 133 133     15       5             Old Honkfoot.     2         3
    ## 132 132     15       4   How heavy is the water?     5         7
    ## 98   98     12       3 The end of the franchise.     5         6
    ## 103 103     12       8       A couple of Ethels.     4         6
    ## 90   90     11       5            Slap and tong.     3         3

</details>

<details>

<summary>

See `title_stats` Summary!
</summary>

``` r
data_sample_list[["title_stats"]]$data_summary
```

    ## query_output 
    ## 
    ##  6  Variables      148  Observations
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## id 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      148        0      148        1     74.5     74.5    49.67     8.35    15.70    37.75    74.50   111.25   133.30   140.65 
    ## 
    ## lowest :   1   2   3   4   5, highest: 144 145 146 147 148
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## series 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      148        0       21    0.996    8.764        9    5.553        1        2        5        9       13       15       16 
    ## 
    ## lowest : -5 -4 -3 -2 -1, highest: 12 13 14 15 16
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## episode 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      148        0       10    0.989    4.966        5    3.286        1        1        2        5        7        9       10 
    ##                                                                       
    ## Value          1     2     3     4     5     6     7     8     9    10
    ## Frequency     21    17    16    16    16    14    13    13    11    11
    ## Proportion 0.142 0.115 0.108 0.108 0.108 0.095 0.088 0.088 0.074 0.074
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## title 
    ##        n  missing distinct 
    ##      148        0      148 
    ## 
    ## lowest : 100% Bosco.              A chair in a sweet.      A coquettish fascinator. A couple of Ethels.      A cuddle.               , highest: Welcome to Rico Face.    What kind of pictures?   Wiley giraffe blower.    You've got no chutzpah.  You tuper super.        
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## words 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd 
    ##      148        0        7     0.95    3.338      3.5    1.443 
    ##                                                     
    ## Value          1     2     3     4     5     6     7
    ## Frequency     13    26    42    37    26     3     1
    ## Proportion 0.088 0.176 0.284 0.250 0.176 0.020 0.007
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    ## syllables 
    ##        n  missing distinct     Info     Mean  pMedian      Gmd      .05      .10      .25      .50      .75      .90      .95 
    ##      148        0       10    0.968    5.081        5    2.032        2        3        4        5        6        7        8 
    ##                                                                       
    ## Value          1     2     3     4     5     6     7     8     9    11
    ## Frequency      4     6    16    30    37    24    20     4     5     2
    ## Proportion 0.027 0.041 0.108 0.203 0.250 0.162 0.135 0.027 0.034 0.014
    ## 
    ## For the frequency table, variable is rounded to the nearest 0
    ## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

</details>

[^1]: This is definitely the corporate side of me talking. If you’ve ever experienced with dealing with large scale systems with multiple moving parts, limited resources and knowing what hard bottlenecks in your work, you’ll know what I mean.

[^2]: Honestly, I didn’t know that points had gone misplaced. I should return my card to the TM fan club…

[^3]: I’m not a big fan of “1=”, etc. being used to denote a tied ranking. It ultimately means the field is no longer an integer and needs additional care to be treated correctly.

[^4]: I’m very surprised that such a dataset exists, and someone has gone to the effort of dissecting each intro sequence to such a minutiae. Saying that, this is the TM fan base…
