## -----------------------------------------------------------------------------
targetIds <- c(1)
outcomeIds <- c(2) 

## ----echo=FALSE, results='asis'-----------------------------------------------

tteTargetData <- data.frame(
  patientId = c(1, 1, 2, 3, 4, 4, 4, 5, 5),
  cohortDefinitionId = rep(1, 9),
  cohortStartDate = c('2001-01-20', '2001-10-20',
                      '2005-09-10', '2004-04-02',
                      '2002-03-03', '2003-02-01',
                      '2003-08-04', '2005-02-01',
                      '2007-04-03'),
  cohortEndDate = c('2001-01-25', '2001-12-05',
                    '2005-09-15', '2004-05-17',
                    '2002-06-12', '2003-02-30',
                    '2003-08-24', '2005-10-08',
                    '2007-05-03')
  )

knitr::kable(
  x = tteTargetData, 
  caption = 'Example time-to-event data with dates.'
    )


## ----echo=FALSE, results='asis'-----------------------------------------------
tteOutcomeData <- data.frame(
  patientId = c(1, 1, 3, 4, 4, 5, 5),
  cohortDefinitionId = rep(2, 7),
  cohortStartDate = c('1999-10-03', '2001-10-30',
                      '2004-05-16', '2002-06-03',
                      '2003-02-20', '2006-07-21',
                      '2008-01-01'),
  cohortEndDate = c('1999-10-08', '2001-11-07',
                    '2004-05-18', '2002-06-14',
                    '2003-03-01', '2006-08-03',
                    '2008-01-09')
  )

knitr::kable(
  x = tteOutcomeData, 
  caption = 'Example time-to-event data with timing.'
    )


## ----echo=FALSE, results='asis'-----------------------------------------------
tteSummaryData <- data.frame(
  patientId = c(1, 1, 3, 4, 4, 5, 5),
  outcomeDate = c('1999-10-03', '2001-10-30',
                  '2004-05-16', '2002-06-03', 
                  '2003-02-20', '2006-07-21',
                  '2008-01-01'),
  firstExposureDate = c('2001-01-20', '2001-01-20',
                        '2004-04-02', '2002-03-03',
                        '2002-03-03', '2005-02-01',
                        '2005-02-01'),
  timeToEvent = c(-475, 283, 44, 92, 354, 535,
                  1064),
  type = c('Before first exposure',
           'During subsequent',
           'During first',
           'During first',
           'During subsequent',
           'Between eras',
           'After last exposure'),
  outcomeType = c('First',
                  'Subsequent',
                  'First',
                  'First',
                  'Subsequent',
                  'First',
                  'Subsequent')
  )

knitr::kable(
  x = tteSummaryData, 
  caption = 'Table 3: Time-to-event intermediate summary.'
    )


## ----echo=FALSE, results='asis'-----------------------------------------------
tteResultData <- data.frame(
  timeType = c(
    rep('1-day', 2), 
    rep('30-day', 7),
    rep('365-day', 5)
    ),
  Type = c(
    'During first',
    'During first',
    'Before first exposure',
    'During first',
    'During first',
    'During subsequent', 
    'During subsequent',
    'Between eras',
    'After last exposure',
    'Before first exposure',
    'During first',
    'During subsequent' ,
    'Between eras',
    'After last exposure'
  ),
  outcomeType = c(
    'First',
    'First',
    'First',
    'First',
    'First',
    'Subsequent',
    'Subsequent',
    'First',
    'Subsequent',
    'First',
    'First',
    'Subsequent',
    'First',
    'Subsequent'
  ),
  timeStart = c(44, 92, -481, 31, 91,
                271, 331, 511, 1051, -731,
                1, 1, 366, 731),
  timeEnd = c(44, 92, -450, 60, 120,
              300, 360, 540, 1080, -365,
              365, 365, 730, 1095),
  count = c(1, 1, 1, 1, 1,
            1, 1, 1, 1, 1, 
            2, 2, 1, 1)
  )

knitr::kable(
  x = tteResultData, 
  caption = 'Table 4: Time-to-event output.'
    )


## -----------------------------------------------------------------------------
targetIds <- c(1)
outcomeIds <- c(2) 
dechallengeStopInterval <- 30
dechallengeEvaluationWindow <- 31

## ----echo=FALSE, results='asis'-----------------------------------------------

dcrcTargetData <- data.frame(
  patientId = c(1, 1, 2,2,2, 3, 4, 4, 4, 5, 5),
  cohortDefinitionId = rep(1, 11),
  cohortStartDate = c('2001-01-20', '2001-10-20',
                      '2005-09-10', '2006-03-04', '2006-05-03',
                      '2004-04-02',
                      '2002-03-03', '2003-02-01', '2003-08-04', 
                      '2005-02-01','2007-04-03'
                      ),
  cohortEndDate = c('2001-01-25', '2001-12-05',
                    '2005-09-15','2006-03-21', '2006-05-05', 
                    '2004-05-17',
                    '2002-06-12', '2003-02-30',
                    '2003-08-24', '2005-10-08',
                    '2007-05-03')
  )

knitr::kable(
  x = dcrcTargetData, 
  caption = 'Example dechallenge-rechallenge data with dates.'
    )


## ----echo=FALSE, results='asis'-----------------------------------------------
dcrcOutcomeData <- data.frame(
  patientId = c(1, 1, 2,2,3, 3,4, 4, 5, 5),
  cohortDefinitionId = rep(2, 10),
  cohortStartDate = c('1999-10-03', '2001-11-30',
                      '2005-07-01', '2006-03-10',
                      '2004-05-16', '2004-06-12',
                      '2002-06-03',
                      '2003-02-20', '2006-07-21',
                      '2008-01-01')
  )

knitr::kable(
  x = tteOutcomeData, 
  caption = 'Example time-to-event data with timing.'
    )


## ----echo=FALSE, results='asis'-----------------------------------------------
dcrcSummaryData <- data.frame(
  patientId = c(1,2,3,4),
  outcomeDate = c('2001-11-30', '2006-03-10', 
                  '2004-05-16', '2002-06-03'),
  exposureEnd = c('2001-12-05', '2006-03-21',
                  '2004-05-17', '2002-06-12'),
  outcomeAfter = c('-','-', '2004-01-12', '-'),
  futureExposure = c('-', '2006-05-03', '-', '2003-01-01'),
  futureOutcome = c('-','-','-','2003-02-20'),
  dechallengeType = c('Success', 'Seccess', 'Fail', 'Success'),
  rechallengeType = c('-','Success', '-', 'Fail')
  )

knitr::kable(
  x = dcrcSummaryData, 
  caption = 'Dehcallenge-rechallenge summary table showing each dechallenge.  Only some patients with a dechallenge will have a rechallenge.'
    )


## ----echo=FALSE, results='asis'-----------------------------------------------
dcrcSummaryData2 <- data.frame(
  dechallengeAttempts = 4,	
  dechallengeSuccess	= 3,
  dechallengeFailure = 1,	
  rechallengeAttempts	= 2, 
  rechallengeSuccess = 1,
  rechallangeFailure = 1
)

knitr::kable(
  x = dcrcSummaryData2, 
  caption = 'Dehcallenge-rechallenge output.'
    )


## -----------------------------------------------------------------------------
minPriorObservation <- 365
covariateSettings <- FeatureExtraction::createCovariateSettings(
  useDemographicsAge = T, 
  useDemographicsGender = T,
  useConditionOccurrenceAnyTimePrior = T, includedCovariateConceptIds = c(201820)
  )

## ----echo=FALSE, results='asis'-----------------------------------------------

targetData <- data.frame(
  patientId = c(1, 1, 1, 2, 2, 2, 3, 3, 3,
                4, 4, 4, 5, 5, 5, 1, 1, 1,
                2, 2, 2, 3, 3, 3),
  cohortId = c(rep(1,15), rep(2, 9)),
  feature = rep(c('age', 'sex', 'diabetes'),8),
  value = c(50, 'Male', 'Yes',
            18, 'Female', 'No',
            22, 'Male', 'No',
            40, 'Male', 'No',
            70, 'Female', 'Yes',
            24, 'Female', 'No',
            35, 'Female', 'No',
            31, 'Female', 'No')
  )

knitr::kable(
  x = targetData, 
  caption = 'Example patient level feature data.'
    )


## ----echo=FALSE, results='asis'-----------------------------------------------

meanData <- data.frame(
  cohortId = c(1, 1, 1, 2, 2, 2),
  feature = c('Age', 'Sex: Male', 'Diabetes: Yes',
              'Age', 'Sex: Male', 'Diabetes: Yes'), 
  mean = c(40, 0.60, 0.40, 30, 0, 0)
  )

knitr::kable(
  x = meanData, 
  caption = 'Example aggregate features for two example cohorts.'
    )


## -----------------------------------------------------------------------------
targetId <- 1
outcomeId <- 2
minPriorObservation <- 365
outcomeWashoutDays <- 365
riskWindowStart <- 1
startAnchor <- 'cohort start'
riskWindowEnd <- 180
endAnchor <- 'cohort start'
covariateSettings <- FeatureExtraction::createCovariateSettings(
  useDemographicsAge = T, 
  useDemographicsGender = T,
  useConditionOccurrenceAnyTimePrior = T, includedCovariateConceptIds = c(201820)
  )

## ----echo=FALSE, results='asis'-----------------------------------------------

data <- data.frame(
  patientId = c(1, 1, 2, 3, 4, 4, 4, 5, 5),
  targetCohortId = rep(1,9),
  cohortStartDate = c('2001-01-20', '2001-10-20',
                      '2005-09-10', '2004-04-02',
                      '2002-03-03', '2003-02-01',
                      '2003-08-04', '2005-02-01',
                      '2007-04-03'),
  cohortEndDate = c('2001-01-25', '2001-12-05',
                    '2005-09-15', '2004-05-17',
                    '2002-06-12', '2003-02-30',
                    '2003-08-24', '2005-10-08',
                    '2007-05-03'),
  observationStart = c('2000-02-01', '2000-02-01',
                       '2001-02-01', '2001-02-01',
                       '2001-02-01', '2001-02-01',
                       '2001-02-01', '2001-02-01',
                       '2001-02-01')
  )

knitr::kable(
  x = data, 
  caption = 'Example target cohort.'
    )


## ----echo=FALSE, results='asis'-----------------------------------------------

data <- data.frame(
  patientId = c(1, 1, 3, 4, 4, 5, 5 ),
  targetCohortId = rep(2,7),
  cohortStartDate = c('1999-10-03', '2001-10-30',
                      '2004-05-16', '2002-06-03',
                      '2003-02-20', '2006-07-21',
                      '2008-01-01'
                      ),
  cohortEndDate = c('1999-10-08', '2001-11-07',
                    '2004-05-18', '2002-06-14',
                    '2003-03-01', '2006-08-03',
                    '2008-01-09')
  )

knitr::kable(
  x = data, 
  caption = 'Example outcome cohort.'
    )


## ----echo=FALSE, results='asis'-----------------------------------------------

data <- data.frame(
  patientId = c(2, 3, 4, 5),
  targetCohortId = rep(1,4),
  cohortStartDate = c('2005-09-10', '2004-04-02',
                      '2002-03-03', '2005-02-01'),
  cohortEndDate = c('2005-09-15', '2004-05-17',
                    '2002-06-12','2005-10-08')
  )

knitr::kable(
  x = data, 
  caption = 'Example target cohort meeting risk factor inclusion criteria.'
    )


## ----echo=FALSE, results='asis'-----------------------------------------------

data <- data.frame(
  patientId = c(2, 3, 4, 5),
  targetCohortId = rep(1,4),
  cohortStartDate = c('2005-09-10', '2004-04-02',
                      '2002-03-03', '2005-02-01'),
  cohortEndDate = c('2005-09-15', '2004-05-17',
                    '2002-06-12','2005-10-08'),
  labels = c('Non-outcome', 'Outcome', 'Outcome',
             'Non-outcome')
  )

knitr::kable(
  x = data, 
  caption = 'Example target cohort meeting risk factor inclusion criteria.'
    )


## ----echo=FALSE, results='asis'-----------------------------------------------

targetData <- data.frame(
  patientId = c(2,2,2,3,3,3,4,4,4,5,5,5),
  cohortId = c(rep('Non-outcome',3), rep('Outcome',3), rep('Outcome',3), rep('Non-outcome',3)),
  feature = rep(c('age', 'sex', 'diabetes'),4),
  value = c(50, 'Male', 'Yes',
            18, 'Female', 'No',
            22, 'Male', 'No',
            40, 'Male', 'No'
            )
  )

knitr::kable(
  x = targetData, 
  caption = 'Example patient level feature data.'
    )


## ----echo=FALSE, results='asis'-----------------------------------------------

meanData <- data.frame(
  cohortId = c(rep('Outcome', 3), rep('Non-outcome',3)),
  feature = c('Age', 'Sex: Male', 'Diabetes: Yes',
              'Age', 'Sex: Male', 'Diabetes: Yes'), 
  mean = c(20, 0.50, 0, 45, 1, 0.5)
  )

knitr::kable(
  x = meanData, 
  caption = 'Example aggregate features for risk factor analysis.'
    )


## -----------------------------------------------------------------------------
targetId <- 1
outcomeId <- 2
minPriorObservation <- 365
outcomeWashoutDays <- 365
preTargetIndexDays <- 365
postOutcomeIndexDays <- 365
riskWindowStart <- 1
startAnchor <- 'cohort start'
riskWindowEnd <- 180
endAnchor <- 'cohort start'
covariateSettings <- FeatureExtraction::createCovariateSettings(
  useConditionOccurrenceAnyTimePrior = T, includedCovariateConceptIds = c(201820)
  )

## ----echo=FALSE, results='asis'-----------------------------------------------

data <- data.frame(
  patientId = c(1, 1, 2, 3, 4, 4, 4, 5, 5),
  targetCohortId = rep(1,9),
  cohortStartDate = c('2001-01-20', '2001-10-20',
                      '2005-09-10', '2004-04-02',
                      '2002-03-03', '2003-02-01',
                      '2003-08-04', '2005-02-01',
                      '2007-04-03'),
  cohortEndDate = c('2001-01-25', '2001-12-05',
                    '2005-09-15', '2004-05-17',
                    '2002-06-12', '2003-02-30',
                    '2003-08-24', '2005-10-08',
                    '2007-05-03'),
  observationStart = c('2000-02-01', '2000-02-01',
                       '2001-02-01', '2001-02-01',
                       '2001-02-01', '2001-02-01',
                       '2001-02-01', '2001-02-01',
                       '2001-02-01')
  )

knitr::kable(
  x = data, 
  caption = 'Example target cohort.'
    )


## ----echo=FALSE, results='asis'-----------------------------------------------

data <- data.frame(
  patientId = c(1, 1, 3, 4, 4, 5, 5 ),
  targetCohortId = rep(2,7),
  cohortStartDate = c('1999-10-03', '2001-10-30',
                      '2004-05-16', '2002-06-03',
                      '2003-02-20', '2006-07-21',
                      '2008-01-01'
                      ),
  cohortEndDate = c('1999-10-08', '2001-11-07',
                    '2004-05-18', '2002-06-14',
                    '2003-03-01', '2006-08-03',
                    '2008-01-09')
  )

knitr::kable(
  x = data, 
  caption = 'Example outcome cohort.'
    )


## ----echo=FALSE, results='asis'-----------------------------------------------

data <- data.frame(
  patientId = c(2, 3, 4, 5),
  targetCohortId = rep(1,4),
  cohortStartDate = c('2005-09-10', '2004-04-02',
                      '2002-03-03', '2005-02-01'),
  cohortEndDate = c('2005-09-15', '2004-05-17',
                    '2002-06-12','2005-10-08')
  )

knitr::kable(
  x = data, 
  caption = 'Example target cohort meeting risk factor inclusion criteria.'
    )


## ----echo=FALSE, results='asis'-----------------------------------------------

data <- data.frame(
  patientId = c(3, 4),
  targetCohortId = rep(1,2),
  cohortStartDate = c('2004-04-02',
                      '2002-03-03'),
  cohortEndDate = c('2004-05-17',
                    '2002-06-12'),
  labels = c('Outcome', 'Outcome')
  )

knitr::kable(
  x = data, 
  caption = 'Example target cohort meeting case inclusion criteria.'
    )


## ----echo=FALSE, results='asis'-----------------------------------------------

data <- data.frame(
  patientId = c(3, 4),
  targetCohortId = rep(1,2),
  targetStartDate = c('2004-04-02',
                      '2002-03-03'),
  outcomeStartDate = c('2004-05-16', 
                       '2002-06-03'),
  beforeStartDate = c("2003-04-03", "2001-03-03"),
  beforeEndDate = c('2004-04-02','2002-03-03'),
  duringStartDate = c('2004-04-03','2002-03-04'),
  duringEndDate = c('2004-05-16','2002-06-03'),
  afterStartDate = c('2004-05-17','2002-06-04'),
  afterEndDate = c("2005-05-16", "2003-06-03")
  )

knitr::kable(
  x = data, 
  caption = 'Example  cases with before/during/after dates.'
    )


## ----echo=FALSE, results='asis'-----------------------------------------------

targetData <- data.frame(
  patientId = c(3,3,3,4,4,4),
  feature = rep(c('diabetes'),6),
  timePeriod = rep(c('before','during', 'after'),2),
  value = c('No', 'No', 'Yes',
            'Yes', 'Yes', 'Yes'
            )
  )

knitr::kable(
  x = targetData, 
  caption = 'Example patient level case feature data.'
    )


## ----echo=FALSE, results='asis'-----------------------------------------------

targetData <- data.frame(
  feature = rep(c('diabetes: Yes'),3),
  timePeriod = c('before', 'during', 'after'),
  value = c(0.5,0.5,1)
  )

knitr::kable(
  x = targetData, 
  caption = 'Example patient level case feature data.'
    )


