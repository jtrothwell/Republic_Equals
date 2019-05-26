set more off
use "[DIRECTORY]\PISA\Cy6_ms_cmb_stu_qqq.dta", clear


egen math=rowmean(PV1MATH- PV10MATH)
egen read=rowmean(PV1READ- PV10READ)
egen sci=rowmean(PV1SCIE- PV10SCIE)
 
foreach x in math read sci {
egen z`x'=std(`x')
}
egen skill=rowmean(zmath zread zsci)

gen dad_ed=FISCED
replace dad_ed=. if FISCED>6
gen mom_ed=MISCED
replace mom_ed=. if MISCED>6
gen parent_ed=dad_ed
replace parent_ed=mom_ed if mom_ed>dad_ed & mom_ed!=.

gen parent_prime=1 if parent_ed<=1
replace parent_prime=0 if parent_ed>1 &  parent_ed<=6
gen parent_sec=1 if parent_ed>=2 &  parent_ed<=4
replace parent_sec=0 if parent_ed<2 |  parent_ed>4
replace parent_sec=. if parent_ed>6
gen parent_ter=1 if parent_ed>=5 & parent_ed!=.
replace parent_ter=0 if parent_ed<5


replace HISCED=. if HISCED>6

reg skill  HISCED  hisei [aw=W_FSTUWT]

gen native=1 if IMMIG==1
replace native=0 if IMMIG==2 | IMMIG==3

gen second_gen=1 if IMMIG==2
replace second_gen=0 if IMMIG==1 | IMMIG==3

ren ST012Q01TA num_tv
ren ST013Q01TA num_books
sum num_tv num_books

gen quiet=1 if ST011Q03TA==1
replace quiet=0 if ST011Q03TA==2

gen comp=1 if  ST011Q04TA==1
replace comp=0 if  ST011Q04TA==2

gen classic_lit=1 if ST011Q07TA==1
replace classic_lit=0 if ST011Q07TA==2

gen help_books=1 if ST011Q10TA==1
replace help_books=0 if ST011Q10TA==2

gen ref_books=1 if ST011Q11TA==1
replace ref_books=0 if ST011Q11TA==2

gen net=1 if ST011Q06TA==1
replace net=0 if ST011Q06TA==2


egen parent_sup=rowmean(ST123Q01NA ST123Q02NA ST123Q03NA ST123Q04NA)
gen parent_effort=ST123Q02NA

gen other_lang=1 if ST022Q01TA==2
replace other_lang=0 if ST022Q01TA==1


foreach x in ST097Q01TA ST097Q02TA ST097Q03TA ST097Q04TA ST097Q05TA ST098Q01TA ST098Q02TA ST098Q03NA ST098Q05TA ST098Q06TA ST098Q07TA ST098Q08NA ST098Q09TA ST098Q10NA ST100Q01TA ST100Q02TA ST100Q03TA ST100Q04TA ST100Q05TA ST103Q01NA ST103Q03NA ST103Q08NA ST103Q11NA ST104Q01NA ST104Q02NA ST104Q03NA ST104Q04NA ST104Q05NA ST107Q01NA ST107Q02NA ST107Q03NA  {
replace `x'=. if `x'>4
}

foreach x in ST078Q02NA ST078Q03NA ST078Q04NA ST078Q05NA ST078Q06NA {
replace `x'=. if `x'>2
}


egen sch_environ= rowmean(ST097Q01TA ST097Q02TA ST097Q03TA ST097Q04TA ST097Q05TA)
egen teach_environ= rowmean(ST098Q01TA ST098Q02TA ST098Q03NA ST098Q05TA ST098Q06TA ST098Q07TA ST098Q08NA ST098Q09TA ST098Q10NA ST100Q01TA ST100Q02TA ST100Q03TA ST100Q04TA ST100Q05TA ST103Q01NA ST103Q03NA ST103Q08NA ST103Q11NA ST104Q01NA ST104Q02NA ST104Q03NA ST104Q04NA ST104Q05NA ST107Q01NA ST107Q02NA ST107Q03NA)
gen study_after_sch=1 if ST078Q02NA==1 
replace study_after_sch=0 if ST078Q02NA==2

reg skill HISCED  hisei  num_books  classic_lit ref_books net ///
native second_gen quiet comp parent_effort other_lang    [aw=W_FSTUWT]
predict Adv
predict Sch_Q, residual

gen cntryid=CNTRYID
merge m:1 cntryid using "[DIRECTORY]\PISA\xwalk_country_name.dta"
drop _merge

collapse (first) cntryid_name wp_replace_name ///
(mean) skill teach_environ sch_environ Adv Sch_Q ///
(p10) p10skill=skill p10adv=Adv p10sq=Sch_Q p10SchEnv=sch_environ ///
(p25) p25skill=skill p25adv=Adv p25sq=Sch_Q p25SchEnv=sch_environ ///
(p50) p50skill=skill p50adv=Adv p50sq=Sch_Q p50SchEnv=sch_environ ///
(p75) p75skill=skill p75adv=Adv p75sq=Sch_Q p75SchEnv=sch_environ ///
(p90) p90skill=skill p90adv=Adv p90sq=Sch_Q p90SchEnv=sch_environ [aw=W_FSTUWT], by(CNTRYID)
order wp_replace_name

gen gap90_10skill=p90skill-p10skill
gen gap75_25skill=p75skill-p25skill
gen gap75_25sq=p75sq-p25sq

reg p25sq p25SchEnv

gsort -gap75_25sq
edit

gsort -gap75_25skil
edit

gsort -p25skill
edit

outsheet using "[DIRECTORY]\PISA\School_Inequality.csv", c  replace
ren cntryid_name country
save "[DIRECTORY]\PISA\School_Inequality.dta",  replace

