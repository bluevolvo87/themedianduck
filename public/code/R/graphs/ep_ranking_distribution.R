# Code to produce the episode ranking distribution

graph_title_label <- glue("Probability Distribution For Episode Ranking for Series {series_id}", series_id = series_id)

subtitle_label <- glue("Using Data up to Episode {max_ep}, {num_sims} Simulated Series, with {remain_eps} remaining episodes.", 
                       max_ep = sim_max_episode_used, 
                       num_sims = scales::number(num_sims), 
                       seed_id = seed_id, 
                       remain_eps = remain_num_eps)

caption_label <- glue("Simulation Seed: {seed_id}", seed_id = seed_id)


ep_ranking_dist_plot <- ggplot(prop_ep_win_df,
       aes(y = Prop_Count, x= Ep_Rank, image = Image_URL, label = scales::percent(Prop_Count, accuracy = 0.01))) +
    geom_bar(stat = "identity", fill = "#FFFFC2") +
    facet_grid(Initials~., switch = "both") +
    geom_image(size=1, x= 0, y = 0.5, by = "height") +
    geom_text(stat = "identity", aes(y = pmin(Prop_Count+0.05, 0.8), colour = MAP_Flag), size = 7, family = "elite", show.legend = FALSE
    ) +
    scale_color_manual(values=c("black", "darkgreen")) +
    quack_theme() +
    ggtitle(label = graph_title_label, subtitle = subtitle_label) +
    xlab("Within Episode Ranking") +
    ylab("Probability") +
    labs(caption = caption_label) +
    scale_y_continuous(labels = scales::percent_format(), limits = c(0, 1)) +
    scale_x_continuous(labels = c("", "1st", "2nd", "3rd", "4th", "5th")) +
    coord_cartesian(xlim = c(0, 5))