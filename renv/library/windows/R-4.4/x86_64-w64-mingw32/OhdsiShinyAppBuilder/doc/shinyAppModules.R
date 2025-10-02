## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

## ----echo=FALSE---------------------------------------------------------------

inputsForConfig <- data.frame(
  Inputs = c('moduleId','tabName',
             'shinyModulePackage',
             'shinyModulePackageVersion',
      'moduleUiFunction', 'moduleServerFunction',
      'moduleInfoBoxFile',
      'moduleIcon',
      'installSource',
      'gitHubRepo'
),

Description = c("a unique id for the shiny app", "The menu text for the module", "The R package that contains the shiny module or NULL if using a local function", "The minimum version of shinyModulePackage that is require or NULL", "The name of the module's UI function", "The name of the module's server function", 
                "The function in the shinyModulePackage package that contains the helper information",
                "An icon to use in the menu for this module",
                "The Repo (CRAN or github) where users can install shinyModulePackage",
                "If shinyModulePackage is available from github, this is the github repo you can find it")
)

knitr::kable(inputsForConfig)


## ----eval=FALSE---------------------------------------------------------------
# 
# aboutModule <- createModuleConfig(
#       moduleId = 'about',
#       tabName = "About",
#       shinyModulePackage = "OhdsiShinyModules",
#       moduleUiFunction = 'aboutViewer',
#       moduleServerFunction = 'aboutServer',
#       moduleInfoBoxFile =  "aboutHelperFile()",
#       moduleIcon = 'info',
#       installSource = 'github',
#       gitHubRepo = 'ohdsi'
#     )
# 

## ----eval=FALSE---------------------------------------------------------------
# 
# aboutModule <- createDefaultAboutConfig()
# 

## ----eval=FALSE---------------------------------------------------------------
# 
# predictionModule <- createModuleConfig(
#     moduleId = 'prediction',
#     tabName = "Prediction",
#     shinyModulePackage = 'OhdsiShinyModules',
#     moduleUiFunction = "predictionViewer",
#     moduleServerFunction = "predictionServer",
#     moduleInfoBoxFile =  "predictionHelperFile()",
#     moduleIcon = "chart-line",
#     installSource = 'github',
#     gitHubRepo = 'ohdsi'
#     )
# 

## ----eval=FALSE---------------------------------------------------------------
# 
# predictionModule <- createDefaultPredictionConfig()
# 

## ----eval=FALSE---------------------------------------------------------------
# 
# cohortMethodModule <- createDefaultEstimationConfig()
# 
# cohortGeneratorModule <- createDefaultCohortGeneratorConfig()
# 

## ----eval=FALSE---------------------------------------------------------------
# 
# library(dplyr)
# shinyAppConfig <- initializeModuleConfig() %>%
#   addModuleConfig(aboutModule) %>%
#   addModuleConfig(cohortGeneratorModule) %>%
#   addModuleConfig(cohortMethodModule) %>%
#   addModuleConfig(predictionModule)
# 

## ----eval=FALSE---------------------------------------------------------------
# # save this as app.R and upload it to a shiny server
# 
# # create the config using existing UI and server functions
# # in OhdsiShinyModules or by creating the UI and server functions
# fooModuleUi <- function (id = "foo") {
#     shiny::fluidPage(title = "foo")
#   }
# 
# fooModule <- function(
#   id = 'foo',
#   connectionHandler = NULL,
#   resultDatabaseSettings = NULL,
#   config
#   ) {
#   shiny::moduleServer(id, function(input, output, session) { })
# }
# 
# fooHelpInfo <- function() {
#   'NA'
# }
# 
# moduleConfig <- createModuleConfig(
#   moduleId = 'foo',
#   tabName = "foo",
#   shinyModulePackage = NULL,
#   moduleUiFunction = fooModuleUi,
#   moduleServerFunction = fooModule,
#   moduleInfoBoxFile = "fooHelpInfo()",
#   moduleIcon = "info"
# )
# 
# shinyAppConfig <- initializeModuleConfig()
# shinyAppConfig <- addModuleConfig(shinyAppConfig, moduleConfig)
# 
# # create a connection to the result database
# # in this example it is an empty sql database
# connectionDetails <- DatabaseConnector::createConnectionDetails(
#   dbms = 'sqlite',
#   server = './madeup.sql'
#   )
# # Create the app
# createShinyApp(
#   config = shinyAppConfig,
#   connectionDetails = connectionDetails,
#   resultDatabaseSettings = createDefaultResultDatabaseSettings()
#     )

## ----eval=FALSE---------------------------------------------------------------
# # create the config using existing UI and server functions
# # in OhdsiShinyModules or by creating the UI and server functions
# fooModuleUi <- function (id = "foo") {
#     shiny::fluidPage(title = "foo")
#   }
# 
# fooModule <- function(
#   id = 'foo',
#   connectionHandler = NULL,
#   resultDatabaseSettings = NULL,
#   config
#   ) {
#   shiny::moduleServer(id, function(input, output, session) { })
# }
# 
# fooHelpInfo <- function() {
#   file.path(tempdir(), 'help.html')
# }
# 
# moduleConfig <- createModuleConfig(
#   moduleId = 'foo',
#   tabName = "foo",
#   shinyModulePackage = NULL,
#   moduleUiFunction = fooModuleUi,
#   moduleServerFunction = fooModule,
#   moduleInfoBoxFile = "fooHelpInfo()",
#   moduleIcon = "info"
# )
# 
# shinyAppConfig <- initializeModuleConfig()
# shinyAppConfig <- addModuleConfig(shinyAppConfig, moduleConfig)
# 
# # create a connection to the result database
# # in this example it is an empty sql database
# connectionDetails <- DatabaseConnector::createConnectionDetails(
#   dbms = 'sqlite',
#   server = './madeup.sql'
#   )
# 
# # specify the app title
# appTitle <- 'Example Foo App'
# 
# # provide a short paragraph to described the study
# # that the is exploring the results of.
# studyDescription <- "An empty made up study for the vignette demo.  The shiny app with show one menu option called 'foo' that will not do anything."
# 
# # specify whether you want to use a pooled connection
# usePooledConnection <- F
# 
# # open a shiny app that lets you explore results
# viewShiny(
#   config = shinyAppConfig,
#   connectionDetails = connectionDetails,
#   resultDatabaseSettings = createDefaultResultDatabaseSettings(),
#   title = appTitle,
#   usePooledConnection = usePooledConnection,
#   studyDescription = studyDescription
#     )

