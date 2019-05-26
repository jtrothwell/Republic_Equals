/*
insheet using  "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\OECD\OECD GDP per capital growth 1980-2017 PPP.csv", clear 
gen recession08_09=((oecd_gdp_pc_ppp2009/ oecd_gdp_pc_ppp2008)^(1/1))-1
gen recession08_10=((oecd_gdp_pc_ppp2010/ oecd_gdp_pc_ppp2008)^(1/2))-1
gen recession08_11=((oecd_gdp_pc_ppp2011/ oecd_gdp_pc_ppp2008)^(1/3))-1
gen recession08_12=((oecd_gdp_pc_ppp2012/ oecd_gdp_pc_ppp2008)^(1/4))-1
gen recession08_13=((oecd_gdp_pc_ppp2013/ oecd_gdp_pc_ppp2008)^(1/5))-1
gen recession08_17=((oecd_gdp_pc_ppp2017/ oecd_gdp_pc_ppp2008)^(1/9))-1
ren v2 name3
gen alt=1 if alt_oecd_gdp_pc_ppp1980_2017!=.
replace oecd_gdp_pc_ppp1980_2017=alt_oecd_gdp_pc_ppp1980_2017 if oecd_gdp_pc_ppp1980_2017==.
keep oecd_gdp_pc_ppp2017 name3 country_name_oecd recession* oecd_gdp_pc_ppp1980_2017 alt
ren oecd_gdp_pc_ppp1980_2017 gr_gdp_pc_ppp1980_2017 
gen oecd=1
save  "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\OECD\OECD GDP per capital growth 1980-2017 PPP.dta", replace 
gsort -oecd_gdp_pc_ppp2017
edit
sum oecd*

*/

*Health share GDP
use  "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\OECD\oecd_health_sh_gdp.dta", clear
gen country_name_oecd=country
*OECD Growth and per capita income
merge 1:1 country_name_oecd using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\OECD\OECD GDP per capital growth 1980-2017 PPP.dta"
drop _merge
*Patents
gen country_code=name3
merge 1:1 country_code using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\OECD\patents_per_capita.dta"
drop _merge
*Gini-OECD
merge 1:1 country using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\OECD\gini_post_tax_oecd2012.dta"
drop _merge
gen countrycode=country_code
*OECD educational attainment
merge 1:1 country using  "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\OECD\oecd_tertiary_education_latest_year.dta"
drop _merge
drop if name3==""
*OECD top marginal rates
merge 1:1 country using   "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\OECD\top_marginal_tax_rates2017.dta"
drop _merge
*Oecd union density; union members/worker
merge 1:1 country using  "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\OECD\union_density1980_2017.dta"
drop _merge
*OECD national accoutns
merge 1:1 name3 using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\OECD\oecd_national_accounts2016.dta"
drop if _merge==2
drop _merge
merge 1:1 name3 using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\OECD\oecd_national_accounts1990.dta"
drop if _merge==2
drop _merge
**World Bank GDP per capita growth
merge 1:1 countrycode using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\WorldBank\gdp_per_capita1990_2015.dta"
gen  WBcode=countrycode
drop if _merge==2
drop _merge
*Ginis
merge 1:1 countrycode using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Milanovic\Gini_Summary_1960_2008.dta"
drop if _merge==2
drop _merge
*ICP Prices/Expenditure shares
merge 1:1 country using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\WorldBank\icp_expenditure_shares_by_sector2011.dta"
drop if _merge==2
drop _merge
merge 1:1 country using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\WorldBank\icp_prices2011.dta"
drop if _merge==2
drop _merge
gen rel_health_prices=ppi_health/ppi_grossdome
gen rel_housing_prices=ppi_housing/ppi_grossdome
*unions
merge 1:1 country_code using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\OECD\OECD_predict_inequality.dta" 
drop if _merge==2
drop _merge
*single-parents
merge 1:1 country_code using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\OECD\oecd_single_parents2014.dta"
drop if _merge==2
drop _merge
*privileges
merge 1:1 country_code using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\OECD\Exclusive_privileges_by_prof.dta" 
drop if _merge==2
drop _merge
*regulations
merge 1:1 country_code using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\OECD\Form_of_business_by_prof.dta"
drop if _merge==2
drop _merge 

**Education
merge 1:1 WBcode using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Barro-Lee\Country_Level_2010_Avg_Yrs_Edu_by_Age.dta"
drop if _merge==2
drop _merge
merge 1:1 WBcode using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Barro-Lee\Female_Country_Level_2010_Avg_Yrs_Edu_by_Age.dta"
drop if _merge==2
drop _merge
merge 1:1 WBcode using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Barro-Lee\Male_Country_Level_2010_Avg_Yrs_Edu_by_Age.dta"
drop if _merge==2
drop _merge
**Govt quality
drop region
merge 1:1 WBcode using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Institutions\Heritage2015_and_2011_2015_WGI_data.dta"
drop if _merge==2
drop _merge
**PWT
merge m:1 countrycode using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\PennWorldTable\PWT_Growth_Since_1960.dta"
drop if _merge==2
drop _merge
*LIS top1 shares
merge 1:1 country using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Luxembourg\LIS Top 1 Shares of Income by Country.dta"
drop _merge
*LUX Gini
merge 1:1 country using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Luxembourg\Gini_coefficients_LIS_ALL_OBS.dta"
*edit country if _merge==2
drop _merge



replace country="Taiwan" if country=="Taiwan, China"
replace country="Russia" if country=="Russian Federat"
replace country=trim(country)
drop if country=="Palestine"
replace	country="Korea, Republic of"	if country=="Korea, Rep." 
replace	country="Slovakia"	if country=="Slovak Republic" 
drop if country==""
drop if countrycode==""

*World Poll
*gen name3=countrycode
*merge 1:m name3 using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Draft\Appendix\Summary_Inequality_by_Country.dta" 
*duplicates tag name3, gen(ex)
*tab name3 if ex>0
*duplicates drop name3, force
drop if name3==""
merge 1:m name3 using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Draft\Appendix\Inequality and Well-being data for merge.dta"
drop _merge

*duplicates tag countrynew, gen(ex)
*tab countrynew if ex>0
*Difficulty with income, 
*N cypruis
*duplicates drop countrynew, force
*merge 1:1 countrynew using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\WorldPoll\financial insecurity by country.dta"*
*drop _merge


****
drop if country==""

*Luxembourg Income Study
merge 1:1 country using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Luxembourg\LIS_share_top1_technicians.dta"
drop if  _merge==2
drop _merge
merge 1:1 country using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Luxembourg\LIS_share_top1_goods.dta"
drop if  _merge==2
drop _merge
merge 1:1 country using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Luxembourg\LIS_share_top1_prof_occ.dta"
drop if  _merge==2
drop _merge
merge 1:1 country using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Luxembourg\LIS_share_top1_healthcare_edu.dta"
drop if  _merge==2
drop _merge
merge 1:1 country using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Luxembourg\LIS_share_top1_finance.dta"
drop if _merge==2
drop _merge
merge 1:1 country using  "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Luxembourg\LIS_share_top1_business_services.dta"
drop if _merge==2
drop _merge
merge 1:1 country using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Luxembourg\LIS_share_top1_legal_services.dta"
drop if _merge==2
drop _merge
merge 1:1 country using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Luxembourg\top1_by_detailed_lawyer.dta"
drop if _merge==2
drop _merge
merge 1:1 country using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Luxembourg\top1_by_detailed_engin.dta"
drop if _merge==2
drop _merge
merge 1:1 country using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Luxembourg\top1_by_detailed_doc.dta"
drop if _merge==2
drop _merge
merge 1:1 country using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Luxembourg\top1_by_detailed_dentist.dta"
drop if _merge==2
drop _merge
*LIS median top1 income to median income
merge 1:1 country using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Luxembourg\top1_ratio_by_country.dta"
drop if _merge==2
drop _merge
merge 1:1 country using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Luxembourg\top1_ratio_by_country2.dta", update
drop if _merge==2
drop _merge
merge 1:1 country using  "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Luxembourg\manager_income_ratio_by_country.dta"
drop if _merge==2
drop _merge
merge 1:1 country using  "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Luxembourg\prof_income_ratio_by_country.dta"
drop if _merge==2
drop _merge


*OECD PISA
merge 1:1 country using  "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\PISA\School_Inequality.dta"
*edit name3 _merge if country=="Czech Republic"
*edit name3 _merge if country=="Slovak Republic"
drop if _merge==2
drop _merge


*2008-2014 Milanovic
gen xgini=gini2008- gini1980
gen xhealth= health_sh_gdp2016- health_sh_gdp2000
egen Elite_regs=rowmean(privilegesACT privilegesARC privilegesENG privilegesLEG regulationsACT regulationsARC regulationsENG regulationsLEG)

ren housingwaterelectricitygasandoth housing
gen housing_health=housing+health


**Putterman/Weil/ancestry
*gen name3=countrycode
drop if countrycode==""
merge 1:1 countrycode using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\WorldBank\Putterman_weil_ancestry2000.dta"
drop if _merge==2
drop _merge
*WB immigration share data
merge 1:1 countrycode using  "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\WorldBank\immigration_share_pop1990_2015.dta"
drop if _merge==2
drop _merge
**Putterman et al agricultural trans
merge 1:1 name3 using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Putterman\Agricultural Transition Data.dta"
drop if _merge==2
drop _merge
**Gallup World Poll Confidence
merge 1:1 name3 using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\WorldPoll\confidence.dta"
drop if _merge==2
drop _merge

*Piketty; pre-tax national income; tax unit based
*merge 1:1 country using  "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Piketty\piketty_top1_shares.dta"
*drop _merge
*merge 1:1 country using  "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Piketty\piketty_top1_shares1970_2016.dta", update
*drop if _merge==2
*drop _merge
*Pre-tax national income share held by a given percentile group. Pre-tax national income is the sum of all pre-tax personal income flows accruing to the owners of the production factors, labor and capital, before taking into account the operation of the tax/transfer system, but after taking into account the operation of pension system. The central difference between personal factor income and pre-tax income is the treatment of pensions, which are counted on a contribution basis by factor income and on a distribution basis by pre-tax income. The population is comprised of individuals over age 20. The base unit is the tax unit defined by national fiscal administrations to measure personal income taxes.

/*
*Piketty
merge 1:1 country using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Piketty\world_ineq_data_2016.dta", update replace
drop if _merge==2
drop _merge
*/

*lis_t1_sh_all lis_t1_sh_wrkage lis_t1_sh_emp_wrkage
*BASICS= food, clothing, housing, education, healthcare, furniture, and transportation
*gsort -basics
*edit

gen gap90_50skill=p90skill-p50skill

ren pct_children_w p_child_w_sp14
ren sh_top1_legal sh_top1_legal

gen area="Scandinavia" if country=="Sweden" | country=="Denmark" | country=="Iceland" | country=="Norway" | country=="Finland"
replace area="Western Europe" if country=="Belgium" | country=="Netherlands" | country=="Luxembourg" | country=="Germany" | country=="France" | country=="Switzerland" | country=="Austria"
replace area="Eastern Europe" if country=="Russia" | country=="Czech Republic" | country=="Poland" | country=="Hungary" | country=="Estonia"  | country=="Slovenia" | country=="Slovak Republic" | country=="Latvia" | country=="Lithuania"
*replace area="Eastern Asia" if country=="Japan" | country=="Korea"
replace area="Japan" if country=="Japan" 
replace area="Britain & former colonies" if country=="United Kingdom" | country=="Canada" | country=="Australia" | country=="Ireland" | country=="New Zealand"
replace area="Southern Europe" if country=="Portugal" | country=="Italy" | country=="Spain" | country=="Greece" 
replace area="USA" if country=="United States"
*replace area="Latin America" if country=="Chile" | country=="Mexico"
*replace area="West Asia" if country=="Israel" | country=="Turkey"
replace area="Israel" if country=="Israel" 
replace area="Turkey" if country=="Turkey" 
replace area="Mexico" if country=="Mexico" 
replace area="Chile" if country=="Chile" 


*LIS data by occupational not available in Sweden
*Canada occupational data uses IPUMS 2011
replace sh_top1_prof_occ=. if country=="Sweden"
replace sh_top1_manager_occ=. if country=="Sweden"
replace sh_top1_not_elite_occ=. if country=="Sweden"


gen xcsh_m1980_2014=csh_m2014-csh_m1980 
gen bal2014=csh_x2014+csh_m2014
gen bal1980=csh_x1980+csh_m1980
gen xbal=bal2014-bal1980

replace oecd=1 if country=="Slovak Republic" | country=="Czech Republic"
sum oecd

foreach x in gr_gdp_pc_ppp1980_2017 un_gini gini_lis_2010_2016 avg_top1_2010_2016 {
egen Z`x'=std(`x')
}
egen NOT_EQUAL=rowmean(Zun_gini Zgini_lis_2010_2016 Zavg_top1_2010_2016)
gen aff_unequal=NOT_EQUAL*oecd_gdp_pc_ppp2017 

*gsort -gr_gdp_pc_ppp1980_2017
*edit country_name gr_gdp_pc_ppp1980_2017 Zgr_gdp_pc_ppp1980_2017

gen slow_growth=1 if gr_gdp_pc_ppp1980_2017<.02
replace slow_growth=0 if gr_gdp_pc_ppp1980_2017>.02
sum slow_growth

gen slow_growth_high_ineq=1 if gr_gdp_pc_ppp1980_2017<.02 & NOT_EQUAL>1
replace slow_growth_high_ineq=0 if gr_gdp_pc_ppp1980_2017>.02 | NOT_EQUAL<1

gen USA_dum=1 if name3=="USA"
replace USA_dum=0 if name3!="USA"

gen pik_change= avg_top1_2010_2016- avg_top1_1979_1981

gen xbal_share_gdp=bal_share_gdp2016-bal_share_gdp1990
gen xcomp_share_gdp=comp_share_gdp2016-comp_share_gdp199

cd "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Draft\Appendix\"

STOP

keep country name3 imm_share2015 diversity p_child_w_sp14 ///
oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary ///
Elite_regs manager_inc_ratio50 manager_inc_ratio90 prof_inc_ratio50 prof_inc_ratio90 sh_top1_bus_services sh_top1_dentist sh_top1_doctor sh_top1_engin sh_top1_finance sh_top1_health_edu_pub sh_top1_lawyer sh_top1_legal sh_top1_manager_occ sh_top1_mfg_mining sh_top1_not_elite_occ sh_top1_prof_occ sh_top1_technicians ///
xcomp_share_gdp comp_share_gdp2016  ///
xunion_2010s_1990   union_density2010s  minwage_rel_median2016 corporatetaxrate   incometaxrate  taxburdenofgdp   top_marginal_rate  ///
govtexpenditureofgdp progressivity_top_rate  tradefreedom  bal_share_gdp2016  xbal_share_gdp   ///
govCC govGE govPV govRL govRQ govVA freedom_score freedomfromcorruption fiscalfreedom businessfreedom laborfreedom monetaryfreedom tradefreedom investmentfreedom financialfreedom ///
gap90_50skill  skill ///
NOT_EQUAL pik_change avg_top1_2010_2016 avg_top1_1979_1981 ///
un_gini gini_change ///
Anxiety conf approve xconf_2017_2006  slow_growth slow_growth_high_ineq recession08_17 gr_gdp_pc_ppp1980_2017 

erase "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Draft\Appendix\OECD_Regress_Confidence_on_Growth_Inequality.csv"

cd "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Draft\Appendix\"
eststo clear
set more off

eststo:  reg xconf_2017_2006  un_gini recession08_17 
eststo:  reg xconf_2017_2006  un_gini recession08_17  change_imm_share  
eststo:  reg xconf_2017_2006  un_gini recession08_17  change_imm_share imm_share2015 diversity  
eststo:  reg xconf_2017_2006  un_gini recession08_17  change_imm_share imm_share2015 diversity  oecd_gdp_pc_ppp2017
eststo:  reg xconf_2017_2006  un_gini recession08_17  change_imm_share imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000
eststo:  reg xconf_2017_2006  un_gini recession08_17  change_imm_share imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 tertiary 
 
eststo:  reg Anxiety  un_gini recession08_17 
eststo:  reg approve  un_gini recession08_17 
eststo:  reg Anxiety  un_gini recession08_17  change_imm_share imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 tertiary  
eststo:  reg approve  un_gini recession08_17  change_imm_share imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 tertiary  

esttab using "OECD_Regress_Confidence_on_Growth_Inequality.csv", se(%9.4f)  star(* 0.05 ** 0.01)  ar2  replace

*Explain inequality-UN Gini
eststo clear
set more off

**tech
eststo: reg  un_gini   imm_share2015 diversity  oecd_tertiary
eststo: reg  un_gini   imm_share2015 diversity  patents_pop1000
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 oecd_tertiary
eststo: reg  avg_top1_2010_2016  imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary
**Labor share
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary  comp_share_gdp2016
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary  xcomp_share_gdp
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary  xcomp_share_gdp comp_share_gdp2016
**Unions
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary xunion_2010s_1990 
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary union_density2010s 
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary minwage_rel_median2016
*Taxes
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary corporatetaxrate 
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary incometaxrate  
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary  taxburdenofgdp 
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary  top_marginal_rate 
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary  progressivity_top_rate
**Trade
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary tradefreedom 
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary bal_share_gdp2016  
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary xbal_share_gdp  
**SKill
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary gap90_50skill
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary skill
**institutions

**Prof elites
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary sh_top1_manager 
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary sh_top1_prof_occ   
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary sh_top1_health
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary  manager_inc_ratio50 prof_inc_ratio50
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary  manager_inc_ratio90  prof_inc_ratio90
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary   prof_inc_ratio50
eststo: reg  un_gini   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary   prof_inc_ratio90

esttab using "OECD_Explain_UN_Gini.csv", se(%9.4f)  star(* 0.05 ** 0.01)  ar2  replace
eststo clear
set more off

erase "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Draft\Appendix\OECD_Explain_WID_Top1_Share.csv"

*Explain inequality-Piketty WID top1 shares
**tech
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_tertiary
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  patents_pop1000
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 oecd_tertiary
eststo: reg  avg_top1_2010_2016  imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary
**Labor share
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary  comp_share_gdp2016
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary  xcomp_share_gdp
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary  xcomp_share_gdp comp_share_gdp2016
**Unions
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary xunion_2010s_1990 
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary union_density2010s 
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary minwage_rel_median2016
*Taxes
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary corporatetaxrate 
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary incometaxrate  
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary  taxburdenofgdp 
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary  top_marginal_rate 
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary  progressivity_top_rate
**Trade
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary tradefreedom 
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary bal_share_gdp2016  
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary xbal_share_gdp  
**SKill
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary gap90_50skill
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary skill
**Prof elites
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary sh_top1_manager 
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary sh_top1_prof_occ   
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary sh_top1_health
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary  manager_inc_ratio50 
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary  manager_inc_ratio90  
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary   prof_inc_ratio50
eststo: reg  avg_top1_2010_2016   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary   prof_inc_ratio90

eststo: reg  NOT_EQUAL   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary sh_top1_manager 
eststo: reg  NOT_EQUAL   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary sh_top1_prof_occ   
eststo: reg  NOT_EQUAL   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary sh_top1_health
eststo: reg  NOT_EQUAL   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary  manager_inc_ratio50 
eststo: reg  NOT_EQUAL   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary  manager_inc_ratio90  
eststo: reg  NOT_EQUAL   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary   prof_inc_ratio50
eststo: reg  NOT_EQUAL   imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary   prof_inc_ratio90

esttab using "OECD_Explain_WID_Top1_Share.csv", se(%9.4f)  star(* 0.05 ** 0.01)  ar2  replace

**Correlations
foreach x in imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary ///
manager_inc_ratio50 manager_inc_ratio90 prof_inc_ratio50 prof_inc_ratio90 sh_top1_bus_services sh_top1_dentist sh_top1_doctor sh_top1_engin sh_top1_finance sh_top1_health_edu_pub sh_top1_lawyer sh_top1_legal sh_top1_manager_occ sh_top1_mfg_mining sh_top1_not_elite_occ sh_top1_prof_occ sh_top1_technicians ///
comp_share_gdp2016  xcomp_share_gdp   ///
xunion_2010s_1990   union_density2010s minwage_rel_median2016 corporatetaxrate   incometaxrate  taxburdenofgdp   top_marginal_rate  ///
progressivity_top_rate  tradefreedom  bal_share_gdp2016  xbal_share_gdp   ///
gap90_50skill  skill {
cor NOT_EQUAL `x'
gen CI`x'=r(rho)
gen NI`x'=r(N)
}


**Correlations
foreach x in imm_share2015 diversity  oecd_gdp_pc_ppp2017 patents_pop1000 oecd_tertiary ///
manager_inc_ratio50 manager_inc_ratio90 prof_inc_ratio50 prof_inc_ratio90 sh_top1_bus_services sh_top1_dentist sh_top1_doctor sh_top1_engin sh_top1_finance sh_top1_health_edu_pub sh_top1_lawyer sh_top1_legal sh_top1_manager_occ sh_top1_mfg_mining sh_top1_not_elite_occ sh_top1_prof_occ sh_top1_technicians ///
xcomp_share_gdp comp_share_gdp2016  ///
xunion_2010s_1990   union_density2010s minwage_rel_median2016 corporatetaxrate   incometaxrate  taxburdenofgdp   top_marginal_rate  ///
progressivity_top_rate  tradefreedom  bal_share_gdp2016  xbal_share_gdp   ///
gap90_50skill  skill {
cor gini_change `x'
gen CX`x'=r(rho)
gen NX`x'=r(N)
}

keep in 1
keep CI* NI* CX* NX*
aorder
outsheet using "OECD_Correlations_Inequality.csv", c replace


cor NOT_EQUAL rel_health_prices rel_housing_prices ppi_health ppi_grossdome ppi_housing ppi_education

cor NOT_EQUAL   freedom_score freedomfromcorruption fiscalfreedom businessfreedom laborfreedom monetaryfreedom tradefreedom investmentfreedom financialfreedom ///
govVA 

cor NOT_EQUAL Elite_regs  housing_health health_sh_gdp2016
