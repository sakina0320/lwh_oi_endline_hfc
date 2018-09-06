/* Note: These do files import the raw data, put variable and value labels, 
		 and check against the sample listing.
		 
		 This do file is part of Master_import_bc_hfc.do, and creates the 
		 following dataset. 
		 
		 "$data\lwh_oi_endline_fs_clean.dta"
*/

	*----------------
	* Import raw data
	*----------------
	import delimited using "$raw_data/LWH Endline 2018 Food Security_WIDE", clear
		
	* Enumerators accidentally used the OI FS form for Gishwati HHs. 
	drop if key == "uuid:ad894405-29fa-4bac-a474-ef4a9565821e" | /// // 8358
			key == "uuid:ba10bfd6-31d1-44c9-8c86-ef6bb081f37b" | /// // 7673
			key == "uuid:11a1e7dc-d4c9-469a-9dc9-dc88dbe0f9a1" | /// // 11890
			key == "uuid:d9098492-c7ab-4043-8721-5ebd12ad30c8" // 6510
			
	* Mistake. Not a part of the sample. 
	drop if key == "uuid:376f1b7e-3619-4f70-b487-bc70fd8ff8d8" | /// // 4862 
			key == "uuid:e48ab711-7c07-4e18-9046-de3b24ca0535" // 2661
	
	*--------------------------	
	* Check and drop duplicates
	*--------------------------
	replace team_fs = "Egidie" if team == "B"
	replace team_fs = "Andre" if team == "C"
	replace team_fs = "Emerance" if team == "D"
	replace team_fs = "Diane" if team == "E"
	replace team_fs = "Freddy" if team == "F"		
	ieduplicates id_05, folder("$high_freq_check\duplicates_report_fs") uniquevars(key) keep(team_fs submissiondate enumerator_fs enumeratorother_fs)
		
	*---------
	* Clean up
	*---------	
	
	* To string
	tostring wdds_b wdds_bs wdds_ls wdds_ds, replace

	/*Replace meta-data and interview data
	foreach var of varlist starttime_fs endtime_fs deviceid_fs comments_fs enumerator_fs team_fs enumeratorother_fs {
		local a = strlen("`var'")
		local b = (`a' - 3)
		local c = substr("`var'",1, `b') 
		replace `var' = `c' if KEY == "uuid:a5f35f3a-6bab-4b51-9d61-5ea3a58dc350"
	}
	replace name_fs = calc_respondent_main if KEY == "uuid:a5f35f3a-6bab-4b51-9d61-5ea3a58dc350"
	replace fs_consent = consent    
	replace short_gps_fs = short_gps_hh if KEY == "uuid:a5f35f3a-6bab-4b51-9d61-5ea3a58dc350"
	replace gps_Latitude = gps_hhLatitude if KEY == "uuid:a5f35f3a-6bab-4b51-9d61-5ea3a58dc350"
	replace gps_Longitude = gps_hhLongitude if KEY == "uuid:a5f35f3a-6bab-4b51-9d61-5ea3a58dc350"
	replace gps_Altitude = gps_hhAltitude if KEY == "uuid:a5f35f3a-6bab-4b51-9d61-5ea3a58dc350"
	replace gps_Accuracy = gps_hhAccuracy if KEY == "uuid:a5f35f3a-6bab-4b51-9d61-5ea3a58dc350"
	
	
	* Drop variables only from other interview that were used to replace other data
	drop starttime endtime deviceid gps_hhlatitude gps_hhlongitude gps_hhaltitude ///
		 gps_hhaccuracy short_gps_hh consent calc_respondent_main fs_a fs_b comments enumerator team	
	
	keep id_05 submissiondate_fs starttime_fs endtime_fs deviceid_fs name_fs phone_fs ///
		 fs_consent start_mod_fs1 fs_0* start_mod_fs2 fs2_count food_* exp_25_* exp_26_* ///
		 exp_27_* exp_28_* exp_28_* exp_29_*  start_mod_fs3 wdds_* comments_fs enumerator_fs ///
		 team_fs gps_latitude_fs gps_longitude_fs gps_altitude_fs gps_accuracy_fs enumeratorother_fs ///
		 short_gps_fs instanceid_fs formdef_version_fs key_fs

	rename gps_latitude_fs gps_fslatitude
	rename gps_longitude_fs gps_fslongitude
	rename gps_altitude_fs gps_fsaltitude
	rename gps_accuracy_fs gps_fsaccuracy
	*/
	
	
	foreach var of varlist formdef_version instanceid key submissiondate ///
						   gps_fslatitude gps_fslongitude gps_fsaltitude gps_fsaccuracy {
		rename `var' `var'_fs
	}

	label var deviceid_fs "Device ID - FS"

	foreach dtvar of varlist starttime* endtime* submissiondate* {
		tempvar tempdtvar
		rename `dtvar' `tempdtvar'
		gen double `dtvar'=.
		cap replace `dtvar'=clock(`tempdtvar',"MDYhms",2025)
		cap replace `dtvar'=clock(`tempdtvar',"MDYhm",2025) if `dtvar'==. & `tempdtvar'~=""
		format %tc `dtvar'
		drop `tempdtvar'
	}

	gen date_fs = dofc(starttime_fs) //Date of interview
	gen date_submit_fs = dofc(submissiondate_fs) //Date when interview was received by server
	format date_fs %td
	format date_submit_fs %td

	label var comments_fs "Enumerator comments FS"
	label var enumerator_fs "Enumerator FS"
	label var team_fs "Team FS"
	label var enumeratorother_fs "Enumerator (Other) FS"
	label var instanceid_fs "Instance ID FS"
	label var formdef_version_fs "Form version FS"
	label var key_fs "Key FS"
	label var name_fs "Respondent name FS"
	label var phone_fs "Respondent contact FS"
	label var starttime_fs "Start time FS"
	label var endtime_fs "End time FS"
	rename submissiondate submission_fs
	label var submission_fs "Submission FS"

	* GPS
	foreach var of varlist gps_*{
		local varname = subinstr("`var'","latitude","_latitude",.)
		local varname = subinstr("`varname'","longitude","_longitude",.)
		local varname = subinstr("`varname'","accuracy","_accuracy",.)
		local varname = subinstr("`varname'","altitude","_altitude",.)
		rename `var' `varname'
	}

	cap tostring enumeratorother_fs, replace
	replace enumerator_fs = enumeratorother_fs if enumerator_fs == "OTHER" & enumeratorother_fs != ""
	replace enumerator_fs = trim(upper(enumerator_fs))
	drop enumeratorother_fs

	*Teams
	clonevar team_entered_fs =  team_fs

	sort enumerator_fs starttime_fs
	tempvar N n
	bysort enumerator_fs: gen `N' = _N
	bysort enumerator_fs: gen `n' = _n
	levelsof enumerator_fs, clean local(enumerators_fs)

	foreach enumerator_fs in `enumerators_fs' {
		levelsof team_fs if enumerator_fs == "`enumerator_fs'" & `N' == `n', clean local(team_fs)
		replace team_fs = "`team_fs'" if enumerator_fs == "`enumerator_fs'"
	}
	drop `N' `n'

	label var gps_fs_latitude "GPS FS: Latitude"
	label var gps_fs_longitude "GPS FS: Longitude" 
	label var gps_fs_altitude "GPS FS: Altitude" 
	label var gps_fs_accuracy "GPS FS: Accuracy"
	label var short_gps_fs "GPS FS"

	*---------------	
	* Generate stats
	*---------------
	
	* total weekly food expenditure
	egen stats_w_food_exp = rowtotal(exp_29_*)
	label var stats_w_food_exp "Total weekly food expenditure"

	
	save "$data\lwh_oi_endline_fs_clean.dta", replace
	
	
		
		
