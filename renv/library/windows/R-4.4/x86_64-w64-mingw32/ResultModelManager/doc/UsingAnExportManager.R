## ----eval=FALSE---------------------------------------------------------------
#  library(ResultModelManager)
#  
#  tableSpecification <- dplyr::tibble(
#    tableName = c(
#      "my_table", "my_table", "my_table", "my_table", "my_table", "my_table", "my_table",
#      "my_andromeda_table", "my_andromeda_table", "my_andromeda_table"
#    ),
#    columnName = c(
#      "database_id", "target_cohort_id", "comparator_cohort_id", "target_count", "comparator_count", "rr", "p_value",
#      "database_id", "covariate_id", "value"
#    ),
#    primaryKey = c(
#      "yes", "yes", "no", "no", "no", "no", "no",
#      "yes", "yes", "no"
#    ),
#    minCellCount = c(
#      "no", "no", "no", "yes", "yes", "no", "no",
#      "no", "no", "no"
#    ),
#    dataType = c(
#      "varchar(255)", "int", "int", "int", "int", "float", "float",
#      "varchar(255)", "bigint", "float"
#    )
#  )
#  
#  # Per database export folder is a good principle to follow
#  exportDir <- "output_folder/example_cdm"
#  exportManager <- createResultExportManager(
#    tableSpecification = tableSpecification,
#    exportDir = exportDir,
#    databaseId = "example_cdm"
#  )

## ----eval=FALSE---------------------------------------------------------------
#  connection <- DatabaseConnector::connect(server = ":memory:", dbms = "sqlite")
#  schema <- "main"
#  
#  # Some made up counts
#  data <- data.frame(
#    target_cohort_id = 1:100,
#    comparator_cohort_id = 101:200,
#    target_count = stats::rpois(100, lambda = 10),
#    target_time = stats::rpois(100, 100000),
#    comparator_count = stats::rpois(100, lambda = 5),
#    comparator_time = stats::rpois(100, 100000)
#  )
#  
#  DatabaseConnector::insertTable(connection, data = data, tableName = "result_table", databaseSchema = schema)

## ----eval=FALSE---------------------------------------------------------------
#  sql <- "SELECT * FROM @schema.result_table"
#  exportManager$exportQuery(connection = connection, sql = sql, exportTableName = "my_table", schema = schema)

## ----eval=FALSE---------------------------------------------------------------
#  library(rateratio.test)
#  
#  transformation <- function(rows, pos) {
#    rrResult <- rateratio.test(
#      x = c(row$target_count, row$comparator_count),
#      n = c(row$target_time, row$comparator_time),
#      RR = 1,
#      conf.level = 0.95
#    )
#  
#    row$rr <- rrResult$estimate
#    row$p_value <- rrResult$p.value
#  
#    return(row)
#  }
#  
#  exportManager$exportQuery(connection,
#    sql,
#    "my_table",
#    transformFunction = transformation,
#    transformFunctionArgs = list(),
#    append = FALSE,
#    schema = schema
#  )

## ----eval=FALSE---------------------------------------------------------------
#  andr <- Andromeda::andromeda()
#  andr$my_andromeda_table <- data.frame(covariate_id = 1:1e4, value = stats::runif(1e4))
#  
#  first <- TRUE
#  writeBatch <- function(batch) {
#    exportManager$exportDataFrame(batch, "my_andromeda_table", append = first)
#    first <<- FALSE
#    # we don't want to return anything, just write the result to disk
#    return(invisible(NULL))
#  }
#  
#  Andromeda::batchApply(andr$my_andromeda_table, writeBatch)

## ----eval=FALSE---------------------------------------------------------------
#  exportManger$writeManifest(packageName = "analytics_package", packageVersion = packageVersion("analytics_package"))

