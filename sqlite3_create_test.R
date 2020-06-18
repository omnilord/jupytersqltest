library(DBI)
library(RSQLite)
library(here)

# Create/Connect to an SQLite3 database
conn = RSQLite::dbConnect(RSQLite::SQLite(), here('test_r.db'))


# Create a test table if it doesn't already exist
create_stm <-
  '
  CREATE TABLE IF NOT EXISTS testing (
    id INTEGER NOT NULL PRIMARY KEY,
    value text
  )
  '
dbExecute(conn, create_stm)


# Make some random data and insert it into the test table
rand_strs <- function(n = 5000) {
  a <- do.call(paste0, replicate(9, sample(LETTERS, n, TRUE), FALSE))
  paste0(a, sample(LETTERS, n, TRUE))
}
data <- setNames(data.frame(rand_strs(100)), c('value'))
dbSendQuery(conn, 'INSERT INTO testing (value) VALUES (:value)', data)


# Check out what's in the database table
table_data = dbGetQuery(conn, "SELECT * FROM testing")
print(table_data)
