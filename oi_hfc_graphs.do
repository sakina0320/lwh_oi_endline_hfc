
	/* This do file creates graphs with high frequency check variables.
	   The graphs are stored in the dropbox folder and viewd on the DB Paper
	   dashboard for the LWH OI Endline.
	   
	   This do file is part of Master_import_bc_hfc.do.
	*/


	clear matrix
	clear mata
	graph drop _all
	
	use "$data\lwh_oi_endline_clean_03.dta", clear
	
	local vars_box 				"area_plots w_inc_lwh w_income_total"

	local vars_binary_seasons	"public_ext_visit fo_tubura_visit any_irrigation"
	local vars_binary			"mem_coop any_plots_terraced formal_account any_form_savings"
		
	local vars_continuous		"area_plots w_inc_lwh w_income_total" 

	local vars_binary_nofup4	"status_obs first_available second_available"	


	cap drop __*

		******************** QUALITY CONTROL ********************

	* Box plots
	foreach var in `vars_box' {
	cap drop __*
		graph box stats_`var', nooutsides box(1, lwidth(thin)) note("") name(`var'_nooutsides) caption("`c(current_date)' `c(current_time)'")
		graph box stats_`var', box(1, lwidth(thin)) note("") name(`var') marker(1, msize(medium) mlabel(id_05)) caption("`c(current_date)' `c(current_time)'")

		graph combine `var'_nooutsides `var'
		graph export "$graphs\box_`var'.png", replace		
	}

	***BAR MEAN CONTINUOUS***
	foreach var in `vars_continuous' {
	cap drop __*
		qui graph bar (mean) stats_`var' fup4_`var', legend(label(1 "2017") label(2 "FUP4") position(6)) caption("`c(current_date)' `c(current_time)'")
		graph export "$graphs/mean_`var'.png", replace

		foreach team in B C D E F {
			qui count if team == "`team'" & stats_`var' < .
			if `r(N)' > 0 {
				qui graph bar (mean) stats_`var' fup4_`var' if team == "`team'", legend(label(1 "2017") label(2 "FUP4") position(6)) caption("`c(current_date)' `c(current_time)'")
				graph export "$graphs/teams/`team'/mean_`var'_`team'.png", replace
			}
		}
	}

	***BAR MEAN BINARY***
	foreach var in `vars_binary' {
	cap drop __*
		replace stats_`var' = stats_`var' * 100
		replace fup4_`var' = fup4_`var' * 100

		graph bar (mean) stats_`var' fup4_`var', legend(label(1 "2017") label(2 "FUP4") position(6)) blabel(bar, format(%3.0f)) caption("`c(current_date)' `c(current_time)'") ytitle(%)
		graph export "$graphs/bin_`var'.png", replace

		foreach team in B C D E F {
			qui count if team == "`team'" & stats_`var' < .
			if `r(N)' > 0 {
				graph bar (mean) stats_`var' fup4_`var' if team == "`team'", legend(label(1 "2017") label(2 "FUP4") position(6)) blabel(bar, format(%3.0f)) caption("`c(current_date)' `c(current_time)'")  ytitle(%)
				graph export "$graphs/teams/`team'/bin_`var'_`team'.png", replace
			}
		}
	}

	***BAR MEAN BINARY SEASON***
	foreach var in `vars_binary_seasons' {
		foreach var2 of varlist *_`var'_* {
			replace `var2' = `var2' * 100
		}

		graph bar (mean) stats_`var'_a stats_`var'_b stats_`var'_c fup4_`var'_a fup4_`var'_b, legend(label(1 "A 2017") label(2 "B 2017") label(3 "C 2017") label(4 "A FUP4") label(5 "B FUP4") position(6)) blabel(bar, format(%3.0f)) caption("`c(current_date)' `c(current_time)'") ytitle(%)
		graph export "$graphs/sbin_`var'.png", replace

		foreach team in B C D E F {
			qui count if team == "`team'" & stats_`var'_a < .
			if `r(N)' > 0 {
				graph bar (mean) stats_`var'_a stats_`var'_b stats_`var'_c fup4_`var'_a fup4_`var'_b if team == "`team'", legend(label(1 "A 2017") label(2 "B 2017") label(3 "C 2017") label(4 "A FUP4") label(5 "B FUP4") position(6)) blabel(bar, format(%3.0f)) caption("`c(current_date)' `c(current_time)'") ytitle(%)
				graph export "$graphs/teams/`team'/sbin_`var'_`team'.png", replace
			}
		}
	}

	***



	cap drop __*


	*****PERFORMANCE*****
	gen started_today = date == today
	gen started_yesterday = date == today - 1
	gen started_lastweek = date >= today - 7

	label var started_today "Today"
	label var started_yesterday "Yesterday"
	label var started_lastweek "Last 7 days"


	keep if consent == 1
	label var consent "All"

	mrgraph hbar consent started_lastweek started_yesterday started_today, blabel(bar, position(center) color(white)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(Interviews)
	graph export "$graphs/progress_days.png", replace


	foreach var of varlist check check_* {
		local varlabel : var label `var'
		local varlabel = subinstr("`varlabel'", "Check: ","", .)
		label var `var' "`varlabel'"
	}

	mrgraph hbar check check_duration check_area check_gps_plot check_gps_hh check_distance check_out, stat(col) blabel(bar, position(center) color(white) format(%3.0f)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(%)
	graph export "$graphs/performance.png", replace

	mrgraph hbar check_cultivation_* check_measured check_harvest, stat(col) blabel(bar, position(center) color(white) format(%3.0f)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(%)
	graph export "$graphs/performance2.png", replace

	graph hbar (mean) stats_accuracy (mean) plots (mean) ratio_plots_measured, blabel(bar, position(center) color(black) format(%9.1f)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(Mean) legend(position(6) label(1 "GPS Accuracy") label(2 "Plots") label(3 "Ratio Plots Measured"))
	graph export "$graphs/means1.png", replace

	gen no_check = 0
	replace no_check = 1 if check == 0 & check_duration== 0 & check_area == 0 & check_gps_plot == 0 & check_gps_hh == 0 & check_distance == 0 & check_out == 0
	label var no_check "No issues"

	qui count if date == today
	if `r(N)' > 0 {
		mrgraph hbar check check_duration check_area check_gps_plot check_gps_hh check_distance check_out no_check if date == today, title("Today") stat(col) blabel(bar, position(center) color(white) format(%3.0f)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(%)
		graph export "$graphs/performance_today.png", replace

		mrgraph hbar check_cultivation_* check_measured check_harvest if date == today, title("Today") stat(col) blabel(bar, position(center) color(white) format(%3.0f)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(%)
		graph export "$graphs/performance2_today.png", replace

		graph hbar (mean) stats_accuracy (mean) plots (mean) ratio_plots_measured if date == today, title("Today") blabel(bar, position(center) color(black) format(%9.1f)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(Mean) legend(position(6) label(1 "GPS Accuracy") label(2 "Plots") label(3 "Ratio Plots Measured"))
		graph export "$graphs/means1_today.png", replace

	}

	qui count if date == today - 1
	if `r(N)' > 0 {
		mrgraph hbar check check_duration check_area check_gps_plot check_gps_hh check_distance check_out if date == today - 1, title("Yesterday") stat(col) blabel(bar, position(center) color(white) format(%3.0f)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(%)
		graph export "$graphs/performance_yesterday.png", replace

		mrgraph hbar check_cultivation_* check_measured check_harvest if date == today - 1, title("Yesterday") stat(col) blabel(bar, position(center) color(white) format(%3.0f)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(%)
		graph export "$graphs/performance2_yesterday.png", replace

		graph hbar (mean) stats_accuracy (mean) plots (mean) ratio_plots_measured if date == today - 1, title("Yesterday") blabel(bar, position(center) color(black) format(%9.1f)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(Mean) legend(position(6) label(1 "GPS Accuracy") label(2 "Plots") label(3 "Ratio Plots Measured"))
		graph export "$graphs/means1_yesterday.png", replace
	}

	foreach var of varlist check check_duration check_area check_harvest check_out ///
						   check_distance check_gps_plot check_gps_hh check_cultivation_? ///
						   stats_accuracy plots ratio_plots_measured {
		replace `var' = `var' * 100
	}

	foreach team in B C D E F {
		qui count if consent == 1 & team == "`team'"
		if `r(N)' > 0 {
			
			mrgraph hbar consent started_lastweek started_yesterday started_today if team == "`team'", blabel(bar, position(center) color(white)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(Interviews)
			graph export "$graphs/teams/`team'/progress_days_`team'.png", replace

			graph hbar (sum) consent (sum) started_lastweek (sum) started_yesterday (sum) started_today if team == "`team'", over(enumerator) blabel(bar, position(center) color(black)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(Interviews) legend(position(6) label(1 "All") label(2 "Last 7 days") label(3 "Yesterday") label(4 "Today"))
			graph export "$graphs/teams/`team'/progress_days_enumerator_`team'.png", replace
			
		}
		
		qui count if consent == 1 & team == "`team'"
		if `r(N)' > 0 {
			graph hbar (mean) check_duration (mean) check_area (mean) check_harvest (mean) check_out if team == "`team'", over(enumerator) blabel(bar, position(center) color(black) format(%9.0f)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(%) legend(position(6) label(1 "Short Interview") label(2 "Plot Unavailable") label(3 "No Harvest") label(4 "Outlier") cols(2))
			graph export "$graphs/teams/`team'/performance_all_`team'.png", replace

			graph hbar (mean) check_distance (mean) check_gps_plot (mean) check_gps_hh if team == "`team'", over(enumerator) blabel(bar, position(center) color(black) format(%9.0f)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(%) legend(position(6) label(1 "Location") label(2 "GPS Plot") label(3 "GPS HH"))
			graph export "$graphs/teams/`team'/performance2_all_`team'.png", replace

			graph hbar (mean) check_cultivation_1 (mean) check_cultivation_2 (mean) check_cultivation_3 if team == "`team'", over(enumerator) blabel(bar, position(center) color(black) format(%9.0f)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(%) legend(position(6) label(1 "Season A") label(2 "Season B") label(3 "Season C"))
			graph export "$graphs/teams/`team'/cultivation_all_`team'.png", replace

			graph hbar (mean) stats_accuracy (mean) plots (mean) ratio_plots_measured  if team == "`team'", over(enumerator) blabel(bar, position(center) color(black) format(%9.1f)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(Mean) legend(position(6) label(1 "GPS Accuracy") label(2 "Plots") label(3 "Ratio Plots Measured"))
			graph export "$graphs/teams/`team'/means1_all_`team'.png", replace

		}
		qui count if consent == 1 & team == "`team'" & date == today
		if `r(N)' > 0 {
			graph hbar (mean) check_duration (mean) check_area (mean) check_harvest (mean) check_out if team == "`team'" & date == today, title("Today") over(enumerator) blabel(bar, position(center) color(black) format(%9.0f)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(%) legend(position(6) label(1 "Short Interview") label(2 "Plot Unavailable") label(3 "No Harvest") label(4 "Outlier") cols(2))
			graph export "$graphs/teams/`team'/performance_today_`team'".png, replace

			graph hbar (mean) check_distance (mean) check_gps_plot (mean) check_gps_hh if team == "`team'" & date == today, title("Today") over(enumerator) blabel(bar, position(center) color(black) format(%9.0f)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(%) legend(position(6) label(1 "Location") label(2 "GPS Plot") label(3 "GPS HH"))
			graph export "$graphs/teams/`team'/performance2_today_`team'.png", replace

			graph hbar (mean) check_cultivation_1 (mean) check_cultivation_2 (mean) check_cultivation_3 if team == "`team'"  & date == today, title("Today") over(enumerator) blabel(bar, position(center) color(black) format(%9.0f)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(%) legend(position(6) label(1 "Season A") label(2 "Season B") label(3 "Season C"))
			graph export "$graphs/teams/`team'/cultivation_today_`team'.png", replace

			graph hbar (mean) stats_accuracy (mean) plots (mean) ratio_plots_measured  if team == "`team'" & date == today, title("Today") over(enumerator) blabel(bar, position(center) color(black) format(%9.1f)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(Mean) legend(position(6) label(1 "GPS Accuracy") label(2 "Plots") label(3 "Ratio Plots Measured"))
			graph export "$graphs/teams/`team'/means1_today_`team'.png", replace
		}
		qui count if consent == 1 & team == "`team'" & date == today - 1
		if `r(N)' > 0 {
			graph hbar (mean) check_duration (mean) check_area (mean) check_harvest (mean) check_out if team == "`team'" & date == today - 1, title("Yesterday") over(enumerator) blabel(bar, position(center) color(black) format(%9.0f)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(%) legend(position(6) label(1 "Short Interview") label(2 "Plot Unavailable") label(3 "No Harvest") label(4 "Outlier") cols(2))
			graph export "$graphs/teams/`team'/performance_yesterday_`team'.png", replace

			graph hbar (mean) check_distance (mean) check_gps_plot (mean) check_gps_hh if team == "`team'" & date == today - 1, title("Yesterday") over(enumerator) blabel(bar, position(center) color(black) format(%9.0f)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(%) legend(position(6) label(1 "Location") label(2 "GPS Plot") label(3 "GPS HH"))
			graph export "$graphs/teams/`team'/performance2_yesterday_`team'.png", replace

			graph hbar (mean) check_cultivation_1 (mean) check_cultivation_2 (mean) check_cultivation_3 if team == "`team'"  & date == today - 1, title("Yesterday") over(enumerator) blabel(bar, position(center) color(black) format(%9.0f)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(%) legend(position(6) label(1 "Season A") label(2 "Season B") label(3 "Season C"))
			graph export "$graphs/teams/`team'/cultivation_yesterday_`team'.png", replace

			graph hbar (mean) stats_accuracy (mean) plots (mean) ratio_plots_measured  if team == "`team'" & date == today - 1, title("Yesterday") over(enumerator) blabel(bar, position(center) color(black) format(%9.1f)) caption("`c(current_date)' `c(current_time)'") yalternate ytitle(Mean) legend(position(6) label(1 "GPS Accuracy") label(2 "Plots") label(3 "Ratio Plots Measured"))
			graph export "$graphs/teams/`team'/means1_yesterday_`team'.png", replace
		}
		
	}

	*** Respondent availability checks
	foreach var in `vars_binary_nofup4' {
		replace `var' = `var' * 100
	}	
	graph bar (mean) first_available ///
					 second_available, ///
					 legend(label(1 "Primary resp. available") ///
					 label (2 "Secondary resp. available") ///
					 label (3 "Other resp. available") position(6)) ///
					 blabel(bar, format(%3.0f)) caption("`c(current_date)' `c(current_time)'") ytitle(%)
	graph export "$graphs/bin_respondents.png", replace

	foreach team in B C D E F {
		qui count if team == "`team'" & first_available < . | first_appointment < . | ///
					 second_available < . 
		if `r(N)' > 0 {
			graph bar (mean) first_available ///
					 second_available, ///
				 legend(label(1 "Primary resp. available") ///
					 label (2 "Secondary resp. available") ///
					 label (3 "Other resp. available") position(6)) ///
				 blabel(bar, format(%3.0f)) caption("`c(current_date)' `c(current_time)'") ytitle(%)
			graph export "$graphs/teams/`team'/bin_respondents_`team'.png", replace
		}
	}
		

	preserve 
		use "$data\lwh_oi_endline_clean_03.dta", clear
		
		* Number of complete inerviews vs unavailable (consent = no) interviews
		graph bar (count)id_05, over(status_obs) ytitle("Number of Interviews") blabel(bar, format(%3.0f)) ///
				   caption("`c(current_date)' `c(current_time)'")
		graph export "$graphs/bin_status_obs.png", replace

		foreach team in B C D E F {
			qui count if team == "`team'" & status_obs < . 
			if `r(N)' > 0 {
				graph bar (count)id_05 if team == "`team'", over(status_obs) ytitle("Number of surveys") ///
					blabel(bar, format(%3.0f)) caption("`c(current_date)' `c(current_time)'")
				graph export "$graphs/teams/`team'/bin_status_obs_`team'.png", replace
				}
			}

		* Number of households exist and nonexistant
		graph bar (count)id_05, over(exist) ytitle("Number of Interviews") blabel(bar, format(%3.0f)) ///
				   caption("`c(current_date)' `c(current_time)'")
		graph export "$graphs/bin_hh_exist.png", replace
			   
		foreach team in B C D E F {
			qui count if team == "`team'" & status_obs < . 
			if `r(N)' > 0 {
				graph bar (count)id_05 if team == "`team'", over(exist) ytitle("Number of surveys") ///
					blabel(bar, format(%3.0f)) caption("`c(current_date)' `c(current_time)'")
				graph export "$graphs/teams/`team'/bin_hh_exist_`team'.png", replace
				}
			}
	restore

	****************************** Backchecks **************************************

	* Progress on backcheck
	clonevar crop_plot_redo = check_bc_plots
	label var crop_plot_redo "Redo the crop and plots rosters"
	mrgraph hbar bc_interviewed backcheck2 backcheck3 crop_plot_redo, title("BC Progress") ///
			blabel(bar, position(center) color(white)) caption("`c(current_date)' `c(current_time)'")
	graph export "$graphs/backcheck_progress.png", replace

	* Reconciliation with the data from the original interviews
	graph bar (sum) check_bc_plots check_bc_crops check_bc_irrigated check_bc_labour check_bc_earnings, ///
					 legend(label(1 "BC Plots") label(2 "BC Crops") label(3 "Irrigation") label(4 "Labor") ///
					 label(5 "Earnings") position(6)) blabel(bar, format(%3.0f)) caption("`c(current_date)' `c(current_time)'") ytitle("Frequency")
	graph export "$graphs/bin_backcheck.png", replace

	* Crops questions in detail
	graph bar (sum) check_bc_crops_a check_bc_crops_b check_bc_crops_c, ///
					 legend(label(1 "BC Crops Season A") label(2 "BC Crops Season B") label(3 "BC Crops Season C") ///
					 label(4 "BC Crops Season C") position(6)) blabel(bar, format(%3.0f)) caption("`c(current_date)' `c(current_time)'") ytitle("Frequency") legend(rows(2))
	graph export "$graphs/bin_backcheck_crops.png", replace

	* Export the 2nd, 3r backehck and redo list to excel
	preserve
		keep id_05 pl_id_06 pl_id_07 pl_id_08 pl_id_09 pl_id_10 id_24 check_bc_plots ///
			 backcheck2 backcheck3 enumerator enumeratorother bc_enumerator bc_enumeratorother
		keep if check_bc_plots == 1 | backcheck2 == 1 | backcheck3 == 1
		rename enumerator original_enumerator
		rename enumeratorother original_enumerator_other
		rename bc_enumerator backcheck_enumerator
		rename bc_enumeratorother backcheck_enumerator_other
		rename check_bc_plots Redo_crop_plot
		rename backcheck2 Redo_backcheck_second_time
		rename backcheck3 Redo_backcheck_thrid_time
		export excel "$backcheck/redo_list", firstrow(var) replace		
	restore 
	
	exit
