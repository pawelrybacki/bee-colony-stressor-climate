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
