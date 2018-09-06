
	/* The raw data are downlowded using ServeyCTO Sync to the folder, 
	   Dropbox\Follow-Up Survey 5 (January 2018)\raw_data.
	   
	   This do file imports the raw data, put variable and value labels, and 
	   check against the sample listing.
	   
	   This do file creates "$data\lwh_oi_endline_clean_00.dta".
	   
	   This do file is part of Master_import_bc_hfc.do.
	*/
	
	import delimited using "$raw_data/LWH Household Survey_WIDE", clear
	tempfile raw_dta
	save `raw_dta'
	
	******************** Check for and Drop Duplicates ********************	
	
	* Producing a duplicate report
	replace team = "Egidie" if team == "B"
	replace team = "Andre" if team == "C"
	replace team = "Emerance" if team == "D"
	replace team = "Diane" if team == "E"
	replace team = "Freddy" if team == "F"		
	ieduplicates id_05, folder("$high_freq_check\duplicates_report") uniquevars(key) keep(team submissiondate enumerator)
	
	************************* Label variables *************************
	
	*----------------------	
	* Identification Module
	*----------------------
	label var starttime "Start"
	note starttime: Start

	label var endtime "End"
	note endtime: End

	label var deviceid "Device ID"
	note deviceid: Device ID

	label var subscriberid "Subscriber ID"
	note subscriberid: Subscriber ID

	label var simid "SIM ID"
	note simid: SIM ID

	label var devicephonenum "Phone Number"
	note devicephonenum: Phone Number

	label var duration "Duration"
	note duration: Duration

	label var text_audit "Audit"
	note text_audit: Audit

	label var id_05 "HH Code"
	note id_05: HH Code

	label var pl_sample "preload: HH Code in Sample"
	note pl_sample: preload: HH Code in Sample

	label var id_05_reenter "Please enter the HH Code a second time."
	note id_05_reenter: Please enter the HH Code a second time.

	label var pl_id_06 "Preload: Village"
	note pl_id_06: Preload: Village

	label var pl_id_07 "Preload: Cell"
	note pl_id_07: Preload: Cell

	label var pl_id_08 "Preload: Sector"
	note pl_id_08: Preload: Sector

	label var pl_id_09 "Preload: District"
	note pl_id_09: Preload: District

	label var pl_id_10 "Preload: Site"
	note pl_id_10: Preload: Site

	label var pl_id_11 "Preload: Household Head"
	note pl_id_11: Preload: Household Head

	label var pl_hhsize "Preload: Household Size"
	note pl_hhsize: Preload: Household Size

	label var pl_id_12 "Preload: National ID"
	note pl_id_12: Preload: National ID

	label var cooperative "Preload: Name of cooperative"
	note cooperative: Preload: Name of cooperative

	label var numplots "Preload: Number of plots cultivated during follow up"
	note numplots: Preload: Number of plots cultivated during follow up

	label var start_mod_a "Start Time of Module A: Identification"
	note start_mod_a: Start Time of Module A: Identification

	label var exist "Enumerator: Does this household still exist?"
	note exist: Enumerator: Does this household still exist?

	label var why_dropped "Why does this household no longer exist?"
	note why_dropped: Why does this household no longer exist?

	label var consent_general "Hello, My name is …………………………..I am working for L4D Ltd"  // I added a consent at an earlier stage without removing the latter one becaseu 1) we had previously been asking too many questions without consent and 2) the latter consent was too important in programming to remove.
	note consent_general: Hello, My name is …………………………..I am working for L4D Ltd (High Lands Centre of Leadership and Development (L4D)Ltd.), a private company that has an office in Rwanda, Kigali. L4D is working on behalf of the World Bank’s researchers and MINAGRI and is carrying out an evaluation on the rural development project. The objective of this evaluation is to understand the ways in which farmers are using the agricultural techniques in order to plan for the future and improve their lives. We need to have a discussion with you now. If you agree to participate in this survey, we will ask you some questions related to your household and its members, plots and crops cultivated, seasons, disasters, savings, income and Expenditures.  There is no consequence for participating, neither on you nor on your household in general and there is no reward for someone who participates in the survey. Note: Your participation is voluntary and the information you will provide will be kept with confidentiality. Your response will be coded and kept in computers that are used by someone who has their codes. IB&C and World Bank trained workers are the only one that can disclose your identity. No information will be disclosed to the public and there will be no name in this survey. That is why we ask you to tell us the truth and to provide full information. You can refuse to respond for some questions or stop the interview whenever you want. There will be no consequences. The survey will take no more than 2.5 hours. Some parts of the survey will require an audio interview so that we can have trusted information. It is possible that we will contact you again and have another interview. In case you have a question regarding this survey, you can let us know now or later on the following address: L4D Ltd, Kimihurura ,Gasabo, P.O. Box 6507 Kigali, Rwanda L4D Ltd Survey  manager Jean Bosco NKURIKIYE:   078-8592360 L4D Ltd managing director Prof Dr. Alfred Bizoza:  078-8415218 Do you agree with the consent?
	
	label var hhh_confirm "According to our records, last year when we were here, the household head was..."
	note hhh_confirm: According to our records, last year when we were here, the household head was . Is this still the same household head?

	label var hhh_change "What happened to ?"
	note hhh_change: What happened to ?

	label var hhh_move "Where in the cell did  move?"
	note hhh_move: Where in the cell did  move?

	label var hhh_remain "Do some of the same household members from s household still live ..."
	note hhh_remain: Do some of the same household members from s household still live here from this time last year?

	label var hhh_notes "DONT READ: Please add any notes about the change or move in HH head"
	note hhh_notes: DONT READ: Please add any notes about the change or move in HH head

	label var hhh_new "Do you have a new household head?"
	note hhh_new: Do you have a new household head?
	
	label var hhh_new_gname "What is the given name of the new household head?"
	note hhh_new_gname: What is the given name of the new household head?
	
	label var hhh_new_sname "What is the surname of the new household head?"
	note hhh_new_sname: What is the surname of the new household head?
	
	label var hhh_new_sex "What is the gender of the new household head?"
	note hhh_new_sex: What is the gender of the new household head?

	label var first_visit "Is this the very first time this household is visited by an enumerator during this data collection?"
	note first_visit: Is this the very first time this household is visited by an enumerator during this data collection?
	
	label var first_available "Is the primary decision maker about the household farm available for us to ta..."
	note first_available: Is the primary decision maker about the household farm available for us to talk to now? These decisions include decisions about crops, seeds, other inputs, agricultural assets to purchase and so on.

	label var revisit "Has this household been visited by a fieldworker previously during this surve..."
	note revisit: Has this household been visited by a fieldworker previously during this survey round?

	label var first_appointment "Can we reschedule a time to talk to the agricultural decision maker? "
	note first_appointment: Can we reschedule a time to talk to the agricultural decision maker? 

	label var first_date "When will he or she be available?"
	note first_date: When will he or she be available?

	label var calc_first_date "formatted time for his/her return"
	note calc_first_date: formatted time for his/her return

	label var first_date_check "You entered . Is this correct?"
	note first_date_check: You entered . Is this correct?

	label var second_respondent "Is there someone else who has good knowledge about the agricultural decisions..."
	note second_respondent: Is there someone else who has good knowledge about the agricultural decisions of the household? (Secondary decision maker)

	label var second_available "Is the secondary decision maker available for an interview now?"
	note second_available: Is the secondary decision maker available for an interview now?

	label var second_appointment "Can we reschedule a time to talk to the secondary decision maker?"
	note second_appointment: Can we reschedule a time to talk to the secondary decision maker?

	label var second_date "When will the secondary decision maker be available?"
	note second_date: When will the secondary decision maker be available?

	label var calc_second_date "formatted time for secondary decision makers return"
	note calc_second_date: formatted time for secondary decision makers return

	label var second_date_check "You entered . Is this correct?"
	note second_date_check: You entered . Is this correct?

	label var third_respondent "Is there another adult in this house that is responsible for the household du..."
	note third_respondent: Is there another adult in this house that is responsible for the household duties while the both the primary and secondary decision maker are away?

	label var third_available "Is this other adult available for an interview now?"
	note third_available: Is this other adult available for an interview now?

	label var third_appointment "Can we reschedule a time to talk to the other adult?"
	note third_appointment: Can we reschedule a time to talk to the other adult?

	label var third_date "When will this person be available?"
	note third_date: When will this person be available?

	label var calc_third_date "formatted time for adult in charge of HHs return"
	note calc_third_date: formatted time for adult in charge of HHs return

	label var third_date_check "You entered . Is this correct?"
	note third_date_check: You entered . Is this correct?

	label var consent "Hello, My name is …………………………..I am working for L4D Ltd"
	note consent: Hello, My name is …………………………..I am working for L4D Ltd (High Lands Centre of Leadership and Development (L4D)Ltd.), a private company that has an office in Rwanda, Kigali. L4D is working on behalf of the World Bank’s researchers and MINAGRI and is carrying out an evaluation on the rural development project. The objective of this evaluation is to understand the ways in which farmers are using the agricultural techniques in order to plan for the future and improve their lives. We need to have a discussion with you now. If you agree to participate in this survey, we will ask you some questions related to your household and its members, plots and crops cultivated, seasons, disasters, savings, income and Expenditures.  There is no consequence for participating, neither on you nor on your household in general and there is no reward for someone who participates in the survey. Note: Your participation is voluntary and the information you will provide will be kept with confidentiality. Your response will be coded and kept in computers that are used by someone who has their codes. IB&C and World Bank trained workers are the only one that can disclose your identity. No information will be disclosed to the public and there will be no name in this survey. That is why we ask you to tell us the truth and to provide full information. You can refuse to respond for some questions or stop the interview whenever you want. There will be no consequences. The survey will take no more than 2.5 hours. Some parts of the survey will require an audio interview so that we can have trusted information. It is possible that we will contact you again and have another interview. In case you have a question regarding this survey, you can let us know now or later on the following address: L4D Ltd, Kimihurura ,Gasabo, P.O. Box 6507 Kigali, Rwanda L4D Ltd Survey  manager Jean Bosco NKURIKIYE:   078-8592360 L4D Ltd managing director Prof Dr. Alfred Bizoza:  078-8415218 Do you agree with the consent?

	label var audio_consent "Enumerator: Does the respondent consent to the audio audit?"
	note audio_consent: Enumerator: Does the respondent consent to the audio audit?

	label var audio_audit "audio_audit"
	note audio_audit: audio_audit

	label var id_all_confirm "According to our record, your HH is located in:   District -   Sec..."
	note id_all_confirm: According to our record, your HH is located in:   District -   Sector -  Cell -   Village -    Have I got all four of these pieces of information correct?  

	label var id_correct_specify "Which of the following is incorrect according to our records?"
	note id_correct_specify: Which of the following is incorrect according to our records?

	label var id_09_corrected "Please select the correct district."
	note id_09_corrected: Please select the correct district.

	label var id_08_corrected "Please select the correct sector."
	note id_08_corrected: Please select the correct sector.

	label var id_07_corrected "Please select the correct cell."
	note id_07_corrected: Please select the correct cell.

	label var id_06_corrected "Please enter the name of the village."
	note id_06_corrected: Please enter the name of the village.

	label var short_gps_hh "GPS HH"
	note short_gps_hh: GPS HH

	label var id_12_confirm "According to our record, s National ID number is: . Is ..."
	note id_12_confirm: According to our record, s National ID number is: . Is this correct? 

	label var id_12 "Please give me  s National ID number"
	note id_12: Please give me  s National ID number

	label var id_24_have "Do you have a mobile?"
	note id_24_have: Do you have a mobile?

	label var id_24 "Mobile Number"
	note id_24: Mobile Number

	*-----------------	
	* Household Roster
	*-----------------
	label var g_roster_old "Household Roster (Old)"
	note g_roster_old: Household Roster (Old)

	forvalues i = 1 / 15 {

		cap label var pl_name_`i' "`i' Preload_`i': `i' Name"
		cap note pl_name_`i': `i' Preload_`i': `i' Name

		cap label var pl_age_`i' "`i' Preload_`i': `i' Age"
		cap note pl_age_`i': `i' Preload_`i': `i' Age

		cap label var pl_sex_`i' "`i' Preload_`i': `i' Sex"
		cap note pl_sex_`i': `i' Preload_`i': `i' Sex

		cap label var member_`i' "`i' Is  still a member of this household?"
		cap note member_`i': `i' Is  still a member of this household?

		cap label var leave_`i' "`i' Why did  leave?"
		cap note leave_`i': `i' Why did  leave?

		cap label var check_age_`i' "`i' According to our records  is  years old. Is this correct?"
		cap note check_age_`i': `i' According to our records  is  years old. Is this correct?

		cap label var correct_age_`i' "`i' What is s correct age?"
		cap note correct_age_`i': `i' What is s correct age?

		cap label var fix_age_`i' "`i' You entered . Did you mean to enter -66 or -88 instead? If so, ..."
		cap note fix_age_`i': `i' You entered . Did you mean to enter -66 or -88 instead? If so, go back to the previous question and correct the answer.

		cap label var age_`i' "`i' Age"
		cap note age_`i': `i' Age

		cap label var check_over18_`i' "`i' Is  18 years old or older?"
		cap note check_over18_`i': `i' Is  18 years old or older?

		cap label var school_`i' "`i' Is  currently attending school?"
		cap note school_`i': `i' Is  currently attending school?

		cap label var education_`i' "`i' What is s highest education level completed?"
		cap note education_`i': `i' What is s highest education level completed?

		cap label var calc_over18_old_`i' "`i' Over 18"
		cap note calc_over18_old_`i': `i' Over 18

		cap label var calc_over18f_old_`i' "`i' Over 18 Female"
		cap note calc_over18f_old_`i': `i' Over 18 Female

		cap label var calc_roster_old_`i' "`i' Roster Old"
		cap note calc_roster_old_`i': `i' Roster Old

		cap label var n_left_`i' "`i' Number who left HH"
		cap note n_left_`i': `i' Number who left HH

		cap label var check_left_`i' "`i' So in total  people left the household since this time last year. Is..."
		cap note check_left_`i': `i' So in total  people left the household since this time last year. Is that correct?

		cap label var hh_new_`i' "`i' Have any HH members been added since the last survey?"
		cap note hh_new_`i': `i' Have any HH members been added since the last survey?

		cap label var new_`i' "`i' How many HH members have been added since the last survey?"
		cap note new_`i': `i' How many HH members have been added since the last survey?

		cap label var g_roster_new_`i' "`i' Household Roster (New)"
		cap note g_roster_new_`i': `i' Household Roster (New)

		cap label var calc_index_new_`i' "`i' Index HH Roster New"
		cap note calc_index_new_`i': `i' Index HH Roster New

		cap label var name_new_first_`i' "`i' What is their Given Name"
		cap note name_new_first_`i': `i' What is their Given Name

		cap label var name_new_last_`i' "`i' What is their Surname"
		cap note name_new_last_`i': `i' What is their Surname

		cap label var name_new_`i' "`i' Name"
		cap note name_new_`i': `i' Name

		cap label var relationship_`i' "`i' What is s relationship to the household head?"
		cap note relationship_`i': `i' What is s relationship to the household head?

		cap label var why_add_`i' "`i' What were the reasons for s addition?"
		cap note why_add_`i': `i' What were the reasons for s addition?

		cap label var sex_new_`i' "`i' What is s gender?"
		cap note sex_new_`i': `i' What is s gender?

		cap label var age_new_`i' "`i' What is s age?"
		cap note age_new_`i': `i' What is s age?

		cap label var fix_age_new_`i' "`i' You entered . Did you mean to enter -66 or -88 instead? If so, go b..."
		cap note fix_age_new_`i': `i' You entered . Did you mean to enter -66 or -88 instead? If so, go back to the previous question and correct the answer.

		cap label var check_over18_new_`i' "`i' Is  18 years old or older?"
		cap note check_over18_new_`i': `i' Is  18 years old or older?

		cap label var calc_over18_new_`i' "`i' Over 18"
		cap note calc_over18_new_`i': `i' Over 18

		cap label var calc_over18f_new_`i' "`i' Over 18 female"
		cap note calc_over18f_new_`i': `i' Over 18 female

		cap label var school_new_`i' "`i' Is  currently attending school?"
		cap note school_new_`i': `i' Is  currently attending school?

		cap label var education_new_`i' "`i' What is s highest education level completed?"
		cap note education_new_`i': `i' What is s highest education level completed?

		cap label var calc_roster_new_`i' "`i' Roster New"
		cap note calc_roster_new_`i': `i' Roster New

		cap label var calc_over18f_`i' "`i' Count: Over 18 female"
		cap note calc_over18f_`i': `i' Count: Over 18 female
	}

	label var decisionmaker "Who is primarily responsible for making decisions about the household farm?"
	note decisionmaker: Who is primarily responsible for making decisions about the household farm?

	label var calc_respondent_decisionmaker "Decision maker"
	note calc_respondent_decisionmaker: Decision maker

	label var calc_gender_decisionmaker "Gender of Decision Maker"
	note calc_gender_decisionmaker: Gender of Decision Maker

	label var respondent_main "Enumerator: Who is the person being interviewed at the moment?"
	note respondent_main: Enumerator: Who is the person being interviewed at the moment?

	label var calc_respondent_main "Main Respondent"
	note calc_respondent_main: Main Respondent

	label var calc_gender_main "Gender of Main Respondent"
	note calc_gender_main: Gender of Main Respondent

	label var is_respondent_finance "Is  the financial decision maker in the household?"
	note is_respondent_finance: Is  the financial decision maker in the household?

	label var respondent_finance "Who is the financial decision maker in the household?"
	note respondent_finance: Who is the financial decision maker in the household?

	label var available_finance "Will  be available for a few questions later?"
	note available_finance: Will  be available for a few questions later?

	label var calc_respondent_finance "Financial Respondent"
	note calc_respondent_finance: Financial Respondent

	label var calc_gender_finance "Gender of Financial Respondent"
	note calc_gender_finance: Gender of Financial Respondent
	
	*------------
	* Plot Roster
	*------------
	label var plots "Enumerator: How many plots did you draw in the diagram above?"
	note plots: Enumerator: How many plots did you draw in the diagram above?

	label var calc_plots "Plots Limit"
	note calc_plots: Plots Limit

	label var plotname_1 "Plot 1:"
	note plotname_1: Plot 1:

	label var plotmatch_1 "Is this the same plot as any of the plots we talked about last time? If so, p..."
	note plotmatch_1: Is this the same plot as any of the plots we talked about last time? If so, please select from the options below. 

	label var plotname_2 "Plot 2:"
	note plotname_2: Plot 2:

	label var plotmatch_2 "Is this the same plot as any of the plots we talked about last time? If so, p..."
	note plotmatch_2: Is this the same plot as any of the plots we talked about last time? If so, please select from the options below. 

	label var plotname_3 "Plot 3:"
	note plotname_3: Plot 3:

	label var plotmatch_3 "Is this the same plot as any of the plots we talked about last time? If so, p..."
	note plotmatch_3: Is this the same plot as any of the plots we talked about last time? If so, please select from the options below. 

	label var plotname_4 "Plot 4:"
	note plotname_4: Plot 4:

	label var plotmatch_4 "Is this the same plot as any of the plots we talked about last time? If so, p..."
	note plotmatch_4: Is this the same plot as any of the plots we talked about last time? If so, please select from the options below. 

	label var plotname_5 "Plot 5:"
	note plotname_5: Plot 5:

	label var plotmatch_5 "Is this the same plot as any of the plots we talked about last time? If so, p..."
	note plotmatch_5: Is this the same plot as any of the plots we talked about last time? If so, please select from the options below. 

	label var plotname_6 "Plot 6:"
	note plotname_6: Plot 6:

	label var plotmatch_6 "Is this the same plot as any of the plots we talked about last time? If so, p..."
	note plotmatch_6: Is this the same plot as any of the plots we talked about last time? If so, please select from the options below. 

	*------------
	* Crop Roster
	*------------
	forvalues plot = 1 / 6 { 


		cap label var calc_plotname_`plot' "P`plot' Plot Name"
		cap note calc_plotname_`plot': P`plot' Plot Name

		cap label var ag6n_`plot' "P`plot' Area"
		cap note ag6n_`plot': P`plot' Area

		cap label var ag6u_`plot' "P`plot' Unit"
		cap note ag6u_`plot': P`plot' Unit

		cap label var ag6u_a_`plot' "P`plot' How confident are you on the answer just provided?"
		cap note ag6u_a_`plot': P`plot' How confident are you on the answer just provided?

		cap label var ag7_`plot' "P`plot' Enumerator checkpoint_`plot': P`plot' What is the source  of the plot area data?"
		cap note ag7_`plot': P`plot' Enumerator checkpoint_`plot': P`plot' What is the source  of the plot area data?

		cap label var ag4_`plot' "P`plot' Where is this plot located?"
		cap note ag4_`plot': P`plot' Where is this plot located?

		cap label var ag_12_`plot' "P`plot' What is the ownership status of this plot?"
		cap note ag_12_`plot': P`plot' What is the ownership status of this plot?

		cap label var ag_coop_`plot' "P`plot' Was this plot cultivated for ?"
		cap note ag_coop_`plot': P`plot' Was this plot cultivated for ?

		cap label var pl_t1_`plot' "P`plot' Is this plot terraced?"
		cap note pl_t1_`plot': P`plot' Is this plot terraced?

		cap label var coop_exists_`plot' "P`plot' Does  still exist?_`plot' "
		cap note coop_exists_`plot': P`plot' Does  still exist? 

		cap label var pl_t2m_`plot' "P`plot' What MONTH and YEAR was this plot terraced?"
		cap note pl_t2m_`plot': P`plot' What MONTH and YEAR was this plot terraced?

		cap label var pl_t3_`plot' "P`plot' Is it a RADICAL or PROGRESSIVE terrace?"
		cap note pl_t3_`plot': P`plot' Is it a RADICAL or PROGRESSIVE terrace?

		cap label var pl_35_`plot' "P`plot' Has this plot been terraced by the LWH project?"
		cap note pl_35_`plot': P`plot' Has this plot been terraced by the LWH project?

		cap label var pl_36_`plot' "P`plot' What percentage of the plot was terraced?_`plot' " 
		cap note pl_36_`plot': P`plot' What percentage of the plot was terraced? 

		cap label var g_seasons_`plot' "P`plot' Seasons"
		cap note g_seasons_`plot': P`plot' Seasons

		forvalues season = 1/3 {
			if `season' == 1 local lseason "A"
			if `season' == 2 local lseason "B"
			if `season' == 3 local lseason "C"

			cap label var calc_season_`plot'_`season' "P`plot' `lseason' C`crop' Season"
			cap note calc_season_`plot'_`season': P`plot' `lseason' C`crop' Season

			cap label var calc_period_`plot'_`season' "P`plot' `lseason' C`crop' Period"
			cap note calc_period_`plot'_`season': P`plot' `lseason' C`crop' Period

			cap label var ag8_16_`plot'_`season' "P`plot' `lseason' C`crop' Did you cultivate seasonal crops on this plot during Season  2017?"
			cap note ag8_16_`plot'_`season': P`plot' `lseason' C`crop' Did you cultivate seasonal crops on this plot during Season  2017?

			cap label var ag9n_16_`plot'_`season' "P`plot' `lseason' C`crop' How many seasonal crops did you cultivate on this plot during Season ${calc_s..."
			cap note ag9n_16_`plot'_`season': P`plot' `lseason' C`crop' How many seasonal crops did you cultivate on this plot during Season  2017?

			cap label var ag10_16_`plot'_`season' "P`plot' `lseason' C`crop' Who was primarily responsible for making decisions about this plot during Sea..."
			cap note ag10_16_`plot'_`season': P`plot' `lseason' C`crop' Who was primarily responsible for making decisions about this plot during Season  2017?

			cap label var ag11_16_`plot'_`season' "P`plot' `lseason' C`crop' Who spent most time working on this plot during Season  2017?"
			cap note ag11_16_`plot'_`season': P`plot' `lseason' C`crop' Who spent most time working on this plot during Season  2017?

			cap label var ag9_16c1_`plot'_`season' "P`plot' `lseason' C`crop' Crop 1 (Most important)"
			cap note ag9_16c1_`plot'_`season': P`plot' `lseason' C`crop' Crop 1 (Most important)

			cap label var ag9_16c2_`plot'_`season' "P`plot' `lseason' C`crop' Crop 2 (Second most important)"
			cap note ag9_16c2_`plot'_`season': P`plot' `lseason' C`crop' Crop 2 (Second most important)

			cap label var ag9_16c3_`plot'_`season' "P`plot' `lseason' C`crop' Crop 3 (Third most important)"
			cap note ag9_16c3_`plot'_`season': P`plot' `lseason' C`crop' Crop 3 (Third most important)

			cap label var g_crop_`plot'_`season' "P`plot' `lseason'"
			cap note g_crop_`plot'_`season': P`plot' `lseason'

			forvalues crop = 1/3 {
				cap label var crop_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Crop"
				cap note crop_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Crop

				cap label var crp_02_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' In which month did you plant ?"
				cap note crp_02_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' In which month did you plant ?

				cap label var crp_03_q_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' On what percentage of plot did you grow ?"
				cap note crp_03_q_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' On what percentage of plot did you grow ?

				cap label var crp_04_q_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Amount"
				cap note crp_04_q_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Amount

				cap label var crp_04_u_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Unit"
				cap note crp_04_u_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Unit

				cap label var crp_05_a_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' What was the source of the seed for ?"
				cap note crp_05_a_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' What was the source of the seed for ?

				cap label var crp_06_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' How much in total did you spend on the  seed you planted in this pl..."
				cap note crp_06_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' How much in total did you spend on the  seed you planted in this plot? (RWF)

				cap label var proportion_gift_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' What percentage of the seed for  was a gift?_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' 
				cap note proportion_gift_`plot'_`season'_`crop': P`plot' `lseason' C`crop' What percentage of the seed for  was a gift? 

				cap label var proportion_own_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' What percentage of the seed for  was own production? _`plot'_`season'_`crop' "P`plot' `lseason' C`crop' 
				cap note proportion_own_`plot'_`season'_`crop': P`plot' `lseason' C`crop' What percentage of the seed for  was own production?  

				cap label var crp_06o_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Alert! The HH reported they spent  RWF on seed. This is very high..."
				cap note crp_06o_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Alert! The HH reported they spent  RWF on seed. This is very high. Are you sure this is correct?

				cap label var crp_07_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Was  affected by any disease or pest infestation during the season?"
				cap note crp_07_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Was  affected by any disease or pest infestation during the season?

				cap label var crp_50_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Was  affected by any other loss in Season ? Examples ..."
				cap note crp_50_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Was  affected by any other loss in Season ? Examples might include grazing animals consuming crops and dry seasons.

				cap label var crp_08_q_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Amount"
				cap note crp_08_q_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Amount

				cap label var crp_08_u_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Unit"
				cap note crp_08_u_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Unit

				cap label var crp_08o_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Alert! The HH reported they harvested *. This is..."
				cap note crp_08o_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Alert! The HH reported they harvested *. This is very high. Are you sure this is correct?

				cap label var crp_08_gd_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Was it green or dry maize?"
				cap note crp_08_gd_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Was it green or dry maize?

				cap label var crp_08_gq_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Amount"
				cap note crp_08_gq_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Amount

				cap label var crp_08_gu_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Unit"
				cap note crp_08_gu_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Unit

				cap label var crp_08_dq_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Amount"
				cap note crp_08_dq_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Amount

				cap label var crp_08_du_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Unit"
				cap note crp_08_du_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Unit

				cap label var crp_08_0_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Why was the harvested amount zero?"
				cap note crp_08_0_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Why was the harvested amount zero?

				cap label var crp_09_q_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Amount"
				cap note crp_09_q_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Amount

				cap label var crp_09_u_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Unit"
				cap note crp_09_u_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Unit

				cap label var crp_09_gd_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Was it green or dry maize?"
				cap note crp_09_gd_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Was it green or dry maize?

				cap label var crp_09_gq_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Amount"
				cap note crp_09_gq_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Amount

				cap label var crp_09_gu_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Unit"
				cap note crp_09_gu_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Unit

				cap label var crp_09_dq_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Amount"
				cap note crp_09_dq_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Amount

				cap label var crp_09_du_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Unit"
				cap note crp_09_du_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Unit

				cap label var crp_10_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' How much did you earn in total from selling  from your Season 16 ${..."
				cap note crp_10_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' How much did you earn in total from selling  from your Season 16  harvest? (RWF)

				cap label var crp_10o_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Alert! The HH reported they earned  RWF from their harvest in sea..."
				cap note crp_10o_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Alert! The HH reported they earned  RWF from their harvest in season . This is very high. Are you sure this is correct?

				* Added for Esdras' Master's thesis
				cap label var crp_11_a_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Where do you get information about price for selling ${crop_16}?"
				note crp_11_a_`plot'_`season'_`crop' : P`plot' `lseason' C`crop' Where do you get information about price for selling ${crop_16}?
							
				cap label var crp_11_b_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' What type of point of sales do you use most to sell ${crop_16}?"
				note crp_11_b_`plot'_`season'_`crop' : P`plot' `lseason' C`crop' What type of point of sales do you use most to sell ${crop_16}?

				cap label var crp_11_c_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' How difficult is it for you to know which point of sales offers you the best price for ${crop_16}?"
				note crp_11_c_`plot'_`season'_`crop' : P`plot' `lseason' C`crop' How difficult is it for you to know which point of sales offers you the best price for ${crop_16}?

				cap label var crp_11_d_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' What means of transportation to get to your main point of sales for ${crop_16}?"
				note crp_11_d_`plot'_`season'_`crop' : P`plot' `lseason' C`crop' What means of transportation to get to your main point of sales for ${crop_16}?				
				
				foreach x in a b d {
					cap label var crp_11_`x'_oth_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Other"
					note crp_11_`x'_oth_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Other
					}
				cap label var crp_11_e_`plot'_`season'_`crop' "How many minutes does it take to get to your main point of sales with the means of transportation you have chosen for ${crop_16}?
				note crp_11_e_`plot'_`season'_`crop': How many minutes does it take to get to your main point of sales with the means of transportation you have chosen for ${crop_16}?
				* End: Esdras' Master's thesis

				cap label var crp_15_q_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Amount"
				cap note crp_15_q_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Amount

				cap label var crp_15_u_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Unit"
				cap note crp_15_u_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Unit

				cap label var amount_total_1_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Crop consumed + sold"
				cap note amount_total_1_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Crop consumed + sold

				cap label var crp_15_gd_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Was it green or dry maize?"
				cap note crp_15_gd_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Was it green or dry maize?

				cap label var crp_15_gq_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Amount"
				cap note crp_15_gq_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Amount

				cap label var crp_15_gu_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Unit"
				cap note crp_15_gu_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Unit

				cap label var crp_15_dq_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Amount"
				cap note crp_15_dq_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Amount

				cap label var crp_15_du_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Unit"
				cap note crp_15_du_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Unit

				cap label var crp_25_q_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Amount"
				cap note crp_25_q_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Amount

				cap label var crp_25_u_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Unit"
				cap note crp_25_u_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Unit

				cap label var amount_total_2_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Crop consumed + sold + lost"
				cap note amount_total_2_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Crop consumed + sold + lost

				cap label var crp_25_gd_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Was it green or dry maize?"
				cap note crp_25_gd_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Was it green or dry maize?

				cap label var crp_25_gq_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Amount"
				cap note crp_25_gq_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Amount

				cap label var crp_25_gu_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Unit"
				cap note crp_25_gu_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Unit

				cap label var crp_25_dq_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Amount"
				cap note crp_25_dq_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Amount

				cap label var crp_25_du_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Unit"
				cap note crp_25_du_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Unit

				cap label var crp_26_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' Did you store  in a post-harvest infrastructure?"
				cap note crp_26_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' Did you store  in a post-harvest infrastructure?

				cap label var crp_27_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' What type of post-harvest infrastructure/storage facility was used to store $..."
				cap note crp_27_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' What type of post-harvest infrastructure/storage facility was used to store ?

				cap label var crp_28_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' How many minutes did it take you to reach the post-harvest infrastructure?"
				cap note crp_28_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' How many minutes did it take you to reach the post-harvest infrastructure?

				cap label var crp_29_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' How much did it cost you to reach the pots-harvest infrastructure, round trip..."
				cap note crp_29_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' How much did it cost you to reach the pots-harvest infrastructure, round trip? (RWF)

				cap label var crp_30_16_`plot'_`season'_`crop' "P`plot' `lseason' C`crop' What was the total storage cost incurred to store the  at the post-..."
				cap note crp_30_16_`plot'_`season'_`crop': P`plot' `lseason' C`crop' What was the total storage cost incurred to store the  at the post-harvest infrastructure? (RWF)
			}
			cap label var PL_16_16a_`plot'_`season' "P`plot' Was this plot irrigated for Season  2017?"
			cap note PL_16_16a_`plot'_`season': P`plot' Was this plot irrigated for Season  2017?
		}	
	}

	label var ag12 "Do you have a kitchen garden?"
	note ag12: Do you have a kitchen garden?

	label var ag13 "When did you start culivating this kitchen garden?"
	note ag13: When did you start culivating this kitchen garden?

	*--------------	
	* HH Farm Labor
	*--------------
	label var start_d2 "Start Time of Module D2: 16A HH Farm Labor"
	note start_d2: Start Time of Module D2: 16A HH Farm Labor

	label var g_seasonrepeat ""
	note g_seasonrepeat:

	forvalues season = 1/3 {
		if `season' == 1 local lseason "A"
		if `season' == 2 local lseason "B"
		if `season' == 3 local lseason "C"

		label var calc_seasons_`season' "`season' Season"
		note calc_seasons_`season': `season' Season

		label var ag_16_x_16_`season' "`lseason' How many total days did members of your household spend on land preparation a..."
		note ag_16_x_16_`season': `lseason' How many total days did members of your household spend on land preparation and planting during ? This includes preparing fields for planting and planting.

		label var ag_17_x_16_`season' "`lseason' Did the HH hire any labor to assist with land preparation and planting during..."
		note ag_17_x_16_`season': `lseason' Did the HH hire any labor to assist with land preparation and planting during ?

		label var ag_18_x_16_`season' "`lseason' How much in total was spent on hired labor for land preparation and planting?..."
		note ag_18_x_16_`season': `lseason' How much in total was spent on hired labor for land preparation and planting? (RWF)

		label var ag_16_y_16_`season' "`lseason' How many total days did members of your household spend on growing during ${c..."
		note ag_16_y_16_`season': `lseason' How many total days did members of your household spend on growing during ? This includes applying inputs, weeding and irrigating.

		label var ag_17_y_16_`season' "`lseason' Did the HH hire any labor to assist with growing during Season ?"
		note ag_17_y_16_`season': `lseason' Did the HH hire any labor to assist with growing during Season ?

		label var ag_18_y_16_`season' "`lseason' How much in total was spent on hired labor for growing? (RWF)"
		note ag_18_y_16_`season': `lseason' How much in total was spent on hired labor for growing? (RWF)

		label var ag_16_z_16_`season' "`lseason' How many total days did members of your household spend on harvesting during ..."
		note ag_16_z_16_`season': `lseason' How many total days did members of your household spend on harvesting during ? This includes harvesting and processing crops after harvest.

		label var ag_17_z_16_`season' "`lseason' Did the HH hire any labor to assist with harvesting during ?"
		note ag_17_z_16_`season': `lseason' Did the HH hire any labor to assist with harvesting during ?

		label var ag_18_z_16_`season' "`lseason' How much in total was spent on hired labor for harvesting? (RWF)"
		note ag_18_z_16_`season': `lseason' How much in total was spent on hired labor for harvesting? (RWF)

		label var start_d3_`season' "`lseason' Start Time of Module D3_`season': `lseason' 16A Inputs"
		note start_d3_`season': `lseason' Start Time of Module D3_`season': `lseason' 16A Inputs

		forvalues input = 1/7 {
			label var ag_08_`season'_`input' "`lseason' I`input'  Did the HH apply any  for use in ?"
			note ag_08_`season'_`input': `lseason' I`input'  Did the HH apply any  for use in ?

			label var ag_11q_`season'_`input' "`lseason' I`input'  Amount"
			note ag_11q_`season'_`input': `lseason' I`input'  Amount

			label var ag_11u_`season'_`input' "`lseason' I`input'  Unit"
			note ag_11u_`season'_`input': `lseason' I`input'  Unit

			label var ag_12_`season'_`input' "`lseason' I`input'  How much in total did the HH spend on ? (RWF)"
			note ag_12_`season'_`input': `lseason' I`input'  How much in total did the HH spend on ? (RWF)
		}

		label var start_mod_e_`season' "`lseason' Start Time of Module E_`season': `lseason' Extension"
		note start_mod_e_`season': `lseason' Start Time of Module E_`season': `lseason' Extension


		forvalues extension = 1 / 5 {
			label var ex_prov_`season'_`extension'  "`lseason' E`extension'  Extension"
			note ex_prov_`season'_`extension' : `lseason' E`extension'  Extension

			label var ex_01_`season'_`extension'  "`lseason' E`extension'  Think back to . Did you know who the  was for your a..."
			note ex_01_`season'_`extension' : `lseason' E`extension'  Think back to . Did you know who the  was for your area?

			label var ex_02_`season'_`extension'  "`lseason' E`extension'  Has the  visited your HH farm during  to provide adv..."
			note ex_02_`season'_`extension' : `lseason' E`extension'  Has the  visited your HH farm during  to provide advice about farming?

			label var ex_03_`season'_`extension'  "`lseason' E`extension'  How many times did  visit your HH farm during ?"
			note ex_03_`season'_`extension' : `lseason' E`extension'  How many times did  visit your HH farm during ?

			label var ex_04_`season'_`extension'  "`lseason' E`extension'  Who met with this ?"
			note ex_04_`season'_`extension' : `lseason' E`extension'  Who met with this ?

			label var ex_08_`season'_`extension'  "`lseason' E`extension'  Did you attend any trainings run by the  during ?"
			note ex_08_`season'_`extension' : `lseason' E`extension'  Did you attend any trainings run by the  during ?
		}

		label var start_mod_f_`season' "`lseason' Start Time of Module F_`season': `lseason' Labor"
		note start_mod_f_`season': `lseason' Start Time of Module F_`season': `lseason' Labor

		label var lab_01_`season' "`lseason' Did anyone in the household do agricultural labor outside of the HH farm for ..."
		note lab_01_`season': `lseason' Did anyone in the household do agricultural labor outside of the HH farm for ?

		label var lab_02_`season' "`lseason' How much in total did the household earn from agricultural labor outside of t..."
		note lab_02_`season': `lseason' How much in total did the household earn from agricultural labor outside of the HH farm in ? (RWF)

		label var lab_03_`season' "`lseason' Did anyone in the household do public works labor for ?"
		note lab_03_`season': `lseason' Did anyone in the household do public works labor for ?

		label var lab_04_`season' "`lseason' How much in total did the household earn from public works labor during ${cal..."
		note lab_04_`season': `lseason' How much in total did the household earn from public works labor during  ? (RWF)

		label var lab_06_`season' "`lseason' Did anyone in the household do any other paid work for ?"
		note lab_06_`season': `lseason' Did anyone in the household do any other paid work for ?

		label var lab_07_`season' "`lseason' How much in total did the household earn from any other paid work for ${calc_..."
		note lab_07_`season': `lseason' How much in total did the household earn from any other paid work for ? (RWF)
	}

	*----------------
	* Ag Technologies
	*----------------
	label var start_mod_g "Start Time of Module G: Technologies"
	note start_mod_g: Start Time of Module G: Technologies

	label var t_1_b "Do you have any agro-forestry species on your land?"
	note t_1_b: Do you have any agro-forestry species on your land?

	label var t_2_b "What Season and Year did you plant these agro-forestry species on your land?"
	note t_2_b: What Season and Year did you plant these agro-forestry species on your land?

	label var t_1_c "Do you intercrop with plants used for plant cover?"
	note t_1_c: Do you intercrop with plants used for plant cover?

	label var t_2_c "What Season and Year did you begin doing this intercropping with plants used ..."
	note t_2_c: What Season and Year did you begin doing this intercropping with plants used for plant cover?

	label var t_1_j "Do you have trees or grasses protecting your terraces?"
	note t_1_j: Do you have trees or grasses protecting your terraces?

	label var t_2_j "What Season and Year did you begin using trees and grasses to protect your te..."
	note t_2_j: What Season and Year did you begin using trees and grasses to protect your terraces?

	label var t_1_l "Do you have waterways connected to your terraces?"
	note t_1_l: Do you have waterways connected to your terraces?

	label var t_2_l "What Season and Year did you first have waterways connected to your terraces?"
	note t_2_l: What Season and Year did you first have waterways connected to your terraces?

	label var t_1_o "Do you have forest species planted on your land, other than on terraces?"
	note t_1_o: Do you have forest species planted on your land, other than on terraces?

	label var t_2_o "What Season and Year did you first plant these forest species?"
	note t_2_o: What Season and Year did you first plant these forest species?

	label var t_1_p "Do you grow rwatsi on your land to fertilize your land?"
	note t_1_p: Do you grow rwatsi on your land to fertilize your land?

	label var t_2_p "What Season and Year did you begin growing rwatsi on your land to fertilize y..."
	note t_2_p: What Season and Year did you begin growing rwatsi on your land to fertilize your land?

	label var t_1_q "Do you put mulch around any plants on your land?"
	note t_1_q: Do you put mulch around any plants on your land?

	label var t_2_q "What Season and Year did you first put mulch around your plants?"
	note t_2_q: What Season and Year did you first put mulch around your plants?

	*--------	
	* Housing
	*--------
	label var start_mod_h "Start Time of Module H: Housing"
	note start_mod_h: Start Time of Module H: Housing

	label var hh_display "Please answer with Yes or No."
	note hh_display: Please answer with Yes or No.

	label var hh_02 "Is there any change in the main construction material of the walls of your ho..."
	note hh_02: Is there any change in the main construction material of the walls of your house, since the last time we spoke, 2 years ago?

	label var hh_03 "Is there any change in the main material used for the floors of the dwelling ..."
	note hh_03: Is there any change in the main material used for the floors of the dwelling since the last time we spoke, 2 years ago?

	label var hh_04 "Is there any change in the primary source of drinking water for your househol..."
	note hh_04: Is there any change in the primary source of drinking water for your household since the last time we spoke, 2 years ago?

	label var hh_02_a "What is the main construction material of the walls of your house now?"
	note hh_02_a: What is the main construction material of the walls of your house now?

	label var hh_03_a "What is the main material used for floors of the dwelling now?"
	note hh_03_a: What is the main material used for floors of the dwelling now?

	label var hh_04_a "What is the primary source of drinking water for your household now?"
	note hh_04_a: What is the primary source of drinking water for your household now?

	*--------------	
	* Farmer Groups
	*--------------
	label var start_mod_i "Start Time of Module I: Farmer Groups"
	note start_mod_i: Start Time of Module I: Farmer Groups

	label var oi_assign "OI Treatment or Control Assignment"
	note oi_assign: OI Treatment or Control Assignment

	label var lwh_group "Have LWH Group Name on File"
	note lwh_group: Have LWH Group Name on File

	label var group_name "Name of LWH Group"
	note group_name: Name of LWH Group

	label var lwh "Are you a member of an LWH self-help group?"
	note lwh: Are you a member of an LWH self-help group?

	label var gr_02_confirm "Last time we visited, you said you were a part of LWH Group . Is..."
	note gr_02_confirm: Last time we visited, you said you were a part of LWH Group . Is this information still correct?

	label var gr_02_corrected "What is the name of your LWH group?"
	note gr_02_corrected: What is the name of your LWH group?

	label var gr_10_t "Did any HH member attend a meeting or a training with your LWH farmer self-he..."
	note gr_10_t: Did any HH member attend a meeting or a training with your LWH farmer self-help group during Season 16A, 16B or 16C?

	label var gr_aa "Is anyone in your house a member of an agricultural cooperative?"
	note gr_aa: Is anyone in your house a member of an agricultural cooperative?

	label var gr_16 "Which cooperative?"
	note gr_16: Which cooperative?

	label var gr_26 "What was the total amount of fees paid to the cooperative for the Season 16A,..."
	note gr_26: What was the total amount of fees paid to the cooperative for the Season 16A, 16B and 16C?

	label var gr_27 "Is anyone in your household a member of a water users association (WUA) or an..."
	note gr_27: Is anyone in your household a member of a water users association (WUA) or any other irrigation-related group?

	label var gr_28 "Which water user association?"
	note gr_28: Which water user association?

	label var gr_37 "What was the total amount of fees paid to the water user association during S..."
	note gr_37: What was the total amount of fees paid to the water user association during Season 16A, 16B and 16C?
	
	*-----------------------
	* Income and Expenditure 
	*-----------------------
	label var available_finance2 "You earlier indicated that  is the financial decisi..."
	note available_finance2: You earlier indicated that  is the financial decision maker in the household but that s/he was not available for an interview. Is the s/he available now?

	label var later_finance "Enumerator: Will  be available for an interview whi..."
	note later_finance: Enumerator: Will  be available for an interview while you are still in the village?

	label var available_finance3 "Enumerator: Please save the survey and make an appointment to come back to th..."
	note available_finance3: Enumerator: Please save the survey and make an appointment to come back to the HH.  After your return: Is  available for an interview now?

	label var rf_consent "Hello, My name is …………………………..I am working for L4D Ltd" 
	note rf_consent: Hello, My name is …………………………..I am working for L4D Ltd (High Lands Centre of Leadership and Development (L4D)Ltd.), a private company that has an office in Rwanda, Kigali. L4D is working on behalf of the World Bank’s researchers and MINAGRI and is carrying out an evaluation on the rural development project. The objective of this evaluation is to understand the ways in which farmers are using the agricultural techniques in order to plan for the future and improve their lives. We need to have a discussion with you now. If you agree to participate in this survey, we will ask you some questions related to your household and its members, plots and crops cultivated, seasons, disasters, savings, income and Expenditures.  There is no consequence for participating, neither on you nor on your household in general and there is no reward for someone who participates in the survey. Note: Your participation is voluntary and the information you will provide will be kept with confidentiality. Your response will be coded and kept in computers that are used by someone who has their codes. IB&C and World Bank trained workers are the only one that can disclose your identity. No information will be disclosed to the public and there will be no name in this survey. That is why we ask you to tell us the truth and to provide full information. You can refuse to respond for some questions or stop the interview whenever you want. There will be no consequences. The survey will take no more than 2.5 hours. Some parts of the survey will require an audio interview so that we can have trusted information. It is possible that we will contact you again and have another interview. In case you have a question regarding this survey, you can let us know now or later on the following address: L4D Ltd, Kimihurura ,Gasabo, P.O. Box 6507 Kigali, Rwanda L4D Ltd Survey  manager Jean Bosco NKURIKIYE:   078-8592360 L4D Ltd managing director Prof Dr. Alfred Bizoza:  078-8415218 Do you agree with the consent?
	
	label var start_mod_j "Start Time of Module J: Income and Expenditure"
	note start_mod_j: Start Time of Module J: Income and Expenditure

	label var inc_01 "On-farm enterprise"
	note inc_01: On-farm enterprise

	label var inc_02 "Non-farm enterprise"
	note inc_02: Non-farm enterprise

	label var inc_03 "Renting land"
	note inc_03: Renting land

	label var inc_06 "Interests & dividends"
	note inc_06: Interests & dividends

	label var inc_08 "Selling livestock products"
	note inc_08: Selling livestock products

	label var inc_09 "Gifts"
	note inc_09: Gifts

	label var inc_12 "Terracing for LWH"
	note inc_12: Terracing for LWH

	label var inc_13 "Nurseries for LWH"
	note inc_13: Nurseries for LWH

	label var inc_14 "Composting for LWH"
	note inc_14: Composting for LWH

	label var inc_15 "Selling of Permanent Crop Production"
	note inc_15: Selling of Permanent Crop Production

	label var inc_16 "Income from Public Works Labor (not reported elsewhere)"
	note inc_16: Income from Public Works Labor (not reported elsewhere)

	label var inc_17 "Income from Migratory Work (not reported elsewhere)"
	note inc_17: Income from Migratory Work (not reported elsewhere)

	label var inc_zero "Alert! The HH reported 0 income in total. Are you sure this is correct?"
	note inc_zero: Alert! The HH reported 0 income in total. Are you sure this is correct?

	label var exp_01 "Transportation"
	note exp_01: Transportation

	label var exp_02 "Communication"
	note exp_02: Communication

	label var exp_03 "Clothing and personal belongings"
	note exp_03: Clothing and personal belongings

	label var exp_04 "Leisure"
	note exp_04: Leisure

	label var exp_06 "Water"
	note exp_06: Water

	label var expw_zero "Alert! The HH reported 0 weekly expenditures in total. Are you sure this is c..."
	note expw_zero: Alert! The HH reported 0 weekly expenditures in total. Are you sure this is correct?

	label var exp_08 "School Fees"
	note exp_08: School Fees

	label var exp_10 "Housing"
	note exp_10: Housing

	label var exp_11 "Household assets"
	note exp_11: Household assets

	label var exp_13 "Health insurance"
	note exp_13: Health insurance

	label var exp_14 "Other health expenditure"
	note exp_14: Other health expenditure

	label var exp_15 "Financial Institutions"
	note exp_15: Financial Institutions

	label var exp_16 "Gifts"
	note exp_16: Gifts

	label var exp_17 "Renting or purchasing land"
	note exp_17: Renting or purchasing land

	label var exp_18 "Renting or purchasing agricultural equipment"
	note exp_18: Renting or purchasing agricultural equipment

	label var exp_21 "Investments in own business (on farm or off farm)"
	note exp_21: Investments in own business (on farm or off farm)

	label var exp_22 "Other livestock expenses"
	note exp_22: Other livestock expenses

	label var exp_23 "Other"
	note exp_23: Other

	label var exp_zero "Alert! The HH reported 0 expenditures in total. Are you sure this is correct?"
	note exp_zero: Alert! The HH reported 0 expenditures in total. Are you sure this is correct?

	label var exp_inc_error "Alert! There is more than 50,000 RWF difference between the HHs total INCOME:..."
	note exp_inc_error: Alert! There is more than 50,000 RWF difference between the HHs total INCOME:  and total EXPENSES: . Are you sure this is correct?

	*-------	
	* Assets
	*-------
	label var start_mod_k "Start Time of Module K: Assets"
	note start_mod_k: Start Time of Module K: Assets

	forvalues i = 1/10 {

		label var aa_01_`i' "A`i' Did your household purchase any  from 30 September 2016 throug..."
		note aa_01_`i': A`i' Did your household purchase any  from 30 September 2016 through August 31, 2017?

		label var aa_02_`i' "A`i' How many?"
		note aa_02_`i': A`i' How many?

		label var aa_03_`i' "A`i' How much in total did you spend? (RWF)"
		note aa_03_`i': A`i' How much in total did you spend? (RWF)

		label var aa_04_`i' "A`i' Did your household sell any  from 30 September 2016 through Au..."
		note aa_04_`i': A`i' Did your household sell any  from 30 September 2016 through August 31, 2017?

		label var aa_05_`i' "A`i' How many?"
		note aa_05_`i': A`i' How many?

		label var aa_06_`i' "A`i' How much in total did you earn? (RWF)"
		note aa_06_`i': A`i' How much in total did you earn? (RWF)
	}

	*--------------	
	* Rural Finance
	*--------------
	label var start_mod_rf0 "Start Time of Module RF0: Rural Finance (Overall Impact)"
	note start_mod_rf0: Start Time of Module RF0: Rural Finance (Overall Impact)

	label var rf_1 "Does your HH currently have a formal bank account (at a bank/SACCO/COOPEC)?"
	note rf_1: Does your HH currently have a formal bank account (at a bank/SACCO/COOPEC)?

	label var rf_1_note "On previous surveys or in other data the HH has reported they have a formal s..."
	note rf_1_note: On previous surveys or in other data the HH has reported they have a formal savings account. However, you just told me that you do not have an account. Does this mean that you closed the account you previously had? 

	label var rf_2 "What is your HHs current amount of formal savings in this bank/SACCO/COOPEC? ..."
	note rf_2: What is your HHs current amount of formal savings in this bank/SACCO/COOPEC? (RWF)

	label var rf_4 "What is your HHs current amount of informal savings? (RWF)"
	note rf_4: What is your HHs current amount of informal savings? (RWF)

	label var rf_5 "Has your HH taken any loans from September 2016 to August 2017?"
	note rf_5: Has your HH taken any loans from September 2016 to August 2017?

	label var rf_5_a "What was the source of your loans you have taken between September 2016 to Au..."
	note rf_5_a: What was the source of your loans you have taken between September 2016 to August 2017?

	label var rf_6 "What was the total amount of money borrowed? (RWF)"
	note rf_6: What was the total amount of money borrowed? (RWF)

	*--------------	
	* Food Security
	*--------------
	label var fs_a "Enumerator: For the remaining sections, the respondent must be an adult femal..."
	note fs_a: Enumerator: For the remaining sections, the respondent must be an adult female in the HH. Please select the respondent for the remaining food security sections.

	label var fs_b "Is she available? "
	note fs_b: Is she available? 

	label var female_date "When will  be available?"
	note female_date: When will  be available?

	label var calc_female_date "formatted time for female respondents return"
	note calc_female_date: formatted time for female respondents return

	label var female_date_check "You entered . Is this correct?"
	note female_date_check: You entered . Is this correct?

	label var fs_consent "Hello, My name is …………………………..I am working for L4D Ltd" 
	note fs_consent: Hello, My name is …………………………..I am working for L4D Ltd (High Lands Centre of Leadership and Development (L4D)Ltd.), a private company that has an office in Rwanda, Kigali. L4D is working on behalf of the World Bank’s researchers and MINAGRI and is carrying out an evaluation on the rural development project. The objective of this evaluation is to understand the ways in which farmers are using the agricultural techniques in order to plan for the future and improve their lives. We need to have a discussion with you now. If you agree to participate in this survey, we will ask you some questions related to your household and its members, plots and crops cultivated, seasons, disasters, savings, income and Expenditures.  There is no consequence for participating, neither on you nor on your household in general and there is no reward for someone who participates in the survey. Note: Your participation is voluntary and the information you will provide will be kept with confidentiality. Your response will be coded and kept in computers that are used by someone who has their codes. IB&C and World Bank trained workers are the only one that can disclose your identity. No information will be disclosed to the public and there will be no name in this survey. That is why we ask you to tell us the truth and to provide full information. You can refuse to respond for some questions or stop the interview whenever you want. There will be no consequences. The survey will take no more than 2.5 hours. Some parts of the survey will require an audio interview so that we can have trusted information. It is possible that we will contact you again and have another interview. In case you have a question regarding this survey, you can let us know now or later on the following address: L4D Ltd, Kimihurura ,Gasabo, P.O. Box 6507 Kigali, Rwanda L4D Ltd Survey  manager Jean Bosco NKURIKIYE:   078-8592360 L4D Ltd managing director Prof Dr. Alfred Bizoza:  078-8415218 Do you agree with the consent?
	
	label var start_mod_fs1 "Start Time of Module FS1: Food Security (Household Food Production)"
	note start_mod_fs1: Start Time of Module FS1: Food Security (Household Food Production)

	label var fs_01 "In the past 4 weeks/30 days, was there ever no food to eat of any kind in you..."
	note fs_01: In the past 4 weeks/30 days, was there ever no food to eat of any kind in your house because of lack of resources to get food?

	label var fs_02 "How often did this happen in the past 4 weeks/30 days?"
	note fs_02: How often did this happen in the past 4 weeks/30 days?

	label var fs_03 "In the past 4 weeks/30 days, did you or any household member go to sleep at n..."
	note fs_03: In the past 4 weeks/30 days, did you or any household member go to sleep at night hungry because there was not enough food?

	label var fs_04 "How often did this happen in the past 4 weeks/30 days?"
	note fs_04: How often did this happen in the past 4 weeks/30 days?

	label var fs_05 "In the past 4 weeks/30 days, did you or any household member go a whole day a..."
	note fs_05: In the past 4 weeks/30 days, did you or any household member go a whole day and night without eating anything at all because there was not enough food?

	label var fs_06 "How often did this happen in the past 4 weeks/30 days?"
	note fs_06: How often did this happen in the past 4 weeks/30 days?

	label var start_mod_fs2 "Start Time of Module FS2: Food Security (Household Food Expenditure)"
	note start_mod_fs2: Start Time of Module FS2: Food Security (Household Food Expenditure)

	forvalues i = 1/16 {
		label var exp_25_`i' "E`i' How many days in the last week has your household consumed ?"
		note exp_25_`i': E`i' How many days in the last week has your household consumed ?

		label var exp_26_`i' "E`i' What was the main source of ?"
		note exp_26_`i': E`i' What was the main source of ?

		label var exp_27_q_`i' "E`i' Amount"
		note exp_27_q_`i': E`i' Amount

		label var exp_27_u_`i' "E`i' Units"
		note exp_27_u_`i': E`i' Units

		label var exp_28_q_`i' "E`i' Amount"
		note exp_28_q_`i': E`i' Amount

		label var exp_28_u_`i' "E`i' Units"
		note exp_28_u_`i': E`i' Units

		label var exp_29_`i' "E`i' How much in total did your HH spend on purchased  over the last week? ..."
		note exp_29_`i': E`i' How much in total did your HH spend on purchased  over the last week? (RWF)
	}
	
	label var start_mod_fs3 "Start Time of Module FS3: Food Security (Womens Dietary Diversity Scale)"
	note start_mod_fs3: Start Time of Module FS3: Food Security (Womens Dietary Diversity Scale)

	label var wdds_note "Enumerator Instructions: Ask the respondent to describe the foods (meals and ..."
	note wdds_note: Enumerator Instructions: Ask the respondent to describe the foods (meals and snacks) she ate or drank yesterday during the day and night. Start with the first food or drink of the morning. Write down all foods and drinks mentioned. When composite dishes are mentioned, ask for the list of ingredients. When the respondent has finished, please probe for meals and snacks not mentioned.

	label var wdds_b "Breakfast"
	note wdds_b: Breakfast

	label var wdds_bs "Snack"
	note wdds_bs: Snack

	label var wdds_l "Lunch"
	note wdds_l: Lunch

	label var wdds_ls "Snack"
	note wdds_ls: Snack

	label var wdds_d "Dinner"
	note wdds_ds: Dinner

	label var wdds_ds "Snack"
	note wdds_ds: Snack

	forvalues i = 1/30 {

		cap label var index_areaname_`i'"`i' Index Plot"
		cap note index_areaname_`i': `i' Index Plot

		cap label var area_plot_`i'"`i' Please select the . plot to be measured."
		cap note area_plot_`i': `i' Please select the . plot to be measured.

		cap label var calc_area_plot_`i'"`i' Plot Name"
		cap note calc_area_plot_`i': `i' Plot Name

		cap label var calc_isplot1_`i'"`i' Is Plot 1"
		cap note calc_isplot1_`i': `i' Is Plot 1

		cap label var calc_isplot2_`i'"`i' Is Plot 2"
		cap note calc_isplot2_`i': `i' Is Plot 2

		cap label var calc_isplot3_`i'"`i' Is Plot 3"
		cap note calc_isplot3_`i': `i' Is Plot 3

		cap label var calc_isplot4_`i'"`i' Is Plot 4"
		cap note calc_isplot4_`i': `i' Is Plot 4

		cap label var calc_isplot5_`i'"`i' Is Plot 5"
		cap note calc_isplot5_`i': `i' Is Plot 5

		cap label var calc_isplot6_`i'"`i' Is Plot 6"
		cap note calc_isplot6_`i': `i' Is Plot 6

		cap label var area_available_`i'"`i' Can you measure this plot?"
		cap note area_available_`i': `i' Can you measure this plot?

		cap label var area_unavailable_`i'"`i' Why can you not measure this plot?"
		cap note area_unavailable_`i': `i' Why can you not measure this plot?

		cap label var g_area2_`i'"`i' Measure"
		cap note g_area2_`i': `i' Measure

		cap label var index_area_`i'"`i' Index Measure"
		cap note index_area_`i': `i' Index Measure

		cap label var short_gps_area_`i'"`i' GPS Area"
		cap note short_gps_area_`i': `i' GPS Area

		cap label var area_`i'"`i' Area"
		cap note area_`i': `i' Area
	}

	label var sketch "Enumerator: Please take a picture of the completed plot sketch.  "
	note sketch: Enumerator: Please take a picture of the completed plot sketch.  

	label var comments "Enumerator: Please write here any notes or comments."
	note comments: Enumerator: Please write here any notes or comments.

	label var enumerator "Enumerator"
	note enumerator: Enumerator

	label var team "Team"
	note team: Team

	label var stop_survey1 "DONT READ: You should end the survey and thank the respondent. After leaving ..."
	note stop_survey1: DONT READ: You should end the survey and thank the respondent. After leaving the HH, please call your supervisor for instructions right away.

	label var stop_survey2 "DONT READ: You should end the survey and thank the respondent. After leaving ..."
	note stop_survey2: DONT READ: You should end the survey and thank the respondent. After leaving the HH, please go and find the house and interview the HH head in their new location.

	label var enumeratorother "Enumerator (Other)"
	note enumeratorother: Enumerator (Other)

	*--------------	
	* Multi-selects
	*--------------
		
	cap label var crp_05_a_16_1 "TUBURA"
	cap label var crp_05_a_16_2 "LWH Project"
	cap label var crp_05_a_16_3 "Local government"
	cap label var crp_05_a_16_4 "NGO"
	cap label var crp_05_a_16_5 "Agrodila "
	cap label var crp_05_a_16_6 "CIP"
	cap label var crp_05_a_16_7 "Own production"
	cap label var crp_05_a_16_8 "Neighbor/friend"
	cap label var crp_05_a_16_9 "RAB"
	cap label var crp_05_a_16_10 "Agricultural cooperative"
	cap label var crp_05_a_16_11 "Gift"
	cap label var crp_05_a_16_12 "Local market"
	cap label var crp_05_a_16_999 "Other"
	cap label var crp_05_a_16_-66 "Refuse to answer"
	cap label var crp_05_a_16_-88 "Don't know"
	
	cap label var ex_04_1 ""
	cap label var ex_04_2 ""
	cap label var ex_04_3 ""
	cap label var ex_04_4 ""
	cap label var ex_04_5 ""
	cap label var ex_04_6 ""
	cap label var ex_04_7 ""
	cap label var ex_04_8 ""
	cap label var ex_04_9 ""
	cap label var ex_04_10 ""
	cap label var ex_04_11 ""
	cap label var ex_04_12 ""
	cap label var ex_04_13 ""
	cap label var ex_04_14 ""
	cap label var ex_04_15 ""
	cap label var ex_04_16 ""
	cap label var ex_04_17 ""
	cap label var ex_04_18 ""
	cap label var ex_04_19 ""
	cap label var ex_04_20 ""
	cap label var ex_04_21 ""
	cap label var ex_04_22 ""
	cap label var ex_04_23 ""
	cap label var ex_04_24 ""
	cap label var ex_04_25 ""
	cap label var ex_04_26 ""
	cap label var ex_04_27 ""
	cap label var ex_04_28 ""
	cap label var ex_04_29 ""
	cap label var ex_04_30 ""
	
	cap label var rf_5_a_1 "Bank"
	cap label var rf_5_a_2 "Credit union"
	cap label var rf_5_a_3 "Agricultural cooperatives/farmers' group"
	cap label var rf_5_a_4 "Parents"
	cap label var rf_5_a_5 "Neighbors"
	cap label var rf_5_a_6 "Relatives"
	cap label var rf_5_a_999 "Other"
	
	cap label var wdds_b_1 "IBINYAMPEKE: Ibigori,umuceri,ingano,amasaka,nibindi binyampeke cg ibikomokaho (ubugali bw'ibinyampeke, umutsima,imigati,igikoma n’ibindi)"
	cap label var wdds_b_2 "IBINYAMIZI N'IBINYABIJUMBA: Ibirayi, ibitoki, ubugali bw'ibinyabijumba, ibivunde n’ibindi bikomoka ku binyamizi"
	cap label var wdds_b_3 "IMBOGA N’IBINYABIJUMBA BIKUNGAHAYE KURI VITAMINI A: Ibihaza, karoti, amadegede cyangwa ibijumba bigira ibara rya oranje imbere + izindi mboga zikungahaye kuri vitamini A zikunda kuboneka mu gace batuyemo ( urugero: puwavuro zitukura)"
	cap label var wdds_b_4 "IMBOGA MBISI: mboga z’amababi mabisi yijimye harimo izo mu gasozi+ imboga z’amababi zikungahaye kuri vitamini A zikunda kuboneka aho batuye nka dodo, ibibabi by’imyumbati, kale, epinari"
	cap label var wdds_b_5 "IZINDI MBOGA : Izindi mboga (twavuga nk’ itomati, ibitunguru by'ibijumba, intoryi) + izindi mboga ziboneka mu gace batuyemo"
	cap label var wdds_b_6 "IMBUTO ZIKUNGAHAYE MURI VITAMINI: umwembe uhiye, ipapayi rihiye, iminekye na jus z'imbuto gusa n'izindi imbuto zingira Vitamin A."
	cap label var wdds_b_7 "IZINDI MBUTO: Amatunda bakoramo imitobe"
	cap label var wdds_b_8 "INYAMA Z’IMYANYA Y’IMBERE MU NDA Z’AMATUNGO: Umwijima, impyiko, umutima cyangwa izindi nyama z’imyanya y’imbere mu nda cyangwa ibiribwa birimo ikiremve"
	cap label var wdds_b_9 "Inyama ibazwe ako kanya: Inyama z’inka,izi ngurube, izi nkwavu, izi nkoko, n’ibiguruka bindi, cg udukoko"
	cap label var wdds_b_10 "AMAGI: Amagi y’inkoko, igishuhe, inkanga cyangwa andi magi"
	cap label var wdds_b_11 "AMAFI: Amafi cg amaf mabisi"
	cap label var wdds_b_12 "IBINYAMISOGWE, UBUNYOBWA N’IBINDI BARYA UTUBUTO TW’IMBERE: amavuta y’ubunyobwa Imiteja, ibishimbo, ubunyobwa, cg ibindi bibikomoho, nk’amavuta yabyo"
	cap label var wdds_b_13 "AMATA N’IBIYAKOMOKAHO: Amata, foromaje,yawurute, n’amavuta y’inka"
	cap label var wdds_b_14 "AMAVUTA N’IBINYABINURE: Amavuta bashyira mu biryo bakoresha bateka"
	cap label var wdds_b_15 "IBINYAMASUKARI: Isukari, ubuki, fanta , imitobe , ibinyobwa bidasembuye , ibiribwa by’ibinyasukari nka shokola, amabombo, biswi na keke"
	cap label var wdds_b_16 "IBIRUNGO,INDYOSHYANDYO N’IBINYOBWA: Ibirungo (urusenda, umunyu), indyoshyandyo (isosi ya soya, isosi irimo urusenda, ikawa, icyayi, ibinyobwa bisembuye"
	cap label var wdds_b_17 "Nta nakimwe"
	cap label var wdds_bs_1 "IBINYAMPEKE: Ibigori,umuceri,ingano,amasaka,nibindi binyampeke cg ibikomokaho (ubugali bw'ibinyampeke, umutsima,imigati,igikoma n’ibindi)"
	cap label var wdds_bs_2 "IBINYAMIZI N'IBINYABIJUMBA: Ibirayi, ibitoki, ubugali bw'ibinyabijumba, ibivunde n’ibindi bikomoka ku binyamizi"
	cap label var wdds_bs_3 "IMBOGA N’IBINYABIJUMBA BIKUNGAHAYE KURI VITAMINI A: Ibihaza, karoti, amadegede cyangwa ibijumba bigira ibara rya oranje imbere + izindi mboga zikungahaye kuri vitamini A zikunda kuboneka mu gace batuyemo ( urugero: puwavuro zitukura)"
	cap label var wdds_bs_4 "IMBOGA MBISI: mboga z’amababi mabisi yijimye harimo izo mu gasozi+ imboga z’amababi zikungahaye kuri vitamini A zikunda kuboneka aho batuye nka dodo, ibibabi by’imyumbati, kale, epinari"
	cap label var wdds_bs_5 "IZINDI MBOGA : Izindi mboga (twavuga nk’ itomati, ibitunguru by'ibijumba, intoryi) + izindi mboga ziboneka mu gace batuyemo"
	cap label var wdds_bs_6 "IMBUTO ZIKUNGAHAYE MURI VITAMINI: umwembe uhiye, ipapayi rihiye, iminekye na jus z'imbuto gusa n'izindi imbuto zingira Vitamin A."
	cap label var wdds_bs_7 "IZINDI MBUTO: Amatunda bakoramo imitobe"
	cap label var wdds_bs_8 "INYAMA Z’IMYANYA Y’IMBERE MU NDA Z’AMATUNGO: Umwijima, impyiko, umutima cyangwa izindi nyama z’imyanya y’imbere mu nda cyangwa ibiribwa birimo ikiremve"
	cap label var wdds_bs_9 "Inyama ibazwe ako kanya: Inyama z’inka,izi ngurube, izi nkwavu, izi nkoko, n’ibiguruka bindi, cg udukoko"
	cap label var wdds_bs_10 "AMAGI: Amagi y’inkoko, igishuhe, inkanga cyangwa andi magi"
	cap label var wdds_bs_11 "AMAFI: Amafi cg amaf mabisi"
	cap label var wdds_bs_12 "IBINYAMISOGWE, UBUNYOBWA N’IBINDI BARYA UTUBUTO TW’IMBERE: amavuta y’ubunyobwa Imiteja, ibishimbo, ubunyobwa, cg ibindi bibikomoho, nk’amavuta yabyo"
	cap label var wdds_bs_13 "AMATA N’IBIYAKOMOKAHO: Amata, foromaje,yawurute, n’amavuta y’inka"
	cap label var wdds_bs_14 "AMAVUTA N’IBINYABINURE: Amavuta bashyira mu biryo bakoresha bateka"
	cap label var wdds_bs_15 "IBINYAMASUKARI: Isukari, ubuki, fanta , imitobe , ibinyobwa bidasembuye , ibiribwa by’ibinyasukari nka shokola, amabombo, biswi na keke"
	cap label var wdds_bs_16 "IBIRUNGO,INDYOSHYANDYO N’IBINYOBWA: Ibirungo (urusenda, umunyu), indyoshyandyo (isosi ya soya, isosi irimo urusenda, ikawa, icyayi, ibinyobwa bisembuye"
	cap label var wdds_bs_17 "Nta nakimwe"
	cap label var wdds_d_1 "IBINYAMPEKE: Ibigori,umuceri,ingano,amasaka,nibindi binyampeke cg ibikomokaho (ubugali bw'ibinyampeke, umutsima,imigati,igikoma n’ibindi)"
	cap label var wdds_d_2 "IBINYAMIZI N'IBINYABIJUMBA: Ibirayi, ibitoki, ubugali bw'ibinyabijumba, ibivunde n’ibindi bikomoka ku binyamizi"
	cap label var wdds_d_3 "IMBOGA N’IBINYABIJUMBA BIKUNGAHAYE KURI VITAMINI A: Ibihaza, karoti, amadegede cyangwa ibijumba bigira ibara rya oranje imbere + izindi mboga zikungahaye kuri vitamini A zikunda kuboneka mu gace batuyemo ( urugero: puwavuro zitukura)"
	cap label var wdds_d_4 "IMBOGA MBISI: mboga z’amababi mabisi yijimye harimo izo mu gasozi+ imboga z’amababi zikungahaye kuri vitamini A zikunda kuboneka aho batuye nka dodo, ibibabi by’imyumbati, kale, epinari"
	cap label var wdds_d_5 "IZINDI MBOGA : Izindi mboga (twavuga nk’ itomati, ibitunguru by'ibijumba, intoryi) + izindi mboga ziboneka mu gace batuyemo"
	cap label var wdds_d_6 "IMBUTO ZIKUNGAHAYE MURI VITAMINI: umwembe uhiye, ipapayi rihiye, iminekye na jus z'imbuto gusa n'izindi imbuto zingira Vitamin A."
	cap label var wdds_d_7 "IZINDI MBUTO: Amatunda bakoramo imitobe"
	cap label var wdds_d_8 "INYAMA Z’IMYANYA Y’IMBERE MU NDA Z’AMATUNGO: Umwijima, impyiko, umutima cyangwa izindi nyama z’imyanya y’imbere mu nda cyangwa ibiribwa birimo ikiremve"
	cap label var wdds_d_9 "Inyama ibazwe ako kanya: Inyama z’inka,izi ngurube, izi nkwavu, izi nkoko, n’ibiguruka bindi, cg udukoko"
	cap label var wdds_d_10 "AMAGI: Amagi y’inkoko, igishuhe, inkanga cyangwa andi magi"
	cap label var wdds_d_11 "AMAFI: Amafi cg amaf mabisi"
	cap label var wdds_d_12 "IBINYAMISOGWE, UBUNYOBWA N’IBINDI BARYA UTUBUTO TW’IMBERE: amavuta y’ubunyobwa Imiteja, ibishimbo, ubunyobwa, cg ibindi bibikomoho, nk’amavuta yabyo"
	cap label var wdds_d_13 "AMATA N’IBIYAKOMOKAHO: Amata, foromaje,yawurute, n’amavuta y’inka"
	cap label var wdds_d_14 "AMAVUTA N’IBINYABINURE: Amavuta bashyira mu biryo bakoresha bateka"
	cap label var wdds_d_15 "IBINYAMASUKARI: Isukari, ubuki, fanta , imitobe , ibinyobwa bidasembuye , ibiribwa by’ibinyasukari nka shokola, amabombo, biswi na keke"
	cap label var wdds_d_16 "IBIRUNGO,INDYOSHYANDYO N’IBINYOBWA: Ibirungo (urusenda, umunyu), indyoshyandyo (isosi ya soya, isosi irimo urusenda, ikawa, icyayi, ibinyobwa bisembuye"
	cap label var wdds_d_17 "Nta nakimwe"
	cap label var wdds_ds_1 "IBINYAMPEKE: Ibigori,umuceri,ingano,amasaka,nibindi binyampeke cg ibikomokaho (ubugali bw'ibinyampeke, umutsima,imigati,igikoma n’ibindi)"
	cap label var wdds_ds_2 "IBINYAMIZI N'IBINYABIJUMBA: Ibirayi, ibitoki, ubugali bw'ibinyabijumba, ibivunde n’ibindi bikomoka ku binyamizi"
	cap label var wdds_ds_3 "IMBOGA N’IBINYABIJUMBA BIKUNGAHAYE KURI VITAMINI A: Ibihaza, karoti, amadegede cyangwa ibijumba bigira ibara rya oranje imbere + izindi mboga zikungahaye kuri vitamini A zikunda kuboneka mu gace batuyemo ( urugero: puwavuro zitukura)"
	cap label var wdds_ds_4 "IMBOGA MBISI: mboga z’amababi mabisi yijimye harimo izo mu gasozi+ imboga z’amababi zikungahaye kuri vitamini A zikunda kuboneka aho batuye nka dodo, ibibabi by’imyumbati, kale, epinari"
	cap label var wdds_ds_5 "IZINDI MBOGA : Izindi mboga (twavuga nk’ itomati, ibitunguru by'ibijumba, intoryi) + izindi mboga ziboneka mu gace batuyemo"
	cap label var wdds_ds_6 "IMBUTO ZIKUNGAHAYE MURI VITAMINI: umwembe uhiye, ipapayi rihiye, iminekye na jus z'imbuto gusa n'izindi imbuto zingira Vitamin A."
	cap label var wdds_ds_7 "IZINDI MBUTO: Amatunda bakoramo imitobe"
	cap label var wdds_ds_8 "INYAMA Z’IMYANYA Y’IMBERE MU NDA Z’AMATUNGO: Umwijima, impyiko, umutima cyangwa izindi nyama z’imyanya y’imbere mu nda cyangwa ibiribwa birimo ikiremve"
	cap label var wdds_ds_9 "Inyama ibazwe ako kanya: Inyama z’inka,izi ngurube, izi nkwavu, izi nkoko, n’ibiguruka bindi, cg udukoko"
	cap label var wdds_ds_10 "AMAGI: Amagi y’inkoko, igishuhe, inkanga cyangwa andi magi"
	cap label var wdds_ds_11 "AMAFI: Amafi cg amaf mabisi"
	cap label var wdds_ds_12 "IBINYAMISOGWE, UBUNYOBWA N’IBINDI BARYA UTUBUTO TW’IMBERE: amavuta y’ubunyobwa Imiteja, ibishimbo, ubunyobwa, cg ibindi bibikomoho, nk’amavuta yabyo"
	cap label var wdds_ds_13 "AMATA N’IBIYAKOMOKAHO: Amata, foromaje,yawurute, n’amavuta y’inka"
	cap label var wdds_ds_14 "AMAVUTA N’IBINYABINURE: Amavuta bashyira mu biryo bakoresha bateka"
	cap label var wdds_ds_15 "IBINYAMASUKARI: Isukari, ubuki, fanta , imitobe , ibinyobwa bidasembuye , ibiribwa by’ibinyasukari nka shokola, amabombo, biswi na keke"
	cap label var wdds_ds_16 "IBIRUNGO,INDYOSHYANDYO N’IBINYOBWA: Ibirungo (urusenda, umunyu), indyoshyandyo (isosi ya soya, isosi irimo urusenda, ikawa, icyayi, ibinyobwa bisembuye"
	cap label var wdds_ds_17 "Nta nakimwe"
	cap label var wdds_l_1 "IBINYAMPEKE: Ibigori,umuceri,ingano,amasaka,nibindi binyampeke cg ibikomokaho (ubugali bw'ibinyampeke, umutsima,imigati,igikoma n’ibindi)"
	cap label var wdds_l_2 "IBINYAMIZI N'IBINYABIJUMBA: Ibirayi, ibitoki, ubugali bw'ibinyabijumba, ibivunde n’ibindi bikomoka ku binyamizi"
	cap label var wdds_l_3 "IMBOGA N’IBINYABIJUMBA BIKUNGAHAYE KURI VITAMINI A: Ibihaza, karoti, amadegede cyangwa ibijumba bigira ibara rya oranje imbere + izindi mboga zikungahaye kuri vitamini A zikunda kuboneka mu gace batuyemo ( urugero: puwavuro zitukura)"
	cap label var wdds_l_4 "IMBOGA MBISI: mboga z’amababi mabisi yijimye harimo izo mu gasozi+ imboga z’amababi zikungahaye kuri vitamini A zikunda kuboneka aho batuye nka dodo, ibibabi by’imyumbati, kale, epinari"
	cap label var wdds_l_5 "IZINDI MBOGA : Izindi mboga (twavuga nk’ itomati, ibitunguru by'ibijumba, intoryi) + izindi mboga ziboneka mu gace batuyemo"
	cap label var wdds_l_6 "IMBUTO ZIKUNGAHAYE MURI VITAMINI: umwembe uhiye, ipapayi rihiye, iminekye na jus z'imbuto gusa n'izindi imbuto zingira Vitamin A."
	cap label var wdds_l_7 "IZINDI MBUTO: Amatunda bakoramo imitobe"
	cap label var wdds_l_8 "INYAMA Z’IMYANYA Y’IMBERE MU NDA Z’AMATUNGO: Umwijima, impyiko, umutima cyangwa izindi nyama z’imyanya y’imbere mu nda cyangwa ibiribwa birimo ikiremve"
	cap label var wdds_l_9 "Inyama ibazwe ako kanya: Inyama z’inka,izi ngurube, izi nkwavu, izi nkoko, n’ibiguruka bindi, cg udukoko"
	cap label var wdds_l_10 "AMAGI: Amagi y’inkoko, igishuhe, inkanga cyangwa andi magi"
	cap label var wdds_l_11 "AMAFI: Amafi cg amaf mabisi"
	cap label var wdds_l_12 "IBINYAMISOGWE, UBUNYOBWA N’IBINDI BARYA UTUBUTO TW’IMBERE: amavuta y’ubunyobwa Imiteja, ibishimbo, ubunyobwa, cg ibindi bibikomoho, nk’amavuta yabyo"
	cap label var wdds_l_13 "AMATA N’IBIYAKOMOKAHO: Amata, foromaje,yawurute, n’amavuta y’inka"
	cap label var wdds_l_14 "AMAVUTA N’IBINYABINURE: Amavuta bashyira mu biryo bakoresha bateka"
	cap label var wdds_l_15 "IBINYAMASUKARI: Isukari, ubuki, fanta , imitobe , ibinyobwa bidasembuye , ibiribwa by’ibinyasukari nka shokola, amabombo, biswi na keke"
	cap label var wdds_l_16 "IBIRUNGO,INDYOSHYANDYO N’IBINYOBWA: Ibirungo (urusenda, umunyu), indyoshyandyo (isosi ya soya, isosi irimo urusenda, ikawa, icyayi, ibinyobwa bisembuye"
	cap label var wdds_l_17 "Nta nakimwe"
	cap label var wdds_ls_1 "IBINYAMPEKE: Ibigori,umuceri,ingano,amasaka,nibindi binyampeke cg ibikomokaho (ubugali bw'ibinyampeke, umutsima,imigati,igikoma n’ibindi)"
	cap label var wdds_ls_2 "IBINYAMIZI N'IBINYABIJUMBA: Ibirayi, ibitoki, ubugali bw'ibinyabijumba, ibivunde n’ibindi bikomoka ku binyamizi"
	cap label var wdds_ls_3 "IMBOGA N’IBINYABIJUMBA BIKUNGAHAYE KURI VITAMINI A: Ibihaza, karoti, amadegede cyangwa ibijumba bigira ibara rya oranje imbere + izindi mboga zikungahaye kuri vitamini A zikunda kuboneka mu gace batuyemo ( urugero: puwavuro zitukura)"
	cap label var wdds_ls_4 "IMBOGA MBISI: mboga z’amababi mabisi yijimye harimo izo mu gasozi+ imboga z’amababi zikungahaye kuri vitamini A zikunda kuboneka aho batuye nka dodo, ibibabi by’imyumbati, kale, epinari"
	cap label var wdds_ls_5 "IZINDI MBOGA : Izindi mboga (twavuga nk’ itomati, ibitunguru by'ibijumba, intoryi) + izindi mboga ziboneka mu gace batuyemo"
	cap label var wdds_ls_6 "IMBUTO ZIKUNGAHAYE MURI VITAMINI: umwembe uhiye, ipapayi rihiye, iminekye na jus z'imbuto gusa n'izindi imbuto zingira Vitamin A."
	cap label var wdds_ls_7 "IZINDI MBUTO: Amatunda bakoramo imitobe"
	cap label var wdds_ls_8 "INYAMA Z’IMYANYA Y’IMBERE MU NDA Z’AMATUNGO: Umwijima, impyiko, umutima cyangwa izindi nyama z’imyanya y’imbere mu nda cyangwa ibiribwa birimo ikiremve"
	cap label var wdds_ls_9 "Inyama ibazwe ako kanya: Inyama z’inka,izi ngurube, izi nkwavu, izi nkoko, n’ibiguruka bindi, cg udukoko"
	cap label var wdds_ls_10 "AMAGI: Amagi y’inkoko, igishuhe, inkanga cyangwa andi magi"
	cap label var wdds_ls_11 "AMAFI: Amafi cg amaf mabisi"
	cap label var wdds_ls_12 "IBINYAMISOGWE, UBUNYOBWA N’IBINDI BARYA UTUBUTO TW’IMBERE: amavuta y’ubunyobwa Imiteja, ibishimbo, ubunyobwa, cg ibindi bibikomoho, nk’amavuta yabyo"
	cap label var wdds_ls_13 "AMATA N’IBIYAKOMOKAHO: Amata, foromaje,yawurute, n’amavuta y’inka"
	cap label var wdds_ls_14 "AMAVUTA N’IBINYABINURE: Amavuta bashyira mu biryo bakoresha bateka"
	cap label var wdds_ls_15 "IBINYAMASUKARI: Isukari, ubuki, fanta , imitobe , ibinyobwa bidasembuye , ibiribwa by’ibinyasukari nka shokola, amabombo, biswi na keke"
	cap label var wdds_ls_16 "IBIRUNGO,INDYOSHYANDYO N’IBINYOBWA: Ibirungo (urusenda, umunyu), indyoshyandyo (isosi ya soya, isosi irimo urusenda, ikawa, icyayi, ibinyobwa bisembuye"
	cap label var wdds_ls_17 "Nta nakimwe"
	
	cap label var leave_1 "School"
	cap label var leave_2 "Marriage"
	cap label var leave_3 "Divorce"
	cap label var leave_4 "Deceased"
	cap label var leave_5 "Migrated for work"
	cap label var leave_999 "Other"
	
	cap label var plotmatch_1_0 "No matching plot"
	cap label var plotmatch_1_1 ""
	cap label var plotmatch_1_2 ""
	cap label var plotmatch_1_3 ""
	cap label var plotmatch_1_4 ""
	cap label var plotmatch_1_5 ""
	cap label var plotmatch_1_6 ""
	cap label var plotmatch_2_0 "No matching plot"
	cap label var plotmatch_2_1 ""
	cap label var plotmatch_2_2 ""
	cap label var plotmatch_2_3 ""
	cap label var plotmatch_2_4 ""
	cap label var plotmatch_2_5 ""
	cap label var plotmatch_2_6 ""
	cap label var plotmatch_3_0 "No matching plot"
	cap label var plotmatch_3_1 ""
	cap label var plotmatch_3_2 ""
	cap label var plotmatch_3_3 ""
	cap label var plotmatch_3_4 ""
	cap label var plotmatch_3_5 ""
	cap label var plotmatch_3_6 ""
	cap label var plotmatch_4_0 "No matching plot"
	cap label var plotmatch_4_1 ""
	cap label var plotmatch_4_2 ""
	cap label var plotmatch_4_3 ""
	cap label var plotmatch_4_4 ""
	cap label var plotmatch_4_5 ""
	cap label var plotmatch_4_6 ""
	cap label var plotmatch_5_0 "No matching plot"
	cap label var plotmatch_5_1 ""
	cap label var plotmatch_5_2 ""
	cap label var plotmatch_5_3 ""
	cap label var plotmatch_5_4 ""
	cap label var plotmatch_5_5 ""
	cap label var plotmatch_5_6 ""
	cap label var plotmatch_6_0 "No matching plot"
	cap label var plotmatch_6_1 ""
	cap label var plotmatch_6_2 ""
	cap label var plotmatch_6_3 ""
	cap label var plotmatch_6_4 ""
	cap label var plotmatch_6_5 ""
	cap label var plotmatch_6_6 ""
	
	cap label var why_add_1 "School"
	cap label var why_add_2 "Marriage"
	cap label var why_add_3 "Divorce"
	cap label var why_add_4 "Born"
	cap label var why_add_5 "Migrated for work"
	cap label var why_add_6 "Migrated because of hunger"
	cap label var why_add_999 "Other"
	
		************************* Create value labels *************************
	label define area_confidence 1 "Not Confident", modify 
	label define area_confidence 2 "Somewhat Confident", modify 
	label define area_confidence 3 "Very Confident", modify 
	
	label define area_units 1 "Acres", modify 
	label define area_units 2 "Hectares", modify 
	label define area_units 3 "Square Meters", modify 
	label define area_units 4 "6 Acres", modify 
	
	label define cooperatives -66 "Refuse to answer", modify 
	label define cooperatives -88 "Don't know", modify 
	label define cooperatives 1 "KOTIRU", modify 
	label define cooperatives 2 "COTUABIKI", modify 
	label define cooperatives 3 "COPAVABU", modify 
	label define cooperatives 4 "COOPAG", modify 
	label define cooperatives 5 "IMBEREHEZA", modify 
	label define cooperatives 6 "GWIZA 34", modify 
	label define cooperatives 7 "HIRWA", modify 
	label define cooperatives 999 "Other", modify 
	
	label define correct 0 "Go back and correct", modify 
	label define correct 1 "The answer entered is accurate", modify 
	
	label define crop_codes 10 "Peas", modify 
	label define crop_codes 11 "Soybeans", modify 
	label define crop_codes 12 "Groundnuts", modify 
	label define crop_codes 13 "Green Beans", modify 
	label define crop_codes 14 "Spinach", modify 
	label define crop_codes 15 "Cabbage", modify 
	label define crop_codes 16 "Carrots", modify 
	label define crop_codes 17 "Amaranthus", modify 
	label define crop_codes 18 "Broccoli", modify 
	label define crop_codes 19 "Cauliflower", modify 
	label define crop_codes 2 "Wheat", modify 
	label define crop_codes 20 "Sukumawiki", modify 
	label define crop_codes 21 "Beetroot", modify 
	label define crop_codes 22 "Lettuce", modify 
	label define crop_codes 23 "Celery", modify 
	label define crop_codes 24 "Parsley", modify 
	label define crop_codes 25 "Onions", modify 
	label define crop_codes 26 "Tomatoes", modify 
	label define crop_codes 27 "Sweet Pepper", modify 
	label define crop_codes 28 "Eggplant", modify 
	label define crop_codes 29 "Pumpkin", modify 
	label define crop_codes 3 "Rice", modify 
	label define crop_codes 30 "Pepper", modify 
	label define crop_codes 31 "Chillies", modify 
	label define crop_codes 32 "Lemon", modify 
	label define crop_codes 33 "Ginger", modify 
	label define crop_codes 34 "Garlic", modify 
	label define crop_codes 35 "Mandarine", modify 
	label define crop_codes 36 "Watermelon", modify 
	label define crop_codes 37 "Strawberry", modify 
	label define crop_codes 38 "Elephant Grasses", modify 
	label define crop_codes 4 "Sorghum", modify 
	label define crop_codes 5 "Irish Potatoes", modify 
	label define crop_codes 6 "Sweet Potatoes", modify 
	label define crop_codes 7 "Talo", modify 
	label define crop_codes 75 "Maize", modify 
	label define crop_codes 8 "Yam", modify 
	label define crop_codes 9 "Dry Beans", modify 
	label define crop_codes 999 "Other", modify 
	
	label define ed_level -66 "Refuse to answer", modify 
	label define ed_level -88 "Don't know", modify 
	label define ed_level 1 "None", modify 
	label define ed_level 2 "Some primary", modify 
	label define ed_level 3 "Completed primary", modify 
	label define ed_level 4 "Some secondary", modify 
	label define ed_level 5 "Completed secondary", modify 
	label define ed_level 6 "Professional training", modify 
	label define ed_level 7 "Some university", modify 
	label define ed_level 8 "University", modify 
	
	label define end_survey 1 "Yes", modify 
	
	label define floor 1 "Mud/Earth/Sand", modify 
	label define floor 2 "Dung ", modify 
	label define floor 3 "Wood", modify 
	label define floor 4 "Clay", modify 
	
	label define food_source -66 "Refuse to answer", modify 
	label define food_source -88 "Don't know", modify 
	label define food_source 1 "Own production", modify 
	label define food_source 2 "Hunting/gathering/fishing", modify 
	label define food_source 3 "Exchange (labor/food)", modify 
	label define food_source 4 "Borrowed", modify 
	label define food_source 5 "Purchased", modify 
	label define food_source 6 "Gifts from relatives ", modify 
	label define food_source 7 "NGO, GoR", modify 
	
	label define food_units 1 "kg", modify 
	label define food_units 10 "10 ml Ikiyiko", modify 
	label define food_units 11 "Wheelbarrow", modify 
	label define food_units 12 "Oxcarts ", modify 
	label define food_units 13 "Mironko (1.5 kg)", modify 
	label define food_units 14 "Bucket (2.5kg)", modify 
	label define food_units 15 "Bucket (5 kg)", modify 
	label define food_units 16 "10 kg basket", modify 
	label define food_units 17 "15 kg basket", modify 
	label define food_units 18 "Pieces ", modify 
	label define food_units 2 "25 Kg sack", modify 
	label define food_units 20 "Bundle", modify 
	label define food_units 21 "Basin ", modify 
	label define food_units 23 "Loaves", modify 
	label define food_units 24 "Trays (24 Eggs)", modify 
	label define food_units 25 "Agakoroboyi (10 ml)", modify 
	label define food_units 3 "50 Kg sack", modify 
	label define food_units 4 "100 Kg sack", modify 
	label define food_units 5 "grams", modify 
	label define food_units 6 "tons", modify 
	label define food_units 7 "ml", modify 
	label define food_units 8 "liters", modify 
	label define food_units 9 "5 ml Ikiyiko", modify 
	
	label define fs_respondent 1 "Yes", modify 
	label define fs_respondent 2 "No, she is not available at this time, but will be available before I leave the village", modify 
	label define fs_respondent 3 "No, she is not available now, but will be available on a later date", modify 
	label define fs_respondent 4 "No, no one is available in this HH at all", modify 
	label define fs_respondent 5 "Another female adult is available now.", modify 
	
	label define hh_not_exist 1 "Moved permanently", modify 
	label define hh_not_exist 2 "Moved temporarily", modify 
	label define hh_not_exist 3 "HH split up", modify 
	label define hh_not_exist 999 "Other", modify 
	
	label define hh_roster 1 "", modify 
	label define hh_roster 2 "", modify 
	label define hh_roster 3 "", modify 
	label define hh_roster 4 "", modify 
	label define hh_roster 5 "", modify 
	label define hh_roster 6 "", modify 
	label define hh_roster 7 "", modify 
	label define hh_roster 8 "", modify 
	label define hh_roster 9 "", modify 	
	label define hh_roster 10 "", modify 
	label define hh_roster 11 "", modify 
	label define hh_roster 12 "", modify 
	label define hh_roster 13 "", modify 
	label define hh_roster 14 "", modify 
	label define hh_roster 15 "", modify 
	label define hh_roster 16 "", modify 
	label define hh_roster 17 "", modify 
	label define hh_roster 18 "", modify 
	label define hh_roster 19 "", modify 	
	label define hh_roster 20 "", modify 
	label define hh_roster 21 "", modify 
	label define hh_roster 22 "", modify 
	label define hh_roster 23 "", modify 
	label define hh_roster 24 "", modify 
	label define hh_roster 25 "", modify 
	label define hh_roster 26 "", modify 
	label define hh_roster 27 "", modify 
	label define hh_roster 28 "", modify 
	label define hh_roster 29 "", modify 
	label define hh_roster 30 "", modify 
	
	label define hhh_change -66 "Refuse to answer", modify 
	label define hhh_change -88 "Don't know", modify 
	label define hhh_change 1 "Moved within cell", modify 
	label define hhh_change 2 "Moved away from cell", modify 
	label define hhh_change 3 "Died", modify 
	
	label define hhs_often -66 "Refuse to answer", modify 
	label define hhs_often -88 "Don't know", modify 
	label define hhs_often 1 "Rarely (1-2 times in past 4 weeks)", modify 
	label define hhs_often 2 "Sometimes (3-10 times in past 4 weeks)", modify 
	label define hhs_often 3 "Often (more than 10 times in past 4 weeks)", modify 
	
	label define identifier 1 "Only the village is incorrect", modify 
	label define identifier 2 "More than just the village is incorrect", modify 
	
	label define input_quantity_units 1 "Kg", modify 
	label define input_quantity_units 10 "10 ml", modify 
	label define input_quantity_units 11 "Wheelbarrow: Ingorofani", modify 
	label define input_quantity_units 13 "1.5 Kg", modify 
	label define input_quantity_units 14 "2.5kg Bucket ", modify 
	label define input_quantity_units 15 "2.5kg Bucket ", modify 
	label define input_quantity_units 16 "10 Kg Basket", modify 
	label define input_quantity_units 17 "15 Kg Basket", modify 
	label define input_quantity_units 2 "25 Kg Sack", modify 
	label define input_quantity_units 3 "50 Kg Sack", modify 
	label define input_quantity_units 4 "100 Kg Sack", modify 
	label define input_quantity_units 5 "Grams", modify 
	label define input_quantity_units 6 "Tons", modify 
	label define input_quantity_units 7 "ml", modify 
	label define input_quantity_units 8 "Liters", modify 
	label define input_quantity_units 9 "5 ml", modify 

	label define lwh_group -66 "Refuse to answer", modify 
	label define lwh_group -88 "Don't know", modify 
	label define lwh_group 390 "aa", modify 
	
	label define maize 1 "Green maize", modify 
	label define maize 2 "Dry maize", modify 
	label define maize 3 "Both", modify 
	
	label define months -66 "Refuse to answer", modify 
	label define months -88 "Don't know", modify 
	label define months 1 "September 2016", modify 
	label define months 2 "October 2016", modify 
	label define months 3 "November 2016", modify 
	label define months 4 "December 2016", modify 
	label define months 5 "January 2017", modify 
	label define months 6 "February 2017", modify 
	label define months 7 "March 2017", modify 
	label define months 8 "April 2017", modify 
	label define months 9 "May 2017", modify 
	label define months 10 "June 2017", modify 
	label define months 11 "July 2017", modify 
	label define months 12 "August 2017", modify 
	label define months 13 "September 2017", modify 
	
	label define ownership_status 1 "Owned", modify 
	label define ownership_status 2 "Rented", modify 
	label define ownership_status 3 "Shared family plot", modify 
	label define ownership_status 4 "Government-owned", modify 
	label define ownership_status 5 "Rented without payment", modify 
	
	label define plot_data 2 "Land title", modify 
	label define plot_data 3 "Self-reported", modify 
	label define plot_data 4 "Plot within land title area - land title & self reported", modify 
	
	label define plot_location -66 "Refuse to answer", modify 
	label define plot_location -88 "Don't know", modify 
	label define plot_location 1 "Hilltop", modify 
	label define plot_location 2 "Hillside", modify 
	label define plot_location 3 "Hill foot", modify 
	label define plot_location 4 "Plain", modify 
	label define plot_location 5 "Marsh", modify 
	
	label define plotlist 1 "", modify 
	label define plotlist 2 "", modify 
	label define plotlist 3 "", modify 
	label define plotlist 4 "", modify 
	label define plotlist 5 "", modify 
	label define plotlist 6 "", modify 
	
	label define post_harvest_infrastructures -66 "Refuse to answer", modify 
	label define post_harvest_infrastructures -88 "Don't know", modify 
	label define post_harvest_infrastructures 1 "Big wood/bamboo basket with cow dung, outside house", modify 
	label define post_harvest_infrastructures 2 "wood/bamboo basket, inside house", modify 
	label define post_harvest_infrastructures 3 "Public storage facility (non-LWH)", modify 
	label define post_harvest_infrastructures 4 "LWH Storage facility", modify 
	label define post_harvest_infrastructures 5 "Sack", modify 
	label define post_harvest_infrastructures 999 "Other", modify 
	
	label define proportion 0 "<5%", modify 
	label define proportion 1 "5%", modify 
	label define proportion 10 "50%", modify 
	label define proportion 11 "55.%", modify 
	label define proportion 12 "60%", modify 
	label define proportion 13 "65%", modify 
	label define proportion 14 "70%", modify 
	label define proportion 15 "75%", modify 
	label define proportion 16 "80%", modify 
	label define proportion 17 "85%", modify 
	label define proportion 18 "90%", modify 
	label define proportion 19 "95%", modify 
	label define proportion 2 "10%", modify 
	label define proportion 20 "100%", modify 
	label define proportion 3 "15%", modify 
	label define proportion 4 "20%", modify 
	label define proportion 5 "25%", modify 
	label define proportion 6 "30%", modify 
	label define proportion 7 "35%", modify 
	label define proportion 8 "40%", modify 
	label define proportion 9 "45%", modify 
	
	label define quantity_units 1 "kg", modify 
	label define quantity_units 11 "Wheelbarrow", modify 
	label define quantity_units 13 "Mironko (1.5 kg)", modify 
	label define quantity_units 14 "Bucket (2.5kg)", modify 
	label define quantity_units 15 "Bucket (5 kg)", modify 
	label define quantity_units 16 "10 kg basket", modify 
	label define quantity_units 17 "15 kg basket", modify 
	label define quantity_units 2 "25 Kg sack", modify 
	label define quantity_units 3 "50 Kg sack", modify 
	label define quantity_units 4 "100 Kg sack", modify 
	label define quantity_units 5 "grams", modify 
	label define quantity_units 6 "tons", modify 
	label define quantity_units 77 "N/A", modify 
	
	label define relationship_to_hhh -66 "Refuse To Answer", modify 
	label define relationship_to_hhh -88 "Don't Know", modify 
	label define relationship_to_hhh 1 "HHH", modify 
	label define relationship_to_hhh 2 "Spouse of HHH", modify 
	label define relationship_to_hhh 3 "Son/Daughter", modify 
	label define relationship_to_hhh 4 "Parent", modify 
	label define relationship_to_hhh 5 "Sibling", modify 
	label define relationship_to_hhh 6 "Other Relative", modify 
	label define relationship_to_hhh 7 "No Relation", modify 
	label define relationship_to_hhh 999 "Other", modify 
	
	label define season_year -66 "Refuse to answer", modify 
	label define season_year -88 "Don't know", modify 
	label define season_year 1	"Season A 17 (September 2016 – February 2017)", modify
	label define season_year 2	"Season B 17 (March – June 2017)", modify
	label define season_year 3	"Season C 17 (July - August 2017)", modify
	label define season_year 4	"Season A 16 (September 2015 – February 2016)", modify
	label define season_year 5	"Season B 16 (March – June 2016)", modify
	label define season_year 6	"Season C 16 (July - August 2016)", modify
	label define season_year 7	"Season A 15 (September 2014 – February 2015)", modify
	label define season_year 8	"Season B 15 (March – June 2015)", modify
	label define season_year 9	"Season C 15 (July - August 2015)", modify
	label define season_year 10	"Season A 14 (September 2013 - February 2014)", modify
	label define season_year 11	"Season B 14 (February - September 2014)", modify
	label define season_year 12	"Season C 14 (July - August 2014)", modify
	label define season_year 13	"Season A 13 (September 2012 - February 2013)", modify
	label define season_year 14	"Season B 13 (February - September 2013)", modify
	label define season_year 15	"Season C 13 (July - August 2013)", modify
	label define season_year 16	"Season A 12  (September 2011 - Februrary 2012)", modify
	label define season_year 17	"Season B 12 (February - September 2012)", modify
	label define season_year 18	"Season C 12 (July - August 2012)", modify
	label define season_year 19	"Before Season 11A (August 2010  - February 2011)", modify
	
	label define sex 1 "Male", modify 
	label define sex 2 "Female", modify 
	
	label define type_terrace -66 "Refuse to answer", modify 
	label define type_terrace -88 "Don't know", modify 
	label define type_terrace 1 "Radical", modify 
	label define type_terrace 2 "Progressive", modify 
	
	label define wall 1 "Adobe/Unburnt bricks", modify 
	label define wall 2 "Cement bricks", modify 
	label define wall 3 "Fired bricks ", modify 
	label define wall 4 "Planks/Timber", modify 
	label define wall 5 "Cemented mud and wattle", modify 
	label define wall 6 "Uncemented mud and wattle", modify 
	
	label define water_source 1 "Tap inside house", modify 
	label define water_source 2 "Tap on property ", modify 
	label define water_source 3 "Public tap", modify 
	label define water_source 4 "Tube well or borehole", modify 
	label define water_source 5 "Protected well", modify 
	label define water_source 6 "Unprotected well", modify 
	label define water_source 7 "Protected spring", modify 
	
	label define wuas -66 "Refuse to answer", modify 
	label define wuas -88 "Don't know", modify 
	label define wuas 1 "ABAGENDANANIGIHE", modify 
	label define wuas 2 "UBUZIMA-BWIZA", modify 
	label define wuas 999 "Other", modify 
	
	label define yes_no 0 "No", modify 
	label define yes_no 1 "Yes", modify 
	
	label define zero_harvest 1 "Crop disease", modify 
	label define zero_harvest 2 "Crop theft", modify 
	label define zero_harvest 3 "Crop destruction", modify 
	label define zero_harvest 4 "Draught", modify 
	label define zero_harvest 999 "Other", modify 
	
	label define loan_source 1 "Bank", modify
	label define loan_source 2 "Credit union", modify	
	label define loan_source 3 "Agricultural cooperatives/farmers' group", modify
	label define loan_source 4 "Parents", modify	
	label define loan_source 5 "Neighbors", modify	
	label define loan_source 6 "Relatives", modify	
	label define loan_source 999 "Other", modify		
	
	label define price_source 1	  "Familiy members and relative", modify
	label define price_source 2	  "Neighbors", modify
	label define price_source 3	  "Your vendors", modify
	label define price_source 4	  "People from your main point of sales", modify
	label define price_source 999 "Other", modify	
	label define price_source -66 "Refuse to answer", modify		
	label define price_source -88 "Don't know", modify			
	
	label define transport 1 "On foot", modify
	label define transport 2 "Bicycle", modify	
	label define transport 3 "Public transport", modify	
	label define transport 4 "Hired vehicle", modify	
	label define transport 5 "Vehicle provided by buyer", modify	
	label define transport 6 "Boat", modify	
	label define transport 999 "Other", modify
	label define transport -66 "-66", modify	
	label define transport -88 "-88", modify		
	
	label define market 1 "Neighbor/friend", modify 
	label define market 2 "Local Shop", modify 	
	label define market 3 "No market--directly at home/farm", modify 
	label define market 4 "No market--directly at other households", modify 	
	label define market 5 "Market", modify 	
	label define market 6 "Collection Center/cooperative", modify 	
	label define market 999 "Other", modify 	
	label define market -66 "Refuse to answer", modify 	
	label define market -88 "Don't know", modify 	

	label define difficulty 1 "Easy", modify
	label define difficulty 2 "Difficult", modify	
	label define difficulty 3 "Very difficult", modify	
	
	label define irrigation_method	1 "Watering Can/Buchet/Basin", modify
	label define irrigation_method	2 "Sprinkler", modify	
	label define irrigation_method	3 "Sprayed Water on Crops Using Hose", modify	
	label define irrigation_method	4 "Transverse Furrows", modify	
	label define irrigation_method	5 "Longitudinal Furrows	", modify
	
		************************* Put value labels *************************	
	label values aa_01_* yes_no
	label values aa_04_* yes_no
	label values ag_08_* yes_no
	label values ag_11u_* input_quantity_units
	label values ag_17_x_16_* yes_no
	label values ag_17_y_16_* yes_no
	label values ag_17_z_16_* yes_no
	label values crp_02_16_* months
	label values crp_03_q_16_* proportion
	label values crp_04_u_16_* quantity_units
	label values crp_07_16_* yes_no
	label values crp_08_0_* zero_harvest
	label values crp_08_du_16_* quantity_units
	label values crp_08_gd_16_* maize
	label values crp_08_gu_16_* quantity_units
	label values crp_08_u_16_* quantity_units
	label values crp_09_du_16_* quantity_units
	label values crp_09_gd_16_* maize
	label values crp_09_gu_16_* quantity_units
	label values crp_09_u_16_* quantity_units
	label values crp_15_du_16_* quantity_units
	label values crp_15_gd_16_* maize
	label values crp_15_gu_16_* quantity_units
	label values crp_15_u_16_* quantity_units
	label values crp_25_du_16_* quantity_units
	label values crp_25_gd_16_* maize
	label values crp_25_gu_16_* quantity_units
	label values crp_25_u_16_* quantity_units
	label values crp_26_16_* yes_no
	label values crp_27_16_* post_harvest_infrastructures
	label values crp_50_16_* yes_no
	label values exp_26_* food_source
	label values exp_27_u_* food_units
	label values exp_28_u_* food_units
	label values ex_01_* yes_no
	label values ex_02_* yes_no
	label values ex_08_* yes_no
	label values fs_01 yes_no
	label values fs_02 hhs_often
	label values fs_03 yes_no
	label values fs_04 hhs_often
	label values fs_05 yes_no
	label values fs_06 hhs_often
	label values fs_a hh_roster
	label values fs_b fs_respondent
	label values gr_02_confirm yes_no
	label values gr_02_corrected lwh_group
	label values gr_10_t yes_no
	label values gr_16 cooperatives
	label values gr_27 yes_no
	label values gr_28 wuas
	label values gr_aa yes_no
	label values lab_01_* yes_no
	label values lab_03_* yes_no
	label values lab_06_* yes_no
	label values pl_16_16_* yes_no
	label values rf_1 yes_no
	label values rf_5 yes_no

	label values ag10_16_* hh_roster
	label values ag11_16_* hh_roster
	label values ag12 yes_no
	label values ag13 season_year
	label values ag4_? plot_location
	label values ag6u_* area_units
	label values ag6u_a_* area_confidence
	label values ag7_* plot_data
	label values ag8_16_* yes_no
	label values ag9_16c1_* crop_codes
	label values ag9_16c2_* crop_codes
	label values ag9_16c3_* crop_codes
	label values ag_12_* ownership_status
	label values ag_coop_* yes_no
	label values area_available_* yes_no
	label values area_plot_* plotlist
	label values audio_consent yes_no
	label values available_finance yes_no
	label values available_finance2 yes_no
	label values available_finance3 yes_no
	label values check_age_* yes_no
	label values check_left yes_no
	label values check_over18_* yes_no
	label values check_over18_new_* yes_no
	label values consent yes_no
	label values coop_exists_* yes_no
	label values crp_06o_16_* yes_no
	label values crp_08o_16_* yes_no
	label values crp_10o_16_* yes_no
	label values decisionmaker hh_roster
	label values education_* ed_level
	label values education_new_* ed_level
	*label values enumerator enumerator
	label values exist yes_no
	label values exp_inc_error yes_no
	label values exp_zero yes_no
	label values expw_zero yes_no
	label values female_date_check yes_no
	label values first_appointment yes_no
	label values first_available yes_no
	label values first_date_check yes_no
	label values fix_age_* correct
	label values fix_age_new_* correct
	label values fs_consent yes_no
	label values hh_02 yes_no
	label values hh_02_a wall
	label values hh_03 yes_no
	label values hh_03_a floor
	label values hh_04 yes_no
	label values hh_04_a water_source
	label values hh_display yes_no
	label values hh_new yes_no
	label values hhh_change hhh_change
	label values hhh_confirm yes_no
	label values hhh_remain yes_no
	label values hhh_new yes_no
	label values hhh_new_sex 
	label values first_visit yes_no
	*label values id_04 supervisor
	label values id_07_corrected cell
	label values id_08_corrected sector
	label values id_09_corrected district
	label values id_12_confirm yes_no
	label values id_24_have yes_no
	label values id_all_confirm yes_no
	label values id_correct_specify identifier
	label values inc_zero yes_no
	label values is_respondent_finance yes_no
	label values later_finance yes_no
	label values lwh yes_no
	label values member_* yes_no
	label values pl_35_* yes_no
	label values pl_36_* proportion
	label values pl_t1_* yes_no
	label values pl_t3_* type_terrace
	label values proportion_gift_* proportion
	label values proportion_own_* proportion
	label values relationship_* relationship_to_hhh
	label values respondent_finance hh_roster
	label values respondent_main hh_roster
	label values revisit yes_no
	label values rf_1_note yes_no
	label values rf_consent yes_no
	label values school_* yes_no
	label values school_new_* yes_no
	label values second_appointment yes_no
	label values second_available yes_no
	label values second_date_check yes_no
	label values second_respondent yes_no
	label values sex_new_* sex
	label values stop_survey1 end_survey
	label values stop_survey2 end_survey
	label values t_1_b yes_no
	label values t_1_c yes_no
	label values t_1_j yes_no
	label values t_1_l yes_no
	label values t_1_o yes_no
	label values t_1_p yes_no
	label values t_1_q yes_no
	label values t_2_b season_year
	label values t_2_c season_year
	label values t_2_j season_year
	label values t_2_l season_year
	label values t_2_o season_year
	label values t_2_p season_year
	label values t_2_q season_year
	label values third_appointment yes_no
	label values third_available yes_no
	label values third_date_check yes_no
	label values third_respondent yes_no
	label values why_dropped hh_not_exist
	
	label values crp_11_a_?_* price_source
	label values crp_11_b_?_* market		
	label values crp_11_c_?_* difficulty
	label values crp_11_d_?_* transport
	
		******************** Merge with sample dataset ********************
	
	* Rename variables in the preload = sample listing
	preserve 
		
		import delimited "$preload\HH list for full survey\preload_data_HH", clear // This is for the full.

		keep id_09 headid id_11 id_08 id_07 id_06 samplehh 
		
		/* Somehow when I export to csv this happens and I can't fix it. So must be dropped and destringed.
		   No effecte to the form and the number of HHs.*/
		drop if headid == "; In Village: ; Location: Hilltop"
		destring headid samplehh, replace
	
		rename id_09		sample_district
		rename headid		hh_code
		rename id_11	 	sample_hhh
		rename id_08		sample_sector
		rename id_07		sample_cell
		rename id_06		sample_village
		rename samplehh		sample
		
		mmerge hh_code using "$sample\endline-listing.dta", ukeep(id_23latitude id_23longitude id_23altitude id_23accuracy)
		assert _merge == 3
		
		rename id_23latitude  sample_gps_latitude 
		rename id_23longitude sample_gps_longitude
		rename id_23altitude  sample_gps_altitude
		rename id_23accuracy  sample_gps_accuracy
		rename hh_code		  id_05
			
		tempfile sample_master
		save `sample_master'
	restore 
	
	* Merge with the sample listing
	merge m:1 id_05 using `sample_master', keepusing(sample sample_gps_*) keep(master match) gen(merge_sample)
	label var merge_sample "Merge: Sample"
	assert merge_sample == 3 // Sanity check. All should match.
	
		******************** Flag newly imported observations ********************
	merge 1:1 key using `raw_dta', keepusing(key) keep(master match) gen(new_obs)
	replace new_obs = new_obs == 1
	label var new_obs "New Observation"

	save "$data\lwh_oi_endline_clean_00.dta", replace

	
