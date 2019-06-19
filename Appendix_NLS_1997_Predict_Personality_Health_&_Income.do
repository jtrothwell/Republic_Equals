*Download data from NLS Investigator
*use "\explain_personality.dta", clear

gen high=1 if CVC_HIGHEST_DEGREE_EVER==2
replace high=0 if CVC_HIGHEST_DEGREE_EVER!=2
gen assoc=1 if CVC_HIGHEST_DEGREE_EVER==3
replace assoc=0 if CVC_HIGHEST_DEGREE_EVER!=3
gen BA=1 if CVC_HIGHEST_DEGREE_EVER==4
replace BA=0 if CVC_HIGHEST_DEGREE_EVER!=4
gen MA=1 if CVC_HIGHEST_DEGREE_EVER==5
replace MA=0 if CVC_HIGHEST_DEGREE_EVER!=5
gen doc_prof=1 if CVC_HIGHEST_DEGREE_EVER==6 | CVC_HIGHEST_DEGREE_EVER==7
replace doc_prof=0 if CVC_HIGHEST_DEGREE_EVER!=6 & CVC_HIGHEST_DEGREE_EVER!=7


gen health=5 if YHEA_100_2013==1
replace health=4 if YHEA_100_2013==2
replace health=3 if YHEA_100_2013==3
replace health=2 if YHEA_100_2013==4
replace health=1 if YHEA_100_2013==5

gen hard_times=1 if  PC8_090==1
replace hard_times=0 if  PC8_090==0
gen daycare=1 if  PC8_092==1
replace daycare=0 if  PC8_092==0
sum hard_times daycare

replace YINC_11600B_2013=. if YINC_11600B_2013<0
replace YINC_1700_2013=. if YINC_1700_2013<0
gen lninc=ln(YINC_1700_2013)

foreach x in ASVAB_GS_ABILITY_EST_POS ASVAB_AR_ABILITY_EST_POS ASVAB_WK_ABILITY_EST_POS ASVAB_PC_ABILITY_EST_POS ASVAB_NO_ABILITY_EST_POS ASVAB_CS_ABILITY_EST_POS ASVAB_AI_ABILITY_EST_POS ASVAB_SI_ABILITY_EST_POS ASVAB_MK_ABILITY_EST_POS ASVAB_MC_ABILITY_EST_POS ASVAB_EI_ABILITY_EST_POS ASVAB_AO_ABILITY_EST_POS {
replace `x'=. if `x'<0
}

gen male=1 if KEY_SEX==1
replace male=0 if KEY_SEX==2

gen adopted=1 if PC8_057==1
replace adopted=0 if PC8_057!=1


foreach x in  ASVAB_MATH_VERBAL_SCORE_PCT CVC_SAT_MATH_SCORE_2007 CVC_SAT_VERBAL_SCORE_2007 CV_PIAT_PERCENTILE_SCORE_2000 CV_PIAT_PERCENTILE_SCORE_2001 CV_PIAT_PERCENTILE_SCORE_2002 {
replace `x'= . if  `x'<0
}

replace ASVAB_MATH_VERBAL_SCORE_PCT=ASVAB_MATH_VERBAL_SCORE_PCT/1000


egen piat_pct=rowmean(CV_PIAT_PERCENTILE_SCORE*)
sum piat_pct ASVAB_MATH_VERBAL_SCORE_PCT 

gen adopted_birth=1 if YCHR_1458_2002==1 | YCHR_1458_2002==2
replace adopted_birth=0 if YCHR_1458_2002==-4
replace adopted_birth=0 if YCHR_1310_2002==-4
replace adopted_birth=1 if YCHR_1310_2002==1 | YCHR_1310_2002==2
sum adopted_birth

gen catholic=1 if P2_013==1
replace catholic=0 if P2_013!=1
gen other_non_christ=1 if P2_013>=21
replace other_non_christ=0 if P2_013<21
gen muslim=1 if P2_013==21
replace muslim=0 if P2_013!=21
gen jew=1 if P2_013>=14 & P2_013<=17
replace jew=0 if P2_013<14 | P2_013>17
gen mormon=1 if P2_013==18
replace mormon=0 if P2_013!=18
gen hindu_bud=1 if P2_013==22
replace hindu_bud=0 if P2_013!=22
gen atheist=1 if P2_013>=24 & P2_013<=27
replace atheist=0 if P2_013<24 | P2_013>27

gen edu_bio_mom=CV_HGC_BIO_MOM	
gen edu_bio_dad=CV_HGC_BIO_DAD
gen edu_nbio_mom=CV_HGC_RES_MOM	
gen edu_nbio_dad=CV_HGC_RES_DAD
replace edu_bio_mom=. if CV_HGC_BIO_MOM<0 | CV_HGC_BIO_MOM>=95
replace edu_nbio_mom=. if CV_HGC_RES_MOM<0 | CV_HGC_RES_MOM>=95
replace edu_bio_dad=. if CV_HGC_BIO_DAD<0 | CV_HGC_BIO_DAD>=95
replace edu_nbio_dad=. if CV_HGC_RES_DAD<0 | CV_HGC_RES_DAD>=95

gen age=CV_AGE_12_31_96_1997
gen age2=age^2

gen hhinc=CV_INCOME_GROSS_YR_1997
replace hhinc=0 if CV_INCOME_GROSS_YR_1997<0
xtile xhhinc=hhinc, nq(3)
xtile xhhinc2=hhinc, nq(2)

gen exec=1 if YEMP_OCCODE_2002_01_2013>=10 & YEMP_OCCODE_2002_01_2013<=430
replace exec=0 if YEMP_OCCODE_2002_01_2013>=10 & YEMP_OCCODE_2002_01_2013<=430

gen Occ2013="Executives" if YEMP_OCCODE_2002_01_2013>=10 & YEMP_OCCODE_2002_01_2013<=430
replace Occ2013="Non-Executive Managers" if YEMP_OCCODE_2002_01_2013>=500 & YEMP_OCCODE_2002_01_2013<=950
replace Occ2013="Professional Science Related" if YEMP_OCCODE_2002_01_2013>=1000 & YEMP_OCCODE_2002_01_2013<=1240
replace Occ2013="Professional Science Related" if YEMP_OCCODE_2002_01_2013>=1300 & YEMP_OCCODE_2002_01_2013<=1530
replace Occ2013="Professional Science Related" if YEMP_OCCODE_2002_01_2013>=1600 & YEMP_OCCODE_2002_01_2013<=1760
replace Occ2013="Professional Science Related" if YEMP_OCCODE_2002_01_2013>=1800 & YEMP_OCCODE_2002_01_2013<=1860
replace Occ2013="Professional Science Related" if YEMP_OCCODE_2002_01_2013>=1900 & YEMP_OCCODE_2002_01_2013<=1960
replace Occ2013="Skilled technical workers" if YEMP_OCCODE_2002_01_2013>=6200 & YEMP_OCCODE_2002_01_2013<=7750
replace Occ2013="Legal workers" if YEMP_OCCODE_2002_01_2013>=2100 & YEMP_OCCODE_2002_01_2013<=2150
replace Occ2013="Social workers, teachers, and librarians" if YEMP_OCCODE_2002_01_2013>=2200 & YEMP_OCCODE_2002_01_2013<=2550
replace Occ2013="Social workers, teachers, and librarians" if YEMP_OCCODE_2002_01_2013>=2000 & YEMP_OCCODE_2002_01_2013<=2060
replace Occ2013="Healthcare practitioners" if YEMP_OCCODE_2002_01_2013>=3000 & YEMP_OCCODE_2002_01_2013<=3260
replace Occ2013="Entertainment and media" if YEMP_OCCODE_2002_01_2013>=2600 & YEMP_OCCODE_2002_01_2013<=2960
replace Occ2013="Healthcare support" if YEMP_OCCODE_2002_01_2013>=3300 & YEMP_OCCODE_2002_01_2013<=3650
replace Occ2013="Low skilled service" if YEMP_OCCODE_2002_01_2013>=3700 & YEMP_OCCODE_2002_01_2013<=4650
replace Occ2013="Low skilled office and sales" if YEMP_OCCODE_2002_01_2013>=4700 & YEMP_OCCODE_2002_01_2013<=5930
replace Occ2013="Low skilled service" if YEMP_OCCODE_2002_01_2013>=7800 & YEMP_OCCODE_2002_01_2013<=7850
replace Occ2013="Operators and transportation" if YEMP_OCCODE_2002_01_2013>=7900 & YEMP_OCCODE_2002_01_2013<=9750

bysort Occ2013: sum ASVAB_EI_ABILITY_EST_POS ASVAB_AI_ABILITY_EST_POS ASVAB_MC_ABILITY_EST_POS ASVAB_AO_ABILITY_EST_POS
 
gen install=1  if YEMP_OCCODE_2002_01_2013>=7000 & YEMP_OCCODE_2002_01_2013<=7620
replace install=0  if YEMP_OCCODE_2002_01_2013<7000 | YEMP_OCCODE_2002_01_2013>7620
gen construction=1 if YEMP_OCCODE_2002_01_2013>=6200 & YEMP_OCCODE_2002_01_2013<=6940
replace construction=0 if YEMP_OCCODE_2002_01_2013<6200 | YEMP_OCCODE_2002_01_2013>6940
gen prod=1 if YEMP_OCCODE_2002_01_2013>=7700 & YEMP_OCCODE_2002_01_2013<=7750
replace prod=0 if YEMP_OCCODE_2002_01_2013<7700 | YEMP_OCCODE_2002_01_2013>7750

sum ASVAB_EI_ABILITY_EST_POS ASVAB_AI_ABILITY_EST_POS ASVAB_MC_ABILITY_EST_POS ASVAB_AO_ABILITY_EST_POS if install==1
sum ASVAB_EI_ABILITY_EST_POS ASVAB_AI_ABILITY_EST_POS ASVAB_MC_ABILITY_EST_POS ASVAB_AO_ABILITY_EST_POS if construction==1
sum ASVAB_EI_ABILITY_EST_POS ASVAB_AI_ABILITY_EST_POS ASVAB_MC_ABILITY_EST_POS ASVAB_AO_ABILITY_EST_POS if prod==1



gen conscientious=YSAQ_282K_2002
replace conscientious=. if YSAQ_282K_2002<1
gen undependable=YSAQ_282L_2002
replace undependable=. if YSAQ_282L_2002<1
gen thorough=YSAQ_282M_2002
replace thorough=. if YSAQ_282M_2002<1

gen reliable=conscientious-undependable+thorough

gen enthus=YTEL_TIPIA_000001_2008
replace enthus=. if YTEL_TIPIA_000001_2008<1 | YTEL_TIPIA_000001_2008>7
gen critical=YTEL_TIPIA_000002_2008
replace critical=. if YTEL_TIPIA_000002_2008<1 | YTEL_TIPIA_000002_2008>7
gen self_disc=YTEL_TIPIA_000003_2008
replace self_disc=. if YTEL_TIPIA_000003_2008<1 | YTEL_TIPIA_000003_2008>7
gen anxious=YTEL_TIPIA_000004_2008
replace anxious=. if YTEL_TIPIA_000004_2008<1 | YTEL_TIPIA_000004_2008>7
gen open=YTEL_TIPIA_000005_2008
replace open=. if YTEL_TIPIA_000005_2008<1 | YTEL_TIPIA_000005_2008>7

gen big3=enthus+self_disc-anxious
gen big5=enthus+self_disc-critical-anxious+open
gen alt_big3=enthus+self_disc -undependable

gen black=1 if KEY_RACE_ETHNICITY_1997==1
replace black=0 if KEY_RACE_ETHNICITY_1997!=1
gen hisp=1 if KEY_RACE_ETHNICITY_1997==2
replace hisp=0 if KEY_RACE_ETHNICITY_1997!=2
gen multi=1 if KEY_RACE_ETHNICITY_1997==3
replace multi=0 if KEY_RACE_ETHNICITY_1997!=3
gen white=1 if KEY_RACE_1997==1
replace white=0 if KEY_RACE_1997!=1
gen asian=1 if KEY_RACE_1997==4
replace asian=0 if KEY_RACE_1997!=4

gen yrs_edu=CVC_HGC_EVER_XRND
replace yrs_edu=. if CVC_HGC_EVER_XRND>20
replace yrs_edu=. if CVC_HGC_EVER_XRND<0

gen yrs_edu_mom=YCHR_1420_COMB
replace yrs_edu_mom=. if YCHR_1420_COMB>8
replace yrs_edu_mom=. if YCHR_1420_COMB<0

gen yrs_edu_dad=YCHR_1470_COMB
replace yrs_edu_dad=. if YCHR_1470_COMB>8
replace yrs_edu_dad=. if YCHR_1470_COMB<0

replace FP_PPRELIG_1997=. if FP_PPRELIG_1997<0
replace FP_ADHRISKI_1997=. if FP_ADHRISKI_1997<0


foreach x in FP_YMPSTYL FP_YFPSTYL FP_YNRMPSTYL FP_YNRFPSTYL FP_YHROUTIN_1997	FP_YMMONIT_1997	FP_YFMONIT_1997	FP_YNRMMONIT_1997	FP_YNRFMONIT_1997	FP_YHLIMITS_1997 FP_PHLIMITS_1997 {
replace `x'=. if `x'<0
}

egen monitor= rowmean(FP_YMMONIT_1997	FP_YFMONIT_1997	FP_YNRMMONIT_1997	FP_YNRFMONIT_1997)
egen authority=rowmean(FP_YMPSTYL FP_YFPSTYL FP_YNRMPSTYL FP_YNRFPSTYL)
gen mom_authority=FP_YMPSTYL 
replace mom_authority=FP_YNRMPSTYL if mom_authority==.
gen dad_authority=FP_YFPSTYL
replace dad_authority=FP_YNRFPSTYL if dad_authority==.

gen best_parent_style=1 if mom_authority==4 | dad_authority==4
replace best_parent_style=0 if mom_authority!=4 & dad_authority!=4
replace best_parent_style=. if mom_authority==. & dad_authority==.

**STANDARDIZE
foreach x in authority monitor FP_YHROUTIN_1997 FP_PPRELIG_1997 FP_ADHRISKI_1997   undependable alt_big3  big3 reliable enthus self_disc anxious ASVAB_MATH_VERBAL_SCORE_PCT CVC_SAT_MATH_SCORE_2007 CVC_SAT_VERBAL_SCORE_2007 CV_PIAT_PERCENTILE_SCORE_2000 CV_PIAT_PERCENTILE_SCORE_2001 CV_PIAT_PERCENTILE_SCORE_2002 FP_YHLIMITS_1997 ///
ASVAB_GS_ABILITY_EST_POS ASVAB_AR_ABILITY_EST_POS ASVAB_WK_ABILITY_EST_POS ASVAB_PC_ABILITY_EST_POS ASVAB_NO_ABILITY_EST_POS ASVAB_CS_ABILITY_EST_POS ASVAB_AI_ABILITY_EST_POS ASVAB_SI_ABILITY_EST_POS ASVAB_MK_ABILITY_EST_POS ASVAB_MC_ABILITY_EST_POS ASVAB_EI_ABILITY_EST_POS ASVAB_AO_ABILITY_EST_POS {
egen z`x'=std(`x')
}

**Analysis
reg big3 zFP_ADHRISKI_1997 best_parent_style
reg big3 zmonitor
reg big3 best_parent_style

bysort dad_authority: sum big3
bysort mom_authority: sum big3


**Calcualte Gini for various factors
set more off
foreach x in ASVAB_MATH_VERBAL_SCORE_PCT big3 health YINC_1700_2013 {
	egen MX`x'=max(`x')
	egen MN`x'=min(`x')
	gen RANGE`x'=MX`x'-MN`x'
	gen IND`x'=100*((`x'-MN`x')/RANGE`x')
	egen P`x'=rank(IND`x'), field
	egen U`x'=mean(IND`x')
	egen N`x'=count(IND`x')
	egen SUM`x'=total(IND`x'*P`x')
	gen Fir`x'=(N`x'+1)/(N`x'-1)
	gen Sec`x'=(2/(N`x'*(N`x'-1)*U`x'))*(SUM`x')
	gen Gini`x'=Fir`x'-Sec`x'
	drop MX`x' MN`x' RANGE`x' P`x' SUM`x' Fir`x' Sec`x'
}
sum Gini* , sep(0)

egen zlninc=std(lninc)
egen zinc=std(YINC_1700_2013)

**Family/Home Risk Index
bysort KEY_RACE_ETHNICITY_1997: sum ASVAB_MATH_VERBAL_SCORE_PCT  zFP_ADHRISKI_1997 [aw=SAMPLING_WEIGHT_CC_1997]
bysort P2_013: sum ASVAB_MATH_VERBAL_SCORE_PCT zFP_ADHRISKI_1997 if white==1 [aw=SAMPLING_WEIGHT_CC_1997]
bysort KEY_RACE_1997: sum ASVAB_MATH_VERBAL_SCORE_PCT zFP_ADHRISKI_1997 if hisp==0 [aw=SAMPLING_WEIGHT_CC_1997]
sum ASVAB_MATH_VERBAL_SCORE_PCT zFP_ADHRISKI_1997 if jew==1 & white==1 [aw=SAMPLING_WEIGHT_CC_1997]
*
sum ASVAB_MATH_VERBAL_SCORE_PCT zFP_ADHRISKI_1997 if P2_013==1 & white==1 [aw=SAMPLING_WEIGHT_CC_1997]
*Baptist
sum ASVAB_MATH_VERBAL_SCORE_PCT zFP_ADHRISKI_1997 if P2_013==2 & white==1 [aw=SAMPLING_WEIGHT_CC_1997]

bysort KEY_RACE_ETHNICITY_1997:  sum zbig3 zanxious zself_disc zenthus [aw=SAMPLING_WEIGHT_CC_2008]
sum zbig3 zanxious zself_disc zenthus if white==1 & hisp==0 [aw=SAMPLING_WEIGHT_CC_2008]
sum zbig3 zanxious zself_disc zenthus if white==1 & hisp==0 & jew==1 [aw=SAMPLING_WEIGHT_CC_2008]
sum zbig3 zanxious zself_disc zenthus if asian==1 [aw=SAMPLING_WEIGHT_CC_2008]
sum zbig3 zanxious zself_disc zenthus if male==1 [aw=SAMPLING_WEIGHT_CC_2008]
sum zbig3 zanxious zself_disc zenthus if male==0 [aw=SAMPLING_WEIGHT_CC_2008]

*Figure 3.3--Cognitive Ability and Personality by riskiness of home and family environment, expressed in standard deviations with mean of zero
xtile risk5=zFP_ADHRISKI_1997 ,nq(5)
bysort risk5: sum zbig3 zanxious zself_disc zenthus zASVAB_MATH_VERBAL_SCORE_PCT 

egen parent_edu=rowmean(yrs_edu_mom yrs_edu_dad)

cor ASVAB_MATH_VERBAL_SCORE_PCT  big3

*Calculate gaps
foreach x in big3 enthus self_disc anxious ASVAB_MATH_VERBAL_SCORE_PCT ASVAB_GS_ABILITY_EST_POS ASVAB_AR_ABILITY_EST_POS ASVAB_WK_ABILITY_EST_POS ASVAB_PC_ABILITY_EST_POS ASVAB_NO_ABILITY_EST_POS ASVAB_CS_ABILITY_EST_POS ASVAB_AI_ABILITY_EST_POS ASVAB_SI_ABILITY_EST_POS ASVAB_MK_ABILITY_EST_POS ASVAB_MC_ABILITY_EST_POS ASVAB_EI_ABILITY_EST_POS ASVAB_AO_ABILITY_EST_POS {
reg z`x'  black hisp asian multi jew male age
outreg2 using "\Predict_IQ_Gaps.xls", excel adjr2 
}
*Calculate gaps | parental edu
foreach x in ASVAB_MATH_VERBAL_SCORE_PCT ASVAB_GS_ABILITY_EST_POS ASVAB_AR_ABILITY_EST_POS ASVAB_WK_ABILITY_EST_POS ASVAB_PC_ABILITY_EST_POS ASVAB_NO_ABILITY_EST_POS ASVAB_CS_ABILITY_EST_POS ASVAB_AI_ABILITY_EST_POS ASVAB_SI_ABILITY_EST_POS ASVAB_MK_ABILITY_EST_POS ASVAB_MC_ABILITY_EST_POS ASVAB_EI_ABILITY_EST_POS ASVAB_AO_ABILITY_EST_POS {
reg z`x'  black hisp asian multi jew male age yrs_edu_mom yrs_edu_dad
outreg2 using "\Predict_IQ_Gaps_control_parent_Edu.xls", excel adjr2 
}

*TEST GAPS | parental edu | parent style
foreach x in big3 enthus self_disc anxious ASVAB_MATH_VERBAL_SCORE_PCT ASVAB_GS_ABILITY_EST_POS ASVAB_AR_ABILITY_EST_POS ASVAB_WK_ABILITY_EST_POS ASVAB_PC_ABILITY_EST_POS ASVAB_NO_ABILITY_EST_POS ASVAB_CS_ABILITY_EST_POS ASVAB_AI_ABILITY_EST_POS ASVAB_SI_ABILITY_EST_POS ASVAB_MK_ABILITY_EST_POS ASVAB_MC_ABILITY_EST_POS ASVAB_EI_ABILITY_EST_POS ASVAB_AO_ABILITY_EST_POS {
reg z`x'  black hisp asian multi jew male age yrs_edu_mom yrs_edu_dad zFP_ADHRISKI_1997 hard_times 
outreg2 using "\Predict_IQ_Gaps_control_parent_Edu_Style.xls", excel adjr2 
}

*Compare to NLSY 1979 analysis
egen parent_edu=rowmean(yrs_edu_mom yrs_edu_dad)
reg lninc big3 yrs_edu ASVAB_MATH_VERBAL_SCORE_PCT   parent_edu black hisp asian multi jew male age catholic other_non_christ
outreg2 using "\Predict_Income_w_Noncog.xls", excel adjr2 tstat replace
reg health big3 yrs_edu ASVAB_MATH_VERBAL_SCORE_PCT   parent_edu black hisp asian multi jew male age catholic other_non_christ
outreg2 using "\Predict_Income_w_Noncog.xls", excel adjr2 tstat

*Race between IQ vs Military test Performance
reg lninc ASVAB_MATH_VERBAL_SCORE_PCT CV_PIAT_PERCENTILE_SCORE_2000
reg health ASVAB_MATH_VERBAL_SCORE_PCT CV_PIAT_PERCENTILE_SCORE_2000

*Predict Personality
reg big3  yrs_edu_mom yrs_edu_dad black hisp asian multi jew male age
outreg2 using "\Predict_Big3.xls", excel adjr2 replace
reg big3  zFP_YHROUTIN_1997  zFP_ADHRISKI_1997 zmonitor yrs_edu_mom yrs_edu_dad black hisp asian multi jew male age
outreg2 using "\Predict_Big3.xls", excel adjr2 

*predict IQ
reg ASVAB_MATH_VERBAL_SCORE_PCT yrs_edu_mom yrs_edu_dad black hisp asian multi jew male age
outreg2 using "\Predict_Big3.xls", excel adjr2 
reg ASVAB_MATH_VERBAL_SCORE_PCT    zFP_YHROUTIN_1997  zFP_ADHRISKI_1997 zmonitor yrs_edu_mom yrs_edu_dad black hisp asian multi jew male age
outreg2 using "\Predict_Big3.xls", excel adjr2 

*Predict income
reg lninc big3 ASVAB_MATH_VERBAL_SCORE_PCT    yrs_edu_mom yrs_edu_dad black hisp asian multi jew male age
outreg2 using "\Predict_Big3.xls", excel adjr2 
reg lninc big3 ASVAB_MATH_VERBAL_SCORE_PCT    zFP_YHROUTIN_1997  zFP_ADHRISKI_1997 zmonitor yrs_edu_mom yrs_edu_dad black hisp asian multi jew male age
outreg2 using "\Predict_Big3.xls", excel adjr2 

*Predict Educational attainment
reg yrs_edu big3 ASVAB_MATH_VERBAL_SCORE_PCT  yrs_edu_mom yrs_edu_dad black hisp asian multi jew male age
outreg2 using "\Predict_Big3.xls", excel adjr2 
reg yrs_edu big3 ASVAB_MATH_VERBAL_SCORE_PCT    zFP_YHROUTIN_1997  zFP_ADHRISKI_1997 zmonitor yrs_edu_mom yrs_edu_dad black hisp asian multi jew male age
outreg2 using "\Predict_Big3.xls", excel adjr2 

**Nog-cog effect on income robust to non-linear IQ
gen ASVAB_sq=ASVAB_MATH_VERBAL_SCORE_PCT^2
gen ASVAB_cubed=ASVAB_MATH_VERBAL_SCORE_PCT^3
sum ASVAB_MATH_VERBAL_SCORE_PCT
reg lninc big3 ASVAB_MATH_VERBAL_SCORE_PCT ASVAB_sq  yrs_edu_mom yrs_edu_dad black hisp asian multi jew male age
reg lninc big3 ASVAB_MATH_VERBAL_SCORE_PCT ASVAB_sq  ASVAB_cubed  yrs_edu_mom yrs_edu_dad black hisp asian multi jew male age

*Nog-cog effect on income, robust within race
reg lninc big3 ASVAB_MATH_VERBAL_SCORE_PCT    yrs_edu_mom yrs_edu_dad male age if black==1
reg lninc enthus self_disc anxious ASVAB_MATH_VERBAL_SCORE_PCT    yrs_edu_mom yrs_edu_dad male age if black==1
reg big3 black male age

***Analyzing Racial & Ethnic differences****
***Regress IQ on race with or without weights and parental education
reg zASVAB_MATH_VERBAL_SCORE_PCT  black hisp asian multi jew male age 
*omitted group is other white non-hispanic Christian
reg zASVAB_MATH_VERBAL_SCORE_PCT  black hisp asian multi jew male age catholic muslim mormon hindu_bud atheist
reg zASVAB_MATH_VERBAL_SCORE_PCT  black hisp asian multi jew male age catholic muslim mormon hindu_bud atheist yrs_edu_mom yrs_edu_dad
*omitted group is white non-hispanic Christian & atheists
reg zASVAB_MATH_VERBAL_SCORE_PCT  black hisp asian multi jew male age muslim hindu_bud yrs_edu_mom yrs_edu_dad
*omitted group is white non-hispanic Christian & atheists
reg zASVAB_MATH_VERBAL_SCORE_PCT  black hisp asian multi jew male age muslim hindu_bud yrs_edu_mom yrs_edu_dad [aw=SAMPLING_WEIGHT_CC_1999]
reg zASVAB_MATH_VERBAL_SCORE_PCT  black hisp asian multi jew male age yrs_edu_mom yrs_edu_dad
*omitted group is non-Jewish non-Hispanic white
reg zASVAB_MATH_VERBAL_SCORE_PCT  black hisp asian multi jew male age yrs_edu_mom yrs_edu_dad [aw=SAMPLING_WEIGHT_CC_1999]

*Other measures of IQ (with smaller sample sizes) show same result
foreach x in zASVAB_MATH_VERBAL_SCORE_PCT zCVC_SAT_MATH_SCORE_2007 zCVC_SAT_VERBAL_SCORE_2007 zCV_PIAT_PERCENTILE_SCORE_2000 zCV_PIAT_PERCENTILE_SCORE_2001 zCV_PIAT_PERCENTILE_SCORE_2002 {
sum `x'
reg `x'  black hisp asian multi jew male age yrs_edu_mom yrs_edu_dad [aw=SAMPLING_WEIGHT_CC_1999]
}

cor yrs_edu yrs_edu_mom
cor yrs_edu yrs_edu_dad

cor big3 yrs_edu_mom
cor big3 yrs_edu_dad

cor reliable yrs_edu_mom
cor ASVAB_MATH_VERBAL_SCORE_PCT yrs_edu_mom
cor ASVAB_MATH_VERBAL_SCORE_PCT yrs_edu_dad
cor yrs_edu ASVAB_MATH_VERBAL_SCORE_PCT

cor big3 black hisp multi white asian jew 
cor reliable black hisp multi white asian jew 

sum zASVAB_MATH_VERBAL_SCORE_PCT yrs_edu zbig3 zreliable if jew==1
sum zASVAB_MATH_VERBAL_SCORE_PCT yrs_edu zbig3 zreliable if white==1
sum zASVAB_MATH_VERBAL_SCORE_PCT yrs_edu zbig3 zreliable if black==1
sum zASVAB_MATH_VERBAL_SCORE_PCT yrs_edu zbig3 zreliable if hisp==1
sum zASVAB_MATH_VERBAL_SCORE_PCT yrs_edu zbig3 zreliable if asian==1

reg zbig3 yrs_edu_mom black 
reg zbig3 jew
reg zbig3 asian
reg zbig3 black
reg zbig3 black asian jew hisp if white==1 | hisp==1 | jew==1 | black==1 | asian==1 [aw=SAMPLING_WEIGHT_CC_1997]
reg zbig3 male [aw=SAMPLING_WEIGHT_CC_1997]


sum zASVAB_MATH_VERBAL_SCORE_PCT yrs_edu zbig3 zreliable if jew==1 & zASVAB_MATH_VERBAL_SCORE_PCT>=.5 & zASVAB_MATH_VERBAL_SCORE_PCT!=.
sum zASVAB_MATH_VERBAL_SCORE_PCT yrs_edu zbig3 zreliable if white==1 & zASVAB_MATH_VERBAL_SCORE_PCT>=.5 & zASVAB_MATH_VERBAL_SCORE_PCT!=.
sum zASVAB_MATH_VERBAL_SCORE_PCT yrs_edu zbig3 zreliable if black==1 & zASVAB_MATH_VERBAL_SCORE_PCT>=.5 & zASVAB_MATH_VERBAL_SCORE_PCT!=.
sum zASVAB_MATH_VERBAL_SCORE_PCT yrs_edu zbig3 zreliable if hisp==1 & zASVAB_MATH_VERBAL_SCORE_PCT>=.5 & zASVAB_MATH_VERBAL_SCORE_PCT!=.
sum zASVAB_MATH_VERBAL_SCORE_PCT yrs_edu zbig3 zreliable if asian==1 & zASVAB_MATH_VERBAL_SCORE_PCT>=.5 & zASVAB_MATH_VERBAL_SCORE_PCT!=.

cor zASVAB_MATH_VERBAL_SCORE_PCT zbig3 big5 if asian==1
cor zASVAB_MATH_VERBAL_SCORE_PCT zbig3 big5 if black==1
cor zASVAB_MATH_VERBAL_SCORE_PCT zbig3 big5 if white==1

reg zbig3 black asian jew hisp if white==1 | hisp==1 | jew==1 | black==1 | asian==1
reg zbig3 black asian jew hisp if (white==1 | hisp==1 | jew==1 | black==1 | asian==1) & zASVAB_MATH_VERBAL_SCORE_PCT>=.5 & zASVAB_MATH_VERBAL_SCORE_PCT!=.
reg zbig3 black asian jew hisp if white==1 | hisp==1 | jew==1 | black==1 | asian==1
reg big5 black asian jew hisp if (white==1 | hisp==1 | jew==1 | black==1 | asian==1) & zASVAB_MATH_VERBAL_SCORE_PCT>=.5 & zASVAB_MATH_VERBAL_SCORE_PCT!=.
reg enthus black asian jew hisp if white==1 | hisp==1 | jew==1 | black==1 | asian==1
reg self_disc black asian jew hisp if white==1 | hisp==1 | jew==1 | black==1 | asian==1
reg anxious  black asian jew hisp if white==1 | hisp==1 | jew==1 | black==1 | asian==1

cor enthus zASVAB_MATH_VERBAL_SCORE_PCT if asian==1 [aw=SAMPLING_WEIGHT_CC_1997]
cor enthus zASVAB_MATH_VERBAL_SCORE_PCT if black==1 [aw=SAMPLING_WEIGHT_CC_1997]
cor enthus zASVAB_MATH_VERBAL_SCORE_PCT if white==1 [aw=SAMPLING_WEIGHT_CC_1997]
cor enthus zASVAB_MATH_VERBAL_SCORE_PCT if hisp==1 [aw=SAMPLING_WEIGHT_CC_1997]


STOP
