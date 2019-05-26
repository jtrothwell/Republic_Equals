*Luxembourg Income Study
use "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Luxembourg\LIS_share_top1_technicians.dta", clear
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
*LIS top1 shares
merge 1:1 country using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Luxembourg\LIS Top 1 Shares of Income by Country.dta"
drop _merge
*LUX Gini
merge 1:1 country using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Databases\Luxembourg\Gini_coefficients_LIS_ALL_OBS.dta"
drop _merge

aorder
order country

sum manager_inc_ratio50 manager_inc_ratio90 prof_inc_ratio50 prof_inc_ratio90 sh_top1_bus_services sh_top1_dentist sh_top1_doctor sh_top1_engin sh_top1_finance sh_top1_health_edu_pub sh_top1_lawyer sh_top1_legal_accounting_serv sh_top1_manager_occ sh_top1_mfg_mining sh_top1_not_elite_occ sh_top1_prof_occ sh_top1_technicians, sep(0)

foreach x in manager_inc_ratio50 manager_inc_ratio90 prof_inc_ratio50 prof_inc_ratio90 sh_top1_bus_services sh_top1_dentist sh_top1_doctor sh_top1_engin sh_top1_finance sh_top1_health_edu_pub sh_top1_lawyer sh_top1_legal_accounting_serv sh_top1_manager_occ sh_top1_mfg_mining sh_top1_not_elite_occ sh_top1_prof_occ sh_top1_technicians {
cor gini_lis_2010_2016 `x'
gen CG`x'=r(rho)
}

foreach x in manager_inc_ratio50 manager_inc_ratio90 prof_inc_ratio50 prof_inc_ratio90 sh_top1_bus_services sh_top1_dentist sh_top1_doctor sh_top1_engin sh_top1_finance sh_top1_health_edu_pub sh_top1_lawyer sh_top1_legal_accounting_serv sh_top1_manager_occ sh_top1_mfg_mining sh_top1_not_elite_occ sh_top1_prof_occ sh_top1_technicians {
cor lis_t1_sh_emp_wrkage `x'
gen CT`x'=r(rho)
}

sum C*, sep(0)

outsheet using "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Draft\Appendix\APPENDIX_LIS_OUTPUT--Composition of Top1 by Occupation & Sector by Country.csv", c replace
