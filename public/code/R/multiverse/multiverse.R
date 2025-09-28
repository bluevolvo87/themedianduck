#######
##Variables to set outside of this script
#seed_id <- 2025-09-11
set.seed(seed_id)

series_id <- unique(task_attempt_df$Series_ID)
#sim_max_episode_used <- 1
#num_sims <- 100000 

#num_eps_series <- 10
remain_num_eps <- num_eps_series - sim_max_episode_used
#pr_task_inflate <- 3 #Number of pre-recorded tasks in an episode. We need to inflate the sampling by this amount for each episode



########
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


#Filter task_attempt to episodes  of interest.

# For each contestant, sample the corresponding amount based on the number of required simulations
# Each sample episode contains: 1 prize task, 3 pre-records, 1 live tasks. 
# Each sample series contains: Length of series - number of episodes that have been broadcasted already x of episode Samples


# For each episode sample, rank contestants within that episode.
# Within each series sample, calculate series cumulative scores and rank contestants. 

train_df <- task_attempt_df %>% filter(Episode_ID <= sim_max_episode_used)


group_train_data_df <- train_df %>% group_by(Contestant, Task_Type) 


sample_set_1 <- group_train_data_df %>% 
    filter(Task_Type != "Pre-Record") %>%
    slice_sample(n = num_sims * remain_num_eps, replace = TRUE) %>%
    mutate(Episode_ID = rep((sim_max_episode_used+1): num_eps_series, each = num_sims),
           Universe_ID = rep(1:num_sims, times = remain_num_eps)
    )

sample_set_2 <- group_train_data_df %>% 
    filter(Task_Type == "Pre-Record") %>%
    slice_sample(n = pr_task_inflate * num_sims * remain_num_eps, replace = TRUE)  %>%
    mutate(Episode_ID = rep((sim_max_episode_used+1): num_eps_series, each = num_sims * pr_task_inflate),
           Universe_ID = rep(1:num_sims, times = remain_num_eps * pr_task_inflate),
           Task_ID = rep((1:pr_task_inflate) + 1, times = num_sims * remain_num_eps) 
    )

full_sample_set_df <- rbind(sample_set_1, sample_set_2) %>%
    mutate(
        OG_Points = Points,
        T1_Points = pmax(pmin(OG_Points, 5), 0)
    ) %>% 
    arrange(Series_ID, Universe_ID, Episode_ID, Task_ID, Contestant) %>%
    group_by(Series_ID, Universe_ID, Episode_ID, Task_ID) %>%
    mutate(
        Points = 5 - (rank(-T1_Points, ties.method = "min") - 1)
    ) %>% ungroup() %>%
    mutate(
        Points = ifelse(OG_Points == 0 , 0, Points) #Retain Disqualification events from original sample
    )



sanity_check_df <- full_sample_set_df %>% group_by(Contestant, Task_Type) %>%
    reframe(
        Num_Sims = n_distinct(Universe_ID),
        Num_Episodes = n_distinct(Episode_ID),
        Num_records = n()
    )


#  Taking the contest-task samples and aggregate 

#Episode summary for each contestant (summed over tasks), and ranked within that episode. 
episode_sample_summary_df <- full_sample_set_df %>% group_by(Universe_ID, Series_ID, Episode_ID, Contestant) %>%
    reframe(Ep_Points = sum(Points)) %>%
    group_by(Universe_ID, Series_ID, Episode_ID) %>%
    mutate(Ep_Rank = rank(-Ep_Points, ties.method = "min")) %>%
    group_by(Universe_ID, Series_ID, Contestant) %>%
    arrange(Universe_ID, Series_ID, Episode_ID) %>%
    mutate(
        Sim_Series_Points =  cumsum(Ep_Points)
    )


prop_ep_win_df <- episode_sample_summary_df %>% 
    group_by(Series_ID, Contestant, Ep_Rank) %>%
    reframe(
        Num_Count = n()
    ) %>% 
    group_by(Series_ID, Contestant) %>%
    mutate(
        MAP_Flag = Num_Count == max(Num_Count),
        Denominator = sum(Num_Count)
    ) %>% ungroup() %>%
    mutate(
        Prop_Count = Num_Count/Denominator
        
    ) %>%
    left_join(contestants_df, by = join_by(`Contestant` == Contestant_Name))


# Constructing Series Simulations
series_sample_summary_df <- series_points_df %>% 
    filter(Episode_ID == sim_max_episode_used) %>%
    select(Series_ID, Contestant, Episode_ID, Series_Points) %>%
    rename(Num_Obs_Eps = Episode_ID, Obs_Series_Points = Series_Points) %>%
    full_join(episode_sample_summary_df, by = join_by(Series_ID == Series_ID, Contestant == Contestant)) %>%
    mutate(
        Full_Sim_Series_Points = Obs_Series_Points + Sim_Series_Points   
    ) %>% group_by(Series_ID, Universe_ID, Episode_ID) %>%
    arrange(Universe_ID, Episode_ID) %>%
    mutate(
        Sim_Series_Rank = rank(-Full_Sim_Series_Points, ties.method = "min")
    )


# Series End Wins and Proportions
prop_series_win_df <- series_sample_summary_df %>% 
    filter(Episode_ID == num_eps_series) %>%
    group_by(Series_ID, Contestant, Sim_Series_Rank) %>%
    reframe(
        Num_Count = n()
    ) %>% 
    group_by(Series_ID, Contestant) %>%
    mutate(
        MAP_Flag = Num_Count == max(Num_Count),
        Denominator = sum(Num_Count)
    ) %>% ungroup() %>%
    mutate(
        Prop_Count = Num_Count/Denominator
        
    ) %>%
    left_join(contestants_df, by = join_by(`Contestant` == Contestant_Name))


sim_cast_summary_df <- series_sample_summary_df %>% 
    filter(Episode_ID == num_eps_series) %>%
    left_join(contestants_df[c("Contestant_Name", "Initials")], by = join_by(Contestant == Contestant_Name)) %>%
    mutate(Init_Rank = paste0(Initials, ": ", Sim_Series_Rank)) %>%
    group_by(Series_ID, Universe_ID) %>%
    reframe(
        Num_Records = n(),
        Full_Cast_Rank = paste(Init_Rank, collapse = ", ")
    )


# Calculating the probability associated with the full cast series ranking event
counts_sim_cast_df  <- sim_cast_summary_df %>% group_by(Series_ID, Full_Cast_Rank) %>%
    reframe(
        Num_Count = n_distinct(Universe_ID)
    )%>%
    group_by(Series_ID) %>%
    mutate(Num_Sims = sum(Num_Count),
           Prop_Count = Num_Count/Num_Sims
    ) %>%
    ungroup() %>%
    mutate(
        Prob_Rank = rank(-Prop_Count),
        MAP_Flag = (Prop_Count == max(Prop_Count)),
        text = ifelse(MAP_Flag, paste0("Current Prediction (", scales::percent(Prop_Count, accuracy = 0.01), ")"),"")
    ) %>%
    arrange(-Prop_Count)


