## ----eval = FALSE-------------------------------------------------------------
#  #' @export
#  getDataMigrator <- function(connectionDetails, databaseSchema, tablePrefix) {
#    ResultModelManager::DataMigrationManager$new(
#      connectionDetails = connectionDetails,
#      databaseSchema = databaseSchema,
#      tablePrefix = tablePrefix,
#      migrationPath = "migrations",
#      packageName = "CohortDiagnostics"
#    )
#  }

## ----eval = FALSE-------------------------------------------------------------
#  connectionDetails <- DatabaseConnector::createConnectionDetails(MySettings)
#  migrator <- getDataMigrator(connectionDetails = connectionDetails, databaseSchema = "mySchema", tablePrefix = "cd_")

## ----eval = FALSE-------------------------------------------------------------
#  migrator$check() # Will return false and display any eronious files

## ----eval = FALSE-------------------------------------------------------------
#  migrator$getStatus() # Will return data frame of all sql migrations and if they have been executed or not

## ----eval = FALSE-------------------------------------------------------------
#  ## It is strongly recommended that you create some form of backup before doing this
#  migrator$executeMigrations()

