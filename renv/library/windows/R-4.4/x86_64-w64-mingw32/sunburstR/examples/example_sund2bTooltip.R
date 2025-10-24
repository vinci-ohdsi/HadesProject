if(interactive()){

library(sunburstR)

# use a sample of the sequences csv data
sequences <- read.csv(
  system.file("examples/visit-sequences.csv",package="sunburstR")
  ,header = FALSE
  ,stringsAsFactors = FALSE
)[1:200,]

# change the tooltip
sund2b(
  sequences,
  tooltip = sund2bTooltip(
    html = htmlwidgets::JS("
function(nodedata, size, percent) {
  return '<span style=\"font-weight: bold;\">' + nodedata.name + '</span>' + ' ' + size
}
    ")
  )
)


}
