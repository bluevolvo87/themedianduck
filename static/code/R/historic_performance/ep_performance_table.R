#Code to provide episode performance grade table.
compare_df <- compare_curr_ep_df

kbl_col_names <- c("Contestant",
                   glue("Episode {ep} Points", ep = sim_max_episode_used),
                   glue("Episode {ep} Ranking", ep = sim_max_episode_used),
                   glue("Episode {ep} Performance Grade", ep = sim_max_episode_used),
                   glue("Summary Performance from Previous {hist_ep} Episodes", hist_ep = sim_max_episode_used-1)
)

tbl_title <- glue("Episode {ep_id} Performance Report Card", ep_id = sim_max_episode_used)
tbl_foot <- glue("Episode {curr_ep_id} Performance Grade is based on comparing the current episode performance, to the prior {prev_ep_id} episode(s) performance and where it lies in the distribution.", curr_ep_id =  sim_max_episode_used, prev_ep_id = sim_max_episode_used-1)

df_compared_df <- as.data.frame(compare_df)

react_compare_df <- compare_df %>% 
    select(Contestant, Current_Ep_Points, Current_Ep_Ranking, Current_Ep_Grade,  Ep_Performance_Summary)

react_compare_df <-as.data.frame(react_compare_df)

ranking_colour_df <- data.frame("Ranking" = c(1:5),
                                "Colour" = c("#D6AF36","#A7A7AD", "#A77044","#e0e5e5","#737473")
)



ep_grade_perf_table <- 
    reactable(
    data = react_compare_df,
    columns = list(
        `Contestant` = reactable::colDef(
            name = kbl_col_names[1],
            cell = function(value, index) {
                name_image_func(data = df_compared_df,
                                value = value,
                                index = index)
            },
            minWidth = 100
        ),
        `Current_Ep_Points` = colDef(name = kbl_col_names[2], width = 150,
                                     cell = 
                                         reactablefmtr::data_bars(
                                             react_compare_df["Current_Ep_Points"],
                                             bar_height = 50,
                                             text_size = 18,
                                             fill_color = "#FFFFC2" ,
                                             border_color = "darkred",
                                             bold_text = TRUE,
                                             border_style = "solid",
                                             border_width ="thin"
                                         )
        ),
        `Current_Ep_Ranking` = colDef(name = kbl_col_names[3], width = 150,
                                      style = function(value, index){
                                          fill_colour <- ranking_colour_df[ranking_colour_df$Ranking == value, "Colour"]
                                          list(background = fill_colour)
                                      }),
        `Current_Ep_Grade` = colDef(name = kbl_col_names[4], width = 150, 
                                    style = function(value, index){
                                        list(background = df_compared_df[index, "Current_Ep_Grade_Colour"])
                                    }
        ),
        `Ep_Performance_Summary` = colDef(name = kbl_col_names[5], minWidth = 350)
    ),
    defaultSortOrder = "asc",
    defaultColDef = reactable::colDef(
        format = colFormat(digits = 0),
        align = "center",
        headerStyle = list(background = "#f7f7f8"),
        vAlign = "center",
        headerVAlign = "bottom"
    ),
    sortable = FALSE,
    bordered = TRUE,
    highlight = TRUE,
    #height = 750,
    striped = TRUE,
    compact = TRUE,
    pagination = FALSE,
    theme = reactableTheme(
        borderColor = "darkred",
        borderWidth = "5px",
        color = "black"
    ),
    fullWidth = TRUE,
    width = "100%"
) %>%
    reactablefmtr::add_title(
        title = tbl_title,
        text_decoration = 'underline',
        font_size = 16,
        font_color = "white",
        background_color = "black"
    ) %>%
    reactablefmtr::add_subtitle(
        subtitle = tbl_foot,
        font_weight = 'normal',
        font_style = 'italic',
        font_size = 14,
        margin = reactablefmtr::margin(t=0.5,r=0,b=0,l=0),
        font_color = "white",
        background_color = "black"
    )
