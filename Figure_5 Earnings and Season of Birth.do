* This do file replicates Figure V in Angrist & Krueger (1991).
* Author: Ian Ho
* Date: Nov 1, 2023
********************************************************************************

clear all

use "Data\AK1991.dta", clear

* Calculate year-quarter average log weekly wage
collapse (mean) lwage, by(yob qob)

* Use season of birth as x-axis
gen x = (yob - 1900) + (qob / 4) - 0.25

* Figure V
twoway (scatter lwage x if inrange(x,30,49.75) & qob==1, mc(black) msymbol(S) mlabel(qob) mlabc(black) mlabsize(vsmall) mlabp(6)) ///
	(scatter lwage x if inrange(x,30,49.75) & qob!=1, mc(black) msymbol(Sh) mlabel(qob) mlabc(black) mlabsize(vsmall) mlabp(6)) ///
	(line lwage x if inrange(x,30,49.75), lc(black)), ///
	xtitle("Year of Birth") ytitle("Mean Log Weekly Earnings") ///
	xlabel(30(2)50, nogrid) leg(off)
graph export "Figures\Figure_5.svg", replace