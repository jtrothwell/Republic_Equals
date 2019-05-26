*use "G:\World_Poll\People\Jonathan_Rothwell\IRS\LARGE_SAMPLE_IRS_ZIP_INCOME2015.dta", clear
insheet using "G:\World_Poll\People\Jonathan_Rothwell\Geographic_Crosswalks\geocorr_puma2014_to_zcta.csv", clear
ren state statefip
ren puma12 puma
format statefip %02.0f
format puma %04.0f
egen puma12=concat(statefip puma), format(%04.0f)
destring puma12, replace
ren zcta5 zcta
save "G:\World_Poll\People\Jonathan_Rothwell\Geographic_Crosswalks\geocorr_puma2014_to_zcta.dta", replace

*ZCTA to ZIP
insheet using "G:\World_Poll\People\Jonathan_Rothwell\Geographic_Crosswalks\zip_to_zcta_2017.csv" , clear
save "G:\World_Poll\People\Jonathan_Rothwell\Geographic_Crosswalks\zip_to_zcta_2017.dta" , replace
*IRS
ren zip_code zip
merge m:1 zip using "G:\World_Poll\People\Jonathan_Rothwell\IRS\LARGE_SAMPLE_IRS_ZIP_INCOME2015.dta"
keep if _merge==3
drop _merge
**MABLE COR--ZCTA-PUMA
merge m:m zcta using "G:\World_Poll\People\Jonathan_Rothwell\Geographic_Crosswalks\geocorr_puma2014_to_zcta.dta"
keep if _merge==3
drop _merge
collapse (count) n=irs_avg_AGI (mean) pct_top1_zip irs_avg_AGI pctinc200k [aw=zip_pop_irs], by(puma12)
save "G:\World_Poll\People\Jonathan_Rothwell\Geographic_Crosswalks\PUMA-Income-IRS.dta" , replace

*ACS 2012-2016
use "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\IPUMS\ACS_2012_2016_Income.dta", clear

format statefip %02.0f
format puma %04.0f
egen puma12=concat(statefip puma), format(%04.0f)
destring puma12, replace

keep if age>=20
replace inctot=. if inctot== 9999999
replace ftotinc=. if ftotinc==9999999
replace  valueh=. if valueh==9999999 

xtile inc_rank=inctot, nq(100)
xtile wage_rank=incwage, nq(100)
xtile home100=valueh, nq(100)

gen top1_home=1 if home100==100
replace top1_home=0 if home100<100
gen top1=1 if inc_rank==100
replace top1=0 if  inc_rank<100

*ZIP data
merge m:1 puma12 using "G:\World_Poll\People\Jonathan_Rothwell\Geographic_Crosswalks\PUMA-Income-IRS.dta" 
drop if _merge==2
drop _merge

*Merge top-codes
ren year year_acs
merge m:1 statefip using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\IPUMS\top1\top_codes_2012_2016_ACS.dta"
drop if _merge==2

gen top_code_wage=1 if incwage==tcincwage
replace top_code_wage=0 if incwage!=tcincwage
gen top_code_bus=1 if incbus00==tcincbus00
replace top_code_bus=0 if incbus00!=tcincbus00
gen top_code_inv=1 if incinvst==tcincinvst
replace top_code_inv=0 if incinvst!=tcincinvst

bysort statefip: egen rev_tcvalueh=max(valueh)
gen top_code_h=1 if valueh==rev_tcvalueh
replace top_code_h=0 if valueh!=rev_tcvalueh

gen inc_bus_own=1 if classwkrd==14
replace inc_bus_own=0 if classwkrd!=14

sum inctot incwage if inc_rank==100
sum inctot incwage if wage_rank==100
sum valueh if top1_home==1 

gen occ2d=substr(occsoc,1,2)
gen occ3d=substr(occsoc,1,3)
gen ind2d=substr(indnaics,1,2)

gen only_bus=1 if inctot==incbus00
replace only_bus=0 if inctot!=incbus00
gen no_wage=1 if incwage==0 
replace no_wage=0 if incwage>0
replace no_wage=1 if incwage==.

gen retired=1 if age>=65 
replace retired=0 if age<65 

sum top_code_wage top_code_bus top_code_inv top_code_h if top1==1 [aw=perwt]
sum top_code_wage top_code_bus top_code_inv top_code_h if top1==0 [aw=perwt]
bysort occ2d: sum top_code_wage top_code_bus top_code_inv top_code_h if top1==0 [aw=perwt]
sum perwt retired if top_code_wage==1 & top1==0
sum perwt no_wage retired if top_code_bus==1 & top1==0

*62% are retirees
sum perwt no_wage retired if top_code_inv==1 & top1==0

*81% of non-top 1% with top-coded investment income are out of labor force
tab empstat if top_code_inv==1 & top1==0
tab empstatd if top_code_inv==1 & top1==0
tab empstatd if top_code_bus==1 & top1==0

tab occ2d if top_code_inv==1 & top1==1
tab occ2d if top_code_inv==1 & top1==0 
tab occ2d if top_code_inv==1 & top1==0 & empstat!=3
tab occ2d if top_code_inv==1 & top1==1 & empstat!=3
tab occ2d if top1==1 

tab ind2d if top_code_inv==1 & top1==0 & empstat!=3
tab ind2d if top_code_inv==1 & top1==0 & empstat!=3 & occ2d=="43"
tab ind2d if top_code_inv==1 & top1==0 & empstat!=3 & occ2d=="41"
*Agriculture, real estate, and construction
tab ind2d if top_code_inv==1 & top1==0 & empstat!=3 & occ2d=="11"

tab occ2d if  top1==1 & occ2d!="0"
tab occsoc if top_code_inv==1 & top1==0 & occ2d=="11"
*sales
tab occsoc if top_code_inv==1 & top1==0 & occ2d=="41"
*office/support
tab occsoc if top_code_inv==1 & top1==0 & occ2d=="43"



tab occ2d if top_code_inv==1 & top1==1
tab occ3d if top_code_inv==1 & top1==1
tab occsoc if top_code_inv==1 & top1==1 & occ2d=="11"
tab occsoc if top_code_inv==1 & top1==0 & occ2d=="11"

tab statefip if tcincbus00<316000
tab statefip if tcincwage<316000

cor top1_home top1
cor valueh inctot ftotinc pct_top1_zip irs_avg_AGI [aw=perwt]

STOP

*TEST top-income thresholds

bysort statefip year

sum top1 if top_code_wage==1
sum age if top_code_wage==1 & tcincwage<316000 & top1==0
sum age if inctot!=.
sum age top1 if incwage<316000

Home value	Average adjusted gross income from IRS in zip code	Percent of residents in zip code with IRS adjusted gross income of $284,000 or higher	Total income, Census	Total family income, Census
*
cor valueh inctot ftotinc  irs_avg_AGI pct_top1_zip   [aw=perwt]
* pctinc200k 

collapse (count) obs=age (rawsum) pop=perwt (mean) valueh top1_home inctot ftotinc pct_top1_zip  irs_avg_AGI pctinc200k top1 [aw=perwt], by(occsoc)
gsort -valueh
format pop %9.0f
outsheet using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Draft\Appendix\6-digit top 1 comparison.csv", c replace
save "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Draft\Appendix\6-digit top 1 comparison.dta",  replace

stop

collapse (rawsum) pop=perwt (mean) valueh top1_home inctot ftotinc pct_top1_zip  irs_avg_AGI pctinc200k top1 [aw=perwt], by(occ3d)
gsort -valueh
format pop %9.0f
outsheet using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Draft\Appendix\3-digit top 1 comparison.csv", c replace

STOP
*use "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Draft\Appendix\6-digit top 1 comparison.dta", clear
*cor top1 valueh top1_home inctot ftotinc pct_top1_zip irs_avg_AGI pctinc200k 

sum inctot ftotinc incbus if 
cor valueh inctot ftotinc pct_top1_zip irs_avg_AGI pctinc200k [aw=perwt]
cor valueh inctot ftotinc pct_top1_zip irs_avg_AGI pctinc200k if sex==1 [aw=perwt]
cor valueh inctot ftotinc pct_top1_zip irs_avg_AGI pctinc200k if sex==1 & occ3d=="111" [aw=perwt]
cor valueh inctot ftotinc pct_top1_zip irs_avg_AGI pctinc200k if occ3d=="111" [aw=perwt]


*collapse (mean) valueh top1_home inctot ftotinc pct_top1_zip  irs_avg_AGI pctinc200k top1 [aw=perwt], by(occ3d)
collapse (mean) valueh top1_home inctot ftotinc pct_top1_zip  irs_avg_AGI pctinc200k top1 [aw=perwt], by(occ2d)
gsort -valueh
outsheet using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Draft\Appendix\2-digit top 1 comparison.csv", c replace



cor top1 pct_top1_zip irs_avg_AGI pctinc200k
reg pct_top1_zip top1
predict top1_err, resid
gsort -top1_err
edit
outsheet using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\IPUMS\top1\top1 by income IRS and ACS 2015.csv", c replace

gsort -pct_top1_zip
edit

**ACS 2012-2016

keep if age>=20
replace inctot=. if inctot==9999999
replace valueh=. if valueh==9999999
xtile inc100=inctot, nq(100)
gen top1=1 if inc100==100
replace top1=0 if inc100<100


*Merge top-codes, 2016 only from 5-year
ren year year_acs
merge m:1 statefip using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\IPUMS\top1\top_codes_2012_2016_ACS.dta"
drop if _merge==2

gen top_code_wage=1 if inctot==tcincwage
replace top_code_wage=0 if inctot!=tcincwage
gen top_code_bus=1 if incbus00==tcincbus00
replace top_code_bus=0 if incbus00!=tcincbus00
gen top_code_inv=1 if incinvst==tcincinvst
replace top_code_inv=0 if incinvst!=tcincinvst

bysort statefip: egen rev_tcvalueh=max(valueh)
gen top_code_h=1 if valueh==rev_tcvalueh
replace top_code_h=0 if valueh!=rev_tcvalueh

gen inc_bus_own=1 if classwkrd==14
replace inc_bus_own=0 if classwkrd!=14

gen occs=occsoc
gen occ2d=substr(occsoc,1,2)
gen occ3d=substr(occsoc,1,3)

gen ind2d=substr(indnaics,1,2)


