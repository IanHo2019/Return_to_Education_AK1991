* This do file replicates Tables IV, V, and VI in Angrist & Krueger (1991).
* Author: Ian Ho
* Date: Nov 1, 2023
********************************************************************************

use "Data\AK1991.dta", clear

local t = 4    // Enter 4/5/6 for producing Table IV/V/VI

* Define cohorts by each decade
gen cohort = 2
replace cohort = 3 if (yob >= 1930 & yob <= 1939)
replace cohort = 4 if (yob >= 1940 & yob <= 1949)

* Select samples
if `t'==4 {
	keep if census == 1970 & cohort == 2
}

if `t'==5 {
	keep if census == 1980 & cohort == 3
}

if `t'==6 {
	keep if census == 1980 & cohort == 4
}

* Generate dummies
tab qob, gen(Q)
tab yob, gen(YR)

forvalues q = 1/3 {
	forvalues y = 1/10 {
		gen Z`y'_`q' = Q`q' * YR`y'
	}
}

* Regressions
gen ageqsq = ageq^2

global controls = "race smsa married neweng midatl soatl enocent esocent wnocent wsocent mt"

eststo model1: reg lwage educ YR1-YR9
eststo model3: reg lwage educ YR1-YR9 ageq ageqsq
eststo model5: reg lwage educ YR1-YR9 $controls
eststo model7: reg lwage educ YR1-YR9 $controls ageq ageqsq

eststo model2: ivreghdfe lwage YR1-YR9 (educ = Z* YR1-YR9)
eststo model4: ivreghdfe lwage YR1-YR9 ageq ageqsq (educ = Z* YR1-YR9)
eststo model6: ivreghdfe lwage YR1-YR9 $controls (educ = Z* YR1-YR9)
eststo model8: ivreghdfe lwage YR1-YR9 $controls ageq ageqsq (educ = Z* YR1-YR9)

estout model1 model2 model3 model4 model5 model6 model7 model8, ///
	keep(educ race smsa married ageq ageqsq) ///
	coll(none) cells(b(star fmt(4)) se(par fmt(4))) ///
	starlevels(* .1 ** .05 *** .01) legend ///
	stats(N sargan sargandf, labels("Observations" "Chi square" "dof") fmt("%9.0fc" 1 0))

* Export as a TeX table
label var educ "Years of education"
label var smsa "SMSA (1 = center city)"
label var married "Married (1 = married)"
label var ageq "Age"
label var ageqsq "Age-squared"

estout model1 model2 model3 model4 model5 model6 model7 model8 using "Tables\Table_`t'.tex", ///
	keep(educ race smsa married ageq ageqsq) sty(tex) ///
	label mlab(none) coll(none) ///
	cells(b(star fmt(4)) se(par fmt(4))) ///
	starlevels(* .1 ** .05 *** .01) ///
	preh("\adjustbox{max width=\textwidth}{" ///
		"\begin{tabular}{l*{8}{c}}" "\hline \hline" ///
		"& (1) & (2) & (3) & (4) & (5) & (6) & (7) & (8) \\ " ///
		"Independent variable & OLS & TSLS & OLS & TSLS & OLS & TSLS & OLS & TSLS \\ \hline") ///
	prefoot("\hline" ///
		"9 Year-of-birth dummies	& Yes & Yes & Yes & Yes & Yes & Yes & Yes & Yes \\ " ///
		"8 Region-of-residence dummies	& No & No & No & No & Yes & Yes & Yes & Yes \\ ") ///
	stats(sargan sargandf N, labels("$ \chi^2 $" "dof" "Observations") fmt(1 0 "%9.0fc")) ///
	postfoot("\hline\hline" "\end{tabular}}") replace