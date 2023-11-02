* This do file replicates part of Table I in Angrist & Krueger (1991).
* Author: Ian Ho
* Date: Oct 31, 2023
********************************************************************************

clear all

use "Data\AK1991.dta", clear

keep if census == 1980

* Define cohorts by each decade
gen cohort = 2
replace cohort = 3 if (yob >= 1930 & yob <= 1939)
replace cohort = 4 if (yob >= 1940 & yob <= 1949)

gen time = yq(yob, qob)
format %tq time

* Calculate moving average for men born in 1930-1939
forvalues i = 3/4 {
	preserve
	
	keep if cohort == `i'
	
	collapse (mean) educ, by(time)

	tsset time
	tssmooth ma MA`i' = educ, window(2 0 2)
	
	drop educ
	
	save "Data\AK1991_MA`i'0.dta", replace
	
	restore
}

* Generate the detrended outcome variable
merge m:1 time using "Data\AK1991_MA30.dta"
drop _merge

merge m:1 time using "Data\AK1991_MA40.dta"
drop _merge

egen MA = rowmin(MA3 MA4)

gen detr_educ = educ - MA

* Generate dummy variables for quarters of birth
tab qob, gen(Q_)

* Calculate the cohort-specific mean (Column 3)
bysort cohort: sum educ

* Run the regressions (Columns 4-7)
forvalues i = 3/4 {
	eststo model`i': reg detr_educ Q_1 Q_2 Q_3 if cohort==`i', r
}

estout model*, keep(Q_*) ///
	coll(none) cells(b(star fmt(3)) se(par fmt(3))) ///
	starlevels(* .1 ** .05 *** .01) ///
	stats(N F, nostar labels("Observations" "F-test") fmt("%9.0fc" 3))

/* Calculate p-value for F test
scalar f = e(F)
scalar n1 = e(df_m)
scalar n2 = e(df_r)
scalar G = F(n1, n2, f)
display 1 - G
*/