## ----eval = FALSE-------------------------------------------------------------
#  #' Get Results Data Model Specifcations
#  getResultsDataModelSpec <- function() {
#    # For loading inside an R package
#    specPath <- system.file("settings", "resulsDataModelSpecifications.csv", package = utils::packageName())
#    spec <- readr::read_csv(specPath, show_col_types = FALSE)
#    colnames(spec) <- SqlRender::snakeCaseToCamelCase(colnames(spec))
#    return(spec)
#  }

## ----eval=FALSE---------------------------------------------------------------
#  connectionDetails <- DatabaseConnector::createConnectionDetails("sqlite", server = "MySqliteDb.sqlite")
#  connection <- DatabaseConnector::connect(connectionDetails)
#  sql <- ResultModelManager::generateSqlSchema(schemaDefinition = getResultsDataModelSpec())
#  DatabaseConnector::renderTranslateExecuteSql(connection, sql, database_schema = "main", table_prefix = "pre_")
#  DatabaseConnector::disconnect(connection)

## ----eval=FALSE---------------------------------------------------------------
#  ResultModelManager::unzipResults(zipFile = "MyResultsZip.zip", resultsFolder = "extraction_folder")
#  ResultModelManager::uploadResults(connectionDetails,
#    schema = "main",
#    resultsFolder = "extraction_folder",
#    tablePrefix = "pre_",
#    purgeSiteDataBeforeUploading = FALSE,
#    specifications = getResultsDataModelSpec()
#  )

