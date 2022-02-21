# IV Empirical Example: Return to Education ([Angrist & Kruger, 1991](https://doi.org/10.2307/2937954))

Here we will estimate a linear model of log(*wage*) as a function of education and additional control variables:

<img src="https://latex.codecogs.com/svg.image?\log(wage)&space;=&space;\beta_0&space;&plus;&space;educ&space;\cdot&space;\beta_1&space;&plus;&space;\sum_{t=31}^{39}&space;1\{yob&space;=&space;t\}&space;\beta_t&space;&plus;&space;\sum_{s=1}^{50}&space;1\{sob&space;=&space;s\}&space;\gamma_s&space;&plus;&space;U" title="\log(wage) = \beta_0 + educ \cdot \beta_1 + \sum_{t=31}^{39} 1\{yob = t\} \beta_t + \sum_{s=1}^{50} 1\{sob = s\} \gamma_s + U" />

where *yob* is year of birth and *sob* is state of birth.

Education, *educ*, is thought to be potentially endogenous:
* Education might suffer from measurement error.
* Unobserved ``ability'' might affect the ``mental cost'' of education and labor market productivity.
* Heterogenous returns to education could lead ``high effect'' agents to choose more education.

Quarter of birth, *qob*, is a potential instrument as it is not a choice variable, and may shift educational attainment due to compulsory schooling laws.

We have multiple choices for the functional form of the instrument:
* One instrument: *qob*.
* Three instruments: 1{*qob* = 2}, 1{*qob* = 3}, 1{*qob* = 4}.
* 180 instruments: Add interactions of the above with 1{*yob* = *t*} and 1{*sob* = *s*}.

As for data, we will use about 330,000 observations from 'AK91'.
