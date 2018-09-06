/* 
	This do file merges the backcheck raw data.
	
	This do file is part of Master_import_bc_hfc.do.
*/

	use "$data\lwh_oi_endline_clean_02.dta", clear
	merge m:1 id_05 consent using "$data/lwh_oi_endline_clean_bc_01.dta", gen(bc_done) keep(match master)
	cap drop __*
	recode bc_done (3 = 1) (1 = 0) // This command creates tempvar that's already defined and breaks.
	label values bc_done yes_no
	label var bc_done "Backcheck done"
