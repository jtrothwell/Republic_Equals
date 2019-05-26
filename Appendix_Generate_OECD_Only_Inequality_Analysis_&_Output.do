cd "[Directory]"
insheet using "Publish\Appendix_DATA_for_OECD_Analysis_of_Inequality.csv", clear

*Chapter 1 analysis of causes of top 1% income share level and change

*Change in inequality--using WID database (top 1% national income shares)
gen xtop99=end_top99-start_top99 

*Labor vs capital-change
foreach x in xcomp_share_gdp comp_share_gdp2016  laborfreedom corporatetaxrate minwage_rel_median2016 protect union_density2010s xunion_2010s_1990 {
reg xtop99 `x'
}
*Labor vs capital-Level
foreach x in xcomp_share_gdp comp_share_gdp2016  laborfreedom corporatetaxrate minwage_rel_median2016 protect union_density2010s xunion_2010s_1990 {
reg  end_top99 `x'
}

*globalization-change
foreach x in tariffrate tradefreedom bal_share_gdp2016 xbal_share_gdp imm_share2015 change_imm_share90_15  {
reg xtop99 `x'
}
*globalization-Level
foreach x in tariffrate tradefreedom bal_share_gdp2016 xbal_share_gdp imm_share2015 change_imm_share90_15 {
reg  end_top99 `x'
}


*Explain National government confidence
erase "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Draft\Appendix\OECD_Regress_Confidence_on_Growth_Inequality.csv"

cd "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Draft\Appendix\"
eststo clear
set more off

eststo:  reg xconf_2017_2006  un_gini recession08_17 
eststo:  reg xconf_2017_2006  un_gini recession08_17  diversity p_child_w_sp14 pop20_64_2011  patents_pop1000 oecd_tertiary tradefreedom 
eststo:  reg xconf_2017_2006  un_gini recession08_17  diversity p_child_w_sp14 pop20_64_2011  patents_pop1000 oecd_tertiary tradefreedom change_imm_share imm_share2015

eststo:  reg Anxiety  un_gini recession08_17 
eststo:  reg Anxiety   un_gini recession08_17  diversity p_child_w_sp14 pop20_64_2011  patents_pop1000 oecd_tertiary tradefreedom change_imm_share imm_share2015
eststo:  reg approve  un_gini recession08_17 
eststo:  reg approve   un_gini recession08_17  diversity p_child_w_sp14 pop20_64_2011  patents_pop1000 oecd_tertiary tradefreedom change_imm_share imm_share2015

esttab using "OECD_Regress_Confidence_on_Growth_Inequality.csv", se(%9.4f)  star(* 0.05 ** 0.01)  ar2  replace

*Explain inequality-UN Gini
erase "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Draft\Appendix\OECD_Explain_UN_Gini.csv"
eststo clear
set more off

foreach x in  manager_inc_ratio50 manager_inc_ratio90 prof_inc_ratio50 prof_inc_ratio90 sh_top1_bus_services sh_top1_dentist sh_top1_doctor sh_top1_engin sh_top1_finance sh_top1_health_edu_pub sh_top1_lawyer sh_top1_legal sh_top1_manager_occ sh_top1_mfg_mining sh_top1_not_elite_occ sh_top1_prof_occ sh_top1_technicians xhealth Elite_regs ///
xcomp_share_gdp comp_share_gdp2016  ///
xunion_2010s_1990  union_density2010s  minwage_rel_median2016 protect strict_regular_contracts_v3 training_exp_sh_gdp2015 ///
corporatetaxrate   incometaxrate  taxburdenofgdp   top_marginal_rate  ///
govtexpenditureofgdp progressivity_top_rate  ///
imm_share2015 change_imm_share90_15 tariffrate    bal_share_gdp2016  xbal_share_gdp   ///
govCC govGE govPV govRL govRQ govVA freedom_score freedomfromcorruption fiscalfreedom businessfreedom laborfreedom monetaryfreedom tradefreedom investmentfreedom financialfreedom ///
gap90_50skill  skill {
eststo: reg  un_gini  diversity p_child_w_sp14 pop20_64_2011  patents_pop1000 oecd_tertiary tradefreedom oecd_gdp_pc_ppp2017 ///
`x'
}
esttab using "OECD_Explain_UN_Gini.csv", se(%9.4f)  star(* 0.05 ** 0.01)  ar2  replace


*Explain inequality-Piketty WID top1 shares
erase "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Draft\Appendix\OECD_Explain_WID_Top1_Share.csv"

eststo clear
set more off

foreach x in  manager_inc_ratio50 manager_inc_ratio90 prof_inc_ratio50 prof_inc_ratio90 sh_top1_bus_services sh_top1_dentist sh_top1_doctor sh_top1_engin sh_top1_finance sh_top1_health_edu_pub sh_top1_lawyer sh_top1_legal sh_top1_manager_occ sh_top1_mfg_mining sh_top1_not_elite_occ sh_top1_prof_occ sh_top1_technicians xhealth Elite_regs ///
xcomp_share_gdp comp_share_gdp2016  ///
xunion_2010s_1990  union_density2010s  minwage_rel_median2016 protect strict_regular_contracts_v3 training_exp_sh_gdp2015 ///
corporatetaxrate   incometaxrate  taxburdenofgdp   top_marginal_rate  ///
govtexpenditureofgdp progressivity_top_rate  ///
imm_share2015 change_imm_share90_15 tariffrate  bal_share_gdp2016  xbal_share_gdp   ///
govCC govGE govPV govRL govRQ govVA freedom_score freedomfromcorruption fiscalfreedom businessfreedom laborfreedom monetaryfreedom tradefreedom investmentfreedom financialfreedom ///
gap90_50skill  skill {
eststo: reg  avg_top1_2010_2016  diversity p_child_w_sp14 pop20_64_2011  patents_pop1000 oecd_tertiary tradefreedom oecd_gdp_pc_ppp2017 ///
`x'
}
esttab using "OECD_Explain_WID_Top1_Share.csv", se(%9.4f)  star(* 0.05 ** 0.01)  ar2  replace

*Explain inequality-Combined index
*erase "G:\World_Poll\People\Jonathan_Rothwell\Personal_Data\BROOKINGS METRO\Book\Draft\Appendix\OECD_Explain_Inequality_Index.csv"

eststo clear
set more off

foreach x in  manager_inc_ratio50 manager_inc_ratio90 prof_inc_ratio50 prof_inc_ratio90 sh_top1_bus_services sh_top1_dentist sh_top1_doctor sh_top1_engin sh_top1_finance sh_top1_health_edu_pub sh_top1_lawyer sh_top1_legal sh_top1_manager_occ sh_top1_mfg_mining sh_top1_not_elite_occ sh_top1_prof_occ sh_top1_technicians xhealth Elite_regs ///
xcomp_share_gdp comp_share_gdp2016  ///
xunion_2010s_1990  union_density2010s  minwage_rel_median2016 protect strict_regular_contracts_v3 training_exp_sh_gdp2015 ///
corporatetaxrate   incometaxrate  taxburdenofgdp   top_marginal_rate  ///
govtexpenditureofgdp progressivity_top_rate  ///
imm_share2015 change_imm_share90_15 tariffrate  bal_share_gdp2016  xbal_share_gdp   ///
govCC govGE govPV govRL govRQ govVA freedom_score freedomfromcorruption fiscalfreedom businessfreedom laborfreedom monetaryfreedom tradefreedom investmentfreedom financialfreedom ///
gap90_50skill  skill {
eststo: reg  NOT_EQUAL  diversity p_child_w_sp14 pop20_64_2011  patents_pop1000 oecd_tertiary tradefreedom oecd_gdp_pc_ppp2017 ///
`x'
}
esttab using "OECD_Explain_Inequality_Index.csv", se(%9.4f)  star(* 0.05 ** 0.01)  ar2  replace

*Robustness checks
reg  un_gini  diversity  prof_inc_ratio90 xcomp_share_gdp
reg  un_gini  diversity  prof_inc_ratio90 xcomp_share_gdp patents_pop1000 
reg  NOT_EQUAL   diversity  prof_inc_ratio90 xcomp_share_gdp
reg  NOT_EQUAL   diversity  prof_inc_ratio90 xcomp_share_gdp patents_pop1000 
reg  avg_top1_2010_2016  diversity  prof_inc_ratio90 xcomp_share_gdp
reg  avg_top1_2010_2016  diversity  prof_inc_ratio90 xcomp_share_gdp patents_pop1000 


**Correlations--LEVEL
foreach x in diversity p_child_w_sp14 pop20_64_2011  patents_pop1000 oecd_tertiary oecd_gdp_pc_ppp2017 ///
manager_inc_ratio50 manager_inc_ratio90 prof_inc_ratio50 prof_inc_ratio90 sh_top1_bus_services sh_top1_dentist sh_top1_doctor sh_top1_engin sh_top1_finance sh_top1_health_edu_pub sh_top1_lawyer sh_top1_legal sh_top1_manager_occ sh_top1_mfg_mining sh_top1_not_elite_occ sh_top1_prof_occ sh_top1_technicians xhealth Elite_regs ///
xcomp_share_gdp comp_share_gdp2016  ///
xunion_2010s_1990  union_density2010s  minwage_rel_median2016 protect strict_regular_contracts_v3 training_exp_sh_gdp2015 ///
corporatetaxrate   incometaxrate  taxburdenofgdp   top_marginal_rate  ///
govtexpenditureofgdp progressivity_top_rate  ///
imm_share2015 change_imm_share90_15 tariffrate   bal_share_gdp2016  xbal_share_gdp   ///
govCC govGE govPV govRL govRQ govVA freedom_score freedomfromcorruption fiscalfreedom businessfreedom laborfreedom monetaryfreedom tradefreedom investmentfreedom financialfreedom ///
gap90_50skill  skill {
cor NOT_EQUAL `x'
gen CI`x'=r(rho)
gen NI`x'=r(N)
}


**Correlations-Change
foreach x in diversity p_child_w_sp14 pop20_64_2011  patents_pop1000 oecd_tertiary oecd_gdp_pc_ppp2017 ///
manager_inc_ratio50 manager_inc_ratio90 prof_inc_ratio50 prof_inc_ratio90 sh_top1_bus_services sh_top1_dentist sh_top1_doctor sh_top1_engin sh_top1_finance sh_top1_health_edu_pub sh_top1_lawyer sh_top1_legal sh_top1_manager_occ sh_top1_mfg_mining sh_top1_not_elite_occ sh_top1_prof_occ sh_top1_technicians xhealth Elite_regs ///
xcomp_share_gdp comp_share_gdp2016  ///
xunion_2010s_1990  union_density2010s  minwage_rel_median2016 protect strict_regular_contracts_v3 training_exp_sh_gdp2015 ///
corporatetaxrate   incometaxrate  taxburdenofgdp   top_marginal_rate  ///
govtexpenditureofgdp progressivity_top_rate  ///
imm_share2015 change_imm_share90_15 tariffrate   bal_share_gdp2016  xbal_share_gdp   ///
govCC govGE govPV govRL govRQ govVA freedom_score freedomfromcorruption fiscalfreedom businessfreedom laborfreedom monetaryfreedom tradefreedom investmentfreedom financialfreedom ///
gap90_50skill  skill {
cor gini_change `x'
gen CX`x'=r(rho)
gen NX`x'=r(N)
}

keep in 1
keep CI* NI* CX* NX*
aorder
outsheet using "OECD_Correlations_Inequality.csv", c replace


