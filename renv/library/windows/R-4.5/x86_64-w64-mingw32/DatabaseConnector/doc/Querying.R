## ----echo = FALSE, message = FALSE--------------------------------------------
library(DatabaseConnector)

## ----eval=FALSE---------------------------------------------------------------
# conn <- connect(dbms = "postgresql",
#                 server = "localhost/postgres",
#                 user = "joe",
#                 password = "secret")

## ----echo=FALSE---------------------------------------------------------------
writeLines("Connecting using PostgreSQL driver")

## ----eval=FALSE---------------------------------------------------------------
# querySql(conn, "SELECT TOP 3 * FROM person")

## ----echo=FALSE---------------------------------------------------------------
data.frame(PERSON_ID = c(1,2,3), GENDER_CONCEPT_ID = c(8507, 8507, 8507), YEAR_OF_BIRTH = c(1975, 1976, 1977))

## ----eval=FALSE---------------------------------------------------------------
# executeSql(conn, "TRUNCATE TABLE foo; DROP TABLE foo; CREATE TABLE foo (bar INT);")

## ----eval=FALSE---------------------------------------------------------------
# library(Andromeda)
# x <- andromeda()
# querySqlToAndromeda(connection = conn,
#                     sql = "SELECT * FROM person",
#                     andromeda = x,
#                     andromedaTableName = "person")

## ----eval=FALSE---------------------------------------------------------------
# persons <- renderTranslatequerySql(conn,
#                                    sql = "SELECT TOP 10 * FROM @schema.person",
#                                    schema = "cdm_synpuf")

## ----eval=FALSE---------------------------------------------------------------
# data(mtcars)
# insertTable(conn, "mtcars", mtcars, createTable = TRUE)

## ----eval=FALSE---------------------------------------------------------------
# options(LOG_DATABASECONNECTOR_SQL = TRUE)
# ParallelLogger::addDefaultFileLogger("sqlLog.txt", name = "TEST_LOGGER")
# 
# persons <- renderTranslatequerySql(conn,
#                                    sql = "SELECT TOP 10 * FROM @schema.person",
#                                    schema = "cdm_synpuf")
# 
# readLines("sqlLog.txt")

