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
    ## 1  1888-02-01 2022-06-07              Alabama            1 FIPS:01
    ## 2  1893-09-01 2022-06-07               Alaska            1 FIPS:02
    ## 3  1867-08-01 2022-06-07              Arizona            1 FIPS:04
    ## 4  1871-07-01 2022-06-07             Arkansas            1 FIPS:05
    ## 5  1850-10-01 2022-06-07           California            1 FIPS:06
    ## 6  1852-10-01 2022-06-07             Colorado            1 FIPS:08
    ## 7  1884-11-01 2022-06-07          Connecticut            1 FIPS:09
    ## 8  1893-01-01 2022-06-07             Delaware            1 FIPS:10
    ## 9  1870-11-01 2022-06-05 District of Columbia            1 FIPS:11
    ## 10 1871-09-12 2022-06-07              Florida            1 FIPS:12
    ## 11 1849-01-01 2022-06-07              Georgia            1 FIPS:13
    ## 12 1905-01-01 2022-06-07               Hawaii            1 FIPS:15
    ## 13 1892-06-01 2022-06-07                Idaho            1 FIPS:16
    ## 14 1870-10-15 2022-06-07             Illinois            1 FIPS:17
    ## 15 1886-02-01 2022-06-07              Indiana            1 FIPS:18
    ## 16 1888-06-01 2022-06-07                 Iowa            1 FIPS:19
    ## 17 1857-04-01 2022-06-07               Kansas            1 FIPS:20
    ## 18 1872-10-01 2022-06-07             Kentucky            1 FIPS:21
    ## 19 1882-07-01 2022-06-07            Louisiana            1 FIPS:22
    ## 20 1885-06-01 2022-06-07                Maine            1 FIPS:23
    ## 21 1880-01-01 2022-06-07             Maryland            1 FIPS:24
    ## 22 1831-02-01 2022-06-07        Massachusetts            1 FIPS:25
    ## 23 1887-06-01 2022-06-07             Michigan            1 FIPS:26
    ## 24 1886-01-01 2022-06-07            Minnesota            1 FIPS:27
    ## 25 1891-01-01 2022-06-07          Mississippi            1 FIPS:28
    ## 26 1890-01-01 2022-06-07             Missouri            1 FIPS:29
    ## 27 1891-08-01 2022-06-07              Montana            1 FIPS:30
    ## 28 1878-01-01 2022-06-07             Nebraska            1 FIPS:31
    ## 29 1877-07-01 2022-06-07               Nevada            1 FIPS:32
    ## 30 1868-01-01 2022-06-07        New Hampshire            1 FIPS:33
    ## 31 1865-06-01 2022-06-07           New Jersey            1 FIPS:34
    ## 32 1870-01-01 2022-06-07           New Mexico            1 FIPS:35
    ## 33 1869-01-01 2022-06-07             New York            1 FIPS:36
    ## 34 1869-03-01 2022-06-07       North Carolina            1 FIPS:37
    ## 35 1891-07-01 2022-06-07         North Dakota            1 FIPS:38
    ## 36 1871-01-01 2022-06-07                 Ohio            1 FIPS:39
    ## 37 1870-04-01 2022-06-07             Oklahoma            1 FIPS:40
    ## 38 1871-11-01 2022-06-07               Oregon            1 FIPS:41
    ## 39 1849-04-01 2022-06-07         Pennsylvania            1 FIPS:42
    ## 40 1893-01-01 2022-06-07         Rhode Island            1 FIPS:44
    ## 41 1849-05-01 2022-06-07       South Carolina            1 FIPS:45
    ## 42 1893-01-01 2022-06-07         South Dakota            1 FIPS:46
    ## 43 1879-01-01 2022-06-07            Tennessee            1 FIPS:47
    ## 44 1852-04-01 2022-06-07                Texas            1 FIPS:48
    ## 45 1887-12-01 2022-06-07                 Utah            1 FIPS:49
    ## 46 1883-12-01 2022-06-07              Vermont            1 FIPS:50
    ## 47 1869-01-01 2022-06-07             Virginia            1 FIPS:51
    ## 48 1856-01-01 2022-06-07           Washington            1 FIPS:53
    ## 49 1854-01-01 2022-06-07        West Virginia            1 FIPS:54
    ## 50 1869-01-01 2022-06-07            Wisconsin            1 FIPS:55
    ## 51 1889-01-01 2022-06-07              Wyoming            1 FIPS:56
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

Note potential datasets of interest: Precipitation - PRCP Evaporation -
EVAP Pressure - PRES Sky cover & clouds - SKY Sunshine - SUN Air
Temperature - TEMP Water - WATER Wind - WIND Weather Type - WXTYPE

Autumn Precipitation - AUPRCP Autumn Temperature - AUTEMP Spring
Precipitation - SPPRCP Spring Temperature - SPTEMP Summer
Precipitation - SUPRCP Summer Temperature - SUTEMP Winter
Precipitation - WIPRCP Winter Temperature - WITEMP
