/*
*Country code crosswalk
insheet using "[DIRECTORY]\PIACC\Methods\PIACC_country_code.csv", clear

set obs 31
replace cntryid = 152 in 25
replace country_name = "Chile" in 25
replace cntryid = 300 in 26
replace country_name = "Greece" in 26
replace cntryid = 376 in 27
replace country_name = "Israel" in 27
replace cntryid = 440 in 28
replace country_name = "Lithuania" in 28
replace cntryid = 554 in 29
replace country_name = "New Zealand" in 29
replace cntryid = 702 in 30
replace country_name = "Singapore" in 30
replace cntryid = 705 in 31
replace country_name = "Slovenia" in 31

ren cntryid CNTRYID
save "[DIRECTORY]\PIACC\Methods\PIACC_country_code.dta", replace

clear
cd "[DIRECTORY]\PIACC\"
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

use "[DIRECTORY]\PIACC\aut.dta", clear
cd "[DIRECTORY]\PIACC\"
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

*Country Names
merge m:1 CNTRYID using "[DIRECTORY]\PIACC\Methods\PIACC_country_code.dta"
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

****Use this for 2digit occ
*Create label dictionary from OECD documents
merge m:1 ISCO2C using "[DIRECTORY]\PIACC\Methods\OECD Occ Labels.dta"
drop _merge

areg lnearn Zskill primary assoc ba grad_degree AGE_R age2 age3 age4 ///
male born_here   native_lang_dif  ZSocial_Adv [aw=SPFWT0], ab(country_name)
predict Earn_Res_Occ, res

bysort country_name: egen N_res=count(Earn_Res_Occ)
tab country_name if N_res==0
sum Zskill
tab country_name
*29 countries; 188,168 people

gen earn_decile=EARNMTHALLDCL

gen iq=(Zskill*15)+100

collapse (first)  prof manager technician (count) Obs=Zskill (semean) seskill=Zskill seiq=iq (sd) sd_skill=skill (mean) avg_earn_decile=earn_decile math literacy tech skill iq income Earn_Res Zskill primary  secondary assoc BA_or_higher AGE_R age2 age3 age4  ///
male born_here   native_lang_dif  ZSocial_Adv ///
Zmath Zliteracy Ztech (p50) earn_decile50=earn_decile  med_income= income iq50=Zskill (p25) iq25=Zskill raw25=skill (p75) earn_decile75=earn_decile raw75=skill iq75=Zskill [aw=SPFWT0], by(occ_title)

gen upper_skill=(seskill*2)+Zskill
gen lower_skill=Zskill-(seskill*2)
order Obs occ_title  prof manager technician Obs iq earn_decile50 Earn_Res avg_earn_decile earn_decile75 earn_decile50 income med_income  Zskill iq25 iq75 upper_skill lower_skill  raw75 raw25 skill sd_skill math literacy tech 
gsort -Zskill
format Obs %11.0f
*drop if Obs<100
drop if Obs<20
outsheet using "[DIRECTORY]\PIACC\Results\IQ_by_2D_Occupation_Surplus.csv", c replace


*USE this for detailed occupational categories
rename ISCO08_C, lower
destring isco08_c, replace
merge m:1 isco08_c using "[DIRECTORY]\PIACC\Methods\isco08_titles.dta"
drop _merge

tab country_name if isco08_c_title=="Legal professionals"
tab country_name if isco08_c_title=="Lawyers"
tab country_name if isco08_c_title=="Medical doctors"
tab country_name if isco08_c_title=="Specialist medical practitioners"
tab country_name if isco08_c_title=="Generalist medical practitioners"

gen MD=1 if isco08_c_title=="Medical doctors"
replace MD=1 if isco08_c_title=="Specialist medical practitioners"
replace MD=1 if isco08_c_title=="Generalist medical practitioners"
mvencode MD, mv(0)
tab country_name if MD==1

areg lnearn Zskill primary assoc ba grad_degree AGE_R age2 age3 age4 ///
male born_here   native_lang_dif  ZSocial_Adv [aw=SPFWT0], ab(country_name)
predict Earn_Res_Occ, res

gen iq=(Zskill*15)+100
sum Zskill iq Earn_Res if MD==1 [aw=SPFWT0]

collapse (first) ISIC1C occ_title prof manager technician (count) Obs=Zskill (semean) seskill=Zskill seiq=iq (sd) sd_skill=skill (mean) avg_earn_decile=earn_decile math literacy tech skill iq income Earn_Res Zskill primary  secondary assoc BA_or_higher AGE_R age2 age3 age4 ///
male born_here   native_lang_dif  ZSocial_Adv ///
Zmath Zliteracy Ztech (p50) earn_decile50=earn_decile  med_income= income iq50=Zskill (p25) iq25=Zskill raw25=skill (p75) earn_decile75=earn_decile raw75=skill iq75=Zskill [aw=SPFWT0], by(isco08_c_title)

gen upper_skill=(seskill*2)+Zskill
gen lower_skill=Zskill-(seskill*2)
order Obs isco08_c_title occ_title prof manager technician avg_earn_decile earn_decile75 earn_decile50 income med_income  Zskill iq25 iq75 upper_skill lower_skill Obs Earn_Res iq raw75 raw25 skill sd_skill math literacy tech 
gsort -Zskill
format Obs %11.0f
*drop if Obs<100
drop if Obs<20
outsheet using "[DIRECTORY]\PIACC\Results\IQ_by_Detailed_Occupation_Surplus.csv", c replace

