/*
	This do file creates necessary variables for high frequency checks.	
	It also pulls data from FUP4 for comparison. 
	These values come from 1611_wb_lwh_data01.
	
	This do file creates "$data\lwh_oi_endline_clean_01.dta".
	
	This do file is part of Master_import_bc_hfc.do.

*/


	use "$data\lwh_oi_endline_clean_00.dta", clear
	label var sample "Sample"

	*----------------
	* Datetime fields
	*----------------
	
	* Format date vars from string to date expression
	foreach dtvar of varlist starttime* endtime* submissiondate* {
		tempvar tempdtvar
		rename `dtvar' `tempdtvar'
		gen double `dtvar'=.
		cap replace `dtvar'=clock(`tempdtvar',"MDYhms",2025)
		cap replace `dtvar'=clock(`tempdtvar',"MDYhm",2025) if `dtvar'==. & `tempdtvar'~=""
		format %tc `dtvar'
		drop `tempdtvar'
		}

	* Addition date/time fields
	gen today = td(`c(current_date)') //useful for quick checks as in "browse if date == today"
	label var today "Today"
	rename submissiondate submission //timestamp when interview was received by server
	gen date = dofc(starttime) //Date of interview
	label var date "Date of interview"
	gen date_submit = dofc(submission) //Date when interview was received by server
	label var date_submit "Date when interview was received by server"
	format date %td
	format date_submit %td

	gen day = dow(date)
	label define day 0 "Sunday" 1 "Monday" 2 "Tuesday" 3 "Wednesday" 4 "Thursday" 5 "Friday" 6 "Saturday"
	label values day day

	gen delay = round(minutes(submission-endtime)) //minutes between when interview was finished and received by server

	replace duration = duration / 60 //duration in minutes


	*---------------------------------	
	* Label variables for backchecking
	*---------------------------------	
	label var lab_02_1 "Paid agricultural labor season A"
	label var lab_02_2 "Paid agricultural labor season B"
	label var lab_02_3 "Paid agricultural labor season C"

	label var lab_04_1 "Paid public works labor season A"
	label var lab_04_2 "Paid public works labor season B"
	label var lab_04_3 "Paid public works labor season C"

	label var lab_07_1 "Other paid work season A"
	label var lab_07_2 "Other paid work season B"
	label var lab_07_3 "Other paid work season C"

	* cooperative substription fees
	label var gr_26 "Cooperative substription fees"

	* water user association substription fees
	label var gr_37 "Water user association substription fees"

	* amount of formal savings
	label var rf_2 "Household formal savings"

	* amount of informal savings
	label var rf_4 "Household informal savings"

	* total amount borrowed
	label var rf_6 "Total amount borrowed"

	* frequency no food in the past 30 days
	label var fs_02 "Frequency no food in the past 30 days"

	* frequency of hunger in the past 30 days 
	label var fs_04 "Frequency hunger in the past 30 days"

	* frequency of no food day and night in the past 30 days
	label var fs_06 "Frequency of no food day and night in the past 30 days"

	*---------------	
	* Missing values
	*---------------
	foreach var of varlist amount_total_* {
		replace `var' = . if `var' < 0 //missing value in calculation
	}

	ds *gps* delay, not
	ds `r(varlist)', has(type numeric)
	gen n_miss = 0
	label var n_miss "Number of missing variables"
	foreach var of varlist `r(varlist)' {
		replace `var' = .a if `var' == - 88
		replace `var' = .b if `var' == - 66
		replace n_miss = n_miss + 1 if `var' > .
	}			
			
	*---------------------
	* Clean for data check
	*---------------------
	
	* GPS
	foreach var of varlist gps_*{
		local varname = subinstr("`var'","Latitude","_latitude",.)
		local varname = subinstr("`varname'","Longitude","_longitude",.)
		local varname = subinstr("`varname'","Accuracy","_accuracy",.)
		local varname = subinstr("`varname'","Altitude","_altitude",.)
		rename `var' `varname'
	}

	* Enumerators
	cap tostring enumeratorother, replace
	replace enumerator = enumeratorother if enumerator == "OTHER" & enumeratorother != ""
	replace enumerator = trim(upper(enumerator))

	* Teams
	clonevar team_entered =  team
	sort enumerator starttime
	tempvar N n
	bysort enumerator: gen `N' = _N
	bysort enumerator: gen `n' = _n
	levelsof enumerator, clean local(enumerators)

	foreach enumerator in `enumerators' {
		levelsof team if enumerator == "`enumerator'" & `N' == `n', clean local(team)
		replace team = "`team'" if enumerator == "`enumerator'"
	}
	drop `N' `n'

	* id_12
	cap destring id_12, force replace
	gen id_12_str = string(id_12, "%16.0f")
	local varlabel : var label id_12
	label var id_12_str "`varlabel'"
	order id_12_str, after(id_12)	
	
	*------------------------------------
	* Create new variables for data check
	*------------------------------------
	
	* GPS Area points
	qui sum count_join // Using count_join because we are only measuring the unmatched plots which may be less than 6 plots.
	local plot_num_max = `r(max)'
	forvalues i = 1 / `plot_num_max' {
		gen n_areapoints_`i' = .
		forvalues j = 1 / 100 {
			cap replace n_areapoints_`i' = `j' if gps_arealatitude_`i'_`j' < .
		}
		label var n_areapoints_`i' "Points per Plot `i'"
	}
	egen stats_avg_n_areapoints = rowmean(n_areapoints_*)
	label var stats_avg_n_areapoints "Avg Points per Plot"
	egen stats_max_n_areapoints = rowmax(n_areapoints_*)
	label var stats_max_n_areapoints "Max Points per Plot"

	* Agricultural Profits
	egen stats_w_profit_agric_a = rowtotal(crp_10_16_*_1_*)
	egen stats_w_profit_agric_b = rowtotal(crp_10_16_*_2_*)
	egen stats_w_profit_agric_c = rowtotal(crp_10_16_*_3_*)
	label var stats_w_profit_agric_a "Profit Agric A"
	label var stats_w_profit_agric_b "Profit Agric B"
	label var stats_w_profit_agric_c "Profit Agric C"
	
	* Harvest
	egen stats_w_total_val_harvested_a = rowtotal(amount_harvest_*_1_*)
	egen stats_w_total_val_harvested_b = rowtotal(amount_harvest_*_2_*)
	egen stats_w_total_val_harvested_c = rowtotal(amount_harvest_*_3_*)
	label var stats_w_total_val_harvested_a "Harvest A"
	label var stats_w_total_val_harvested_b "Harvest B"
	label var stats_w_total_val_harvested_c "Harvest C"

	* Area
	preserve 
		* Getting areas for matched plots from the last survey
		use "$fup4_data/Clean/fup4_clean.dta", clear
		keep id_05 area_?
		rename area_? fup4_area_?
		tempfile temp
		save `temp'
	restore
	mmerge id_05 using `temp', unmatched(master) // For comparison, it's better to add on the area values from the last survey.
	forvalues i = 1 / `plot_num_max' {
		replace area_`i' = . if area_`i' == 0
	}
	egen stats_area_plots = rowmean(area_? fup4_area_?)
	label var stats_area_plots "Area"
	
	* GPS Accuracy
	egen stats_accuracy = rowmax(gps_areaaccuracy_* gps_hhaccuracy)
	label var stats_accuracy "Accuracy"

	* Cooperative
	gen stats_mem_coop = gr_aa
	label var stats_mem_coop "Cooperative"
	
	* Public extension
	gen stats_public_ext_visit_a = ex_02_1_3
	gen stats_public_ext_visit_b = ex_02_2_3
	gen stats_public_ext_visit_c = ex_02_3_3
	label var stats_public_ext_visit_a "Public Extension Worker A"
	label var stats_public_ext_visit_b "Public Extension Worker B"
	label var stats_public_ext_visit_c "Public Extension Worker C"

	* Tubura
	gen stats_fo_tubura_visit_a = ex_02_1_4
	gen stats_fo_tubura_visit_b = ex_02_2_4
	gen stats_fo_tubura_visit_c = ex_02_3_4
	label var stats_fo_tubura_visit_a "Tubura A"
	label var stats_fo_tubura_visit_b "Tubura B"
	label var stats_fo_tubura_visit_c "Tubura C"	
	
	* Terraced
	egen stats_any_plots_terraced = rowmax(pl_t1_*)
	label var stats_any_plots_terraced "Terraced"

	* Irrigation
	egen stats_any_irrigation_a = rowmax(pl_16_16_*_1)
	egen stats_any_irrigation_b = rowmax(pl_16_16_*_2)
	egen stats_any_irrigation_c = rowmax(pl_16_16_*_3)
	label var stats_any_irrigation_a "Irrigation A"
	label var stats_any_irrigation_b "Irrigation B"
	label var stats_any_irrigation_c "Irrigation C"

	* Formal Account
	gen stats_formal_account = rf_1
	label var stats_formal_account "Account"
	
	* Any savings
	gen stats_any_form_savings = rf_2 > 0 & rf_2 < . | rf_4 > 0 & rf_4 < .
	label var stats_any_form_savings "Savings"
		
	* Income LWH
	egen stats_w_inc_lwh = rowtotal(inc_12-inc_14)
	label var stats_w_inc_lwh "LWH Income"

	* Income Total
	egen stats_w_income_total = rowtotal(inc_01-inc_17)
	label var stats_w_income_total "Total Income"
	
	* Crops
	egen stats_crops = rowtotal(ag9n_16_*)
	label var stats_crops "Crops"

	* Plots
	gen stats_plots = plots
	label var stats_plots "Plots"

	* Spent on Seeds
	egen stats_seeds = rowtotal(crp_06_16_*)
	label var stats_seeds "Seeds"

	* Harvest
	egen stats_harvest = rowtotal(amount_harvest_*)
	label var stats_harvest "Harvest"

	* No Harvest
	gen stats_noharvest = stats_harvest == 0 | stats_harvest == .
	label var stats_noharvest "No Harvest"

	* total no. of days household members spent on land prepapration
	egen stats_total_land_prep = rowtotal(ag_16_x_16_*)
	label var stats_total_land_prep "Total number of days household members spent on land preparation"

	* total amount spent on labour on land preparation
	egen stats_total_h_labour = rowtotal(ag_18_*_16_*)
	label var stats_total_h_labour "Total amount spent on hired labour for land preparation"

	* total no. of days household members spent on growing
	egen stats_total_growing = rowtotal(ag_16_y_16_*)
	label var stats_total_growing "Total number of days household members spent on growing"

	* total no. of days household members spent on harvesting
	egen stats_total_harvesting = rowtotal(ag_16_z_16_*)
	label var stats_total_harvesting "Total number of days household members spent on harvesting"

	* total no. of extension visits per season

	forvalues i = 1 / 3 {
		if `i' == 1 local season A
		if `i' == 2 local season B
		if `i' == 3 local season C

		egen n_extension_visits_`i' = rowtotal(ex_03_`i'_*)
		label var n_extension_visits_`i' "Number of extension visits Season `season'"
	}

	* total weekly food expenditure
	egen stats_w_food_exp = rowtotal(exp_29_*)
	label var stats_w_food_exp "Total weekly food expenditure"

	* total crop earnings per season
	egen stats_crop_earn_a = rowtotal(crp_10_16_*_1_*)
	egen stats_crop_earn_b = rowtotal(crp_10_16_*_2_*)
	egen stats_crop_earn_c = rowtotal(crp_10_16_*_3_*)
	label var stats_crop_earn_a "Total earnings crop sells Season A"
	label var stats_crop_earn_b "Total earnings crop sells Season B"
	label var stats_crop_earn_c "Total earnings crop sells Season C"

	*---------------------------
	* Creat monitoring variables
	*---------------------------
	
	* Duration
	gen check_duration = duration <= 90 & consent == 1 // Not using consent_general because we care lees about how long it took durin the ID module.
	label var check_duration "Check: Duration"

	* GPS
	forvalues i = 1 / `plot_num_max' {
		levelsof gps_arealatitude_`i'_1, clean local(isplot)
		if "`isplot'" != "" {
			gen check_gps_plot_`i' = 0 if gps_arealatitude_`i'_1 < .
			foreach var of varlist gps_areaaccuracy_`i'_* {
				replace check_gps_plot_`i' = 1 if `var' > 3 & `var' < . 
			}
			label var check_gps_plot_`i' "Check: GPS Plot `i'"
		}
	}
	egen check_gps_plot = rowmax(check_gps_plot_*)
	replace check_gps_plot = 0 if check_gps_plot == .
	label var check_gps_plot "Check: GPS Plot"

	gen check_gps_hh = gps_hhaccuracy > 3 & gps_hhaccuracy < .
	label var check_gps_hh "Check: GPS Household"

	egen check_gps = rowmax(check_gps_hh check_gps_plot)
	label var check_gps "Check: GPS"

	* Plot unavailable
	gen check_area = 0
	forvalues i = 1 / `plot_num_max' {
		replace check_area = 1 if area_available_`i' == 0
	}
	label var check_area "Check: Plot unavailable"

	* Distance
	geodist gps_hhlatitude gps_hhlongitude sample_gps_latitude sample_gps_longitude if gps_hhlatitude < . & sample_gps_latitude < ., gen(distance)
	replace distance = distance * 1000
	label var distance "Distance between GPS points"

	gen check_distance = distance > (sample_gps_accuracy + gps_hhaccuracy + 20) & distance < .
	label var check_distance "Check: Distance"

	* Number of unmatched plots
	clonevar num_plot_unmatched = count_join
	label var num_plot_unmatched "Number of unmatched plots"
	
	* Number of unmatched plots measured
	egen plots_measured = rowtotal(area_available_*)
	gen ratio_plots_measured = plots_measured / num_plot_unmatched // Demoninator must be unmactehd plots because we decided to measure only if unmatched.
	gen check_measured = ratio_plots_measured < 0.66
	label var plots_measured "Number of unmatched plots measured"
	label var ratio_plots_measured "Ratio of unmatched plots measured"
	label var check_measured "Check: Not Measured"

	* Zero cultivation, per season
	forvalues i = 1 / 3 {
		if `i' == 1 local season A
		if `i' == 2 local season B
		if `i' == 3 local season C

		egen check_cultivation_`i' = rowmax(ag8_16_*_`i')
		recode check_cultivation_`i' (1 = 0) (0 = 1)
		label var check_cultivation_`i' "Check: No Cultivation Season `season'"

	}

	* Zero harvest, crop level
	gen check_harvest = 0 if check_cultivation_1 == 0 | check_cultivation_2 == 0 | check_cultivation_3 == 0
	foreach var of varlist crp_08_q_16_* {
		replace check_harvest = 1 if `var' == 0
	}
	label var check_harvest "Check: No Harvest (at least one crop)"

	forvalues i = 1 / 6 {
		recode ag8_16_`i'_1 (0=1) (1=0), g(nocultv_`i'_1)
		recode ag8_16_`i'_2 (0=1) (1=0), g(nocultv_`i'_2)
		recode ag8_16_`i'_3 (0=1) (1=0), g(nocultv_`i'_3)
	}

	* Outliers
	local numerical1 "stats_w_profit_agric_a stats_w_profit_agric_b stats_w_profit_agric_c stats_w_total_val_harvested_a stats_w_total_val_harvested_b stats_w_total_val_harvested_c"
	local numerical2 "hhsize stats_total_land_prep stats_total_h_labour stats_total_harvesting n_extension_visits_1 n_extension_visits_2 n_extension_visits_3" 
	local numerical3 "stats_crop_earn_a stats_crop_earn_b stats_crop_earn_c lab_02_* lab_04_* lab_07_*"
	local numerical4 "gr_26 gr_37 rf_2 rf_4 rf_6 fs_02 fs_04 fs_06"

	foreach var of varlist `numerical1' `numerical2' `numerical3' `numerical4' {
		qui sum `var' if `var' > 0 & `var' < ., detail
		local varname = subinstr("`var'","_harvested_","_h_",.)
		gen check_out_`varname' = `var' < r(mean) - 3*r(sd) | `var' > r(mean) + 3*r(sd) if `var' < .
		label var check_out_`varname' "Check: Outlier `var'"
	}

	egen check_out = rowmax(check_out_*)
	label var check_out "Check: Outlier"

	egen check = rowmax(check_gps check_duration check_area check_distance)
	label var check "Check"

	* Status
	gen status_obs = 1 if consent == 1
	replace status_obs = 2 if first_appointment == 1 | second_appointment == 1 | third_appointment == 1
	replace status_obs = 3 if status_obs == .

	bysort id_05: egen status_id = min(status_obs)
	label var status_obs "Status: Observation"
	label var status_id "Status: Household"

	label define status 1 "Complete" 2 "Revisit" 3 "Unavailable" 4 "Open"
	label values status_obs status
	label values status_id status

	gen check_rf1 = .
	replace check_rf = 0 if rf_consent == 1 | rf_consent == 0 | inc_01 != . | consent == 0 | consent == . 
	replace check_rf = 1 if check_rf == . & inc_01 == . 
	label var check_rf "Check: RF section not completed - Original"

	gen check_fs1 = .
	replace check_fs = 0 if fs_consent == 1 | (calc_over18f == 0 & calc_over18f_fix ==.) | calc_over18f_fix == 0 | fs_consent == 0 | fs_01 != . | consent == 0 | consent == . 
	replace check_fs = 1 if check_fs == . & consent == 1 & fs_01 == . 
	label var check_fs "Check: FS section not completed - Original"

	* Additional labelling
	label var pl_sample "Preload: HH Code in Sample"

	label var gps_hhlatitude "GPS HH: Latitude"
	label var gps_hhlongitude "GPS HH: Longitude" 
	label var gps_hhaltitude "GPS HH: Altitude" 
	label var gps_hhaccuracy "GPS HH: Accuracy"

	label var calc_repeat_old "Preload: Household size (adjusted)"
	foreach var of varlist oldplot_* {
		local i = substr("`var'",-1,1)
		label var `var' "Preload: Plot `i'"
	}
	label var hhh_notes "Notes about the change or move in HH head"
	label var consent "Do you agree with the consent?"
	label var audio_consent "Does the respondent consent to the audio audit?"
	label var calc_first_date "Return date/time - 1st"
	label var calc_second_date "Return date/time - 2nd"
	label var calc_third_date "Return date/time - 3rd"
	label var audio_audit "Audio recording link"
	foreach var of varlist pl_name_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Preload: Name `i'"
	}
	foreach var of varlist pl_age_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Preload: Age `i'"
	}
	foreach var of varlist pl_sex_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Preload: Sex `i'"
	}
	foreach var of varlist pl_sex_str_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Preload: Sex `i' (string)"
	}
	foreach var of varlist member_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Is member `i' still a member of this household?"
	}
	foreach var of varlist leave_? leave_?? {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Why did member `i' leave?"
	}
	
	foreach var of varlist leave_1_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Left HH: School `i'"
	}
	foreach var of varlist leave_2_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Left HH: Marriage `i'"
	}
	foreach var of varlist leave_3_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Left HH: Divorce `i'"
	}
	foreach var of varlist leave_4_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Left HH: Deceased `i'"
	}
	foreach var of varlist leave_5_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Left HH: Work `i'"
	}
	foreach var of varlist leave_999_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Left HH: Other `i'"
	}
	
	foreach var of varlist check_age_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Is member `i''s age correct according to records"
	}
	foreach var of varlist correct_age_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "What is member `i''s correct age?"
	}
	foreach var of varlist fix_age_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Is member `i''s age accurate?"
	}
	foreach var of varlist age_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Age `i'"
	}
	foreach var of varlist check_gender* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Is member `i''s gender correct according to our records?"
	}
	foreach var of varlist check_over18* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Is member `i' over 18?"
	}
	foreach var of varlist check_over18* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Is member `i' over 18?"
	}
	foreach var of varlist school_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Is member `i' currently attending school?"
	}
	foreach var of varlist education_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "What is member `i''s highest education level completed?"
	}
	foreach var of varlist calc_get_roster_old_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Name & age `i'"
	}
	foreach var of varlist calc_over18f_old_fix_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Over 18 female `i' (Fix)"
	}
	foreach var of varlist calc_over18_old_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Over 18 - `i'"
	}
	foreach var of varlist calc_over18f_old_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Over 18 female `i'"
	}
	
	label var n_left "Number of members who left household"
	label var check_left "Is the number of member who left the household correct?"
	label var hh_new "Have any HH members been added since the last survey?"
	label var new "How many HH members have been added since the last survey?"
	label var hhsize "How many people live in this household?"
	drop g_roster_new_count //identical to variable new


	foreach var of varlist calc_index_new_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Roster ID - new `i'"
	}
	foreach var of varlist name_new_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Name - new `i'"
	}
	foreach var of varlist name_new_first_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Given name - new `i'"
	}
	foreach var of varlist name_new_last_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Surname - new `i'"
	}
	foreach var of varlist relationship_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Relationship to HH head - new `i'"
	}
	foreach var of varlist why_add_* {
	if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Reason for addition to HH - new `i'"
	}
	
	foreach var of varlist why_add_1_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Added HH: School - new `i'"
	}
	foreach var of varlist why_add_2_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Added HH: Marriage - new `i'"
	}
	foreach var of varlist why_add_3_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Added HH: Divorce - new `i'"
	}
	foreach var of varlist why_add_4_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Added HH: Born - new `i'"
	}
	foreach var of varlist why_add_5_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Added HH: Work - new `i'"
	}
	foreach var of varlist why_add_6_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Added HH: Hunger - new `i'"
	}
	foreach var of varlist why_add_999_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Added HH: Other - new `i'"
	}
	
	foreach var of varlist sex_new_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Gender - new `i'"
	}
	foreach var of varlist age_new_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Age - new `i'"
	}
	foreach var of varlist fix_age_new_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Age correct?  - new `i'"
	}
	foreach var of varlist check_over18_new_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Is new `i' age 18 or over?"
	}
	foreach var of varlist calc_over18_new_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Over 18 - new `i'"
	}
	foreach var of varlist calc_over18f_new_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Over 18 female - new `i'"
	}
	foreach var of varlist school_new_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Attending school - new `i'"
	}
	foreach var of varlist education_new_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Highest qualification - new `i'"
	}
	foreach var of varlist calc_get_roster_new_* {
		if regexm("`var'", "[0-9][0-9]$") == 1{
		local i = substr("`var'",-2,2)
		}
		else local i = substr("`var'",-1,1)
		label var `var' "Name & age - new `i'"
	}
	
	label var calc_over18f "Adult females (18+)(n)"
	label var calc_over18f_fix "Adult females (18+)(n) fix"

	* Plots
	foreach var of varlist plotname_* {
		local i = substr("`var'",-1,1)
		label var `var' "Name: Plot `i'"
	}
	foreach var of varlist plotmatch_*_* {
		local i = substr("`var'",-3,1)
		local j = substr("`var'",-1,1)
		label var `var' "Plot `i' matches old plot `j'"
	}
	foreach var of varlist plotmatch_*_0{
		local i = substr("`var'",-3,1)
		label var `var' "Plot `i' has no matching plot"
	}
	drop g_plotrepeat_count //identical to calc_plots
	drop calc_plotname_* //identical to plotname_*

	forvalues num = 1 / 6 {
		gen ag6_`num' = round((ag6n_`num' * 4046.86), 0.1) if ag6u_`num' == 1
		replace ag6_`num' = round((ag6n_`num' * 10000), 0.1) if ag6u_`num' == 2
		replace ag6_`num' = round((ag6n_`num' * 1), 0.1) if ag6u_`num' == 3
		replace ag6_`num' = round((ag6n_`num' * 24281.1), 0.1)  if ag6u_`num' == 4
		order ag6_`num', before(ag6u_`num')
	}
	foreach var of varlist ag6_1 ag6_2 ag6_3 ag6_4 ag6_5 ag6_6 {
		local i = substr("`var'",-1,1)
		label var `var' "P`i' Area (Sq m)"
	}
	foreach var of varlist ag7_* {
		local i = substr("`var'",-1,1)
		label var `var' "P`i' What is the source  of the plot area data?"
	}
	foreach var of varlist ag_coop_* {
		local i = substr("`var'",-1,1)
		label var `var' "P`i' Was this plot cultivated for [COOP NAME]?"
	}
	foreach var of varlist ag_coop2_* {
		local i = substr("`var'",-1,1)
		label var `var' "P`i' Was this plot cultivated for a cooperative?"
	}
	foreach var of varlist coop_exists_* {
		local i = substr("`var'",-1,1)
		label var `var' "P`i' Does [COOP NAME] still exist?"
	}
	foreach var of varlist coop_name_* {
		local i = substr("`var'",-1,1)
		label var `var' "P`i' What is the name of this cooperative?"
	}
	foreach var of varlist pl_36_* {
		local i = substr("`var'",-1,1)
		label var `var' "P`i' What percentage of the plot was terraced?"
	}
	foreach var of varlist calc_season_*_1 {
		local i = substr("`var'",-1,1)
		label var `var' "Name: Plot `i'"
	}
	foreach var of varlist ag8_16_*_1 {
		local i = substr("`var'",-3,1)
		label var `var' "P`i' Did you cultivate seasonal crops on this plot during Season A: Sep'15-Feb'16?"
	}
	foreach var of varlist ag8_16_*_2 {
		local i = substr("`var'",-3,1)
		label var `var' "P`i' Did you cultivate seasonal crops on this plot during Season B: Mar-Jun 2016?"
	}
	foreach var of varlist ag8_16_*_3 {
		local i = substr("`var'",-3,1)
		label var `var' "P`i' Did you cultivate seasonal crops on this plot during Season C: Jul-Aug 2016?"
	}
	
	foreach var of varlist ag9n_16_*_1 {
		local i = substr("`var'",-3,1)
		label var `var' "P`i' A: How many seasonal crops did you cultivate on this plot during Season A?"
	}
	foreach var of varlist ag9n_16_*_2 {
		local i = substr("`var'",-3,1)
		label var `var' "P`i' B: How many seasonal crops did you cultivate on this plot during Season B?"
	}
	foreach var of varlist ag9n_16_*_3 {
		local i = substr("`var'",-3,1)
		label var `var' "P`i' C: How many seasonal crops did you cultivate on this plot during Season C?"
	}
	foreach var of varlist ag10_16_*_1 {
		local i = substr("`var'",-3,1)
		label var `var' "P`i' A: Who was primarily responsible for making decisions about this plot?"
	}
	foreach var of varlist ag10_16_*_2 {
		local i = substr("`var'",-3,1)
		label var `var' "P`i' B: Who was primarily responsible for making decisions about this plot?"
	}
	foreach var of varlist ag10_16_*_3 {
		local i = substr("`var'",-3,1)
		label var `var' "P`i' C: Who was primarily responsible for making decisions about this plot?"
	}
	foreach var of varlist ag11_16_*_1 {
		local i = substr("`var'",-3,1)
		label var `var' "P`i' A: Who spent most time working on this plot during season A?"
	}
	foreach var of varlist ag11_16_*_1 {
		local i = substr("`var'",-3,1)
		label var `var' "P`i' A: Who spent most time working on this plot during season A?"
	}

	foreach var of varlist ag9_16c1_*_1 {
		local i = substr("`var'",-3,1)
		label var `var' "P`i' A: Crop 1 (Most important)"
	}
	foreach var of varlist ag9_16c2_*_1 {
		local i = substr("`var'",-3,1)
		label var `var' "P`i' A: Crop 2 (Second most important)"
	}
	foreach var of varlist ag9_16c3_*_1 {
		local i = substr("`var'",-3,1)
		label var `var' "P`i' A: Crop 3 (Third most important)"
	}
	foreach var of varlist ag9_16c1_*_2 {
		local i = substr("`var'",-3,1)
		label var `var' "P`i' B: Crop 1 (Most important)"
	}
	foreach var of varlist ag9_16c2_*_2 {
		local i = substr("`var'",-3,1)
		label var `var' "P`i' B: Crop 2 (Second most important)"
	}
	foreach var of varlist ag9_16c3_*_2 {
		local i = substr("`var'",-3,1)
		label var `var' "P`i' B: Crop 3 (Third most important)"
	}
	foreach var of varlist ag9_16c1_*_3 {
		local i = substr("`var'",-3,1)
		label var `var' "P`i' C: Crop 1 (Most important)"
	}
	foreach var of varlist ag9_16c2_*_3 {
		local i = substr("`var'",-3,1)
		label var `var' "P`i' C: Crop 2 (Second most important)"
	}
	foreach var of varlist ag9_16c3_*_3 {
		local i = substr("`var'",-3,1)
		label var `var' "P`i' C: Crop 3 (Third most important)"
	}
	foreach var of varlist crp_02_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': In which month did you plant Crop `k'?"
	}
	foreach var of varlist crp_03_q_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': On what percentage of plot `i' did you grow Crop `k'?"
	}
	label define quantity_units 1 "Kg" 2 "25kg sack" 3 "50kg sack" 4 "100kg sack" 5 "Grams" 6 "Tons" 13 "Mironko (1.5kg)" 14 "Bucket (2.5kg)" 15 "Bucket (5kg)" 16 "10kg basket" 17 "15kg basket" 11 "Wheelbarrow", modify
	label val crp_04_u_16_* crp_08_u_16_* crp_08_gu_16_* crp_08_du_16_* crp_09_u_16_* crp_09_gu_16_* crp_09_du_16_* crp_15_u_16_* crp_15_gu_16_* crp_15_du_16_* crp_25_u_16_* crp_25_gu_16_* crp_25_du_16_* quantity_units
	foreach var of varlist crp_04_q_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': How much Crop `k' seed did you plant in Plot `i'(amt)?"
	}
	foreach var of varlist crp_04_u_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': How much Crop `k' seed did you plant in Plot `i'(unit)?"
	}
	foreach var of varlist crp_05_a_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': What was the source of the seed for Crop `k'?"
	}
	foreach var of varlist crp_05_a_16_* {
		if substr("`var'",-8,2) == "_1" local m "TUBURA"
		else if substr("`var'",-8,2) == "_2" local m "LWH Project"
		else if substr("`var'",-8,2) == "_3" local m "Local government"
		else if substr("`var'",-8,2) == "_4" local m "NGO"
		else if substr("`var'",-8,2) == "_5" local m "Agrodila"
		else if substr("`var'",-8,2) == "_6" local m "CIP"
		else if substr("`var'",-8,2) == "_7" local m "Own production"
		else if substr("`var'",-8,2) == "_8" local m "Neighbour/Friend"
		else if substr("`var'",-8,2) == "_9" local m "RAB"
		else if substr("`var'",-8,2) == "10" local m "Agricultural cooperative"
		else if substr("`var'",-8,2) == "11" local m "Gift"
		else if substr("`var'",-8,2) == "12" local m "Local market"
		else if substr("`var'",-8,2) == "99" local m "Other"
		else if substr("`var'",-8,2) == "66" local m "Refuse"
		else local m "Don't know"
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Seed source: `m'"
	}
	foreach var of varlist crp_06_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': How much did you spend on the seed planted in this plot? (Total RWF)?"
	}
	foreach var of varlist proportion_gift_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': What percentage of the seed for Crop `k' was a gift?"
	}
	foreach var of varlist proportion_own_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': What percentage of the seed for Crop `k' was own production?"
	}
	foreach var of varlist crp_06o_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Alert! Amount spend oh seed is high. Are you sure of amount?"
	}
	foreach var of varlist crp_07_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Was Crop `k' affected by any disease or pest infestation in season `j'?"
	}
	foreach var of varlist crp_50_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Was Crop `k' by any other loss in Season `j'?"
	}
	foreach var of varlist crp_08_q_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': How much Crop `k' did you harvest from Plot `i' in Season `j'(Amt)?"
	}
	foreach var of varlist crp_08_u_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': How much Crop `k' did you harvest from Plot `i' in Season `j'(unit)?"
	}
	foreach var of varlist crp_08o_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Alert! Amount harvested is high. Are you sure?"
	}
	foreach var of varlist crp_08_gd_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Was it green or dry maize?"
	}
	foreach var of varlist crp_08_gq_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Green maize harvested(amt)?"
	}
	foreach var of varlist crp_08_gu_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Green maize harvested(unit)?"
	}
	foreach var of varlist crp_08_dq_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Dry maize harvested(amt)?"
	}
	foreach var of varlist crp_08_du_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Dry maize harvested(unit)?"
	}
	foreach var of varlist crp_08_0_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Why was the harvested amount zero?"
	}
	foreach var of varlist crp_09_q_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': How much Crop `k' did you sell from the Season `j' harvest(amt)?"
	}
	foreach var of varlist crp_09_u_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': How much Crop `k' did you sell from the Season `j' harvest(unit)?"
	}
	foreach var of varlist crp_09_gd_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Was it green or dry maize?"
	}
	foreach var of varlist crp_09_gq_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Green maize sold(amt)?"
	}
	foreach var of varlist crp_09_gu_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Green maize sold(unit)?"
	}
	foreach var of varlist crp_09_dq_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Dry maize sold(amt)?"
	}
	foreach var of varlist crp_09_du_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Dry maize sold(unit)?"
	}
	foreach var of varlist crp_10_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Total earnings from selling Crop `k' from Season `j' harvest(RWF)?"
	}
	foreach var of varlist crp_10o_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Alert! Earnings are high. Are you sure?"
	}
	foreach var of varlist crp_15_q_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': How much of Crop `k' was consumed by household in Season `j'(amt)?"
	}
	foreach var of varlist crp_15_u_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': How much of Crop `k' was consumed by household in Season `j'(unit)?"
	}

	foreach var of varlist amount_total_1_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Total amount of Crop `k' consumed or sold in Season `j'"
	}
	foreach var of varlist amount_total_2_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Total amount of Crop `k' consumed, sold or lost in Season `j'"
	}
	foreach var of varlist crp_15_gd_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Was it green or dry maize"
	}
	foreach var of varlist crp_15_gq_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Green maize consumed(amt)?"
	}
	foreach var of varlist crp_15_gu_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Green maize consumed(unit)?"
	}
	foreach var of varlist crp_15_dq_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Dry maize consumed(amt)?"
	}
	foreach var of varlist crp_15_du_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Dry maize consumed(unit)?"
	}
	foreach var of varlist crp_25_q_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': How much Crop `k' was lost due to spoilage/post-harvest losses(amt)?"
	}
	foreach var of varlist crp_25_u_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': How much Crop `k' was lost due to spoilage/post-harvest losses(unit)?"
	}
	foreach var of varlist crp_25_gd_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Was it green or dry maize"
	}
	foreach var of varlist crp_25_gq_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Green maize lost(amt)?"
	}
	foreach var of varlist crp_25_gu_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Green maize lost(unit)?"
	}
	foreach var of varlist crp_25_dq_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Dry maize lost(amt)?"
	}
	foreach var of varlist crp_25_du_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Dry maize lost(unit)?"
	}
	foreach var of varlist crp_26_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Did you store Crop `k' in a post-harvest infrastructure?"
	}
	foreach var of varlist crp_27_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': What type of post-harvest facility was used to store Crop `k'?"
	}
	foreach var of varlist crp_28_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Minutes taken to reach the post-harvest infrastructure?"
	}
	foreach var of varlist crp_29_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Cost to reach the pots-harvest infrastructure, return?(RWF)"
	}
	foreach var of varlist crp_30_16_* {
		local i = substr("`var'",-5,1)
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		local k = substr("`var'",-1,1)
		label var `var' "P`i' `j' C`k': Total storage cost for Crop `k' at facility?(RWF)"
	}
	foreach var of varlist calc_plot_season_* {
		if substr("`var'",-3,1) == "a" local j "A"
		else if substr("`var'",-3,1) == "b" local j "B"
		else local j "C"
		local i = substr("`var'",-1,1)
		label var `var' "P`i': Plot cultivated in Season `j'"
	}
	foreach var of varlist pl_16_16_* {
		local i = substr("`var'",-3,1)
		if substr("`var'",-1,1) == "1" local j "A"
		else if substr("`var'",-1,1) == "2" local j "B"
		else local j "C"
		label var `var' "P`i' `j' C`k': Was Plot `i' irrigated for Season `j' 2016?"
	}
	foreach var of varlist ag_16_x_16_* {
		if substr("`var'",-1,1) == "1" local j "A"
		else if substr("`var'",-1,1) == "2" local j "B"
		else local j "C"
		label var `var' "`j': How many total days did members of your household spend on land preparation and planting?"
	}
	foreach var of varlist ag_17_x_16_* {
		if substr("`var'",-1,1) == "1" local j "A"
		else if substr("`var'",-1,1) == "2" local j "B"
		else local j "C"
		label var `var' "`j': Did the HH hire any labor to assist with land preparation and planting?"
	}
	foreach var of varlist ag_18_x_16_* {
		if substr("`var'",-1,1) == "1" local j "A"
		else if substr("`var'",-1,1) == "2" local j "B"
		else local j "C"
		label var `var' "`j': Total spent on hired labor for land preparation and planting?(RWF)"
	}
	foreach var of varlist ag_16_y_16_* {
		if substr("`var'",-1,1) == "1" local j "A"
		else if substr("`var'",-1,1) == "2" local j "B"
		else local j "C"
		label var `var' "`j': How many total days did members of your household spend on growing?"
	}
	foreach var of varlist ag_17_y_16_* {
		if substr("`var'",-1,1) == "1" local j "A"
		else if substr("`var'",-1,1) == "2" local j "B"
		else local j "C"
		label var `var' "`j': Did the HH hire any labor to assist with growing during Season `j'?"
	}
	foreach var of varlist ag_18_y_16_* {
		if substr("`var'",-1,1) == "1" local j "A"
		else if substr("`var'",-1,1) == "2" local j "B"
		else local j "C"
		label var `var' "`j': How much in total was spent on hired labor for growing? (RWF)?"
	}
	foreach var of varlist ag_16_z_16_* {
		if substr("`var'",-1,1) == "1" local j "A"
		else if substr("`var'",-1,1) == "2" local j "B"
		else local j "C"
		label var `var' "`j': How many total days did members of your household spend on harvesting?"
	}
	foreach var of varlist ag_17_z_16_* {
		if substr("`var'",-1,1) == "1" local j "A"
		else if substr("`var'",-1,1) == "2" local j "B"
		else local j "C"
		label var `var' "`j': Did the HH hire any labor to assist with harvesting during Season `j'?"
	}
	foreach var of varlist ag_18_z_16_* {
		if substr("`var'",-1,1) == "1" local j "A"
		else if substr("`var'",-1,1) == "2" local j "B"
		else local j "C"
		label var `var' "`j': How much in total was spent on hired labor for harvesting? (RWF)?"
	}
	foreach var of varlist ag_08_* {
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		if substr("`var'",-1,1) == "1" local k "Compost"
		else if substr("`var'",-1,1) == "2" local k "Organic manure"
		else if substr("`var'",-1,1) == "3" local k "NPK"
		else if substr("`var'",-1,1) == "4" local k "Urea"
		else if substr("`var'",-1,1) == "5" local k "DAP"
		else if substr("`var'",-1,1) == "6" local k "Lime"
		else if substr("`var'",-1,1) == "7" local k "Pesticides"
		label var `var' "`j': `k': Did the HH apply any `k' for use in Season `j'?"
	}
	foreach var of varlist ag_11q_* {
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		if substr("`var'",-1,1) == "1" local k "Compost"
		else if substr("`var'",-1,1) == "2" local k "Organic manure"
		else if substr("`var'",-1,1) == "3" local k "NPK"
		else if substr("`var'",-1,1) == "4" local k "Urea"
		else if substr("`var'",-1,1) == "5" local k "DAP"
		else if substr("`var'",-1,1) == "6" local k "Lime"
		else if substr("`var'",-1,1) == "7" local k "Pesticides"
		label var `var' "`j': `k' amt: How much `k' did the HH use in Season `j'"
	}
	foreach var of varlist ag_11u_* {
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		if substr("`var'",-1,1) == "1" local k "Compost"
		else if substr("`var'",-1,1) == "2" local k "Organic manure"
		else if substr("`var'",-1,1) == "3" local k "NPK"
		else if substr("`var'",-1,1) == "4" local k "Urea"
		else if substr("`var'",-1,1) == "5" local k "DAP"
		else if substr("`var'",-1,1) == "6" local k "Lime"
		else if substr("`var'",-1,1) == "7" local k "Pesticides"
		label var `var' "`j': `k' unit: How much `k' did the HH use in Season `j'"
	}
	foreach var of varlist ag_12_* {
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		if substr("`var'",-1,1) == "1" local k "Compost"
		else if substr("`var'",-1,1) == "2" local k "Organic manure"
		else if substr("`var'",-1,1) == "3" local k "NPK"
		else if substr("`var'",-1,1) == "4" local k "Urea"
		else if substr("`var'",-1,1) == "5" local k "DAP"
		else if substr("`var'",-1,1) == "6" local k "Lime"
		else if substr("`var'",-1,1) == "7" local k "Pesticides"
		label var `var' "`j': `k' cost: How much in total did the HH spend on `k'?(RWF)"
	}
	foreach var of varlist ex_01_* {
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		if substr("`var'",-1,1) == "1" local k "Lead farmer"
		else if substr("`var'",-1,1) == "2" local k "LWH agronomist"
		else if substr("`var'",-1,1) == "3" local k "public extension worker"
		else if substr("`var'",-1,1) == "4" local k "Tubura field officer"
		else if substr("`var'",-1,1) == "5" local k "Other NGO/PEP"
		if substr("`var'",-1,1) == "1" local l "LF"
		else if substr("`var'",-1,1) == "2" local l "LWH"
		else if substr("`var'",-1,1) == "3" local l "PEW"
		else if substr("`var'",-1,1) == "4" local l "Tubura"
		else if substr("`var'",-1,1) == "5" local l "Other"
		label var `var' "`j': `l': Did you know who the `k' was for your area?"
	}
	foreach var of varlist ex_02_* {
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		if substr("`var'",-1,1) == "1" local k "Lead farmer"
		else if substr("`var'",-1,1) == "2" local k "LWH agronomist"
		else if substr("`var'",-1,1) == "3" local k "public extension worker"
		else if substr("`var'",-1,1) == "4" local k "Tubura field officer"
		else if substr("`var'",-1,1) == "5" local k "Other NGO/PEP"
		if substr("`var'",-1,1) == "1" local l "LF"
		else if substr("`var'",-1,1) == "2" local l "LWH"
		else if substr("`var'",-1,1) == "3" local l "PEW"
		else if substr("`var'",-1,1) == "4" local l "Tubura"
		else if substr("`var'",-1,1) == "5" local l "Other"
		label var `var' "`j': `l': Has the `k' visited to provide farming advice?"
	}
	foreach var of varlist ex_03_* {
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		if substr("`var'",-1,1) == "1" local k "Lead farmer"
		else if substr("`var'",-1,1) == "2" local k "LWH agronomist"
		else if substr("`var'",-1,1) == "3" local k "public extension worker"
		else if substr("`var'",-1,1) == "4" local k "Tubura field officer"
		else if substr("`var'",-1,1) == "5" local k "Other NGO/PEP"
		if substr("`var'",-1,1) == "1" local l "LF"
		else if substr("`var'",-1,1) == "2" local l "LWH"
		else if substr("`var'",-1,1) == "3" local l "PEW"
		else if substr("`var'",-1,1) == "4" local l "Tubura"
		else if substr("`var'",-1,1) == "5" local l "Other"
		label var `var' "`j': `l': How many times did `k' visit your HH farm?"
	}
	foreach var of varlist ex_04_* {
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		if substr("`var'",-1,1) == "1" local k "Lead farmer"
		else if substr("`var'",-1,1) == "2" local k "LWH agronomist"
		else if substr("`var'",-1,1) == "3" local k "public extension worker"
		else if substr("`var'",-1,1) == "4" local k "Tubura field officer"
		else if substr("`var'",-1,1) == "5" local k "Other NGO/PEP"
		if substr("`var'",-1,1) == "1" local l "LF"
		else if substr("`var'",-1,1) == "2" local l "LWH"
		else if substr("`var'",-1,1) == "3" local l "PEW"
		else if substr("`var'",-1,1) == "4" local l "Tubura"
		else if substr("`var'",-1,1) == "5" local l "Other"
		if substr("`var'",-6,1) == "_" local i = substr("`var'",-5,1)
		else local i = substr("`var'",-6,2)
		label var `var' "`j': `l': Did member `i' meet with `k'?"
	}
	foreach var of varlist ex_04_1_1 ex_04_1_2 ex_04_1_3 ex_04_1_4 ex_04_1_5  ex_04_2_1 ex_04_2_2 ex_04_2_3 ex_04_2_4 ex_04_2_5 ex_04_3_1 ex_04_3_2 ex_04_3_3 ex_04_3_4 ex_04_3_5 {
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		if substr("`var'",-1,1) == "1" local k "Lead farmer"
		else if substr("`var'",-1,1) == "2" local k "LWH agronomist"
		else if substr("`var'",-1,1) == "3" local k "public extension worker"
		else if substr("`var'",-1,1) == "4" local k "Tubura field officer"
		else if substr("`var'",-1,1) == "5" local k "Other NGO/PEP"
		if substr("`var'",-1,1) == "1" local l "LF"
		else if substr("`var'",-1,1) == "2" local l "LWH"
		else if substr("`var'",-1,1) == "3" local l "PEW"
		else if substr("`var'",-1,1) == "4" local l "Tubura"
		else if substr("`var'",-1,1) == "5" local l "Other"
		label var `var' "`j': `l': Who met with `k' in Season `j'?"
	}
	foreach var of varlist ex_08_* {
		if substr("`var'",-3,1) == "1" local j "A"
		else if substr("`var'",-3,1) == "2" local j "B"
		else local j "C"
		if substr("`var'",-1,1) == "1" local k "Lead farmer"
		else if substr("`var'",-1,1) == "2" local k "LWH agronomist"
		else if substr("`var'",-1,1) == "3" local k "public extension worker"
		else if substr("`var'",-1,1) == "4" local k "Tubura field officer"
		else if substr("`var'",-1,1) == "5" local k "Other NGO/PEP"
		if substr("`var'",-1,1) == "1" local l "LF"
		else if substr("`var'",-1,1) == "2" local l "LWH"
		else if substr("`var'",-1,1) == "3" local l "PEW"
		else if substr("`var'",-1,1) == "4" local l "Tubura"
		else if substr("`var'",-1,1) == "5" local l "Other"
		label var `var' "`j': `l': Did you attend any trainings run by the `k'?"
	}

	foreach var of varlist lab_01_* {
		if substr("`var'",-1,1) == "1" local j "A"
		else if substr("`var'",-1,1) == "2" local j "B"
		else local j "C"
		label var `var' "`j': Did anyone in the household do agricultural labor outside of the HH farm?"
	}
	foreach var of varlist lab_02_* {
		if substr("`var'",-1,1) == "1" local j "A"
		else if substr("`var'",-1,1) == "2" local j "B"
		else local j "C"
		label var `var' "`j': How much was earned from agricultural labor outside of the HH farm?"
	}
	foreach var of varlist lab_03_* {
		if substr("`var'",-1,1) == "1" local j "A"
		else if substr("`var'",-1,1) == "2" local j "B"
		else local j "C"
		label var `var' "`j': Did anyone in the household do public works labor for Season `j'?"
	}
	foreach var of varlist lab_04_* {
		if substr("`var'",-1,1) == "1" local j "A"
		else if substr("`var'",-1,1) == "2" local j "B"
		else local j "C"
		label var `var' "`j': How much did the household earn from public works labor?(RWF)"
	}
	foreach var of varlist lab_06_* {
		if substr("`var'",-1,1) == "1" local j "A"
		else if substr("`var'",-1,1) == "2" local j "B"
		else local j "C"
		label var `var' "`j': Did anyone in the household do any other paid work for Season `j'?"
	}
	foreach var of varlist lab_07_* {
		if substr("`var'",-1,1) == "1" local j "A"
		else if substr("`var'",-1,1) == "2" local j "B"
		else local j "C"
		label var `var' "`j': How much was earned from other paid work for Season `j'?(RWF)"
	}
	label var gr_16_other "Which cooperative?(Other)"
	order gr_16_other, after(gr_16)

	label var inc_01 "Earnings: On-farm enterprise"
	label var inc_02 "Earnings: Non-farm enterprise"
	label var inc_03 "Earnings: Renting land"
	label var inc_06 "Earnings: Interests & dividends"
	label var inc_08 "Earnings: Selling livestock products"
	label var inc_09 "Earnings: Gifts"
	label var inc_12 "Earnings: Terracing for LWH"
	label var inc_13 "Earnings: Nurseries for LWH"
	label var inc_14 "Earnings: Composting for LWH"
	label var inc_15 "Earnings: Selling of Permanent Crop Production"
	label var inc_16 "Earnings: Income from Public Works Labor (not reported elsewhere)"
	label var inc_17 "Earnings: Income from Migratory Work (not reported elsewhere)"
	label var inc_t "Total annual income"

	label var exp_01 "Expenditure: Transportation"
	label var exp_02 "Expenditure: Communication"
	label var exp_03 "Expenditure: Clothing and personal belongings"
	label var exp_04 "Expenditure: Leisure"
	label var exp_06 "Expenditure: Water"
	label var exp_08 "Expenditure: School Fees"
	label var exp_10 "Expenditure: Housing"
	label var exp_11 "Expenditure: Household assets"
	label var exp_13 "Expenditure: Health insurance"
	label var exp_14 "Expenditure: Other health expenditure"
	label var exp_15 "Expenditure: Financial Institutions"
	label var exp_16 "Expenditure: Gifts"
	label var exp_17 "Expenditure: Renting or purchasing land"
	label var exp_18 "Expenditure: Renting or purchasing agricultural equipment"
	label var exp_21 "Expenditure: Investments in own business (on farm or off farm)"
	label var exp_22 "Expenditure: Other livestock expenses"
	label var exp_23 "Expenditure: Other"
	label var expw_t "Total weekly expenditure"
	label var exp_t "Total annual expenditure"

	foreach var of varlist aa_01_*{
		if substr("`var'",-1,1) == "1" local j "Cows"
		else if substr("`var'",-1,1) == "2" local j "Goats"
		else if substr("`var'",-1,1) == "3" local j "Pigs"
		else if substr("`var'",-1,1) == "4" local j "Poultry"
		else if substr("`var'",-1,1) == "5" local j "Radios"
		else if substr("`var'",-1,1) == "6" local j "Mobiles"
		else if substr("`var'",-1,1) == "7" local j "Living room"
		else if substr("`var'",-1,1) == "8" local j "Bicycle"
		else if substr("`var'",-1,1) == "9" local j "Hoes/Shovels"
		else if substr("`var'",-2,2) == "10" local j "Other agr. equip"
		else local j "C"
		label var `var' "`j': Did your household purchase any `j' from 30 Sep'15 to 31 Aug'16?"
	}
	foreach var of varlist aa_02_*{
		if substr("`var'",-1,1) == "1" local j "Cows"
		else if substr("`var'",-1,1) == "2" local j "Goats"
		else if substr("`var'",-1,1) == "3" local j "Pigs"
		else if substr("`var'",-1,1) == "4" local j "Poultry"
		else if substr("`var'",-1,1) == "5" local j "Radios"
		else if substr("`var'",-1,1) == "6" local j "Mobiles"
		else if substr("`var'",-1,1) == "7" local j "Living room"
		else if substr("`var'",-1,1) == "8" local j "Bicycle"
		else if substr("`var'",-1,1) == "9" local j "Hoes/Shovels"
		else if substr("`var'",-2,2) == "10" local j "Other agr. equip"
		else local j "C"
		label var `var' "`j': How many purchased? (30 Sep'15 - 31 Aug'16)"
	}
	foreach var of varlist aa_03_*{
		if substr("`var'",-1,1) == "1" local j "Cows"
		else if substr("`var'",-1,1) == "2" local j "Goats"
		else if substr("`var'",-1,1) == "3" local j "Pigs"
		else if substr("`var'",-1,1) == "4" local j "Poultry"
		else if substr("`var'",-1,1) == "5" local j "Radios"
		else if substr("`var'",-1,1) == "6" local j "Mobiles"
		else if substr("`var'",-1,1) == "7" local j "Living room"
		else if substr("`var'",-1,1) == "8" local j "Bicycle"
		else if substr("`var'",-1,1) == "9" local j "Hoes/Shovels"
		else if substr("`var'",-2,2) == "10" local j "Other agr. equip"
		else local j "C"
		label var `var' "`j': How much in total did you spend?(RWF)(30 Sep'15 - 31 Aug'16)"
	}
	foreach var of varlist aa_04_*{
		if substr("`var'",-1,1) == "1" local j "Cows"
		else if substr("`var'",-1,1) == "2" local j "Goats"
		else if substr("`var'",-1,1) == "3" local j "Pigs"
		else if substr("`var'",-1,1) == "4" local j "Poultry"
		else if substr("`var'",-1,1) == "5" local j "Radios"
		else if substr("`var'",-1,1) == "6" local j "Mobiles"
		else if substr("`var'",-1,1) == "7" local j "Living room"
		else if substr("`var'",-1,1) == "8" local j "Bicycle"
		else if substr("`var'",-1,1) == "9" local j "Hoes/Shovels"
		else if substr("`var'",-2,2) == "10" local j "Other agr. equip"
		else local j "C"
		label var `var' "`j': Did your household sell any `j' from 30 Sep'15 to 31 Aug'16?"
	}
	foreach var of varlist aa_05_*{
		if substr("`var'",-1,1) == "1" local j "Cows"
		else if substr("`var'",-1,1) == "2" local j "Goats"
		else if substr("`var'",-1,1) == "3" local j "Pigs"
		else if substr("`var'",-1,1) == "4" local j "Poultry"
		else if substr("`var'",-1,1) == "5" local j "Radios"
		else if substr("`var'",-1,1) == "6" local j "Mobiles"
		else if substr("`var'",-1,1) == "7" local j "Living room"
		else if substr("`var'",-1,1) == "8" local j "Bicycle"
		else if substr("`var'",-1,1) == "9" local j "Hoes/Shovels"
		else if substr("`var'",-2,2) == "10" local j "Other agr. equip"
		else local j "C"
		label var `var' "`j': How many sold? (30 Sep'15 - 31 Aug'16)"
	}
	foreach var of varlist aa_06_*{
		if substr("`var'",-1,1) == "1" local j "Cows"
		else if substr("`var'",-1,1) == "2" local j "Goats"
		else if substr("`var'",-1,1) == "3" local j "Pigs"
		else if substr("`var'",-1,1) == "4" local j "Poultry"
		else if substr("`var'",-1,1) == "5" local j "Radios"
		else if substr("`var'",-1,1) == "6" local j "Mobiles"
		else if substr("`var'",-1,1) == "7" local j "Living room"
		else if substr("`var'",-1,1) == "8" local j "Bicycle"
		else if substr("`var'",-1,1) == "9" local j "Hoes/Shovels"
		else if substr("`var'",-2,2) == "10" local j "Other agr. equip"
		else local j "C"
		label var `var' "`j': How much in total did you earn?(RWF)(30 Sep'15 - 31 Aug'16)"
	}
	label var has_formal "Has formal account"
	/*label var rf_5_a_1 "Loan source: Bank"
	label var rf_5_a_2 "Loan source: Credit union"
	label var rf_5_a_3 "Loan source: Agr. Coop/Farmer's group"
	label var rf_5_a_4 "Loan source: Parents"
	label var rf_5_a_5 "Loan source: Neighbors"
	label var rf_5_a_6 "Loan source: Relatives"
	label var rf_5_a_999 "Loan source: Other"*/
	label var calc_respondent_female "Name of female respondent"

	foreach var of varlist exp_25_*{
		if substr("`var'",-2,2) == "_1" local j "Flour"
		else if substr("`var'",-2,2) == "_2" local j "Bread"
		else if substr("`var'",-2,2) == "_3" local j "Rice"
		else if substr("`var'",-2,2) == "_4" local j "Meat/Fish"
		else if substr("`var'",-2,2) == "_5" local j "Poultry/Eggs"
		else if substr("`var'",-2,2) == "_6" local j "Milk/Dairy"
		else if substr("`var'",-2,2) == "_7" local j "Edible oils"
		else if substr("`var'",-2,2) == "_8" local j "Fruits"
		else if substr("`var'",-2,2) == "_9" local j "Beans"
		else if substr("`var'",-2,2) == "10" local j "Vegetables"
		else if substr("`var'",-2,2) == "11" local j "Tubers"
		else if substr("`var'",-2,2) == "12" local j "Juice/Soda"
		else if substr("`var'",-2,2) == "13" local j "Sugar/Honey"
		else if substr("`var'",-2,2) == "14" local j "Salt/Spices"
		else if substr("`var'",-2,2) == "15" local j "Meals outside HH"
		else if substr("`var'",-2,2) == "16" local j "Nuts/Seeds"
		else local j "C"
		label var `var' "`j': How many days in the last week has your household consumed `j'?"
	}
	foreach var of varlist exp_26_*{
		if substr("`var'",-2,2) == "_1" local j "Flour"
		else if substr("`var'",-2,2) == "_2" local j "Bread"
		else if substr("`var'",-2,2) == "_3" local j "Rice"
		else if substr("`var'",-2,2) == "_4" local j "Meat/Fish"
		else if substr("`var'",-2,2) == "_5" local j "Poultry/Eggs"
		else if substr("`var'",-2,2) == "_6" local j "Milk/Dairy"
		else if substr("`var'",-2,2) == "_7" local j "Edible oils"
		else if substr("`var'",-2,2) == "_8" local j "Fruits"
		else if substr("`var'",-2,2) == "_9" local j "Beans"
		else if substr("`var'",-2,2) == "10" local j "Vegetables"
		else if substr("`var'",-2,2) == "11" local j "Tubers"
		else if substr("`var'",-2,2) == "12" local j "Juice/Soda"
		else if substr("`var'",-2,2) == "13" local j "Sugar/Honey"
		else if substr("`var'",-2,2) == "14" local j "Salt/Spices"
		else if substr("`var'",-2,2) == "15" local j "Meals outside HH"
		else if substr("`var'",-2,2) == "16" local j "Nuts/Seeds"
		else local j "C"
		label var `var' "`j': What was the main source of `j'?"
	}
	foreach var of varlist exp_27_q_*{
		if substr("`var'",-2,2) == "_1" local j "Flour"
		else if substr("`var'",-2,2) == "_2" local j "Bread"
		else if substr("`var'",-2,2) == "_3" local j "Rice"
		else if substr("`var'",-2,2) == "_4" local j "Meat/Fish"
		else if substr("`var'",-2,2) == "_5" local j "Poultry/Eggs"
		else if substr("`var'",-2,2) == "_6" local j "Milk/Dairy"
		else if substr("`var'",-2,2) == "_7" local j "Edible oils"
		else if substr("`var'",-2,2) == "_8" local j "Fruits"
		else if substr("`var'",-2,2) == "_9" local j "Beans"
		else if substr("`var'",-2,2) == "10" local j "Vegetables"
		else if substr("`var'",-2,2) == "11" local j "Tubers"
		else if substr("`var'",-2,2) == "12" local j "Juice/Soda"
		else if substr("`var'",-2,2) == "13" local j "Sugar/Honey"
		else if substr("`var'",-2,2) == "14" local j "Salt/Spices"
		else if substr("`var'",-2,2) == "15" local j "Meals outside HH"
		else if substr("`var'",-2,2) == "16" local j "Nuts/Seeds"
		else local j "C"
		label var `var' "`j': Amount consumed from own production(quantity)"
	}
	foreach var of varlist exp_27_u_*{
		if substr("`var'",-2,2) == "_1" local j "Flour"
		else if substr("`var'",-2,2) == "_2" local j "Bread"
		else if substr("`var'",-2,2) == "_3" local j "Rice"
		else if substr("`var'",-2,2) == "_4" local j "Meat/Fish"
		else if substr("`var'",-2,2) == "_5" local j "Poultry/Eggs"
		else if substr("`var'",-2,2) == "_6" local j "Milk/Dairy"
		else if substr("`var'",-2,2) == "_7" local j "Edible oils"
		else if substr("`var'",-2,2) == "_8" local j "Fruits"
		else if substr("`var'",-2,2) == "_9" local j "Beans"
		else if substr("`var'",-2,2) == "10" local j "Vegetables"
		else if substr("`var'",-2,2) == "11" local j "Tubers"
		else if substr("`var'",-2,2) == "12" local j "Juice/Soda"
		else if substr("`var'",-2,2) == "13" local j "Sugar/Honey"
		else if substr("`var'",-2,2) == "14" local j "Salt/Spices"
		else if substr("`var'",-2,2) == "15" local j "Meals outside HH"
		else if substr("`var'",-2,2) == "16" local j "Nuts/Seeds"
		else local j "C"
		label var `var' "`j': Amount consumed from own production(units)"
	}
	foreach var of varlist exp_28_q_*{
		if substr("`var'",-2,2) == "_1" local j "Flour"
		else if substr("`var'",-2,2) == "_2" local j "Bread"
		else if substr("`var'",-2,2) == "_3" local j "Rice"
		else if substr("`var'",-2,2) == "_4" local j "Meat/Fish"
		else if substr("`var'",-2,2) == "_5" local j "Poultry/Eggs"
		else if substr("`var'",-2,2) == "_6" local j "Milk/Dairy"
		else if substr("`var'",-2,2) == "_7" local j "Edible oils"
		else if substr("`var'",-2,2) == "_8" local j "Fruits"
		else if substr("`var'",-2,2) == "_9" local j "Beans"
		else if substr("`var'",-2,2) == "10" local j "Vegetables"
		else if substr("`var'",-2,2) == "11" local j "Tubers"
		else if substr("`var'",-2,2) == "12" local j "Juice/Soda"
		else if substr("`var'",-2,2) == "13" local j "Sugar/Honey"
		else if substr("`var'",-2,2) == "14" local j "Salt/Spices"
		else if substr("`var'",-2,2) == "15" local j "Meals outside HH"
		else if substr("`var'",-2,2) == "16" local j "Nuts/Seeds"
		else local j "C"
		label var `var' "`j': Amount purchased (quantity)"
	}
	foreach var of varlist exp_28_u_*{
		if substr("`var'",-2,2) == "_1" local j "Flour"
		else if substr("`var'",-2,2) == "_2" local j "Bread"
		else if substr("`var'",-2,2) == "_3" local j "Rice"
		else if substr("`var'",-2,2) == "_4" local j "Meat/Fish"
		else if substr("`var'",-2,2) == "_5" local j "Poultry/Eggs"
		else if substr("`var'",-2,2) == "_6" local j "Milk/Dairy"
		else if substr("`var'",-2,2) == "_7" local j "Edible oils"
		else if substr("`var'",-2,2) == "_8" local j "Fruits"
		else if substr("`var'",-2,2) == "_9" local j "Beans"
		else if substr("`var'",-2,2) == "10" local j "Vegetables"
		else if substr("`var'",-2,2) == "11" local j "Tubers"
		else if substr("`var'",-2,2) == "12" local j "Juice/Soda"
		else if substr("`var'",-2,2) == "13" local j "Sugar/Honey"
		else if substr("`var'",-2,2) == "14" local j "Salt/Spices"
		else if substr("`var'",-2,2) == "15" local j "Meals outside HH"
		else if substr("`var'",-2,2) == "16" local j "Nuts/Seeds"
		else local j "C"
		label var `var' "`j': Amount purchased (units)"
	}
	foreach var of varlist exp_29_*{
		if substr("`var'",-2,2) == "_1" local j "Flour"
		else if substr("`var'",-2,2) == "_2" local j "Bread"
		else if substr("`var'",-2,2) == "_3" local j "Rice"
		else if substr("`var'",-2,2) == "_4" local j "Meat/Fish"
		else if substr("`var'",-2,2) == "_5" local j "Poultry/Eggs"
		else if substr("`var'",-2,2) == "_6" local j "Milk/Dairy"
		else if substr("`var'",-2,2) == "_7" local j "Edible oils"
		else if substr("`var'",-2,2) == "_8" local j "Fruits"
		else if substr("`var'",-2,2) == "_9" local j "Beans"
		else if substr("`var'",-2,2) == "10" local j "Vegetables"
		else if substr("`var'",-2,2) == "11" local j "Tubers"
		else if substr("`var'",-2,2) == "12" local j "Juice/Soda"
		else if substr("`var'",-2,2) == "13" local j "Sugar/Honey"
		else if substr("`var'",-2,2) == "14" local j "Salt/Spices"
		else if substr("`var'",-2,2) == "15" local j "Meals outside HH"
		else if substr("`var'",-2,2) == "16" local j "Nuts/Seeds"
		else local j "C"
		label var `var' "`j': Total amount spent by HH over last week (RWF)"
	}

	foreach var of varlist wdds_b_*{
		if substr("`var'",-2,2) == "_1" local j "IBINYAMPEKE"
		else if substr("`var'",-2,2) == "_2" local j "IBINYAMIZI N'IBINYABIJUMBA"
		else if substr("`var'",-2,2) == "_3" local j "IMBOGA N’IBINYABIJUMBA BIKUNGAHAYE KURI VITAMINI A"
		else if substr("`var'",-2,2) == "_4" local j "IMBOGA MBISI"
		else if substr("`var'",-2,2) == "_5" local j "IZINDI MBOGA"
		else if substr("`var'",-2,2) == "_6" local j "IMBUTO ZIKUNGAHAYE MURI VITAMINI"
		else if substr("`var'",-2,2) == "_7" local j "IZINDI MBUTO"
		else if substr("`var'",-2,2) == "_8" local j "INYAMA Z’IMYANYA Y’IMBERE MU NDA Z’AMATUNGO"
		else if substr("`var'",-2,2) == "_9" local j "Inyama ibazwe ako kanya"
		else if substr("`var'",-2,2) == "10" local j "AMAGI"
		else if substr("`var'",-2,2) == "11" local j "AMAFI"
		else if substr("`var'",-2,2) == "12" local j "IBINYAMISOGWE, UBUNYOBWA N’IBINDI BARYA UTUBUTO TW’IMBERE"
		else if substr("`var'",-2,2) == "13" local j "AMATA N’IBIYAKOMOKAHO"
		else if substr("`var'",-2,2) == "14" local j "AMAVUTA N’IBINYABINURE"
		else if substr("`var'",-2,2) == "15" local j "IBINYAMASUKARI"
		else if substr("`var'",-2,2) == "16" local j "IBIRUNGO,INDYOSHYANDYO N’IBINYOBWA"
		else if substr("`var'",-2,2) == "17" local j "Nta nakimwe"
		else local j "C"
		label var `var' "Breakfast: `j'"
	}
	foreach var of varlist wdds_bs_*{
		if substr("`var'",-2,2) == "_1" local j "IBINYAMPEKE"
		else if substr("`var'",-2,2) == "_2" local j "IBINYAMIZI N'IBINYABIJUMBA"
		else if substr("`var'",-2,2) == "_3" local j "IMBOGA N’IBINYABIJUMBA BIKUNGAHAYE KURI VITAMINI A"
		else if substr("`var'",-2,2) == "_4" local j "IMBOGA MBISI"
		else if substr("`var'",-2,2) == "_5" local j "IZINDI MBOGA"
		else if substr("`var'",-2,2) == "_6" local j "IMBUTO ZIKUNGAHAYE MURI VITAMINI"
		else if substr("`var'",-2,2) == "_7" local j "IZINDI MBUTO"
		else if substr("`var'",-2,2) == "_8" local j "INYAMA Z’IMYANYA Y’IMBERE MU NDA Z’AMATUNGO"
		else if substr("`var'",-2,2) == "_9" local j "Inyama ibazwe ako kanya"
		else if substr("`var'",-2,2) == "10" local j "AMAGI"
		else if substr("`var'",-2,2) == "11" local j "AMAFI"
		else if substr("`var'",-2,2) == "12" local j "IBINYAMISOGWE, UBUNYOBWA N’IBINDI BARYA UTUBUTO TW’IMBERE"
		else if substr("`var'",-2,2) == "13" local j "AMATA N’IBIYAKOMOKAHO"
		else if substr("`var'",-2,2) == "14" local j "AMAVUTA N’IBINYABINURE"
		else if substr("`var'",-2,2) == "15" local j "IBINYAMASUKARI"
		else if substr("`var'",-2,2) == "16" local j "IBIRUNGO,INDYOSHYANDYO N’IBINYOBWA"
		else if substr("`var'",-2,2) == "17" local j "Nta nakimwe"
		else local j "C"
		label var `var' "Morning snack: `j'"
	}
	foreach var of varlist wdds_l_*{
		if substr("`var'",-2,2) == "_1" local j "IBINYAMPEKE"
		else if substr("`var'",-2,2) == "_2" local j "IBINYAMIZI N'IBINYABIJUMBA"
		else if substr("`var'",-2,2) == "_3" local j "IMBOGA N’IBINYABIJUMBA BIKUNGAHAYE KURI VITAMINI A"
		else if substr("`var'",-2,2) == "_4" local j "IMBOGA MBISI"
		else if substr("`var'",-2,2) == "_5" local j "IZINDI MBOGA"
		else if substr("`var'",-2,2) == "_6" local j "IMBUTO ZIKUNGAHAYE MURI VITAMINI"
		else if substr("`var'",-2,2) == "_7" local j "IZINDI MBUTO"
		else if substr("`var'",-2,2) == "_8" local j "INYAMA Z’IMYANYA Y’IMBERE MU NDA Z’AMATUNGO"
		else if substr("`var'",-2,2) == "_9" local j "Inyama ibazwe ako kanya"
		else if substr("`var'",-2,2) == "10" local j "AMAGI"
		else if substr("`var'",-2,2) == "11" local j "AMAFI"
		else if substr("`var'",-2,2) == "12" local j "IBINYAMISOGWE, UBUNYOBWA N’IBINDI BARYA UTUBUTO TW’IMBERE"
		else if substr("`var'",-2,2) == "13" local j "AMATA N’IBIYAKOMOKAHO"
		else if substr("`var'",-2,2) == "14" local j "AMAVUTA N’IBINYABINURE"
		else if substr("`var'",-2,2) == "15" local j "IBINYAMASUKARI"
		else if substr("`var'",-2,2) == "16" local j "IBIRUNGO,INDYOSHYANDYO N’IBINYOBWA"
		else if substr("`var'",-2,2) == "17" local j "Nta nakimwe"
		else local j "C"
		label var `var' "Lunch: `j'"
	}
	foreach var of varlist wdds_ls_*{
		if substr("`var'",-2,2) == "_1" local j "IBINYAMPEKE"
		else if substr("`var'",-2,2) == "_2" local j "IBINYAMIZI N'IBINYABIJUMBA"
		else if substr("`var'",-2,2) == "_3" local j "IMBOGA N’IBINYABIJUMBA BIKUNGAHAYE KURI VITAMINI A"
		else if substr("`var'",-2,2) == "_4" local j "IMBOGA MBISI"
		else if substr("`var'",-2,2) == "_5" local j "IZINDI MBOGA"
		else if substr("`var'",-2,2) == "_6" local j "IMBUTO ZIKUNGAHAYE MURI VITAMINI"
		else if substr("`var'",-2,2) == "_7" local j "IZINDI MBUTO"
		else if substr("`var'",-2,2) == "_8" local j "INYAMA Z’IMYANYA Y’IMBERE MU NDA Z’AMATUNGO"
		else if substr("`var'",-2,2) == "_9" local j "Inyama ibazwe ako kanya"
		else if substr("`var'",-2,2) == "10" local j "AMAGI"
		else if substr("`var'",-2,2) == "11" local j "AMAFI"
		else if substr("`var'",-2,2) == "12" local j "IBINYAMISOGWE, UBUNYOBWA N’IBINDI BARYA UTUBUTO TW’IMBERE"
		else if substr("`var'",-2,2) == "13" local j "AMATA N’IBIYAKOMOKAHO"
		else if substr("`var'",-2,2) == "14" local j "AMAVUTA N’IBINYABINURE"
		else if substr("`var'",-2,2) == "15" local j "IBINYAMASUKARI"
		else if substr("`var'",-2,2) == "16" local j "IBIRUNGO,INDYOSHYANDYO N’IBINYOBWA"
		else if substr("`var'",-2,2) == "17" local j "Nta nakimwe"
		else local j "C"
		label var `var' "Afternoon snack: `j'"
	}
	foreach var of varlist wdds_d_*{
		if substr("`var'",-2,2) == "_1" local j "IBINYAMPEKE"
		else if substr("`var'",-2,2) == "_2" local j "IBINYAMIZI N'IBINYABIJUMBA"
		else if substr("`var'",-2,2) == "_3" local j "IMBOGA N’IBINYABIJUMBA BIKUNGAHAYE KURI VITAMINI A"
		else if substr("`var'",-2,2) == "_4" local j "IMBOGA MBISI"
		else if substr("`var'",-2,2) == "_5" local j "IZINDI MBOGA"
		else if substr("`var'",-2,2) == "_6" local j "IMBUTO ZIKUNGAHAYE MURI VITAMINI"
		else if substr("`var'",-2,2) == "_7" local j "IZINDI MBUTO"
		else if substr("`var'",-2,2) == "_8" local j "INYAMA Z’IMYANYA Y’IMBERE MU NDA Z’AMATUNGO"
		else if substr("`var'",-2,2) == "_9" local j "Inyama ibazwe ako kanya"
		else if substr("`var'",-2,2) == "10" local j "AMAGI"
		else if substr("`var'",-2,2) == "11" local j "AMAFI"
		else if substr("`var'",-2,2) == "12" local j "IBINYAMISOGWE, UBUNYOBWA N’IBINDI BARYA UTUBUTO TW’IMBERE"
		else if substr("`var'",-2,2) == "13" local j "AMATA N’IBIYAKOMOKAHO"
		else if substr("`var'",-2,2) == "14" local j "AMAVUTA N’IBINYABINURE"
		else if substr("`var'",-2,2) == "15" local j "IBINYAMASUKARI"
		else if substr("`var'",-2,2) == "16" local j "IBIRUNGO,INDYOSHYANDYO N’IBINYOBWA"
		else if substr("`var'",-2,2) == "17" local j "Nta nakimwe"
		else local j "C"
		label var `var' "Dinner: `j'"
	}
	foreach var of varlist wdds_ds_*{
		if substr("`var'",-2,2) == "_1" local j "IBINYAMPEKE"
		else if substr("`var'",-2,2) == "_2" local j "IBINYAMIZI N'IBINYABIJUMBA"
		else if substr("`var'",-2,2) == "_3" local j "IMBOGA N’IBINYABIJUMBA BIKUNGAHAYE KURI VITAMINI A"
		else if substr("`var'",-2,2) == "_4" local j "IMBOGA MBISI"
		else if substr("`var'",-2,2) == "_5" local j "IZINDI MBOGA"
		else if substr("`var'",-2,2) == "_6" local j "IMBUTO ZIKUNGAHAYE MURI VITAMINI"
		else if substr("`var'",-2,2) == "_7" local j "IZINDI MBUTO"
		else if substr("`var'",-2,2) == "_8" local j "INYAMA Z’IMYANYA Y’IMBERE MU NDA Z’AMATUNGO"
		else if substr("`var'",-2,2) == "_9" local j "Inyama ibazwe ako kanya"
		else if substr("`var'",-2,2) == "10" local j "AMAGI"
		else if substr("`var'",-2,2) == "11" local j "AMAFI"
		else if substr("`var'",-2,2) == "12" local j "IBINYAMISOGWE, UBUNYOBWA N’IBINDI BARYA UTUBUTO TW’IMBERE"
		else if substr("`var'",-2,2) == "13" local j "AMATA N’IBIYAKOMOKAHO"
		else if substr("`var'",-2,2) == "14" local j "AMAVUTA N’IBINYABINURE"
		else if substr("`var'",-2,2) == "15" local j "IBINYAMASUKARI"
		else if substr("`var'",-2,2) == "16" local j "IBIRUNGO,INDYOSHYANDYO N’IBINYOBWA"
		else if substr("`var'",-2,2) == "17" local j "Nta nakimwe"
		else local j "C"
		label var `var' "Evening snack: `j'"
	}

	foreach var of varlist gps_arealatitude_* {
		if substr("`var'",-3,1) == "_" local p = substr("`var'",-4,1)
		else local p = substr("`var'",-3,1)
		if substr("`var'",-3,1) == "_" local c = substr("`var'",-2,2)
		else local c = substr("`var'",-1,1)
		label var `var' "GPS Latitude: Plot `p' Corner `c'"
	}
	foreach var of varlist gps_arealongitude_* {
		if substr("`var'",-3,1) == "_" local p = substr("`var'",-4,1)
		else local p = substr("`var'",-3,1)
		if substr("`var'",-3,1) == "_" local c = substr("`var'",-2,2)
		else local c = substr("`var'",-1,1)
		label var `var' "GPS Longitude: Plot `p' Corner `c'"
	}
	foreach var of varlist gps_areaaltitude_* {
		if substr("`var'",-3,1) == "_" local p = substr("`var'",-4,1)
		else local p = substr("`var'",-3,1)
		if substr("`var'",-3,1) == "_" local c = substr("`var'",-2,2)
		else local c = substr("`var'",-1,1)
		label var `var' "GPS Altitude: Plot `p' Corner `c'"
	}
	foreach var of varlist gps_areaaccuracy_* {
		if substr("`var'",-3,1) == "_" local p = substr("`var'",-4,1)
		else local p = substr("`var'",-3,1)
		if substr("`var'",-3,1) == "_" local c = substr("`var'",-2,2)
		else local c = substr("`var'",-1,1)
		label var `var' "GPS Accuracy: Plot `p' Corner `c'"
	}
	foreach var of varlist short_gps_area_* {
		if substr("`var'",-3,1) == "_" local p = substr("`var'",-4,1)
		else local p = substr("`var'",-3,1)
		if substr("`var'",-3,1) == "_" local c = substr("`var'",-2,2)
		else local c = substr("`var'",-1,1)
		label var `var' "GPS: Plot `p' Corner `c'"
	}
	foreach var of varlist calc_isplot* {
		local m = substr("`var'",-1,1)
		local c = substr("`var'",-3,1)
		label var `var' "Is measurement `m' for Plot `c'?"
	}
	foreach var of varlist area_available_* {
		local m = substr("`var'",-1,1)
		label var `var' "Can you measure this plot(M `m')?"
	}
	foreach var of varlist area_unavailable_* {
		local m = substr("`var'",-1,1)
		label var `var' "Why can you not measure this plot? (M`m')"
	}
	foreach var of varlist area_? {
		local m = substr("`var'",-1,1)
		label var `var' "Area of plot (M`m')"
	}
	foreach var of varlist calc_area_plot_* {
		local m = substr("`var'",-1,1)
		label var `var' "Name of plot (M`m')"
	}

	foreach var of varlist crp_05_a_16_* {
		destring `var', replace
	}
	foreach var of varlist unit_* crop_16_* crp_05_a_16_1_1_1 crp_05_a_16_1_1_2 ///
						   crp_05_a_16_1_1_3 crp_05_a_16_1_2_1 crp_05_a_16_1_2_2 ///
						   crp_05_a_16_1_2_3 crp_05_a_16_1_3_1 crp_05_a_16_1_3_2 ///
						   crp_05_a_16_1_3_3 crp_05_a_16_2_1_1 crp_05_a_16_2_1_2 ///
						   crp_05_a_16_2_1_3 crp_05_a_16_2_2_1 crp_05_a_16_2_2_2 ///
						   crp_05_a_16_2_2_3 crp_05_a_16_2_3_1 crp_05_a_16_2_3_2 ///
						   crp_05_a_16_2_3_3 crp_05_a_16_3_1_1 crp_05_a_16_3_1_2 ///
						   crp_05_a_16_3_1_3 crp_05_a_16_3_2_1 crp_05_a_16_3_2_2 ///
						   crp_05_a_16_3_2_3 crp_05_a_16_3_3_1 crp_05_a_16_3_3_2 ///
						   crp_05_a_16_3_3_3 crp_05_a_16_4_1_1 crp_05_a_16_4_1_2 ///
						   crp_05_a_16_4_1_3 crp_05_a_16_4_2_1 crp_05_a_16_4_2_2 ///
						   crp_05_a_16_4_2_3 crp_05_a_16_4_3_1 crp_05_a_16_4_3_2 ///
						   crp_05_a_16_4_3_3 crp_05_a_16_5_1_1 crp_05_a_16_5_1_2 ///
						   crp_05_a_16_5_1_3 crp_05_a_16_5_2_1 crp_05_a_16_5_2_2 ///
						   crp_05_a_16_5_2_3 crp_05_a_16_5_3_1 crp_05_a_16_5_3_2 ///
						   crp_05_a_16_5_3_3 crp_05_a_16_6_1_1 crp_05_a_16_6_1_2 ///
						   crp_05_a_16_6_1_3 crp_05_a_16_6_2_1 crp_05_a_16_6_2_2 ///
						   crp_05_a_16_6_2_3 crp_05_a_16_6_3_1 crp_05_a_16_6_3_2 crp_05_a_16_6_3_3 {
		tostring `var', replace
		replace `var' = "" if `var' == "."
	}

	*----------------------------------------
	* Get FUP4 average values from comparison
	*----------------------------------------
	preserve
		use "$fup4_data\Raw\1611_wb_lwh_data01.dta", clear
			
		* Ag profits
		rename stats_w_profit_agric_? fup4_w_profit_agric_?
		label var fup4_w_profit_agric_a "Profit Agric A (FUP4)"
		label var fup4_w_profit_agric_b "Profit Agric B (FUP4)"
		label var fup4_w_profit_agric_c "Profit Agric C (FUP4)"
		
		* Harvests
		rename stats_w_total_val_harvested_? fup4_w_total_val_harvested_?
		label var fup4_w_total_val_harvested_a "Harvest A (FUP4)"
		label var fup4_w_total_val_harvested_b "Harvest B (FUP4)"
		label var fup4_w_total_val_harvested_c "Harvest C (FUP4)"
		
		* Plot area
		rename stats_area_plots fup4_area_plots
		label var fup4_area_plots "Area (FUP4)"
		
		* GPS Accuracy
		rename stats_accuracy fup4_accuracy
		label var fup4_accuracy "Accuracy (FUP4)"
		
		* Cooperative
		rename stats_mem_coop fup4_mem_coop
		label var fup4_mem_coop "Cooperative (FUP4)"
		
		* Public extension
		rename stats_public_ext_visit_? fup4_public_ext_visit_?
		label var fup4_public_ext_visit_a "Public Extension Worker A (FUP4)"
		label var fup4_public_ext_visit_b "Public Extension Worker B (FUP4)"
		label var fup4_public_ext_visit_c "Public Extension Worker C (FUP4)"
		
		* Tubura 
		rename stats_fo_tubura_visit_? fup4_fo_tubura_visit_?
		label var fup4_fo_tubura_visit_a "Tubura A (FUP4)"
		label var fup4_fo_tubura_visit_b "Tubura B (FUP4)"		
		label var fup4_fo_tubura_visit_c "Tubura C (FUP4)"
		
		* Terraced
		rename stats_any_plots_terraced fup4_any_plots_terraced
		label var fup4_any_plots_terraced "Terraced (FUP4)"
		
		* Irrigation
		rename stats_any_irrigation_? fup4_any_irrigation_?
		label var fup4_any_irrigation_a "Irrigation A (FUP4)"
		label var fup4_any_irrigation_b "Irrigation B (FUP4)"
		label var fup4_any_irrigation_c "Irrigation C (FUP4)"
		
		* Formal account
		rename stats_formal_account fup4_formal_account
		label var fup4_formal_account "Account (FUP4)"

		* Any savings
		rename stats_any_form_savings fup4_any_form_savings
		label var fup4_any_form_savings "Savings (FUP4)"

		* Income LWH
		rename stats_w_inc_lwh fup4_w_inc_lwh
		label var fup4_w_inc_lwh "LWH Income (FUP4)"
		
		* Total income
		rename stats_w_income_total fup4_w_income_total
		label var fup4_w_income_total "Total Income (FUP4)"
	
		* Calculate the average by collapsing
		keep id_05 fup4_*
		duplicates tag id_05, gen(dup)
		keep if dup == 0
		drop dup
		collapse (mean) _all
		
		* save as a tempfile
		gen sample = 1 // This will help wit the merge below.
		tempfile fup4
		save `fup4'		
	restore 	
	
	* Merge the FUP4 values
	mmerge sample using `fup4'
	drop _merge
	save "$data\lwh_oi_endline_clean_01.dta", replace
	




















