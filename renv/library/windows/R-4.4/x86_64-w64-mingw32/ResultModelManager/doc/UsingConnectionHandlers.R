## ----eval=FALSE---------------------------------------------------------------
#  connectionDetails <- DatabaseConnector::createConnectionDetails("sqlite", server = "MyDb.sqlite")
#  connectionHandler <- ConnectionHandler$new(connectionDetails)

## ----eval=FALSE---------------------------------------------------------------
#  connectionDetails <- DatabaseConnector::createConnectionDetails("sqlite", server = "MyDb.sqlite")
#  connectionHandler <- PooledConnectionHandler$new(connectionDetails)

## ----eval=FALSE---------------------------------------------------------------
#  result <- connectionHandler$queryDb("SELECT * FROM my_table WHERE id = @id", id = 1)

## ----eval=FALSE---------------------------------------------------------------
#  result <- connectionHandler$executeSql("CREATE TABLE foo (id INT);")

