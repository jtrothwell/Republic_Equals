***THIS STATA DO FILE REPLICATES THE ANALYSIS IN paper & book
Rothwell, Jonathan "Classroom Inequality and the Cognitive Race Gap: Evidence from 4-Year Olds in Public PreK"
Rothwell, Jonathan. Republic of Equals: How to Create a Just Society (Princeton University Press, 2019)

**FIRST STEP IS TO GET DATA FROM HERE or ICPSR

**DATA SOURCE: Early, Diane, Margaret Burchinal, Oscar Barbarin, Donna Bryant, Florence Chang, Richard Clifford, Gisele Crawford, Wanda Weaver, Carollee Howes, Sharon Ritchie, Marcia Kraft-Sayre, Robert Pianta, and W. Steven Barnett. Pre-Kindergarten in Eleven States: NCEDL's Multi-State Study of Pre-Kindergarten and Study of State-Wide Early Education Programs (SWEEP). ICPSR34877-v1. Ann Arbor, MI: Inter-university Consortium for Political and Social Research [distributor], 2013-10-02. http://doi.org/10.3886/ICPSR34877.v1

**SECOND STEP IS TO SET DIRECTORY TO FOLDER WITH DATA FILES THEN RUN THIS FILE
cd "YOUR PREFERRED DIRECTORY"

**MERGE student data with class data**
set more off
use "ChildData.dta", clear
do  "ChildRecode.do"
merge m:1 ICPSR_CLASS_ID STATE STUDY using  "ClassData.dta"
do  CLassRecode.do"
drop if _merge==2
drop _merge

*************
**Prepare variables***
*************

**Test measures
gen xletter_eng=LETTEREPS-LETTEREPF
gen xnumber_eng=NUMBEREPS-NUMBEREPF
gen XWJ10=WJ10_SSEPS-WJ10_SSEPF
gen XOWL=OWLSEPS-OWLSEPF
gen XPPV=PPVTEPS-PPVTEPF
gen Xcount=HICNTCOREPS-HICNTCOREPF
gen xcolor=COLOREPS-COLOREPF

**Previous education environment
gen HeadSt=1 if CCARRP_2==1
replace HeadSt=0 if CCARRP_2==0
gen Home=1 if CCARRP_9==1
replace Home=0 if CCARRP_9==0
gen PreK=1 if CCARRP_1==1 | CCARRP_3==1 | CCARRP_4==1
replace PreK=0 if CCARRP_1==0 & CCARRP_3==0 & CCARRP_4==0

*********
*******Student family background
******
gen poor=1 if POORP==1
replace poor=0 if POORP==0
gen yes_father=1 if CHLIVEP_5 ==1
replace yes_father=0 if CHLIVEP_5==0
gen step_father=1 if CHLIVEP_6==1 | CHLIVEP_8==1
replace step_father=0 if CHLIVEP_6==0 & CHLIVEP_8==0
gen grandparents=1 if CHLIVEP_3==1 | CHLIVEP_7==1
replace grandparents=0 if CHLIVEP_3==0 & CHLIVEP_7==0

**income maxes out at $85K
gen lnCHINCOMCP=ln(CHINCOMCP)
gen male=1 if CHGENP==1
replace male=0 if CHGENP==2
gen sweep=1 if STUDY==2
replace sweep=0 if STUDY==1

gen Black=1 if CHRACEP==2
gen Latino=1 if CHRACEP==1
gen Native=1 if CHRACEP==3
gen White=1 if CHRACEP==5
gen Asian=1 if CHRACEP==4
gen Mixed=1 if CHRACEP==6
mvencode Black-Mixed, mv(0)

gen LessHS=1 if CHMATEDCP <=2
gen HS=1 if CHMATEDCP==3 
gen PostSec=1 if CHMATEDCP>=4 &  CHMATEDCP<=6
gen BA=1 if CHMATEDCP==7
gen GRAD=1 if CHMATEDCP>=8
mvencode LessHS-GRAD, mv(0)

**Replace English scores with Spanish if English is missing
replace HICNTCOREPF=HICNTCORSPF if HICNTCOREPF==.
replace HICNTCOREPS=HICNTCORSPS if HICNTCOREPS==.
replace NUMBEREPF=NUMBERSPF if NUMBEREPF==.
replace NUMBEREPS=NUMBERSPS if NUMBEREPS==.
replace LETTEREPF=LETTERSPF if LETTEREPF==.
replace LETTEREPS=LETTERSPS if LETTEREPS==.
replace COLOREPF=COLORSPF if COLOREPF==.
replace COLOREPS=COLORSPS if COLOREPS==.

foreach x in HICNTCOREPF NUMBEREPF LETTEREPF COLOREPF  WJ10_SSEPF   OWLSEPF  PPVTEPF HICNTCOREPS NUMBEREPS LETTEREPS COLOREPS  WJ10_SSEPS   OWLSEPS PPVTEPS   {
egen Z`x'=std(`x')
}
egen IQF=rowmean(ZHICNTCOREPF-ZPPVTEPF)
egen IQS=rowmean(ZHICNTCOREPS-ZPPVTEPS)
gen XIQ=IQS-IQF

**Factor analysis for scores
factor ZHICNTCOREPF-ZPPVTEPF
predict Fall_Score
factor ZHICNTCOREPS-ZPPVTEPS
predict Spring_Score
gen XScore=Spring_Score-Fall_Score
egen ZSpring_Score=std(Spring_Score)
egen ZFall_Score=std(Fall_Score)
cor Spring_Score IQS
cor Fall_Score IQF

duplicates drop ICPSR_CLASS_ID ICPSR_STUDY_ID, force
sort ICPSR_CLASS_ID TEACH_ID
by ICPSR_CLASS_ID TEACH_ID : egen Obs_Class=count(ICPSR_STUDY_ID)
sum Obs_Class if CLASTOTP!=.
sum Obs_Class if Spring_Score!=. & Fall_Score!=. [aw=CLASS_WT]
sum Obs_Class if T_CHNGCP==1
sum Obs_Class if T_CHNGCP==0

*******
***CLASS DATA********
******

*Teacher/classroom qualities
egen ZCLAS=std(CLASTOTP)
egen ZBELIEF=std(T_BELIEFP)
egen ZT_IDEAP=std(T_IDEAP)
gen T_SubBA=1 if T_EDUCP<=4 
gen T_BA=1 if T_EDUCP==5 | T_EDUCP==6
gen T_GRAD=1 if T_EDUCP>=7
mvencode T_SubBA T_BA T_GRAD, mv(0)

gen EXP2=EXPTOTP ^2
gen EXP3=EXPTOTP ^3
gen lnexper=ln(EXPTOTP)
egen ZlnCHINCOMCP=std(lnCHINCOMCP)
gen teacher_exp5_15=1 if EXPTOTP>=5 & EXPTOTP<=15
replace teacher_exp5_15=0 if EXPTOTP<5 | EXPTOTP>15
gen teacher_exp15_25=1 if EXPTOTP>=15 & EXPTOTP<=25
replace teacher_exp15_25=0 if EXPTOTP<15 | EXPTOTP>25
gen teacher_exp_over30=1 if EXPTOTP>=30
replace teacher_exp_over30=0 if EXPTOTP<30 
gen teacher_exp_over35=1 if EXPTOTP>=35
replace teacher_exp_over35=0 if EXPTOTP<35
gen teacher_exp_over20=1 if EXPTOTP>=20
replace teacher_exp_over20=0 if EXPTOTP<20 
gen teacher_exp_over25=1 if EXPTOTP>=25
replace teacher_exp_over25=0 if EXPTOTP<25 
replace  teacher_exp_over25=. if EXPTOTP==.
gen teacher_exp_under5=1 if EXPTOTP<5
replace teacher_exp_under5=0 if EXPTOTP>=5 
replace  teacher_exp_under5=. if EXPTOTP==.

gen age2=T_AGEP^2

foreach x in HTCOMPPS HTPSSKPS HTTKORPS HTLNPRPS EXPTOTP teacher_exp_under5 teacher_exp_over35 HOURSWKP_IMP  CALC_WAGEP_IMP T_BA T_GRAD PARVISP  PPLANHRP T_CHNG PARCOOPP  RATIOESP {
egen Z`x'=std(`x')
}

gen T_Q=ZBELIEF +ZCLAS
gen xPPVREPF=PPVREPS-PPVREPF
gen xWJ10_WEPF=WJ10_WEPS-WJ10_WEPF

save "PreK4_Achievement_Data.dta", replace

*********
*******FINDINGS****
******
use "PreK4_Achievement_Data.dta", clear

gen XHTLNPRP=HTLNPRPS-HTLNPRPF

**Note: Raw Scores used to assess absolute learning gains

**Test score changes for average student, spring weights
sum PPVTEPF OWLSEPF WJ10_SSEPF WJ10_WEPF PPVREPF LETTEREPF  NUMBEREPF COLOREPF HICNTCOREPF HTLNPRPF [aw=CHILD_WTPF]
sum PPVTEPS OWLSEPS WJ10_SSEPS WJ10_WEPF PPVREPF LETTEREPS  NUMBEREPS COLOREPS HICNTCOREPS HTLNPRPF [aw=CHILD_WTPS]
sum XWJ10 XOWL XPPV xWJ10_WEPF XHTLNPRP xPPVREPF xletter_eng xnumber_eng xcolor Xcount [aw=CHILD_WTPS]
di 9.97/18.76111 
sort CHRACEP
by CHRACEP: sum XWJ10 XOWL XPPV xWJ10_WEPF XHTLNPRP xPPVREPF xletter_eng xnumber_eng xcolor Xcount [aw=CHILD_WTPS]

**Test score changes by race
set more off
areg XScore Black Latino Asian Mixed Native CHFLANGP_1 ASMTAGEPF  male   [aw=CHILD_WTPS], ab(STATE)
areg XScore Black Latino White Mixed Native CHFLANGP_1 ASMTAGEPF  male   [aw=CHILD_WTPS], ab(STATE)

sum XScore if Black==1 & ZCLAS>1 [aw=CLASS_WT]
sum XScore if Black==1 & ZCLAS>0 [aw=CLASS_WT]
sum XScore if Black==1 & ZCLAS<0 [aw=CLASS_WT]
sum XScore if Black==1 & ZCLAS<-1 [aw=CLASS_WT]
sum XScore if White==1 & ZCLAS>0 [aw=CLASS_WT]
sum XScore if White==1 & ZCLAS<0 [aw=CLASS_WT]


***BOOK Finding: Change in test scores by quality of classroom
use "PreK4_Achievement_Data.dta", clear
gen xZHTCNPRPS=ZHTCNPRPS-ZHTCNPRPF
gen XHTLNPRP=HTLNPRPS-HTLNPRPF
xtile TQ4=T_Q, nq(4)
xtile CLAS4=ZCLAS, nq(4)
bysort TQ4: sum xPPVIQ XWJ10 XIQ [aw=CHILD_WTPS]
*Change in test scores by quality of teaching
bysort CLAS4: sum xPPVIQ XWJ10 XIQ XPPV Xcount xletter  PPVTEPS PPVTEPF IQS IQF if Black==1 [aw=CHILD_WTPS]
bysort CLAS4: sum xPPVIQ XWJ10 XIQ XPPV Xcount xletter  PPVTEPS PPVTEPF IQS IQF if  White==1 [aw=CHILD_WTPS]
bysort CLAS4: sum xPPVIQ XWJ10 XIQ XPPV Xcount xletter  PPVTEPS PPVTEPF IQS IQF if  Latino==1 [aw=CHILD_WTPS]

**Number of Asian students too small to be reliable
bysort CLAS4: sum xPPVIQ XWJ10 XIQ XPPV Xcount xletter  PPVTEPS PPVTEPF IQS IQF if  Asian==1 [aw=CHILD_WTPS]

****RAW change in scores by race
sum WJ21AEPF PPVREPF WJ21AEPS PPVREPS
foreach x in WJ21AEPF PPVREPF {
egen sd_`x'=sd(`x')
egen u_`x'=mean(`x')
gen IQ_`x'=100+(15*((`x'-u_`x')/sd_`x'))
}

gen xWJ_raw= (WJ21AEPS-WJ21AEPF)/sd_WJ21AEPF
gen xPPV_raw= (PPVREPS-PPVREPF)/sd_PPVREPF

sum xPPV_raw xWJ_raw WJ21AEPS WJ21AEPF xletter_eng xnumber_eng Xcount xcolor [aw=CHILD_WTPS]
sum xPPV_raw xWJ_raw WJ21AEPS WJ21AEPF xletter_eng xnumber_eng Xcount xcolor if Black==1 [aw=CHILD_WTPS]
sum xPPV_raw xWJ_raw WJ21AEPS WJ21AEPF xletter_eng xnumber_eng Xcount xcolor if  White==1 [aw=CHILD_WTPS]
sum xPPV_raw xWJ_raw xletter_eng xnumber_eng Xcount xcolor if  Latino==1 [aw=CHILD_WTPS]
sum xPPV_raw xWJ_raw xletter_eng xnumber_eng Xcount xcolor if  Asian==1 [aw=CHILD_WTPS]

cor LETTEREPF NUMBEREPF COLOREPF HICNTCOREPF WJ10_SSEPF OWLSEPF PPVTEPF
cor LETTEREPS NUMBEREPS COLOREPS HICNTCOREPS WJ10_SSEPS OWLSEPS PPVTEPS

bysort CLAS4: sum xPPV_raw xWJ_raw if Black==1 [aw=CHILD_WTPS]
bysort CLAS4: sum xPPV_raw xWJ_raw if  White==1 [aw=CHILD_WTPS]
bysort CLAS4: sum xPPV_raw xWJ_raw if  Latino==1 [aw=CHILD_WTPS]
bysort CLAS4: sum xPPV_raw xWJ_raw if  Asian==1 [aw=CHILD_WTPS]


**Summary data uses FALL Weight
use "PreK4_Achievement_Data.dta", clear

collapse (first) Obs_Class (rawsum) Children=CHILD_WTPF (mean) ZSpring_Score ZFall_Score Spring_Score Fall_Score ///
ZHICNTCOREPF ZNUMBEREPF ZLETTEREPF ZCOLOREPF ZWJ10_SSEPF ZOWLSEPF ZPPVTEPF ///
ZBELIEF ZCLAS  ZT_IDEAP  ZEXPTOTP Zteacher_exp_under5 Zteacher_exp_over35 EXPTOTP teacher_exp_under5 teacher_exp_over35 ///
CHABSENTP Black Latino Asian Mixed Native CHFLANGP_1 ASMTAGEPF  male POORP lnCHINCOMCP GRAD BA PostSec LessHS yes_father HeadSt Home PreK ZHTCOMPPS ZHTPSSKPS ZHTTKORPS ZHTLNPRPS ///
HOURSWKP HOURSWKP_IMP  CALC_WAGEP  CALC_WAGEP_IMP T_BA T_GRAD PARVISP  PPLANHRP T_CHNG PARCOOPP  RATIOESP  [aw=CHILD_WTPF], by(CHRACEP)
outsheet using "Results\Summary Teacher Quality by Race--Fall weight.csv", c replace

use "PreK4_Achievement_Data.dta", clear

**Summary data uses Spring Weight
collapse (first) Obs_Class (rawsum) Children=CHILD_WTPF (mean) ZSpring_Score ZFall_Score Spring_Score Fall_Score ZBELIEF ZCLAS  ZT_IDEAP  ZEXPTOTP Zteacher_exp_under5 Zteacher_exp_over35 EXPTOTP teacher_exp_under5 teacher_exp_over35 ///
ZHICNTCOREPS ZNUMBEREPS ZLETTEREPS ZCOLOREPS ZWJ10_SSEPS ZOWLSEPS ZPPVTEPS ///
CHABSENTP Black Latino Asian Mixed Native CHFLANGP_1 ASMTAGEPF  male POORP lnCHINCOMCP GRAD BA PostSec LessHS yes_father HeadSt Home PreK ZHTCOMPPS ZHTPSSKPS ZHTTKORPS ZHTLNPRPS ///
HOURSWKP HOURSWKP_IMP  CALC_WAGEP  CALC_WAGEP_IMP T_BA T_GRAD PARVISP  PPLANHRP T_CHNG PARCOOPP  RATIOESP  [aw=CHILD_WTPF], by(CHRACEP)
outsheet using "Results\Summary Teacher Quality by Race--Spring weight.csv", c replace

use "PreK4_Achievement_Data.dta", clear

**Summary data uses Classroom Weight
collapse (first) Obs_Class (rawsum) Children=CHILD_WTPF (mean) ZSpring_Score ZFall_Score Spring_Score Fall_Score ZBELIEF ZCLAS  ZT_IDEAP  ZEXPTOTP Zteacher_exp_under5 Zteacher_exp_over35 EXPTOTP teacher_exp_under5 teacher_exp_over35 ///
CHABSENTP Black Latino Asian Mixed Native CHFLANGP_1 ASMTAGEPF  male POORP lnCHINCOMCP GRAD BA PostSec LessHS yes_father HeadSt Home PreK ZHTCOMPPS ZHTPSSKPS ZHTTKORPS ZHTLNPRPS ///
HOURSWKP HOURSWKP_IMP  CALC_WAGEP  CALC_WAGEP_IMP T_BA T_GRAD PARVISP  PPLANHRP T_CHNG PARCOOPP  RATIOESP  [aw=CHILD_WTPF], by(CHRACEP)
outsheet using "Results\Summary Teacher Quality by Race--Class weight.csv", c replace

*******
****Basic Race gaps***
******
use "PreK4_Achievement_Data.dta", clear

areg ZFall_Score ///
Black Latino Asian Mixed Native ASMTAGEPF  male CHFLANGP_1 [aw=CHILD_WTPF], ab(STATE) cl(ICPSR_CLASS_ID)
outreg2 using "Results\Regression--Predict Fall Scores.xls", excel adjr2 replace

areg ZFall_Score ///
Black Latino Asian Mixed Native ASMTAGEPF  male CHFLANGP_1   lnCHINCOMCP GRAD BA PostSec LessHS yes_father  [aw=CHILD_WTPF], ab(STATE)   cl(ICPSR_CLASS_ID)
outreg2 using "Results\Regression--Predict Fall Scores.xls", excel adjr2

areg ZSpring_Score ///
Black Latino Asian Mixed Native ASMTAGEPF  male  CHFLANGP_1   [aw=CHILD_WTPS], ab(STATE) cl(ICPSR_CLASS_ID)
outreg2 using "Results\Regression--Predict Fall Scores.xls", excel adjr2

areg ZSpring_Score ///
Black Latino Asian Mixed Native ASMTAGEPF  male  CHFLANGP_1  lnCHINCOMCP GRAD BA PostSec LessHS yes_father  [aw=CHILD_WTPS], ab(STATE)  cl(ICPSR_CLASS_ID)
outreg2 using "Results\Regression--Predict Fall Scores.xls", excel adjr2


************
****TEACHER VALUE-ADDED***
********
use "PreK4_Achievement_Data.dta", clear

set more off
areg ZSpring_Score ZFall_Score  Black Latino Asian Mixed Native  [aw=CLASS_WT], ab(STATE) cl(ICPSR_CLASS_ID)
*outreg2 using Results\Regression--Predict Value Added.xls", excel adjr2 

areg ZSpring_Score ZFall_Score ///
ZBELIEF ZCLAS    [aw=CLASS_WT], ab(STATE) cl(ICPSR_CLASS_ID)
outreg2 using "Results\Regression--Predict Value Added.xls", excel adjr2 replace


areg ZSpring_Score ZFall_Score ///
ZBELIEF ZCLAS   ZEXPTOTP Zteacher_exp_under5 Zteacher_exp_over35  ///
CHABSENTP Black Latino Asian Mixed Native CHFLANGP_1 ASMTAGEPF  male POORP  lnCHINCOMCP GRAD BA PostSec LessHS yes_father HeadSt Home PreK  [aw=CLASS_WT], ab(STATE) cl(ICPSR_CLASS_ID)
outreg2 using "Results\Regression--Predict Value Added.xls", excel adjr2 
foreach varname in ZBELIEF ZCLAS   ZEXPTOTP Zteacher_exp_under5 Zteacher_exp_over35  {
	gen B_`varname'=_b[`varname']*`varname'
}

areg ZSpring_Score ZFall_Score ///
ZBELIEF ZCLAS   ZEXPTOTP Zteacher_exp_under5 Zteacher_exp_over35  ///
CHABSENTP Black Latino Asian Mixed Native CHFLANGP_1 ASMTAGEPF  male POORP lnCHINCOMCP GRAD BA PostSec LessHS yes_father HeadSt Home PreK  ///
HOURSWKP_IMP  CALC_WAGEP_IMP T_BA T_GRAD PARVISP  PPLANHRP T_CHNG PARCOOPP  RATIOESP [aw=CLASS_WT], ab(STATE) cl(ICPSR_CLASS_ID)
outreg2 using "Results\Regression--Predict Value Added.xls", excel adjr2 

foreach varname in ZBELIEF ZCLAS   ZEXPTOTP Zteacher_exp_under5 Zteacher_exp_over35  {
	gen B2_`varname'=_b[`varname']*`varname'
}

areg ZSpring_Score ZFall_Score ///
ZBELIEF ZCLAS   ZEXPTOTP Zteacher_exp_under5 Zteacher_exp_over35  ///
CHABSENTP Black Latino Asian Mixed Native CHFLANGP_1 ASMTAGEPF  male POORP lnCHINCOMCP GRAD BA PostSec LessHS yes_father HeadSt Home PreK  ///
HOURSWKP_IMP  CALC_WAGEP_IMP T_BA T_GRAD PARVISP  PPLANHRP T_CHNG PARCOOPP  RATIOESP ZHTPSSKPS ZHTTKORPS ZHTLNPRPS [aw=CLASS_WT], ab(STATE) cl(ICPSR_CLASS_ID)
outreg2 using "Results\Regression--Predict Value Added.xls", excel adjr2 

**ROBUSTNESS TO DIF TESTS
**Value-added
set more off
foreach x in ZHICNTCOREP ZCOLOREP ZLETTEREP ZNUMBEREP ZWJ10_SSEP ZOWLSEP ZPPVTEP  {
areg `x'S `x'F ///
ZBELIEF ZCLAS   ZEXPTOTP Zteacher_exp_under5 Zteacher_exp_over35  ///
CHABSENTP Black Latino Asian Mixed Native CHFLANGP_1 ASMTAGEPF  male POORP lnCHINCOMCP GRAD BA PostSec LessHS yes_father HeadSt Home PreK  ///
HOURSWKP_IMP  CALC_WAGEP_IMP T_BA T_GRAD PARVISP  PPLANHRP T_CHNG PARCOOPP  RATIOESP [aw=CLASS_WT], ab(STATE) cl(ICPSR_CLASS_ID)
outreg2 using "Results\Regression--VA By Exam.xls", excel adjr2 
}

**ROBUSTNESS TO UNMEASURED STUDENT CHARACTERISTICS
areg  ZFall_Score CHABSENTP Black Latino Asian Mixed Native CHFLANGP_1 ASMTAGEPF  male POORP  lnCHINCOMCP GRAD BA PostSec LessHS yes_father HeadSt Home PreK  [aw=CLASS_WT], ab(STATE) cl(ICPSR_CLASS_ID)
predict Measured_Stud_Adv
predict Unmeasured_Stud_Adv, res
cor Unmeasured_Stud_Adv ZBELIEF ZCLAS
reg Unmeasured_Stud_Adv ZBELIEF ZCLAS
reg Unmeasured_Stud_Adv ZCLAS

*Do high quality teachers affect low-scoring students differently?
gen Inter_Adv_Class=Measured_Stud_Adv*ZCLAS
gen Inter_FS_Class=ZFall_Score*ZCLAS
reg ZSpring_Score ZFall_Score Inter_FS_Class ZCLAS
