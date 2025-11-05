# Script to perform historic performance summary

# I want to compare each contestants performance in this episode, to their performance from prior episodes in the series.
# This is both at a episode final score (and ranking), and individual task performance

# Series Tracker data frame. Episode x Contestant granularity
series_points_df <- task_attempt_df %>% group_by(Series_ID, Contestant, Episode_ID) %>%
    arrange(Episode_ID) %>%
    reframe(
        Num_Tasks = n_distinct(Task_ID),
        Ep_Points = sum(Points)
    ) %>% 
    group_by(Series_ID, Episode_ID) %>%
    mutate(
        Ep_Ranking = rank(-Ep_Points, ties.method = "min")
    ) %>%
    group_by(Series_ID, Contestant) %>%
    arrange(Episode_ID) %>%
    mutate(
        Series_Points = cumsum(Ep_Points)
    ) %>%
    group_by(Series_ID, Episode_ID) %>%
    mutate(
        Series_Ranking = rank(-Series_Points, ties.method = "min")
    ) %>%
    left_join(contestants_df, by = join_by(Contestant == Contestant_Name))


latest_df <- series_points_df %>% 
    filter(Episode_ID == sim_max_episode_used)


past_df <- series_points_df %>% filter(Episode_ID < sim_max_episode_used)

past_summary_df <- past_df %>% group_by(Series_ID, Contestant, Initials, Image_URL, Seat) %>%
    reframe(
        Num_Eps = n_distinct(Episode_ID),
        Min_Ep_ID = min(Episode_ID),
        Max_Ep_ID = max(Episode_ID), 
        Ep_Points_Summary = list(summary(Ep_Points)),
        Min_Ep_Points = min(Ep_Points),
        P25_Ep_Points = quantile(Ep_Points, probs = 0.25),
        Median_Ep_Points = quantile(Ep_Points, probs = 0.5),
        P75_Ep_Points = quantile(Ep_Points, probs = 0.75),
        Max_Ep_Points = max(Ep_Points),
        Mean_Ep_Points = mean(Ep_Points),
        Std_Dev_Ep_Points = sd(Ep_Points),
        Ep_Rank_Summary = list(table(Ep_Ranking))
    )


grade_levels <- c("A (Best Ever)", "B+ (Very Good)", "B (Good)", "C (Bad)", "C- (Very Bad)", "D (Worst Ever)")
grade_colours <- brewer.pal(6, "RdYlGn")

grade_lookup_df <- data.frame("Grade" = grade_levels, "Colour" = rev(grade_colours))


compare_curr_ep_df <- past_summary_df[c("Series_ID", "Contestant", "Initials", "Image_URL", "Seat", "Num_Eps", "Min_Ep_Points", "P25_Ep_Points", "Median_Ep_Points", "P75_Ep_Points", "Max_Ep_Points", "Mean_Ep_Points", "Std_Dev_Ep_Points")] %>% 
    left_join(latest_df[c("Series_ID", "Contestant", "Initials", "Image_URL", "Seat", "Episode_ID", "Ep_Points", "Ep_Ranking")], 
              by = join_by(Series_ID == Series_ID, Contestant == Contestant, Initials == Initials, Image_URL == Image_URL, Seat == Seat )) %>%
    rename(Current_Ep_ID = Episode_ID,
           Current_Ep_Points = Ep_Points,
           Current_Ep_Ranking = Ep_Ranking 
    ) %>% mutate(
        Current_Ep_Grade = case_when(
            (Max_Ep_Points < Current_Ep_Points ) ~ grade_lookup_df[1,"Grade"],
            ((P75_Ep_Points <= Current_Ep_Points)) ~ grade_lookup_df[2,"Grade"],
            ((Median_Ep_Points <= Current_Ep_Points) ) ~ grade_lookup_df[3,"Grade"],
            ((P25_Ep_Points <= Current_Ep_Points) ) ~ grade_lookup_df[4,"Grade"],
            ((Min_Ep_Points <= Current_Ep_Points)) ~ grade_lookup_df[5,"Grade"],
            (Current_Ep_Points < Min_Ep_Points) ~ grade_lookup_df[6,"Grade"]
          
        ),
        Current_Ep_Grade_Colour = case_when(
            Current_Ep_Grade == "A (Best Ever)" ~ grade_lookup_df[1,"Colour"],
            Current_Ep_Grade ==  "B+ (Very Good)" ~ grade_lookup_df[2,"Colour"],
            Current_Ep_Grade ==  "B (Good)" ~ grade_lookup_df[3,"Colour"],
            Current_Ep_Grade == "C (Bad)" ~ grade_lookup_df[4,"Colour"],
            Current_Ep_Grade ==  "C- (Very Bad)" ~ grade_lookup_df[5,"Colour"],
            Current_Ep_Grade == "D (Worst Ever)" ~ grade_lookup_df[6,"Colour"]
        ),
        Ep_Performance_Summary = glue("[Min: {min}, P25: {p25}, Median: {med}, P75: {p75}, Max: {max}, Mean: {mean}:, StdDev: {sd}]", min = number(Min_Ep_Points), p25 = P25_Ep_Points, med = Median_Ep_Points, p75= P75_Ep_Points, max = Max_Ep_Points, mean = number(Mean_Ep_Points, accuracy = 0.1), sd = number(Std_Dev_Ep_Points, accuracy = 0.1), num_eps = Num_Eps)
    ) %>%
    arrange(Current_Ep_Ranking)


# Task Performanace code
bin_levels <- c('<0', as.character(0:5), '6+')

# Bin the Task points to 
adj_task_attempt_df <- task_attempt_df %>% mutate(
    Binned_Points = case_when(Points < 0 ~ '<0',
                              Points > 5 ~ '6+',
                              .default =  as.character(Points)
    ),
    Binned_Points = factor(Binned_Points, levels = bin_levels)
)

past_tasks_df <-     adj_task_attempt_df %>% filter(Episode_ID <= (sim_max_episode_used - 1)) %>%
    mutate(Period = glue("Past Eps", ep = (sim_max_episode_used - 1))) %>%
    group_by(Series_ID, Contestant, Period, Binned_Points) %>%
    count(name = "Count", Series_ID, Contestant, Period, Binned_Points, .drop=FALSE) %>%
    group_by(Series_ID, Contestant, Period) %>%
    mutate(Sum_Count = sum(Count),
           Prop_Count = Count/Sum_Count,
           Text_Count = paste(number(Count), 
                              percent(Prop_Count, accuracy = 0.1, prefix = "(", suffix = "%)")
           )
    )


curr_ep_tasks_df <- adj_task_attempt_df %>% 
    filter(Episode_ID == sim_max_episode_used) %>%
    mutate(Period = glue("Current Ep", ep = sim_max_episode_used)) %>%
    group_by(Series_ID, Contestant, Period, Binned_Points) %>%
    count(name = "Count", Series_ID, Contestant, Binned_Points, .drop = FALSE) %>%
    group_by(Series_ID, Contestant, Period) %>%
    mutate(Sum_Count = sum(Count),
           Prop_Count = Count/Sum_Count,
           Text_Count = paste(number(Count), 
                              percent(Prop_Count, accuracy = 0.1, prefix = "(", suffix = "%)")
           )
    )

# Combine past and current task distribution data frames.
all_tasks_df <- past_tasks_df %>% 
    bind_rows(curr_ep_tasks_df) %>%
    mutate(Period = factor(Period, levels = c("Past Eps", "Current Ep"))
    ) %>% ungroup()

pivot_id_cols <- c("Series_ID", "Contestant", "Period")

# Pivot tables with point bins as columns

# Proportion counts
prop_count_pivot_df <- all_tasks_df %>%
    pivot_wider(names_from = Binned_Points, values_from = c("Prop_Count"),
                id_cols = pivot_id_cols) %>%
    arrange(Series_ID, Contestant, Period)

# Text with number of instances and percentages in parenthesis 
text_count_pivot_df <- all_tasks_df %>%
    pivot_wider(names_from = Binned_Points, values_from = c("Text_Count"),
                id_cols = pivot_id_cols) %>%
    arrange(Series_ID, Contestant, Period)



##### 
kable_text_df <- text_count_pivot_df 

heat_cols <- colnames(text_count_pivot_df)[-c(1:3)]

# Code to allow for conditional formatting of distributions. 
# Content of the table is based on the text, colour is based on the proportion.
for(heat_iter in heat_cols) {
    kable_text_df[, heat_iter] <- cell_spec(
        x = text_count_pivot_df[[heat_iter]],
        background_as_tile = FALSE,
        color = "black",
        align = "c", 
        monospace = TRUE,
        font_size = spec_font_size(
            x = prop_count_pivot_df[[heat_iter]],
            begin = 8,
            end = 20,
            scale_from = c(0.1, 0.5)
        )
        ,
        background = spec_color(
            x = prop_count_pivot_df[[heat_iter]],
            begin = 0,
            end = 1,
            alpha = 0.25,
            option = 'G',
            direction = -1,
            scale_from = c(0, 1)
        ),
        extra_css = "justify-content: center; text-align: center; align-items:center; margin: 0px; padding: 0px; padding-right:-4px; padding-left: -4px; border: 0px; display: flex;  width: 100%; height: 200%;" # Key CSS for full cell color ; 
    )
}


