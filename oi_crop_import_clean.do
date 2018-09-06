

	*----------------
	* Import raw data
	*----------------
	import delimited using "$raw_data/LWH Crops_WIDE.csv", clear
	
	*--------------------------	
	* Check and drop duplicates
	*--------------------------
	replace team_cr = "Egidie" if team == "B"
	replace team_cr = "Andre" if team == "C"
	replace team_cr = "Emerance" if team == "D"
	replace team_cr = "Diane" if team == "E"
	replace team_cr = "Freddy" if team == "F"		
	ieduplicates id_05, folder("$high_freq_check\duplicates_report_crop") uniquevars(key) keep(team_cr submissiondate enumerator_cr enumeratorother_cr)

	*---------
	* Clean up
	*---------	
	foreach var of varlist plotmatch_1 plotmatch_2 plotmatch_3 plotmatch_4 ///
						   plotmatch_5 plotname_6 coop_name_* unit_* crop_16_* ///
						   pl_t2m_* crp_27_16_* {
		tostring `var', replace
		replace `var' = "" if `var' == "."
	}
	foreach var of varlist crp_25_q_16_* crp_27_16_* crp_05_a_16_*{
		destring `var', replace
	}

	forvalues plot = 1/5 {


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

			cap label var ag8_16_`plot'_`season' "P`plot' `lseason' C`crop' Did you cultivate seasonal crops on this plot during Season  2016?"
			cap note ag8_16_`plot'_`season': P`plot' `lseason' C`crop' Did you cultivate seasonal crops on this plot during Season  2016?

			cap label var ag9n_16_`plot'_`season' "P`plot' `lseason' C`crop' How many seasonal crops did you cultivate on this plot during Season ${calc_s..."
			cap note ag9n_16_`plot'_`season': P`plot' `lseason' C`crop' How many seasonal crops did you cultivate on this plot during Season  2016?

			cap label var ag10_16_`plot'_`season' "P`plot' `lseason' C`crop' Who was primarily responsible for making decisions about this plot during Sea..."
			cap note ag10_16_`plot'_`season': P`plot' `lseason' C`crop' Who was primarily responsible for making decisions about this plot during Season  2016?

			cap label var ag11_16_`plot'_`season' "P`plot' `lseason' C`crop' Who spent most time working on this plot during Season  2016?"
			cap note ag11_16_`plot'_`season': P`plot' `lseason' C`crop' Who spent most time working on this plot during Season  2016?

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
			cap label var pl_16_16a_`plot'_`season' "P`plot' Was this plot irrigated for Season  2016?"
			cap note pl_16_16a_`plot'_`season': P`plot' Was this plot irrigated for Season  2016?
		}	
	}
	label var sketch"Enumerator: Please take a picture of the completed plot sketch.  "
	note sketch: Enumerator: Please take a picture of the completed plot sketch.  


	*Undoing destringing done in last step to selected variables for crp_05_a_16_*
	foreach var of varlist crp_05_a_16_1_1_1 crp_05_a_16_1_1_2 crp_05_a_16_1_1_3 crp_05_a_16_1_2_1 crp_05_a_16_1_2_2 crp_05_a_16_1_2_3 crp_05_a_16_1_3_1 crp_05_a_16_1_3_2 crp_05_a_16_1_3_3 crp_05_a_16_2_1_1 crp_05_a_16_2_1_2 crp_05_a_16_2_1_3 crp_05_a_16_2_2_1 crp_05_a_16_2_2_2 crp_05_a_16_2_2_3 crp_05_a_16_2_3_1 crp_05_a_16_2_3_2 crp_05_a_16_2_3_3 crp_05_a_16_3_1_1 crp_05_a_16_3_1_2 crp_05_a_16_3_1_3 crp_05_a_16_3_2_1 crp_05_a_16_3_2_2 crp_05_a_16_3_2_3 crp_05_a_16_3_3_1 crp_05_a_16_3_3_2 crp_05_a_16_3_3_3 crp_05_a_16_4_1_1 crp_05_a_16_4_1_2 crp_05_a_16_4_1_3 crp_05_a_16_4_2_1 crp_05_a_16_4_2_2 crp_05_a_16_4_2_3 crp_05_a_16_4_3_1 crp_05_a_16_4_3_2 crp_05_a_16_4_3_3 crp_05_a_16_5_1_1 crp_05_a_16_5_1_2 crp_05_a_16_5_1_3 crp_05_a_16_5_2_1 crp_05_a_16_5_2_2 crp_05_a_16_5_2_3 crp_05_a_16_5_3_1 crp_05_a_16_5_3_2 crp_05_a_16_5_3_3{	
		tostring `var', replace
		replace `var' = "" if `var' == "."
	}
	foreach var of varlist *cr{
		local a = strlen("`var'")
		local b = (`a' - 3)
		local c = substr("`var'",1, `b') 
		rename `var' `c'
	}

	foreach var of varlist oldplot_* {
		local i = substr("`var'",-1,1)
		label var `var' "Preload: Plot `i'"
	}

	*Plots
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

	forvalues num = 1/5{
		cap gen ag6_`num' = round((ag6n_`num' * 4046.86), 0.1) if ag6u_`num' == 1
		cap replace ag6_`num' = round((ag6n_`num' * 10000), 0.1) if ag6u_`num' == 2
		cap replace ag6_`num' = round((ag6n_`num' * 1), 0.1) if ag6u_`num' == 3
		cap replace ag6_`num' = round((ag6n_`num' * 24281.1), 0.1)  if ag6u_`num' == 4
		cap order ag6_`num', before(ag6u_`num')
	}
	cap foreach var of varlist ag6_1 ag6_2 ag6_3 ag6_4 ag6_5 ag6_6 {
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
	//drop g_*_count_* //Static count variables
	//drop calc_season_* calc_period_* calc_crops_label_* crop_16_* amount_harvest_* unit_harvest_* amount_green_harvest_* unit_green_harvest_* amount_dry_harvest_* unit_dry_harvest_* amount_consumption_* unit_consumption_* amount_sell_* unit_sell_* //used for time period labels
	//drop amount_green_sell_* unit_green_sell_* amount_dry_sell_* unit_dry_sell_* amount_green_consumption_* unit_green_consumption_* amount_dry_consumption_* unit_dry_consumption_* amount_loss_* unit_loss_* amount_green_loss_* unit_green_loss_* amount_dry_loss_* unit_dry_loss_*
	//drop input_* index_area_* area_plot_* index_areaname_*
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
	
	* !!
	foreach var of varlist plotmatch_1 plotmatch_2 plotmatch_3 plotmatch_4 plotmatch_5 ///
						   plotname_6 coop_name_* unit_* crop_16_* pl_t2m_* crp_27_16_*{
		tostring `var', replace
		replace `var' = "" if `var' == "."
	}
	foreach var of varlist crp_25_q_16_* crp_27_16_* crp_05_a_16_*{
		destring `var', replace
	}
	foreach var of varlist crp_05_a_16_1_1_1 crp_05_a_16_1_1_2 crp_05_a_16_1_1_3 crp_05_a_16_1_2_1 crp_05_a_16_1_2_2 crp_05_a_16_1_2_3 crp_05_a_16_1_3_1 crp_05_a_16_1_3_2 crp_05_a_16_1_3_3 crp_05_a_16_2_1_1 crp_05_a_16_2_1_2 crp_05_a_16_2_1_3 crp_05_a_16_2_2_1 crp_05_a_16_2_2_2 crp_05_a_16_2_2_3 crp_05_a_16_2_3_1 crp_05_a_16_2_3_2 crp_05_a_16_2_3_3 crp_05_a_16_3_1_1 crp_05_a_16_3_1_2 crp_05_a_16_3_1_3 crp_05_a_16_3_2_1 crp_05_a_16_3_2_2 crp_05_a_16_3_2_3 crp_05_a_16_3_3_1 crp_05_a_16_3_3_2 crp_05_a_16_3_3_3 crp_05_a_16_4_1_1 crp_05_a_16_4_1_2 crp_05_a_16_4_1_3 crp_05_a_16_4_2_1 crp_05_a_16_4_2_2 crp_05_a_16_4_2_3 crp_05_a_16_4_3_1 crp_05_a_16_4_3_2 crp_05_a_16_4_3_3 crp_05_a_16_5_1_1 crp_05_a_16_5_1_2 crp_05_a_16_5_1_3 crp_05_a_16_5_2_1 crp_05_a_16_5_2_2 crp_05_a_16_5_2_3 crp_05_a_16_5_3_1 crp_05_a_16_5_3_2 crp_05_a_16_5_3_3{	
		tostring `var', replace
		replace `var' = "" if `var' == "."
	}
	tostring unit_* crop_16_*, replace

	label var deviceid "Device ID - CR"


	***Datetime fields
	foreach dtvar of varlist starttime* endtime* submissiondate* {
		tempvar tempdtvar
		rename `dtvar' `tempdtvar'
		gen double `dtvar'=.
		cap replace `dtvar'=clock(`tempdtvar',"MDYhms",2025)
		cap replace `dtvar'=clock(`tempdtvar',"MDYhm",2025) if `dtvar'==. & `tempdtvar'~=""
		format %tc `dtvar'
		drop `tempdtvar'
	}

	*Addition date/time fields
	rename submissiondate submission //timestamp when interview was received by server
	gen date = dofc(starttime) //Date of interview
	gen date_submit = dofc(submission) //Date when interview was received by server
	format date %td
	format date_submit %td

	***Clean
	**GPS
	foreach var of varlist gps_*{
		local varname = subinstr("`var'","Latitude","_latitude",.)
		local varname = subinstr("`varname'","Longitude","_longitude",.)
		local varname = subinstr("`varname'","Accuracy","_accuracy",.)
		local varname = subinstr("`varname'","Altitude","_altitude",.)
		rename `var' `varname'
	}

	*Enumerators
	cap tostring enumeratorother, replace
	replace enumerator = enumeratorother if enumerator == "OTHER" & enumeratorother != ""
	replace enumerator = trim(upper(enumerator))

	*Teams
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
	*drop `N' `n'

	**Agricultural Profits
	egen stats_w_profit_agric_a = rowtotal(crp_10_16_*_1_*)
	egen stats_w_profit_agric_b = rowtotal(crp_10_16_*_2_*)
	egen stats_w_profit_agric_c = rowtotal(crp_10_16_*_3_*)
	label var stats_w_profit_agric_a "Profit Agric A"
	label var stats_w_profit_agric_b "Profit Agric B"
	label var stats_w_profit_agric_c "Profit Agric C"

	gen fup3_w_profit_agric_a = 20408
	gen fup3_w_profit_agric_b = 15071
	label var fup3_w_profit_agric_a "Profit Agric A (FUP3)"
	label var fup3_w_profit_agric_b "Profit Agric B (FUP3)"

	**Harvest
	egen stats_w_total_val_harvested_a = rowtotal(amount_harvest_*_1_*)
	egen stats_w_total_val_harvested_b = rowtotal(amount_harvest_*_2_*)
	egen stats_w_total_val_harvested_c = rowtotal(amount_harvest_*_3_*)
	label var stats_w_total_val_harvested_a "Harvest A"
	label var stats_w_total_val_harvested_b "Harvest B"
	label var stats_w_total_val_harvested_c "Harvest C"

	gen fup3_w_total_val_harvested_a = 95548
	gen fup3_w_total_val_harvested_b = 57374
	label var fup3_w_total_val_harvested_a "Harvest A (FUP3)"
	label var fup3_w_total_val_harvested_b "Harvest B (FUP3)"

	**Terraced
	egen stats_any_plots_terraced = rowmax(pl_t1_*)
	label var stats_any_plots_terraced "Terraced"

	gen fup3_any_plots_terraced = 0.33
	label var fup3_any_plots_terraced "Terraced (FUP3)"

	**Irrigation
	egen stats_any_irrigation_a = rowmax(pl_16_16_*_1)
	egen stats_any_irrigation_b = rowmax(pl_16_16_*_2)
	egen stats_any_irrigation_c = rowmax(pl_16_16_*_3)
	label var stats_any_irrigation_a "Irrigation A"
	label var stats_any_irrigation_b "Irrigation B"
	label var stats_any_irrigation_c "Irrigation C"

	gen fup3_any_irrigation_a = 0.03
	gen fup3_any_irrigation_b = 0.06
	label var fup3_any_irrigation_a "Irrigation A (FUP3)"
	label var fup3_any_irrigation_b "Irrigation B (FUP3)"

	*Crops
	egen stats_crops = rowtotal(ag9n_16_*)
	label var stats_crops "Crops"

	*Plots
	gen stats_plots = plots
	label var stats_plots "Plots"

	*Spent on Seeds
	egen stats_seeds = rowtotal(crp_06_16_*)
	label var stats_seeds "Seeds"

	*Harvest
	egen stats_harvest = rowtotal(amount_harvest_*)
	label var stats_harvest "Harvest"

	*No Harvest
	gen stats_noharvest = stats_harvest == 0 | stats_harvest == .
	label var stats_noharvest "No Harvest"

	* total crop earnings per season
	egen stats_crop_earn_a = rowtotal(crp_10_16_*_1_*)
	egen stats_crop_earn_b = rowtotal(crp_10_16_*_2_*)
	egen stats_crop_earn_c = rowtotal(crp_10_16_*_3_*)
	label var stats_crop_earn_a "Total earnings crop sells Season A"
	label var stats_crop_earn_b "Total earnings crop sells Season B"
	label var stats_crop_earn_c "Total earnings crop sells Season C"

	***Zero cultivation, per season
	forvalues i = 1/3 {
		if `i' == 1 local season A
		if `i' == 2 local season B
		if `i' == 3 local season C

		egen check_cultivation_`i' = rowmax(ag8_16_*_`i')
		recode check_cultivation_`i' (1 = 0) (0 = 1)
		label var check_cultivation_`i' "Check: No Cultivation Season `season'"

	}

	***Zero harvest, crop level
	gen check_harvest = 0 if check_cultivation_1 == 0 | check_cultivation_2 == 0 | check_cultivation_3 == 0
	foreach var of varlist crp_08_q_16_* {
		replace check_harvest = 1 if `var' == 0
	}
	label var check_harvest "Check: No Harvest (at least one crop)"

	forvalues i = 1/5 {
		recode ag8_16_`i'_1 (0=1) (1=0), g(nocultv_`i'_1)
		recode ag8_16_`i'_2 (0=1) (1=0), g(nocultv_`i'_2)
		recode ag8_16_`i'_3 (0=1) (1=0), g(nocultv_`i'_3)
	}

	***Missing values
	foreach var of varlist amount_total_* {
		replace `var' = . if `var' < 0 //missing value in calculation
	}

	*Plots
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
	forvalues num = 1/5{
		drop ag6_`num'
		gen ag6_`num' = round((ag6n_`num' * 4046.86), 0.1) if ag6u_`num' == 1
		replace ag6_`num' = round((ag6n_`num' * 10000), 0.1) if ag6u_`num' == 2
		replace ag6_`num' = round((ag6n_`num' * 1), 0.1) if ag6u_`num' == 3
		replace ag6_`num' = round((ag6n_`num' * 24281.1), 0.1)  if ag6u_`num' == 4
		order ag6_`num', before(ag6u_`num')
	}
	foreach var of varlist ag6_1 ag6_2 ag6_3 ag6_4 ag6_5 {
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
	foreach var of varlist ag_12_* {
		local j = substr("`var'",-1,1)
		label var `var' "P`j': What is the ownership status of this plot?"
	}
	label define ownership_cr 1 "Owned" 2 "Rented" 3 "Shared family plot" 4 "Government-owned" 5 "Rented without payment"
	label val ag_12_* ownership_cr


	label var gps_crlatitude "GPS CR: Latitude"
	label var gps_crlongitude "GPS CR: Longitude" 
	label var gps_craltitude "GPS CR: Altitude" 
	label var gps_craccuracy "GPS CR: Accuracy"
	rename short_gps short_gps_cr 
	label var short_gps_cr "GPS CR"

	drop enumeratorother

	//Lines 743-759 or Lines 762-767
	/*foreach var of varlist _all{
		rename `var' `var'CR
	}
	foreach var of varlist formdef_versionCR instanceIDCR KEYCR submission dateCR date_submitCR enumeratorCR commentsCR deviceidCR endtimeCR  starttimeCR teamCR nameCR phoneCR consentCR{ 
		local a = strlen("`var'")
		local b = (`a' - 2)
		local c = substr("`var'",1, `b') 
		rename `var' `c'_cr
	}

	foreach var of varlist gps_cr_latitudeCR gps_cr_longitudeCR gps_cr_altitudeCR gps_cr_accuracyCR short_gps_crCR id_05CR{
		local a = strlen("`var'")
		local b = (`a' - 2)
		local c = substr("`var'",1, `b') 
		rename `var' `c'
	}
	rename consent_cr cr_consent
	*/

	foreach var of varlist formdef_version instanceid key submission date ///
						   date_submit enumerator comments deviceid endtime ///
						   starttime team name phone consent { 
	//	local a = strlen("`var'")
	//	local b = (`a' - 2)
	//	local c = substr("`var'",1, `b') 
		rename `var' `var'_cr
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
						   crp_05_a_16_5_3_3 {
		tostring `var', replace
		replace `var' = "" if `var' == "."
	}


	label var plotmatch_1 "Is this the same plot as any of the plots we talked about last time? If so, p..."
	note plotmatch_1: Is this the same plot as any of the plots we talked about last time? If so, please select from the options below. 

	label var plotmatch_2 "Is this the same plot as any of the plots we talked about last time? If so, p..."
	note plotmatch_2: Is this the same plot as any of the plots we talked about last time? If so, please select from the options below. 

	label var plotmatch_3 "Is this the same plot as any of the plots we talked about last time? If so, p..."
	note plotmatch_3: Is this the same plot as any of the plots we talked about last time? If so, please select from the options below. 

	label var plotmatch_4 "Is this the same plot as any of the plots we talked about last time? If so, p..."
	note plotmatch_4: Is this the same plot as any of the plots we talked about last time? If so, please select from the options below. 

	label var plotmatch_5 "Is this the same plot as any of the plots we talked about last time? If so, p..."
	note plotmatch_5: Is this the same plot as any of the plots we talked about last time? If so, please select from the options below. 

	label var plotmatch_6 "Is this the same plot as any of the plots we talked about last time? If so, p..."
	note plotmatch_6: Is this the same plot as any of the plots we talked about last time? If so, please select from the options below. 

	label var plots "Enumerator: How many plots did you draw in the diagram above?"
	note plots: Enumerator: How many plots did you draw in the diagram above?

	label var calc_plots "Plots Limit"
	note calc_plots: Plots Limit

	save "$data\lwh_oi_endline_cr_clean.dta", replace
