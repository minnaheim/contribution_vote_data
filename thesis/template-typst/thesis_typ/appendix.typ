
#figure(
  image("../figures/desc_stats.png", width: 70%),
  caption: [the descriptive statistics of the main dataset used for the analysis#footnote("the variable Instance refers to the Votes. The Instances are 3, 4, 51, 52, 6 and 7, where 3 stands for the vote in the 113th congress, 51 stands for the first vote in the 115th congress, 52 for the second vote in the 115th congress, etc. The district variable refers to the district which the legislators represented. Sadly not all representatives had the district information.")
 ],
) <desc-stats>


#figure(
    image("../figures/party.png", width: 100%), 
    caption: [All party FE models, with all representatives, only those who changed their votes and all those who didn't],
) <logit-main>


#figure(
    image("../figures/lpm_per_vote.png", width: 100%), 
    caption: [the LPM models with only control variables],
) <lpm-control>


#figure(
    image("../figures/log_transformed.png", width: 65%), 
    caption: [the LPM models with geographical and year fixed effects],
) <lpm-geo>
