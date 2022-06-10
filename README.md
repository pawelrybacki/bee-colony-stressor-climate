This file was originally a part of a team project whose goal was to
establish relationships among variables related to bee colony losses,
bee colony stressors, and climate.

The data describing bee colonies come from the Bee Colonies dataset from
[TidyTuesday](https://github.com/rfordatascience/tidytuesday/blob/master/data/2022/2022-01-11/readme.md#bee-colonies).
This source has two datasets – related to colonies and stressors. The
stressor dataset has 5 variables and 7,332 observations. Here are the
explanations of variables in these two subsets:

<table>
<colgroup>
<col style="width: 7%" />
<col style="width: 6%" />
<col style="width: 85%" />
</colgroup>
<thead>
<tr class="header">
<th>Variable</th>
<th>Class</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>year</td>
<td>character</td>
<td>Year</td>
</tr>
<tr class="even">
<td>months</td>
<td>character</td>
<td>Month range</td>
</tr>
<tr class="odd">
<td>state</td>
<td>character</td>
<td>State Name (note there is United States and Other States)</td>
</tr>
<tr class="even">
<td>stressor</td>
<td>character</td>
<td>Stress type</td>
</tr>
<tr class="odd">
<td>stress_pct</td>
<td>double</td>
<td>Percent of colonies affected by stressors anytime during the
quarter, colony can be affected by multiple stressors during same
quarter</td>
</tr>
</tbody>
</table>

This file uses the TidyTuesday Bee Colonies stressors dataset and
downloads data on climate from the National Climatic Data Center using
API through the `rnoaa` package, an R interface to NOAA climate data.

More specifically, this script uses `rnoaa` to download, transform, and
merge data so that the temperature, precipitation, and bee colony
stressor types and effects for all 50 states (if applicable) and all
quarters of the years 2015-2021 are present in one final dataset called
`stressor_climate.csv`.

## About the use of the `rnoaa` package

To use some components of the package, including the ones related to
this project, the user must get an API key (aka, token) from
<https://www.ncdc.noaa.gov/cdo-web/token>. The token must be passed in
some API requests (functions of the packages) as an argument. Rather
than hard-coding the token, it’s safer to pass it as a variable stored
in:

1.  your .Rprofile file with the entry options(noaakey =
    “your-noaa-token”), or

2.  your .Renviron file with the entry NOAA\_KEY=your-noaa-token

## NOAA data exploration

    # Show all location categories (first 25 results).
    ncdc_locs_cats()

    ## $meta
    ## $meta$totalCount
    ## [1] 12
    ## 
    ## $meta$pageCount
    ## [1] 25
    ## 
    ## $meta$offset
    ## [1] 1
    ## 
    ## 
    ## $data
    ##                          name       id
    ## 1                        City     CITY
    ## 2            Climate Division CLIM_DIV
    ## 3              Climate Region CLIM_REG
    ## 4                     Country    CNTRY
    ## 5                      County     CNTY
    ## 6  Hydrologic Accounting Unit  HYD_ACC
    ## 7  Hydrologic Cataloging Unit  HYD_CAT
    ## 8           Hydrologic Region  HYD_REG
    ## 9        Hydrologic Subregion  HYD_SUB
    ## 10                      State       ST
    ## 11               US Territory  US_TERR
    ## 12                   Zip Code      ZIP
    ## 
    ## attr(,"class")
    ## [1] "ncdc_locs_cats"

    # Fetch all available U.S. States.
    ncdc_locs(locationcategoryid='ST', limit=52)

    ## $meta
    ## $meta$totalCount
    ## [1] 51
    ## 
    ## $meta$pageCount
    ## [1] 52
    ## 
    ## $meta$offset
    ## [1] 1
    ## 
    ## 
    ## $data
    ##       mindate    maxdate                 name datacoverage      id
    ## 1  1888-02-01 2022-06-09              Alabama            1 FIPS:01
    ## 2  1893-09-01 2022-06-09               Alaska            1 FIPS:02
    ## 3  1867-08-01 2022-06-09              Arizona            1 FIPS:04
    ## 4  1871-07-01 2022-06-09             Arkansas            1 FIPS:05
    ## 5  1850-10-01 2022-06-09           California            1 FIPS:06
    ## 6  1852-10-01 2022-06-09             Colorado            1 FIPS:08
    ## 7  1884-11-01 2022-06-09          Connecticut            1 FIPS:09
    ## 8  1893-01-01 2022-06-09             Delaware            1 FIPS:10
    ## 9  1870-11-01 2022-06-07 District of Columbia            1 FIPS:11
    ## 10 1871-09-12 2022-06-09              Florida            1 FIPS:12
    ## 11 1849-01-01 2022-06-09              Georgia            1 FIPS:13
    ## 12 1905-01-01 2022-06-09               Hawaii            1 FIPS:15
    ## 13 1892-06-01 2022-06-09                Idaho            1 FIPS:16
    ## 14 1870-10-15 2022-06-09             Illinois            1 FIPS:17
    ## 15 1886-02-01 2022-06-09              Indiana            1 FIPS:18
    ## 16 1888-06-01 2022-06-09                 Iowa            1 FIPS:19
    ## 17 1857-04-01 2022-06-09               Kansas            1 FIPS:20
    ## 18 1872-10-01 2022-06-09             Kentucky            1 FIPS:21
    ## 19 1882-07-01 2022-06-09            Louisiana            1 FIPS:22
    ## 20 1885-06-01 2022-06-09                Maine            1 FIPS:23
    ## 21 1880-01-01 2022-06-09             Maryland            1 FIPS:24
    ## 22 1831-02-01 2022-06-09        Massachusetts            1 FIPS:25
    ## 23 1887-06-01 2022-06-09             Michigan            1 FIPS:26
    ## 24 1886-01-01 2022-06-09            Minnesota            1 FIPS:27
    ## 25 1891-01-01 2022-06-09          Mississippi            1 FIPS:28
    ## 26 1890-01-01 2022-06-09             Missouri            1 FIPS:29
    ## 27 1891-08-01 2022-06-09              Montana            1 FIPS:30
    ## 28 1878-01-01 2022-06-09             Nebraska            1 FIPS:31
    ## 29 1877-07-01 2022-06-09               Nevada            1 FIPS:32
    ## 30 1868-01-01 2022-06-09        New Hampshire            1 FIPS:33
    ## 31 1865-06-01 2022-06-09           New Jersey            1 FIPS:34
    ## 32 1870-01-01 2022-06-09           New Mexico            1 FIPS:35
    ## 33 1869-01-01 2022-06-09             New York            1 FIPS:36
    ## 34 1869-03-01 2022-06-09       North Carolina            1 FIPS:37
    ## 35 1891-07-01 2022-06-09         North Dakota            1 FIPS:38
    ## 36 1871-01-01 2022-06-09                 Ohio            1 FIPS:39
    ## 37 1870-04-01 2022-06-09             Oklahoma            1 FIPS:40
    ## 38 1871-11-01 2022-06-09               Oregon            1 FIPS:41
    ## 39 1849-04-01 2022-06-09         Pennsylvania            1 FIPS:42
    ## 40 1893-01-01 2022-06-09         Rhode Island            1 FIPS:44
    ## 41 1849-05-01 2022-06-09       South Carolina            1 FIPS:45
    ## 42 1893-01-01 2022-06-09         South Dakota            1 FIPS:46
    ## 43 1879-01-01 2022-06-09            Tennessee            1 FIPS:47
    ## 44 1852-04-01 2022-06-09                Texas            1 FIPS:48
    ## 45 1887-12-01 2022-06-09                 Utah            1 FIPS:49
    ## 46 1883-12-01 2022-06-09              Vermont            1 FIPS:50
    ## 47 1869-01-01 2022-06-09             Virginia            1 FIPS:51
    ## 48 1856-01-01 2022-06-09           Washington            1 FIPS:53
    ## 49 1854-01-01 2022-06-09        West Virginia            1 FIPS:54
    ## 50 1869-01-01 2022-06-09            Wisconsin            1 FIPS:55
    ## 51 1889-01-01 2022-06-09              Wyoming            1 FIPS:56
    ## 
    ## attr(,"class")
    ## [1] "ncdc_locs"

    # See data categories available for Nevada (locationid = "FIPS:32"), for example.
    ncdc_datacats(locationid = "FIPS:32", limit = 100)

    ## $meta
    ## $meta$totalCount
    ## [1] 42
    ## 
    ## $meta$pageCount
    ## [1] 100
    ## 
    ## $meta$offset
    ## [1] 1
    ## 
    ## 
    ## $data
    ##                          name            id
    ## 1         Annual Agricultural        ANNAGR
    ## 2          Annual Degree Days         ANNDD
    ## 3        Annual Precipitation       ANNPRCP
    ## 4          Annual Temperature       ANNTEMP
    ## 5         Autumn Agricultural         AUAGR
    ## 6          Autumn Degree Days          AUDD
    ## 7        Autumn Precipitation        AUPRCP
    ## 8          Autumn Temperature        AUTEMP
    ## 9                    Computed          COMP
    ## 10      Computed Agricultural       COMPAGR
    ## 11                Degree Days            DD
    ## 12           Dual-Pol Moments DUALPOLMOMENT
    ## 13                  Echo Tops       ECHOTOP
    ## 14                Evaporation          EVAP
    ## 15           Hydrometeor Type   HYDROMETEOR
    ## 16                       Land          LAND
    ## 17                 Miscellany          MISC
    ## 18                      Other         OTHER
    ## 19                    Overlay       OVERLAY
    ## 20              Precipitation          PRCP
    ## 21                   Pressure          PRES
    ## 22               Reflectivity  REFLECTIVITY
    ## 23         Sky cover & clouds           SKY
    ## 24        Spring Agricultural         SPAGR
    ## 25         Spring Degree Days          SPDD
    ## 26       Spring Precipitation        SPPRCP
    ## 27         Spring Temperature        SPTEMP
    ## 28        Summer Agricultural         SUAGR
    ## 29         Summer Degree Days          SUDD
    ## 30                   Sunshine           SUN
    ## 31       Summer Precipitation        SUPRCP
    ## 32         Summer Temperature        SUTEMP
    ## 33            Air Temperature          TEMP
    ## 34                   Velocity      VELOCITY
    ## 35 Vertical Integrated Liquid VERTINTLIQUID
    ## 36                      Water         WATER
    ## 37        Winter Agricultural         WIAGR
    ## 38         Winter Degree Days          WIDD
    ## 39                       Wind          WIND
    ## 40       Winter Precipitation        WIPRCP
    ## 41         Winter Temperature        WITEMP
    ## 42               Weather Type        WXTYPE
    ## 
    ## attr(,"class")
    ## [1] "ncdc_datacats"

Note potential datasets of interest:

Precipitation - PRCP

Evaporation - EVAP

Pressure - PRES

Sky cover & clouds - SKY

Sunshine - SUN

Air Temperature - TEMP

Water - WATER

Wind - WIND

Weather Type - WXTYPE

Autumn Precipitation - AUPRCP

Autumn Temperature - AUTEMP

Spring Precipitation - SPPRCP

Spring Temperature - SPTEMP

Summer Precipitation - SUPRCP

Summer Temperature - SUTEMP

Winter Precipitation - WIPRCP

Winter Temperature - WITEMP

    # explore datasets based on a particular category (temperature) and for a particular state (Nevada).
    ncdc_datasets(datacategoryid = "TEMP", locationid = "FIPS:32", limit = 100)

    ## $meta
    ## $meta$offset
    ## [1] 1
    ## 
    ## $meta$count
    ## [1] 11
    ## 
    ## $meta$limit
    ## [1] 100
    ## 
    ## 
    ## $data
    ##                     uid    mindate    maxdate                        name
    ## 1  gov.noaa.ncdc:C00861 1763-01-01 2022-06-06             Daily Summaries
    ## 2  gov.noaa.ncdc:C00946 1763-01-01 2022-06-01 Global Summary of the Month
    ## 3  gov.noaa.ncdc:C00947 1763-01-01 2022-01-01  Global Summary of the Year
    ## 4  gov.noaa.ncdc:C00345 1991-06-05 2022-06-07    Weather Radar (Level II)
    ## 5  gov.noaa.ncdc:C00708 1994-05-20 2022-06-07   Weather Radar (Level III)
    ## 6  gov.noaa.ncdc:C00821 2010-01-01 2010-01-01     Normals Annual/Seasonal
    ## 7  gov.noaa.ncdc:C00823 2010-01-01 2010-12-31               Normals Daily
    ## 8  gov.noaa.ncdc:C00824 2010-01-01 2010-12-31              Normals Hourly
    ## 9  gov.noaa.ncdc:C00822 2010-01-01 2010-12-01             Normals Monthly
    ## 10 gov.noaa.ncdc:C00505 1970-05-12 2014-01-01     Precipitation 15 Minute
    ## 11 gov.noaa.ncdc:C00313 1900-01-01 2014-01-01        Precipitation Hourly
    ##    datacoverage         id
    ## 1          1.00      GHCND
    ## 2          1.00       GSOM
    ## 3          1.00       GSOY
    ## 4          0.95    NEXRAD2
    ## 5          0.95    NEXRAD3
    ## 6          1.00 NORMAL_ANN
    ## 7          1.00 NORMAL_DLY
    ## 8          1.00 NORMAL_HLY
    ## 9          1.00 NORMAL_MLY
    ## 10         0.25  PRECIP_15
    ## 11         1.00 PRECIP_HLY
    ## 
    ## attr(,"class")
    ## [1] "ncdc_datasets"

    # Get a list of variables (datatypes) from a particular dataset (GSOM, Global Summary of the Month), based on particular categories (temperature and precipitation) and for a particular state (Nevada).
    ncdc_datatypes(datasetid = "GSOM", datacategoryid = "TEMP", locationid = "FIPS:32", limit = 100)

    ## $meta
    ##   offset count limit
    ## 1      1     7   100
    ## 
    ## $data
    ##      mindate    maxdate                                        name
    ## 1 1763-01-01 2022-05-01          Cooling Degree Days Season to Date
    ## 2 1763-01-01 2022-05-01 Extreme minimum temperature for the period.
    ## 3 1763-01-01 2022-05-01 Extreme maximum temperature for the period.
    ## 4 1763-07-01 2022-05-01          Heating Degree Days Season to Date
    ## 5 1763-01-01 2022-05-01                        Average Temperature.
    ## 6 1763-01-01 2022-05-01                         Maximum temperature
    ## 7 1763-01-01 2022-05-01                         Minimum temperature
    ##   datacoverage   id
    ## 1            1 CDSD
    ## 2            1 EMNT
    ## 3            1 EMXT
    ## 4            1 HDSD
    ## 5            1 TAVG
    ## 6            1 TMAX
    ## 7            1 TMIN
    ## 
    ## attr(,"class")
    ## [1] "ncdc_datatypes"

    ncdc_datatypes(datasetid = "GSOM", datacategoryid = "PRCP", locationid = "FIPS:32", limit = 100)

    ## $meta
    ##   offset count limit
    ## 1      1     7   100
    ## 
    ## $data
    ##      mindate    maxdate
    ## 1 1863-12-01 2022-05-01
    ## 2 1840-05-01 2022-05-01
    ## 3 1863-12-01 2022-05-01
    ## 4 1840-05-01 2022-05-01
    ## 5 1781-01-01 2022-05-01
    ## 6 1781-01-01 2022-05-01
    ## 7 1840-05-01 2022-05-01
    ##                                                           name datacoverage
    ## 1 Number days with snow depth > 1 inch(25.4mm) for the period.            1
    ## 2                        Number days with snow depth > 1 inch.            1
    ## 3                   Extreme maximum snow depth for the period.            1
    ## 4                     Extreme maximum snowfall for the period.            1
    ## 5                Extreme maximum precipitation for the period.            1
    ## 6                                                Precipitation            1
    ## 7                                                     Snowfall            1
    ##     id
    ## 1 DSND
    ## 2 DSNW
    ## 3 EMSD
    ## 4 EMSN
    ## 5 EMXP
    ## 6 PRCP
    ## 7 SNOW
    ## 
    ## attr(,"class")
    ## [1] "ncdc_datatypes"

## Prepare dataframes with states, years, and months of interest

In a format suitable for use with the `rnoaa` package.

    # Sources that inspired the code below:
    # https://stackoverflow.com/questions/29402528/append-data-frames-together-in-a-for-loop
    # https://stackoverflow.com/questions/53735450/using-a-loop-to-cycle-though-api-calls-in-r
    # https://www.projectpro.io/recipes/append-output-from-for-loop-dataframe-r

    # Store all state codes in a dataframe
    state_list <- ncdc_locs(locationcategoryid='ST', limit=52)$data %>% 
      select(name, id) %>% 
      rename(state = name, state_id = id)

    # Store all years in a dataframe
    years <- tribble(
      ~year, ~x,
      "2015", 1,
      "2016", 1,
      "2017", 1,
      "2018", 1,
      "2019", 1,
      "2020", 1,
      "2021", 1
    )

    # Store all start and end dates requested in a dataframe
    months1 <- data.frame()

    for(i in 1:nrow(years)) {
      y = paste0(years$year[i])
      output <- tribble(
      ~start_date,  ~end_date,
      paste0(y,"-01-01"), paste0(y,"-01-31"),
      paste0(y,"-02-01"), paste0(y,"-03-31"),
      paste0(y,"-04-01"), paste0(y,"-06-30"),
      paste0(y,"-07-01"), paste0(y,"-08-31"),
      paste0(y,"-09-01"), paste0(y,"-10-31"),
      paste0(y,"-11-01"), paste0(y,"-12-31"),
    )
      months1 = rbind(months1, output) 
    }

## Download temperature data

This chunk may take a lot of time and internet data to complete. Thus,
it runs a separate script: `download_temperature_data.R,` not run while
knitting the markdown file..

    source("download_temperature_data.R", local = knitr::knit_global())

    ## Warning in dir.create("temp_data"): 'temp_data' already exists

    ## [1] "Alabama"
    ## [1] "Alaska"
    ## [1] "Arizona"
    ## [1] "Arkansas"
    ## [1] "California"
    ## [1] "Colorado"
    ## [1] "Connecticut"
    ## [1] "Delaware"
    ## [1] "District of Columbia"
    ## [1] "Florida"
    ## [1] "Georgia"
    ## [1] "Hawaii"
    ## [1] "Idaho"
    ## [1] "Illinois"
    ## [1] "Indiana"
    ## [1] "Iowa"
    ## [1] "Kansas"
    ## [1] "Kentucky"
    ## [1] "Louisiana"
    ## [1] "Maine"
    ## [1] "Maryland"
    ## [1] "Massachusetts"
    ## [1] "Michigan"
    ## [1] "Minnesota"
    ## [1] "Mississippi"
    ## [1] "Missouri"
    ## [1] "Montana"
    ## [1] "Nebraska"
    ## [1] "Nevada"
    ## [1] "New Hampshire"
    ## [1] "New Jersey"
    ## [1] "New Mexico"
    ## [1] "New York"
    ## [1] "North Carolina"
    ## [1] "North Dakota"
    ## [1] "Ohio"
    ## [1] "Oklahoma"
    ## [1] "Oregon"
    ## [1] "Pennsylvania"
    ## [1] "Rhode Island"
    ## [1] "South Carolina"
    ## [1] "South Dakota"
    ## [1] "Tennessee"
    ## [1] "Texas"
    ## [1] "Utah"
    ## [1] "Vermont"
    ## [1] "Virginia"
    ## [1] "Washington"
    ## [1] "West Virginia"
    ## [1] "Wisconsin"
    ## [1] "Wyoming"

## Combine temperature data from all states.

    # https://statisticsglobe.com/merge-csv-files-in-r
    # combine temperature data from all states into a single file
    unlink(c("temp_data/avgtemp_all_states.csv", "temp_data/avg_temp_q_all_states.csv"))
    avg_temp <- list.files(path = "temp_data/",  # Identify all CSV files
                           pattern = "*.csv", full.names = TRUE) %>% 
      lapply(read_csv) %>% bind_rows %>% dplyr::select(-1) %>% dplyr::rename(temp_mean = value.mean, temp_sd = value.sd)

    avg_temp 

    ## # A tibble: 4,277 × 4
    ##    date                temp_mean temp_sd state  
    ##    <dttm>                  <dbl>   <dbl> <chr>  
    ##  1 2015-01-01 00:00:00      6.16   2.13  Alabama
    ##  2 2015-02-01 00:00:00      4.67   2.63  Alabama
    ##  3 2015-03-01 00:00:00     14.0    2.30  Alabama
    ##  4 2015-04-01 00:00:00     18.7    1.78  Alabama
    ##  5 2015-05-01 00:00:00     22.0    1.37  Alabama
    ##  6 2015-06-01 00:00:00     26.1    0.958 Alabama
    ##  7 2015-07-01 00:00:00     27.5    1.04  Alabama
    ##  8 2015-08-01 00:00:00     26.1    1.32  Alabama
    ##  9 2015-09-01 00:00:00     23.5    1.27  Alabama
    ## 10 2015-10-01 00:00:00     18.2    1.58  Alabama
    ## # … with 4,267 more rows

    write.csv(avg_temp, paste0("temp_data/avgtemp_", "all_states", ".csv"))

## Take quarter means of temperature data.

    # based on the data in the existing dataframe, attribute a quarter to each year/month/state
    avg_temp_q <- avg_temp %>%
      mutate(quarter = paste0(substring(year(date),3,4),"/0",quarter(date))) 

    # https://stats.oarc.ucla.edu/r/faq/how-can-i-collapse-my-data-in-r/
    # Take the mean and standard deviation of all months within a quarter/state using a function somewhat familiar to Stata users:
    avg_temp_q <- summaryBy(temp_mean ~ quarter + state, FUN=c(mean,sd), data = avg_temp_q)

    # rename for clarity
    avg_temp_q <- avg_temp_q %>% dplyr::rename(temp_mean = temp_mean.mean, temp_sd = temp_mean.sd)

    # save
    write.csv(avg_temp_q, paste0("temp_data/avg_temp_q_", "all_states", ".csv"))
    unlink("temp_data/avgtemp_all_states.csv")

## Download precipitation data

Similarly to the one downloading temperature data, this chunk may take a
lot of time and internet data to complete. Thus, it runs a separate
script, `download_precipitation_data.R,` not run while knitting the
markdown file.

    source("download_precipitation_data.R", local = knitr::knit_global())

    ## Warning in dir.create("prcp_data"): 'prcp_data' already exists

    ## [1] "Alabama"
    ## [1] "Alaska"
    ## [1] "Arizona"
    ## [1] "Arkansas"
    ## [1] "California"
    ## [1] "Colorado"
    ## [1] "Connecticut"
    ## [1] "Delaware"
    ## [1] "District of Columbia"
    ## [1] "Florida"
    ## [1] "Georgia"
    ## [1] "Hawaii"
    ## [1] "Idaho"
    ## [1] "Illinois"
    ## [1] "Indiana"
    ## [1] "Iowa"
    ## [1] "Kansas"
    ## [1] "Kentucky"
    ## [1] "Louisiana"
    ## [1] "Maine"
    ## [1] "Maryland"
    ## [1] "Massachusetts"
    ## [1] "Michigan"
    ## [1] "Minnesota"
    ## [1] "Mississippi"
    ## [1] "Missouri"
    ## [1] "Montana"
    ## [1] "Nebraska"
    ## [1] "Nevada"
    ## [1] "New Hampshire"
    ## [1] "New Jersey"
    ## [1] "New Mexico"
    ## [1] "New York"
    ## [1] "North Carolina"
    ## [1] "North Dakota"
    ## [1] "Ohio"
    ## [1] "Oklahoma"
    ## [1] "Oregon"
    ## [1] "Pennsylvania"
    ## [1] "Rhode Island"
    ## [1] "South Carolina"
    ## [1] "South Dakota"
    ## [1] "Tennessee"
    ## [1] "Texas"
    ## [1] "Utah"
    ## [1] "Vermont"
    ## [1] "Virginia"
    ## [1] "Washington"
    ## [1] "West Virginia"
    ## [1] "Wisconsin"
    ## [1] "Wyoming"

## Combine precipitation data from all states.

    # https://statisticsglobe.com/merge-csv-files-in-r
    prcp <- list.files(path = "prcp_data/",  # Identify all CSV files
                           pattern = "*.csv", full.names = TRUE) %>% 
      lapply(read_csv) %>% bind_rows %>% select(-1) %>% dplyr::rename(prcp_mean = value.mean, prcp_sd = value.sd)

    prcp 

    ## # A tibble: 4,152 × 4
    ##    date                prcp_mean prcp_sd state  
    ##    <dttm>                  <dbl>   <dbl> <chr>  
    ##  1 2015-01-01 00:00:00     110.     27.0 Alabama
    ##  2 2015-02-01 00:00:00     102.     25.5 Alabama
    ##  3 2015-03-01 00:00:00     119.     37.2 Alabama
    ##  4 2015-04-01 00:00:00     197.     57.3 Alabama
    ##  5 2015-05-01 00:00:00     107.     41.3 Alabama
    ##  6 2015-06-01 00:00:00      86.0    39.3 Alabama
    ##  7 2015-07-01 00:00:00     129.     41.3 Alabama
    ##  8 2015-08-01 00:00:00     149.     53.5 Alabama
    ##  9 2015-09-01 00:00:00      61.6    54.4 Alabama
    ## 10 2015-10-01 00:00:00      75.5    28.6 Alabama
    ## # … with 4,142 more rows

    write.csv(prcp, paste0("prcp_data/prcp_", "all_states", ".csv"))
