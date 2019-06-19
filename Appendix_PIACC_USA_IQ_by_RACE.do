usespss "[DIRECTORY]prgushp1_puf.sav" , clear

gen prison=1 if INTLFLAG==0
replace prison=0 if INTLFLAG==1
drop if prison==1

tab REGION_US, gen(region)
tab AGEG5LFSEXT, gen(age_category)
tab URBAN_4CAT, gen(urban)

gen age=(16+(19-16)/2) if AGEG5LFS==1
replace age=(20+(24-20)/2) if AGEG5LFS==2
replace age=(25+(29-25)/2) if AGEG5LFS==3
replace age=(30+(34-30)/2) if AGEG5LFS==4
replace age=(35+(39-35)/2) if AGEG5LFS==5
replace age=(40+(44-40)/2) if AGEG5LFS==6
replace age=(45+(49-45)/2) if AGEG5LFS==7
replace age=(50+(54-50)/2) if AGEG5LFS==8
replace age=(55+(59-55)/2) if AGEG5LFS==9
replace age=(60+(65-60)/2) if AGEG5LFS==10
replace age=(66+(70-66)/2) if AGEG5LFS==11

egen math=rowmean(PVNUM1-PVNUM10)
egen literacy=rowmean(PVLIT1-PVLIT10)
egen tech=rowmean(PVPSL1-PVPSL10)
egen skill=rowmean(math literacy tech)
egen Zskill=std(skill)

foreach x in math literacy tech {
egen Z`x'=std(`x')
}

/*
RACETHN_5CAT
    1 Hispanic
           2 White
           3 Black
           4 Asian/pacific islander
           6 Other race
          .a [9]Not stated or inferr
*/

tab RACETHN_5CAT
gen white=1 if RACETHN_5CAT==2
replace white=0 if RACETHN_5CAT!=2
replace white=. if RACETHN_5CAT>6

gen black=1 if RACETHN_5CAT==3
replace black=0 if RACETHN_5CAT!=3
replace black=. if RACETHN_5CAT>6

gen hispanic=1 if RACETHN_5CAT==1
replace hispanic=0 if RACETHN_5CAT!=1
replace hispanic=. if RACETHN_5CAT>6

gen asian=1 if RACETHN_5CAT==4
replace asian=0 if RACETHN_5CAT!=4
replace asian=. if RACETHN_5CAT>6

gen other=1 if RACETHN_5CAT==6
replace other=0 if RACETHN_5CAT!=6
replace other=. if RACETHN_5CAT>6

gen paid_job=1 if C_Q01A==1
replace paid_job=0 if C_Q01A==2

egen top_earn=max(EARNMTHALLPPPUS_C)
gen top1_300K=1 if EARNMTHALLPPPUS_C>=25000
replace top1_300K=0 if EARNMTHALLPPPUS_C<25000
replace top1_300K=. if EARNMTHALLPPPUS_C>top_earn
sum top1_300

gen lnearn=ln(EARNMTHALLPPP)
egen Zlnearn=std(lnearn)
gen strong_health=1 if I_Q08_T==1 |  I_Q08_T==2
replace strong_health=0 if I_Q08_T!=1 &  I_Q08_T!=2
gen Health=1/I_Q08_T

label list I_Q08 
label list I_Q08_T 

gen age2=age^2
gen age3=age^3

sum D_Q10 
gen work_hours=D_Q10 
gen lnhours=ln(D_Q10 )

gen primary=1 if B_Q01A>=1 & B_Q01A<=4
replace primary=0 if B_Q01A<1 | B_Q01A>4
gen secondary=1 if B_Q01A>=5 & B_Q01A<=7
replace secondary=0 if B_Q01A<5 | B_Q01A>7
gen assoc=1 if B_Q01A>=8 & B_Q01A<=10
replace assoc=0 if B_Q01A<8 | B_Q01A>10
gen ba=1 if B_Q01A==11 | B_Q01A==12
replace ba=0 if B_Q01A!=11 & B_Q01A!=12
gen ma=1 if B_Q01A==13
replace ma=0 if B_Q01A!=13
gen doc=1 if B_Q01A==14
replace doc=0 if B_Q01A!=14
gen for_cred=1 if B_Q01A==15
replace for_cred=0 if B_Q01A!=15
gen BA_or_higher=1 if B_Q01A==16
replace BA_or_higher=0 if B_Q01A!=16
replace BA_or_higher=1 if B_Q01A>=11 & B_Q01A<=14
gen grad_degree=1 if B_Q01A==13 | B_Q01A==14
replace grad_degree=0 if B_Q01A<13

*****
**SOCIAL ADVANTAGE***
******
sum CNT_BRTH

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

gen native_lang_dif=1 if NATIVELANG==0
replace native_lang_dif=0 if NATIVELANG!=0

gen father_for=1 if J_Q07A_T==1
replace father_for=0 if J_Q07A_T!=1
gen mother_for=1 if J_Q06A_T==1
replace mother_for=0 if J_Q06A_T!=1
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

gen father_HighEd=1 if J_Q07B_T==3
replace father_HighEd=0 if J_Q07B_T!=3
gen father_MidEd=1 if J_Q07B_T==2
replace father_MidEd=0 if J_Q07B_T!=2
gen father_LowEd=1 if J_Q07B_T==1
replace father_LowEd=0 if J_Q07B_T!=1

gen mother_HighEd=1 if J_Q06B_T==3
replace mother_HighEd=0 if J_Q06B_T!=3
gen mother_MidEd=1 if J_Q06B_T==2
replace mother_MidEd=0 if J_Q06B_T!=2
gen mother_LowEd=1 if J_Q06B_T==1
replace mother_LowEd=0 if J_Q06B_T!=1


gen Age_in_Country=J_Q04C1
replace  Age_in_Country=0 if J_Q04C1>=96

gen arrive_before10=1 if J_Q04C1<=2
replace arrive_before10=0 if J_Q04C1>2
replace arrive_before10=. if J_Q04C1>9
replace arrive_before10=. if J_Q04C1==.

tab J_Q04C1, gen (age_arrive)

gen born_here=1 if J_Q04A==1
replace born_here=0 if J_Q04A!=1

foreach x in Zskill {
bysort AGEG5LFS: egen m`x'Z=mean(`x') if white==1 
bysort AGEG5LFS: egen SD`x'Z=sd(`x') if  white==1
bysort AGEG5LFS: egen m`x'=max(m`x'Z) 
bysort AGEG5LFS: egen SD`x'=max(SD`x'Z)
drop SD`x'Z m`x'Z
gen z`x'=(`x'-m`x')/SD`x'
gen `x'100=(100)+(15*z`x')
}
gen IQ=Zskill100
sum IQ if white==1
sum IQ if white==1 [aw=SPFWT0]


destring I_Q04B I_Q04D I_Q04H I_Q04J I_Q04L I_Q04M I_Q05F I_Q06A I_Q07A I_Q07B, replace ignore("V" "R" "D" "N")
egen open_learn=rowmean(I_Q04B-I_Q04M)
egen trust=rowmean(I_Q07A I_Q07B)
gen new_idea=I_Q04B
gen like_learn=I_Q04D

reg  IQ age age2 age3  parent_col ///
black hispanic asian other male  region2 region3 region4 urban2 urban3 urban4  paid_job [aw=SPFWT0] 
outreg2 using "[DIRECTORY]Predict_IQ_by_race.xls" , excel adjr2 replace
reg  IQ age age2 age3  parent_col ///
black hispanic asian other male  region2 region3 region4 urban2 urban3 urban4  paid_job [aw=SPFWT0] 
outreg2 using "[DIRECTORY]Predict_IQ_by_race.xls" , excel adjr2 
reg  IQ age age2 age3   ///
black hispanic asian other male  [aw=SPFWT0] 
outreg2 using "[DIRECTORY]Predict_IQ_by_race.xls" , excel adjr2 
areg  IQ black hispanic asian other male  [aw=SPFWT0] , ab(age)
outreg2 using "[DIRECTORY]Predict_IQ_by_race.xls" , excel adjr2 

reg lnearn IQ age age2 age3  parent_col ///
black hispanic asian other male  region2 region3 region4 urban2 urban3 urban4  paid_job [aw=SPFWT0] 
outreg2 using "[DIRECTORY]Regress Earnings on IQ with noncog skills.xls" , excel adjr2 replace

reg lnearn IQ open_learn trust new_idea like_learn ///
 age age2 age3  parent_col ///
black hispanic asian other male  region2 region3 region4 urban2 urban3 urban4  paid_job [aw=SPFWT0] 
outreg2 using "[DIRECTORY]Regress Earnings on IQ with noncog skills.xls" , excel adjr2 

reg lnearn IQ open_learn trust new_idea like_learn ///
age age2 age3   ///
region2 region3 region4 urban2 urban3 urban4  ///
black hispanic asian other male  [aw=SPFWT0] 
outreg2 using "[DIRECTORY]Regress Earnings on IQ with noncog skills.xls" , excel adjr2 

reg IQ open_learn trust new_idea like_learn ///
 age age2 age3  parent_col ///
black hispanic asian other male  region2 region3 region4 urban2 urban3 urban4  paid_job [aw=SPFWT0] 

reg trust  ///
 age age2 age3  parent_col ///
black hispanic asian other male  region2 region3 region4 urban2 urban3 urban4  paid_job [aw=SPFWT0] 

reg new_idea  ///
 age age2 age3  parent_col ///
black hispanic asian other male  region2 region3 region4 urban2 urban3 urban4  paid_job [aw=SPFWT0] 


**REGRESSIONS
bysort RACETHN_5CAT: sum Zskill Zmath Zliteracy Ztech [aw=SPFWT0]
bysort RACETHN_5CAT REGION_US: sum Zskill Zmath Zliteracy Ztech [aw=SPFWT0]
bysort RACETHN_5CAT: sum IQ Zskill [aw=SPFWT0]
bysort RACETHN_5CAT AGEG5LFS: sum IQ [aw=SPFWT0]
bysort RACETHN_5CAT: sum IQ Zskill Zmath [aw=SPFWT0]
sum IQ Zmath Zliteracy Ztech if male==0 [aw=SPFWT0]
sum IQ Zmath Zliteracy Ztech if male==1 [aw=SPFWT0]
sum IQ Zmath Zliteracy Ztech if male==0 & work_hours>40 [aw=SPFWT0]
sum IQ Zmath Zliteracy Ztech if male==1 & work_hours>40 [aw=SPFWT0]

**Regress IQ on race
reg IQ  black hispanic asian other male born_here  native_lang_dif   [aw=SPFWT0]
outreg2 using "[DIRECTORY]Regress IQ on Race.xls" , excel adjr2 replace
*Regional differences
reg IQ  black hispanic asian other male born_here  native_lang_dif  region2 region3 region4 urban2 urban3 urban4  [aw=SPFWT0]
outreg2 using "[DIRECTORY]Regress IQ on Race.xls" , excel adjr2 
*control for parental ed
reg IQ  black hispanic asian other male born_here  native_lang_dif  region2 region3 region4 urban2 urban3 urban4 ///
father_MidEd father_LowEd mother_MidEd mother_LowEd books25 books75 books150 books350  [aw=SPFWT0]
outreg2 using "[DIRECTORY]Regress IQ on Race.xls" , excel adjr2 
*control for parental ed
reg IQ  black hispanic asian other male born_here  native_lang_dif  region2 region3 region4 urban2 urban3 urban4 ///
father_MidEd father_LowEd mother_MidEd mother_LowEd books25 books75 books150 books350 ///
Age_in_Country [aw=SPFWT0]
outreg2 using "[DIRECTORY]Regress IQ on Race.xls" , excel adjr2 
**IQ benefit of arriving
reg IQ  black hispanic asian other male   native_lang_dif  region2 region3 region4 urban2 urban3 urban4 ///
father_MidEd father_LowEd mother_MidEd mother_LowEd books25 books75 books150 books350 ///
age_arrive2 age_arrive3 age_arrive4 age_arrive5 age_arrive6 age_arrive7 age_arrive8 age_arrive9 if arrive_before10!=. [aw=SPFWT0]
outreg2 using "[DIRECTORY]Regress IQ on Race.xls" , excel adjr2 

reg lnearn IQ age age2 age3  parent_col ///
black hispanic asian other male  region2 region3 region4 urban2 urban3 urban4  paid_job [aw=SPFWT0] 
outreg2 using "[DIRECTORY]Regress Earnings on IQ.xls" , excel adjr2 replace
open_learn trust new_idea like_learn

reg lnearn IQ primary  assoc BA_or_higher age age2 age3 ///
black hispanic asian other male born_here  native_lang_dif  region2 region3 region4 urban2 urban3 urban4 paid_job  [aw=SPFWT0]
outreg2 using "[DIRECTORY]Regress Earnings on IQ.xls" , excel adjr2

reg lnearn IQ primary  assoc BA_or_higher age age2 age3 ///
black hispanic asian other male born_here  native_lang_dif  region2 region3 region4 urban2 urban3 urban4 ///
if paid_job==1  [aw=SPFWT0]
outreg2 using "[DIRECTORY]Regress Earnings on IQ.xls" , excel adjr2

reg lnearn IQ primary  assoc BA_or_higher age age2 age3 ///
black hispanic asian other male born_here  native_lang_dif  region2 region3 region4 urban2 urban3 urban4 ///
parent_col if paid_job==1  [aw=SPFWT0]
outreg2 using "[DIRECTORY]Regress Earnings on IQ.xls" , excel adjr2


tab ISCO08_C
rename ISCO08_C, lower
ren isco08_cus_c isco08_c
destring isco08_c, replace
merge m:1 isco08_c using "[DIRECTORY]Methods\isco08_titles.dta"
drop _merge

destring ISCO2C, replace
merge m:1 ISCO2C using "[DIRECTORY]Methods\OECD Occ Labels.dta"
drop _merge

collapse (count) N=IQ (first) isco08_c (mean) extra_earn extra_earn2 male black white hispanic asian lnearn income IQ Zskill Zmath Zliteracy Ztech top1 (p50) med_res=extra_earn med_res2=extra_earn2 med_inc=income  [aw=SPFWT0] ,by(isco08_c_title)
gsort -extra_earn
edit if N>=20
gsort -med_res
edit
outsheet using "[DIRECTORY]Occupational Rent USA.csv" , c replace

collapse (count) N=IQ (first) isco08_c (mean) extra_earn extra_earn2 male black white hispanic asian lnearn income IQ Zskill Zmath Zliteracy Ztech top1 (p50) med_res=extra_earn med_res2=extra_earn2 med_inc=income  [aw=SPFWT0] ,by(occ_title)
gsort -extra_earn
edit if N>=20
gsort -med_res
edit
outsheet using "[DIRECTORY]2-D Occupational Rent USA.csv" , c replace

