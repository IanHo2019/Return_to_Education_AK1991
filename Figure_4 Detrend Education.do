* This do file replicates Figure IV in Angrist & Krueger (1991).
* Author: Ian Ho
* Date: Oct 31, 2023
********************************************************************************

clear all

use "Data\AK1991.dta", clear

* Calculate year-quarter average years of completed education
collapse (mean) educ, by(yob qob)

* Calculate moving average
gen time = yq(yob, qob)
format %tq time

tsset time

tssmooth ma MA = educ, window(2 0 2)

* Generate detrended education series
gen detr_educ = educ - MA

* Figure IV
gen x = (yob - 1900) + (qob / 4) - 0.25

gen lab_loc = 12
replace lab_loc = 6 if detr_educ < 0

twoway bar detr_educ x if inrange(x,30.5,39.75), ///
	yline(0, lc(black) lp(solid) lwidth(thin)) ///
	barwidth(.2) fc(eltblue) ///
	mlabel(qob) mlabc(black) mlabsize(vsmall) mlabv(lab_loc) ///
	title("A) Men born in 1930-1939", position(11)) ///
	xtitle("Year of Birth") ytitle("Schooling Differential") ///
	xlabel(30/40, nogrid) name(panel1, replace)

twoway bar detr_educ x if inrange(x,40,49.25), ///
	yline(0, lc(black) lp(solid) lwidth(thin)) ///
	barwidth(.2) fc(eltblue) ///
	mlabel(qob) mlabc(black) mlabsize(vsmall) mlabv(lab_loc) ///
	title("B) Men born in 1940-1949", position(11)) ///
	xtitle("Year of Birth") ytitle("Schooling Differential") ///
	xlabel(40/50, nogrid) name(panel2, replace)

gr combine panel1 panel2, rows(2) xsize(5) ysize(5)
graph export "Figures\Figure_4.svg", replace