library(here) #library to help with identifying the repo working directory

# URL where Database file resides. We will download from here.
db_url <- "https://tdlm.fly.dev/taskmaster.db"
modified_thresh <- 30


# Where the data will be stored locally
db_file_name <- "taskmaster.db"
data_dir <- here("static", "data")

db_data_location <- file.path(data_dir, db_file_name)


# Create Data Directory if does not exist
if(!file.exists(file.path(data_dir))){
    dir.create(file.path(data_dir))
}

# Download file specified by URL, save in the local destination.
db_exists <- file.exists(db_data_location)

days_since_modified <- NULL

if(db_exists){
    # If DB file already exists, calculate the last modified date.
    last_modified_date <- as.Date(file.info(db_data_location)$mtime)
    days_since_modified <- as.numeric(Sys.Date() -last_modified_date)
}else{
    days_since_modified <- modified_thresh * 2
    }

# If the DB file doesn't exist OR the db file exceeds the modified threshold, then download.
if(!(db_exists) | (days_since_modified >= modified_thresh)){
    download.file(url = db_url, destfile = db_data_location, mode = "wb")
}

package_name <- "RSQLite"

# Install packages if does not exist, then load.
if(!require(package_name, character.only = TRUE)){
    install.packages(package_name, character.only = TRUE)
} else{
    suppressPackageStartupMessages (library(package_name, character.only = TRUE))    
}


# Driver used to establish database connection
sqlite_driver <- dbDriver("SQLite")

# Making the connection 
tm_db <- dbConnect(sqlite_driver, dbname = db_data_location)

print("Database Connection, tm_db, is now ready to use.")


suppressPackageStartupMessages(library(tidyverse))
