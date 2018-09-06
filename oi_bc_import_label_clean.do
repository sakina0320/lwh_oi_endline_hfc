/* Note: This do file import the backcheck raw data and put labels. 
			 
		 "$data\lwh_oi_endline_clean_bc_01.dta" is created here.
	
		 This do file is part of Master_import_bc_hfc.do.
*/

	*------------
	* Import Data
	*------------
	import delimited using "$raw_data/LWH Endline 2018 Backcheck_WIDE", clear
	tempfile raw_dta
	save `raw_dta'
	
	*--------------------------	
	* Check and drop duplicates
	*--------------------------
	ieduplicates id_05, folder("$backcheck\duplicates_report") uniquevars(key) keep(submissiondate bc_enumerator bc_enumeratorother)

	*----------------	
	* Label variables
	*----------------
	label var bc_starttime "Start"
	note bc_starttime: Start

	label var bc_endtime "End"
	note bc_endtime: End

	label var bc_deviceid "Device ID"
	note bc_deviceid: Device ID

	label var bc_subscriberid "Subscriber ID"
	note bc_subscriberid: Subscriber ID

	label var bc_simid "SIM ID"
	note bc_simid: SIM ID

	label var bc_devicephonenum "Phone Number"
	note bc_devicephonenum: Phone Number

	label var bc_duration "Duration"
	note bc_duration: Duration

	label var id_05 "Please enter the Household Code."
	note id_05: Please enter the Household Code.

	label var bc_pl_sample "Preload: Household Code"
	note bc_pl_sample: Preload: Household Code

	label var bc_id_05_reenter "Please enter the HH Code a second time."
	note bc_id_05_reenter: Please enter the HH Code a second time.

	label var bc_calc_roster_old_1 "Old HH member 1"
	note bc_calc_roster_old_1: Old HH member 1

	label var bc_calc_roster_old_2 "Old HH member 2"
	note bc_calc_roster_old_2: Old HH member 2

	label var bc_calc_roster_old_3 "Old HH member 3"
	note bc_calc_roster_old_3: Old HH member 3

	label var bc_calc_roster_old_4 "Old HH member 4"
	note bc_calc_roster_old_4: Old HH member 4

	label var bc_calc_roster_old_5 "Old HH member 5"
	note bc_calc_roster_old_5: Old HH member 5

	label var bc_calc_roster_old_6 "Old HH member 6"
	note bc_calc_roster_old_6: Old HH member 6

	label var bc_calc_roster_old_7 "Old HH member 7"
	note bc_calc_roster_old_7: Old HH member 7

	label var bc_calc_roster_old_8 "Old HH member 8"
	note bc_calc_roster_old_8: Old HH member 8

	label var bc_calc_roster_old_9 "Old HH member 9"
	note bc_calc_roster_old_9: Old HH member 9

	label var bc_calc_roster_old_10 "Old HH member 10"
	note bc_calc_roster_old_10: Old HH member 10

	label var bc_calc_roster_old_11 "Old HH member 11"
	note bc_calc_roster_old_11: Old HH member 11

	label var bc_calc_roster_old_12 "Old HH member 12"
	note bc_calc_roster_old_12: Old HH member 12

	label var bc_calc_roster_old_13 "Old HH member 13"
	note bc_calc_roster_old_13: Old HH member 13

	label var bc_calc_roster_old_14 "Old HH member 14"
	note bc_calc_roster_old_14: Old HH member 14

	label var bc_calc_roster_old_15 "Old HH member 15"
	note bc_calc_roster_old_15: Old HH member 15

	label var bc_calc_roster_new_1 "New HH member 1"
	note bc_calc_roster_new_1: New HH member 1

	label var bc_calc_roster_new_2 "New HH member 2"
	note bc_calc_roster_new_2: New HH member 2

	label var bc_calc_roster_new_3 "New HH member 3"
	note bc_calc_roster_new_3: New HH member 3

	label var bc_calc_roster_new_4 "New HH member 4"
	note bc_calc_roster_new_4: New HH member 4

	label var bc_calc_roster_new_5 "New HH member 5"
	note bc_calc_roster_new_5: New HH member 5

	label var bc_calc_roster_new_6 "New HH member 6"
	note bc_calc_roster_new_6: New HH member 6

	label var bc_calc_roster_new_7 "New HH member 7"
	note bc_calc_roster_new_7: New HH member 7

	label var bc_calc_roster_new_8 "New HH member 8"
	note bc_calc_roster_new_8: New HH member 8

	label var bc_calc_roster_new_9 "New HH member 9"
	note bc_calc_roster_new_9: New HH member 9

	label var bc_calc_roster_new_10 "New HH member 10"
	note bc_calc_roster_new_10: New HH member 10

	label var bc_calc_roster_new_11 "New HH member 11"
	note bc_calc_roster_new_11: New HH member 11

	label var bc_calc_roster_new_12 "New HH member 12"
	note bc_calc_roster_new_12: New HH member 12

	label var bc_calc_roster_new_13 "New HH member 13"
	note bc_calc_roster_new_13: New HH member 13

	label var bc_calc_roster_new_14 "New HH member 14"
	note bc_calc_roster_new_14: New HH member 14

	label var bc_calc_roster_new_15 "New HH member 15"
	note bc_calc_roster_new_15: New HH member 15

	label var bc_calc_repeat_old "Old HH member count"
	note bc_calc_repeat_old: Old HH member count

	label var bc_calc_repeat_new "New HH member count"
	note bc_calc_repeat_new: New HH member count

	label var bc_interviewed "Was someone in your hh recently interviewed you about agriculture productivit..."
	note bc_interviewed: Was someone in your hh recently interviewed you about agriculture productivity and food security issues?

	label var bc_backcheck_respondent "Fieldworker: Who is the person you are talking to?"
	note bc_backcheck_respondent: Fieldworker: Who is the person you are talking to?

	label var bc_main_respondent "Who was being interviewed?"
	note bc_main_respondent: Who was being interviewed?

	label var bc_calc_main_respondent "Primary Respondent"
	note bc_calc_main_respondent: Primary Respondent

	label var bc_is_decisionmaker "Is  the primary agricultural decision maker in the ..."
	note bc_is_decisionmaker: Is  the primary agricultural decision maker in the household?

	label var bc_not_decisionmaker "Why was the agricultural decision maker not the main respondent?"
	note bc_not_decisionmaker: Why was the agricultural decision maker not the main respondent?

	label var bc_not_decisionmakerother "Why was the agricultural decision maker not the main respondent? (Other reason)"
	note bc_not_decisionmakerother: Why was the agricultural decision maker not the main respondent? (Other reason)

	label var bc_plots "How many agricultural plots did the HH cultivate at any time during the time ..."
	note bc_plots: How many agricultural plots did the HH cultivate at any time during the time period from Season 16A-16C?

	label var bc_crops_a "How many seasonal crops were grown on plot_1 during season A?"
	note bc_crops_a: How many seasonal crops were grown on plot_1 during season A?

	label var bc_crops_b "How many seasonal crops were grown on plot_2 during season B?"
	note bc_crops_b: How many seasonal crops were grown on plot_2 during season B?

	label var bc_crops_c "How many seasonal crops were grown on plot_3 during season C?"
	note bc_crops_c: How many seasonal crops were grown on plot_3 during season C?

	label var bc_irrigated_b "How many of your n plots were irrigated during Season 2016 B?"
	note bc_irrigated_b: How many of your n plots were irrigated during Season 2016 B?

	label var bc_labour "Did anyone in the house do agricultural labor outside of the HH farm during S..."
	note bc_labour: Did anyone in the house do agricultural labor outside of the HH farm during Season 2016 B?

	label var bc_earnings "What was the total earnings of the household from non-farm labor in the last ..."
	note bc_earnings: What was the total earnings of the household from non-farm labor in the last year?

	label var bc_comments "Enumerator: Please write here any notes or comments."
	note bc_comments: Enumerator: Please write here any notes or comments.

	label var bc_enumerator "Enumerator"
	note bc_enumerator: Enumerator

	label var bc_phone "Has this interview been conducted via phone?"
	note bc_phone: Has this interview been conducted via phone?

	label var bc_enumeratorother "Enumerator (Other)"
	note bc_enumeratorother: Enumerator (Other)

	label var bc_short_gps_hh "GPS Backcheck"
	note bc_short_gps_hh: GPS Backcheck

	***Drop variables
	*drop bc_id_05_incorrect note_finish note_respondent

	*drop bc_calc_main_respondent bc_calc_repeat_new bc_calc_repeat_old bc_calc_roster_new_1 bc_calc_roster_new_10 bc_calc_roster_new_11 bc_calc_roster_new_12 bc_calc_roster_new_13 bc_calc_roster_new_14 bc_calc_roster_new_15 bc_calc_roster_new_2 bc_calc_roster_new_3 bc_calc_roster_new_4 bc_calc_roster_new_5 bc_calc_roster_new_6 bc_calc_roster_new_7 bc_calc_roster_new_8 bc_calc_roster_new_9 bc_calc_roster_old_1 bc_calc_roster_old_10 bc_calc_roster_old_11 bc_calc_roster_old_12 bc_calc_roster_old_13 bc_calc_roster_old_14 bc_calc_roster_old_15 bc_calc_roster_old_2 bc_calc_roster_old_3 bc_calc_roster_old_4 bc_calc_roster_old_5 bc_calc_roster_old_6 bc_calc_roster_old_7 bc_calc_roster_old_8 bc_calc_roster_old_9 bc_duration bc_pl_sample bc_short_gps_hh

	***Create value labels
	label define bc_not_decisionmaker 1 "Person was gone from the HH for more than 3 days", modify 
	label define bc_not_decisionmaker 2 "Person was gone from the HH for 1-2 days", modify 
	label define bc_not_decisionmaker 3 "Do not know, he was available", modify 
	label define bc_not_decisionmaker 4 "Other reason", modify 
	label define yes_no 0 "No", modify 
	label define yes_no 1 "Yes", modify 
	label values bc_interviewed yes_no
	label values bc_is_decisionmaker yes_no
	label values bc_labour yes_no
	label values bc_not_decisionmaker bc_not_decisionmaker
	label values bc_phone yes_no
	
	/***Drop variables
	drop bc_simid bc_devicephonenum bc_subscriberid bc_deviceid instanceid bc_pl_sample ///
		 bc_id_05_reenter bc_id_05_reenter bc_calc_roster_* bc_calc_repeat_* ///
		 bc_backcheck_respondent* bc_main_respondent*
	*/
	
	foreach var of varlist formdef_version key submissiondate {
		rename `var' bc_`var'
	}

	*---------
	* Clean up
	*---------
	* Datetime fields
	rename bc_submissiondate bc_submission
	foreach dtvar of varlist bc_starttime bc_endtime bc_submission {
		tempvar tempdtvar
		rename `dtvar' `tempdtvar'
		gen double `dtvar'=.
		cap replace `dtvar'=clock(`tempdtvar',"MDYhms",2025)
		cap replace `dtvar'=clock(`tempdtvar',"MDYhm",2025) if `dtvar'==. & `tempdtvar'~=""
		format %tc `dtvar'
		drop `tempdtvar'
	}

	label var bc_formdef_version "BC Version"
	label var bc_key "BC KEY"
	label var bc_starttime "BC Start"
	label var bc_endtime "BC End"
	label var bc_submission "BC Submission"

	ds *gps* , not
	ds `r(varlist)', has(type numeric)
	foreach var of varlist `r(varlist)' {
		replace `var' = .a if `var' == - 88
		replace `var' = .b if `var' == - 66
	}
	
	bysort id_05: gen bc_visits = _N
	label var bc_visits "Backcheck HH visited already"

	gsort id_05 -bc_start
	tempvar n
	bysort id_05: gen `n' = _n
	keep if `n' == 1
	drop `n'


	* necessary for clean merge
	gen consent = 1


	save "$data\lwh_oi_endline_clean_bc_01.dta", replace
	exit
