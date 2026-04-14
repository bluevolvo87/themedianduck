# Code to produce the joint cast series ranking distribution
initials_vec <- multiverse_env$latest_df$Initials
#prev_ep_joint_pred <- 

full_prev_ep_pred <- paste(paste(initials_vec, prev_ep_joint_pred, sep = ": "), collapse= ", ")

top_casts <- 20 


graph_title_label <- glue("Joint Distribution of Cast Series Rankings for Series {series_id}", series_id = series_id)

subtitle_label <- glue("Using Data up to Episode {max_ep}, {num_sims} Simulated Series, with {remain_eps} remaining episodes.", 
                       max_ep = sim_max_episode_used, 
                       num_sims = scales::number(num_sims),
                       seed_id = seed_id, 
                       remain_eps = remain_num_eps)

caption_label <- glue("Top {n_cast} of the Most Probable Cast Rankings are displayed only. Seed: {seed_id}", n_cast = top_casts, seed_id = seed_id)


joint_cast_ranking_dist_plot <- counts_sim_cast_df %>% 
    filter((Prob_Rank <= top_casts) | MAP_Flag | (Full_Cast_Rank %in% full_prev_ep_pred)) %>%
    mutate(text = ifelse(Full_Cast_Rank %in% full_prev_ep_pred, paste("Previous Prediction ", percent(Prop_Count, accuracy = 0.01, prefix = "(", suffix = "%)")), text)) %>%
    ggplot(aes(x = forcats::fct_reorder(Full_Cast_Rank, Prop_Count), y= Prop_Count)) +
    geom_bar(stat = "identity", fill = "#FFFFC2" , colour = "darkred", linewidth = 0.25) +
    #scale_fill_manual(values = c("Prediction" = "#D6AF36", " " = "#e0e5e5", "Actual" = "#A77044")) +
    geom_text(aes(label = text, hjust = 0, colour = MAP_Flag), family = "elite", nudge_y = 0.001, show.legend = FALSE) +
    scale_color_manual(values = c("TRUE" = "darkgreen", "FALSE" = "black")) +
    quack_theme() +
    ggtitle(label = graph_title_label, subtitle = subtitle_label) +
    labs(caption = caption_label) +
    scale_y_continuous(labels = scales::percent_format(), limits = c(0, 1), n.breaks = 10) +
    ylab("Probability") +
    xlab("Full Cast Ranking") +
    coord_flip()