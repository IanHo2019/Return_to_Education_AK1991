* This do file replicates Figures I and II in Angrist & Krueger (1991).
* Author: Ian Ho
* Date: Nov 1, 2023
********************************************************************************

clear all

use "Data\AK1991.dta", clear

* Calculate year-quarter average years of completed education
collapse (mean) educ, by(yob qob)

* Use season of birth as x-axis
gen x = (yob - 1900) + (qob / 4) - 0.25

* Figure I
twoway connect educ x if inrange(x,30,39.75), ///
	lc(black) mc(black) msymbol(S) ///
	mlabel(qob) mlabc(black) mlabsize(vsmall) mlabp(6) ///
	xtitle("Year of Birth") ytitle("Years of Completed Education") ///
	xlabel(30/40, nogrid)
graph export "Figures\Figure_1.svg", replace

* Figure II
twoway connect educ x if inrange(x,40,49.75), ///
	lc(black) mc(black) msymbol(S) ///
	mlabel(qob) mlabc(black) mlabsize(vsmall) mlabp(6) ///
	xtitle("Year of Birth") ytitle("Years of Completed Education") ///
	xlabel(40/50, nogrid)
graph export "Figures\Figure_2.svg", replace