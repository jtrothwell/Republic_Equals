*DATA by ZIP
insheet using [16zpallagi.csv], clear

drop if zipcode==99999 | zipcode==0

ren n1 irs_returns
ren n2 irs_pop
ren a02650 irs_income
format irs_income %15.0fc

gen irs_mean_hh_income=(irs_income*1000)/irs_returns
gen irs_ui_pct=n02300/irs_returns
gen irs_pct_with_Kinc=n01000/irs_returns
gen irs_avg_K_income=(1000*a01000)/irs_returns
gen irs_K_inc_reliance=a01000/irs_income
gen irs_pct_with_LLCinc=n26270/irs_returns
gen irs_avg_LLC_incomce=a26270/irs_returns
gen irs_LLC_inc_reliance=a26270/irs_income
gen irs_avg_mort=(a19300*1000)/irs_returns
gen irs_mort_inc_ratio=a19300/irs_income
gen irs_SSI_reliance=a02500/irs_income
gen irs_EITC_pct=n59660/irs_returns
gen irs_avg_AGI=(1000*a00100)/irs_returns
gen irs_mean_ind_income=(irs_income*1000)/irs_pop
gen irs_pct_with_Wage=n00200/irs_returns
gen irs_avg_Wage=(1000*a00200)/irs_returns
gen irs_Wage_reliance=a00200/irs_income

ren n00300 n_interest
ren n00600 n_dividends
ren n00650 n_qdividends

sum irs_income irs_mean_hh_income

bysort agi_stub: sum irs_avg_AGI

*keep if agi_stub==6
gen pctinc200k=1 if agi_stub==6
replace pctinc200k=0 if agi_stub<6

foreach x in irs_avg_AGI  {
gen t100`x'=1 if `x'>284000
replace t100`x'=0 if `x'<284000
replace t100`x'=. if `x'==.
}

collapse (first) statefips state (rawsum) zip_pop_irs=irs_pop (mean)  t100irs_avg_AGI pctinc200k irs_avg_AGI irs_returns irs_pop irs_avg_K_income irs_income  irs_mean_hh_income irs_mean_ind_income irs_avg_Wage irs_avg_LLC_incomce ///
[aw=irs_pop], by(zipcode)
ren zipcode zip
format zip %05.0f

egen xtop_zip_tagi=xtile(irs_avg_AGI), nq(100)
egen xtop_zip_tinc=xtile(irs_mean_ind_income), nq(100)
egen xtop_zip_linc=xtile(irs_avg_Wage), nq(100)
egen xtop_zip_kinc=xtile(irs_avg_K_income), nq(100)


ren t100irs_avg_AGI pct_top1_zip
sum pct_top1_zip irs_avg_AGI pctinc200k
*keep pct_top1_zip irs_avg_AGI pctinc200k zip zip_pop_irs
cor pct_top1_zip irs_avg_AGI pctinc200k

foreach z in zip_pop_irs pct_top1_zip pctinc200k irs_avg_AGI irs_returns irs_pop irs_avg_K_income irs_income irs_mean_hh_income irs_mean_ind_income irs_avg_Wage xtop_zip_tagi xtop_zip_tinc xtop_zip_linc xtop_zip_kinc irs_avg_LLC_incomce  {
ren `z' `z'2016 
}

**Merge Census income by zcta
merge 1:1 zip using zcta_income2012_2016.dta"
keep if _merge==3
drop _merge
destring home_value75 mean_income med_home, replace ignore("N" "-" "+" ",")

cor home_value75 mean_income med_home irs_avg_LLC_incomce pct_top1_zip2016 pctinc200k2016 irs_avg_AGI2016 irs_returns2016 irs_pop2016 irs_avg_K_income2016 irs_income2016 irs_mean_hh_income2016 irs_mean_ind_income2016 irs_avg_Wage2016  [aw=zip_pop_irs]
*no weight
cor home_value75 mean_income med_home irs_avg_LLC_incomce pct_top1_zip2016 pctinc200k2016 irs_avg_AGI2016 irs_returns2016 irs_pop2016 irs_avg_K_income2016 irs_income2016 irs_mean_hh_income2016 irs_mean_ind_income2016 irs_avg_Wage2016  

cor home_value75 mean_income med_home pct_top1_zip2016 pctinc200k2016 irs_avg_AGI2016 irs_returns2016 irs_pop2016 irs_avg_K_income2016 irs_income2016 irs_mean_hh_income2016 irs_mean_ind_income2016 irs_avg_Wage2016 

sum home_value75 mean_income med_home pct_top1_zip2016 pctinc200k2016 irs_avg_AGI2016 irs_returns2016 irs_pop2016 irs_avg_K_income2016 irs_income2016 irs_mean_hh_income2016 irs_mean_ind_income2016 irs_avg_Wage2016  [aw=zip_pop_irs]

