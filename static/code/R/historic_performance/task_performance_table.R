# Code to provide the task performance table

series_id_vec <- kable_text_df$Series_ID
series_id <- unique(series_id_vec[!is.na(series_id_vec)], nmax = 1)

kable_text_df <- kable_text_df %>%
    left_join(contestants_df[c("Contestant_Name", "Initials", "Image_URL")], by = join_by(Contestant == Contestant_Name))

react_full_text_df <- as.data.frame(kable_text_df)

react_sub_text_df <- kable_text_df %>% ungroup() %>%
    filter(!is.na(Contestant)) %>% 
    select(Contestant, Image_URL, Period, all_of(heat_cols))
react_sub_text_df <- as.data.frame(react_sub_text_df)

caption_label <- glue("Series {series_id} Task Points Distribution.", series_id = series_id)
footnote_label <- glue("Past covers tasks up to Episode {past_ep}, Current Ep covers tasks in Episode  {current_ep}.", past_ep = multiverse_env$sim_max_episode_used - 1, current_ep = multiverse_env$sim_max_episode_used)

task_perf_table <- reactable(
    data = react_sub_text_df,
    columns = list(
        `Contestant` = colDef(
            cell = function(value, index) {
                name_image_func(data = react_sub_text_df,
                                value = value,
                                index = index)
            },
            minWidth = 100,
            html = TRUE, filterable = TRUE
        ),
        `Image_URL` = colDef(html = TRUE, show = FALSE, resizable = TRUE),
        `Period` = colDef(width = 150, html = FALSE, filterable = TRUE)
    ),
    defaultSortOrder = "asc",
    groupBy = "Contestant",
    defaultExpanded = TRUE,
    defaultColDef = colDef(
        format = colFormat(digits = 0),
        align = "center",
        headerStyle = list(background = "#f7f7f8"),
        vAlign = "center",
        headerVAlign = "bottom",
        html = TRUE,
        minWidth = 100
    ),
    sortable = FALSE,
    bordered = TRUE,
    highlight = TRUE,
    height = 500,
    striped = TRUE,
    compact = TRUE,
    pagination = FALSE,
    theme = reactableTheme(
        borderColor = "#AA6C39",
        borderWidth = "5px",
        color = "black"
    ),
    style = list(maxWidth = 2000),
    width = "100%",
    fullWidth = TRUE
) %>%
    reactablefmtr::add_title(
        title = caption_label,
        text_decoration = 'underline',
        font_size = 16,
        font_color = "white",
        background_color = "black"
    ) %>%
    reactablefmtr::add_subtitle(
        subtitle = footnote_label,
        font_weight = 'normal',
        font_style = 'italic',
        font_size = 14,
        margin = reactablefmtr::margin(t=0.5,r=0,b=0,l=0),
        font_color = "white",
        background_color = "black"
    )