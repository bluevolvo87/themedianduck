# Associated with googlesheets interaction
suppressPackageStartupMessages(library(googlesheets4))
gmail_acct <- "themedianduck@gmail.com" # Gmail account associated with the project
gs4_auth(email = gmail_acct)
