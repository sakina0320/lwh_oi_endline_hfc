/* Note: This do file selects new backcheck HHs, and create variabales from 
		 the backcheck data. 
			 
		 "$data\lwh_oi_endline_clean_02.dta" is created here.
	
		 This do file is part of Master_import_bc_hfc.do.
*/


	if $first_time {
	
		*------------------------------------------
		* Select backchecks for the very first time 
		*------------------------------------------
		set seed 43168 // from random.org
		sort team
		gen backcheck = 0
		gen rand_num = uniform()
		bys team: egen ordering = rank(rand_num)
		bys team: replace backcheck = 1 if ordering == 1 // For backcheck HH, we'll just pick the first on in each team.
		}
	
	if $afterwards {
		
		*---------------------------------------		
		* Select backchecks after the first time
		*---------------------------------------
		sort team date status_obs key
		tempvar team_n
		bysort team date status_obs: gen `team_n' = _n
		*gen backcheck = 1 if `team_n' == 1 & status_obs == 1 & bc_done != 1 & date != today // Date is the date of submission in a different time format.
		tempvar yesterday
		gen `yesterday' = today - 1 // This is to avoid getting backcheck list from earlier days we already checked.
		gen backcheck = 1 if (`team_n' == 1 | `team_n' == 2) & status_obs == 1 & bc_done != 1 & date >= `yesterday'
		label var backcheck "HH to be backchecked"
		
		*-------------------------		
		* Make a backcheck preload
		*-------------------------
		preserve 
			keep if backcheck == 1
			keep id_05 calc_roster_old_* calc_roster_new_* calc_repeat_old calc_repeat_new
			export delimited using "$backcheck/backcheck", replace
		restore
		
		}

	if $bc_check_vars {

		*---------------------------------	
		* Create backcheck check variables
		*---------------------------------
		
		* Number of backcheck interviews that haven't been conducted
		gen check_bc_interviewed = bc_interviewed != 1 if bc_interviewed < .
		label var check_bc_interviewed "# of unconducted BC interviews"
		label var bc_interviewed "# of conducted BC interviews"

		* 1 if the number of plots counted during the BC interview is greater than the one in the original interview
		gen check_bc_plots = bc_plots > plots if bc_plots < .
		label var check_bc_plots "Check: BC Plots"
		
		* 1 if the number of crops planted on plot 1 in A is greater than that in the original interview
		gen check_bc_crops_a = bc_crops_a > ag9n_16_1_1 & bc_crops_a < . if plots >= 1 & plots < . & bc_plots >= 1 & bc_plots < .
		label var check_bc_crops_a "Check: BC Crops A"

		* 1 if the number of crops planted on plot 2 in B is greater than that in the original interview
		gen check_bc_crops_b = bc_crops_b > ag9n_16_2_2 & bc_crops_b < . if plots >= 2 & plots < . & bc_plots >= 2 & bc_plots < .		
		label var check_bc_crops_b "Check: BC Crops B"
		
		* 1 if the number of crops planted on plot 3 in C is greater than that in the original interview
		gen check_bc_crops_c = bc_crops_c > ag9n_16_3_3 & bc_crops_c < . if plots >= 3 & plots < . & bc_plots >= 3 & bc_plots < .
		label var check_bc_crops_c "Check: BC Crops C"
		
		* At least one of the 3 crop check variables above checks.
		cap drop __*
		egen check_bc_crops = rowmax(check_bc_crops_*) if bc_crops_a < .
		label var check_bc_crops "Check: BC Crops"

		* Number of irrigated plots recorded in each season recorded during the original interviews
		forvalues i = 1/3 {
			if `i' == 1 local season A
			if `i' == 2 local season B
			if `i' == 3 local season C

			egen n_irrigated_`i' = rowtotal(pl_16_16_*_`i')
			label var n_irrigated_`i' "Number irrigated plots Season `season'"
		}
	
		* 1 if the number of plots irrigated recorded during the BC interview doesn't match with the one from the original interview
		gen check_bc_irrigated = n_irrigated_2 != bc_irrigated_b if bc_irrigated_b < .
		label var check_bc_irrigated "Check: BC Irrigated"

		* 1 if the total non-househod ag labor income does not match the one from the original interview.
		tempvar labour
		egen `labour' = rowmax(lab_01_*)
		gen check_bc_labour = bc_labour != `labour' if bc_labour < .
		label var check_bc_labour "Check: BC Labor"

		* 1 if the earnings from land rentals and livestock produce sales is greater in the bc interview than the original interview
		gen check_bc_earnings = (bc_earnings > (inc_03 + inc_08) * 1.1 | ///
								bc_earnings < (inc_03 + inc_08) * 0.9) & inc_t != 0 if bc_earnings < .
		label var check_bc_earnings "Check: BC Earnings"

		* 1 if households has to be interview for 2nd and 3rd backcheck
		gen backcheck2 = (check_bc_interviewed == 1 | check_bc_plots == 1 | ///
						 (check_bc_crops + check_bc_irrigated + check_bc_labour + check_bc_earnings) > 2) & ///
						 bc_visits == 1 if bc_interviewed < .
		label var backcheck2 "HHs for 2nd backcheck"

		gen backcheck3 = (check_bc_interviewed == 1 | check_bc_plots == 1 | ///
						 (check_bc_crops + check_bc_irrigated + check_bc_labour + check_bc_earnings) > 2) & ///
						 bc_visits > 1 & bc_visits < . if bc_interviewed < .
		label var backcheck3 "HHs for 3rd backcheck"

		tostring bc_main_respondent bc_calc_main_respondent, replace
		replace bc_backcheck_respondent = bc_backcheck_respondent2 if bc_backcheck_respondent == . & bc_backcheck_respondent2 != .
		replace bc_main_respondent = string(bc_main_respondent2) if bc_main_respondent == "" & bc_main_respondent2 != .
		replace bc_calc_main_respondent = bc_calc_main_respondent2 if bc_calc_main_respondent == "" & bc_calc_main_respondent2 != ""
		drop bc_calc_main_respondent2 bc_main_respondent2 bc_backcheck_respondent2
				
		* Save the dataset
		cap drop __* //get rid of unwanted temporary variables
		drop calc_roster_old_* //Same as calc_get_roster_old_*
		drop calc_repeat_new 
		drop calc_roster_new_* //same as calc_get_roster_new_*
		note: This dataset only contains the original, food security, and backcheck interviews. 
		save "$data\lwh_oi_endline_clean_03.dta", replace	
	
		}
