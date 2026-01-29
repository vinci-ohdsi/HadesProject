# Example researcher project start-up
# @author Marc A Suchard

Sys.setenv(JAVA_HOME="extras/jdk1.8") # may need to be a fully specified path
Sys.setenv(DATABASECONNECTOR_JAR_FOLDER="extras") # may need to be a fully specified path
# NB: may be possible to move these `Sys.setenv()` into `.Rprofile` and `.Renviron`

# check ability to open CDM
connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = "sql server",
  server = "vhacdwrb02" # ensure this is the researcher's DB server
  # full specification "vhacdwrb02.vha.med.va.gov" may be necessary
)

connection <- DatabaseConnector::connect(connectionDetails = connectionDetails)
DatabaseConnector::disconnect(connection)

databaseName <- "ORD_Researcher_xyz" # need to change for each ORD research space
cdmSchemaName <- "OMOPV5"
cdmDatabaseSchema <- paste(databaseName, cdmSchemaName, sep = ".")

# create OMOP CDM schema in ORD space -- only needs to be executed once!
# VaTools::createStandardCdmSchema(
#   connectionDetails = connectionDetails,
#   database = databaseName,
#   startingSchema = "src",
#   destinationSchema = cdmSchemaName)

# small silly test
connection <- DatabaseConnector::connect(connectionDetails = connectionDetails)
sql <- SqlRender::render(
  "SELECT COUNT(*) AS subjects FROM @cdmDatabaseSchema.person;",
  cdmDatabaseSchema = cdmDatabaseSchema)
DatabaseConnector::querySql(connection = connection,
         sql = sql)
DatabaseConnector::disconnect(connection)
