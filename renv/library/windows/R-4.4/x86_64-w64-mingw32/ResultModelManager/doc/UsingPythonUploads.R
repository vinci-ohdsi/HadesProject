## ----eval = F-----------------------------------------------------------------
#  ResultModelManager::enablePythonUploads()

## ----eval = F-----------------------------------------------------------------
#  ResultModelManager::install_psycopg2()

## ----eval = FALSE-------------------------------------------------------------
#  ResultModelManager::enablePythonUploads()
#  connectionDetails <- DabaseConnector::createConnectionDetails(
#    dbms = "postgreql",
#    server = "myserver.com",
#    port = 5432,
#    password = "s",
#    user = "me",
#    database = "some_db"
#  )
#  connection <- DatabaseConnector::connect(connectionDetails)
#  readr::write_csv(
#    data.frame(
#      id = 1:1e6,
#      paste(1:1e6, "bottle(s) on the wall")
#    ),
#    "my_massive_csv.csv"
#  )
#  
#  ResultModelManager::pyUploadCsv(connection,
#    table = "my_table",
#    filepath = "my_massive_csv.csv",
#    schema = "my_schema"
#  )

## ----eval=F-------------------------------------------------------------------
#  ResultModelManager::pyUploadDataframe(connection,
#    table = "my_table",
#    filepath = "my_massive_csv.csv",
#    schema = "my_schema"
#  )

## ----eval=F-------------------------------------------------------------------
#  ResultModelManager::enablePythonUploads()
#  
#  ResultModelManager::uploadResults(
#    connectionDetails,
#    schema = "my_schema",
#    resultsFolder = "my_results_folder",
#    tablePrefix = "cm_",
#    purgeSiteDataBeforeUploading = FALSE,
#    specifications = getResultsDataModelSpec()
#  )

