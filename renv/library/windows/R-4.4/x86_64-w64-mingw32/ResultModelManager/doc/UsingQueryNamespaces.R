## -----------------------------------------------------------------------------
library(ResultModelManager)

tableSpecification <- data.frame(
  tableName = "cohort_definition",
  columnName = c("cohort_definition_id", "cohort_name", "json", "sql"),
  primaryKey = c("yes", "no", "no", "no"),
  dataType = c("bigint", "varchar", "varchar", "varchar")
)

## -----------------------------------------------------------------------------
connectionDetails <- DatabaseConnector::createConnectionDetails("sqlite", server = tempfile())
qns <- createQueryNamespace(
  connectionDetails = connectionDetails,
  usePooledConnection = FALSE,
  tableSpecification = tableSpecification,
  tablePrefix = "rwe_study_99_",
  snakeCaseToCamelCase = TRUE,
  database_schema = "main"
)

# Create our schema within the namespace
sql <- generateSqlSchema(schemaDefinition = tableSpecification)
# note - the table prefix and schema parameters are not neeeded
qns$executeSql(sql)

## -----------------------------------------------------------------------------
qns$queryDb("SELECT * FROM @database_schema.@cohort_definition")

## -----------------------------------------------------------------------------
qns$queryDb("SELECT * FROM @database_schema.@cohort_definition")

## -----------------------------------------------------------------------------
qns$queryDb("SELECT * FROM @database_schema.@cohort_definition WHERE cohort_definition_id = @id",
  id = 5
)

## -----------------------------------------------------------------------------
qns$addReplacementVariable("database_id", "my_cdm")

## ----eval = FALSE-------------------------------------------------------------
#  qns$addReplacementVariable("database_id", "my_cdm")

## -----------------------------------------------------------------------------
tableSpecification2 <- data.frame(
  tableName = "database_info",
  columnName = c("database_id", "database_name"),
  primaryKey = c("yes", "no"),
  dataType = c("varchar", "varchar")
)
qns$addTableSpecification(tableSpecification2)

