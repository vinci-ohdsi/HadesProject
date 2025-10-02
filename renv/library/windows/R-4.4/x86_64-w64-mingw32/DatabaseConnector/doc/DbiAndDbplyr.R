## ----echo = FALSE, message = FALSE--------------------------------------------
library(DatabaseConnector)

## ----eval=FALSE---------------------------------------------------------------
# connection <- dbConnect(
#   DatabaseConnectorDriver(),
#   dbms = "postgresql",
#   server = "localhost/postgres",
#   user = "joe",
#   password = "secret"
# )

## ----echo=FALSE---------------------------------------------------------------
writeLines("Connecting using PostgreSQL driver")

## ----eval=FALSE---------------------------------------------------------------
# dbIsValid(conn)

## ----echo=FALSE---------------------------------------------------------------
TRUE

## ----eval=FALSE---------------------------------------------------------------
# dbGetQuery(connection, "SELECT TOP 3 * FROM cdmv5.person")

## ----echo=FALSE---------------------------------------------------------------
data.frame(person_id = c(1,2,3), gender_concept_id = c(8507, 8507, 8507), year_of_birth = c(1975, 1976, 1977))

## ----eval=FALSE---------------------------------------------------------------
# res <- dbSendQuery(connection, "SELECT TOP 3 * FROM cdmv5.person")
# dbFetch(res)

## ----echo=FALSE---------------------------------------------------------------
data.frame(person_id = c(1,2,3), gender_concept_id = c(8507, 8507, 8507), year_of_birth = c(1975, 1976, 1977))

## ----eval=FALSE---------------------------------------------------------------
# dbHasCompleted(res)

## ----echo=FALSE---------------------------------------------------------------
TRUE

## ----eval=FALSE---------------------------------------------------------------
# dbClearResult(res)
# dbDisconnect(res)

## ----eval=FALSE---------------------------------------------------------------
# library(dpylr)
# person <- tbl(connection, inDatabaseSchema("cdmv5", "person"))
# person

## ----echo=FALSE---------------------------------------------------------------
data.frame(person_id = c(1,2,3), gender_concept_id = c(8507, 8507, 8507), year_of_birth = c(1975, 1976, 1977))

## ----eval=FALSE---------------------------------------------------------------
# person %>%
#   filter(gender_concept_id == 8507) %>%
#   count() %>%
#   pull()

## ----echo=FALSE---------------------------------------------------------------
1234

## ----eval=FALSE---------------------------------------------------------------
# observationPeriod <- tbl(connection, inDatabaseSchema("cdmv5", "observation_period"))
# observationPeriod %>%
#   filter(
#     dateDiff("day", observation_period_start_date, observation_period_end_date) > 365
#   ) %>%
#   count() %>%
#   pull()

## ----echo=FALSE---------------------------------------------------------------
987

## ----eval=FALSE---------------------------------------------------------------
# option(sqlRenderTempEmulationSchema = "a_schema")

## ----eval=FALSE---------------------------------------------------------------
# dbWriteTable(connection, "#temp", cars)

## ----echo=FALSE---------------------------------------------------------------
message("Inserting data took 0.053 secs")

## ----eval=FALSE---------------------------------------------------------------
# carsTable <- copy_to(connection, cars)

## ----echo=FALSE---------------------------------------------------------------
writeLines("Created a temporary table named #cars")

## ----eval=FALSE---------------------------------------------------------------
# tempTable <- person %>%
#   filter(gender_concept_id == 8507) %>%
#   compute()

## ----echo=FALSE---------------------------------------------------------------
message("Created a temporary table named #dbplyr_001")

## ----eval=FALSE---------------------------------------------------------------
# dropEmulatedTempTables(connection)

## ----eval=FALSE---------------------------------------------------------------
# dbDisconnect(connection)

