*These data are available for purchase from Gallup or free at some university libraries with subscriptions.
use "[DIRECTORY]\World_Poll.dta", clear

label list WP2319 
*Which one of these phrases comes closest to your own feelings about your household’s income these days: living comfortably on present income, getting by on present income, finding it difficult on present income, or finding it very difficult on present income? (WP2319)
gen feeling_income=WP2319 
replace feeling_income=. if WP2319 >4

gen conf=1 if WP139 ==1
replace conf=0 if WP139 ==2
gen approve=1 if WP13125==1
replace approve=0 if WP13125==2

tab feeling_income, gen(inc_dif)
replace WP31 =. if WP31 >3
tab WP31, gen(worse)

*Right now, do you think that economic conditions in the city or area where you live, as a whole, are getting better or getting worse? (WP88)
label list WP88
gen city_getting_worse=1 if WP88==3
replace city_getting_worse=0 if WP88<3

*Right now, do you feel your standard of living is getting better or getting worse? (WP31)
gen getting_worse=1 if WP31==3
replace getting_worse=0 if WP31<3

*Are you satisfied or dissatisfied with your standard of living, all the things you can buy and do? (WP30)
gen sat_living=1 if WP30==1
replace sat_living=0 if WP30==2
gen not_sat_living=1 if WP30==2
replace not_sat_living=0 if WP30==1

foreach x in feeling_income not_sat_living  getting_worse city_getting_worse {
egen z`x'=std(`x')
}

**Create Anxiety variable
egen Anxiety=rowmean(zfeeling_income znot_sat_living  zgetting_worse zcity_getting_worse)

gen yr=YEAR_CALENDAR
keep if yr>=2013
tab yr
drop if yr==2018
*786,721 2013-2017

set more off
gen elementary=1 if wp3117==1
replace elementary=0 if wp3117!=1
gen secondary=1 if wp3117==2
replace secondary=0 if wp3117!=2
gen tertiary=1 if wp3117==3
replace tertiary=0 if wp3117!=3
replace WP16=. if WP16>10
replace WP18=. if WP18>10

gen age=WP1220  
gen age2=WP1220 ^2
gen age3=WP1220 ^3
gen inc=INCOME_1
gen inc_int=income_2
gen lninc=ln(INCOME_1)
gen lninc_int=ln(income_2)
gen male=1 if WP1219==1
replace male=0 if WP1219==2

gen inc_ratio=INCOME_1/INCOME_3
sum inc_ratio

label list EMP_2010
gen employed_FT=1 if EMP_2010==1
replace employed_FT=0 if EMP_2010!=1
gen self_employed_FT=1 if EMP_2010==2
replace self_employed_FT=0 if EMP_2010!=2
gen unemployed=1 if EMP_2010==4
replace unemployed=0 if EMP_2010!=4
gen lab_force=1 if EMP_2010!=6
replace lab_force=0 if EMP_2010==6
gen pt_employ=1 if EMP_2010==3 | EMP_2010==5
replace pt_employ=0 if EMP_2010!=3 & EMP_2010!=5

gen employ=1 if EMP_2010<6
replace employ=0 if EMP_2010==4
replace employ=0 if EMP_2010==6

gen youth=1 if age<=29
replace youth=0 if age>29

gen employFT_any=1 if EMP_2010==1 | EMP_2010==2
replace employFT_any=0 if EMP_2010!=1 & EMP_2010!=2

gen foreign=1 if WP4657==2
replace foreign=0 if WP4657==1


*1=strongly agree; 5=strongly disagree
gen health_near_perf=WP14449
replace health_near_perf=. if WP14449>5
sum health_near_perf

*Do you have any health problems that prevent you from doing any of the things people your age normally can do?
gen health_problems=1 if WP23 ==1
replace health_problems=0 if WP23 ==2

tab yr, gen(year)

**Tag countries by OECD status
gen oecd_name=countrynew
merge m:1 oecd_name using  "G:\World_Poll\People\Jonathan_Rothwell\WP\WP_OECD_country_name.dta"

areg conf Anxiety year1 year2 year3 year4 ///
WP16 INCOME_5  lninc secondary tertiary age age2 age3  male employed_FT self_employed_FT unemployed pt_employ foreign if oecd==1 [aw=wgt], ab(WP5)
outreg2 using "[DIRECTORY]\WorldPoll\Regress Confidence on Anxiety.xls", excel adjr2 replace

areg approve Anxiety year1 year2 year3 year4 ///
WP16 INCOME_5  lninc secondary tertiary age age2 age3  male employed_FT self_employed_FT unemployed pt_employ foreign if oecd==1 [aw=wgt], ab(WP5)
outreg2 using "[DIRECTORY]\WorldPoll\Regress Confidence on Anxiety.xls", excel adjr2
 
