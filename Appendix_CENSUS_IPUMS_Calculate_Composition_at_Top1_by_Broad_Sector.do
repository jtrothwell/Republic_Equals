
cd  "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\IPUMS"

/*
use indnaics ind1990  perwt year using USA2015.dta, clear     

gen naics2=substr(indnaics,1,2)
tab naics2
replace naics2="31-33" if naics2=="3M"
replace naics2="31-33" if naics2=="31"
replace naics2="31-33" if naics2=="32"
replace naics2="31-33" if naics2=="33"
replace naics2="44-45" if naics2=="4M"
replace naics2="48-49" if naics2=="48"
replace naics2="48-49" if naics2=="49"
replace naics2="44-45" if naics2=="44"
replace naics2="44-45" if naics2=="45"

collapse (sum) pop=perwt, by(naics2 ind1990)
gsort naics2 -pop
edit

bysort ind1990: egen max_cov=max(pop)
keep if max_cov==pop
edit 

drop pop
drop max_cov
save "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\IPUMS\Match_Ind1990_NAICS_2D.dta", replace
*/

clear
set more off

global datasets "USA1970 USA1980 USA1990 USA2000 USA2015"

*program drop make_var 
program define make_naics2_loop     
 keep sex age empstat educ*  ind1990 inctot perwt
 keep if empstat==1
 keep if age>=18 & age<=64
  decode ind1990, generate(i_title)
 *Broad occupations
 merge m:1 ind1990 using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\IPUMS\Match_Ind1990_NAICS_2D.dta"
 drop _merge


 gen male=1 if sex==1
 replace male=0 if sex!=1
 replace inctot=. if inctot==9999999
 replace inctot=0 if inctot<0
 gen age2=age^2
 gen age3=age^3

 gen lninc=ln(inc)
 areg lninc age age2 age3 male, ab(educ)
 predict earn_res, res

 xtile inc100=inctot, nq(100)

 gen top1=1 if inc100==100
 replace top1=0 if inc100<100
end     

cd  "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\IPUMS"

**Occ only
foreach data in $datasets  {     
 use sex age empstat educ* ind1990 inctot perwt year using `data'.dta, clear     
 quietly make_naics2_loop     
  
  
bysort naics2: egen pop_occ=total(perwt)
egen pop=total(perwt)
gen sh_all=pop_occ/pop
bysort naics2: egen pop1_occ=total(perwt*top1)
egen pop1=total(perwt*top1)
gen sh_top1=pop1_occ/pop1

collapse (rawsum) pop=perwt (first)  sh_all sh_top1 (mean) top1 inctot earn_res [aw=perwt], by(naics2)
format pop %15.0f
gsort -sh_top1
outsheet using `data'_top1_by_naics2.csv, c replace
save `data'_top1_by_naics2.dta, replace
}     


********
******
**ANALYIS

*Combine occupations
use USA2015_top1_by_naics2.dta, clear
gen year=2015
append using  USA2000_top1_by_naics2.dta
replace year=2000 if year==.
append using  USA1990_top1_by_naics2.dta
replace year=1990 if year==.
append using  USA1980_top1_by_naics2.dta
replace year=1980 if year==.
append using  USA1970_top1_by_naics2.dta
replace year=1970 if year==.

gen num_top1=pop*top1
bysort year: egen us_num_top1=total(num_top1)

drop if naics2==""
keep num_top1 us_num_top1 naics2 sh_top1 top1 year earn_res
reshape wide num_top1 us_num_top1 sh_top1 top1 earn_res, i(naics2) j(year)

gen change=num_top12015-num_top11980
gen us_change=us_num_top12015-us_num_top11980

gen sh_change=change/(us_change)

gen xsh_top1=sh_top12015-sh_top11980

*gsort -change
*edit
gsort -sh_top12015
edit naics2 sh_top12015 earn_res*
aorder
order naics2
outsheet using Change_1980_2015_by_naics2.csv, c replace

