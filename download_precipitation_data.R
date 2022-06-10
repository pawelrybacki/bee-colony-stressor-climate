library(tidyverse)
library(rnoaa)
library(doBy)

dir.create("prcp_data")

## Download precipitation data

for(j in 1:nrow(state_list)) { 
  z = paste0(state_list$state_id[j])
  q = paste0(state_list$state[j])
  print(q)
  
  if (file.exists(paste0("prcp_data/prcp_", q, ".csv")) == FALSE) {
  prcp_data = data.frame()
  for(i in 1:nrow(months1)) {
    x = paste0(months1$start_date[i])
    y = paste0(months1$end_date[i])
    print(x)
    output <- ncdc(
      datasetid = "GSOM",
      datatypeid = "PRCP",
      stationid = NULL,
      locationid = z,
      startdate = x,
      enddate = y,
      sortfield = NULL,
      sortorder = NULL,
      limit = 1000,
      offset = NULL,
      token = noaakey,
      includemetadata = TRUE,
      add_units = FALSE
    )$data
    # take the mean and standard deviation of all stations in a given          month/state
    collapsed <- summaryBy(value ~ date, FUN=c(mean,sd), data = output)
    prcp_data = rbind(prcp_data, collapsed)
    Sys.sleep(1)
  }
  prcp_data <- mutate(prcp_data, state = q)
  write.csv(prcp_data, paste0("prcp_data/prcp_", q, ".csv"))
  }
}
