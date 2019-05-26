*You have to get the data from NLS Investigator yourself
*use "[directory]\non_cognitive_weight.dta", clear

*Control variables and variable creation

*Born 1957-1964
sum TNFI_TRUNC_1979 TNFI_TRUNC_1980 TNFI_TRUNC_1981 TNFI_TRUNC_1982 TNFI_TRUNC_1983 TNFI_TRUNC_2000 TNFI_TRUNC_2002 TNFI_TRUNC_2004 TNFI_TRUNC_2006 TNFI_TRUNC_2008 TNFI_TRUNC_2010 TNFI_TRUNC_2012
foreach x in TNFI_TRUNC_1979 TNFI_TRUNC_1980 TNFI_TRUNC_1981 TNFI_TRUNC_1982 TNFI_TRUNC_1983 TNFI_TRUNC_2000 TNFI_TRUNC_2002 TNFI_TRUNC_2004 TNFI_TRUNC_2006 TNFI_TRUNC_2008 TNFI_TRUNC_2010 TNFI_TRUNC_2012 {
replace `x'=. if `x'<0
}

egen weight=rowmean (SAMPWEIGHT_1979 SAMPWEIGHT_1981 SAMPWEIGHT_1980 SAMPWEIGHT_1982 SAMPWEIGHT_1983 SAMPWEIGHT_1984 SAMPWEIGHT_1985 SAMPWEIGHT_1986 SAMPWEIGHT_1987 SAMPWEIGHT_1988 SAMPWEIGHT_1989 SAMPWEIGHT_1990 SAMPWEIGHT_1991 SAMPWEIGHT_1992)

gen real_fam_inc1979=TNFI_TRUNC_1979 *3.31
gen real_fam_inc1980=TNFI_TRUNC_1980 *2.9
gen real_fam_inc1981=TNFI_TRUNC_1981 *2.64
gen real_fam_inc1982=TNFI_TRUNC_1982 *2.49
gen real_fam_inc1983=TNFI_TRUNC_1983*2.41
egen real_fam_inc79_83=rowmean(real_fam_inc1979 real_fam_inc1980 real_fam_inc1981 real_fam_inc1982 real_fam_inc1983)

egen fam_inc=rowmean(TNFI_TRUNC_2000 TNFI_TRUNC_2002 TNFI_TRUNC_2004 TNFI_TRUNC_2006 TNFI_TRUNC_2008 TNFI_TRUNC_2010 TNFI_TRUNC_2012)
gen real_fam_inc2000 =TNFI_TRUNC_2000*1.39
gen real_fam_inc2002 =TNFI_TRUNC_2002*1.33
gen real_fam_inc2004 =TNFI_TRUNC_2004*1.27
gen real_fam_inc2006 =TNFI_TRUNC_2006*1.19
gen real_fam_inc2008 =TNFI_TRUNC_2008*1.11
gen real_fam_inc2010 =TNFI_TRUNC_2010*1.10
gen real_fam_inc2012 =TNFI_TRUNC_2012*1.045
egen real_fam_inc=rowmean(real_fam_inc2000 real_fam_inc2002 real_fam_inc2004 real_fam_inc2006 real_fam_inc2008 real_fam_inc2010 real_fam_inc2012)

sum OCCALL_EMP*
foreach x in OCCALL_EMP_01_2000 OCCALL_EMP_01_2002 OCCALL_EMP_01_2004 OCCALL_EMP_01_2006 OCCALL_EMP_01_2008 OCCALL_EMP_01_2010 OCCALL_EMP_01_2012 {
replace `x'=. if `x'>990
replace `x'=. if `x'<0
}

egen min_occ=rowmin(OCCALL_EMP_01_2000 OCCALL_EMP_01_2002 OCCALL_EMP_01_2004 OCCALL_EMP_01_2006 OCCALL_EMP_01_2008 OCCALL_EMP_01_2010 OCCALL_EMP_01_2012)
gen prof_man=1 if min_occ<=245
replace prof_man=0 if min_occ>245
replace prof_man=0 if min_occ==.

gen prof_man2000=1 if OCCALL_EMP_01_2000<=245
replace prof_man2000=0 if OCCALL_EMP_01_2000>245
replace prof_man2000=0 if OCCALL_EMP_01_2000==.
gen prof_man2012=1 if OCCALL_EMP_01_2012<=245
replace prof_man2012=0 if OCCALL_EMP_01_2012>245
replace prof_man2012=0 if OCCALL_EMP_01_2012==.

gen yr_born=Q1_3_A_Y_1979 
gen yr_born2=yr_born^2

gen yrs_edu=Q3_4_2012
replace yrs_edu=. if yrs_edu>20
replace yrs_edu=. if yrs_edu<0

gen yrs_edu_dad=HGC_FATHER_1979
replace yrs_edu_dad=. if yrs_edu>20
replace yrs_edu_dad=. if yrs_edu<0
gen yrs_edu_mom=HGC_MOTHER_1979
replace yrs_edu_mom=. if yrs_edu>20
replace yrs_edu_mom=. if yrs_edu<0
egen yrs_edu_parent=rowmean(yrs_edu_mom yrs_edu_dad)

gen jew2=1 if R_REL_1_COL_1979==8
replace jew2=0 if R_REL_1_COL_1979<8 | R_REL_1_COL_1979==9

gen catholic=1 if R_REL_1_1979 ==7
replace catholic=0 if R_REL_1_1979!=7
gen jew=1 if R_REL_1_1979 ==8
replace jew=0 if R_REL_1_1979 !=8
gen other_rel=1 if R_REL_1_1979>9
replace other_rel=0 if R_REL_1_1979<9

gen asian=1 if FAM_31_1979==2
replace asian=1 if FAM_31_1979==10
replace asian=1 if FAM_31_1979==14
replace asian=1 if FAM_31_1979==13
replace asian=1 if FAM_31_1979==26
replace asian=1 if FAM_31_1979==4
replace asian=1 if FAM_31_1979==8
mvencode asian, mv(0)

gen male=1 if SAMPLE_SEX_1979==1
replace male=0 if SAMPLE_SEX_1979==2

gen hisp=1 if SAMPLE_RACE_78SCRN==1
replace hisp=0 if SAMPLE_RACE_78SCRN==2 | SAMPLE_RACE_78SCRN==3
gen black=1 if SAMPLE_RACE_78SCRN==2
replace black=0 if SAMPLE_RACE_78SCRN==1 | SAMPLE_RACE_78SCRN==3
gen white=1 if SAMPLE_RACE_78SCRN==3
replace white=0 if SAMPLE_RACE_78SCRN==2 | SAMPLE_RACE_78SCRN==1

replace AFQT_3_1981=. if AFQT_3_1981<0   
sum AFQT_3_1981
gen AFQT_3_1981_100=AFQT_3_1981/1000
egen zAFQT=std(AFQT_3_1981)


sum SCHSUR_8A_1979 SCHSUR_9A_1979 SCHSUR_10A_1979  SCHSUR_12A_1979 ///
SCHSUR_13A_1979 SCHSUR_14A_1979 SCHSUR_15A_1979  SCHSUR_16A_1979 SCHSUR_48A_1979 SCHSUR_49A_1979

foreach x in SCHSUR_8_1979  SCHSUR_10_1979  SCHSUR_12_1979 ///
SCHSUR_13_1979 SCHSUR_14_1979 SCHSUR_15_1979  SCHSUR_16_1979 SCHSUR_48_1979 { 
replace `x'=. if `x'<0
}

sum SCHSUR_8_1979  SCHSUR_10_1979  SCHSUR_12_1979 ///
SCHSUR_13_1979 SCHSUR_14_1979 SCHSUR_15_1979  SCHSUR_16_1979 SCHSUR_48_1979 

egen altIQ=rowmean(SCHSUR_8_1979  SCHSUR_10_1979  SCHSUR_12_1979 ///
SCHSUR_13_1979 SCHSUR_14_1979 SCHSUR_15_1979  SCHSUR_16_1979 SCHSUR_48_1979 )
sum altIQ


foreach x in SCHSUR_8A_1979 SCHSUR_9A_1979 SCHSUR_10A_1979  SCHSUR_12A_1979 ///
SCHSUR_13A_1979 SCHSUR_14A_1979 SCHSUR_15A_1979  SCHSUR_16A_1979 SCHSUR_48A_1979 SCHSUR_49A_1979 {
replace `x'=. if `x'<0 
}

egen iq=rowmean(SCHSUR_8A_1979 SCHSUR_9A_1979 SCHSUR_10A_1979  SCHSUR_12A_1979 ///
SCHSUR_13A_1979 SCHSUR_14A_1979 SCHSUR_15A_1979  SCHSUR_16A_1979 SCHSUR_48A_1979 SCHSUR_49A_1979)
egen ziq=std(iq)

egen raw_iq=rowmean(SCHSUR_8A_1979 SCHSUR_9A_1979 SCHSUR_10A_1979  SCHSUR_12A_1979 ///
SCHSUR_13A_1979 SCHSUR_14A_1979 SCHSUR_15A_1979  SCHSUR_16A_1979 SCHSUR_48A_1979 SCHSUR_49A_1979)
egen ziq2=std(iq)

gen health=5 if H40_SF12_2==1
replace health=4 if H40_SF12_2==2
replace health=3 if H40_SF12_2==3
replace health=2 if H40_SF12_2==4
replace health=1 if H40_SF12_2==5

gen extrov=HEALTH_SOC_1_1985
replace extrov=. if HEALTH_SOC_1_1985>4 | HEALTH_SOC_1_1985<1
gen lack_control=ROTTER_SCORE
replace lack_control=. if ROTTER_SCORE<4

gen enthus=TIPI10_000001
replace enthus=. if TIPI10_000001<1 | TIPI10_000001>7
gen critical=TIPI10_000002
replace critical=. if TIPI10_000002<1 | TIPI10_000002>7
gen self_disc=TIPI10_000003
replace self_disc=. if TIPI10_000003<1 | TIPI10_000003>7
gen anxious=TIPI10_000004
replace anxious=. if TIPI10_000004<1 | TIPI10_000004>7
gen open=TIPI10_000005
replace open=. if TIPI10_000005<1 | TIPI10_000005>7

gen big3=enthus+self_disc-anxious
gen big5=enthus+self_disc-critical-anxious+open

sum AFQT_3_1981_100
gen lnreal_fam_inc=ln(real_fam_inc)
gen lnfam_inc=ln(fam_inc)

*IQ vs AFQT on predicting income
reg lnfam_inc  zAFQT yrs_edu yr_born catholic jew other_rel male hisp black
reg lnreal_fam_inc  ziq zAFQT yrs_edu yr_born catholic jew other_rel male hisp black
reg lnreal_fam_inc  ziq yrs_edu yr_born catholic jew other_rel male hisp black
reg lnreal_fam_inc  altIQ zAFQT yrs_edu yr_born catholic jew other_rel male hisp black

*Study habits
replace TIMEUSESCH_12_MIN_1981=. if TIMEUSESCH_12_MIN_1981<0
replace TIMEUSESCH_12_HRS_1981=. if TIMEUSESCH_12_HRS_1981<0
gen  hw_hours2=TIMEUSESCH_12_MIN_1981/60
gen homework=TIMEUSESCH_12_HRS_1981+hw_hours2
sum homework TIMEUSESCH_12_*
gen study=TIMEUSESCH_13_1981
replace study=. if TIMEUSESCH_13_1981<0
sum study

replace TIMEUSETV_2_HRS_1981=. if TIMEUSETV_2_HRS_1981<0
replace TIMEUSETV_2_MINS_1981=. if TIMEUSETV_2_MINS_1981<0
gen tv=TIMEUSETV_2_HRS_1981+(TIMEUSETV_2_MINS_1981/60)

replace TIMEUSEREADING_10_HRS=. if TIMEUSEREADING_10_HRS<0
replace TIMEUSEREADING_10_MIN=. if TIMEUSEREADING_10_MIN<0
gen read=(TIMEUSEREADING_10_MIN/60)+TIMEUSEREADING_10_HRS

***Analyzing Racial & Ethnic differences****
***Regress IQ on race with or without weights and parental education
reg zAFQT  yr_born catholic jew other_rel male hisp black
reg zAFQT  yrs_edu_parent  yrs_edu yr_born catholic jew other_rel male hisp black
reg zAFQT  yrs_edu_parent  yrs_edu yr_born catholic jew other_rel male hisp black [aw=SAMPWEIGHT_1979]
reg altIQ  yrs_edu_parent  yrs_edu yr_born catholic jew other_rel male hisp black [aw=SAMPWEIGHT_1979]

replace AFQT_1_1981=. if AFQT_1_1981<0   
sum AFQT_1_1981 if white==1 & jew==0 [aw=SAMPWEIGHT_1981]
gen mwhiteA=r(mean)
gen sdwhiteA=r(sd)
gen zwhiteA=(AFQT_1_1981-mwhiteA)/sdwhiteA
gen A100=(100)+(zwhiteA*15)
sum A100
sum A100 if white==1
sum A100 if hisp==1 [aw=SAMPWEIGHT_1981]
sum A100 if white==1 [aw=SAMPWEIGHT_1981]
sum A100 if white==1 & jew==1 [aw=SAMPWEIGHT_1981]
sum A100 if asian==1 [aw=SAMPWEIGHT_1981]
sum A100 if black==1 [aw=SAMPWEIGHT_1981]
bysort R_REL_1_COL_1979: sum A100 if white==1 [aw=SAMPWEIGHT_1981]
bysort R_REL_1_COL_1979: sum A100 if black==1 [aw=SAMPWEIGHT_1981]

**Racial differnces in non-cognitive traits that predict income & health
egen zbig3=std(big3)

sum zAFQT zbig3 enthus self_disc anxious if black==1 [aw=SAMPWEIGHT_1979]
sum zAFQT zbig3 enthus self_disc anxious if jew==1 [aw=SAMPWEIGHT_1979]
sum zAFQT zbig3 enthus self_disc anxious if white==1 [aw=SAMPWEIGHT_1979]
sum zAFQT zbig3 enthus self_disc anxious if asian==1 [aw=SAMPWEIGHT_1979]
sum zAFQT zbig3 enthus self_disc anxious if hisp==1 [aw=SAMPWEIGHT_1979]
reg zbig3 male

reg big3 black hisp jew asian 
reg big3 black hisp jew asian [aw=SAMPWEIGHT_1979]
reg big3 black hisp jew asian yrs_edu_parent    [aw=SAMPWEIGHT_1979]
bysort SAMPLE_SEX_1979: sum zAFQT zbig3 enthus self_disc anxious [aw=SAMPWEIGHT_1979]

*IQ difference with Jewish-non-Jewish white dissappears with parental education
reg zAFQT yr_born catholic asian jew other_rel male hisp black [aw=SAMPWEIGHT_1981]
reg zAFQT yrs_edu_parent yrs_edu yr_born catholic asian jew other_rel male hisp black [aw=SAMPWEIGHT_1981]

*Low correaltion between cog & non-cog
cor zAFQT big3 big5 lack_control  yrs_edu_parent  extrov yrs_edu self_disc enthus critical anxious open

*Critical, anxious, open, don't work.
*Self-discipline & extroversion work
reg lnreal_fam_inc zAFQT self_disc enthus critical anxious open lack_control  yrs_edu_parent  extrov yrs_edu yr_born catholic jew other_rel male hisp black
reg lnreal_fam_inc zAFQT self_disc enthus critical anxious open lack_control  yrs_edu_parent  yrs_edu yr_born catholic jew other_rel male hisp black
reg lnreal_fam_inc zAFQT self_disc enthus  anxious  lack_control  yrs_edu_parent  yrs_edu yr_born catholic jew other_rel male hisp black

cor black big3 big5 zAFQT lack_control  yrs_edu_parent  extrov yrs_edu self_disc enthus critical anxious open
cor hisp big3 big5 zAFQT lack_control  yrs_edu_parent  extrov yrs_edu self_disc enthus critical anxious open if black!=1
cor jew big3 big5 zAFQT lack_control  yrs_edu_parent  extrov yrs_edu self_disc enthus critical anxious open 
cor other_rel big3 big5 zAFQT lack_control  yrs_edu_parent  extrov yrs_edu self_disc enthus critical anxious open 

reg lnreal_fam_inc zAFQT big3  lack_control  yrs_edu_parent  yrs_edu yr_born catholic jew other_rel male hisp black

***BIG 5 works as well as IQ
reg lnreal_fam_inc zAFQT ziq
reg health zAFQT ziq

reg lnreal_fam_inc zAFQT big3  lack_control  yrs_edu_parent  yrs_edu yr_born catholic jew other_rel male hisp black [aw= weight]
reg lnreal_fam_inc zAFQT big3  lack_control  yrs_edu_parent  yrs_edu yr_born catholic jew other_rel male hisp black 

**FINDIND in BOOK; 22%
reg lnreal_fam_inc zAFQT big3  lack_control  yrs_edu_parent  yrs_edu yr_born catholic jew other_rel male hisp black
reg lnreal_fam_inc ziq big3  lack_control  yrs_edu_parent  yrs_edu yr_born catholic jew other_rel male hisp black
cor yrs_edu ziq zAFQT

reg lnreal_fam_inc zAFQT big5  lack_control  yrs_edu_parent  yrs_edu yr_born catholic jew other_rel male hisp black
outreg2 using "DIRECTORY\Explain_income_w_iq_personality.xls" , excel adjr2 tstat replace
reg lnreal_fam_inc zAFQT big3  lack_control  yrs_edu_parent  yrs_edu yr_born catholic jew other_rel male hisp black
outreg2 using "DIRECTORY\Explain_income_w_iq_personality.xls" , excel adjr2 tstat
reg lnreal_fam_inc ziq big3  lack_control  yrs_edu_parent  yrs_edu yr_born catholic jew other_rel male hisp black
outreg2 using "DIRECTORY\Explain_income_w_iq_personality.xls" , excel adjr2 tstat
reg lnreal_fam_inc zAFQT self_disc enthus critical anxious open  lack_control  yrs_edu_parent  yrs_edu yr_born catholic jew other_rel male hisp black
outreg2 using "DIRECTORY\Explain_income_w_iq_personality.xls" , excel adjr2 tstat
reg lnreal_fam_inc zAFQT self_disc enthus critical anxious open  lack_control  yrs_edu_parent  yrs_edu yr_born male
outreg2 using "DIRECTORY\Explain_income_w_iq_personality.xls" , excel adjr2 tstat
reg lnreal_fam_inc zAFQT big3  lack_control  yrs_edu_parent  yrs_edu yr_born male
outreg2 using "DIRECTORY\Explain_income_w_iq_personality.xls" , excel adjr2 tstat
reg lnreal_fam_inc zAFQT big3  lack_control   yr_born male
outreg2 using "DIRECTORY\Explain_income_w_iq_personality.xls" , excel adjr2 tstat
reg lnreal_fam_inc yr_born catholic jew other_rel male hisp black
outreg2 using "DIRECTORY\Explain_income_w_iq_personality.xls" , excel adjr2 tstat
reg lnreal_fam_inc yr_born catholic jew other_rel male hisp black self_disc enthus critical anxious open  lack_control  yrs_edu_parent  yrs_edu
outreg2 using "DIRECTORY\Explain_income_w_iq_personality.xls" , excel adjr2 tstat

**HOMEWORK
reg zAFQT homework  big3  lack_control  yrs_edu_parent  yrs_edu yr_born catholic jew other_rel male hisp black
reg homework  big3  lack_control  yrs_edu_parent  yrs_edu yr_born catholic jew other_rel male hisp black
reg homework   yr_born catholic jew other_rel male hisp black

tab TIMEUSESCH_2_1981
sum TIMEUSESCH_2_1981
sum read tv homework zAFQT if asian==1 & TIMEUSESCH_2_1981==1
sum read tv homework zAFQT if jew==1  & TIMEUSESCH_2_1981==1 [aw=SAMPWEIGHT_1981]
sum read tv homework zAFQT if jew==0 & TIMEUSESCH_2_1981==1 [aw=SAMPWEIGHT_1981]
di 12.5-8.2
di 11.1-7.7
ttesti 110 .84 1.1 11960 .768 1.2
reg zAFQT homework male black tv jew yrs_edu yrs_edu_parent if TIMEUSESCH_2_1981==1 [aw=weight]

sum read tv homework zAFQT if cath==1
sum homework
cor zAFQT homework tv read

reg homework jew asian  male hisp black [aw=weight]
reg zAFQT yrs_edu yr_born  jew  male hisp black asian [aw=weight]
reg zAFQT yrs_edu yr_born  jew  male hisp black asian [aw=weight]
reg zAFQT yrs_edu yrs_edu_parent yr_born  jew  male hisp black asian [aw=weight]
reg zAFQT yrs_edu homework tv yrs_edu_parent yr_born  jew  male hisp black asian [aw=weight]

reg zAFQT  big3  lack_control    yrs_edu yr_born catholic jew other_rel male hisp black asian [aw=weight]
reg zAFQT homework big3  lack_control    yrs_edu yr_born catholic jew other_rel male hisp black asian [aw=weight]
reg zAFQT homework  big3  lack_control  yrs_edu_parent  yrs_edu yr_born catholic jew other_rel male hisp black asian [aw=weight]

**HEALTH
reg health zAFQT big5  lack_control  yrs_edu_parent  yrs_edu yr_born catholic jew other_rel male hisp black
outreg2 using "DIRECTORY\Explain_health_w_iq_personality.xls" , excel adjr2 replace tstat
reg health zAFQT big3  lack_control  yrs_edu_parent  yrs_edu yr_born catholic jew other_rel male hisp black
outreg2 using "DIRECTORY\Explain_health_w_iq_personality.xls" , excel adjr2  tstat
reg health zAFQT self_disc enthus critical anxious open   lack_control  yrs_edu_parent  yrs_edu yr_born catholic jew other_rel male hisp black
outreg2 using "DIRECTORY\Explain_health_w_iq_personality.xls" , excel adjr2  tstat
reg health yr_born catholic jew other_rel male hisp black
outreg2 using "DIRECTORY\Explain_health_w_iq_personality.xls" , excel adjr2  tstat


**Calculate age-adjusted income & health based on IQ/AFQT
reg lnreal_fam_inc zAFQT  yr_born 
predict p_earn
reg health zAFQT  yr_born 
predict p_health

reg lnreal_fam_inc zAFQT  yr_born big3
predict p_earn_big
reg health zAFQT  yr_born big3
predict p_health_big

**GINI
**Calcualte Gini for various factors
set more off
foreach x in AFQT_3_1981_100 health real_fam_inc big3 big5 p_health p_earn  p_health_big p_earn_big {
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


sum real_fam_inc health
gen affluent_healthy=1 if real_fam_inc>70000 & health>=4
replace affluent_healthy=0 if real_fam_inc<70000 | health<4

egen inc50= median(real_fam_inc)

gen aff=1 if real_fam_inc>inc50
replace aff=0 if real_fam_inc<=inc50

gen vgood_health=1 if health>=4
replace vgood_health=0 if health<4
replace vgood_health=. if health==.

xtile xbig3=big3, nq(5)
xtile xafqt=AFQT_3_1981_100, nq(5)

sum affluent_healthy aff vgood_health prof_man* if AFQT_3_1981_100<=20 & AFQT_3_1981_100>=0
sum affluent_healthy aff vgood_health prof_man* if AFQT_3_1981_100<=40 & AFQT_3_1981_100>20
sum affluent_healthy aff vgood_health prof_man* if AFQT_3_1981_100<=60 & AFQT_3_1981_100>40
sum affluent_healthy aff vgood_health prof_man* if AFQT_3_1981_100<=80 & AFQT_3_1981_100>60
sum affluent_healthy aff vgood_health prof_man* if AFQT_3_1981_100>=80


bysort xafqt: sum prof_man2000
bysort xbig3: sum affluent_healthy prof_man2000

sum big5 self_disc enthus critical anxious open 

sum self_disc enthus critical anxious open if black==1
sum self_disc enthus critical anxious open if  hisp==1
sum self_disc enthus critical anxious open if white==1

reg big3   yr_born catholic jew other_rel male hisp black
reg big3   yrs_edu_parent  yrs_edu yr_born catholic jew other_rel male hisp black


STOP

**CPI Data used to adjust incomes
Year	Annual	
1979	72.6	3.305881543
1980	82.4	2.912706311
1981	90.9	2.640341034
1982	96.5	2.487119171
1983	99.6	2.409708835
1984	103.9	2.309980751
1985	107.6	2.230548327
1986	109.6	2.189844891
1987	113.6	2.112737676
1988	118.3	2.028799662
1989	124.0	1.935540323
1990	130.7	1.836319816
1991	136.2	1.762165932
1992	140.3	1.710669993
1993	144.5	1.660948097
1994	148.2	1.619480432
1995	152.4	1.574849081
1996	156.9	1.529681326
1997	160.5	1.495370717
1998	163.0	1.472435583
1999	166.6	1.440618247
2000	172.2	1.393768873
2001	177.1	1.355206098
2002	179.9	1.334113396
2003	184.0	1.30438587
2004	188.9	1.270550556
2005	195.3	1.228914491
2006	201.6	1.190510913
2007	207.342	1.157541646
2008	215.303	1.114740621
2009	214.537	1.11872078
2010	218.056	1.100666801
2011	224.939	1.06698705
2012	229.594	1.045353973
2013	232.957	1.030263096
2014	236.736	1.013817079
2015	237.017	1.012615129
2016	240.007	1
