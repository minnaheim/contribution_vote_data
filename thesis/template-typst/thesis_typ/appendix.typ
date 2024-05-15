
#figure(
  image("../figures/desc_stats.png", width: 70%),
  caption: [the descriptive statistics of the main dataset used for the analysis#footnote("the variable Instance refers to the Votes. The Instances are 3, 4, 51, 52, 6 and 7, where 3 stands for the vote in the 113th congress, 51 stands for the first vote in the 115th congress, 52 for the second vote in the 115th congress, etc. The district variable refers to the district which the legislators represented. Sadly not all representatives had the district information.")
 ],
) <desc-stats>


#figure(
    image("../figures/lpm_main.png", width: 110%), 
    caption: [the most important LPM models: c],
) <lpms>


#figure(
    image("../figures/logit.png", width: 60%), 
    caption: [the two Logit models: (1) with only control variables and (2) legislator and year FEs],
) <logit-table>


#figure(
    image("../figures/lpm_basic.png", width: 90%), 
    caption: [the LPM models with only control variables],
) <lpm-control>


#figure(
    image("../figures/lpm_geo.png", width: 65%), 
    caption: [the LPM models with geographical and year fixed effects],
) <lpm-geo>

#figure(
    image("../figures/lpm_party.png", width: 70%), 
    caption: [the LPM models with party and year FEs],
) <lpm-party>

