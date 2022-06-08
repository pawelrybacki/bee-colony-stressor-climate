dir.create("temp_data")

# Loop over all states
for(j in 1:nrow(state_list)) { 
  z = paste0(state_list$state_id[j])
  q = paste0(state_list$state[j])
  print(q)
  temp_data = data.frame()
  
  # loop over the temporal range
  for(i in 1:nrow(months1)) {
    x = paste0(months1$start_date[i])
    y = paste0(months1$end_date[i])
    print(x)
    # Make an API request for average temperature in a given month/year/state.
    output <- ncdc(
      datasetid = "GSOM",
      datatypeid = "TAVG",
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
    # The data contains a long list of different meteorological stations in the requested state. Take the mean and standard deviation of all stations in a given year/month/state using a function somewhat familiar to Stata users:
    collapsed <- summaryBy(value ~ date, FUN=c(mean,sd), data = output)
    # append the new year/state combination to the existing temperature dataframe.
    temp_data = rbind(temp_data, collapsed) 
  }
  # add state name
  temp_data <- mutate(temp_data, state = q)
  # save
  write.csv(temp_data, paste0("temp_data/avgtemp_", q, ".csv"))
}
