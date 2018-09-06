/*******************************************************************************	
		Project: LWH Overall Impact Rwanda
		Endline Survey (January 2018)
	
Purpose : Import the raw data from the endline survey, and run the HFC.

Note : The endline sample size is 1097. 
	   "$endline\sample_listing\endline-listing.dta" is the main list.
	   This do file constructs a preload HH list containing all necessary data
	   to match the main list.
	   
	   What data are needed in preload_data_HH.csv?
	   
	   headid		HH ID
	   hhsize		HH size (the number of HH members
	   id_06		village
	   id_07		cell
	   id_08		sector
	   id_09		district
	   id_10		site
	   id_11		HH head neame
	   id_12		HH head's national ID
	   lwh_group	Have LWH group name on file (dummy)
	   Numplots		Number of plots cultivated during the last follow up 
	   oi_assign	Treatment or control
	   samplehh		Equals 1 for all the rows in the preload, just an indicator 
					that the enumerator did enter a "valid" hh-id
	   plot_*		Plot info: description, village, location
	   age_*		
	   Cooperative
	   firstlast_*
	   gender_*
	   group_name	Name of LWH group
	   has_formal	Equals 1 if HH has a formal account

Written by : Sakina Shibuya
********************************************************************************/


				********** Housekeeping **********
				
	clear 
	set maxvar 32767
	
	* Machine Identification
	if "`c(username)'" == "wb357411" {
		global dropbox "C:\Users\wb357411\Dropbox"
	}
	
	if c(username) == "wb470337" {		
		global dropbox "C:/Users/WB470337/Dropbox"
	}
		
	if c(username) == "wb506744" { 								// Sakina		
		global dropbox "C:/Users/WB506744/Dropbox/DIME_work"
	}
	
	if c(username) == "Sakina" { 								// Sakina (personal laptop)		
		global dropbox "C:/Users/Sakina\Dropbox/DIME_work"
	}
	
	* File path globals
	global	project				"$dropbox/GAFSP Rwanda" 
	global	endline_fieldwork	"$project/Surveys/Follow-Up Survey 5 (January 2018)" 
	global	data				"$endline_fieldwork\data"	
	global	raw_data			"$endline_fieldwork\data\raw_data"
	global	backcheck			"$endline_fieldwork\backcheck"
	global 	high_freq_check		"$endline_fieldwork\high_frequency_check"
	global	graphs				"$high_freq_check\graphs"
	global	sample				"$endline_fieldwork\sample_listing"
	global	preload		 		"$endline_fieldwork\preload"
	global	fup4_data			"$project\data\followup_4\data"

	* Section globals
	global	install			0 // Install user written commands, if necessary
		
	global	step_1			1 // Import data and label
	global	step_2			1 // Create check variables
	global	step_3			1 // Merge the short forms and check for duplicates	
	global 	step_4			1 // Merge backcheck data
	global	step_5			1 // Select backcheck HHs and create backcheck preload
	global	step_6			1 // Create graphs

if $install {	
	ssc install mmerge, replace
	ssc install geodist, replace
	ssc install ietoolkit, replace
	}
	
if $step_1 {

	/* Note: These do files import the raw data, put variable and value labels, 
			 and check against the sample listing. Duplicates are identified, 
			 and dropped in this process.
	*/
		
	* Full survey : "$data\lwh_oi_endline_clean_00.dta" created here
	do "$high_freq_check\oi_import_label_clean.do"
			
	* Food security short form: "$data\lwh_oi_endline_fs_clean.dta" created here
	do "$high_freq_check\oi_fs_import_clean.do"
	
	* Plot-Crop module redo form: "$data\lwh_oi_endline_cr_clean.dta" created here
	do "$high_freq_check\oi_crop_import_clean.do"
	
	* Backcheck: "$data/lwh_oi_endline_clean_bc_01.dta" created here
	do "$backcheck\oi_bc_import_label_clean.do"
	} 
	
if $step_2 {

	/* Note: This do file creates necessary variables for high frequency checks.
			 This do file creates "$data\lwh_oi_endline_clean_01.dta". 
	*/
	
	do "$high_freq_check\oi_hfc_create_vars.do"	
	} 
	
if $step_3 {

	/* Note: This do file imports and merge the raw data from the short financial
			 decisions and food security forms.
			 This do file creates "$data\lwh_oi_endline_clean_02.dta".
	*/
			 
	do "$high_freq_check\oi_hfc_merge_shorts.do"
	} 
	
	
if $step_4 {
	
	/* Note: This section merges the backcheck raw data. 
			 No dataset is saved there.
	*/

	do "$backcheck\oi_bc_merge.do"
	}
	
if $step_5 {

	/* Note: This do file selects new backcheck HHs, and create check variabales from 
			 the backcheck data. 
			 
			 "$data\lwh_oi_endline_clean_03.dta" is created here.
	*/
	
	* For the OI data
	global first_time		0 // Select backcheck HHs. This should be 1 only for the 1st day of backchecking. 
	global afterwards		1 // Select backcheck HHs. After the 1st backcheck selection, this should always be 1.
	global bc_check_vars	1 // Create check variables for backcheck.

	do "$backcheck\oi_bc_select_preload.do"	// Still need to edit'
	}
	
if $step_6 {

	/* Note: This do file creates all data check graphs and save in a DB folder,
			 which then get reflected to the DB Paper dashboards.
	*/
			 
	do "$high_freq_check\oi_hfc_graphs.do" 
	}

