/* Note: This do file imports and merge the raw data from the short financial
		 decisions and food security forms. 
		 
		 This do file is part of Master_import_bc_hfc.do, and creates 
		 "$data\lwh_oi_endline_clean_02.dta".
*/



	use "$data\lwh_oi_endline_clean_01.dta", clear

	* --------------------------------------------
	* Merge in and replace Food Security (FS) data
	* --------------------------------------------
	merge m:1 id_05 using "$data\lwh_oi_endline_fs_clean.dta", update replace nogen assert(1 3 4 5)

	*Merge in Crop data - First clear out all previous values of crop variables for observations that were done previously
	merge m:1 id_05 using "$data\lwh_oi_endline_cr_clean.dta", nogen keepusing(key_cr) keep(master match) //key_cr identifies interviews where crop data must be replaced

	foreach var of varlist ag_12_* ag_coop* ag4_* ag6_* ag6n_* ag6u_* ag7_* ///
						   ag8_16_* ag9_* ag9n_* amount_* calc_plot_season_* ///
						   calc_plots check_cultivation_* check_harvest ///
						   coop_exists_* pl_16_* {
		capture confirm numeric var `var' 
		if !_rc {
			replace `var' = . if key_cr != "" 
			}
		else {
			replace `var' = "" if key_cr != "" 			
			}
		}
	tostring crp_05_a_16_*, replace
	foreach var of varlist crp_05_a_16_* {
		replace `var' = "" if key_cr != "" 
	}
	foreach var of varlist crp_05_a_16_* {
		qui tostring `var', replace
		replace `var' = "" if `var' == "."
		replace `var' = "" if key_cr != ""
		qui destring `var', replace 
	}

	foreach var of varlist crp_05_a_16_1_1_1 crp_05_a_16_1_1_2 crp_05_a_16_1_1_3 ///
						   crp_05_a_16_1_2_1 crp_05_a_16_1_2_2 crp_05_a_16_1_2_3 ///
						   crp_05_a_16_1_3_1 crp_05_a_16_1_3_2 crp_05_a_16_1_3_3 ///
						   crp_05_a_16_2_1_1 crp_05_a_16_2_1_2 crp_05_a_16_2_1_3 ///
						   crp_05_a_16_2_2_1 crp_05_a_16_2_2_2 crp_05_a_16_2_2_3 ///
						   crp_05_a_16_2_3_1 crp_05_a_16_2_3_2 crp_05_a_16_2_3_3 ///
						   crp_05_a_16_3_1_1 crp_05_a_16_3_1_2 crp_05_a_16_3_1_3 ///
						   crp_05_a_16_3_2_1 crp_05_a_16_3_2_2 crp_05_a_16_3_2_3 ///
						   crp_05_a_16_3_3_1 crp_05_a_16_3_3_2 crp_05_a_16_3_3_3 ///
						   crp_05_a_16_4_1_1 crp_05_a_16_4_1_2 crp_05_a_16_4_1_3 ///
						   crp_05_a_16_4_2_1 crp_05_a_16_4_2_2 crp_05_a_16_4_2_3 ///
						   crp_05_a_16_4_3_1 crp_05_a_16_4_3_2 crp_05_a_16_4_3_3 ///
						   crp_05_a_16_5_1_1 crp_05_a_16_5_1_2 crp_05_a_16_5_1_3 ///
						   crp_05_a_16_5_2_1 crp_05_a_16_5_2_2 crp_05_a_16_5_2_3 ///
						   crp_05_a_16_5_3_1 crp_05_a_16_5_3_2 crp_05_a_16_5_3_3 ///
						   crp_05_a_16_6_1_1 crp_05_a_16_6_1_2 crp_05_a_16_6_1_3 ///
						   crp_05_a_16_6_2_1 crp_05_a_16_6_2_2 crp_05_a_16_6_2_3 ///
						   crp_05_a_16_6_3_1 crp_05_a_16_6_3_2 crp_05_a_16_6_3_3 {
		qui tostring `var', replace
		replace `var' = "" if `var' == "."
	}

	qui ds crp_11_?_oth_* , has(type numeric) 
	foreach var in `r(varlist)' {
		qui tostring `var', replace
		}	
		
	**Merge in Crop data - now replace with new values	
	preserve 
		use "$data\lwh_oi_endline_cr_clean.dta", clear
		macro drop _*
		tostring plotmatch_6, replace
		ds crp_11_?_oth_* , has(type numeric) 
		foreach var in `r(varlist)' {
			tostring `var', replace
			}
		foreach var of varlist crp_05_a_16_1_1_1 crp_05_a_16_1_1_2 crp_05_a_16_1_1_3 ///
						   crp_05_a_16_1_2_1 crp_05_a_16_1_2_2 crp_05_a_16_1_2_3 ///
						   crp_05_a_16_1_3_1 crp_05_a_16_1_3_2 crp_05_a_16_1_3_3 ///
						   crp_05_a_16_2_1_1 crp_05_a_16_2_1_2 crp_05_a_16_2_1_3 ///
						   crp_05_a_16_2_2_1 crp_05_a_16_2_2_2 crp_05_a_16_2_2_3 ///
						   crp_05_a_16_2_3_1 crp_05_a_16_2_3_2 crp_05_a_16_2_3_3 ///
						   crp_05_a_16_3_1_1 crp_05_a_16_3_1_2 crp_05_a_16_3_1_3 ///
						   crp_05_a_16_3_2_1 crp_05_a_16_3_2_2 crp_05_a_16_3_2_3 ///
						   crp_05_a_16_3_3_1 crp_05_a_16_3_3_2 crp_05_a_16_3_3_3 ///
						   crp_05_a_16_4_1_1 crp_05_a_16_4_1_2 crp_05_a_16_4_1_3 ///
						   crp_05_a_16_4_2_1 crp_05_a_16_4_2_2 crp_05_a_16_4_2_3 ///
						   crp_05_a_16_4_3_1 crp_05_a_16_4_3_2 crp_05_a_16_4_3_3 ///
						   crp_05_a_16_5_1_1 crp_05_a_16_5_1_2 crp_05_a_16_5_1_3 ///
						   crp_05_a_16_5_2_1 crp_05_a_16_5_2_2 crp_05_a_16_5_2_3 ///
						   crp_05_a_16_5_3_1 crp_05_a_16_5_3_2 crp_05_a_16_5_3_3 ///
						   crp_05_a_16_6_1_1 crp_05_a_16_6_1_2 crp_05_a_16_6_1_3 ///
						   crp_05_a_16_6_2_1 crp_05_a_16_6_2_2 crp_05_a_16_6_2_3 ///
						   crp_05_a_16_6_3_1 crp_05_a_16_6_3_2 crp_05_a_16_6_3_3 {
			qui tostring `var', replace
		replace `var' = "" if `var' == "."
	}

		
		tempfile temp 
		di "`temp'"
		save `temp'
	restore	
	merge m:1 id_05 using `temp', update replace nogen assert(1 3 4 5)
	erase `temp'
		
	* Drop variables
	drop g_*_count_* g_*count //Static count variables
	*drop calc_season_* calc_seasons_* calc_period_* calc_crops_label_* amount_harvest_* unit_harvest_* amount_green_harvest_* unit_green_harvest_* amount_dry_harvest_* unit_dry_harvest_* amount_consumption_* unit_consumption_* amount_sell_* unit_sell_* //used for time period labels
	*drop amount_green_sell_* unit_green_sell_* amount_dry_sell_* unit_dry_sell_* amount_green_consumption_* unit_green_consumption_* amount_dry_consumption_* unit_dry_consumption_* amount_loss_* unit_loss_* amount_green_loss_* unit_green_loss_* amount_dry_loss_* unit_dry_loss_*
	*drop input_* index_area_* area_plot_* index_areaname_* label_* animal_asset_* calc_female_date fs2_count food_*
	drop team_entered*

	gen replaced_cr = 0
	replace replaced_cr = 1 if key_cr != ""
	gen replaced_fs = 0
	replace replaced_fs = 1 if key_fs != ""

	label var replaced_cr "Replaced: Crop data"
	label var replaced_fs "Replaced: Food Security data"
	order replaced_*, after(comments)


	**Order variables
	foreach var of varlist comments deviceid endtime enumerator starttime team instanceid formdef_version key submission date date_submit {
		order `var'_fs, after(`var')
		order `var'_cr, after(`var'_fs)
	}

	**Additional labelling
	rename fs_consent consent_fs
	//rename cr_consent consent_cr
	label var consent_fs "FS: Do you agree with the consent?"
	label var consent_cr "CR: Do you agree with the consent?"
	label var comments_fs "Enumerator comments FS"
	label var comments_cr "Enumerator comments CR"
	label var enumerator_fs "Enumerator FS"
	label var enumerator_cr "Enumerator CR"
	label var team_fs "Team FS"
	label var team_cr "Team CR"
	label var instanceid "Instance ID"
	label var instanceid_fs "Instance ID FS"
	label var instanceid_cr "Instance ID CR"
	label var formdef_version "Form version"
	label var formdef_version_fs "Form version FS"
	label var formdef_version_cr "Form version CR"
	label var key "Key"
	label var key_fs "Key FS"
	label var key_cr "Key CR"
	label var name_fs "Respondent name FS"
	label var name_cr "Respondent name CR"
	label var phone_fs "Respondent contact FS"
	label var phone_cr "Respondent contact CR"
	label var sample_gps_latitude "GPS Latitude: Sample"
	label var sample_gps_longitude "GPS Longitude: Sample"
	label var sample_gps_accuracy "GPS Accuracy: Sample"
	label var starttime "Start time"
	label var starttime_cr "Start time CR"
	label var starttime_fs "Start time FS"
	label var endtime "End time"
	label var endtime_cr "End time CR"
	label var endtime_fs "End time FS"
	label var submission "Submission"
	label var submission_cr "Submission CR"
	label var submission_fs "Submission FS"
	label var date "Date of HH interview"
	label var date_fs "Date of FS interview"
	label var date_cr "Date of CR interview"
	label var date_submit "Submission date of HH interview"
	label var date_submit_fs "Submission date of FS interview"
	label var date_submit_cr "Submission date of CR interview"
	label var day "Day of week of HH interview"
	label var delay "Submission delay of HH interview"

	order key formdef_version deviceid subscriberid simid starttime endtime ///
		  submission date date_submit day delay duration gps_hhlatitude ///
		  gps_hhlongitude gps_hhaltitude gps_hhaccuracy short_gps_hh ///
		  enumerator enumeratorother comments, first 

	*replace check_bc_crops = 0 if key_cr != "" //Crop form has been completed
	
	note : This dataset includes the original and food security interviews. 
	save "$data\lwh_oi_endline_clean_02.dta", replace


