use "[DIRECTORY]\Project_Talent\ICPSR_33341-V2\ICPSR_33341\DS0005\33341-0005-Data.dta", clear

tab BY_SI062
label list BY_SI062

gen yiddish_any=1 if BY_SI062>=2 & BY_SI062<=6
replace yiddish_any=0 if BY_SI062==1
gen yiddish=1 if BY_SI062>=4 & BY_SI062<=6
replace yiddish=0 if BY_SI062<4 & BY_SI062!=0
gen fluent_yid=1 if BY_SI062==6 
replace fluent_yid=0 if BY_SI062<6 & BY_SI062!=0

gen russian=1 if BY_SI061>=4 & BY_SI061<=6
replace russian=0 if BY_SI061<4 & BY_SI061!=0
gen italian=1 if BY_SI059>=4 & BY_SI059<=6
replace italian=0 if BY_SI059<4 & BY_SI059!=0
gen german=1 if BY_SI058>=2 & BY_SI058<=6
replace german=0 if BY_SI058<4 & BY_SI058!=0
gen oriental=1 if BY_SI064>=4 & BY_SI064<=6
replace oriental=0 if BY_SI064<4 & BY_SI064!=0
gen spanish=1 if BY_SI060>=4 & BY_SI060<=6
replace spanish=0 if BY_SI060<4 & BY_SI060!=0
gen nordic=1 if BY_SI063 <4 & BY_SI063 <=6
replace nordic=0 if BY_SI063==1 & BY_SI063!=0

bysort BY_SI062: tab BY_SI061
tab BY_SI062 if yiddish==1

tab BY_SI061 if yiddish==1
tab BY_SI061 if yiddish==0
tab BY_SI058 if yiddish==1
tab BY_SI058 if yiddish==0
tab BY_SI058 if italian==1
tab BY_SI058 if italian==0
tab BY_SI062 if italian==1
tab BY_SI062 if italian==0
sum yiddish if italian==1
sum fluent_yid if italian==1
sum fluent_yid if BY_SI059==6

gen IQ=BY_C001
replace IQ=. if IQ==999
gen acad=BY_C002
replace acad=. if BY_C002==999
gen verb=BY_C003
replace verb=. if BY_C003==999
gen quant=BY_C004A
replace quant=. if BY_C004A==999
gen tech=BY_C005A
replace tech=. if BY_C005A==99
gen sci=BY_C006
replace sci=. if BY_C006==9999
gen math=BY_C004B
replace math=. if BY_C004B==999
gen tech_info=BY_C005B
replace tech_info=. if BY_C005B==99
gen creative=BY_R260 
replace creative=. if BY_R260==99
gen mechanical=BY_R270 
replace mechanical =. if BY_R270  ==99
*IQ=reading+math+abstract
gen abstract=BY_R290  
replace abstract =. if BY_R290 ==99
gen reading= BY_R250
replace reading=. if BY_R250==99
gen math1=BY_R311 
replace math1=. if BY_R311 ==99
*visualization
gen visual2d=BY_R281
replace visual2d=. if BY_R281==99
gen visual3d=BY_R282
replace visual3d=. if BY_R282==99
gen memory_sent=BY_R211
replace  memory_sent=. if BY_R211==99
gen memory_word=BY_R212
replace  memory_word=. if BY_R212==99



/*
BY_C001         int     %8.0g                 IQ COMPOSITE
BY_C002         int     %8.0g                 GENERAL ACADEMIC APTITUDE COMPOSITE
BY_C003         int     %8.0g                 VERBAL COMPOSITE
BY_C004A        int     %8.0g                 QUANTITATIVE APTITUDE COMPOSITE
BY_C005A        int     %8.0g                 TECHNICAL APTITUDE COMPOSITE
BY_C006         int     %8.0g                 SCIENTIFIC COMPOSITE
BY_C004B        int     %8.0g                 MATHEMATICS COMPOSITE
BY_C005B        int     %8.0g                 TECHNICAL INFORMATION COMPOSITE
*/


tab BY_AGESR if yiddish==1
tab BY_AGESR if yiddish==0
drop if BY_AGESR==0 | BY_AGESR==99
gen age_group="8-13" if BY_AGESR>=8 & BY_AGESR<=13
replace age_group="14" if BY_AGESR==14
replace age_group="15" if BY_AGESR==15
replace age_group="16" if BY_AGESR==16
replace age_group="17" if BY_AGESR==17
replace age_group="18" if BY_AGESR==18
replace age_group="19-21" if BY_AGESR>=19 &  BY_AGESR<=21

**Create age-standardized IQ scores, no weights used for this; but checks that it makes little difference to result
foreach x in IQ acad verb quant tech sci math tech_info creative mechanical abstract reading math1 visual2d visual3d memory_word memory_sent {
bysort age_group: egen m`x'Z=mean(`x') if BY_RACE==1 & yiddish==0 
bysort age_group: egen SD`x'Z=sd(`x') if BY_RACE==1 & yiddish==0 
bysort age_group: egen m`x'=max(m`x'Z) 
bysort age_group: egen SD`x'=max(SD`x'Z)
drop SD`x'Z m`x'Z
gen z`x'=(`x'-m`x')/SD`x'
gen `x'100=(100)+(15*z`x')
}


label list BY_RACE
gen white=1 if BY_RACE==1
replace white=0 if BY_RACE!=1
gen black=1 if BY_RACE==2
replace black=0 if BY_RACE!=2
gen asian=1 if BY_RACE==3
replace asian=0 if BY_RACE!=3
gen highest_faminc=1 if BY_SI072==5
replace highest_faminc=0 if BY_SI072<5  | BY_SI072==6

gen northern_black=1 if BY_RACE==2 & BY_REGCE==1
replace northern_black=0 if BY_RACE!=2 | BY_REGCE!=1

*Family incomes and education of parents
tab BY_SI118 
label list BY_SI072
gen fam_inc=BY_SI072 if BY_SI072<=5
replace fam_inc=1500 if BY_SI072==2
replace fam_inc=7500 if BY_SI072==3
replace fam_inc=10500 if BY_SI072==4
replace fam_inc=15000 if BY_SI072==5

label list BY_SI118
tab BY_SI119
gen mom_ed=BY_SI119
replace mom_ed=. if BY_SI119<1
gen dad_ed=BY_SI118
replace dad_ed=. if BY_SI118<1

egen maxed=rowmax(BY_SI118 BY_SI119 )
gen parent_ed= maxed
replace parent_ed=BY_SI119 if BY_SI118==.
replace parent_ed=BY_SI118 if BY_SI119==.
gen parentBA=1 if parent_ed>=8
replace parentBA=0 if parent_ed<8


STOP


***RESULTS******
**********
bysort BY_SI062: sum IQ100 [aw=BY_WTA]

**all non-yiddish
sum IQ100 visual2d100 visual3d100 abstract100 reading100 math1100 if yiddish==0  [aw=BY_WTA]
**white non-yiddish
sum IQ100 visual2d100 visual3d100 abstract100 reading100 math1100 if yiddish==0 & BY_RACE==1  [aw=BY_WTA]
sum IQ100 visual2d100 visual3d100 abstract100 reading100 math1100 if yiddish==0 & BY_RACE==1  

**by degree of yiddish--summary
sum IQ100 visual2d100 visual3d100 abstract100 reading100 math1100 if yiddish==1  [aw=BY_WTA]
sum IQ100 visual2d100 visual3d100 abstract100 reading100 math1100 if yiddish_any==1  [aw=BY_WTA]
sum IQ100 if  BY_SI062==1  [aw=BY_WTA]

sum IQ100 visual2d100 visual3d100 abstract100 if russian==1 [aw=BY_WTA]
sum IQ100 visual2d100 visual3d100 abstract100 if italian==1 [aw=BY_WTA]
sum IQ100 visual2d100 visual3d100 abstract100 if german==1 [aw=BY_WTA]
sum IQ100 visual2d100 visual3d100 abstract100 if oriental==1 [aw=BY_WTA]
sum IQ100 visual2d100 visual3d100 abstract100 if spanish==1 [aw=BY_WTA]
sum IQ100 visual2d100 visual3d100 abstract100 if nordic==1 [aw=BY_WTA]

sum IQ100 reading100 math1100 visual2d100 visual3d100 abstract100 if asian==1 [aw=BY_WTA]
sum IQ100 reading100 math1100 visual2d100 visual3d100 abstract100 if black==1 [aw=BY_WTA]

*By RACE
bysort BY_RACE: sum IQ100 [aw=BY_WTA]

**Parents' Education
tab BY_SI118 if yiddish==1  [aw=BY_WTA]
tab BY_SI119 if yiddish==1  [aw=BY_WTA]
tab maxed if yiddish==1 [aw=BY_WTA]
sum parentBA if yiddish==1 [aw=BY_WTA]
sum parentBA if yiddish==0 [aw=BY_WTA]
sum parentBA if yiddish==0 & BY_RACE==1 [aw=BY_WTA]
sum parentBA if oriental==1 [aw=BY_WTA]
sum parentBA if asian==1 [aw=BY_WTA]
sum parentBA if black==1 [aw=BY_WTA]

*parents' occupations
tab BY_SI105 if yiddish==1 [aw=BY_WTA]
tab BY_SI105 if yiddish==0 & BY_RACE==1 [aw=BY_WTA]
tab BY_SI106 if yiddish==1 [aw=BY_WTA]
tab BY_SI106 if yiddish==0 & BY_RACE==1[aw=BY_WTA]
bysort BY_SI105: sum IQ100 if yiddish==1 [aw=BY_WTA]
bysort BY_SI105: sum IQ100 if yiddish==0 & BY_RACE==1 [aw=BY_WTA]

tab BY_SI107 if yiddish==1 [aw=BY_WTA]
tab BY_SI105 if yiddish==0 & BY_RACE==1 [aw=BY_WTA]
tab BY_SI107 if yiddish==0 & BY_RACE==1 [aw=BY_WTA]

*Blacks raised outside south
sum IQ100 if BY_RACE==2 & (BY_REGCE==1 | BY_REGCE==4)  [aw=BY_WTA]
sum IQ100 if BY_RACE==2 & (BY_REGCE==2 | BY_REGCE==3)  [aw=BY_WTA]
sum IQ100 if BY_RACE==2 & (BY_REGCE==3)  [aw=BY_WTA]
sum IQ100 if BY_RACE==2 & (BY_REGCE==1 | BY_REGCE==4) & BY_SI066>=4 & BY_SI066!=. [aw=BY_WTA]
sum IQ100 if BY_RACE==2 & (BY_REGCE==2 | BY_REGCE==3) & BY_SI066>=4 & BY_SI066!=. [aw=BY_WTA]

*whites in NE
sum IQ100 if BY_RACE==2 & (BY_REGCE==1) & yiddish==0  [aw=BY_WTA]

*By place of parental birth
label list  BY_SI036
tab BY_SI036  if yiddish==1 [aw=BY_WTA]
sum IQ100 if yiddish==1 & BY_SI036!=3  [aw=BY_WTA]
sum IQ100 if yiddish==1 & BY_SI036==3  [aw=BY_WTA]

foreach x in IQ acad verb quant tech sci math tech_info mechanical abstract reading math1 visual2d visual3d memory_word memory_sent  creative {
sum `x'100 if oriental==1 [aw=BY_WTA]
}
foreach x in IQ acad verb quant tech sci math tech_info  mechanical abstract reading math1 visual2d visual3d memory_word memory_sent creative {
sum `x'100 if yiddish==1 [aw=BY_WTA]
}
foreach x in IQ acad verb quant tech sci math tech_info mechanical abstract reading math1 visual2d visual3d memory_word  memory_sent  creative {
sum `x'100 if BY_RACE==2 [aw=BY_WTA]
}

foreach x in IQ acad verb quant tech sci math tech_info mechanical abstract reading math1 visual2d visual3d memory_word  memory_sent  creative {
sum `x'100 if BY_RACE==2 & BY_REGCE==1 [aw=BY_WTA]
}

sum IQ100 if yiddish==1 & german==1 [aw=BY_WTA]

*parents occupations
tab BY_SI105 if yiddish==1 [aw=BY_WTA]
tab BY_SI107 if yiddish==1 [aw=BY_WTA]
tab BY_SI105 if yiddish==0 & BY_RACE==1 [aw=BY_WTA]
tab BY_SI107 if yiddish==0 & BY_RACE==1 [aw=BY_WTA]

*By private school
tab BY_CONTR if yiddish==1 [aw=BY_WTA]
bysort BY_CONTR: sum IQ100 if yiddish_any==1 [aw=BY_WTA]
bysort BY_CONTR: sum IQ100 if yiddish_any==0 & BY_RACE==1 [aw=BY_WTA]


**Reproduction
desc BY_SI121
label list BY_SI121  
sum BY_SI121  
tab BY_SI121  
gen children=BY_SI121  
replace children=. if BY_SI121==0 | BY_SI121 >12

*Brothers
label list BY_SI122 
label list BY_SI123
gen siblings=BY_SI123+BY_SI122
sum siblings
tab siblings

gen iq_x_yid= IQ100*yiddish
gen iq_x_oriental= IQ100*oriental

reg children IQ100 [aw=BY_WTA]
reg siblings IQ100 [aw=BY_WTA]
reg children IQ100 yiddish iq_x_yid [aw=BY_WTA]
reg siblings IQ100 yiddish iq_x_yid [aw=BY_WTA]
reg children IQ100 oriental iq_x_oriental [aw=BY_WTA]

reg children IQ100 fam_inc dad_ed mom_ed BY_AGESR [aw=BY_WTA]
reg siblings IQ100 fam_inc dad_ed mom_ed BY_AGESR [aw=BY_WTA]

reg children IQ100 BY_AGESR if yiddish==1 [aw=BY_WTA]
reg children IQ100 BY_AGESR if asian==1 [aw=BY_WTA]
reg children IQ100 BY_AGESR if yiddish==0 & white==1 [aw=BY_WTA]
reg children IQ100 BY_AGESR if yiddish==0 & black==1 [aw=BY_WTA]

reg siblings IQ100 BY_AGESR if yiddish==1 [aw=BY_WTA]
reg siblings IQ100 BY_AGESR if asian==1 [aw=BY_WTA]
reg siblings IQ100 BY_AGESR if yiddish==0 [aw=BY_WTA]

**Selective mating tests
sum children siblings if yiddish==1 & IQ100>100 [aw=BY_WTA]
sum children siblings if yiddish==1 & IQ100<100 [aw=BY_WTA]
sum children siblings if yiddish==0 & IQ100>100 [aw=BY_WTA]
sum children siblings if yiddish==0 & IQ100<100 [aw=BY_WTA]
sum children siblings if BY_RACE==2 & IQ100>100 [aw=BY_WTA]
sum children siblings if BY_RACE==2 & IQ100<100 [aw=BY_WTA]
sum children siblings if asian==1 & IQ100>100 [aw=BY_WTA]
sum children siblings if asian==1 & IQ100<100 [aw=BY_WTA]
sum children siblings if oriental==1 & IQ100>100 [aw=BY_WTA]
sum children siblings if oriental==1 & IQ100<100 [aw=BY_WTA]

sum children siblings if yiddish==1 & IQ100>100 & age_group=="16" [aw=BY_WTA]
sum children siblings if yiddish==1 & IQ100<100 & age_group=="16"  [aw=BY_WTA]
sum children siblings if yiddish==1 & IQ100>100 & age_group=="16" [aw=BY_WTA]
sum children siblings if yiddish==1 & IQ100<100 & age_group=="16"  [aw=BY_WTA]

sum IQ100 if yiddish==1 [aw=BY_WTA]
sum IQ100 if yiddish==1 [aw=children], detail
sum IQ100 if yiddish==1 [aw=siblings], detail
sum IQ100 if yiddish==1 [aw=BY_WTA], detail
sum IQ100 if yiddish==0 [aw=children], detail
sum IQ100 if yiddish==0 [aw=siblings], detail
sum IQ100 if yiddish==0 [aw=BY_WTA], detail
sum IQ100 if yiddish==0 & asian==1 [aw=children], detail
sum IQ100 if yiddish==0 & asian==1 [aw=siblings], detail
sum IQ100 if yiddish==0 & asian==1 [aw=BY_WTA], detail



