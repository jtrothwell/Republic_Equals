use "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\CPS\ASEC_1960_2017.dta", clear

**immigration status asked starting in 1994 on ASEC
keep if year>=1994

gen less=1 if educ<71
gen HS=1 if educ==72 | educ==73
gen some=1 if educ==80 | educ==81
replace some=1 if educ==100 
gen assoc=1 if educ==91 | educ==92
gen assoc_or_two=1 if educ==90 | educ==91 | educ==92
gen BA=1 if educ==111
gen BA_or_four=1 if educ==111 | educ==110
gen postBA=1 if educ>=120
gen BA_higher=1 if educ>=111 
replace BA_higher=0 if educ<111 
replace BA_higher=. if educ>130 
mvencode less HS some assoc assoc_or_two BA BA_or_four postBA, mv(0)

gen age2=age^2
gen age3=age^3
gen male=1 if sex==1
replace male=0 if sex==2


*Replace missing income data as missing if coded as such
replace inctot=. if inctot==99999999
replace inctot=. if inctot==99999998

*remove if negative weights
drop if asecwt<0
gen lninc=ln(inctot)

bysort year: egen SDinctot=sd(inctot)
bysort year: egen Meaninctot=mean(inctot)
gen Zinc=(inctot-Meaninctot)/SDinctot
sum Zinc

gen emp=1 if empstat==1 | empstat==10 | empstat==12
replace emp=0 if empstat!=1 & empstat!=10 & empstat!=12
keep if emp==1

gen foreign=1 if nativity==4 | nativity==5
replace foreign=0 if nativity<=3

bysort statefip year: egen pctFB_st=mean(foreign)
bysort occ1990 year: egen pctFB_occ=mean(foreign)
bysort statefip occ1990 year: egen pctFB_st_occ=mean(foreign)

bysort statefip year: egen n_st=total(asecwt)
bysort occ1990 year: egen n_occ=total(asecwt)
bysort statefip occ1990 year: egen n_st_occ=total(asecwt)

bysort statefip year: egen nFB_st=total(foreign*asecwt)
bysort occ1990 year: egen nFB_occ=total(foreign*asecwt)
bysort statefip occ1990 year: egen nFB_st_occ=total(foreign*asecwt)

gen field="Law" if occ1990==178 | occ1990==179
replace field="Law" if occ1990==234
replace field="Management" if occ1990>=03 & occ1990<=37 
replace field="Engineering" if occ1990>=43 & occ1990<=59
replace field="Computer or Math" if occ1990>=64 & occ1990<=68
replace field="Science" if occ1990>=69 & occ1990<=83
replace field="Healthcare" if occ1990>=84 & occ1990<=106
replace field="Healthcare" if occ1990>=203 & occ1990<=208
replace field="Healthcare" if occ1990>=445 & occ1990<=447
replace field="Teacher" if occ1990>=113 & occ1990<=165
replace field="Social science" if occ1990>=166 & occ1990<=173
replace field="Social suppprt" if occ1990>=174 & occ1990<=176
replace field="Writer" if occ1990>=183 & occ1990<=184
replace field="Writer" if occ1990==195 | occ1990==198
replace field="Artist and Designers" if occ1990>=185 & occ1990<=194
replace field="Atheletes and Officials" if occ1990==199
replace field="Engineering" if occ1990>=213 & occ1990<=218
replace field="Science" if occ1990>=223 & occ1990<=225
replace field="Computer or Math" if occ1990>=229 & occ1990<=234
*Technican NEC
replace field="Professional NEC" if occ1990==235
*prof NEC
replace field="Professional NEC" if occ1990==200
*broadcast tech
replace field="Professional NEC" if occ1990==228
replace field="Sales" if occ1990>=243 & occ1990<=290
replace field="Clerical" if occ1990>=303 & occ1990<=391
*reclassify comp machine operator as computer  job
*replace field="Computer or Math" if occ1990==308
replace field="Protective Service" if occ1990>=415 & occ1990<=427
replace field="Personal Service" if occ1990>=405 & occ1990<=408
replace field="Personal Service" if occ1990>=434 & occ1990<=444
replace field="Personal Service" if occ1990>=448 & occ1990<=469
replace field="Agriculture" if occ1990>=473 & occ1990<=498
replace field="Repair" if occ1990>=503 & occ1990<=549
replace field="Construction" if occ1990>=558 & occ1990<=617
replace field="Production" if occ1990>=628 & occ1990<=799
replace field="Transportation" if occ1990>=803 & occ1990<=890
replace field="Air Travel Professions" if occ1990>=226 & occ1990<=227
replace field="Military" if occ1990==905

tab field, gen(group)

bysort statefip field year: egen pctFB_st_field=mean(foreign)

gen Ethnic="White" if hispan==0 & race==100
replace Ethnic="Black" if hispan==0 & race==200
replace Ethnic="Hispanic" if hispan!=0 
replace Ethnic="Asian" if race==400 | race==500
tab Ethnic, gen(race)
tab year, gen(yr)
sum race1 race2

*Native workers
*********

**State-occupation competition
areg lninc pctFB_st_occ group1-group23 male age age2 age3 less some assoc BA postBA race1 race2  yr2-yr25 if foreign==0 [aw=asecwt], ab(statefip) cl(statefip)
*-.227
**US-occupation competition**

**Preferrred Model**
areg lninc pctFB_occ group1-group23 male age age2 age3 less some assoc BA postBA race1 race2  yr2-yr25 if foreign==0 [aw=asecwt], ab(statefip) cl(statefip)
**state competition, any occupation
areg lninc pctFB_st group1-group23 male age age2 age3 less some assoc BA postBA race1 race2  yr2-yr25 if foreign==0 [aw=asecwt], ab(statefip) cl(statefip)
**state competition in broad occupation group
areg lninc pctFB_st_field group1-group23 male age age2 age3 less some assoc BA postBA race1 race2  yr2-yr25 if foreign==0 [aw=asecwt], ab(statefip) cl(statefip)
*Foreign workers
areg lninc pctFB_st_field group1-group23 male age age2 age3 less some assoc BA postBA race1 race2  yr2-yr25 if foreign==1 [aw=asecwt], ab(statefip) cl(statefip)

**By Level of education
areg lninc pctFB_st_field group1-group23 male age age2 age3 less some assoc BA postBA race1 race2  yr2-yr25 if foreign==0 & educ<=73 [aw=asecwt], ab(statefip) cl(statefip)
areg lninc pctFB_st_field group1-group23 male age age2 age3 less some assoc BA postBA race1 race2  yr2-yr25 if foreign==0 & educ<111 [aw=asecwt], ab(statefip) cl(statefip)
areg lninc pctFB_st_field group1-group23 male age age2 age3 less some assoc BA postBA race1 race2  yr2-yr25 if foreign==0 & educ>=111 [aw=asecwt], ab(statefip) cl(statefip)

areg Zinc pctFB_st_field group1-group23 male age age2 age3 less some assoc BA postBA race1 race2  yr2-yr25 if foreign==0 & educ<=73 [aw=asecwt], ab(statefip) cl(statefip)
areg Zinc pctFB_st_field group1-group23 male age age2 age3 less some assoc BA postBA race1 race2  yr2-yr25 if foreign==0 & educ>=111 [aw=asecwt], ab(statefip) cl(statefip)

areg lninc pctFB_st_field group1-group23 male age age2 age3 less some assoc BA postBA race1 race2  if foreign==0 & year==1994 [aw=asecwt], ab(statefip) cl(statefip)
areg lninc pctFB_st_field group1-group23 male age age2 age3 less some assoc BA postBA race1 race2  if foreign==0 & year<2000 [aw=asecwt], ab(statefip) cl(statefip)
areg lninc pctFB_st_field group1-group23 male age age2 age3 less some assoc BA postBA race1 race2  if foreign==0 & year>=2000 [aw=asecwt], ab(statefip) cl(statefip)
areg lninc pctFB_st_field group1-group23 male age age2 age3 less some assoc BA postBA race1 race2  if foreign==0 & year==2017 [aw=asecwt], ab(statefip) cl(statefip)

areg Zinc pctFB_st_field group1-group23 male age age2 age3 less some assoc BA postBA race1 race2  yr2-yr25 if foreign==0 [aw=asecwt], ab(statefip) cl(statefip)
di .2*(.24-.135)

**Exposure to immigration by education
bysort year: sum pctFB_st_field
bysort year: sum pctFB_st_field if educ>=111
bysort year: sum pctFB_st_field if educ<=73
