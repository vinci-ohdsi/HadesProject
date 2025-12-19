# Example developer project start-up
# @author Marc A Suchard

# ENVIRONMENT SETTINGS NEEDED FOR RUNNING STUDY IN ENVIRONMENT ------------
Sys.setenv("_JAVA_OPTIONS"="-Xmx4g") # Sets the Java maximum heap space to 4GB
Sys.setenv("VROOM_THREADS"=1) # Sets the number of threads to 1 to avoid deadlocks on file system

Sys.setenv(JAVA_HOME="extras/jdk1.8") # may need to be a fully specified path
Sys.setenv(DATABASECONNECTOR_JAR_FOLDER="extras") # may need to be a fully specified path
# NB: may be possible to move these `Sys.setenv()` into `.Rprofile` and `.Renviron`

# check ability to open CDM
connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = "sql server",
  server = "vhacdwdwhdbs102"
)

connect <- DatabaseConnector::connect(connectionDetails = connectionDetails)
DatabaseConnector::disconnect(connect)

