*WIID
**BEST GINI Measures
*WIID
use "[DIRECTORY]\UN\WIID3.4_19JAN2017.dta", clear

set more off
keep if Year>1970

*All Ages
keep if AgeCovr_new==1
*All Regions
keep if  AreaCovr_new==1
*Total pop, not just employed
keep if PopCovr_new==1
*Best quality sources
keep if Quality==1
keep if Year>1970
drop if Gini==.

foreach x in Welfaredefn_new  Equivsc_new UofAnala_new IncSharU_new  {
tab `x', gen(D_`x')
sum `x'
}

areg Gini i.Year i.Welfaredefn_new i.Equivsc_new i.UofAnala_new , ab(Country)
predict est_gini

bysort Country: egen maxy=max(Year)
bysort Country: egen miny=min(Year)
gen length=maxy-miny
bysort Country : egen gini_miny_x=mean(Gini) if miny==Year
bysort Country : egen gini_maxy_x=mean(Gini) if maxy==Year
bysort Country : egen gini_miny=max(gini_miny_x)
bysort Country : egen gini_maxy=max(gini_maxy_x)
gen gini_change=gini_maxy-gini_miny

gen window_max=maxy-10
gen window_min=miny+10

bysort Country : egen gini_window_miny_x=mean(Gini) if Year<=window_min
bysort Country : egen gini_window_maxy_x=mean(Gini) if Year>=window_max
bysort Country : egen gini_window_miny=max(gini_window_miny_x)
bysort Country : egen gini_window_maxy=max(gini_window_maxy_x)
gen gini_change_window=gini_window_maxy-gini_window_miny

collapse (count) N_per_yr=Gini (mean) un_gini=Gini gini_window_miny gini_window_maxy est_gini gini_change_window gini_miny gini_maxy  maxy gini_change miny length, by(Country)
sort Country 
gsort -un_gini
edit
rename Country country

replace country="Ivory Coast" if country=="Cote d'Ivoire"
replace country="Egypt, Arab Rep." if country=="Egypt"
replace country="Hong Kong SAR, China" if country=="Hong Kong"
replace country="Korea, Rep." if country=="Korea, Republic of"
replace country="Macedonia, FYR" if country=="Macedonia, former Yugoslav Republic of"
replace country="Russian Federation" if country=="Russia"
replace country="Slovak Republic" if country=="Slovakia"
replace country="Syrian Arab Republic" if country=="Syria"
replace country="Venezuela, RB" if country=="Venezuela"

save "[DIRECTORY]\UN\UN_Inequality_Best_current_measures.dta", replace
cor un_gini gini_window_miny gini_window_maxy est_gini gini_change_window gini_miny gini_maxy  maxy gini_change

