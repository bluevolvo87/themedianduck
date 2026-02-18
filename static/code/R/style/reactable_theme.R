# Reactable table theme

options(reactable.theme = reactableTheme(
    color = "black",
    backgroundColor = "#FFFFC2",
#    borderColor = "hsl(233, 9%, 22%)",
    stripedColor = "#ffff94",
        borderColor = "darkred",
        borderWidth = "5px"
))


name_image_func <- function(data, value, index, img_width = "30%") {
    img_url <- data[index, "Image_URL"]
    image <- img(src = img_url,
                 style = glue("width: {iw};", iw = img_width),
                 alt = "Contestant.Image")
    tagList(div(style = list(fontWeight = 1000), value),
            div(style = "display: inline-block; width: 98%;", image))
    
}


good_bad_styling_func <- function(value, good_col = "lightgreen", bad_col = "#FFCCCB", neut_col = "#f9f9f9"){
    if (value > 0) {
        color <- good_col
    } else if (value < 0) {
        color <- bad_col
    } else {
        color <- neut_col
    }
    list(background = color, fontWeight = "bold")
}
    


# Define the custom filter input function in R
range_filter_input <- function(values, name, elementId) {
    tags$div(
        # Add an element ID to the div for easy JS targeting
        id = paste0(name, "-range-filter"),
        tags$input(
            type = "number",
            placeholder = "Min",
            onchange = sprintf("Reactable.setFilter('%s', '%s', [event.target.value, document.getElementById('%s-range-filter').children[1].value])",
                               elementId, name, name),
            style = "width: 45%; margin-right: 5%;"
        ),
        tags$input(
            type = "number",
            placeholder = "Max",
            onchange = sprintf("Reactable.setFilter('%s', '%s', [document.getElementById('%s-range-filter').children[0].value, event.target.value])",
                               elementId, name, name),
            style = "width: 45%;"
        )
    )
}

# Define the custom slider input
slider_filter <- function(values, name) {
    tags$div(
        # Display the current value next to the slider
        tags$label(`for` = name, sprintf("Min %s:", name)),
        tags$input(
            type = "range",
            min = min(values), max = max(values), value = min(values),
            style = "width: 100%;",
            # Reactable.setFilter updates the table state
            oninput = sprintf("Reactable.setFilter('cars-range-table', '%s', this.value)", name)
        )
    )
}

slider_filter_method <- JS("function(rows, columnId, filterValue) {
        return rows.filter(function(row) {
          return row.values[columnId] >= filterValue
        })
      }")


# Define the custom filter method in JavaScript
# This JS function filters rows based on a specified min/max range
range_filter_method <- JS("function(rows, columnId, filterValue) {
  const [min, max] = filterValue;
  return rows.filter(row => {
    const value = row.values[columnId];
    // Convert inputs to numbers and check if value is within range
    return (isNaN(min) || value >= Number(min)) && (isNaN(max) || value <= Number(max));
  });
}")
