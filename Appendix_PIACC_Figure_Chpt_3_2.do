/*

clear
cd "DIRECTORY\"
set more off

foreach X in chl grc isr ltu nzl sgp svn aut bel can cze deu dnk esp est fin fra gbr irl ita jpn kor nld nor pol rus svk swe usa {
	insheet using Prg`X'p1.csv, clear
	
	foreach v of varlist * {
	local x : variable label `v'
	rename `v' `x'
	}

	destring AGEG5LFS I_Q08_T EARNMTHALLPPP EARNMTHALLDCL AGEG10LFS AGE_R ///
	PVNUM1-PVNUM10 PVLIT1-PVLIT10 PVPSL1-PVPSL1 ///
	B_Q01a CNT_BRTH ///
	J_Q06b_T J_Q07b_T  ///
	J_Q08 J_Q02a J_Q06a_T J_Q07a_T GENDER_R PARED J_Q04c1 J_Q04a NATIVELANG HOMLGRGN ///
	C_Q07_T B_Q01a3, ignore(D R V M N) replace
	
	sum AGEG5LFS I_Q08_T EARNMTHALLPPP EARNMTHALLDCL AGEG10LFS AGE_R ///
	PVNUM1-PVNUM10 PVLIT1-PVLIT10 PVPSL1-PVPSL1 ///
	B_Q01a CNT_BRTH ///
	J_Q06b_T J_Q07b_T  ///
	J_Q08 J_Q02a J_Q06a_T J_Q07a_T GENDER_R PARED J_Q04c1 J_Q04a NATIVELANG HOMLGRGN ///
	C_Q07_T B_Q01a3
	
	save `X'.dta, replace
}
*/

*DOWNLOAD DATA
*International Data: http://www.oecd.org/skills/piaac/publicdataandanalysis/
*USA Data: https://nces.ed.gov/pubsearch/pubsinfo.asp?pubid=2016667REV

use "DIRECTORY\aut.dta", clear
cd "DIRECTORY\"
foreach X in chl grc isr ltu nzl sgp svn bel can cze deu dnk esp est fin fra gbr irl ita jpn kor nld nor pol rus svk swe usa {
	set more off
	append using `X'.dta, force
}


**SKILL
drop AGE_R
ren AGEG5LFS AGE_R
gen age2=AGE_R^2
gen age3=AGE_R^3
gen age4=AGE_R^4

egen math=rowmean(PVNUM1-PVNUM10)
egen literacy=rowmean(PVLIT1-PVLIT10)
egen tech=rowmean(PVPSL1-PVPSL10)
egen skill=rowmean(math literacy tech)
foreach x in math literacy tech skill {
egen Z`x'=std(`x')
}

gen books10_less=1 if J_Q08==1
replace books10_less=0 if J_Q08!=1
gen books25=1 if J_Q08==2
replace books25=0 if J_Q08!=2
gen books75=1 if J_Q08==3
replace books75=0 if J_Q08!=3
gen books150=1 if J_Q08==4
replace books150=0 if J_Q08!=4
gen books350=1 if J_Q08==5
replace books350=0 if J_Q08!=5

gen spouse_partner=1 if J_Q02a==1
replace spouse_partner=0 if J_Q02a!=1

gen native_lang_dif=1 if NATIVELANG==0
replace native_lang_dif=0 if NATIVELANG!=0

gen father_for=1 if J_Q07a_T==1
replace father_for=0 if J_Q07a_T!=1
gen mother_for=1 if J_Q06a_T==1
replace mother_for=0 if J_Q06a_T!=1
gen both_parents_for=1 if father_for==1 & mother_for==1
replace both_parents_for=0 if father_for==0 | mother_for==0

gen male=1 if GENDER_R==1
replace male=0 if GENDER_R==2

gen parent_no_dip=1 if PARED==1
replace parent_no_dip=0 if PARED!=1
gen parent_dip=1 if PARED==2
replace parent_dip=0 if PARED!=2
gen parent_col=1 if PARED==3
replace parent_col=0 if PARED!=3

gen father_HighEd=1 if J_Q07b_T==3
replace father_HighEd=0 if J_Q07b_T!=3
gen father_MidEd=1 if J_Q07b_T==2
replace father_MidEd=0 if J_Q07b_T!=2
gen father_LowEd=1 if J_Q07b_T==1
replace father_LowEd=0 if J_Q07b_T!=1

gen mother_HighEd=1 if J_Q06b_T==3
replace mother_HighEd=0 if J_Q06b_T!=3
gen mother_MidEd=1 if J_Q06b_T==2
replace mother_MidEd=0 if J_Q06b_T!=2
gen mother_LowEd=1 if J_Q06b_T==1
replace mother_LowEd=0 if J_Q06b_T!=1

gen Age_in_Country=J_Q04c1
replace  Age_in_Country=0 if J_Q04c1>=96
gen born_here=1 if J_Q04a==1
replace born_here=0 if J_Q04a!=1

tab AGEG10LFS, gen(age_category)

gen primary=1 if B_Q01a>=1 & B_Q01a<=4
replace primary=0 if B_Q01a<1 | B_Q01a>4
gen secondary=1 if B_Q01a>=5 & B_Q01a<=7
replace secondary=0 if B_Q01a<5 | B_Q01a>7
gen assoc=1 if B_Q01a>=8 & B_Q01a<=10
replace assoc=0 if B_Q01a<8 | B_Q01a>10
gen ba=1 if B_Q01a==11 | B_Q01a==12
replace ba=0 if B_Q01a!=11 & B_Q01a!=12
gen ma=1 if B_Q01a==13
replace ma=0 if B_Q01a!=13
gen doc=1 if B_Q01a==14
replace doc=0 if B_Q01a!=14
gen for_cred=1 if B_Q01a==15
replace for_cred=0 if B_Q01a!=15
gen BA_or_higher=1 if B_Q01a==16
replace BA_or_higher=0 if B_Q01a!=16
replace BA_or_higher=1 if B_Q01a>=11 & B_Q01a<=14
gen grad_degree=1 if B_Q01a==13 | B_Q01a==14
replace grad_degree=0 if B_Q01a<13


*Foreign Education re-code
replace primary=1 if B_Q01a3>=1 & B_Q01a3<=4
replace secondary=1 if B_Q01a3>=5 & B_Q01a3<=7
replace assoc=1 if B_Q01a3>=8 & B_Q01a3<=10
replace BA_or_higher=1 if B_Q01a3>=11 & B_Q01a3<=15

*Country Names--derived from country labels .csv file included in package
merge m:1 CNTRYID using "DIRECTORY\Methods\PIACC_country_code.dta"
drop if _merge!=3
drop _merge

**SKILL DEVELOPMENT
set more off
reg Zskill books10_less books25 books75 books150  ///
father_HighEd father_MidEd ///
mother_HighEd mother_MidEd ///
father_for mother_for both_parents_for ///
male age_category1 age_category2 age_category3 age_category4  born_here  native_lang_dif  [aw=SPFWT0]
gen K_Sch_Quality=_b[_cons]
predict Sch_Quality, res
predict Social_Adv
egen ZSch_Quality=std(Sch_Quality)
egen ZSocial_Adv=std(Social_Adv)

sum EARNMTHALLPPP
gen lnearn=ln(EARNMTHALLPPP)
egen Zlnearn=std(lnearn)

gen health=1 if I_Q08=="5"
replace health=2 if I_Q08=="4"
replace health=3 if I_Q08=="3"
replace health=4 if I_Q08=="2"
replace health=5 if I_Q08=="1"

gen strong_health=1 if I_Q08_T==1 |  I_Q08_T==2
replace strong_health=0 if I_Q08_T!=1 &  I_Q08_T!=2

bysort country_name: egen N_earn=count(EARNMTHALLPPP)
bysort country_name: egen N_health=count(strong_health)

tab country_name if N_earn==0
tab country_name if N_earn==.
tab country_name if N_health==.
tab country_name if N_earn>0

sum EARN* if country_name=="United States"

gen income=12*EARNMTHALLPPP

STOP

areg lnearn Zskill strong_health primary assoc ba grad_degree AGE_R age2 age3 age4 ///
male born_here   native_lang_dif  ZSocial_Adv [aw=SPFWT0], ab(country_name)

areg lnearn  trust new_idea like_learn  [aw=SPFWT0], ab(country_name)

areg lnearn  trust new_idea like_learn Zskill strong_health primary assoc ba grad_degree AGE_R age2 age3 age4 ///
male born_here   native_lang_dif  ZSocial_Adv [aw=SPFWT0], ab(country_name)

areg health trust new_idea like_learn Zskill  primary assoc ba grad_degree AGE_R age2 age3 age4 ///
male born_here   native_lang_dif  ZSocial_Adv [aw=SPFWT0], ab(country_name)

areg strong_health trust new_idea like_learn Zskill  primary assoc ba grad_degree AGE_R age2 age3 age4 ///
male born_here   native_lang_dif  ZSocial_Adv [aw=SPFWT0], ab(country_name)

areg strong_health Zskill [aw=SPFWT0], ab(country_name)
areg strong_health primary assoc ba grad_degree  [aw=SPFWT0], ab(country_name)

tab country_name if lnearn!=.
*23; 78,193

cor lnearn Zskill
areg lnearn Zskill  [aw=SPFWT0], ab(country_name)
areg lnearn Zskill  AGE_R age2 age3 age4 [aw=SPFWT0], ab(country_name)
areg lnearn  AGE_R age2 age3 age4 [aw=SPFWT0], ab(country_name)
areg lnearn  primary assoc ba grad_degree [aw=SPFWT0], ab(country_name)
areg lnearn  ZSocial_Adv  [aw=SPFWT0], ab(country_name)
areg lnearn strong_health  [aw=SPFWT0], ab(country_name)
areg lnearn male  [aw=SPFWT0], ab(country_name)
areg lnearn books10_less books25 books75 books150  ///
father_HighEd father_MidEd ///
mother_HighEd mother_MidEd    [aw=SPFWT0], ab(country_name)
areg lnearn Zskill  books10_less books25 books75 books150  ///
father_HighEd father_MidEd ///
mother_HighEd mother_MidEd    [aw=SPFWT0], ab(country_name)

*areg lnearn Zskill  primary  assoc BA_or_higher AGE_R age2 age3 age4 ///
*male born_here  native_lang_dif  ///
*if (C_Q07_T==1) [aw=SPFWT0], ab(CNTRYID)

areg lnearn Zskill  primary  assoc BA_or_higher AGE_R age2 age3 age4 ///
male if (C_Q07_T==1)  [aw=SPFWT0], ab(CNTRYID)
predict pred_earn
gen pred_earn_level=exp(pred_earn)

areg health Zskill  primary  assoc BA_or_higher AGE_R age2 age3 age4 ///
male    [aw=SPFWT0], ab(CNTRYID)
predict pred_health


**Calcualte Gini for various factors (see text Chpt3/p77 for discussion)
set more off
foreach x in EARNMTHALLDCL health pred_earn pred_earn_level pred_health  Zskill  {
	bysort CNTRYID: egen WMX`x'=max(`x')
	bysort CNTRYID: egen WMN`x'=min(`x')
	gen WRANGE`x'=WMX`x'-WMN`x'
	gen WIND`x'=100*((`x'-WMN`x')/WRANGE`x')
	bysort CNTRYID: egen WP`x'=rank(WIND`x'), field
	bysort CNTRYID: egen WU`x'=mean(WIND`x')
	bysort CNTRYID: egen WN`x'=count(WIND`x')
	bysort CNTRYID: egen WSUM`x'=total(WIND`x'*WP`x')
	gen WFir`x'=(WN`x'+1)/(WN`x'-1)
	gen WSec`x'=(2/(WN`x'*(WN`x'-1)*WU`x'))*(WSUM`x')
	gen WGini`x'=WFir`x'-WSec`x'
}
sum WGini* 


STOP

**Professional earnings premium***

**Note: Analysis was run separately with United States b/c PIACC file on OECD website ///
*did not have detailed earnings data when I downloaded

**Merge in occupational classifications**
merge m:1 ISCO2C using "DIRECTORY\PIACC_MetaData_OECD_Occupation_Categories.dta"
drop _merge

**Create summary category of all professionals (including managers & technicians/associate prof)
**And non-manager professionals.
***Change "prof" variable to exclude managers and technicians/associate prof
gen pro_man=prof
replace prof=0 if manager==1 | technician==1

areg lnearn pro_man Zskill primary assoc ba grad_degree AGE_R age2 age3 age4 ///
male born_here   native_lang_dif  ZSocial_Adv [aw=SPFWT0], ab(country_name)

gen beta_prof=.
gen beta_manager=.
gen beta_pro_man=.
gen beta_tech=.
keep if  (C_Q07_T==1 |  C_Q07_T==2)
keep if lnearn!=.
*Estonia has missing data
drop if country_name=="Estonia"
*drop c_num*
*drop beta_prof
tab country_name, gen(c_num)


forval x=1/22 {
reg lnearn pro_man Zskill primary assoc ba grad_degree AGE_R age2 age3 age4 ///
male born_here   native_lang_dif  ZSocial_Adv [aw=SPFWT0] if c_num`x'==1
replace beta_pro_man=_b[pro_man] if c_num`x'==1
}

forval x=1/22 {
reg lnearn prof technician manager Zskill primary assoc ba grad_degree AGE_R age2 age3 age4 ///
male born_here   native_lang_dif  ZSocial_Adv [aw=SPFWT0] if c_num`x'==1
replace beta_prof=_b[prof] if c_num`x'==1
replace beta_manager=_b[manager] if c_num`x'==1
replace beta_tech=_b[technician] if c_num`x'==1
}

/*
forval x=1/22 {
reg lnearn manager Zskill primary assoc ba grad_degree AGE_R age2 age3 age4 ///
male born_here   native_lang_dif  ZSocial_Adv [aw=SPFWT0] if c_num`x'==1
replace beta_manager=_b[manager] if c_num`x'==1
}

forval x=1/22 {
reg lnearn technician Zskill primary assoc ba grad_degree AGE_R age2 age3 age4 ///
male born_here   native_lang_dif  ZSocial_Adv [aw=SPFWT0] if c_num`x'==1
replace beta_tech=_b[technician] if c_num`x'==1
}
*/

collapse (mean) beta_prof beta_manager beta_pro_man  beta_tech [aw=SPFWT0], by(country_name)
gsort -beta_pro_man
outsheet using "DIRECTORY\Results\Beta_on_Professinoal_by_Country.csv", c replace
