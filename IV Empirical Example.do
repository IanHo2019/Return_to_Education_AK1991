clear

import delimited "AK91.csv", clear


** No instruments
regress lwage educ i.yob i.sob, r cformat(%9.4f)


** One instrument
ivregress 2sls lwage (educ = qob) i.yob i.sob, r cformat(%9.4f)
estat firststage
weakiv ivregress 2sls lwage (educ = qob) i.yob i.sob, usegrid


** Three instruments
ivregress 2sls lwage (educ = i.qob) i.yob i.sob, r cformat(%9.4f)
estat firststage
weakiv ivregress 2sls lwage (educ = i.qob) i.yob i.sob, usegrid


** 180 instruments
ivregress 2sls lwage (educ = i.qob i.qob#i.yob i.qob#i.sob) i.yob i.sob, cformat(%9.4f)
estat firststage
weakiv ivregress 2sls lwage (educ = i.qob i.qob#i.yob i.qob#i.sob) i.yob i.sob, usegrid

ivregress liml lwage (educ = i.qob i.qob#i.yob i.qob#i.sob) i.yob i.sob, cformat(%9.4f)