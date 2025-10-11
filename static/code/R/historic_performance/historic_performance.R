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
            (Current_Ep_Points > Max_Ep_Points) ~ grade_lookup_df[1,"Grade"],
            ((Max_Ep_Points >= Current_Ep_Points) & (Current_Ep_Points > P75_Ep_Points)) ~ grade_lookup_df[2,"Grade"],
            ((P75_Ep_Points >= Current_Ep_Points) & (Current_Ep_Points > Median_Ep_Points)) ~ grade_lookup_df[3,"Grade"],
            ((Median_Ep_Points >= Current_Ep_Points) & (Current_Ep_Points > P25_Ep_Points)) ~ grade_lookup_df[4,"Grade"],
            ((P25_Ep_Points >= Current_Ep_Points) & (Current_Ep_Points >= Min_Ep_Points)) ~ grade_lookup_df[5,"Grade"],
            (Min_Ep_Points > Current_Ep_Points) ~ grade_lookup_df[6,"Grade"]
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
