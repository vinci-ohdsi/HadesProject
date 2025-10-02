## -----------------------------------------------------------------------------
DataMigrationManager <- R6::R6Class(
  "DataMigrationManager",
  private = list(
    executeMigration = function(filePath) {
      # Load, render, translate and execute sql

      # Save migration in set of migrations

      # Error handling - stop execution, restore transaction
    }
  ),
  public = list(
    migrationPath = NULL,
    migrationFolder = NULL,
    resulultsDatabaseSchema = NULL,
    connection = NULL,
    initalize = function(connectionDetails,
                         resultsDatabaseSchema,
                         tablePrefix,
                         migrationsPath,
                         migrationRegexp = .defaultMigrationRegexp) {
      # Set required variables
    },
    getStatus = function() {
      # return data frame all migrations, including file name, order and
    },
    check = function() {
      # Check to see if files follow pattern
    },
    executeMigrations = function() {
      # load list of migrations
      # Load list of executed migrations
      # if migrations table doesn't exist, create it
      # execute migrations that haven't been executed yet
    }
  )
)

## -----------------------------------------------------------------------------
#' @inheritParams ResultModelManager::DatabaseMigrationManager - this will probably need to be a factory
#' @export`
getMigrationManager <- function(migrationsPath = system.file("sql", "sql_server", "migrations", package = utils::packageName()), ...) {
  migrationManager <- ResultModelManager::DatabaseMigrationManager$new(migrationsPath = migrationsPath, ...)
}

