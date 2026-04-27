# Code to produce the series score tracker
title_label <- glue("Series {series_id}: Series Score Tracker", series_id = series_id)

series_score_plot <- ggplot(series_points_df, aes(x= Episode_ID, y= Series_Points)) +
    geom_point(aes(x = Episode_ID, colour = Initials), size = 2, alpha = 0.6) +
    geom_line(aes(colour = Initials), alpha = 0.6, linewidth = 1.5) +
    #scale_color_manual(values = c("AM" = "darkred", "MA" = "darkblue", "PE" = "darkorange", "RS" = "darkgreen", "SB" = "purple")) +
    geom_image(data = latest_df, aes(x= 10 + (rank(-Series_Points, ties.method = "first")-1)*0.5, y = Series_Points, image = Image_URL), size = 0.1, by = "height", inherit.aes = FALSE) + 
    new_scale_color() +
    geom_label(data = latest_df, aes(x= 10 + (rank(-Series_Points, ties.method = "first")-1)*0.5,
                                    y = Series_Points + 2*floor(log(Series_Points)),
                                    label = Series_Ranking, colour = as.factor(Series_Ranking)),
              parse= TRUE, family = "elite", show.legend = FALSE, inherit.aes = FALSE, 
              size = 20, size.unit = "pt", fill = "lightyellow", label.padding = unit(0.1, "lines")) + 
    scale_color_manual(values = c("1" = "#D6AF36", "2" = "#A7A7AD", "3" = "#A77044", "4" = "#737473", "5" = "black")) + 
    geom_label(data = latest_df, aes(x= 10 + (rank(-Series_Points, ties.method = "first")-1)*0.5,
                                     y = Series_Points - 2*ceiling(log(Series_Points)),
                                     label = Series_Points, colour = as.factor(Series_Ranking)), 
               parse= TRUE, family = "elite", show.legend = FALSE, inherit.aes = FALSE, 
               size = 16, size.unit = "pt", label.padding = unit(0.1, "lines"), fill = "lightyellow") + 
    #coord_cartesian(xlim = c(1, 12)) +
    #coord_cartesian(ylim = c(0, 100)) +
    expand_limits(y = 0) + 
    scale_x_continuous(breaks = c(1: 10), limits = c(1, 12)) +
    labs(title = title_label) +
    xlab("Episode") +
    ylab("Series Points (Cumulative)") +
    quack_theme()