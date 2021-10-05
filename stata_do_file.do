clear
import delimited "C:\Users\peppu\Documents\MyPythonProject\policy_evaluation\Spain\dairy.csv"



*(POOLED) OLS without a constant intercept
* nocons = no milk if all xs are zero
reg milk cows labor land feed, nocons
est store POLS1

*(POOLED) OLS without a constant intercept and time fixed effects
* nocons = no milk if all xs are zero
xi: reg milk cows labor land feed i.year, nocons
est store POLS2

xtset farm year

* Panel description of dataset
xtdescribe

* Panel summary statistics: within and between variation
xtsum farm year milk cows land labor feed

* heterogeneity across years
bysort year: egen milk_mean=mean(milk)
twoway scatter milk year, msymbol(circle_hollow) || connected milk_mean year,
msymbol(diamond) || , xlabel(93(1)98)

* heterogeneity across farms
bysort farm: egen milk_mean_2=mean(milk)
twoway scatter milk farm, msymbol(circle_hollow) || connected milk_mean_2 farm

xtreg milk cows labor land feed i.year, fe vce(cluster farm) /* note we lose one additional year dummy because exp is included */
est store FE





* Backup
egen mean_cows = mean(cows)
gen cows_c = cows - mean_cows
egen mean_labor = mean(labor)
gen labor_c = labor - mean_labor
egen mean_feed = mean(feed)
gen feed_c = feed - mean_feed
egen mean_land = mean(land)
gen land_c = land - mean_land

reg milk cows labor land feed
estat vif

reg milk cows_c labor_c land_c feed_c
estat vif

gen cows_r = cows/cows
gen labor_r = labor/cows
gen feed_r = feed/cows
gen land_r = land/cows

gen cows_labor = cows*labor
reg milk cows labor land cows_labor, nocons
xi: reg milk cows labor land cows_labor i.year, nocons
xtreg milk cows labor land cows_labor i.year, fe


reg milk cows labor_r land, nocons
xi: reg milk cows labor_r land i.year, nocons
xtreg milk cows labor_r land i.year, fe



gen milk_per_cow = milk/cows
gen feed_per_cow = feed/cows

reg milk_per_cow labor land feed_per_cow, nocons
xi: reg milk_per_cow labor land feed_per_cow i.year, nocons
xtset farm year
xtreg milk_per_cow labor land feed_per_cow i.year, fe


