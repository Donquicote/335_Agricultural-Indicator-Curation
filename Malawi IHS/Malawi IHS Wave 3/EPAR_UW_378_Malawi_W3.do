
/*
-----------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of a set of agricultural development indicators 
				  using the Malawi National Panel Survey (TNPS) LSMS-ISA Wave 4 (2014-15)
*Author(s)		: Anu Sidhu, C. Leigh Anderson, &  Travis Reynolds

*Acknowledgments: We acknowledge the helpful contributions of members of the World Bank's LSMS-ISA team, the FAO's RuLIS team, IFPRI, IRRI, 
				  and the Bill & Melinda Gates Foundation Agricultural Development Data and Policy team in discussing indicator construction decisions. 
				  All coding errors remain ours alone.
*Date			: 21 January 2018

----------------------------------------------------------------------------------------------------------------------------------------------------*/


*Data source
*----------- 
*The Malawi National Panel Survey was collected by the National Statistical Office in Zomba 
*and the World Bank's Living Standards Measurement Study - Integrated Surveys on Agriculture(LSMS - ISA)
*The data were collected over the period April 2016 - April 2017.
*All the raw data, questionnaires, and basic information documents are available for downloading free of charge at the following link
*http://microdata.worldbank.org/index.php/catalog/2936

*Throughout the do-file, we sometimes use the shorthand LSMS to refer to the Malawi National Panel Survey.

*Summary of Executing the Master do.file
*-----------
*This Master do.file constructs selected indicators using the Malawi LSMS data set.
*Using data files from within the "378 - LSMS Burkina Faso, Malawi, Uganda" folder within the "raw_data" folder, 
*the do.file first constructs common and intermediate variables, saving dta files when appropriate 
*in R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave3-2016\code 
*These variables are then brought together at the household, plot, or individual level, saving dta files at each level when available 
*in the folder "Tanzania TNPS - LSMS-ISA - Wave 4 (2014-15)" within the "Final DTA files" folder.

*The processed files include all households, individuals, and plots in the sample.
*Toward the end of the do.file, a block of code estimates summary statistics (mean, standard error of the mean, minimum, first quartile, median, third quartile, maximum) 
*of final indicators, restricted to the rural households only, disaggregated by gender of head of household or plot manager.
*The results are outputted in the excel file "Tanzania_NPS_LSMS_ISA_W3_summary_stats.xlsx" in the "Tanzania TNPS - LSMS-ISA - Wave 4 (2014-15)" within the "Final DTA files" folder. AKS 1.23 Should I delete>
*It is possible to modify the condition  "if rural==1" in the portion of code following the heading "SUMMARY STATISTICS" to generate all summary statistics for a different sub_population.

 
/*
OUTLINE OF THE DO.FILE
Below are the list of the main files created by running this Master do.file

*INTERMEDIATE FILES					MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD IDS						MWI_IHS_IHPS_W3_hhids.dta
*INDIVIDUAL IDS						MWI_IHS_IHPS_W3_person_ids.dta
*GPS COORDINATES					MWI_IHS_IHPS_W3_hh_coords.dta
*HOUSEHOLD SIZE						MWI_IHS_IHPS_W3_hhsize.dta
*WEIGHTS							MWI_IHS_IHPS_W3_weights.dta
*PLOT AREAS							MWI_IHS_IHPS_W3_plot_areas.dta
*CROP UNIT CONVERSION FACTOR		MWI_IHS_IHPS_W3_cf.dta
*ALL PLOTS							Malawi_W3_all_plots.dta
*PLOT-CROP DECISION MAKERS			MWI_IHS_IHPS_W3_plot_decision_makers.dta
*TLU (Tropical Livestock Units)		MWI_IHS_IHPS_W3_TLU_Coefficients.dta

*GROSS CROP REVENUE					MWI_IHS_IHPS_W3_tempcrop_harvest.dta
									MWI_IHS_IHPS_W3_tempcrop_sales.dta
									MWI_IHS_IHPS_W3_permcrop_harvest.dta
									MWI_IHS_IHPS_W3_permcrop_sales.dta
									MWI_IHS_IHPS_W3_hh_crop_production.dta
									MWI_IHS_IHPS_W3_plot_cropvalue.dta
									MWI_IHS_IHPS_W3_parcel_cropvalue.dta
									MWI_IHS_IHPS_W3_crop_residues.dta
									MWI_IHS_IHPS_W3_hh_crop_prices.dta
									MWI_IHS_IHPS_W3_crop_losses.dta
*CROP EXPENSES						MWI_IHS_IHPS_W3_wages_mainseason.dta
									MWI_IHS_IHPS_W3_wages_shortseason.dta
									
									MWI_IHS_IHPS_W3_fertilizer_costs.dta
									MWI_IHS_IHPS_W3_seed_costs.dta
									MWI_IHS_IHPS_W3_land_rental_costs.dta
									MWI_IHS_IHPS_W3_asset_rental_costs.dta
									MWI_IHS_IHPS_W3_transportation_cropsales.dta
									
*MONOCROPPED PLOTS					MWI_IHS_IHPS_W3_monocrop_plots.dta
									Malawi_IHS_W3_`cn'_monocrop.dta
									MWI_IHS_IHPS_W3_`cn'_monocrop_hh_area.dta
									Malawi_IHS_W3_inputs_`cn'.dta
																		
*LIVESTOCK INCOME					MWI_IHS_IHPS_W3_livestock_products.dta
									MWI_IHS_IHPS_W3_livestock_expenses.dta // RH: not disaggregated
									MWI_IHS_IHPS_W3_hh_livestock_products.dta
									MWI_IHS_IHPS_W3_livestock_sales.dta
									MWI_IHS_IHPS_W3_TLU.dta
									MWI_IHS_IHPS_W3_livestock_income.dta

*FISH INCOME						MWI_IHS_IHPS_W3_fishing_expenses_1.dta
									MWI_IHS_IHPS_W3_fishing_expenses_2.dta
									MWI_IHS_IHPS_W3_fish_income.dta

*OTHER INCOME						MWI_IHS_IHPS_W3_other_income.dta
									MWI_IHS_IHPS_W3_land_rental_income.dta									
									
*CROP INCOME						MWI_IHS_IHPS_W3_crop_income.dta
																	
*SELF-EMPLOYMENT INCOME				MWI_IHS_IHPS_W3_self_employment_income.dta
									MWI_IHS_IHPS_W3_agproducts_profits.dta
									MWI_IHS_IHPS_W3_fish_trading_revenue.dta
									MWI_IHS_IHPS_W3_fish_trading_other_costs.dta
									MWI_IHS_IHPS_W3_fish_trading_income.dta
									
*WAGE INCOME						MWI_IHS_IHPS_W3_wage_income.dta
									MWI_IHS_IHPS_W3_agwage_income.dta

*FARM SIZE / LAND SIZE				MWI_IHS_IHPS_W3_land_size.dta
									MWI_IHS_IHPS_W3_farmsize_all_agland.dta
									MWI_IHS_IHPS_W3_land_size_all.dta
*FARM LABOR							MWI_IHS_IHPS_W3_farmlabor_mainseason.dta
									MWI_IHS_IHPS_W3_farmlabor_shortseason.dta
									MWI_IHS_IHPS_W3_family_hired_labor.dta
*VACCINE USAGE						MWI_IHS_IHPS_W3_vaccine.dta

*ANIMAL HEALTH

*LIVESTOCK WATER, FEEDING, AND HOUSING

*USE OF INORGANIC FERTILIZER		MWI_IHS_IHPS_W3_fert_use.dta
*USE OF IMPROVED SEED				MWI_IHS_IHPS_W3_improvedseed_use.dta

*REACHED BY AG EXTENSION			MWI_IHS_IHPS_W3_any_ext.dta
*MOBILE OWNERSHIP                   Malawi_IHS_LSMS_ISA_W2_mobile_own.dta
*USE OF FORMAL FINANACIAL SERVICES	MWI_IHS_IHPS_W3_fin_serv.dta

*GENDER PRODUCTIVITY GAP 			MWI_IHS_IHPS_W3_gender_productivity_gap.dta
*MILK PRODUCTIVITY					MWI_IHS_IHPS_W3_milk_animals.dta
*EGG PRODUCTIVITY					MWI_IHS_IHPS_W3_eggs_animals.dta


*CONSUMPTION						MWI_IHS_IHPS_W3_consumption.dta
*HOUSEHOLD FOOD PROVISION			MWI_IHS_IHPS_W3_food_insecurity.dta
*HOUSEHOLD ASSETS					MWI_IHS_IHPS_W3_hh_assets.dta

*FARM SIZE/LAND SIZE				MWI_IHS_IHPS_W3_land_size.dta

*** BELOW: NOT YET STARTED *****
*CROP PRODUCTION COSTS PER HECTARE	MWI_IHS_IHPS_W3_hh_cost_land.dta
									MWI_IHS_IHPS_W3_hh_cost_inputs_lrs.dta
									MWI_IHS_IHPS_W3_hh_cost_inputs_srs.dta
									MWI_IHS_IHPS_W3_hh_cost_seed_lrs.dta
									MWI_IHS_IHPS_W3_hh_cost_seed_srs.dta		
									MWI_IHS_IHPS_W3_cropcosts_perha.dta

*RATE OF FERTILIZER APPLICATION		MWI_IHS_IHPS_W3_fertilizer_application.dta
*HOUSEHOLD'S DIET DIVERSITY SCORE	MWI_IHS_IHPS_W3_household_diet.dta
*WOMEN'S CONTROL OVER INCOME		MWI_IHS_IHPS_W3_control_income.dta
*WOMEN'S AG DECISION-MAKING			MWI_IHS_IHPS_W3_make_ag_decision.dta
*WOMEN'S ASSET OWNERSHIP			MWI_IHS_IHPS_W3_ownasset.dta
*AGRICULTURAL WAGES					MWI_IHS_IHPS_W3_ag_wage.dta
*CROP YIELDS						MWI_IHS_IHPS_W3_yield_hh_crop_level.dta

*FINAL FILES						MAIN FILES CREATED
*-------------------------------------------------------------------------------------
*HOUSEHOLD VARIABLES				MWI_IHS_IHPS_W3_household_variables.dta
*INDIVIDUAL-LEVEL VARIABLES			MWI_IHS_IHPS_W3_individual_variables.dta	
*PLOT-LEVEL VARIABLES				MWI_IHS_IHPS_W3_gender_productivity_gap.dta
*SUMMARY STATISTICS					MWI_IHS_IHPS_W3_summary_stats.xlsx
*/


clear 
set more off

clear matrix	
clear mata	
set maxvar 8000		
ssc install findname      //need this user-written ado file for some commands to work_TH
//set directories
*These paths correspond to the folders where the raw data files are located and where the created data and final data will be stored.
global MWI_IHS_IHPS_W3_raw_data 			"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave3-2016\raw_data"
global MWI_IHS_IHPS_W3_appended_data "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\RA Working Folders\Surabhi\LSMS_dev\donkey\Malawi IHS\Malawi IHS Wave 3\Final DTA files\Temp"
global MWI_IHS_IHPS_W3_created_data 		"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave3-2016\temp"
global MWI_IHS_IHPS_W3_final_data  		"\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave3-2016\outputs"

*MGM.4.13.2023 Re-scaling survey weights to match population estimates
*https://databank.worldbank.org/source/world-development-indicators#
global MWI_IHS_IHPS_W3_pop_tot 17881367
global MWI_IHS_IHPS_W3_pop_rur 14892509
global MWI_IHS_IHPS_W3_pop_urb 2988658

************************
*EXCHANGE RATE AND INFLATION FOR CONVERSION IN SUD IDS  
************************
// Do I need data for 2016 or 2017 
global IHS_LSMS_ISA_W3_exchange_rate 2158
global IHS_LSMS_ISA_W3_gdp_ppp_dollar 251.074234 //SS:Updated 04/24/23 // Previous: 205.61    // https://data.worldbank.org/indicator/PA.NUS.PPP -2017
global IHS_LSMS_ISA_W3_cons_ppp_dollar 241.9305267 //SS: Updated 04/24/23 // Previous: 207.24	 // https://data.worldbank.org/indicator/PA.NUS.PRVT.PP - Only 2016 data available 
global IHS_LSMS_ISA_W3_inflation 0.89651207929// SS: Updated 04/24 // 2016/2017=305.0313745/340.2421245

 // inflation rate 2015-2016. Data was collected during oct2014-2015. We want to adjust the monetary values to 2016

********************************************************************************
*THRESHOLDS FOR WINSORIZATION -- RH, Complete 7/15/21 - HI checked 4/12/22
********************************************************************************
global wins_lower_thres 1    						//  Threshold for winzorization at the bottom of the distribution of continous variables
global wins_upper_thres 99							//  Threshold for winzorization at the top of the distribution of continous variables

********************************************************************************
*GLOBALS OF PRIORITY CROPS 
********************************************************************************
*Enter the 12 priority crops here (maize, rice, wheat, sorghum, pearl millet (or just millet if not disaggregated), cowpea, groundnut, common bean, yam, sweet potato, cassava, banana)
*plus any crop in the top ten crops by area planted that is not already included in the priority crops - limit to 6 letters or they will be too long!
*For consistency, add the 12 priority crops in order first, then the additional top ten crops
global topcropname_area "maize mango nkhwni pigpea tobcco sbean grdnt beans rice cotton swtptt pmill peas" 
*global topcrop_area "13 12 16 13 14 32 43 31 24 22 21 71 50 41 34"
global topcrop_area "1 52 42 36 5 35 11 34 17 37 28 33 46 " // SS 10.17.23
global comma_topcrop_area "1, 52, 42, 36, 5, 35, 11, 34, 17, 37, 28, 33, 46"
global nb_topcrops : list sizeof global(topcropname_area) // Gets the current length of the global macro list "topcropname_area" 
display $nb_topcrops

/*
********************************************************************************
* APPENDING Malawi IHPS data to IHS data (does not need to be re-run every time)
* To run for first time:
* Create a "Temp" folder in "Final DTA Files" folders
* comment out macro which creates "created_data" above
* create new paths below
* After running, must change created_data file path back to raw/created_data (above)
********************************************************************************
* HKS 07.06.23: Adding a new global for appending in the panel data
global append_data "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-ihps-all-datasets"
* Issue: case_id doesn't account for split off households. For example, 2 households may both have a case_id of "210663390033", but have different y4_hhid (1309-002 and 1312-004) and often y3_hhid as well. Later, when trying to merge in hh_mod_a_filt_19.dta (to get case_id and qx),

* HKS 7/6/23: appending panel files (IHPS) in to IHS data; renaming HHID hhid
global temp_data "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\RA Working Folders\Surabhi\LSMS_dev\donkey\Malawi IHS\Malawi IHS Wave 3\Final DTA Files\Temp"
local directory_raw "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave3-2016\raw_data"
local directory_panel "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-ihps-all-datasets"
cd "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\"

local raw_files : dir "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave3-2016\raw_data" files "*.dta", respectcase
local panel_files : dir "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-ihps-all-datasets" files "*_16.dta", respectcase
*local panel_files : dir "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-ihps-all-datasets\bs" files "*_19.dta", respectcase

* Change "raw_data" path so it pulls from our slightly edited (appended) raw data in our "Temp" folder
globalMWI_IHS_IHPS_W3_raw_data "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\RA Working Folders\Surabhi\LSMS_dev\donkey\Malawi IHS\Malawi IHS Wave 3\Final DTA Files\Temp"

*  restrict to only those which haven't been run to completion
foreach panelfile of local panel_files {
			*local filename : subinstr local panelfile "19.dta" ""
			*isplay in red "`filename'"
	local raw_file = subinstr("`panelfile'", "_16", "", .)
			if !fileexists("${temp_data}/`raw_file'") { // if file has not yet been saved to temp_data
			if (!strpos("`panelfile'", "meta") & !strpos("`panelfile'", "com_") ){
				use "`directory_panel'/`panelfile'", clear // use IHPS
					display in red  "`directory_panel'/`panelfile'"
			local append_file "`directory_raw'/`raw_file'" // Append IHS
				display in red "we will be appending the following raw IHS data: `append_file'"
				
			*if (!strpos("`append_file'", "meta")) { // if the raw data (append file) does not contain "meta", appendfile
			preserve
				use "${append_data}\hh_mod_a_filt_16.dta", clear
				tostring HHID, replace
				replace HHID = y3_hhid
				ren HHID hhid
				tempfile merge_file
				save `merge_file'
			restore
			capture tostring ag_e13_2*, replace
			capture destring ag_f39*, replace
			capture destring ag_h39*, replace
			capture tostring hhid, replace
			capture destring pid, replace
			
			capture encode ag_i204_1, gen(replace_me)
			capture  drop ag_i204_1
			capture ren replace_me ag_i204_1
			capture decode ag_i204_1oth, gen(replace_me)
			capture  drop ag_i204_1oth
			capture ren replace_me ag_i204_1oth
			
			capture decode ag_i204_3_oth, gen(replace_me)
			capture  drop ag_i204_3_oth
			capture ren replace_me ag_i204_3_oth
					
			capture decode ag_i208c_oth, gen(replace_me)
			capture  drop ag_i208c_oth
			capture ren replace_me ag_i208c_oth
								
			capture decode ag_i216c_oth, gen(replace_me)
			capture  drop ag_i216c_oth
			capture ren replace_me ag_i216c_oth
						
			capture decode ag_i32b_oth, gen(replace_me)
			capture  drop ag_i32b_oth
			capture ren replace_me ag_i32b_oth
			
			capture decode ag_k01b, gen(replace_me)
			capture  drop ag_k01b
			capture ren replace_me ag_k01b
			
			capture decode ag_k25_oth, gen(replace_me)
			capture  drop ag_k25_oth
			capture ren replace_me ag_k25_oth

			capture decode ag_l06a, gen(replace_me)
			capture  drop ag_l06a
			capture ren replace_me ag_l06a
			
			capture decode ag_l14b, gen(replace_me)
			capture  drop ag_l14b
			capture ren replace_me ag_l14b
			
			capture decode ag_l39b, gen(replace_me)
			capture  drop ag_l39b
			capture ren replace_me ag_l39b
			
			capture decode ag_o104b_oth, gen(replace_me)
			capture  drop ag_o104b_oth
			capture ren replace_me ag_o104b_oth
			
			capture decode ag_o105e, gen(replace_me)
			capture  drop ag_o105e
			capture ren replace_me ag_o105e
			
			capture decode ag_o04b_oth, gen(replace_me)
			capture  drop ag_o04b_oth
			capture ren replace_me ag_o04b_oth
			
			capture decode ag_q33b_oth, gen(replace_me)
			capture  drop ag_q33b_oth
			capture ren replace_me ag_q33b_oth
						
			capture decode ag_u06b_oth, gen(replace_me)
			capture  drop ag_u06b_oth
			capture ren replace_me ag_u06b_oth
			
			capture encode fs_f03j, gen(replace_me)
			capture  drop fs_f03j
			capture ren replace_me fs_f03j
						
			capture encode fs_i04i, gen(replace_me)
			capture  drop fs_i04i
			capture ren replace_me fs_i04i
			
			capture encode fs_i04k, gen(replace_me)
			capture  drop fs_i04k
			capture ren replace_me fs_i04k
						
			capture encode fs_i05a, gen(replace_me)
			capture  drop fs_i05a
			capture ren replace_me fs_i05a
			
			capture encode fs_i06*, gen(replace_me)
			capture  drop fs_i06*
			capture ren replace_me fs_i06*
			
			capture encode fs_i08i, gen(replace_me)
			capture  drop fs_i08i
			capture ren replace_me fs_i08i
			
			capture encode fs_i08k, gen(replace_me)
			capture  drop fs_i08k
			capture ren replace_me fs_i08k
									
			capture encode fs_i13*, gen(replace_me)
			capture  drop fs_i13*
			capture ren replace_me fs_i13*
			
			capture encode fs_j02*, gen(replace_me)
			capture  drop fs_j02*
			capture ren replace_me fs_j02*
			
			capture encode fs_j03*, gen(replace_me)
			capture  drop fs_j03*
			capture ren replace_me fs_j03*
			
			capture encode hh_e33_code, gen(replace_me)
			capture  drop hh_e33_code
			capture ren replace_me hh_e33_code
			
			capture encode hh_e34_code, gen(replace_me)
			capture  drop hh_e34_code
			capture ren replace_me hh_e34_code
			
			capture encode hh_e40a, gen(replace_me)
			capture  drop hh_e40a
			capture ren replace_me hh_e40a
			
			capture encode hh_e41, gen(replace_me)
			capture  drop hh_e41
			capture ren replace_me hh_e41
			
			capture encode hh_e47b, gen(replace_me)
			capture  drop hh_e47b
			capture ren replace_me hh_e47b
			
			capture replace hhid = y3
				if _rc {
					capture gen hhid = y3
				}
			append using "`append_file'"
			merge m:1 y3_hhid using "`merge_file'", nogen keep(1 3) keepusing(case_id hhid y3 qx ea) // merge in case_id to each of these IHPS file
			* Households that do not match from master are those which are in IHS but are not also in IHPS.
				ren qx panel_dummy
				*ren HHID hhid
				ren y3_hhid y3_hhid_IHPS
				*replace hhid = y4 if hhid == ""
				display in red "we are saving to '${temp_data}\`raw_file'" 
				save "${temp_data}/`raw_file'", replace // Save in GH location
				}
}
}

use "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave3-2016\raw_data\HouseholdGeovariablesIHPSY3", clear
duplicates drop
*drop if HHID == .
append using "R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-ihps-all-datasets\HouseholdGeovariablesIHPSY3.dta"
			merge m:1 y3 using "${append_data}\hh_mod_a_filt_16.dta", nogen keep(1 3) keepusing(case_id HHID y3 qx) // merge in case_id to each of these IHPS file
			*drop if HHID == .
			drop if case_id == ""
*save "${temp_data}\householdgeovariables_ihs5", replace
save "${MWI_IHS_IHPS_W3_raw_data}\householdgeovariables_ihs5", replace

* For other files in the original raw folder that were not edited - copy them into new "raw" (that is, my Temp folder):
use "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave3-2016\raw_data\Agricultural Conversion Factor Database.dta", clear
save "${MWI_IHS_IHPS_W3_raw_data}\Agricultural Conversion Factor Database.dta", replace

use "\\netid.washington.edu\wfs\EvansEPAR\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave3-2016\raw_data\caloric_conversionfactor.dta", clear
	save "${MWI_IHS_IHPS_W3_raw_data}\caloric_conversionfactor.dta", replace
*/

************************
*HOUSEHOLD IDS - Complete TH, edited RH 7/29 - HI checked 4/12/22
************************
use "${MWI_IHS_IHPS_W3_raw_data}\hh_mod_a_filt.dta", clear
ren hh_a02a ta // RH added 7/29
*rename ea_id ea
rename hh_wgt weight
rename region region
lab var region "1=North, 2=Central, 3=South"
gen rural = (reside==2)
lab var rural "1=Household lives in a rural area"
keep case_id hhid region district ta ea rural weight 
recast str50 hhid, force
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta", replace

********************************************************************************
* WEIGHTS * - Complete FN 4/13/22 - HI checked 4/26/22
********************************************************************************
use "${MWI_IHS_IHPS_W3_raw_data}\hh_mod_a_filt.dta", clear
rename hh_a02a ta
*rename ea_id ea
rename hh_wgt weight
rename region region
lab var region "1=North, 2=Central, 3=South"
gen rural = (reside==2)
lab var rural "1=Household lives in a rural area"
keep hhid region district ta ea rural weight  
recast str50 hhid, force
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_weights.dta", replace


************************
*INDIVIDUAL IDS - FN: unsure if complete, not checked; HKS: still not checked, but it runs ok! (08.31.23)
************************
use "${MWI_IHS_IHPS_W3_raw_data}\hh_mod_b", clear
ren pid indiv			//At the individual-level, the IHPS data from 2010, 2013, and 2016 can be merged using the variable pid - will be used later in data
keep hhid indiv hh_b03 hh_b05a hh_b04
gen female=hh_b03==2 
lab var female "1= indivdual is female"
gen age=hh_b05a
lab var age "Indivdual age"
gen hh_head=hh_b04 if hh_b04==1
lab var hh_head "1= individual is household head"
drop hh_b03 hh_b05a hh_b04
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_person_ids.dta", replace


************************
*HOUSEHOLD SIZE - RH complete 7/16/21 - HI checked 4/12/22
************************

use "${MWI_IHS_IHPS_W3_raw_data}\hh_mod_b.dta", clear
gen hh_members = 1
rename hh_b04 relhead 
rename hh_b03 gender
gen fhh = (relhead==1 & gender==2)
collapse (sum) hh_members (max) fhh, by ( hhid case_id)
lab var hh_members "Number of household members"
lab var fhh "1= Female-headed household"
recast str50 hhid, force

//Rescaling the weights to match the population better
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta", nogen keep(2 3)
total hh_members [pweight=weight]
matrix temp =e(b)
gen weight_pop_tot=weight*${MWI_IHS_IHPS_W3_pop_tot}/el(temp,1,1)


total hh_members [pweight=weight_pop_tot]
lab var weight_pop_tot "Survey weight - adjusted to match total population"
*Adjust to match total population but also rural and urban
total hh_members [pweight=weight] if rural==1
matrix temp =e(b)
gen weight_pop_rur= weight*${MWI_IHS_IHPS_W3_pop_rur}/el(temp,1,1) if rural==1
total hh_members [pweight=weight_pop_tot]  if rural==1

total hh_members [pweight=weight] if rural==0
matrix temp =e(b)
gen weight_pop_urb= weight*${MWI_IHS_IHPS_W3_pop_urb}/el(temp,1,1) if rural==0
total hh_members [pweight=weight_pop_urb]  if rural==0

egen weight_pop_rururb=rowtotal(weight_pop_rur weight_pop_urb)
total hh_members [pweight=weight_pop_rururb]  
lab var weight_pop_rururb "Survey weight - adjusted to match rural and urban population"
drop weight_pop_rur weight_pop_urb
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhsize.dta", replace



********************************************************************************
*GPS COORDINATES *
********************************************************************************
use "${MWI_IHS_IHPS_W3_raw_data}\HouseholdGeovariables_IHPS_13.dta", clear 
rename y2_hhid hhid 
recast str50 hhid, force
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta", nogen keep(3) 
ren LAT_DD_MOD latitude
ren LON_DD_MOD longitude
keep hhid latitude longitude
gen GPS_level = "hhid"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hh_coords.dta", replace


************************
*PLOT AREAS - FN: unsure if complete, not checked
************************

//SS 10.9.2023 Added module P for the 75 missing households 

use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_p", clear
gen season=2 //perm
rename plotid plot_id 
rename gardenid garden_id
ren ag_p02a area
ren ag_p02b unit
duplicates drop //zero duplicate entry
drop if garden_id=="" // 61 observations deleted 
drop if plot_id=="" //69 observations deleted //Note from ALT 8.14.2023: So if you check the data at this point, a large number of obs have no plot_id (and are also zeroes) there's no reason to hold on to these observations since they cannot be matched with any other module and don't appear to contain meaningful information.
keep if strpos(plot_id, "T") & plot_id!="" //SS 10.04.2023: 0 obs deleted 
collapse (max) area, by(hhid garden_id plot_id crop_code season unit)
collapse (sum) area, by(hhid garden_id plot_id season unit)
replace area=. if area==0 //the collapse (sum)function turns blank observations in 0s - as the raw data for ag_mod_p have no observations equal to 0, we can do a mass replace of 0s with blank observations so that we are not reporting 0s where 0s were not reported.
drop if area==. & unit==.


gen area_acres_est = area if unit==1 											//Permanent crops in acres
replace area_acres_est = (area*2.47105) if area == 2 & area_acres_est ==.		//Permanent crops in hectares
replace area_acres_est = (area*0.000247105) if area == 3 & area_acres_est ==.	//Permanent crops in square meters
keep hhid plot_id garden_id season area_acres_est

collapse (sum) area_acres_est, by (hhid plot_id garden_id season)
replace area_acres_est=. if area_acres_est==0 //the collapse function turns blank observations in 0s - as the raw data for ag_mod_p have no observations equal to 0, we can do a mass replace of 0s with blank observations so that we are not reporting 0s where 0s were not reported.


tempfile ag_perm
save `ag_perm'


use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_c", clear
gen season=0 //rainy
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_j", gen(dry)
replace season=1 if season==. //dry
append using  "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_o2" //APPENDed MODULE O_2 HERE IN ORDER TO INCORPORATE TREE/PERM CROP DATA
replace season=2 if season==. 
ren plotid plot_id
ren gardenid garden_id

* Counting acreage
gen area_acres_est = ag_c04a if ag_c04b == 1 										//Self-report in acres - rainy season 
replace area_acres_est = (ag_c04a*2.47105) if ag_c04b == 2 & area_acres_est ==.		//Self-report in hectares
replace area_acres_est = (ag_c04a*0.000247105) if ag_c04b == 3 & area_acres_est ==.	//Self-report in square meters
replace area_acres_est = ag_j05a if ag_j05b==1 										//Replace with dry season measures if rainy season is not available
replace area_acres_est = (ag_j05a*2.47105) if ag_j05b == 2 & area_acres_est ==.		//Self-report in hectares
replace area_acres_est = (ag_j05a*0.000247105) if ag_j05b == 3 & area_acres_est ==.	//Self-report in square meters
replace area_acres_est = ag_o04a if ag_o04b == 1 										//Self-report in acres
replace area_acres_est = (ag_o04a*2.47105) if ag_o04b == 2 & area_acres_est ==.	//self-report in hectares
replace area_acres_est = (ag_o04a*0.000247105) if ag_o04b == 3 & area_acres_est ==. //self-report in square meters 

* GPS MEASURE
gen area_acres_meas = ag_c04c														//GPS measure - rainy
replace area_acres_meas = ag_j05c if area_acres_meas==. 							//GPS measure - replace with dry if no rainy season measure
replace area_acres_meas = ag_o04c if area_acres_meas==.								//GPS measure- replace with tree/perm crop if no rainy season measure 

lab var season "season: 0=rainy, 1=dry, 2=tree crop"
label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
label values season season

gen field_size= (area_acres_est* (1/2.47105))
replace field_size = (area_acres_meas* (1/2.47105))  if field_size==. & area_acres_meas!=. 


keep if area_acres_est !=. | area_acres_meas !=. //13,491 obs deleted - Keep if acreage or GPS measure info is available
keep hhid garden_id plot_id season area_acres_est area_acres_meas field_size 			
gen gps_meas = area_acres_meas!=. 
lab var gps_meas "Plot was measured with GPS, 1=Yes" 

lab var area_acres_meas "Plot are in acres (GPSd)"
lab var area_acres_est "Plot area in acres (estimated)"
gen area_est_hectares=area_acres_est* (1/2.47105)  
gen area_meas_hectares= area_acres_meas* (1/2.47105)
lab var area_meas_hectares "Plot are in hectares (GPSd)"
lab var area_est_hectares "Plot area in hectares (estimated)"

recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_plot_areas.dta", replace

************************
*PLOT DECISION MAKERS - TH drafted, RH edited - simplified to match TZA w5 & MWI w2 8/31/21; FN: final dta file still has duplicates - cannot merge w/ all plots; hks 08.25.23: revising
************************
use "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_b.dta", clear 
//ren pid personid			// indivis the roster number, combination of y2_hhid and indivare unique id for this wave
// HKS 08.28.23: There are several hhid and indivtype variables; I am selecting those which seem to resonate with the rest of the data for better merging and rejecting, for example, pid which is for "new members" from ihs3/ihps/ihs4
ren id_code indiv // hks 08.28.23
	replace indiv= pid if  indiv==. & pid != .
*rename y2_hhid hhid 
drop if indiv==.
replace hhid = i_HHID if hhid == "" & i_HHID != "" // 0 changes
gen female=hh_b03==2 
gen age=hh_b05a
gen head = hh_b04==1 if hh_b04!=.
keep indiv female age hhid head
lab var female "1=Individual is a female"
lab var age "Individual age"
lab var head "1=Individual is the head of household"
compress hhid
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_gender_merge.dta", replace

use "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_d.dta", clear
ren plotid plot_id
drop if plot_id=="" 
drop if ag_d14==.
gen cultivated = ag_d14==1
gen season=0
tempfile dm_r
save `dm_r'
use "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_k.dta", clear
* HKS 08.25.23: Note that questions K4-K20 are missing; no info on cultivated status
ren plot plot_id
tempfile dm_d
save `dm_d'

use `dm_r', clear
append using `dm_d'
recode cultivated (.=0)

*Gender/age variables 
gen indiv= ag_d02
replace indiv=ag_k03 if indiv==. & ag_k03!=. 
* HKS 08.28.23: Note that indivis blank for 9 obs in mod D and for 176 obs in mod K
compress hhid
count if indiv == . // hks 08.28.23: 185 obs out of 21,410 have empty personid
merge m:1 hhid indiv using  "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_gender_merge.dta", gen(dm1_merge) keep(1 3)	// hks 08.2.8.23; a mere 185 not matched from master (that is, where indivis blank)	

*First decision-maker variables 
gen dm1_female = female
drop female indiv
*Second owner
gen indiv= ag_d01_2a
replace indiv=ag_k02_2a if indiv==. &  ag_k02_2a!=.
merge m:1 hhid indiv using "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_gender_merge.dta", gen(dm2_merge) keep(1 3)		// Dropping unmatched from using
gen dm2_female = female
drop female indiv
*Third
gen indiv= ag_d01_2b
replace indiv=ag_k02_2b if indiv==. &  ag_k02_2b!=.
merge m:1 hhid indiv using "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_gender_merge.dta", gen(dm3_merge) keep(1 3)		// Dropping unmatched from using
gen dm3_female = female
drop female indiv

*Constructing three-part gendered decision-maker variable; male only (=1) female only (=2) or mixed (=3)
gen dm_gender = 1 if (dm1_female==0 | dm1_female==.) & (dm2_female==0 | dm2_female==.) & (dm3_female==0 | dm3_female==.) & !(dm1_female==. & dm2_female==. & dm3_female==.)
replace dm_gender = 2 if (dm1_female==1 | dm1_female==.) & (dm2_female==1 | dm2_female==.) & (dm3_female==1 | dm3_female==.) & !(dm1_female==. & dm2_female==. & dm3_female==.)
replace dm_gender = 3 if dm_gender==. & !(dm1_female==. & dm2_female==. & dm3_female==.)
la def dm_gender 1 "Male only" 2 "Female only" 3 "Mixed gender"
la val dm_gender dm_gender
lab var  dm_gender "Gender of plot manager/decision maker"

*Replacing observations without gender of plot manager with gender of HOH
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhsize.dta", nogen keep(1 3)	
recast str50 hhid, force							
replace dm_gender = 1 if fhh==0 & dm_gender==.
replace dm_gender = 2 if fhh==1 & dm_gender==.
drop if  plot_id==""
keep hhid garden plot_id dm_gender cultivated season
lab var cultivated "1=Plot has been cultivated" //6192 observations
ren garden garden_id
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_plot_decision_makers.dta", replace

 

/* START NOTE: We will have to remove the "R" and "D" before plotid and gardenid because they indicate rainy and dry season, but this makes it so we cannot merge the two season datasets. Code as you will by appending and wait until end to merge by removing R and D. 
use "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_d.dta", clear 	//Rainy season
merge 1:1 HHID gardenid plotid using "${MWI_IHS_IHPS_W3_created_data}/MLW_IHS_LSMS_ISA_W3_dry_season_plot_manager.dta" //none matched because plots in the rainy season have a prefix of R and the dry season have a D prefix...are they the same plots though? 
END NOTE */

use "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_d.dta", clear 	//Rainy season
gen cultivated = ag_d57==1 	
drop if plotid==""	
gen dry=0 										//To code for dry season as a variable used later
append using "${MWI_IHS_IHPS_W3_created_data}/MLW_IHS_LSMS_ISA_W3_dry_season_plot_manager.dta"	//Dry season  
replace dry=1 if dry==. 
drop if plotid=="" 
drop if ag_d57==. 						//This means that nothing was cultivated in both the rainy or dry seasons. NOTE already removed this from dry season created data. 

********************************************************************************
* FORMALIZED LAND RIGHTS *
********************************************************************************

use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_b2.dta", clear
gen season=0
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_i2.dta"
replace season=1 if season==.
lab var season "season: 0=rainy, 1=dry, 2=tree crop"
label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
label values season season

gen formal_land_rights=1 if ag_b204_1==2  //SS 10.16.23 Using garden level data 
replace formal_land_rights=1 if ag_i204_1 ==2 & formal_land_rights==.
replace formal_land_rights=0 if  ag_b204_1==1 | ag_b204_1==3 | ag_b204_1==4 & formal_land_rights==.
replace formal_land_rights=0 if ag_i204_1==1 | ag_i204_1 ==3| ag_i204_1 ==4 & formal_land_rights==.

//Primary Land Owner
gen indiv=ag_b204_2__0
replace indiv=ag_i204a_1 if ag_i204a_1!=. & indiv==.
recast str50 hhid, force 
merge m:1 hhid indiv using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_person_ids.dta", keep (1 3) nogen //SS 10.16.23 Only 684 observations matched 
ren indiv primary_land_owner
ren female primary_land_owner_female
drop age hh_head

//Secondary Land Owner
gen indiv=ag_b204_2__1
replace indiv=ag_i204a_2 if ag_i204a_2!=. & indiv==.
merge m:1 hhid indiv using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_person_ids.dta", keep (1 3) nogen //SS 10.16.23 Only 67 observations matched 
ren indiv secondary_land_owner_1
ren female secondary_land_owner_female_1
drop age hh_head

//Secondary Land Owner #2 
gen indiv=ag_b204_2__2
replace indiv=ag_i204a_3 if ag_i204a_3!=. & indiv==.
merge m:1 hhid indiv using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_person_ids.dta", keep (1 3) nogen //SS 10.16.23 Only 16 observations matched 
ren indiv secondary_land_owner_2
ren female secondary_land_owner_female_2
drop age hh_head

//Secondary Land Owner #3 
gen indiv=ag_b204_2__3
replace indiv=ag_i204a_4 if ag_i204a_4!=. & indiv==.
merge m:1 hhid indiv using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_person_ids.dta", keep (1 3) nogen //SS 10.16.23 Only 11 observations matched 
ren indiv secondary_land_owner_3
ren female secondary_land_owner_female_3
drop age hh_head

gen formal_land_rights_f=1 if formal_land_rights==1 & (primary_land_owner_female==1 | secondary_land_owner_female_1==1 | secondary_land_owner_female_2==1 | secondary_land_owner_female_3 ==1 )
preserve
collapse (max) formal_land_rights_f, by(hhid) 	
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_land_rights_ind.dta", replace
restore
collapse (max) formal_land_rights_hh=formal_land_rights, by(hhid)
keep hhid formal_land_rights_hh
drop if formal_land_rights==. //1,143 observations deleted 
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_rights_hh.dta", replace



************************
*CROP UNIT CONVERSION FACTORS - complete (TH?); not checked
************************
*From ALT 09.15.23: we'll probably drop this once we're on a single conversion factor file.
use "${MWI_IHS_IHPS_W3_raw_data}\IHS Agricultural Conversion Factor Database.dta", clear
ren crop_code crop_code_full
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_cf.dta", replace


************************
* Caloric Conversion
************************
/*MGM: 2/9/23 
MLW W4 as reference
There is no caloric_conversionfactor raw data file for W3. Codes are the same across waves. Copied the raw data file from W4 into the created data folder for W3.
*/

/* MGM: 2/26/23  Creating a modified data file for IHS Conversion factors to help merge and populate more observations with calories

@Didier-many observations in all plots have N/A for condition on crops like Maize (and all crops in general). To help populate observations with calorie information, are you okay if we replace the conversion information for crops like Maize with the conversion for UNSHELLED? This would be a conservative estimate regarding edible portion.*/
	
	capture confirm file "${MWI_IHS_IHPS_W3_appended_data}/IHS Agricultural Conversion Factor Database.dta"
	if !_rc {
	use "${MWI_IHS_IHPS_W3_appended_data}/IHS Agricultural Conversion Factor Database.dta", clear
	//creating cassava and populating with sweet potato conversion values
	drop if crop_code!=28
	replace crop_code=49 if crop_code==28
	replace condition=. if crop_code==49
	save "${MWI_IHS_IHPS_W3_created_data}/Cassava Addition IHS Agricultural Conversion Factor Database.dta", replace
	
	//to populate N/A observations
	use "${MWI_IHS_IHPS_W3_appended_data}/IHS Agricultural Conversion Factor Database.dta", clear
	drop if condition==1 | condition==3
	replace condition=3
	label define condition 3 "N/A"
	save "${MWI_IHS_IHPS_W3_created_data}/Primary Amended IHS Agricultural Conversion Factor Database.dta", replace
	
	//to populate . observations
	use "${MWI_IHS_IHPS_W3_appended_data}/IHS Agricultural Conversion Factor Database.dta", clear
	drop if condition==1 | condition==3
	replace condition=. if condition==2
	save "${MWI_IHS_IHPS_W3_created_data}/Secondary Amended IHS Agricultural Conversion Factor Database.dta", replace
	
	//Appending with original IHS dataset
	use "${MWI_IHS_IHPS_W3_appended_data}/IHS Agricultural Conversion Factor Database.dta", clear
	append using "${MWI_IHS_IHPS_W3_created_data}/Primary Amended IHS Agricultural Conversion Factor Database.dta"
	append using "${MWI_IHS_IHPS_W3_created_data}/Secondary Amended IHS Agricultural Conversion Factor Database.dta"
	append using "${MWI_IHS_IHPS_W3_created_data}/Cassava Addition IHS Agricultural Conversion Factor Database.dta"
	label define condition 3 "N/A", modify
	label define crop_code 49 "CASSAVA", modify
	save "${MWI_IHS_IHPS_W3_created_data}/Final Amended IHS Agricultural Conversion Factor Database.dta", replace
	}


//ALT: Temp
use "${MWI_IHS_IHPS_W3_created_data}/Final Amended IHS Agricultural Conversion Factor Database.dta", clear
recode crop_code (1 2 3 4=1)(5 6 7 8 9 10=5)(13 12 13 14 15 16=13)(17 18 19 20 21 22 23 24 25 26=17)
collapse (firstnm) conversion, by(region crop_code unit condition shell_unshelled)
save "${MWI_IHS_IHPS_W3_created_data}/Final Amended IHS Agricultural Conversion Factor Database.dta", replace
//end alt temp


	else {
	di as error "IHS Agricultural Conversion Factor Database.dta not present; caloric conversion will likely be incomplete"
	}
	
	
	capture confirm file "${MWI_IHS_IHPS_W3_created_data}/caloric_conversionfactor.dta"
	if !_rc {
	use "${MWI_IHS_IHPS_W3_created_data}/caloric_conversionfactor.dta", clear
	
	/*ALT: It's important to note that the file contains some redundancies (e.g., we don't need maize flour because we know the caloric value of the grain; white and orange sweet potato are identical, etc. etc.)
	So we need a step to drop the irrelevant entries. */
	//Also there's no way tea and coffee are just tea/coffee
	//Also, data issue: no crop code is indicative of green maize (i.e., sweet corn); I'm assuming this means cultivation information is not tracked for that crop
	//Calories for wheat flour are slightly higher than for raw wheat berries.
	drop if inlist(item_code, 101, 102, 103, 105, 202, 204, 206, 207, 301, 305, 405, 813, 820, 822, 901, 902) | cal_100g == .

	
	local item_name item_name
	foreach var of varlist item_name{
		gen item_name_upper=upper(`var')
	}
	
	gen crop_code = .
	count if missing(crop_code) 
	
	// crop seed master list
	replace crop_code=1 if strpos(item_name_upper, "MAIZE") 
	replace crop_code=5 if strpos(item_name_upper, "TOBACCO")
	replace crop_code=13 if strpos(item_name_upper, "GROUNDNUT") 
    replace crop_code=17 if strpos(item_name_upper, "RICE")
	replace crop_code=34 if strpos(item_name_upper, "BEAN")
	replace crop_code=27 if strpos(item_name_upper, "GROUND BEAN") | strpos(item_name_upper, "NZAMA")
	replace crop_code=28 if strpos(item_name_upper, "SWEET POTATO")
	replace crop_code=29 if strpos(item_name_upper, "IRISH POTATO") | strpos(item_name_upper, "MALAWI POTATO")
	replace crop_code=30 if strpos(item_name_upper, "WHEAT")
	replace crop_code=31 if strpos(item_name_upper, "FINGER MILLET")  | strpos(item_name_upper, "MAWERE")
	replace crop_code=32 if strpos(item_name_upper, "SORGHUM")
	replace crop_code=46 if strpos(item_name_upper, "PEA") // first to account for PEArl millet and pigeonPEA
	replace crop_code=33 if strpos(item_name_upper, "PEARL MILLET") | strpos(item_name_upper, "MCHEWERE")
	replace crop_code=35 if strpos(item_name_upper, "SOYABEAN")
	replace crop_code=36 if strpos(item_name_upper, "PIGEONPEA")| strpos(item_name_upper, "NANDOLO") | strpos(item_name_upper, "PIGEON PEA")
	replace crop_code=38 if strpos(item_name_upper, "SUNFLOWER")
	replace crop_code=39 if strpos(item_name_upper, "SUGAR CANE")
	replace crop_code=40 if strpos(item_name_upper, "CABBAGE")
	replace crop_code=41 if strpos(item_name_upper, "TANAPOSI")
	replace crop_code=42 if strpos(item_name_upper, "NKHWANI")
	replace crop_code=43 if strpos(item_name_upper, "OKRA")
	replace crop_code=44 if strpos(item_name_upper, "TOMATO")
	replace crop_code=45 if strpos(item_name_upper, "ONION")
	replace crop_code=47 if strpos(item_name_upper, "PAPRIKA")

	count if missing(crop_code) //87 missing
	
	// food from tree/permanent crop master list
	replace crop_code=49 if strpos(item_name_upper,"CASSAVA") 
	replace crop_code=50 if strpos(item_name_upper,"TEA")
	replace crop_code=51 if strpos(item_name_upper,"COFFEE") 
	replace crop_code=52 if strpos(item_name_upper,"MANGO")
	replace crop_code=53 if strpos(item_name_upper,"ORANGE")
	replace crop_code=54 if strpos(item_name_upper,"PAWPAW")| strpos(item_name_upper, "PAPAYA")
	replace crop_code=55 if strpos(item_name_upper,"BANANA")
	
	replace crop_code=56 if strpos(item_name_upper,"AVOCADO" )
	replace crop_code=57 if strpos(item_name_upper,"GUAVA" )
	replace crop_code=58 if strpos(item_name_upper,"LEMON" )
	replace crop_code=59 if strpos(item_name_upper,"NAARTJE" )| strpos(item_name_upper, "TANGERINE")
	replace crop_code=60 if strpos(item_name_upper,"PEACH" )
	replace crop_code=61 if strpos(item_name_upper,"POZA") | strpos(item_name_upper, "APPLE")
	replace crop_code=63 if strpos(item_name_upper,"MASAU")
	replace crop_code=64 if strpos(item_name_upper,"PINEAPPLE" )
	replace crop_code=65 if strpos(item_name_upper,"MACADEMIA" )
	//replace crop_code= X if strpos(item_name_upper,"COCOYAM") No cropcode for cocoyam.
	count if missing(crop_code) //76 missing
	drop if crop_code == . 
	
	// More matches using crop_code_short
	ren crop_code crop_code_short
	save "${MWI_IHS_IHPS_W3_created_data}/caloric_conversionfactor_crop_codes.dta", replace 
	}
	else {
	di as error "Updated conversion factor file not present; caloric conversion will likely be incomplete"
	}
	
	
********************************************************************************
*ALL PLOTS  FN 4/15; HI checked 4/27/22 for functionality beyond final merge - needs review and final check.
********************************************************************************
/*Inputs to this section: 
					___change__> sect13f: area_planted, date of last harvest, losses, actual harvest of tree/permanent crop, anticipated harvest of field crops, expected sales
					__change___> secta3i: date of harvest, quantity harvested, future expected harvest
					ag_mod_i_13 / ag_mod_o_13: actual sales
				Workflow:
					Get area planted/harvested
					Determine what's *actually* a monocropped plot 
					Value crop (based on estimated value, anticipated sales value, or actual sales value? Seems like going in reverse order is best)*/
					
/*Purpose: (from Uganda W5)
Crop values section is about finding out the value of sold crops. It saves the results in temporary storage that is deleted once the code stops running, so the entire section must be ran at once (conversion factors require output from Crop Values section).

Plot variables section is about pretty much everything else you see below in all_plots.dta. It spends a lot of time creating proper variables around intercropped, monocropped, and relay cropped plots, as the actual data collected by the survey seems inconsistent here.

Many intermediate spreadsheets are generated in the process of creating the final .dta

Final goal is all_plots.dta. This file has regional, hhid, plotid, crop code, fieldsize, monocrop dummy variable, relay cropping variable, quantity of harvest, value of harvest, hectares planted and harvested, number of trees planted, plot manager gender, percent inputs(?), percent field (?), and months grown variables.

Note: Malawi has dry season, rainy season, and permanent/tree crop data in separate modules which are all combined below 

	*/
********************************************************************************
*ALL PLOTS
********************************************************************************

    ***************************
	*Crop Values
	***************************
	//Nonstandard unit values (kg values in plot variables section)
	use "${MWI_IHS_IHPS_W3_appended_data}/AG_MOD_I.dta", clear
	gen season=0 //rainy season 
	append using "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_o.dta" 
	recode season (.=1) //dry season 
	append using "${MWI_IHS_IHPS_W3_appended_data}/AG_MOD_Q.dta"
	recode season (.=2) //tree or permanent crop
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season
	keep if ag_i01==1 | ag_o01==1 | ag_q01==1
	ren ag_i02a sold_qty //rainy: total sold
	replace sold_qty = ag_o02a if sold_qty ==. & ag_o02a!=. //dry
	replace sold_qty = ag_q02a if sold_qty ==. & ag_q02a!=. //tree/permanent 
	ren ag_i02b unit
	replace unit = ag_o02b if unit ==. & ag_o02b! =.
	replace unit = ag_q02b if unit ==. & ag_q02b! =.
	ren ag_i03 sold_value
	replace sold_value=ag_o03 if sold_value==. & ag_o03!=.
	replace sold_value=ag_q03 if sold_value==. & ag_q03!=.
	
	
	label define AG_M0B 49 "CASSAVA" 50 "TEA" 51 "COFFEE" 52 "MANGO" 53 "ORANGE" 54 "PAWPAW/PAPAYA" 55 "BANANA" 56 "AVOCADO" 57 "GUAVA" 58 "LEMON" 59 "NAARTJE (TANGERINE)" 60 "PEACH" 61 "POZA (CUSTARD APPLE)" 62 "MASUKU (MEXICAN APPLE)" 63 "MASAU" 64 "PINEAPPLE" 65 "MACADEMIA" 66 "OTHER (SPECIFY)" 67 "N/A" 68 "N/A", add
	
	keep hhid crop_code sold_qty unit sold_value 
	recast str50 hhid, force
	
	merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_weights.dta", nogen keepusing(region district ta ea rural weight)
	

	keep hhid sold_qty unit sold_value crop_code region district ta ea rural  weight
	gen price_unit = sold_value/sold_qty 
	lab var price_unit "Average sold value per crop unit"
	gen obs=price_unit!=.
	
	merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta", nogen keep(1 3)		
	
	*create a value for the price of each crop at different levels
	foreach i in region district ta ea hhid {
	preserve
	bys `i' crop_code unit : egen obs_`i'_price = sum(obs) 
	collapse (median) price_unit_`i'=price_unit [aw=weight], by (`i' unit crop_code obs_`i'_price) 
	tempfile price_unit_`i'_median
	save `price_unit_`i'_median'
	restore
	}
	collapse (median) price_unit_country = price_unit (sum) obs_country_price=obs [aw=weight], by(crop_code unit)
	tempfile price_unit_country_median
	save `price_unit_country_median'

	*/
	****************************
	*Plot variables
	****************************
	use "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_g.dta", clear //rainy ** Running this again because we created a dummy dataset for plot decision maker which changes the variables if np
	gen season=0 //create variable for season 
	append using "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_m.dta" //dry
	recode season(.=1)
	append using "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_p.dta" // tree/perm 
	ren plotid plot_id
	ren gardenid garden_id
	ren ag_p05 number_trees_planted // number of trees planted during last 12 months
	recode season (.=2)
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season
	gen crop_code_perm=ag_p0c //TH: tree crop codes overlap with crop crop codes, i recode them here to have unique numbers
	recode crop_code_perm (2=49) (3=50)(4=51)(5=52)(6=53)(7=54)(8=55)(0=56)(10=57)(13=58)(12=59)(13=60)(14=61)(15=62)(16=63)(17=64)(21=65)(100=66)(1800=67)(1900=68)(2000=69) 
	//FN: nothing coded was as 1, 18, 19, 20
	la var crop_code_perm "Unique crop codes for trees/ permanent crops"
	label define crop_code_perm 49 "TEA" 50 "COFFEE" 51 "MANGO" 52 "ORANGE" 53 "PAWPAW/PAPAYA" 54 "BANANA" 55 "AVOCADO" 56 "GUAVA" 57 "LEMON" 58 "NAARTJE (TANGERINE)" 59 "PEACH" 60 "POZA (CUSTARD APPLE)" 61 "MASUKU (MEXICAN APPLE)" 62 "MASAU" 63 "PINEAPPLE" 64 "MACADEMIA" 65 "OTHER (SPECIFY)" 66 "CASSAVA" 67 "FODDER TREES" 68 "FERTILISER TREES" 69 "FUEL WOOD TREES"
	label val crop_code_perm crop_code_perm

	replace crop_code=crop_code_perm if crop_code==. & crop_code_perm!=. //TH: applying tree codes to crop codes
	label define crop_complete 49 "TEA" 50 "COFFEE" 51 "MANGO" 52 "ORANGE" 53 "PAWPAW/PAPAYA" 54 "BANANA" 55 "AVOCADO" 56 "GUAVA" 57 "LEMON" 58 "NAARTJE (TANGERINE)" 59 "PEACH" 60 "POZA (CUSTARD APPLE)" 61 "MASUKU (MEXICAN APPLE)" 62 "MASAU" 63 "PINEAPPLE" 64 "MACADEMIA" 65 "OTHER (SPECIFY)" 66 "CASSAVA" 67 "FODDER TREES" 68 "FERTILISER TREES" 69 "FUEL WOOD TREES", add

	label val crop_code crop_complete 

**consolidate crop codes (into the lowest number of the crop category)
	gen crop_code_short=crop_code //Generic level (without detail)
	recode crop_code_short (1 2 3 4=1)(5 6 7 8 9 10=5)(11 12 13 14 15 16=11)(17 18 19 20 21 22 23 24 25 26=17)
	la var crop_code_short "Generic level crop code"
	la val crop_code_short crop_complete 
	label define crop_complete 1 "Maize" 5 "Tobacco" 13 "Groundnut" 17 "Rice", modify
	drop if crop_code_short==. //SS: 1150 obs deleted

	*Create area variables
	gen crop_area_share=ag_g03 //rainy season TH: this indicates proportion of plot with crop, but NGA area_unit indicates the unit (ie stands/ridges/heaps) that area was measured in
	label var crop_area_share "Proportion of plot planted with crop"
	replace crop_area_share =ag_m03 if crop_area_share==. & ag_m03!=. //dry szn 
	replace crop_area_share=0.125 if crop_area_share==1 //converting answers to proportions
	replace crop_area_share=0.25 if crop_area_share==2 
	replace crop_area_share=0.5 if crop_area_share==3
	replace crop_area_share=0.75 if crop_area_share==4
	replace crop_area_share=.875 if crop_area_share==5
	replace crop_area_share=1 if ag_g02==1 | ag_m02==1 //FN: ag_g02/ag_m02 = was the plot planted in the entire area of the plot 
 	recast str50 hhid, force
	merge m:1 hhid  plot_id garden_id using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_plot_areas.dta" 
	gen ha_planted=crop_area_share*area_meas_hectares
	replace ha_planted=crop_area_share*area_est_hectares if ha_planted==. & area_est_hectares!=. & area_est_hectares!=0
	replace ha_planted=ag_p02a* (1/2.47105) if ag_p02b==1 & ha_planted==. & (ag_p02a!=. & ag_p02a!=0 & ag_p02b!=0 & ag_p02b!=.)
	replace ha_planted=ag_p02a*(1/10000) if ag_p02b==3 & ha_planted==. & (ag_p02a!=. & ag_p02a!=0 & ag_p02b!=0 & ag_p02b!=.)

	tempfile ha_planted
	save `ha_planted'
	save 	"${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_ha_planted.dta", replace

	//TH: The NGA w3 survey asks "what area of the plot is covered by trees" while the Malawi w3 survey asks "what is the area of the plantation" (for trees; area + unit), how can we consolidate these under one indicator/ should we?
	drop crop_area_share
	gen ha_harvested=ha_planted

	*** TIME VARIABLES (month planted, harvest, and length of time grown) ***
	
	* Month Planted *
	gen month_planted = ag_g05a
	replace month_planted = ag_m05a if month_planted==.
	lab var month_planted "Month of planting"
	
	* Year Planted *
	codebook ag_m05b 
	drop if ag_g05b==201 | ag_g05b==2013 | ag_g05b==2014 
	gen year_planted1 = ag_g05b
	gen year_planted2 = ag_m05b //
	gen year_planted = year_planted1
	replace year_planted= year_planted2 if year_planted==.
	lab var year_planted "Year of planting"
	
	* Month Harvested (Start) *
	gen harvest_month_begin = ag_g12a
	replace harvest_month_begin =ag_m12a if harvest_month_begin==. & ag_m12a!=.
	lab var harvest_month_begin "Month of start of harvesting"
	
	gen harvest_month_end=ag_g12b
	replace harvest_month_end=ag_m12b if harvest_month_end==. & ag_m12b!=.
	lab var harvest_month_end "Month of end of harvesting"
		
	* Months Crop Grown *
	gen months_grown = harvest_month_begin - month_planted if harvest_month_begin > month_planted  // since no year info, assuming if month harvested was greater than month planted, they were in same year 
	replace months_grown = 12 - month_planted + harvest_month_begin if harvest_month_begin < month_planted // months in the first calendar year when crop planted 
	replace months_grown = 12 - month_planted if months_grown<1 // reconcile crops for which month planted is later than month harvested in the same year
	replace months_grown=. if months_grown <1 | month_planted==. | harvest_month_begin==.
	lab var months_grown "Total months crops were grown before harvest"
	
	//Plot workdays
	preserve
	gen days_grown = months_grown*30 
	collapse (max) days_grown, by(hhid garden_id plot_id)
	save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_plot_season_length.dta", replace
	restore
	
	* Date Planted *
	gen date_planted = mdy(month_planted, 1, ag_g05b) if ag_g05b!=.
	replace date_planted = mdy(month_planted-12, 1, ag_g05b) if month_planted>12 & ag_g05b!=.
	replace date_planted = mdy(month_planted-12, 1, ag_m05b) if month_planted>12 & ag_m05b!=.
	replace date_planted = mdy(month_planted, 1, ag_m05b) if date_planted==. & ag_m05b!=.
	
	* Date Harvested *
	*TH: survey did not ask for harvest year, see/ check assumptions for year:
	gen date_harvested = mdy(harvest_month_begin, 1, ag_g05b) if ag_g05b==2016
	replace date_harvested = mdy(harvest_month_begin, 1, ag_m05b) if harvest_month_begin==. & ag_m05b==2016
	replace date_harvested = mdy(harvest_month_begin, 1, ag_g05b) if month_planted<=12 &harvest_month_begin>month_planted & date_harvest==. & ag_g05b!=. //assuming if planted in 2015 and month harvested is later than planted, it was harvested in 2015
	replace date_harvested = mdy(harvest_month_begin, 1, ag_m05b) if month_planted<=12 &harvest_month_begin>month_planted & date_harvest==. & ag_m05b!=.
	replace date_harvested = mdy(harvest_month_begin, 1, ag_g05b+1) if month_planted<=12 & harvest_month_begin<month_planted & date_harvest==. & ag_g05b!=.
	replace date_harvested = mdy(harvest_month_begin, 1, ag_m05b+1) if month_planted<=12 & harvest_month_begin<month_planted & date_harvest==. & ag_m05b!=.
	
	format date_planted %td
	format date_harvested %td
	gen days_grown=date_harvest-date_planted
	
	bys plot_id hhid : egen min_date_harvested = min(date_harvested)
	bys plot_id hhid : egen max_date_planted = max(date_planted)
	gen overlap_date = min_date_harvested - max_date_planted 
	
	*Generate crops_plot variable for number of crops per plot. This is used to fix issues around intercropping and relay cropping being reported inaccurately for our purposes.
	preserve
		gen obs=1
		replace obs=0 if ag_g13a==0 | ag_m13a==0 | ag_p09a==0  
		collapse(sum)crops_plot=obs, by(hhid plot_id garden_id season) 
		tempfile ncrops
		save `ncrops'
	restore
	
	merge m:1 hhid plot_id garden_id season using `ncrops', nogen 
	
	gen contradict_mono = 1 if (ag_g01==1 | ag_m01==1) & crops_plot >1
	gen contradict_inter = 1 if (ag_g01==2 | ag_m01==2) & crops_plot ==1 
	replace contradict_inter = . if ag_g01==1 | ag_m01==1 
		
	
		*Generating monocropped plot variables (Part 1)
		bys hhid plot_id garden_id season: egen crops_avg= mean(crop_code_short) //checks for diff versions of same crop in the same plot
		gen purestand=1 if crops_plot==1 | crops_avg == crop_code_short 
		gen perm_crop=1 if crop_code!=. 
		bys hhid plot_id : egen permax = max(perm_crop) 

		bys hhid plot_id month_planted year_planted : gen plant_date_unique=_n
		bys hhid plot_id harvest_month_begin : gen harv_date_unique=_n //MGM: survey does not ask year of harvest for crops
		bys hhid plot_id : egen plant_dates = max(plant_date_unique)
		bys hhid plot_id : egen harv_dates = max(harv_date_unique) 

	replace purestand=0 if (crops_plot>1 & (plant_dates>1 | harv_dates>1))  | (crops_plot>1 & permax==1)  
	gen any_mixed=!(ag_g01==1 | ag_m01==1 | (perm_crop==1 & purestand==1)) 
	bys hhid plot_id : egen any_mixed_max = max(any_mixed)
	replace purestand=1 if crops_plot>1 & plant_dates==1 & harv_dates==1 & permax==0 & any_mixed_max==0 
	
	replace purestand=1 if crop_code==crops_avg 
	replace purestand=0 if purestand==. 
	drop crops_plot crops_avg plant_dates harv_dates plant_date_unique harv_date_unique permax
	
	* Rescaling plots *
	replace ha_planted = ha_harvest if ha_planted==. 
	//Let's first consider that planting might be misreported but harvest is accurate
	replace ha_planted = ha_harvest if ha_planted > area_meas_hectares & ha_harvest < ha_planted & ha_harvest!=. 
	gen percent_field=ha_planted/area_meas_hectares 
*Generating total percent of purestand and monocropped on a field
	bys hhid plot_id garden_id : egen total_percent = total(percent_field)
	
	replace percent_field = percent_field/total_percent if total_percent>1 & purestand==0
	replace percent_field = 1 if percent_field>1 & purestand==1
	
	replace ha_planted = percent_field*area_meas_hectares
	replace ha_harvest = ha_planted if ha_harvest > ha_planted
	
	
	ren ag_g13b unit // HKS 09.11.23: to preserve unit as a labeled factor, not an un-labeled numeric
	replace unit = ag_m11b if unit == .  // hks 09.11.23: previously was m13b, which is not a unit var
	replace unit = ag_p09b if unit == . // tree crops

	ren ag_g13a quantity_harvested
	replace quantity_harvested = ag_m13a if quantity_harvested==. & ag_m13a !=. 
	replace quantity_harvested = ag_p09a if quantity_harvested==. & ag_p09a !=.
	
	* Merging in HH module A to bring in region info 
	merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta", nogen keep(1 3) // updating code accordingly. The created data set offers regional info and renamed case_id to hhid
	
	* Renaming condition vars in master to match using file 
	gen condition=ag_g13c
	lab define condition 1 "S: SHELLED" 2 "U: UNSHELLED" 3 "N/A", modify
	lab val condition condition
	replace condition = ag_g13c if condition==. & ag_g13c !=. 
	replace condition = ag_m11c if condition==. & ag_m11c !=. 
	
	gen unit_fix = strpos(ag_g13b_oth, "70 KGS") | strpos(ag_g13b_oth, "1 TON")
	replace quantity_harvested = quantity_harvested * 70 if strpos(ag_g13b_oth, "70 KGS") 
	replace quantity_harvested = quantity_harvested * 1000 if strpos(ag_g13b_oth, "1 TON") 
	replace unit = 1 if unit_fix==1 
	drop unit_fix

	capture {
		confirm file `"${MWI_IHS_IHPS_W3_created_data}/Final Amended IHS Agricultural Conversion Factor Database.dta"'
	} 
	if !_rc {
	merge m:1 region crop_code_short unit condition using "${MWI_IHS_IHPS_W3_created_data}/Final Amended IHS Agricultural Conversion Factor Database.dta", keep(1 3) gen(cf_merge) 
} 
else {
 di as error "Updated conversion factors file not present; harvest data will likely be incomplete"
}

//ALT: Multiply by shelled/unshelled cf for unshelled units
	replace conversion = 1 if unit == 1 & conversion==. 
	replace conversion = 1*shell_unshelled if unit == 1 & conversion==. & condition==2 
	replace conversion = 50 if unit==2 & conversion==. & condition 
	replace conversion = 50*shell_unshelled if unit==2 & conversion==. & condition==2 
	replace conversion = 90 if unit==3 & conversion==. 
	replace conversion = 90*shell_unshelled if unit==3 & conversion==. & condition==2 
	gen quant_harv_kg= quantity_harvested*conversion
	
	preserve
	keep quant_harv_kg crop_code crop_code_short hhid plot_id garden_id season
	save "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_yield_1_6_23.dta", replace
	restore	

//ALT This should use the geographic medians.
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_weights.dta", nogen 

foreach i in region district ta ea hhid {
	merge m:1 `i' crop_code unit using  `price_unit_`i'_median', nogen keep(1 3)
	}
merge m:1 unit crop_code using `price_unit_country_median', nogen keep(1 3)
//Using giving household price priority; take hhid out if results are looking weird
gen value_harvest = price_unit_hhid * quant_harv_kg 
gen missing_price = value_harvest == .
foreach i in region district ta ea { //decending order from largest to smallest geographical figure
replace value_harvest = quantity_harvested * price_unit_`i' if missing_price == 1 & obs_`i' > 9 & obs_`i' != . 
}
replace value_harvest = quantity_harvested * price_unit_country if value_harvest==.

	
	gen val_unit = value_harvest/quantity_harvested
	gen val_kg = value_harvest/quant_harv_kg
	gen plotweight = ha_planted*conversion
	gen obs=quantity_harvested>0 & quantity_harvested!=.

preserve
	collapse (mean) val_unit, by (hhid crop_code unit)
	drop if crop_code ==. 
	ren val_unit hh_price_mean
	lab var hh_price_mean "Average price reported for this crop-unit in the household"
	save "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_hh_crop_prices_for_wages.dta", replace
restore
preserve
collapse (median) val_unit_country = val_unit (sum) obs_country_unit=obs [aw=plotweight], by(crop_code unit)
save "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_crop_prices_median_country.dta", replace //This gets used for self-employment income.
restore	


	
	***** Adding Caloric conversion - CWL
	// Add calories if the prerequisite caloric conversion file exists
	capture {
		confirm file `"${MWI_IHS_IHPS_W3_created_data}/caloric_conversionfactor_crop_codes.dta"'
	} 
	if _rc!=0 {
		display "Note: file ${MWI_IHS_IHPS_W3_created_data}/caloric_conversionfactor_crop_codes.dta does not exist - skipping calorie calculations"		
	}
	if _rc==0{
		merge m:1 crop_code_short using "${MWI_IHS_IHPS_W3_created_data}/caloric_conversionfactor_crop_codes.dta", nogen keep(1 3)
	
		// logic for units: calories / 100g * kg * 1000g/kg * edibe perc * 100 / perc * 1/1000 = cal
		gen calories = cal_100g * quant_harv_kg * edible_p / .1 
		count if missing(calories) 
	}	
	
	//AgQuery
	collapse (sum) quant_harv_kg value_harvest ha_planted ha_harvest number_trees_planted percent_field (max) months_grown, by(region district ea ta hhid plot_id garden_id crop_code crop_code_short purestand area_meas_hectares condition)
	bys hhid plot_id garden_id: egen percent_area = sum(percent_field)
	bys hhid plot_id garden_id : gen percent_inputs = percent_field/percent_area
	drop percent_area 
	capture ren ea ea_id
	save "${MWI_IHS_IHPS_W3_created_data}/Malawi_W3_all_plots.dta",replace
	
**# Bookmark #1// code to find topcrop
	/*use "${MWI_IHS_IHPS_W3_created_data}/Malawi_W3_all_plots.dta", clear
	merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhsize.dta"
	gen area= ha_planted*weight 
	collapse (sum) area, by (crop_code_short)*/
	
	
************************
*TLU (Tropical Livestock Units) 06/02/2023 SS Checked (Need to push it to github)
************************
use "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_r1.dta", clear		
gen tlu_coefficient=0.5 if (ag_r0a==304|ag_r0a==303|ag_r0a==302|ag_r0a==301) //bull, cow, steer & heifer, calf [for Malawi]
replace tlu_coefficient=0.1 if (ag_r0a==307|ag_r0a==308) //goat, sheep
replace tlu_coefficient=0.2 if (ag_r0a==309) //pig
replace tlu_coefficient=0.01 if (ag_r0a==3310|ag_r0a==315) //lvstckid==12|lvstckid==13) //chicken (layer & broiler), duck, other poultry (MLW has "other"?), hare (not in MLW but have hen?) AKS 5.15		
//EEE 10.1 From looking at other instruments/waves, I would include 313 LOCAL-HEN, 313-LOCAL-COCK, 3314 TURKEY/GUINEA FOWL, and 319 DOVE/PIGEON in the line above
replace tlu_coefficient=0.3 if ag_r0a==3305 // donkey
lab var tlu_coefficient "Tropical Livestock Unit coefficient"

*Livestock categories
gen cattle=inrange(ag_r0a,301,304)
gen smallrum=inlist(ag_r0a,307,308,309) //inlcudes sheep, goat			//EEE 10.1 inrange vs. inlist
gen poultry=inlist(ag_r0a,313,313,315,319,3310,3314)  //includes pigeon (319)		//EEE 10.1 changed to reflect list above
gen other_ls=ag_r0a==318 | 3305 | 3304 // inlcludes other, donkey/horse, ox		//EEE 10.1 must include ag_r0a= with every single or clause
gen cows=ag_r0a==303
gen chickens= ag_r0a==313 | 313 | 3310 | 3314 // includes local cock (313), local hen (313),  chicken layer (3310), and turkey (3314)		//EEE 10.1 same problem here
ren ag_r0a livestock_code

*Number of livestock owned, present-day
ren ag_r02 nb_ls_today
gen nb_cattle_today=nb_ls_today if cattle==1
gen nb_smallrum_today=nb_ls_today if smallrum==1
gen nb_poultry_today=nb_ls_today if poultry==1
gen nb_other_ls_today=nb_ls_today if other==1 
gen nb_cows_today=nb_ls_today if cows==1
gen nb_chickens_today=nb_ls_today if chickens==1
gen tlu_today = nb_ls_today * tlu_coefficient

lab var nb_cattle_today "Number of cattle owned as of the time of survey"
lab var nb_smallrum_today "Number of small ruminant owned as of the time of survey"
lab var nb_poultry_today "Number of cattle poultry as of the time of survey"
lab var nb_other_ls_today "Number of other livestock (horse, donkey, and other) owned as of the time of survey"
lab var nb_cows_today "Number of cows owned as of the time of survey"
lab var nb_chickens_today "Number of chickens owned as of the time of survey"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
lab var nb_ls_today "Number of livestock owned as of today" 

*Number of livestock owned, 1 year ago
gen nb_cattle_1yearago = ag_r07 if cattle==1
gen nb_smallrum_1yearago=ag_r07 if smallrum==1
gen nb_poultry_1yearago=ag_r07 if poultry==1
gen nb_other_1yearago=ag_r07 if other==1
gen nb_cows_1yearago=ag_r07 if cows==1
gen nb_chickens_1yearago=ag_r07 if chickens==1
gen nb_ls_1yearago = ag_r07
gen tlu_1yearago = ag_r07 * tlu_coefficient

lab var nb_cattle_1yearago "Number of cattle owned as of 12 months ago"
lab var nb_smallrum_1yearago "Number of small ruminants owned as of 12 months ago"
lab var nb_poultry_1yearago "Number of poultry as of 12 months ago"
lab var nb_other_1yearago "Number of other livestock (horse, donkey, and other) owned as of 12 months ago"
lab var nb_cows_1yearago "Number of cows owned as of 12 months ago"
lab var nb_chickens_1yearago "Number of chickens owned as of 12 months ago"
lab var nb_ls_1yearago "Number of livestock owned 12 months ago"

recode tlu_* nb_* (.=0)
collapse (sum) tlu_* nb_*  , by (hhid)
drop tlu_coefficient
save "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_TLU_Coefficients.dta", replace


************************
*GROSS CROP REVENUE 
************************
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_I.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_O.dta"
rename ag_i03 value
replace value = ag_o03 if  value==. 
recode value (.=0)
ren ag_i02a qty
replace qty = ag_o02a if qty==. & ag_o02a!=. 
gen unit=ag_i02b
replace unit= ag_o02b if unit==.
ren ag_i02c condition 
replace condition= ag_o02c if condition==.
tostring hhid, format(%18.0f) replace
recast str50 hhid, force 
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta", nogen keepusing(region district ta rural ea weight) keep(1 3)
rename crop_code crop_code_short 
***We merge Crop Sold Conversion Factor at the crop-unit-regional level***
merge m:1 region crop_code unit condition using "${MWI_IHS_IHPS_W3_created_data}/Final Amended IHS Agricultural Conversion Factor Database.dta", keep(1 3) nogen 

***We merge Crop Sold Conversion Factor at the crop-unit-national level***
 
*We create Quantity Sold (kg using standard  conversion factor table for each crop- unit and region). 
replace conversion=conversion if region!=. //  We merge the national standard conversion factor for those hhid with missing regional info. 
gen kgs_sold = qty*conversion 
collapse (sum) value kgs_sold, by (hhid crop_code)
lab var value "Value of sales of this crop"
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_W3_cropsales_value.dta", replace

use "${MWI_IHS_IHPS_W3_created_data}/Malawi_W3_all_plots.dta", clear

collapse (sum) value_harvest quant_harv_kg, by (hhid crop_code) // Update: SW We start using the standarized version of value harvested and kg harvested
rename crop_code crop_code_short 
merge 1:1 hhid crop_code using "${MWI_IHS_IHPS_W3_created_data}/Malawi_W3_cropsales_value.dta"
replace value_harvest = value if value>value_harvest & value_!=. /* In a few cases, sales value reported exceeds the estimated value of crop harvest */
ren value value_crop_sales 
recode  value_harvest value_crop_sales  (.=0)
collapse (sum) value_harvest value_crop_sales kgs_sold quant_harv_kg, by (hhid crop_code_short)
ren value_harvest value_crop_production
lab var value_crop_production "Gross value of crop production, summed over main and short season"
lab var value_crop_sales "Value of crops sold so far, summed over main and short season"
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_W3_hh_crop_values_production.dta", replace
//Legacy code 

collapse (sum) value_crop_production value_crop_sales, by (hhid)
lab var value_crop_production "Gross value of crop production for this household"
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_W3_hh_crop_production.dta", replace

*Crops lost post-harvest
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_I.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_O.dta"
drop if crop_code==. //302 observations deleted 
rename ag_i36d percent_lost
replace percent_lost = ag_o36d if percent_lost==. & ag_o36d!=.
replace percent_lost = 100 if percent_lost > 100 & percent_lost!=. 
tostring hhid, format(%18.0f) replace
rename crop_code crop_code_short 
merge m:1 hhid crop_code using "${MWI_IHS_IHPS_W3_created_data}/Malawi_W3_hh_crop_values_production.dta", nogen keep(1 3)
gen value_lost = value_crop_production * (percent_lost/100)
recode value_lost (.=0)
collapse (sum) value_lost, by (hhid)
rename value_lost crop_value_lost
lab var crop_value_lost "Value of crop production that had been lost by the time of survey"
save "${MWI_IHS_IHPS_W3_created_data}/Malawi_W3_crop_losses.dta", replace

/*Old Code:
/*use "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_g.dta", clear		
append using "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_m.dta", gen(dry)
append using "${MWI_IHS_IHPS_W3_created_data}/Malawi_W3_cf.dta"

*Rename variables so they match in merged files
ren plotid plot_id
ren gardenid garden_id 
replace crop_code_full = crop_code_collapsed if crop_code_full==.
replace unit = ag_m13b if unit==.
replace condition = ag_m11c if condition==.
drop if plot_id==""

*Merge in region from hhids file and conversion factors
recast str50 hhid, force 
merge m:1 hhid using  "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta", nogen keep(1 3)	//6,739 matched 0 unmatched
merge m:1 region crop_code_full unit condition using  "${MWI_IHS_IHPS_W3_created_data}/Malawi_W3_cf.dta"		//5,109 matched 2,415 unmatched
//ren crop_code_full crop_code_collapsed 	//rename for consistency across files

*Temporary crops (both seasons) 
gen harvest_yesno=.
replace harvest_yesno = 1 if ag_g13a > 0 & ag_g13a !=.		//Yes harvested
replace harvest_yesno = 2 if ag_g13a == 0					//No harvested "maize rice sorgum pmillet fmill grdnt beans swtptt" //
gen kgs_harvest = ag_g13a*conversion if crop_code_full== 1 | crop_code_full== 17 | crop_code_full==32 |  crop_code_full==33 | crop_code_full==31 | crop_code_full==13 |  crop_code_full==34 |  crop_code_full==28 	
replace kgs_harvest = ag_m13a*conversion if crop_code_full== 1 | crop_code_full== 17 | crop_code_full==32 |  crop_code_full==33 | crop_code_full==31 | crop_code_full==13 |  crop_code_full==34 |  crop_code_full==28 & kgs_harvest==.
//rename ag4a_29 value_harvest																		//Not possible to construct value_harvest, used value_sold below instead
//replace value_harvest = ag4b_29 if value_harvest==.
replace kgs_harvest = 0 if harvest_yesno==2					//If no harvest, then 0 KG
collapse (sum) kgs_harvest /*value_harvest*/, by (hhid crop_code_collapsed plot_id)
ren crop_code_collapsed crop_code							//For consistency 
lab var kgs_harvest "Kgs harvested of this crop, summed over main and short season"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_tempcrop_harvest.dta", replace

*Value of harvest by quantity sold - in Module I of LSMS (no value of harvest question in Malawi) 
use "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_i.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_o.dta", gen(dry)		//Neither of these files have the crop_code_collapsed; only extenstive crop code

gen crop_code_collapsed=.
replace crop_code_collapsed=1 if crop_code==1 | crop_code==2 | crop_code==3 | crop_code==4											//MAIZE
replace crop_code_collapsed=17 if crop_code==17 | crop_code==18 | crop_code==19 | crop_code==21 | crop_code==23 | crop_code==25		//RICE
//replace crop_code=30 //No wheat in this dta file Help - ask Emma
replace crop_code_collapsed=32 if crop_code==32																						//SORGUM
replace crop_code_collapsed=33 if crop_code==33																						//PMILL
replace crop_code_collapsed=13 if crop_code==13 | crop_code==12 | crop_code==13 | crop_code==14 | crop_code==15 | crop_code==16
replace crop_code_collapsed=34 if crop_code==34 | crop_code==34
replace crop_code_collapsed=28 if crop_code==28
la def crop_code_collapsed 1 "Maize" 17 "Rice" /*30 "Wheat"*/ 32 "Sorgum" 33 "Pearl Millet" 13 "Ground Nut" 34 "Beans" 28 "Sweet Potato" 
//la val crop_code crop_code_collapsed 	
//lab var crop_code_collapsed "Crop Code Collapsed" 

*Rename variables so they match in merged files
ren crop_code crop_code_full
ren ag_i02b unit 
replace unit = ag_o02b if unit==. 
ren ag_i02c condition
replace condition = ag_o02c if condition==.

*Merge in region from hhids file and conversion factors
recast str50 hhid, force 
merge m:1 hhid using  "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta", nogen keep(1 3)		//0 unmatched 23,918 matched
merge m:1 region crop_code_full unit condition using  "${MWI_IHS_IHPS_W3_created_data}/Malawi_W3_cf.dta"			//18,671 unmatched from master 651 unmatched from using 5,247 matched


*Temporary crop sales 
drop if crop_code_full==.
rename ag_i01 sell_yesno
replace sell_yesno = ag_o01 if sell_yesno==.
gen quantity_sold = ag_i02a*conversion if crop_code_full==1 | 13 | 17 | 28 | 30 | 32 | 33 | 34  //`c' //Help invalid syntax if I use `c'
replace quantity_sold = ag_o02a*conversion if crop_code_full==1 | 13 | 17 | 28 | 30 | 32 | 33 | 34  & quantity_sold==. //same issue for crop code as above
rename ag_i03 value_sold
replace value_sold = ag_o03 if value_sold==.
keep if sell_yesno==1
collapse (sum) quantity_sold value_sold, by (hhid crop_code_full)
lab var quantity_sold "Kgs sold of this crop, summed over main and short season"
lab var value_sold "Value sold of this crop, summed over main and short season"
gen price_kg = value_sold / quantity_sold
lab var price_kg "Price per kg sold"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_tempcrop_sales.dta", replace

*Permanent and tree crops
*fodder trees, fuel wood trees and fertiliser trees include as perm crops, but they are for purposes of soil improvement and not harvest so are excluded. 
use "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_p.dta", clear //Rainy season
ren ag_p0c crop_code
drop if crop_code==.						//Need to add new perm crops from world bank update e.g., coffee
replace crop_code = 100 if crop_code==4		//Mango - renaming all permanent crops due to overlap of codes with temporary crops
replace crop_code = 150 if crop_code==5		//Orange
replace crop_code = 200 if crop_code==6		//Papaya
replace crop_code = 250 if crop_code==7		//Banana
replace crop_code = 300 if crop_code==8		//Avocado
replace crop_code = 350 if crop_code==9		//Guava
replace crop_code = 400 if crop_code==10	//Lemon
replace crop_code = 450 if crop_code==13	//Tangerine
replace crop_code = 500 if crop_code==12	//Peach 
replace crop_code = 550 if crop_code==13	//Poza 
replace crop_code = 600 if crop_code==14	//Masuku
replace crop_code = 650 if crop_code==15	//Masau 
replace crop_code = 700 if crop_code==21	//Other - q=36
replace crop_code = 750 if crop_code==100	//Cassava - q=982 - use sweet potato 
replace crop_code = 800 if crop_code==16	//Pineapple //Treaing "piece" of pineapple as 1 KG. 
replace crop_code = 850 if crop_code==3		//Coffee 
replace crop_code = 900 if crop_code==17	//Macadamia
la def crop_code 100 "Mango" 150 "Orange" 200 "Papaya" 250 "Banana" 300 "Avocado" 350 "Guava" 400 "Lemon" 450 "Tangerine" 500 "Peach" 550 "Poza" /*
*/ 600 "Masuku" 650 Masau 700 "Other" 750 "Cassava" 800 "Pineapple" 850 "Coffee"

*Rename to match conversion file
ren ag_p09b unit	

*Created conversion file from resources PDF provided by World Bank -  missing crops include peach, poza, cassava, and masuku (no conversion for these)
recast str50 hhid, force 
merge m:1 hhid using  "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta", nogen keep(1 3)		//0 unmatched 3,959 matched - adding in region
merge m:1 region crop_code unit using  "${MWI_IHS_IHPS_W3_appended_data}/Conversion_factors_perm.dta"					//3,503 unmatched (3,439 from master & 64 from using) 520 matched 

gen kgs_harvest = ag_p09a*Conversion		//AKS 8.9.19: using conversions from created file but missing some converstion codes for units such as "basket"

collapse (sum) kgs_harvest, by (hhid crop_code plotid)
lab var kgs_harvest "Kgs harvested of this crop, summed over main and short season"
ren plotid plot_id							//For consistent coding
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_permcrop_harvest.dta", replace

use "${MWI_IHS_IHPS_W3_appended_data}/ag_mod_q.dta", clear //Dry season 
*units include kilogram, 50 kg bag, small pail, large pail, bunch, piece, ox-cart -- created perm conversion file to convert all to kg units. 
drop if crop_code==.
replace crop_code = 100 if crop_code==4		//Mango - renaming all permanent crops due to overlap of codes with temporary crops
replace crop_code = 150 if crop_code==5		//Orange
replace crop_code = 200 if crop_code==6		//Papaya
replace crop_code = 250 if crop_code==7		//Banana
replace crop_code = 300 if crop_code==8		//Avocado
replace crop_code = 350 if crop_code==9		//Guava
replace crop_code = 400 if crop_code==10	//Lemon
replace crop_code = 450 if crop_code==13	//Tangerine
replace crop_code = 500 if crop_code==12	//Peach  		
replace crop_code = 550 if crop_code==13	//Poza 	
replace crop_code = 600 if crop_code==14	//Masuku
replace crop_code = 650 if crop_code==15	//Masau
replace crop_code = 700 if crop_code==18	//Other 
replace crop_code = 750 if crop_code==1		//Cassava = q=867 - use Zambia code; oxcart measure is taken from 
replace crop_code = 800 if crop_code==16	//Pineapple //Treaing "piece" of pineapple as 1 KG. 
replace crop_code = 850 if crop_code==3		//Coffee
la def crop_code 100 "Mango" 150 "Orange" 200 "Papaya" 250 "Banana" 300 "Avocado" 350 "Guava" 400 "Lemon" 450 "Tangerine" 500 "Peach" 550 "Poza" /*
*/ 600 "Masuku" 650 "Masau" 700 "Other" 750 "Cassava"

*Rename to match conversion file
ren ag_q02b unit

*Checked this decision with Ayala. Created conversion file from resources PDF provided by World Bank 
	//Peach, Poza, Cassava, and Masuku do not have conversion codes in Malawi reference doc. Instead, I use the following conversions for each of these crops:
		/*Peach = Orange, Poza = Tangerine, Masuku = Tangerine,  and Cassava = I used "Raw cassava" conversion from Zambia LSMS; I use raw because most cassava is sold raw in Malawi (http://citeseerx.ist.psu.edu
		/viewdoc/download?doi=10.1.1.480.7549&rep=rep1&type=pdf*/
	*Ox-cart also does not have a conversion, instead I use the conversion factor for "extra large wheelbarrow" from Nigeria (https://microdata.worldbank.org/index.php/catalog/1002/datafile/F75/V1961)
recast str50 hhid, force 	
merge m:1 hhid using  "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta", nogen keep(1 3)				//0 unmatched 3,833 matched - adding in region
merge m:1 region crop_code unit using  "${MWI_IHS_IHPS_W3_appended_data}/Conversion_factors_perm.dta", nogen keep(1 3)		//3,690 unmatched (3,617 from master & 73 from using) 216 matched 

rename ag_q01 sell_yesno
gen quantity_sold = ag_q02a*Conversion			//AKS 8.9.19: using conversions from created file but missing some conversion codes for units such as "basket"
replace quantity_sold = ag_q02a*1 if unit==1	//If quantity is measured in KG just multiply by 1 to get KG quantity_sold (don't have this variable in conversion file)
rename ag_q03 value_sold
keep if sell_yesno==1
recode quantity_sold value_sold (.=0)
collapse (sum) quantity_sold value_sold, by (hhid crop_code)
lab var quantity_sold "Kgs sold of this crop, summed over main and short season"
lab var value_sold "Value sold of this crop, summed over main and short season"
gen price_kg = value_sold / quantity_sold
lab var price_kg "Price per kg sold"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_permcrop_sales.dta", replace


*Prices of permanent and tree crops need to be imputed from sales
use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_permcrop_sales.dta", clear
append using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_tempcrop_sales.dta"


recode price_kg (0=.)
recast str50 hhid, force 
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta"
drop if _merge==2
drop _merge
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_sales.dta", replace	//AKS Help - stata says that this file cannot be opened?

use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_sales.dta", clear	//Measure by EA (Note this wave does not have TA measure)
gen observation = 1
bys region district ea ta crop_code: egen obs_ea = count(observation)			
collapse (median) price_kg [aw=weight], by (region district ea crop_code obs_ea)
rename price_kg price_kg_median_ea
lab var price_kg_median_ea "Median price per kg for this crop in the enumeration area"
lab var obs_ea "Number of sales observations for this crop in the enumeration area"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_prices_ea.dta", replace

use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_sales.dta", clear	//Now measure by District 
gen observation = 1
bys region district crop_code: egen obs_district = count(observation) 
collapse (median) price_kg [aw=weight], by (region district crop_code obs_district)
rename price_kg price_kg_median_district
lab var price_kg_median_district "Median price per kg for this crop in the district"
lab var obs_district "Number of sales observations for this crop in the district"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_prices_district.dta", replace

use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_sales.dta", clear	//Now by Region
gen observation = 1 
bys crop_code: egen obs_region = count(observation)
collapse (median) price_kg [aw=weight], by (region crop_code obs_region)
rename price_kg price_kg_median_region
lab var price_kg_median_region "Median price per kg for this crop in the region"
lab var obs_region "Number of sales observations for this crop in the region"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_prices_region.dta", replace

use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_sales.dta", clear	//Now by country
gen observation = 1
bys crop_code: egen obs_country = count(observation)
collapse (median) price_kg [aw=weight], by (crop_code obs_country)
rename price_kg price_kg_median_country
lab var price_kg_median_country "Median price per kg for this crop in the country"
lab var obs_country "Number of sales observations for this crop in the country"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_prices_country.dta", replace

*Pull prices into harvest estimates
use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_sales.dta", clear
replace crop_code_full = -_n if crop_code_full==.
drop crop_code
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_sales_temp.dta", replace

use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_tempcrop_harvest.dta", clear		//Uniquely identify by HHID, plot_id, and crop_code_collapsed
append using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_permcrop_harvest.dta"
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta"	//2,563 unmatched (9 from master, 2,554 from using) & 27,547 matched
drop if _merge==2
drop _merge

rename crop_code crop_code_full
merge m:1 hhid crop_code_full using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_sales_temp.dta" //AKS help won't merge due to not uniquely idenifying but I don't see the problem. //TH 5.18.21 fixed

replace crop_code_full=. if crop_code_full<0
rename crop_code_full crop_code

drop _merge
replace ta = TA if ta == .
drop TA
replace ea_id = ea if ea_id == ""
drop ea
merge m:1 region district ea crop_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_prices_ea.dta"
drop _merge
//merge m:1 region district crop_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_prices_ta.dta" //TH 5.18.21 no TA in w3
//drop _merge
merge m:1 region district crop_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_prices_district.dta"
drop _merge
merge m:1 region crop_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_prices_region.dta"
drop _merge
merge m:1 crop_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_prices_country.dta"
drop _merge
gen price_kg_hh = price_kg
lab var price_kg_hh "Price per kg, with missing values imputed using local median values"
replace price_kg = price_kg_median_ea if price_kg==. & obs_ea >= 10 & crop_code!=21 &crop_code!=48 //TH 5.17.21: changed crop code to match "other" on W3 tempcrop/permacrop_harvest /* Don't impute prices for "other" permanent or temporary crops */
//replace price_kg = price_kg_median_ta if price_kg==. & obs_ta >= 10 & crop_code!=21 & crop_code!=48 // TH 5.17.21: no TA in w3
replace price_kg = price_kg_median_district if price_kg==. & obs_district >= 10 & crop_code!=21 & crop_code!=48
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10 & crop_code!=21 & crop_code!=48
replace price_kg = price_kg_median_country if price_kg==. & crop_code!=21 & crop_code!=48
lab var price_kg "Price per kg, with missing values imputed using local median values"

//AKS: Following MMH 6.21.19 (Malawi W1): This instrument doesn't ask about value harvest, just value sold, EFW 05.02.2019 (Uganda W1): Since we don't have value harvest for this instrument computing value harvest as price_kg * kgs_harvest for everything. This is what was done in Ethiopia baseline
gen value_harvest_imputed = kgs_harvest * price_kg_hh if price_kg_hh!=. 
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==.
replace value_harvest_imputed = 0 if value_harvest_imputed==.
lab var value_harvest_imputed "Imputed value of crop production"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_values_tempfile.dta", replace 

preserve 		
recode value_harvest_imputed value_sold kgs_harvest quantity_sold (.=0)
collapse (sum) value_harvest_imputed value_sold kgs_harvest quantity_sold , by (hhid crop_code)
ren value_harvest_imputed value_crop_production
lab var value_crop_production "Gross value of crop production, summed over rainy and dry season"
rename value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far, summed over rainy and dry season"
lab var kgs_harvest "Kgs harvested of this crop, summed over rainy and dry  season"
ren quantity_sold kgs_sold
lab var kgs_sold "Kgs sold of this crop, summed over rainy and dry season"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hh_crop_values_production.dta", replace
restore
*The file above will be used as the estimation intermediate variables : Gross value of crop production, Total value of crop sold, Total quantity harvested.  

collapse (sum) value_harvest_imputed value_sold, by (hhid)
replace value_harvest_imputed = value_sold if value_sold>value_harvest_imputed & value_sold!=. & value_harvest_imputed!=. /* In a few cases, the kgs sold exceeds the kgs harvested */
rename value_harvest_imputed value_crop_production
lab var value_crop_production "Gross value of crop production for this household"
*This is estimated using household value estimated for temporary crop production plus observed sales prices for permanent/tree crops.
*Prices are imputed using local median values when there are no sales.
rename value_sold value_crop_sales
lab var value_crop_sales "Value of crops sold so far"
gen proportion_cropvalue_sold = value_crop_sales / value_crop_production
lab var proportion_cropvalue_sold "Proportion of crop value produced that has been sold"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hh_crop_production.dta", replace

*Plot value of crop production
use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_values_tempfile.dta", clear
collapse (sum) value_harvest_imputed, by (hhid plot_id)
rename value_harvest_imputed plot_value_harvest
lab var plot_value_harvest "Value of crop harvest on this plot"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_plot_cropvalue.dta", replace

*Crop residues (captured only in Tanzania) 		// AKS 08.23/.2019: Malawi W4 doesn't ask about crop residues // TH 5.18.21 Malawi W3**

*Crop values for inputs in agricultural product processing (self-employment)
use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_sales.dta", clear //TH 5.18.21 recoding crop_code_full here so observations can be uniquely identified
replace crop_code_full = -_n if crop_code_full==.
drop crop_code
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_sales_temp.dta", replace

use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_tempcrop_harvest.dta", clear		
append using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_permcrop_harvest.dta"
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta", nogen keep(1 3)

rename crop_code crop_code_full //TH 5.18.21 restoring to original 
merge m:1 hhid crop_code_full using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_sales_temp.dta" 

replace crop_code_full=. if crop_code_full<0
rename crop_code_full crop_code
drop _merge
replace ta = TA if ta == .
replace ea_id = ea if ea_id == ""
drop ta ea

merge m:1 region district ea crop_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_prices_ea.dta", nogen // TH 5.18.21 no TA in W3
//merge m:1 region district crop_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_prices_ta.dta", nogen // TH 5.18.21 no TA in W3
merge m:1 region district crop_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_prices_district.dta", nogen
merge m:1 region crop_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_prices_region.dta", nogen
merge m:1 crop_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crop_prices_country.dta", nogen
replace price_kg = price_kg_median_ea if price_kg==. & obs_ea >= 10 & crop_code!= 48 & crop_code!=21 & crop_code!=18/* Don't impute prices for "other" crops. VAP: Check code 1800 for other. TH 5.17.21: Other crop ==18|21|48*/ 
//replace price_kg = price_kg_median_ta if price_kg==. & obs_ta >= 10 & crop_code!=18 // TH 5.18.21 no TA in w3
replace price_kg = price_kg_median_district if price_kg==. & obs_district >= 10 & crop_code!= 48 & crop_code!=21 & crop_code!=18
replace price_kg = price_kg_median_region if price_kg==. & obs_region >= 10 & crop_code!= 48 & crop_code!=21 & crop_code!=18
replace price_kg = price_kg_median_country if price_kg==. & crop_code!= 48 & crop_code!=21 & crop_code!=18
lab var price_kg "Price per kg, with missing values imputed using local median values"

gen value_harvest_imputed = kgs_harvest * price_kg if price_kg!=.  //MW W2 doesn't ask about value harvest, just value sold. 
replace value_harvest_imputed = kgs_harvest * price_kg if value_harvest_imputed==.
replace value_harvest_imputed = 0 if value_harvest_imputed==.
keep hhid crop_code price_kg 
duplicates drop
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hh_crop_prices.dta", replace

*/
*/
********************************************************************************
* CROP EXPENSES * 
********************************************************************************

/* Explanation of changes
MGM transferring notes from ALT: This section has been formatted significantly differently from previous waves and the Tanzania template file (see also NGA W3 and TZA W3-5).
Previously, inconsistent nomenclature forced the complete enumeration of variables at each step, which led to accidental omissions messing with prices.
This section is designed to reduce the amount of code needed to compute expenses and ensure everything gets included. We accomplish this by 
taking advantage of Stata's "reshape" command to take a wide-formatted file and convert it to long (see help(reshape) for more info). The resulting file has 
additional columns for expense type ("input") and whether the expense should be categorized as implicit or explicit ("exp"). This allows simple file manipulation using
collapse rather than rowtotal and can easily be converted back into our standard "wide" format using reshape. 
*/

	*********************************
	* 			LABOR				*
	*********************************
	*Hired rainy
	*Crop payments rainy
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_d.dta", clear 
	ren plotid plot_id
	ren gardenid garden_id 
	ren ag_d46f crop_code
	ren ag_d46c qty
	ren ag_d46d unit
	ren ag_d46e condition
	keep hhid plot_id garden_id crop_code qty unit condition 
	gen season=0 //"rainy"
tempfile rainy_crop_payments
save `rainy_crop_payments'
	
	*Crop payments dry
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_k.dta", clear 
	ren plotid plot_id
	ren gardenid garden_id 
	ren ag_k46c crop_code
	ren ag_k46d qty
	ren ag_k46e unit
	ren ag_k46f condition
	keep hhid plot_id garden_id crop_code qty unit condition 
	gen season= 1 //"dry"
tempfile dry_crop_payments
save `dry_crop_payments'

use `rainy_crop_payments', clear
append using `dry_crop_payments'
lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season 

recast str50 hhid, force
merge m:1 hhid crop_code unit using "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_hh_crop_prices_for_wages.dta", nogen keep (1 3) //SS 11.1.2023: only 46 0bs matched
	
	recode qty hh_price_mean (.=0)
	gen val = qty*hh_price_mean
	keep hhid val plot_id garden_id season 
	gen exp = "exp"
	merge m:1 hhid plot_id garden_id using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_plot_decision_makers.dta", nogen keep (1 3) keepusing(dm_gender)
	tempfile inkind_payments
	save `inkind_payments'

	
*HIRED LABOR
	/*SS 11.1.23 This code creates three temporary files for exchange labor in the rainy season: rainy_hired_all, rainy_hired_nonharvest, and rainy_hired_harvest. Will append nonharvest and harvest to compare to all.*/
	* For MWI W3, relevant question numbers on instrument are:
		* Q46: during rainy season, how many days did you hire men(a1)/women(a2)/children(a3);
		* Q47: during rainy season, how many days did you hire men/women/children for all NON-harvest activities
		* Q48: during the rainy season, how many days did you hire men/women/children for HARVEST activities
		* WAGES:
			* 46-48, b1-3, where b1 is MEN, b2 is WOMEN, and b3 is CHILDREN
			
local qnums "46 47 48" //qnums refer to question numbers on instrument		
foreach q in `qnums' {
    use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_d.dta", clear 
	compress hhid
	merge m:1  hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta"   

	ren ag_d`q'a1 dayshiredmale // 46a1 is days hired male ALL
	ren ag_d`q'a2 dayshiredfemale // 46a2 is days hired FEMALE ALL
	ren ag_d`q'a3 dayshiredchild // 46a3 is dyas hired children all
	ren ag_d`q'b1 wagehiredmale
	ren ag_d`q'b2 wagehiredfemale
	ren ag_d`q'b3 wagehiredchild

	capture ren TA ta
	keep region district ta ea rural hhid gardenid plotid *hired*
	gen season=0 //"rainy"
    local suffix ""
    if `q' == 46 {
        local suffix "_all"
		gen period="all"
    }
    else if `q' == 47 {
        local suffix "_nonharvest"
		gen period="harv-nonharv"
    }
    else if `q' == 48 {
        local suffix "_harvest"
		gen period="harv-nonharv"
    }
    tempfile rainy_hired`suffix'
    save `rainy_hired`suffix'', replace
}

	*Hired dry
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_k.dta", clear 
	compress hhid
	merge m:1 hhid ea using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta" , nogen
	ren ag_k46a1 dayshiredmale // "any and all types of activities "
	ren ag_k46a2 dayshiredfemale
	ren ag_k46a3 dayshiredchild
	ren ag_k46b1 wagehiredmale
	ren ag_k46b2 wagehiredfemale
	ren ag_k46b3 wagehiredchild
	capture ren TA ta
	keep region district ta ea rural hhid case_id plotid gardenid *hired* 
	gen season= 1 // "dry"
	ren plot plot_id
tempfile dry_hired_all
save `dry_hired_all' 

	use `rainy_hired_all'
	append using `dry_hired_all'
	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season 
	
	replace plot_id = plotid if plot_id == ""
		drop plotid
	duplicates drop region district ta ea case_id hhid plot_id garden season, force
	reshape long dayshired wagehired, i(region district ta ea case_id hhid garden plot_id season) j(gender) string 
	
	duplicates report region  district ta ea hhid case_id plot season
	duplicates tag region district ta ea hhid case_id gardenid plot season, gen(dups)

	* fill in missing eas
	gsort hhid case_id  -ea
	replace ea = ea[_n-1] if ea == ""	
	
	reshape long days wage, i(region district ta ea hhid garden plot season gender) j(labor_type) string
	recode wage days  (.=0) //no number on MWI
	drop if wage==0 & days==0 /*& number==0 & inkind==0*/ //105,990 observations deleted
	gen val = wage*days

tempfile all_hired
save `all_hired'
	

	*Exchange rainy
/*MGM 5.31.23 This code creates three temporary files for exchange labor in the rainy season: rainy_exchange_all, rainy_exchange_nonharvest, and rainy_exchange_harvest. Will append nonharvest and harvest to compare to all.*/
local qnums "50 52 54" //question numbers
foreach q in `qnums' {
    use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_d.dta", clear
	compress hhid
	merge m:1 hhid  using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta", nogen
	ren ag_d`q'a daysnonhiredmale
	ren ag_d`q'b daysnonhiredfemale
	ren ag_d`q'c daysnonhiredchild
		capture	ren TA ta
	keep region district ta ea rural case_id hhid plotid garden daysnonhired*
	gen season= 0 
    local suffix ""
    if `q' == 50 {
        local suffix "_all"
    }
    else if `q' == 52 {
        local suffix "_nonharvest"
    }
    else if `q' == 54 {
        local suffix "_harvest"
    }
	duplicates drop  region district ta ea rural hhid garden plotid season, force //1 duplicate deleted
	reshape long daysnonhired, i(region  district ta ea rural hhid garden plotid season) j(gender) string
    tempfile rainy_exchange`suffix'
    save `rainy_exchange`suffix'', replace
}

	*Exchange dry
    use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_k.dta", clear 
    
	compress hhid
	merge m:1 hhid  using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta", nogen
	ren ag_k47a daysnonhiredmale
	ren ag_k47b daysnonhiredfemale
	ren ag_k47c daysnonhiredchild
	capture ren TA ta
	keep region district ta ea rural hhid garden plotid daysnonhired*
	gen season= 1 
	reshape long daysnonhired, i(region   district ta ea rural hhid garden plotid season) j(gender) string
	tempfile dry_exchange_all 
    save `dry_exchange_all', replace
	append using `rainy_exchange_all'
			lab var season "season: 0=rainy, 1=dry, 2=tree crop"
			label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
			label values season season 
	capture replace plot_id = plotid if plot_id == ""
	capture drop plotid 
	gen days = daysn
	gen labor_type = "nonhired"
	drop daysnon
	tempfile all_exchange
	save `all_exchange', replace
	
//creates tempfile `members' to merge with household labor later
use "${MWI_IHS_IHPS_W3_appended_data}\hh_mod_b.dta", clear
	rename id_code indiv
	replace indiv= pid if  indiv==. & pid != .
isid  hhid indiv
gen male= (hh_b03==1) 
gen age=hh_b05a
lab var age "Individual age"
keep hhid age male indiv 
compress hhid
tempfile members
save `members', replace

*Household labor, rainy and dry
local seasons 0 1  // where 0 = rainy; 1=dry; 2=tree (not included here)
foreach season in `seasons' {
	di "`season'"
	if `season'==  0 {
		local qnums  "42 43 44" //refers to question numbers
		local dk d //refers to module d
		local ag ag_d00
	} 
	else {
		local qnums "43 44 45" //question numbers differ for module k than d
		local dk k //refers to module k
		local ag ag_k0a
	}
	use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_`dk'.dta", clear
	compress hhid
    merge m:1 hhid  using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta", nogen //merges in household info
	capture ren TA ta
	
	forvalues k=1(1)3 {
		local q : word `k' of `qnums'
		if `k' == 1 { //where 1 refers to the first value in qnums, question 42 - planting
        local suffix "_planting" 
    }
    else if `k' == 2 { //where 2 refers to the second value in qnums, question 43 - nonharvest
        local suffix "_nonharvest"
    }
    else if `k' == 3 { //where 3 refers to the third value in qnums, question 44 - harvest
        local suffix "_harvest"
    }
	ren ag_`dk'`q'a1 pid1`suffix'
    ren ag_`dk'`q'b1 weeks_worked1`suffix'
    ren ag_`dk'`q'c1 days_week1`suffix'
    ren ag_`dk'`q'd1 hours_day1`suffix'
    ren ag_`dk'`q'a2 pid2`suffix'
    ren ag_`dk'`q'b2 weeks_worked2`suffix'
    ren ag_`dk'`q'c2 days_week2`suffix'
    ren ag_`dk'`q'd2 hours_day2`suffix'
    ren ag_`dk'`q'a3 pid3`suffix'
    ren ag_`dk'`q'b3 weeks_worked3`suffix'
    ren ag_`dk'`q'c3 days_week3`suffix'
    ren ag_`dk'`q'd3 hours_day3`suffix'
    ren ag_`dk'`q'a4 pid4`suffix'
    ren ag_`dk'`q'b4 weeks_worked4`suffix'
    ren ag_`dk'`q'c4 days_week4`suffix'
    ren ag_`dk'`q'd4 hours_day4`suffix'
	ren ag_`dk'`q'a5 pid5`suffix'
    ren ag_`dk'`q'b5 weeks_worked5`suffix'
    ren ag_`dk'`q'c5 days_week5`suffix'
    ren ag_`dk'`q'd5 hours_day5`suffix'
	
	ren ag_`dk'`q'a6 pid6`suffix'
    ren ag_`dk'`q'b6 weeks_worked6`suffix'
    ren ag_`dk'`q'c6 days_week6`suffix'
    ren ag_`dk'`q'd6 hours_day6`suffix'
	
	ren ag_`dk'`q'a7 pid7`suffix'
    ren ag_`dk'`q'b7 weeks_worked7`suffix'
    ren ag_`dk'`q'c7 days_week7`suffix'
    ren ag_`dk'`q'd7 hours_day7`suffix'
	
	capture ren ag_`dk'`q'a8 pid8`suffix'
    capture ren ag_`dk'`q'b8 weeks_worked8`suffix'
    capture ren ag_`dk'`q'c8 days_week8`suffix'
    capture ren ag_`dk'`q'd8 hours_day8`suffix'
	
    capture ren ag_`dk'`q'a9 pid9`suffix'
    capture ren ag_`dk'`q'b9 weeks_worked9`suffix'
    capture ren ag_`dk'`q'c9 days_week9`suffix'
    capture ren ag_`dk'`q'd9 hours_day9`suffix'
	
	capture ren ag_`dk'`q'a10 pid10`suffix'
    capture ren ag_`dk'`q'b10 weeks_worked10`suffix'
    capture ren ag_`dk'`q'c10 days_week10`suffix'
    capture ren ag_`dk'`q'd10 hours_day10`suffix'
	
	capture ren ag_`dk'`q'a13 pid13`suffix'
    capture ren ag_`dk'`q'b13 weeks_worked13`suffix'
    capture ren ag_`dk'`q'c13 days_week13`suffix'
    capture ren ag_`dk'`q'd13 hours_day13`suffix'
	
	capture ren ag_`dk'`q'a12 pid12`suffix'
    capture ren ag_`dk'`q'b12 weeks_worked12`suffix'
    capture ren ag_`dk'`q'c12 days_week12`suffix'
    capture ren ag_`dk'`q'd12 hours_day12`suffix'
	
	capture ren ag_`dk'`q'a13 pid13`suffix'
    capture ren ag_`dk'`q'b13 weeks_worked13`suffix'
    capture ren ag_`dk'`q'c13 days_week13`suffix'
    capture ren ag_`dk'`q'd13 hours_day13`suffix'
    }
	keep region district ta ea rural hhid garden plotid pid* weeks_worked* days_week* hours_day*
    gen season = "`season'"
	unab vars : *`suffix' //this line generates a list of all the variables that end in suffix 
	local stubs : subinstr local vars "_`suffix'" "", all //this line removes `suffix' from the end of all of the variables that currently end in suffix
	duplicates drop  region district ta ea rural hhid garden plotid season, force //one duplicate entry
	reshape long pid weeks_worked days_week hours_day, i(region /*stratum*/  district ta ea rural hhid /*case_id*/ garden plotid season) j(num_suffix) string 
	split num_suffix, parse(_) //need additional command to break up num_suffix into two variables
	
	if `season'== 0 { 
		tempfile rainy
		save `rainy'
	}
	else {
		append using `rainy'
	}
}

destring season, force replace
lab var season "season: 0=rainy, 1=dry, 2=tree crop"
label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
label values season season 

gen days=weeks_worked*days_week
gen hours=weeks_worked*days_week*hours_day
drop if days==. 
drop if hours==. //0 observations deleted
//rescaling fam labor to growing season duration

ren plot plot_id
capture ren pid indiv

preserve
collapse (sum) days_rescale=days, by(region district ta ea rural hhid garden plot_id season indiv)
compress hhid
ren garden garden_id
merge m:1 hhid garden plot_id using"${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_plot_season_length.dta", nogen keep(1 3)
replace days_rescale = days_grown if days_rescale > days_grown
	compress hhid
tempfile rescaled_days
save `rescaled_days'
restore

//Rescaling to season
bys  hhid plot_id garden indiv : egen tot_days = sum(days)
gen days_prop = days/tot_days 
ren garden garden_id
recast str50 hhid, force 
merge m:1 region district ta ea rural hhid  garden_ plot_id indiv season using `rescaled_days' 
replace days = days_rescale * days_prop if tot_days > days_grown
merge m:1 hhid indiv using `members', nogen keep (1 3)
gen gender="child" if age<15 //MGM: age <16 on reference code, age <15 on MWI W1 survey instrument
replace gender="male" if strmatch(gender,"") & male==1
replace gender="female" if strmatch(gender,"") & male==0
gen labor_type="family"
keep region district ta ea rural hhid garden plot_id season gender days labor_type season
lab var season "season: 0=rainy, 1=dry, 2=tree crop"
label values season season
capture ren garden garden_id
append using `all_exchange'

gen val = . //MGM 7.20.23: EPAR cannot construct the value of family labor or nonhired (AKA exchange) labor MWI Waves 1, 2, 3, and 4 given issues with how the value of hired labor is constructed (e.g. we do not know how many laborers are hired and if wages are reported as aggregate or singular). Therefore, we cannot use a median value of hired labor to impute the value of family or nonhired (AKA exchange) labor.
append using `all_hired'
replace garden_id = gardenid if gardenid != "" & garden_ == ""
keep region district ta ea rural /*case_id*/ hhid garden_ plot_id season days val labor_type gender //MGM: number does not exist for MWI W1
drop if val==.&days==.
capture ren plotid plot_id
compress hhid 
capture ren garden garden_id
destring hhid, replace 
merge m:1 plot_id hhid garden using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender) // HKS 08.28.23: 0 empty dm_gender or plots in plot_decision_makers.dta; after merge, dm_gender is blank for 49,475 obs, which is nearly equivalent to the number of empty plot obs; thus, in the m:1 merge, all obs with plot_id == "" is populated with dm_gender == .; I do not believe there is anything we can do about that.

collapse (sum) val days, by(hhid plot_id garden_id season labor_type gender dm_gender) //this is a little confusing, but we need "gender" and "number" for the agwage file.
	la var gender "Gender of worker"
	la var dm_gender "Plot manager gender"
	la var labor_type "Hired, exchange, or family labor"
	la var days "Number of person-days per plot"
	la var val "Total value of hired labor (Malawian Kwacha)"
save "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_plot_labor_long.dta",replace
preserve
	collapse (sum) labor_=days, by (hhid plot_id garden_id labor_type season)
	reshape wide labor_, i(hhid plot_id garden_id season) j(labor_type) string
		la var labor_family "Number of family person-days spent on plot, all seasons"
		la var labor_nonhired "Number of exchange (free) person-days spent on plot, all seasons"
		la var labor_hired "Number of hired labor person-days spent on plot, all seasons"
	save "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_plot_labor_days.dta",replace //AgQuery
restore

//At this point all code below is legacy; we could cut it with some changes to how the summary stats get processed.
preserve
	gen exp="exp" if strmatch(labor_type,"hired")
	replace exp="imp" if strmatch(exp,"")
	collapse (sum) val, by (hhid plot_id garden_id season exp dm_gender)
	gen input="labor"
	save "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_plot_labor.dta", replace //this gets used below.
restore	


//And now we go back to wide
collapse (sum) val, by (hhid plot_id garden_id season labor_type dm_gender)
ren val val_ 
reshape wide val_, i(hhid plot_id garden_id season dm_gender) j(labor_type) string
ren val* val*_
gen season_fix="rainy" if season==0
replace season_fix="dry" if season==1
drop season
ren season_fix season
reshape wide val*, i (hhid plot_id garden_id dm_gender) j(season) string
gen dm_gender2 = "male" if dm_gender==1
replace dm_gender2 = "female" if dm_gender==2
replace dm_gender2 = "mixed" if dm_gender==3
replace dm_gender2 = "unknown" if dm_gender==.
drop dm_gender
ren val* val*_
drop if dm_gender2 == "" 
reshape wide val*, i(hhid plot_id garden_id) j(dm_gender2) string
collapse (sum) val*, by(hhid)
save "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_hh_cost_labor.dta", replace

**************************
*    LAND/PLOT RENT     *
************************** 
* Crops Payments
	use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_b2.dta", clear
	gen season=0
	append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_i2.dta"
	gen cultivate = 0
	replace cultivate = 1 if ag_b214 == 1
	replace cultivate = 1 if ag_i214 == 1 
	ren gardenid garden_id 
	gen payment_period=ag_b212b
	replace payment_period=ag_i212 if payment_period==.

* Paid
	ren ag_b208a crop_code_paid // SS 10.18.23- Only 963 crop type -how much are you supposed to pay instead of already paid 
	replace crop_code_paid=ag_i208a if crop_code_paid==. // SS 10.18.23 Only 123 crop type 
	ren ag_b208b qty_paid
	replace qty_paid=ag_i208b if qty_paid==.
	ren ag_b208c unit_paid
	replace unit_paid=ag_i208c if unit_paid==.
	ren ag_b208d condition_paid
	replace condition_paid=ag_i208d if condition_paid==.

* Owed
	ren ag_b210a crop_code_owed
	//replace crop_code_owed=ag_i210a if crop_code_owed==. //SS 10.18.23 no data for this 
	ren ag_b210b qty_owed
	//replace qty_owed=ag_i210b if qty_owed==. //no data for this 
	ren ag_b210c unit_owed
	//replace unit_owed=ag_i210c if unit_owed==. // no data for this 
	ren ag_b210d condition_owed
	//replace condition_owed=ag_i210d if condition_owed==. // no data for this 

	
	drop if crop_code_paid==. & crop_code_owed==. //only care about crop payments from households that made plot rental payments by crops
	drop if (unit_paid==. & crop_code_paid!=.) | (unit_owed==. & crop_code_owed!=.)  //8 observations deleted-cannot convert to kg if units are unavailable
	
	keep hhid garden_id cultivate season crop_code* qty* unit* condition* payment_period
	reshape long crop_code qty unit condition, i (hhid season garden_id payment_period cultivate) j(payment_status) string
	drop if crop_code==. //cannot estimate crop values for payments we do not have crop types for
	drop if qty==. //cannot estimate crop values for payments we do not have qty for
	duplicates drop hhid, force  //3 observation deleted 
	recast str50 hhid, force 
	merge 1:m hhid crop_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hh_crop_prices_for_wages.dta", nogen keep (1 3) //35 out of 67 matched; hh_price_mean in using data set seems high?

gen val=qty*hh_price_mean 
drop qty unit crop_code condition hh_price_mean payment_status
keep if val!=. //32 obs deleted; cannot monetize crop payments without knowing the mean hh price
tempfile plotrentbycrops
save `plotrentbycrops'


* Rainy Cash + In-Kind
	use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_b2.dta", clear
	gen cultivate = 0
	replace cultivate = 1 if ag_b214 == 1
	ren gardenid garden_id
	
	ren ag_b209a cash_rents_total
	ren ag_b209b inkind_rents_total
	ren ag_b211a cash_rents_paid
	ren ag_b211b inkind_rents_paid
	ren ag_b212 payment_period
	replace cash_rents_paid=cash_rents_total if cash_rents_paid==. & cash_rents_total!=. & payment_period==1
	ren ag_b211c cash_rents_owed
	ren ag_b211d inkind_rents_owed
	egen val = rowtotal(cash_rents_paid inkind_rents_paid cash_rents_owed inkind_rents_owed)
	gen season = 0 //"Rainy"
	keep hhid garden_id val season cult payment_period
	tempfile rainy_land_rents
	save `rainy_land_rents', replace
	
	* Dry Cash + In-Kind
	use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_i2.dta", clear 
	gen cultivate = 0
		replace cultivate = 1 if ag_i214 == 1
    ren gardenid garden_id 
	ren ag_i208a cash_rents_total
	ren ag_i208b inkind_rents_total
	ren ag_i212 payment_period
	replace payment_period=0 if payment_period==3 & (strmatch(ag_i212_oth, "DIMBA SEASON ONLY") | strmatch(ag_i212_oth, "DIMBA SEASOOY") | strmatch(ag_i212_oth, "ONLY DIMBA"))
	egen val = rowtotal( cash_rents_total inkind_rents_total)  //SS 10/23/23- No data on cash_rents_paid.
	keep hhid garden_id val cult payment_period
	gen season = 1 //"Dry"

* Combine dry + rainy + payments-by-crop
append using `rainy_land_rents'
append using `plotrentbycrops'
lab var season "season: 0=rainy, 1=dry, 2=tree crop"
label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
label values season season
gen input="plotrent"
gen exp="exp" //all rents are explicit

duplicates report hhid garden_id season
duplicates tag hhid garden_id season, gen(dups)
duplicates drop hhid garden_id season, force //27 duplicate entries
drop dups

//This chunk identifies and deletes duplicate observations across season modules where an annual payment is recorded twice
gen check=1 if payment_period==2 & val>0 & val!=.
duplicates report hhid garden_id payment_period check
duplicates tag  hhid garden_id payment_period check, gen(dups)
drop if dups>0 & check==1 & season==1 //7 obs deleted 
drop dups check

gen qty=0 //not sure if this should be . or 0 (MGM 9.12.2023: given that val is recoded to 0 in the next line, I am guessing 0)
recode val (.=0)
collapse (sum) val, by (hhid garden_id season exp input qty cultivate)
duplicates drop hhid garden_id, force //SS 2,791 observations deleted 
recast str50 hhid, force 
merge 1:m hhid garden_id using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_plot_areas.dta", keep (1 3) 
count if _m==1 & plot_id!="" & val!=. & val>0 
	drop if _m != 3 //SS 10.23.2023: 794 obs deleted
	drop _m

* Calculate quantity of plot rents etc. 
replace qty = field_size if val > 0 & val! = . //1,450 changes
keep if cultivate==1 //794 observations deleted - no need for uncultivated plots 
keep hhid plot_id garden_id season input exp val qty
tempfile plotrents
save `plotrents'	

	******************************************************
	* CHEMICALS, FERTILIZER, LAND, ANIMALS, AND MACHINES *
	******************************************************
************************ ANIMAL TRACTION (ASSET RENTAL) ******************************
use "${MWI_IHS_IHPS_W3_appended_data}/HH_MOD_M.dta", clear // reported at the household level
rename hh_m0b itemid
gen animal_traction = (itemid>=609 & itemid<=610) // MW3: Ox Plough, Ox Cart, same as MW1/2 
gen ag_asset = (itemid>=601 & itemid<= 608 | itemid>=613 & itemid <=625) // MW3=MW1=MW2: Hand hoe, slasher, axe, sprayer, panga knife, sickle, treadle pump, watering can, ridger, cultivator, generator, motor pump, grain mill, other, chicken house, livestock and poultry kraal, storage house, granary, barn, pig sty
rename hh_m14 rental_cost 
ren hh_m13 rental_qty // HKS 09.15.23: how many [item] did your hh rent or borrow
gen animal_traction_qty = rental_qty if animal_traction == 1 
gen ag_asset_qty = rental_qty if ag_asset == 1 
gen tractor = (itemid>=611 & itemid<=612) // tractor or tractor plow
gen tractor_qty = rental_qty if tractor == 1 
gen rental_cost_animal_traction = rental_cost if animal_traction==1
gen rental_cost_ag_asset = rental_cost if ag_asset==1
gen rental_cost_tractor = rental_cost if tractor==1
recode rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor (.=0)

recode *_qty (.=0) 
collapse (sum) rental_cost_animal_traction rental_cost_ag_asset rental_cost_tractor *_qty, by(hhid) // HKS 09.13.23: added rental qty
lab var rental_cost_animal_traction "Costs for renting animal traction"
lab var rental_cost_ag_asset "Costs for renting other agricultural items" 
lab var rental_cost_tractor "Costs for renting a tractor"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_asset_rental_costs.dta", replace

recast str50 hhid, force 

ren rental_cost_* val*_rent
drop rental_qty
ren *_qty qty*_rent 
reshape long val qty, i(hhid) j(var) string 
gen input = "asset_rental"
gen exp = "exp" 
tempfile asset_rental
save `asset_rental'

************************    PHYSICAL INPUTS (fert,herb,pest)   ******************************  // updated 09.07.23 by hks
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_f.dta", clear
	gen season = 0 // Rainy
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_l.dta"
	replace season = 1 if season == . // Dry

	lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season 
	
	ren ag_f0c itemcode  
	replace itemcode = ag_l0c if itemcode==. 

	* HKS 08.24.23: Note that W3 & W4 have what W1/2 call "itemcode" (specifying input type like UREA, CAN, DAP, etc) but no "codefertherb" (specifying organic fert, inorganic fert #1, inorganic fert #2, etc. So I'll create a comparable variable)
		//Type of inorganic fertilizer or Herbicide (1 = 23:21:0+4S/CHITOWE, 2 =  DAP, 3 = CAN 4 = UREA, 5 = D COMPOUND 5, 6 = Other Fertilizer, 7 = INSECTICIDE, 8 = HERBICIDE, 9 = FUMIGANT)
		// 10 = Other Pesticide or Herbicide. 17 - unknown)
	gen codefertherb = 0 if item == 0 // organic fertilizers
		replace code = 1 if inlist(item, 1,2,3,4,5,6) // inorganic fertilizers
		replace code = 2 if inlist(item, 7,9,10) // pesticide 
		replace code = 3 if inlist(item, 8) // herbicide
* HKS 09.07.23: This variable does not exist in W3
		/* replace code = 2 if strmatch(ag_f0c_oth, "2.4D") //backfill
		replace code = 3 if strmatch(ag_f0c_oth, "ROUND UP") //backfill
		replace code = 2 if strmatch(ag_l0c_oth, "DIMETHOATE") //backfill
		drop if itemcode==11 & (ag_f0c_os!="2.4D" | ag_f0c_os!="ROUND UP" | ag_l0c_os!="DIMETHOATE") // 8 obs deleted
lab var codefertherb "Code: 0 = organic
*/ 
		lab var codefertherb "Code: 0 = organic fert, 1 = inorganic fert, 2 = pesticide, 3 = herbicide"
		lab define codefertherb 0 "organic fert" 1 "inorganic fert" 2 "pesticide" 3 "herbicide"
		lab values codefertherb codefertherb	

	
*replace ag_f00b = ag_l00b if ag_f00b=="" // f00b is input description, which we don't have in W3/4
/* alt/tkk code, tweak some "others"	(for w3, f0c corresponds to f01b_oth)
replace itemcode=3 if ag_f01b_oth=="CAN" // HKS 08.24.23: 0 changes
replace itemcode=1 if ag_f01b_ot=="CHITOWE" // HKS 08.24.23: 0 changes
replace itemcode=4 if ag_f01b_o=="UREA" // HKS 08.24.23: 0 changes
replace itemcode=6 if codefertherb==101 //Just give a code here so we can match on it later. // HKS 08.24.23; codefertherb == 101 is "org fert" in our case; already has an itemcode of 0; and itemcode == 6 is taken;
*/

* For all "specify unit" variable
local qnum 07 16 26 36 38 42 
foreach q in `qnum'{
	tostring ag_f`q'b_oth, format(%19.0f) replace
	tostring ag_l`q'b_oth, format(%19.0f) replace
}

*All Source Input and Transportation Costs (Explicit)*
ren ag_f07a qtyinputexp0
replace qtyinputexp0 = ag_l07a if qtyinputexp0 ==.
ren ag_f07b unitinputexp0
replace unitinputexp0 = ag_l07b if unitinputexp0 ==. //adding dry season
ren ag_f09 valtransfertexp0 //all transportation is explicit
replace valtransfertexp0 = ag_l09 if valtransfertexp0 == .
ren ag_f10 valinputexp0
replace valinputexp0 = ag_l10 if valinputexp0 == .

*First Source Input and Transportation Costs (Explicit)*
ren ag_f16a qtyinputexp1
replace qtyinputexp1 = ag_l16a if qtyinputexp1 ==.
ren ag_f16b unitinputexp1
replace unitinputexp1 = ag_l16b if unitinputexp1 ==. //adding dry season
ren ag_f18 valtransfertexp1 //all transportation is explicit
replace valtransfertexp1 = ag_l18 if valtransfertexp1 == .
ren ag_f19 valinputexp1
replace valinputexp1 = ag_l19 if valinputexp1 == .

*Second Source Input and Transportation Costs (Explicit)*
ren ag_f26a qtyinputexp2
replace qtyinputexp2 = ag_l26a if qtyinputexp2 ==.
ren ag_f26b unitinputexp2
replace unitinputexp2 = ag_l26b if unitinputexp2 ==. //adding dry season
ren ag_f28 valtransfertexp2 //all transportation is explicit
replace valtransfertexp2 = ag_l28 if valtransfertexp2 == .
ren  ag_f29 valinputexp2
replace valinputexp2 = ag_l29 if valinputexp2 == .

*Third Source Input Costs (Explicit)* // Transportation Costs and Value of input not asked about for third source on W1 instrument, hence the need to impute these costs later provided we have itemcode code and qtym
ren ag_f36a qtyinputexp3  // Third Source
replace qtyinputexp3 = ag_l36a if qtyinputexp3 == .
ren ag_f36b unitinputexp3
replace unitinputexp3 = ag_l36b if unitinputexp3 == . //adding dry season

*Free and Left-Over Input Costs (Implicit)*
gen itemcodeinputimp1 = itemcode
ren ag_f38a qtyinputimp1  // Free input
replace qtyinputimp1 = ag_l38a if qtyinputimp1 == .
ren ag_f38b unitinputimp1
replace unitinputimp1 = ag_l38b if unitinputimp1 == . //adding dry season
ren ag_f42a qtyinputimp2 //Quantity input left
replace qtyinputimp2 = ag_l42a if qtyinputimp2 == .
ren ag_f42b unitinputimp2
replace unitinputimp2 = ag_l42b if unitinputimp2== . //adding dry season

*Free Input Source Transportation Costs (Explicit)*
ren ag_f40 valtransfertexp3 //all transportation is explicit
replace valtransfertexp3 = ag_l40 if valtransfertexp3 == .

ren ag_f07b_oth otherunitinputexp0
	replace otherunitinputexp0 = ag_f07b_oth_1 if otherunitinputexp0 == ""
		replace otherunitinputexp0 = ag_f07b_oth_2 if otherunitinputexp0 == ""
replace otherunitinputexp0=ag_l07b_o if otherunitinputexp0==""
ren ag_f16b_o otherunitinputexp1
replace otherunitinputexp1=ag_l16b_o if otherunitinputexp1==""
ren ag_f26b_o otherunitinputexp2
replace otherunitinputexp2=ag_l26b_o if otherunitinputexp2==""
ren ag_f36b_o otherunitinputexp3
replace otherunitinputexp3=ag_l36b_o if otherunitinputexp3==""
ren ag_f38b_o otherunitinputimp1
replace otherunitinputimp1=ag_l38b_o if otherunitinputimp1==""
ren ag_f42b_o otherunitinputimp2
replace otherunitinputimp2=ag_l42b_o if otherunitinputimp2==""

replace qtyinputexp1=qtyinputexp0 if (qtyinputexp0!=. & qtyinputexp1==. & qtyinputexp2==. & qtyinputexp3==.) // HKS 09.07.23: 7,954 changes
replace unitinputexp1=unitinputexp0 if (unitinputexp0!=. & unitinputexp1==. & unitinputexp2==. & unitinputexp3==.) // HKS 09.07.23: 7,890 changes
replace otherunitinputexp1=otherunitinputexp0 if (otherunitinputexp0!="" & otherunitinputexp1=="" & otherunitinputexp2=="" & otherunitinputexp3=="") // HKS 09.07.23: 60 changes
replace valtransfertexp1=valtransfertexp0 if (valtransfertexp0!=. & valtransfertexp1==. & valtransfertexp2==.) // HKS 09.07.23: 7,954 changes
replace valinputexp1=valinputexp0 if (valinputexp0!=. & valinputexp1==. & valinputexp2==.) //  HKS 09.07.23: 7,954 changes


keep qty* unit* otherunit* val* hhid itemcode codefertherb season
gen dummya = _n
unab vars : *1
local stubs : subinstr local vars "1" "", all
reshape long `stubs', i (hhid dummya itemcode codefertherb) j(entry_no)
drop entry_no
replace dummya=_n
unab vars2 : *exp
local stubs2 : subinstr local vars2 "exp" "", all
reshape long `stubs2', i(hhid dummya itemcode codefertherb) j(exp) string
replace dummya=_n
reshape long qty unit val, i(hhid exp dummya itemcode codefertherb) j(input) string
tab val if exp=="imp" & input=="transfert"
drop if strmatch(exp,"imp") & strmatch(input, "transfert") //No implicit transportation costs // HKS 09.11.23: Currently dropping 652,188 obs
drop if val < 0 // HKS 09.11.23: there are 4 obs of negative val (transfert = -99999999 )

// Converting GRAMS to KILOGRAM
replace qty = qty / 1000 if unit == 1 
// Converting 2 KG BAG to KILOGRAM
replace qty = qty * 2 if unit == 3
// Converting 3 KG BAG to KILOGRAM
replace qty = qty * 3 if unit == 4
// Converting 5 KG BAG to KILOGRAM
replace qty = qty * 5 if unit == 5
// Converting 10 KG BAG to KILOGRAM
replace qty = qty * 10 if unit == 6
// Converting 50 KG BAG to KILOGRAM
replace qty = qty * 50 if unit == 7


*CONVERTING VOLUMES TO MASS*
/*Assuming 1 BUCKET is about 20L in Malawi
Citation: Mponela, P., Villamor, G. B., Snapp, S., Tamene, L., Le, Q. B., & Borgemeister, C. (2020). The role of women empowerment and labor dependency on adoption of integrated soil fertility management in Malawi. Sustainability, 12(15), 1-11. https://doi.org/10.1111/sum.12627
*/

*ORGANIC FERTILIZER
/*Assuming bulk density of ORGANIC FERTILIZER is between 420-655 kg/m3 (midpoint 537.5kg/m3)
Citation: Khater, E. G. (2015). Some Physical and Chemical Properties of Compost. Agricultural Engineering Department, Faculty of Agriculture, Benha University, Egypt. Corresponding author: Farouk K. M. Wali, Assistant professor, Chemical technology Department, The Prince Sultan Industrial College, Saudi Arabia, Tel: +20132467034; E-mail: alsayed.khater@fagr.bu.edu.eg. Retrieved from https://www.walshmedicalmedia.com/open-access/some-physical-and-chemical-properties-of-compost-2252-5211-1000172.pdf
*/
replace qty = qty*.5375 if unit== 8 & itemcode==0 //liter
replace qty = qty/1000*.5375 if unit== 9 & itemcode==0 //milliliter
replace qty = qty*20*.5375 if unit== 10 & itemcode==0 //bucket

*CHITOWE*
/*Assuming bulk density of CHITOWE(NPK) is between 66lb/ft3 (converts to 1057.22kg/m3) based on the bulk density of YaraMila 16-16-16 by Yara North America, Inc. fertilizer available at https://www.yara.us/contentassets/280676bbae1c466799e9d22b57225584/yaramila-16-16-16-pds/
*/
replace qty = qty*1.05722 if unit== 8 & itemcode==1 //liter
replace qty = qty/1000*1.05722 if unit== 9 & itemcode==1 //milliliter
replace qty = qty*20*1.05722 if unit== 10 & itemcode==1 //bucket

*DAP*
/*Assuming bulk density of DAP is between 900-1100kg/m3 (midpoint 1000kg/m3) based on the bulk density of DAP fertlizer by Incitec Pivot Ltd. (Australia) available at https://www.incitecpivotfertilisers.com.au/~/media/Files/IPF/Documents/Fact%20Sheets/40%20Fertiliser%20Products%20Density%20and%20Sizing%20Fact%20Sheet.pdf
*/
replace qty = qty*1 if unit== 8 & itemcode==2 //liter
replace qty = qty/1000*1 if unit== 9 & itemcode==2 //milliliter
replace qty = qty*20*1 if unit== 10 & itemcode==2 //bucket

*CAN*
/*Assuming bulk density of CAN is 12.64lb/gal (converts to 1514.606kg/m3) based on the bulk density of CAN-17 by Simplot (Boise, ID) available at https://techsheets.simplot.com/Plant_Nutrients/Calcium_Ammon_Nitrate.pdf
*/
replace qty = qty*1.514606 if unit== 8 & itemcode==3 //liter
replace qty = qty/1000*1.514606 if unit== 9 & itemcode==3 //milliliter
replace qty = qty*20*1.514606 if unit== 10 & itemcode==3 //bucket

*UREA*
/*Assuming bulk density of UREA is 760kg/m3 based on the bulk density of  urea-prills by Pestell Nutrition (Canada) available at https://pestell.com/product/urea-prills/
*/
replace qty = qty*.760 if unit== 8 & itemcode==4 //liter
replace qty = qty/1000*.760 if unit== 9 & itemcode==4 //milliliter
replace qty = qty*20*.760 if unit== 10 & itemcode==4 //bucket

*D COMPOUND*
/*Assuming bulk density of D COMPOUND is approximately 1,587.30kg/m3 based on the bulk density D Compound-50kg stored in a (30cm x 50cm x 70cm) bag by E-msika (Zambia) available at www.emsika.com/product-details/54
Calculation: 50 kg stored in a (30cm x 50cm x 70cm) = 31,500cm3 (0.0315m3) bag; so 50kg/0.0315m3 or 1,587.30kg/m3
*/
replace qty = qty*1.5873 if unit== 8 & itemcode==5 //liter
replace qty = qty/1000*1.5873 if unit== 9 & itemcode==5 //milliliter
replace qty = qty*20*1.5873 if unit== 10 & itemcode==5 //bucket

*PESTICIDES AND HERBICIDES*
/*ALT: Pesticides and herbicides do not have a bulk density because they are typically sold already in liquid form, so they'd have a mass density. It depends on the concentration of the active ingredient and the presence of any adjuvants and is typically impossible to get right unless you have the specific brand name. Accordingly, EPAR currently assumes 1L=1kg, which results in a slight underestimate of herbicides and pesticides.*/
replace qty = qty*1 if unit== 8 & (codefertherb==2 | codefertherb==3) //liter
replace qty = qty/1000*1 if unit== 9 & (codefertherb==2 | codefertherb==3) //milliliter
replace qty = qty*20*1 if unit== 10 & (codefertherb==2 | codefertherb==3) //bucket

*CONVERTING WHEELBARROW AND OX-CART TO KGS*
/*Assuming 1 WHEELBARROW max load is 80 kg 
Assuming 1 OX-CART has a 800 kgs carrying capacity, though author notes that ox-carts typically carry loads far below their weight capacity, particularly for crops (where yields may not fill the cart entirely)
Citation: Wendroff, A. P. (n.d.). THE MALAWI CART: An Affordable Bicycle-Wheel Wood-Frame Handcart for Agricultural, Rural and Urban Transport Applications in Africa. Research Associate, Department of Geology, Brooklyn College / City University of New York; Director, Malawi Handcart Project. Available at: https://www.academia.edu/15078493/THE_MALAWI_CART_An_Affordable_Bicycle-Wheel_Wood-Frame_Handcart_for_Agricultural_Rural_and_Urban_Transport_Applications_in_Africa
*/
replace qty = qty*80 if unit==11
replace qty = qty*800 if unit==12

* Updating the unit for unit to "1" (to match SEEDS code) for the relevant units after conversion
replace unit = 1 if inlist(unit, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)

tab otherunit
replace qty = 1 if qty==. & (strmatch(otherunit, "TONNE")) // Assuming metric ton instead of standard conversion where 1 ton=907.185 kgs; HKS 09.07.23: 4 changes
replace unit = 1 if strmatch(otherunit, "TONNE") // HKS 09.07.23: 9 Changes
replace qty = qty*50 if strpos(otherunit, "50 KG") // HKS 09.07.23: 14 changes
replace unit = 1 if strpos(otherunit, "50 KG") // HKS 09.07.23: 18 real changes
replace qty = qty*90 if strpos(otherunit, "90 KG") // HKS 09.07.23: 1 changes
replace unit = 1 if strpos(otherunit, "90 KG") // 5 real changes
replace qty = qty*70 if strpos(otherunit, "70 KG") // HKS 09.07.23: 1 changes
replace unit = 1 if strpos(otherunit, "70 KG") // HKS 09.07.23: 1 real changes
replace qty = qty*25 if strpos(otherunit, "25 KG") // HKS 09.07.23:4 changes
replace unit = 1 if strpos(otherunit, "25 KG") // HKS 09.07.23: 8 real changes

label define inputunitrecode 1 "Kilogram", modify
label values unit inputunitrecode
tab unit //10 obs with unit = 13, other specified but no other specified units. Some of these have qty and val information but no units. Can't do anything with these I would think. Should we drop?
drop if unit==13 //11 obs dropped
drop if (qty==. | qty==0) & strmatch(input, "input") // HKS 09.11.23: 1,103,931 obs deleted - cannot impute val without qty for seeds - the raw data have a lot of missing across 1st, 2nd, and 3rd commercial input, seeds which roughly add up to >200,000 so this isn't surprising
drop if unit==. & strmatch(input, "input") // HKS 09.07.23: 42 obs deleted - cannot impute val without unit for seeds
drop if itemcode==. // HKS 09.07.23: 0 obs deleted, 33,495 of which are transfert with absolutely no data (maybe from the reshape)?
gen byte qty_missing = missing(qty) //only relevant to transfert
gen byte val_missing = missing(val)
collapse (sum) val qty, by(hhid unit itemcode codefertherb exp input qty_missing val_missing season)
replace qty =. if qty_missing
replace val =. if val_missing
drop qty_missing val_missing

//ENTER CODE HERE THAT CHANGES INPUT TO INORGFERT, ORGFERT, HERB, PEST BASED ON ITEM CODE
replace input="orgfert" if codefertherb==0 & input!="transfert"
replace input="inorgfert" if codefertherb==1 & input!="transfert"
replace input="pest" if codefertherb==2 & input!="transfert"
replace input="herb" if codefertherb==3 & input!="transfert"
replace qty=. if input=="transfert" // 4 changes
keep if qty>0 // hks 09.070.23: 695 obs deleted
replace unit=1 if unit==. //Weight, meaningless for transportation 
drop if input == "input" & itemc == 11 // HKS 09.11.12: Can't attribute expense to *either* fert or herb for "other fert/herb"; for now, drop (63 obs)
tempfile phys_inputs
save `phys_inputs'



*********************************
	* 			SEED			*
*********************************
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_h.dta", clear
gen season = 0 // rainy
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_n.dta"
replace season = 1 if season == . // dry
recast str50 hhid
lab var season "season: 0=rainy, 1=dry, 2=tree crop"
	label define season 0 "rainy" 1 "dry" 2 "tree or permanent crop"
	label values season season 
	
ren crop_code seedcode

drop if seedc == . // HKS 09.05.23: DROPS 302 OBS

* HKS 09.04.23: Note that MWI W1 has variables ending in "os", which indicates "other, specify", while other waves such as MWI W4 have variables ending in "_oth", containing the same information.
local qnum 07 16 26 36 38 42
foreach q in `qnum'{
	tostring ag_h`q'b_oth, format(%19.0f) replace
	tostring ag_n`q'b_oth, format(%19.0f) replace
}

** Filling empties from duplicative questions
* How much seed was purhcased w/o coupons etc.?
replace ag_h16a=ag_h07a if (ag_h07a!=. & ag_h16a==. & ag_h26a==. & ag_h36a==.) // HKS 09.05.23: 6,954 changes
replace ag_h16b=ag_h07b if (ag_h07b!=. & ag_h16b==. & ag_h26b==. & ag_h36b==.) //  HKS 09.05.23: 6,899 changes
replace ag_h16b_oth=ag_h07b_oth if (ag_h07b_oth!="" & ag_h16b_oth=="" & ag_h26b_oth=="" & ag_h36b_oth=="") //  HKS 09.05.23: 369 changes

*How much did you pay for transpo to acquire seed?
replace ag_h18=ag_h09 if (ag_h09!=. & ag_h18==. & ag_h28==.) // HKS 09.05.23: 6,952 changes

* Value of seed purchased? 
replace ag_h19=ag_h10 if (ag_h10!=. & ag_h19==. & ag_h29==.) // HKS 09.05.23: 6,954 changes

* Repeat for Module N
replace ag_n16a=ag_n07a if (ag_n07a!=. & ag_n16a==. & ag_n26a==. & ag_n36a==.) // HKS 09.05.23: 724 changes
replace ag_n16b=ag_n07b if (ag_n07b!=. & ag_n16b==. & ag_n26b==. & ag_n36b==.) // HKS 09.05.23: 722 changes
replace ag_n16b_oth=ag_n07b_oth if (ag_n07b_oth!="" & ag_n16b_oth=="" & ag_n26b_oth=="" & ag_n36b_oth=="") // HKS 09.05.23: 0 changes
replace ag_n18=ag_n09 if (ag_n09!=. & ag_n18==. & ag_n28==.) // HKS 09.05.23: 724 changes
replace ag_n19=ag_n10 if (ag_n10!=. & ag_n19==. & ag_n29==.) // HKS 09.05.23: 723 changes
*****

* EXPLICIT Costs: Seeds bought & Transpo costs:
	* First source
	ren ag_h16a qtyseedsexp1 // qty seeds purchased w/o coupons
	replace qtyseedsexp1 = ag_n16a if qtyseedsexp1 ==.
	ren ag_h16b unitseedsexp1
	replace unitseedsexp1 = ag_n16b if unitseedsexp1 ==. //adding dry season
	ren ag_h18 valseedtransexp1 // all transportation costs are explicit
	replace valseedtransexp1 = ag_n18 if valseedtransexp1 == .
	ren ag_h19 valseedsexp1 // value of seed purchased
	replace valseedsexp1 = ag_n19 if valseedsexp1 == .
	gen itemcodeseedsexp1 = seedcode if qtyseedsexp1!=. 

	* Second source
	ren ag_h26a qtyseedsexp2 // qty purchased w/o coupons
	replace qtyseedsexp2 = ag_n26a if qtyseedsexp2 ==.
	ren ag_h26b unitseedsexp2
	replace unitseedsexp2 = ag_n26b if unitseedsexp2 ==.
	ren ag_h28 valseedtransexp2 //all transportation is explicit
	replace valseedtransexp2 = ag_n28 if valseedtransexp2 == .
	ren  ag_h29 valseedsexp2 // value of seed purchased
	replace valseedsexp2 = ag_n29 if valseedsexp2 == .
	gen itemcodeseedsexp2 = seedcode if qtyseedsexp2!=. 

	* Third Source // Transportation Costs and Value of Seeds not asked about for third source on W4 instrument, hence the need to impute these costs later provided we have itemcode code and qtym
	ren ag_h36a qtyseedsexp3  // Third Source - qty purchased
	replace qtyseedsexp3 = ag_n36a if qtyseedsexp3 == .
	ren ag_h36b unitseedsexp3
	replace unitseedsexp3 = ag_n36b if unitseedsexp3 == . // adding Dry Season
	gen itemcodeseedsexp3 = seedcode if qtyseedsexp3!=. // hks 09.04.23: this line doesn't exist in MWI W1


	/* ALL COMMERCIAL PURCHASED SEED - commented out by MGM in W1 - 09.04.23:
	ren ag_h07a qtyseedsexp0 // qty purchased COMMERCIAL
	replace qtyseedsexp0 = ag_n07a if  qtyseedsexp0 == . 
	ren ag_h07b unitseedsexp3
	replace unitseedsexp0 = ag_n07b if  unitseedsexp0 ==. 
	ren ag_h09 valseedtransexp0 //all transportation is explicit
	replace valseedtransexp0 = ag_n09 if valseedtransexp0 == .
	ren ag_h10 valseedsexp0 // value purchased
	replace valseedsexp0 = ag_n10 if valseedsexp0 ==.
	gen itemcodeseedsexp0 = seedcode if qtyseedsexp0 != .
*/

* IMPLICIT COSTS: Free and Left Over Value:
ren ag_h42a qtyseedsimp1 // Left over seeds
replace qtyseedsimp1 = ag_n42a if qtyseedsimp1 == . 
ren ag_h42b unitseedsimp1
gen itemcodeseedsimp1 = seedcode if qtyseedsimp1!=. //Adding this to reduce the number of empties after the reshape. 
replace unitseedsimp1 = ag_n42b if unitseedsimp1== . // adding Dry Season

ren ag_h38a qtyseedsimp2  // Free seeds
replace qtyseedsimp2 = ag_n38a if qtyseedsimp2 == .
ren ag_h38b unitseedsimp2
replace unitseedsimp2 = ag_n38b if unitseedsimp2 == . // adding Dry Season
gen itemcodeseedsimp2 = seedcode if qtyseedsimp2!=.

* Free Source Transportation Costs (Explicit):
ren ag_h40 valseedtransexp3 //all transportation is explicit
replace valseedtransexp3 = ag_n40 if valseedtransexp3 == .


* Checking gaps in "other" unit variables
tab ag_h16b_oth //backfill needed W3
tab ag_n16b_oth //backfill needed W3
tab ag_h26b_oth // no obs and no need to backfilL W3
tab ag_n26b_oth //no obs and no need to backfil W3
tab ag_h36b_oth //no obs and no need to backfill W3
tab ag_n36b_oth //no obs and no need to backfill W3
tab ag_h38b_oth //backfill needed W3
tab ag_n38b_oth //backfill needed W3
tab ag_h42b_oth //backfill needed W3
tab ag_n42b_oth //backfill needed W3

**** BACKFILL CODE, EDITED TO MEET THE NEEDS OF W3
ren ag_h16b_o otherunitseedsexp1
replace otherunitseedsexp1=ag_n16b_o if otherunitseedsexp1==""
ren ag_h26b_o otherunitseedsexp2
replace otherunitseedsexp2=ag_n26b_o if otherunitseedsexp2==""
ren ag_h36b_o otherunitseedsexp3
replace otherunitseedsexp3=ag_n36b_o if otherunitseedsexp3==""
ren ag_h38b_o otherunitseedsimp1
replace otherunitseedsimp1=ag_n38b_o if otherunitseedsimp1==""
ren ag_h42b_o otherunitseedsimp2
replace otherunitseedsimp2=ag_n42b_o if otherunitseedsimp2==""

local suffix exp1 exp2 exp3 imp1 imp2
foreach s in `suffix' {
//CONVERT SPECIFIED UNITS TO KGS
replace qtyseeds`s'=qtyseeds`s'/1000 if unitseeds`s'==1
replace qtyseeds`s'=qtyseeds`s'*2 if unitseeds`s'==3
replace qtyseeds`s'=qtyseeds`s'*3 if unitseeds`s'==4
replace qtyseeds`s'=qtyseeds`s'*3.7 if unitseeds`s'==5
replace qtyseeds`s'=qtyseeds`s'*5 if unitseeds`s'==6
replace qtyseeds`s'=qtyseeds`s'*10 if unitseeds`s'==7
replace qtyseeds`s'=qtyseeds`s'*50 if unitseeds`s'==8
recode unitseeds`s' (1/8 = 1) //see below for redefining variable labels
label define unitrecode`s' 1 "Kilogram" 4 "Pail (small)" 5 "Pail (large)" 6 "No 10 Plate" 7 "No 12 Plate" 8 "Bunch" 9 "Piece" 11 "Basket (Dengu)" 120 "Packet" 210 "Stem" 260 "Cutting", modify  
label values unitseeds`s' unitrecode`s'

//REPLACE UNITS WITH O/S WHERE POSSIBLE
//Malawi instruments do not have unit codes for units like "packet" or "stem" or "bundle". Converting unit codes to align with the Malawi conversion factor file (merged in later). Also, borrowing Nigeria's unit codes for units (e.g. packets) that do not have unit codes in the Malawi instrument or conversion factor file.

* KGs 
replace unitseeds`s'=1 if strmatch(otherunitseeds`s', "MG") 
replace qtyseeds`s'=qtyseeds`s'/1000000 if strmatch(otherunitseeds`s', "MG") 
replace unitseeds`s'=1 if strmatch(otherunitseeds`s', "20 KG BAG")
replace qtyseeds`s'=qtyseeds`s'*20 if strmatch(otherunitseeds`s', "20 KG BAG")
replace unitseeds`s'=1 if strmatch(otherunitseeds`s', "2.5 KG")
replace qtyseeds`s'=qtyseeds`s'*2.5 if strmatch(otherunitseeds`s', "2.5 KG")
replace unitseeds`s'=1 if strmatch(otherunitseeds`s', "5.5KG")
replace qtyseeds`s'=qtyseeds`s'*5.5 if strmatch(otherunitseeds`s', "5.5KG")

replace unitseeds`s'=1 if strmatch(otherunitseeds`s', "25 KG BAG")
replace qtyseeds`s'=qtyseeds`s'*25 if strmatch(otherunitseeds`s', "25 KG BAG")
replace unitseeds`s'=1 if strpos(otherunitseeds`s', "50 KG") | strpos(otherunitseeds`s', "50KG") // edited
replace qtyseeds`s'=qtyseeds`s'*50 if strpos(otherunitseeds`s', "50 KG") | strpos(otherunitseeds`s', "50KG") //edited
replace unitseeds`s'=1 if strpos(otherunitseeds`s', "70 KG") | strpos(otherunitseeds`s', "70KG") // added
replace qtyseeds`s'=qtyseeds`s'*50 if strpos(otherunitseeds`s', "70 KG") | strpos(otherunitseeds`s', "70KG") //added
replace unitseeds`s'=1 if strpos(otherunitseeds`s', "90 KG") | strpos(otherunitseeds`s', "90KG") //edited
replace qtyseeds`s'=qtyseeds`s'*90 if strpos(otherunitseeds`s', "90 KG") | strpos(otherunitseeds`s', "90KG") //edited
replace unitseeds`s'=1 if strpos(otherunitseeds`s', "100KG") | strpos(otherunitseeds`s', "100 KG")  //edited
replace qtyseeds`s'=qtyseeds`s'*100 if strpos(otherunitseeds`s', "100KG") | strpos(otherunitseeds`s', "100 KG")  //edited
replace unitseeds`s'=1 if strpos(otherunitseeds`s', "100G") | strpos(otherunitseeds`s', "8 GRAM") // edited: grams
replace qtyseeds`s'=(qtyseeds`s'/1000)*100 if strpos(otherunitseeds`s', "100KG") //edited
replace qtyseeds`s'=(qtyseeds`s'/1000)*8 if strpos(otherunitseeds`s', "8 GRAM") //edited
replace unitseeds`s'=1 if strmatch(otherunitseeds`s', "GRAMS") // edited: grams
replace qtyseeds`s'=(qtyseeds`s'/1000) if strmatch(otherunitseeds`s', "GRAMS") //edited

* Pails
replace unitseeds`s'=4 if strpos(otherunitseeds`s', "PAIL") // Edited: contains pail (any size)
replace unitseeds`s'=5 if strpos(otherunitseeds`s', "PAIL") & (strpos(otherunitseeds`s', "BIG") | strpos(otherunitseeds`s', "LARGE")) // Edited: big/large pails
replace qtyseeds`s'=qtyseeds`s'*2 if strmatch(otherunitseeds`s', "2X LARGE PAIL")

* Plates
replace unitseeds`s'=6 if (strpos(otherunitseeds`s', "PLATE")  | strpos(otherunitseeds`s', "10 PLATE") | strpos(otherunitseeds`s', "10PLATE")) & !strpos(otherunitseeds`s', "KG") // Edited: 10 plate
replace qtyseeds`s'=qtyseeds`s'*2 if strmatch(otherunitseeds`s', "2 NO 10 PLATES")
replace unitseeds`s'=7 if strpos(otherunitseeds`s', "12 PLATE")  | strpos(otherunitseeds`s', "12PLATE") // edited: 12 plate

* Pieces & Bundles 
replace unitseeds`s'=9 if strpos(otherunitseeds`s', "PIECE") | strpos(otherunitseeds`s', "PIECES") | strpos(otherunitseeds`s', "STEMS") | strmatch(otherunitseeds`s', "CUTTINGS") | strmatch(otherunitseeds`s', "BUNDLES") | strmatch(otherunitseeds`s', "MTOLO UMODZI WA BATATA") //"motolo umodzi" translates to bundles and a standard bundle is 100 stems
replace qtyseeds`s'=qtyseeds`s'*100 if strmatch(otherunitseeds`s', "BUNDLES") | strmatch(otherunitseeds`s', "MTOLO UMODZI WA BATATA")

* Dengu
replace unitseeds`s'=11 if strmatch(otherunitseeds`s', "DENGU") 

* Packet
replace unitseeds`s'=120 if strpos(otherunitseeds`s', "PACKET") //edited
replace qtyseeds`s'=qtyseeds`s'*2 if strmatch(otherunitseeds`s', "2 PACKETS")
* HKS 09.04.23: For now, ignoring units of teaspoon and tablespoon because bulk densisites can vary seed to seed and there isn't a clear conversion factor (not in database)

* HKS 09.05.23: ADDITIONAL UNITS OF INTEREST THAT ARE NOT LISTED IN THE "FINAL AMENDED IHS AGRICULTURAL CONVERSION FACTOR DATABASE" (yet)
* NO 24 Plate
* chikang'a
}


keep item* qty* unit* val* hhid /*ALT*/ season seed
gen dummya = _n //creates a unique number for every observation as hhid is not unique among all observations 
unab vars : *1
local stubs : subinstr local vars "1" "", all
reshape long `stubs', i (hhid /*season*/ dummya) j(entry_no) // HKS 09.04.23: MWI W1 does not include season; do we expect seed values to not vary season to season? Probably not, and many seeds can only be planted in one season
drop entry_no
replace dummya = _n
unab vars2 : *exp
local stubs2 : subinstr local vars2 "exp" "", all
drop if qtyseedsexp==. & valseedsexp==. //we're dropping if both values are missing 
reshape long `stubs2', i(hhid /*season*/ dummya) j(exp) string
replace dummya=_n
reshape long qty unit val itemcode, i(hhid /*season*/ exp dummya) j(input) string
drop if strmatch(exp,"imp") & strmatch(input,"seedtrans") //No implicit transportation costs; all transporatation cost are explicit 
//ALT: Crop recode not necessary for seed expenses.

/*gen crop_code_full = itemcode 
recode crop_code_full (1/4 = 1) (5/7 10 = 2) (11/16 = 3) (17/23 25/26 = 4) (27 = 5) (28 = 6) (29 = 7) (31 = 8) (32 = 9) (33 = 10) (34 = 11) (35 = 12) (36 = 13) (37 = 14) (38 = 15) (39 = 16) (40 = 17) (41 = 18) (42 = 19) (43 = 20) (44 = 21) (45 = 22) (46 = 23) (47 = 24) (48 = 25) */

label define unitrecode 1 "Kilogram" 4 "Pail (small)" 5 "Pail (large)" 6 "No 10 Plate" 7 "No 12 Plate" 8 "Bunch" 9 "Piece" 11 "Basket (Dengu)" 120 "Packet" 210 "Stem" 260 "Cutting", modify
label values unit unitrecode

drop if (qty==. | qty==0) & strmatch(input, "seeds") // HKS 09.05.23: 9,364 obs deleted - cannot impute val without qty for seeds; for the variable input; where any observations have equal seeds 
drop if unit==. & strmatch(input, "seeds") // 2 obs deleted - cannot impute val without unit for seeds
gen byte qty_missing = missing(qty) //only relevant to seedtrans
gen byte val_missing = missing(val)
collapse (sum) val qty, by(hhid unit seedcode exp input qty_missing val_missing season)
replace qty =. if qty_missing
replace val =. if val_missing
drop qty_missing val_missing

ren seedcode crop_code
drop if crop_code==. & strmatch(input, "seeds") // 0 obs deleted
gen condition=1 
replace condition=3 if inlist(crop_code, 5, 6, 7, 8, 10, 28, 29, 30, 31, 32, 33, 37, 39, 40, 41, 42, 43, 44, 45, 47) // X real changes //these are crops for which the cf file only has entries with condition as N/A
recode crop_code (1 2 3 4=1)(5 6 7 8 9 10=5)(11 12 13 14 15 16=11)(17 18 19 20 21 22 23 24 25 26=17)
rename crop_code crop_code_short
recast str50 hhid, force 
*ren TA ta
merge m:1 hhid using  "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhsize.dta", keepusing (region district ta ea) nogen keep(1 3) // hks 09.04.23: dropping unmatched from using
* hks 09.04.23: cropied over the FINAL AMENDED IHS AG CONV FACTOR DATABASE FILE (below) from MWI W1; MGM created this amended version temporarily; working on further filling in!
merge m:1 crop_code_short unit condition region using "${MWI_IHS_IHPS_W3_created_data}/Final Amended IHS Agricultural Conversion Factor Database.dta", keep (1 3) // HKS 09.05.23: 10,446 not matched.  9,549 of these obs are seedtrans, hence the non-matching. Remaining 897 unsure why not matching;
replace qty=. if input=="seedtrans" //0 changes, seedtrans must already have blanks for qty on all observations
keep if qty>0 //0 obs deleted

//This chunk ensures that conversion factors did not get used for planted-as-seed crops where the conversion factor weights only work for planted-as-harvested crops
replace conversion =. if inlist(crop_code, 5-8, 10, 28-29, 37, 39-45, 47) // HKS 09.05.23: 196 real changes 

replace unit=1 if unit==. //Weight, meaningless for transportation 
replace conversion = 1 if unit==1 //conversion factor converts everything in kgs so if kg is the unit, cf is 1
replace conversion = 1 if unit==9 //if unit is piece, we use conversion factor of 1 but maintain unit name as "piece"/unitcode #9
replace qty=qty*conversion if conversion!=.
/*By converting smaller units (e.g. grams, packets, bunches, etc.) into kgs and then imputing values (see end of crop expenses) for these observations where val is missing, we are underestimating the true value of smaller quantities of seeds. For example, seeds are more 
ren crop_code_short itemcode*/
rename crop_code itemcode
drop _m
tempfile seeds
save `seeds'


********************************
*** HKS 08.23.23, copied from MWI W4 (originally NGA W3) for use in MONOCROPPED PLOTS below
*** Combining rents and getting prices
*****
*** Plot Level files: plot_rents ONLY as of 08.25.23

use `plotrents', clear
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_cost_per_plot.dta", replace

recast str50 hhid, force 
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_weights.dta",gen(weights) keep(1 3) keepusing(weight region district ea ta) // added geo vars here to avoid having to merge in later using a diff file
* 08.24.23
merge m:1 hhid garden_id plot_id season using "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_plot_areas.dta", gen(plotareas) keep(1 3) keepusing(field_size) 
merge m:1 hhid garden_id plot_id using "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_plot_decision_makers.dta", gen(dms) keep(1 3) keepusing(dm_gender) 
gen plotweight = weight*field_size 
tempfile all_plot_inputs
save `all_plot_inputs', replace

* Calculating Geographic Medians for PLOT LEVEL files
	keep if strmatch(exp,"exp") & qty!=. 
	recode val (0=.)
	gen price = val/qty
	drop if price==. 
	gen obs=1

	* HKS 08.25.23: I dropped "unit" and "itemcode" from all of these loops bc we don't have them anymore (since phys inputs is not at plot level)
	capture restore,not 
	foreach i in ea ta district region hhid {
	preserve
		bys `i' input : egen obs_`i' = sum(obs)
		collapse (median) price_`i'=price [aw=plotweight], by (`i' input obs_`i')
		tempfile price_`i'_median
		save `price_`i'_median'
	restore
	}

	preserve
	bys input : egen obs_country = sum(obs)
	collapse (median) price_country = price [aw=plotweight], by(input  obs_country)
	tempfile price_country_median
	save `price_country_median'
	restore

	use `all_plot_inputs',clear
	foreach i in ea ta district region hhid {
		merge m:1 `i' input using `price_`i'_median', nogen keep(1 3) 
	}
		merge m:1 input using `price_country_median', nogen keep(1 3)
		recode price_hhid (.=0)
		gen price=price_hhid
	foreach i in country region district ta ea  {
		replace price = price_`i' if obs_`i' > 9 & obs_`i'!=.
	}
	
	
//Default to household prices when available
replace price = price_hhid if price_hhid>0
replace qty = 0 if qty <0 
recode val qty (.=0)
drop if val==0 & qty==0 
replace val=qty*price if val==0


* For PLOT LEVEL data, add in plot_labor data
append using "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_plot_labor.dta" // hks 08.25.23: many empty garden, plot, dm_genders (where val == 0)
drop if garden == "" & plot_ == "" // HKS: as per discussion with ALT on 08.31.23; 2 obs dropped
collapse (sum) val, by (hhid plot_id garden exp input dm_gender season) 


* Save PLOT-LEVEL Crop Expenses (long)
	save "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_plot_cost_inputs_long.dta",replace 

* Save PLOT-Level Crop Expenses (wide, does not currently get used in MWI W4 code)
preserve
	collapse (sum) val_=val, by(hhid plot_id garden exp dm_gender season)
	reshape wide val_, i(hhid plot_id garden dm_gender season) j(exp) string 
	save "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_plot_cost_inputs.dta", replace // HKS 08.21.23 (mwi w4): This used to get used below in CROP EXPENSES - currently commented out, we'll see if it gets revived
restore

* HKS 08.25.23: Aggregate PLOT-LEVEL crop expenses data up to HH level and append to HH LEVEL data.	
preserve
use "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_plot_cost_inputs_long.dta", clear
	collapse (sum) val, by(hhid exp input)
	tempfile plot_to_hh_cropexpenses
	save `plot_to_hh_cropexpenses', replace
restore


********
*** HH LEVEL Files: seed, asset_rental, phys inputs
use `seeds', clear
	append using `asset_rental'
	append using `phys_inputs' // 08.31.23: ALT says we can drop from price imputation
	recast str50 hhid, force
	merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_weights.dta", nogen keep(1 3) keepusing(weight region district ea ta) // merge in hh weight & geo data 
tempfile all_HH_LEVEL_inputs
save `all_HH_LEVEL_inputs', replace
	

* Calculating Geographic Medians for HH LEVEL files
	keep if strmatch(exp,"exp") & qty!=. 
	recode val (0=.)
	drop if unit==0 //Remove things with unknown units.
	gen price = val/qty
	drop if price==.
	gen obs=1

	* HKS 08.28.23: Plotweight has been changed to aw = qty*weight (where weight is population weight), as per discussion with ALT
	capture restore,not 
	foreach i in ea ta district region hhid {
	preserve
		bys `i' input unit itemcode : egen obs_`i' = sum(obs)
		collapse (median) price_`i'=price  [aw = (qty*weight)], by (`i' input unit itemcode obs_`i') 
		tempfile price_`i'_median
		save `price_`i'_median'
	restore
	}

	preserve
	bys input unit itemcode : egen obs_country = sum(obs)
	collapse (median) price_country = price  [aw = (qty*weight)], by(input unit itemcode obs_country)
	tempfile price_country_median
	save `price_country_median'
	restore

	use `all_HH_LEVEL_inputs', clear
	foreach i in ea ta district region hhid {
		merge m:1 `i' input unit itemcode using `price_`i'_median', nogen keep(1 3) 
	}
		merge m:1 input unit itemcode using `price_country_median', nogen keep(1 3)
		recode price_hhid (.=0)
		gen price=price_hhid
	foreach i in country region district ta ea  {
		replace price = price_`i' if obs_`i' > 9 & obs_`i'!=.
	}
	
	
//Default to household prices when available
replace price = price_hhid if price_hhid>0
replace qty = 0 if qty <0 // Remove any households reporting negative quantities of fertilizer.
recode val qty (.=0)
drop if val==0 & qty==0 //Dropping unnecessary observations.
replace val=qty*price if val==0
replace input = "orgfert" if itemcode==5
replace input = "inorg" if strmatch(input,"fert")

*  HKS 09.14.23: Amend input names to match those of NGA data (GH ISSUE #45)
replace input = "anml" if strpos(input, "animal_tract") 
replace input = "inorg" if strpos(input, "inorg")
replace input = "seed" if strpos(input, "seed")
replace input = "mech" if strpos(input, "ag_asset") | strpos(input, "tractor") | strpos(input, "asset_rent") // double check that ag_asset is basically just mechanized tools


* Add geo variables // hks 09.15.23:
   merge m:1 hhid  using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta", nogen keepusing(ta ea district region)
   capture ren TA ta
   capture ren ea ea_id

preserve
	keep if strpos(input,"orgfert") | strpos(input,"inorg") | strpos(input,"herb") | strpos(input,"pest")
	//Unfortunately we have to compress liters and kg here, which isn't ideal.
	collapse (sum) qty_=qty, by(hhid /*plot_id garden*/ ta ea district region input season) // hks 09.14.23: season added as per MGM/ALT
	reshape wide qty_, i(hhid ta ea district region /*plot_id garden*/ season) j(input) string // hks 09.14.23: season added as per MGM/ALT
	ren qty_inorg inorg_fert_rate
	ren qty_orgfert org_fert_rate
	ren qty_herb herb_rate
	*ren qty_pestherb pestherb_rate
	ren qty_pest pest_rate
	la var inorg_fert_rate "Qty inorganic fertilizer used (kg)"
	la var org_fert_rate "Qty organic fertilizer used (kg)"
	la var herb_rate "Qty of herbicide used (kg/L)"
	la var pest_rate "Qty of pesticide used (kg/L)"
	*la var pestherb_rate "Qty of pesticide/herbicide used (kg/L)"

	save "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_input_quantities.dta", replace
restore	
	
* Save HH-LEVEL Crop Expenses (long)
preserve
collapse (sum) val qty, by(hhid exp input season ta ea district region) 
save "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_hh_cost_inputs_long.dta", replace // HKS 08.21.23: This version does not get used later in the code (the wide version doesn't either)
restore

* COMBINE HH-LEVEL crop expenses (long) with PLOT level data (long) aggregated up to HH LEVEL & re-aggregate them together (hks 08.21.23):
use "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_hh_cost_inputs_long.dta", clear
	append using `plot_to_hh_cropexpenses'
	collapse (sum) val qty, by(hhid exp input season) // hks 09.14.23: season added as per MGM/ALT
	merge m:1 hhid  using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta", nogen keepusing(ta ea district region)
	capture ren (TA ea) (ta ea_id)
	
	save "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_hh_cost_inputs_long_complete.dta", replace
	
	
	
********************************************************************************
* MONOCROPPED PLOTS *
********************************************************************************
use "${MWI_IHS_IHPS_W3_created_data}/Malawi_W3_all_plots.dta",clear 
	keep if purestand==1   
	save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_monocrop_plots.dta", replace

use "${MWI_IHS_IHPS_W3_created_data}/Malawi_W3_all_plots.dta",clear
	keep if purestand == 1 // hks 08.23.23: added from w4
	merge m:1  hhid garden_id plot_id using  "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
	ren ha_planted monocrop_ha
	ren quant_harv_kg kgs_harv_mono
	ren value_harvest val_harv_mono
	collapse (sum) *mono*, by(hhid garden_id plot_id crop_code_short dm_gender)
	
	
forvalues k=1(1)$nb_topcrops  {		
preserve	
	local c : word `k' of $topcrop_area
	local cn : word `k' of $topcropname_area
	local cn_full : word `k' of $topcropname_area_full
	count if crop_code==`c'
	if `r(N)'!=0 {
	keep if crop_code==`c'
	ren monocrop_ha `cn'_monocrop_ha
	count if `cn'_monocrop_ha!=0
	if `r(N)'!=0 {
	drop if `cn'_monocrop_ha==0 		
	ren kgs_harv_mono kgs_harv_mono_`cn'
	ren val_harv_mono val_harv_mono_`cn'
	gen `cn'_monocrop=1
	la var `cn'_monocrop "HH grows `cn_full' on a monocropped plot"
	save "${MWI_IHS_IHPS_W3_created_data}\Malawi_IHS_W3_`cn'_monocrop.dta", replace
	
	
	foreach i in `cn'_monocrop_ha kgs_harv_mono_`cn' val_harv_mono_`cn' `cn'_monocrop { 
		gen `i'_male = `i' if dm_gender==1
		gen `i'_female = `i' if dm_gender==2
		gen `i'_mixed = `i' if dm_gender==3 //MGM MWI may not be creating dm_gender==3 for mixed right now. Do we want to add this?
	}


	collapse (sum) *monocrop_ha* kgs_harv_mono* val_harv_mono* (max) `cn'_monocrop `cn'_monocrop_male `cn'_monocrop_female `cn'_monocrop_mixed, by(hhid) // hks 08.23.23: does not exist in current MWI version as per w4
	la var `cn'_monocrop_ha "Total `cn' monocrop hectares - Household"
	la var `cn'_monocrop "Household has at least one `cn' monocrop"
	la var kgs_harv_mono_`cn' "Total kilograms of `cn' harvested - Household"
	la var val_harv_mono_`cn' "Value of harvested `cn' (MWK)"
	
	foreach g in male female mixed {		
		la var `cn'_monocrop_ha_`g' "Total `cn' monocrop hectares on `g' managed plots - Household"
		la var kgs_harv_mono_`cn'_`g' "Total kilograms of `cn' harvested on `g' managed plots - Household"
		la var val_harv_mono_`cn'_`g' "Total value of `cn' harvested on `g' managed plots - Household"
	}
		//collapse (sum) *monocrop* kgs_harv* val_harv*, by(hhid) 
	save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_`cn'_monocrop_hh_area.dta", replace
**# Bookmark #1
	}
	}
restore
}	

use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_plot_cost_inputs_long.dta", clear 
merge m:1 hhid garden_id plot_id using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_plot_decision_makers.dta", nogen keep(1 3) keepusing(dm_gender)
collapse (sum) val, by(hhid garden_id plot_id dm_gender input)
levelsof input, clean l(input_names)
ren val val_
	reshape wide val_, i(hhid garden_id plot_id dm_gender) j(input) string
	//ren val* val*_`cn'_
	gen dm_gender2 = "male" if dm_gender==1
	replace dm_gender2 = "female" if dm_gender==2
	replace dm_gender2 = "mixed" if dm_gender==3
	replace dm_gender2 = "unknown" if dm_gender==. 
	drop dm_gender 
	

	foreach cn in $topcropname_area {
preserve
	//keep if strmatch(exp, "exp")
	//drop exp
capture confirm file "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_`cn'_monocrop.dta"
	if !_rc {
	ren val* val*_`cn'_
	reshape wide val*, i(hhid garden_id plot_id) j(dm_gender2) string
	merge 1:1 hhid garden_id plot_id using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_`cn'_monocrop.dta", nogen keep(3)
	count
	if(r(N) > 0){
	collapse (sum) val*, by(hhid)
	foreach i in `input_names' {
		egen val_`i'_`cn'_hh = rowtotal(val_`i'_`cn'_male val_`i'_`cn'_female val_`i'_`cn'_mixed)
	}
	//To do: labels
	save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_inputs_`cn'.dta", replace
	}
	}
restore
}	
drop if plot_id==""

*****************
*LIVESTOCK INCOME - RH Complete 7/29; HI checked 5/2/22 - needs review
*****************

*Expenses - complete 7/20 
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_R2.dta", clear
rename ag_r26 cost_fodder_livestock       /* VAP: MW2 has no separate cost_water_livestock - same with W3*/
rename ag_r27 cost_vaccines_livestock     /* Includes medicines */
rename ag_r28 cost_othervet_livestock     /* VAP: TZ didn't have this. Includes dipping, deworming, AI */
gen cost_medical_livestock = cost_vaccines_livestock + cost_othervet_livestock /* VAP: Combining the two categories for later. */
rename ag_r25 cost_hired_labor_livestock 
rename ag_r29 cost_input_livestock        /* VAP: TZ didn't have this. Includes housing equipment, feeding utensils */
recode cost_fodder_livestock cost_vaccines_livestock cost_othervet_livestock cost_medical_livestock cost_hired_labor_livestock cost_input_livestock(.=0)

collapse (sum) cost_fodder_livestock cost_vaccines_livestock cost_othervet_livestock  cost_hired_labor_livestock cost_input_livestock, by (hhid)
lab var cost_fodder_livestock "Cost for fodder for <livestock>"
lab var cost_vaccines_livestock "Cost for vaccines and veterinary treatment for <livestock>"
lab var cost_othervet_livestock "Cost for other veterinary treatments for <livestock> (incl. dipping, deworming, AI)"
lab var cost_hired_labor_livestock "Cost for hired labor for <livestock>"
lab var cost_input_livestock "Cost for livestock inputs (incl. housing, equipment, feeding utensils)"
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_livestock_expenses.dta", replace

//since can't disaggregate by species cannot create the following: 
//lrum_expenses; expenses_animal
//- old code preserved in W2

*Livestock products 
* Milk - RH complete 7/21 (question)
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_s.dta", clear
rename ag_s0a livestock_code
keep if livestock_code==401
rename ag_s02 no_of_months_milk // VAP: During the last 12 months, for how many months did your household produce any [PRODUCT]?
rename ag_s03a qty_milk_per_month // VAP: During these months, what was the average quantity of [PRODUCT] produced PER MONTH?. 
gen milk_liters_produced = no_of_months_milk * qty_milk_per_month if ag_s03b==1 // VAP: Only including liters, not including 2 obsns in "buckets". 
lab var milk_liters_produced "Liters of milk produced in past 12 months"

gen liters_sold_12m = ag_s05a if ag_s05b==1 // VAP: Keeping only units in liters
rename ag_s06 earnings_milk_year
gen price_per_liter = earnings_milk_year/liters_sold_12m if liters_sold_12m > 0
gen price_per_unit = price_per_liter // RH: why do we need per liter and per unit if the same?
gen quantity_produced = milk_liters_produced
recode price_per_liter price_per_unit (0=.) //RH Question: is turning 0s to missing on purpose? Or is this backwards? 
keep hhid livestock_code milk_liters_produced price_per_liter price_per_unit quantity_produced earnings_milk_year //why do we need both per liter and per unit if the same?
lab var price_per_liter "Price of milk per liter sold"
lab var price_per_unit "Price of milk per unit sold" 
lab var quantity_produced "Quantity of milk produced"
lab var earnings_milk_year "Total earnings of sale of milk produced"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_products_milk", replace	
					
* Other livestock products  // VAP: Includes milk, eggs, meat, hides/skins and manure. No honey in MW2. TZ does not have meat and manure. - RH complete 7/29
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_S.dta", clear
rename ag_s0a livestock_code
rename ag_s02 months_produced
rename ag_s03a quantity_month
rename ag_s03b quantity_month_unit					

drop if livestock_code == 401 //RH edit. Removing milk from "other" dta, will be added back in for all livestock products file
replace quantity_month = round(quantity_month/0.06) if livestock_code==402 & quantity_month_unit==2 // VAP: converting obsns in kgs to pieces for eggs 
// using MW IHS Food Conversion factors.pdf. Cannot convert ox-cart & ltrs. 
replace quantity_month_unit = 3 if livestock_code== 402 & quantity_month_unit==2
replace quantity_month_unit =. if livestock_code==402 & quantity_month_unit!=3        // VAP: chicken eggs, pieces
replace quantity_month_unit =. if livestock_code== 403 & quantity_month_unit!=3      // guinea fowl eggs, pieces
replace quantity_month = quantity_month*1.5 if livestock_code==404 & quantity_month_unit==3 // VAP: converting pieces to kgs for meat, 
// using conversion for chicken. Cannot convert ltrs & buckets.  
replace quantity_month_unit = 2 if livestock_code== 404 & quantity_month_unit==3
replace quantity_month_unit =. if livestock_code==404 & quantity_month_unit!=2     // VAP: now, only keeping kgs for meat
replace quantity_month_unit =. if livestock_code== 406 & quantity_month_unit!=3   // VAP: skin and hide, pieces. Not converting kg and bucket.
replace quantity_month_unit =. if livestock_code== 407 & quantity_month_unit!=2 // VAP: manure, using only obsns in kgs. 
// This is a bigger problem, as there are many obsns in bucket, wheelbarrow & ox-cart but no conversion factors.
recode months_produced quantity_month (.=0) 
gen quantity_produced = months_produced * quantity_month // Units are liters for milk, pieces for eggs & skin, kg for meat and manure. (RH Note: only showing values for chicken eggs - is that correct?) ALSO, double check if "other" (408) has quantity produced values
lab var quantity_produced "Quantity of this product produced in past year"

rename ag_s05a sales_quantity
rename ag_s05b sales_unit
*replace sales_unit =. if livestock_code==401 & sales_unit!=1 // milk, liters only
replace sales_unit =. if livestock_code==402 & sales_unit!=3  // chicken eggs, pieces only
replace sales_unit =. if livestock_code== 403 & sales_unit!=3   // guinea fowl eggs, pieces only
replace sales_quantity = sales_quantity*1.5 if livestock_code==404 & sales_unit==3 // VAP: converting obsns in pieces to kgs for meat. Using conversion for chicken. 
replace sales_unit = 2 if livestock_code== 404 & sales_unit==3 // VAP: kgs for meat
replace sales_unit =. if livestock_code== 406 & sales_unit!=3   // VAP: pieces for skin and hide, not converting kg (1 obsn).
replace sales_unit =. if livestock_code== 407 & quantity_month_unit!=2  // VAP: kgs for manure, not converting liters(1 obsn), bucket, wheelbarrow & oxcart (2 obsns each)

rename ag_s06 earnings_sales
recode sales_quantity months_produced quantity_month earnings_sales (.=0)
gen price_per_unit = earnings_sales / sales_quantity
keep hhid livestock_code quantity_produced price_per_unit earnings_sales

label define livestock_code_label 402 "Chicken Eggs" 403 "Guinea Fowl Eggs" 404 "Meat" 406 "Skin/Hide" 407 "Manure" 408 "Other" //RH - added "other" lbl to 408, removed 401 "Milk"
label values livestock_code livestock_code_label
bys livestock_code: sum price_per_unit
gen price_per_unit_hh = price_per_unit
lab var price_per_unit "Price per unit sold"
lab var price_per_unit_hh "Price per unit sold at household level"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_products_other", replace

*All Livestock Products
use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_products_milk", clear
append using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_products_other"
recode price_per_unit (0=.)
recast str50 hhid, force 
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta" //RH note: why is w3 missing stratum, weight, TA in HHID?
drop if _merge==2
drop _merge
replace price_per_unit = . if price_per_unit == 0 
lab var price_per_unit "Price per unit sold"
lab var quantity_produced "Quantity of product produced"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_products", replace
					
* EA Level
use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_products", clear
keep if price_per_unit !=. 
gen observation = 1
bys region district ta ea_id livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district ta ea_id livestock_code obs_ea)
rename price_per_unit price_median_ea
lab var price_median_ea "Median price per unit for this livestock product in the ea"
lab var obs_ea "Number of sales observations for this livestock product in the ea"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_products_prices_ea.dta", replace

* TA Level
use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district ta livestock_code: egen obs_ta = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district ta livestock_code obs_ta)
rename price_per_unit price_median_ta
lab var price_median_ta "Median price per unit for this livestock product in the ta"
lab var obs_ta "Number of sales observations for this livestock product in the ta"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_products_prices_ta.dta", replace 

* District Level
use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_unit [aw=weight], by (region district livestock_code obs_district)
rename price_per_unit price_median_district
lab var price_median_district "Median price per unit for this livestock product in the district"
lab var obs_district "Number of sales observations for this livestock product in the district"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_products_prices_district.dta", replace

* Region Level
use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_unit [aw=weight], by (region livestock_code obs_region)
rename price_per_unit price_median_region
lab var price_median_region "Median price per unit for this livestock product in the region"
lab var obs_region "Number of sales observations for this livestock product in the region"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_products_prices_region.dta", replace

* Country Level
use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_products", clear
keep if price_per_unit !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_unit [aw=weight], by (livestock_code obs_country)
rename price_per_unit price_median_country
lab var price_median_country "Median price per unit for this livestock product in the country"
lab var obs_country "Number of sales observations for this livestock product in the country"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_products_prices_country.dta", replace

use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_products", clear
merge m:1 region district ta ea_id livestock_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_products_prices_ea.dta", nogen
merge m:1 region district ta livestock_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_products_prices_ta.dta", nogen
merge m:1 region district livestock_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_products_prices_district.dta", nogen
merge m:1 region livestock_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_products_prices_region.dta", nogen
merge m:1 livestock_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_products_prices_country.dta", nogen
replace price_per_unit = price_median_ea if price_per_unit==. & obs_ea >= 10
replace price_per_unit = price_median_ta if price_per_unit==. & obs_ta >= 10
replace price_per_unit = price_median_district if price_per_unit==. & obs_district >= 10 
replace price_per_unit = price_median_region if price_per_unit==. & obs_region >= 10 
replace price_per_unit = price_median_country if price_per_unit==.
lab var price_per_unit "Price per unit of this livestock product, with missing values imputed using local median values" 

gen value_milk_produced = milk_liters_produced * price_per_unit 
gen value_eggs_produced = quantity_produced * price_per_unit if livestock_code==402|livestock_code==403
gen value_other_produced = quantity_produced * price_per_unit if livestock_code== 404|livestock_code==406|livestock_code==407|livestock_code==408
egen sales_livestock_products = rowtotal(earnings_sales earnings_milk_year)		
collapse (sum) value_milk_produced value_eggs_produced value_other_produced sales_livestock_products, by (hhid)

*First, constructing total value
egen value_livestock_products = rowtotal(value_milk_produced value_eggs_produced value_other_produced)
lab var value_livestock_products "value of livestock prodcuts produced (milk, eggs, other)"
*Now, the share
gen share_livestock_prod_sold = sales_livestock_products/value_livestock_products
replace share_livestock_prod_sold = 1 if share_livestock_prod_sold>1 & share_livestock_prod_sold!=.
lab var share_livestock_prod_sold "Percent of production of livestock products that is sold" 
lab var value_milk_produced "Value of milk produced"
lab var value_eggs_produced "Value of eggs produced"
lab var value_other_produced "Value of skins, meat and manure produced"
recode value_milk_produced value_eggs_produced value_other_produced (0=.)
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hh_livestock_products", replace // RH complete

* Manure (Dung in TZ)
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_S.dta", clear
rename ag_s0a livestock_code
rename ag_s06 earnings_sales
gen sales_manure=earnings_sales if livestock_code==407 
recode sales_manure (.=0)
collapse (sum) sales_manure, by (hhid)
lab var sales_manure "Value of manure sold" 
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_manure.dta", replace // RH complete

*Sales (live animals)
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_R1.dta", clear
rename ag_r0a livestock_code
rename ag_r17 income_live_sales     // total value of sales of [livestock] live animals last 12m -- RH note, w3 label doesn't include "during last 12m"
rename ag_r16 number_sold          // # animals sold alive last 12 m
rename ag_r19 number_slaughtered  // # animals slaughtered last 12 m 
/* VAP: not available in MW2 or w3
rename lf02_32 number_slaughtered_sold  // # of slaughtered animals sold
replace number_slaughtered = number_slaughtered_sold if number_slaughtered < number_slaughtered_sold  
rename lf02_33 income_slaughtered // # total value of sales of slaughtered animals last 12m
*/
//rename ag_r13 value_livestock_purchases // tot. value of purchase of live animals last 12m
recode income_live_sales number_sold number_slaughtered /*number_slaughtered_sold income_slaughtered value_livestock_purchases*/ (.=0)
gen price_per_animal = income_live_sales / number_sold
lab var price_per_animal "Price of live animals sold"
recode price_per_animal (0=.) 
recast str50 hhid, force 
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta"
drop if _merge==2
drop _merge
keep hhid weight region district ta ea livestock_code number_sold income_live_sales number_slaughtered /*number_slaughtered_sold income_slaughtered*/ price_per_animal //value_livestock_purchases
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hh_livestock_sales", replace // RH complete - can we do anything about missing slaughtered/sold data? Is total value of sales actually live only? Label says "total value of livestock sales", not total value of live sales

*Implicit prices  // VAP: MW2 & w3 do not have value of slaughtered livestock

* EA Level
use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district ta ea livestock_code: egen obs_ea = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district ta ea livestock_code obs_ea)
rename price_per_animal price_median_ea
lab var price_median_ea "Median price per unit for this livestock in the ea"
lab var obs_ea "Number of sales observations for this livestock in the ea"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_prices_ea.dta", replace 

* TA Level
use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district ta livestock_code: egen obs_ta = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district ta livestock_code obs_ta)
rename price_per_animal price_median_ta
lab var price_median_ta "Median price per unit for this livestock in the ta"
lab var obs_ta "Number of sales observations for this livestock in the ta"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_prices_ta.dta", replace 

* District Level
use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region district livestock_code: egen obs_district = count(observation)
collapse (median) price_per_animal [aw=weight], by (region district livestock_code obs_district)
rename price_per_animal price_median_district
lab var price_median_district "Median price per unit for this livestock in the district"
lab var obs_district "Number of sales observations for this livestock in the district"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_prices_district.dta", replace

* Region Level
use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys region livestock_code: egen obs_region = count(observation)
collapse (median) price_per_animal [aw=weight], by (region livestock_code obs_region)
rename price_per_animal price_median_region
lab var price_median_region "Median price per unit for this livestock in the region"
lab var obs_region "Number of sales observations for this livestock in the region"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_prices_region.dta", replace

* Country Level
use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hh_livestock_sales", clear
keep if price_per_animal !=.
gen observation = 1
bys livestock_code: egen obs_country = count(observation)
collapse (median) price_per_animal [aw=weight], by (livestock_code obs_country)
rename price_per_animal price_median_country
lab var price_median_country "Median price per unit for this livestock in the country"
lab var obs_country "Number of sales observations for this livestock in the country"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_prices_country.dta", replace //RH complete

use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hh_livestock_sales", clear
merge m:1 region district ta ea livestock_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_prices_ea.dta", nogen
merge m:1 region district ta livestock_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_prices_ta.dta", nogen
merge m:1 region district livestock_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_prices_country.dta", nogen
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_ta if price_per_animal==. & obs_ta >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_lvstck_sold = price_per_animal * number_sold
gen value_slaughtered = price_per_animal * number_slaughtered

{
/* VAP: Not available for MW2 or w3
gen value_slaughtered_sold = price_per_animal * number_slaughtered_sold 
*gen value_slaughtered_sold = income_slaughtered 
replace value_slaughtered_sold = income_slaughtered if (value_slaughtered_sold < income_slaughtered) & number_slaughtered!=0 /* Replace value of slaughtered animals with income from slaughtered-sales if the latter is larger */
replace value_slaughtered = value_slaughtered_sold if (value_slaughtered_sold > value_slaughtered) & (number_slaughtered > number_slaughtered_sold) //replace value of slaughtered with value of slaughtered sold if value sold is larger
*gen value_livestock_sales = value_lvstck_sold  + value_slaughtered_sold 
*/
}

collapse (sum) /*value_livestock_sales value_livestock_purchases*/ value_lvstck_sold /*value_slaughtered*/, by (hhid)
drop if hhid==""
*lab var value_livestock_sales "Value of livestock sold (live and slaughtered)"
*lab var value_livestock_purchases "Value of livestock purchases"
*lab var value_slaughtered "Value of livestock slaughtered (with slaughtered livestock that weren't sold valued at local median prices for live animal sales)"
lab var value_lvstck_sold "Value of livestock sold live" 
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_sales", replace //RH complete

*TLU (Tropical Livestock Units)
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_R1.dta", clear
rename ag_r0a livestock_code //NOTE: why changing the name to lvstckid here?
gen tlu_coefficient=0.5 if (livestock_code==301|livestock_code==302|livestock_code==303|livestock_code==304|livestock_code==3304) // calf, steer/heifer, cow, bull, ox
replace tlu_coefficient=0.1 if (livestock_code==307|livestock_code==308) //goats, sheep
replace tlu_coefficient=0.2 if (livestock_code==309) // pigs
replace tlu_coefficient=0.01 if (livestock_code==313|livestock_code==313|livestock_code==315|livestock_code==319|livestock_code==3310|livestock_code==3314) // local hen, cock, duck, dove/pigeon, chicken layer/broiler, turkey/guinea fowl
replace tlu_coefficient=0.3 if (livestock_code==3305) // donkey/mule/horse
lab var tlu_coefficient "Tropical Livestock Unit coefficient"

rename ag_r07 number_1yearago
rename ag_r02 number_today_total
rename ag_r03 number_today_exotic
gen number_today_indigenous = number_today_total - number_today_exotic
recode number_today_total number_today_indigenous number_today_exotic (.=0)
*gen number_today = number_today_indigenous + number_today_exotic // already exists (number_today_total)
gen tlu_1yearago = number_1yearago * tlu_coefficient
gen tlu_today = number_today_total * tlu_coefficient
rename ag_r17 income_live_sales 
rename ag_r16 number_sold

rename ag_r21b lost_disease // VAP: Includes lost to injury in MW2
*rename lf02_22 lost_injury 
rename ag_r15 lost_stolen // # of livestock lost or stolen in last 12m
egen mean_12months = rowmean(number_today_total number_1yearago)
egen animals_lost12months = rowtotal(lost_disease lost_stolen)	
gen share_imp_herd_cows = number_today_exotic/(number_today_total) if livestock_code==303 // VAP: only cows, not including calves, steer/heifer, ox and bull
gen species = (inlist(livestock_code,301,302,202,204,3304)) + 2*(inlist(livestock_code,307,308)) + 3*(livestock_code==309) + 4*(livestock_code==3305) + 5*(inlist(livestock_code,313,313,315,319,3310,3314))
recode species (0=.)
la def species 1 "Large ruminants (calves, steer/heifer, cows, bulls, oxen)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys, mules)" 5 "Poultry"
la val species species

preserve
	*Now to household level
	*First, generating these values by species
	collapse (firstnm) share_imp_herd_cows (sum) number_today_total number_1yearago animals_lost12months lost_disease number_today_exotic lvstck_holding=number_today_total, by(hhid species)
	egen mean_12months = rowmean(number_today_total number_1yearago)
	gen any_imp_herd = number_today_exotic!=0 if number_today_total!=. & number_today_total!=0
	
foreach i in animals_lost12months mean_12months any_imp_herd lvstck_holding lost_disease {
		gen `i'_lrum = `i' if species==1
		gen `i'_srum = `i' if species==2
		gen `i'_pigs = `i' if species==3
		gen `i'_equine = `i' if species==4
		gen `i'_poultry = `i' if species==5
	}
	*Now we can collapse to household (taking firstnm because these variables are only defined once per household)
	collapse (sum) number_today_total number_today_exotic (firstnm) *lrum *srum *pigs *equine *poultry share_imp_herd_cows, by(hhid)
	*Overall any improved herd
	gen any_imp_herd = number_today_exotic!=0 if number_today_total!=0
	drop number_today_exotic number_today_total
	
	foreach i in lvstck_holding animals_lost12months mean_12months lost_disease {
		gen `i' = .
	}
	la var lvstck_holding "Total number of livestock holdings (# of animals)"
	la var any_imp_herd "At least one improved animal in herd"
	la var share_imp_herd_cows "Share of improved animals in total herd - Cows only"
	lab var animals_lost12months  "Total number of livestock  lost in last 12 months"
	lab var  mean_12months  "Average number of livestock  today and 1  year ago"
	lab var lost_disease "Total number of livestock lost to disease or injury" 
	
	foreach i in any_imp_herd lvstck_holding animals_lost12months mean_12months lost_disease {
		local l`i' : var lab `i'
		lab var `i'_lrum "`l`i'' - large ruminants"
		lab var `i'_srum "`l`i'' - small ruminants"
		lab var `i'_pigs "`l`i'' - pigs"
		lab var `i'_equine "`l`i'' - equine"
		lab var `i'_poultry "`l`i'' - poultry"
	}
	la var any_imp_herd "At least one improved animal in herd - all animals" 
	*Now dropping these missing variables, which I only used to construct the labels above
	
	*Total livestock holding for large ruminants, small ruminants, and poultry
	gen lvstck_holding_all = lvstck_holding_lrum + lvstck_holding_srum + lvstck_holding_poultry
	la var lvstck_holding_all "Total number of livestock holdings (# of animals) - large ruminants, small ruminants, poultry"
	
	*any improved large ruminants, small ruminants, or poultry
	gen any_imp_herd_all = 0 if any_imp_herd_lrum==0 | any_imp_herd_srum==0 | any_imp_herd_poultry==0
	replace any_imp_herd_all = 1 if  any_imp_herd_lrum==1 | any_imp_herd_srum==1 | any_imp_herd_poultry==1
	lab var any_imp_herd_all "1=hh has any improved lrum, srum, or poultry"
	
	recode lvstck_holding* (.=0)
	drop lvstck_holding animals_lost12months mean_12months lost_disease 
	save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_herd_characteristics", replace
restore

gen price_per_animal = income_live_sales / number_sold
recast str50 hhid, force 
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta"
drop if _merge==2
drop _merge
merge m:1 region district ta ea livestock_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_prices_ea.dta", nogen
merge m:1 region district ta livestock_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_prices_ta.dta", nogen
merge m:1 region district livestock_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_prices_district.dta", nogen
merge m:1 region livestock_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_prices_region.dta", nogen
merge m:1 livestock_code using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_prices_country.dta", nogen

recode price_per_animal (0=.)
replace price_per_animal = price_median_ea if price_per_animal==. & obs_ea >= 10
replace price_per_animal = price_median_ta if price_per_animal==. & obs_ta >= 10
replace price_per_animal = price_median_district if price_per_animal==. & obs_district >= 10
replace price_per_animal = price_median_region if price_per_animal==. & obs_region >= 10
replace price_per_animal = price_median_country if price_per_animal==. 
lab var price_per_animal "Price per animal sold, imputed with local median prices if household did not sell"
gen value_1yearago = number_1yearago * price_per_animal
gen value_today = number_today_total * price_per_animal
collapse (sum) tlu_1yearago tlu_today value_1yearago value_today, by (hhid)
lab var tlu_1yearago "Tropical Livestock Units as of 12 months ago"
lab var tlu_today "Tropical Livestock Units as of the time of survey"
gen lvstck_holding_tlu = tlu_today
lab var lvstck_holding_tlu "Total HH livestock holdings, TLU"  
lab var value_1yearago "Value of livestock holdings from one year ago"
lab var value_today "Value of livestock holdings today"
drop if hhid==""
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_TLU.dta", replace

*Livestock income
use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_sales", clear
recast str50 hhid, force 
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hh_livestock_products", nogen
recast str50 hhid, force 
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_manure.dta", nogen
recast str50 hhid, force 
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_expenses", nogen
recast str50 hhid, force 
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_TLU.dta", nogen

gen livestock_income = value_lvstck_sold  /*value_slaughtered*/ /*
*/ + (value_milk_produced + value_eggs_produced + value_other_produced + sales_manure) /*
*/ - (cost_hired_labor_livestock + cost_fodder_livestock + cost_vaccines_livestock + cost_othervet_livestock + cost_input_livestock)

lab var livestock_income "Net livestock income"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_income", replace


************
*FISH INCOME - CNC
************
*Fishing expenses  
*VAP: Method of calculating ft and pt weeks and days consistent with ag module indicators for rainy/dry seasons*/
use "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_c.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_g.dta"
rename fs_c01a weeks_ft_fishing_high // FT weeks, high season
replace weeks_ft_fishing_high= fs_g01a if weeks_ft_fishing_high==. // FT weeks, low season
rename fs_c02a weeks_pt_fishing_high // PT weeks, high season
replace weeks_pt_fishing_high= fs_g02a if weeks_pt_fishing_high==. // PT weeks, low season
gen weeks_fishing = weeks_ft_fishing_high + weeks_pt_fishing_high

rename fs_c01b days_ft_fishing_high // FT, days, high season
replace days_ft_fishing_high= fs_g01b if days_ft_fishing_high==. // FT days, low season
rename fs_c02b days_pt_fishing_high // PT days, high season
replace days_pt_fishing_high= fs_g02b if days_pt_fishing_high==. // PT days, low season
gen days_per_week = days_ft_fishing_high + days_pt_fishing_high

recode weeks_fishing days_per_week (.=0)
collapse (max) weeks_fishing days_per_week, by (hhid) 
keep hhid weeks_fishing days_per_week
lab var weeks_fishing "Weeks spent working as a fisherman (maximum observed across individuals in household)"
lab var days_per_week "Days per week spent working as a fisherman (maximum observed across individuals in household)"
recast str50 hhid, force
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_weeks_fishing.dta", replace

use "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_d1.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_h2.dta"
recast str50 hhid, force
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_weeks_fishing.dta"
rename weeks_fishing weeks
rename fs_h13 fuel_costs_week
rename fs_h12 rental_costs_fishing 
// Relevant and in the MW2 Qs., but missing in .dta files. 
// fs_d6: "How much did your hh. pay to rent [gear] for use in last high season?" 
rename fs_h10 purchase_costs_fishing // VAP: Boat/Engine purchase. Purchase cost is additional in MW2, TZ code does not have this. 
recode weeks fuel_costs_week rental_costs_fishing  purchase_costs_fishing(.=0)
gen cost_fuel = fuel_costs_week * weeks
collapse (sum) cost_fuel rental_costs_fishing, by (hhid)
lab var cost_fuel "Costs for fuel over the past year"
lab var rental_costs_fishing "Costs for other fishing expenses over the past year"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_fishing_expenses_1.dta", replace // VAP: Not including hired labor costs, keeping consistent with TZ. Can add this for MW if needed. 

* Other fishing costs  
use "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_d3.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_h3.dta"
recast str50 hhid, force 
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_weeks_fishing"
rename fs_d24a total_cost_high // total other costs in high season, only 6 obsns. 
replace total_cost_high=fs_h24a if total_cost_high==.
rename fs_d24b unit
replace unit=fs_h24b if unit==. 
gen cost_paid = total_cost_high if unit== 2  // season
replace cost_paid = total_cost_high * weeks_fishing if unit==1 // weeks
collapse (sum) cost_paid, by (hhid)
lab var cost_paid "Other costs paid for fishing activities"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_fishing_expenses_2.dta", replace

* Fish Prices
//ALT 10.18.19: It doesn't look like the data match up with the questions in module e.

use "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_e1.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_i1.dta"
rename fs_e02 fish_code 
replace fish_code=fs_i02 if fish_code==. 
recode fish_code (12=13) // recoding "aggregate" from low season to "other"
rename fs_e06a fish_quantity_year // high season
replace fish_quantity_year=fs_i06a if fish_quantity_year==. // low season
rename fs_e06b fish_quantity_unit
replace fish_quantity_unit=fs_i06b if fish_quantity_unit==.
rename fs_e08b unit  // piece, dozen/bundle, kg, small basket, large basket
gen price_per_unit = fs_e08d // VAP: This is already avg. price per packaging unit. Did not divide by avg. qty sold per week similar to TZ, seems to be an error?
replace price_per_unit = fs_i08d if price_per_unit==.
recast str50 hhid, force 
merge m:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hhids.dta"
drop if _merge==2
drop _merge
recode price_per_unit (0=.) 
collapse (median) price_per_unit [aw=weight], by (fish_code unit)
rename price_per_unit price_per_unit_median
replace price_per_unit_median = . if fish_code==13
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_fish_prices.dta", replace

* Value of fish harvest & sales 
use "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_e1.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_i1.dta"
rename fs_e02 fish_code 
replace fish_code=fs_i02 if fish_code==. 
recode fish_code (12=13) // recoding "aggregate" from low season to "other"
rename fs_e06a fish_quantity_year // high season
replace fish_quantity_year=fs_i06a if fish_quantity_year==. // low season
rename fs_e06b unit  // piece, dozen/bundle, kg, small basket, large basket
recast str50 hhid, force 
merge m:1 fish_code unit using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_fish_prices.dta"
drop if _merge==2
drop _merge
rename fs_e08a quantity_1
replace quantity_1=fs_i08a if quantity_1==.
rename fs_e08b unit_1
replace unit_1=fs_i08b if unit_1==.
gen price_unit_1 = fs_e08d // not divided by qty unlike TZ, not sure about the logic of dividing here. 
replace price_unit_1=fs_i08d if price_unit_1==.
rename fs_e08g quantity_2
replace quantity_2=fs_i08g if quantity_2==.
rename fs_e08h unit_2 
replace unit_2= fs_i08h if unit_2==.
gen price_unit_2=fs_e08j // not divided by qty unlike TZ.
replace price_unit_2=fs_i08j if price_unit_2==.
recode quantity_1 quantity_2 fish_quantity_year (.=0)
gen income_fish_sales = (quantity_1 * price_unit_1) + (quantity_2 * price_unit_2)
gen value_fish_harvest = (fish_quantity_year * price_unit_1) if unit==unit_1 
replace value_fish_harvest = (fish_quantity_year * price_per_unit_median) if value_fish_harvest==.
collapse (sum) value_fish_harvest income_fish_sales, by (hhid)
recode value_fish_harvest income_fish_sales (.=0)
lab var value_fish_harvest "Value of fish harvest (including what is sold), with values imputed using a national median for fish-unit-prices"
lab var income_fish_sales "Value of fish sales"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_fish_income.dta", replace


* HKS 09.01.23: This section was previously labeled self-employment income, which was separate from other self-employment income. I've moved this to the rest of fish income; not sure if these files should be appended/merged/consolidated with the above fish_income.dta
*Fish trading
use "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_c.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_g.dta"
rename fs_c04a weeks_fish_trading 
replace weeks_fish_trading=fs_g04a if weeks_fish_trading==.
recode weeks_fish_trading (.=0)
collapse (max) weeks_fish_trading, by (hhid) 
keep hhid weeks_fish_trading
lab var weeks_fish_trading "Weeks spent working as a fish trader (maximum observed across individuals in household)"
compress hhid
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_weeks_fish_trading.dta", replace

use "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_f1.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_f2.dta"
append using "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_j1.dta"
append using "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_j2.dta"
rename fs_f02a quant_fish_purchased_1
replace quant_fish_purchased_1= fs_j02a if quant_fish_purchased_1==.
rename fs_f02f price_fish_purchased_1
replace price_fish_purchased_1= fs_j02f if price_fish_purchased_1==.
rename fs_f02h quant_fish_purchased_2
replace quant_fish_purchased_2= fs_j02h if quant_fish_purchased_2==.
rename fs_f02m price_fish_purchased_2
replace price_fish_purchased_2= fs_j02m if price_fish_purchased_2==.
rename fs_f03a quant_fish_sold_1
replace quant_fish_sold_1=fs_j03a if quant_fish_sold_1==.
rename fs_f03f price_fish_sold_1
replace price_fish_sold_1=fs_j03f if price_fish_sold_1==.
rename fs_f03h quant_fish_sold_2
replace quant_fish_sold_2=fs_j03g if quant_fish_sold_2==.
rename fs_f03m price_fish_sold_2
replace price_fish_sold_2=fs_j03l if price_fish_sold_2==.

recode quant_fish_purchased_1 price_fish_purchased_1 quant_fish_purchased_2 price_fish_purchased_2 /*
*/ quant_fish_sold_1 price_fish_sold_1 quant_fish_sold_2 price_fish_sold_2 /*other_costs_fishtrading*/(.=0)

gen weekly_fishtrade_costs = (quant_fish_purchased_1 * price_fish_purchased_1) + (quant_fish_purchased_2 * price_fish_purchased_2) /*+ other_costs_fishtrading*/
gen weekly_fishtrade_revenue = (quant_fish_sold_1 * price_fish_sold_1) + (quant_fish_sold_2 * price_fish_sold_2)
gen weekly_fishtrade_profit = weekly_fishtrade_revenue - weekly_fishtrade_costs
collapse (sum) weekly_fishtrade_profit, by (hhid)
lab var weekly_fishtrade_profit "Average weekly profits from fish trading (sales minus purchases), summed across individuals"
keep hhid weekly_fishtrade_profit
compress hhid
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_fish_trading_revenues.dta", replace   

use "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_f2.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\fs_mod_j2.dta"
rename fs_f05 weekly_costs_for_fish_trading // VAP: Other costs: Hired labor, transport, packaging, ice, tax in MW2.
replace weekly_costs_for_fish_trading=fs_j05 if weekly_costs_for_fish_trading==.
recode weekly_costs_for_fish_trading (.=0)
collapse (sum) weekly_costs_for_fish_trading, by (hhid)
lab var weekly_costs_for_fish_trading "Weekly costs associated with fish trading, in addition to purchase of fish"
keep hhid weekly_costs_for_fish_trading
compress hhid
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_fish_trading_other_costs.dta", replace

use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_weeks_fish_trading.dta", clear
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_fish_trading_revenues.dta" 
drop _merge
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_fish_trading_other_costs.dta"
drop _merge
replace weekly_fishtrade_profit = weekly_fishtrade_profit - weekly_costs_for_fish_trading
gen fish_trading_income = (weeks_fish_trading * weekly_fishtrade_profit)
lab var fish_trading_income "Estimated net household earnings from fish trading over previous 12 months"
keep hhid fish_trading_income
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_fish_trading_income.dta", replace


************
*OTHER INCOME - HKS copied from MS AL Seasonal Hunger by FN on 6.29.23 - CNC
************
*use "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_crop_prices.dta", clear
*keep if crop_code==1 // keeping only maize for later
*save "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_maize_prices.dta", replace

use "${MWI_IHS_IHPS_W3_appended_data}\HH_MOD_P.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\HH_MOD_R.dta" 
append using "${MWI_IHS_IHPS_W3_appended_data}\HH_MOD_O.dta"
*merge m:1 HHID using "R:\Project\EPAR\Working Files\378 - LSMS Burkina Faso, Malawi, Uganda\malawi-wave3-2016\temp\MWI_IHS_IHPS_W3_hh_maize_prices.dta"  // VAP: need maize prices for calculating cash value of free maize 
*merge m:1 y2_hhid using "${MLW_W2_created_data}\Malawi_IHS_LSMS_ISA_W2_hh_maize_prices.dta"  // VAP: need maize prices for calculating cash value of free maize 
rename hh_p0a income_source
ren hh_p01 received_income
ren hh_p02 amount_income
gen rental_income=amount_income if received_income==1 & inlist(income_source, 106, 107, 108, 109) // non-ag land rental, house/apt rental, shope/store rental, vehicle rental
gen pension_investment_income=amount_income if received_income==1 &  income_source==105| income_source==104 | income_source==136 // pension & savings/interest/investment income+ private pension
gen asset_sale_income=amount_income if received_income==1 &  inlist(income_source, 130,131,132) // real estate sales, non-ag hh asset sale income, hh ag/fish asset sale income
gen other_income=amount_income if received_income==1 &  inlist(income_source, 133, 134, 135) // inheritance, lottery, other income
rename hh_r0a prog_code

gen assistance_cash_yesno= hh_r02a!=0 & hh_r02a!=. if inlist(prog_code, 1031, 104,108,1091,131,132) // Cash from MASAF, Non-MASAF pub. works,
*inputs-for-work, sec. level scholarships, tert. level. scholarships, dir. Cash Tr. from govt, DCT other
gen assistance_food= hh_r02b!=0 & hh_r02b!=.  if inlist(prog_code, 101, 102, 1032, 105, 107) //  
gen assistance_otherinkind_yesno=hh_r02b!=0 & hh_r02b!=. if inlist(prog_code,104, 106, 132, 133) // 

rename hh_o14 cash_remittance // VAP: Module O in MW2
rename hh_o17 in_kind_remittance // VAP: Module O in MW2 //ALT - ditto+
recode rental_income pension_investment_income asset_sale_income other_income assistance_cash assistance_food /*assistance_inkind cash_received inkind_gifts_received*/  cash_remittance in_kind_remittance (.=0)
gen remittance_income = /*cash_received + inkind_gifts_received +*/ cash_remittance + in_kind_remittance
*gen assistance_income = assistance_cash + assistance_food + assistance_inkind
lab var rental_income "Estimated income from rentals of buildings, land, vehicles over previous 12 months"
lab var pension_investment_income "Estimated income from a pension AND INTEREST/INVESTMENT/INTEREST over previous 12 months"
lab var other_income "Estimated income from inheritance, lottery/gambling and ANY OTHER source over previous 12 months"
lab var asset_sale_income "Estimated income from household asset and real estate sales over previous 12 months"
lab var remittance_income "Estimated income from remittances over previous 12 months"
*lab var assistance_income "Estimated income from food aid, food-for-work, cash transfers etc. over previous 12 months"

gen remittance_income_yesno = remittance_income!=0 & remittance_income!=. //FN: creating dummy for remittance
gen rental_income_yesno= rental_income!=0 & rental_income!=.
gen pension_investment_income_yesno= pension_investment_income!=0 & pension_investment_income!=.
gen asset_sale_income_yesno= asset_sale_income!=0 & asset_sale_income!=.
gen other_income_yesno= other_income!=0 & other_income!=.
collapse (max) *_yesno  (sum) remittance_income rental_income pension_investment_income asset_sale_income other_income, by(hhid case_id)
recode *_yesno *_income (.=0)
egen any_other_income_yesno=rowmax(rental_income_yesno pension_investment_income_yesno asset_sale_income_yesno other_income_yesno)

lab var remittance_income_yesno "1=Household received some remittances (cash or in-kind)"
lab var any_other_income_yesno "1=Household received some other non-farm income (rental, asset sales, pension, others)"
lab var rental_income_yesno "1=Household received some income from properties rental"
lab var asset_sale_income_yesno "1=Household received some income from the sale of assets"
lab var pension_investment_income_yesno "1=Household received some income from pension"
lab var other_income_yesno "1=Household received some other non-farm income"

lab var rental_income "Estimated income from rentals of buildings, land, vehicles over previous 12 months"
lab var pension_investment_income "Estimated income from a pension AND INTEREST/INVESTMENT/INTEREST over previous 12 months"
lab var other_income "Estimated income from inheritance, lottery/gambling and ANY OTHER source over previous 12 months"
lab var asset_sale_income "Estimated income from household asset and real estate sales over previous 12 months"
lab var remittance_income "Estimated income from remittances over previous 12 months"
*lab var assistance_income "Estimated income from food aid, food-for-work, cash transfers etc. over previous 12 months"

lab var assistance_cash_yesno "1=Household received some cash assistance"
lab var assistance_otherinkind_yesno "1=Household received some inkind assistance"
recast str50 hhid, force
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_other_income.dta", replace

************
* Other: Land Rental Income - HKS copied from MWI W2

* HKS 6.29.23:
	* Questionnaire shows AG MOD B2 Q19 asking " how much did you ALREADY receive from renting out this garden in the rainy season", but q19 is omitted from the raw data
	* We do have Q B217 though: "How much did you receive from renting out this garden in the rainy season"
* Cross section got q17 whereas panel got q19;
* for MSAI request 6/30/23, refer only to cross section (prefer q17); for general LSMS purposes, need to incorporate the panel data;
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_b2.dta", clear // *VAP: The below code calculates only agricultural land rental income, per TZ guideline code 
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_i2.dta" 
rename ag_b217a land_rental_cash_rainy_recd // how much did you receive from renting out this garden in the rainy season
rename ag_b217b land_rental_inkind_rainy_recd // how much did you receive from renting out this garden in the rainy season (in kind)
*rename ag_d19c land_rental_cash_rainy_owed
*rename ag_d19d land_rental_inkind_rainy_owed
rename ag_i217a land_rental_cash_dry_recd // how much did you receive from renting out this garden in the dry season
rename ag_i217b land_rental_inkind_dry_recd // how much did you receive from renting out this garden in the dry season
*rename ag_k20c land_rental_cash_dry_owed
*rename ag_k20d land_rental_inkind_dry_owed
recode land_rental_cash_rainy_recd land_rental_inkind_rainy_recd /*land_rental_cash_rainy_owed land_rental_inkind_rainy_owed*/ land_rental_cash_dry_recd land_rental_inkind_dry_recd /*land_rental_cash_dry_owed land_rental_inkind_dry_owed */ (.=0)
gen land_rental_income_rainyseason= land_rental_cash_rainy_recd + land_rental_inkind_rainy_recd //+ land_rental_cash_rainy_owed + land_rental_inkind_rainy_owed
gen land_rental_income_dryseason= land_rental_cash_dry_recd + land_rental_inkind_dry_recd //+ land_rental_cash_dry_owed + land_rental_inkind_dry_owed 
gen land_rental_income = land_rental_income_rainyseason + land_rental_income_dryseason
collapse (sum) land_rental_income, by (hhid case_id)
lab var land_rental_income "Estimated income from renting out land over previous 12 months"
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_land_rental_income.dta", replace


*****************
* CROP INCOME - HKS copied from CWL code for MWI4 on 6.29.23 - CNC
*****************
/*use "${Malawi_IHS_W3_created_data}/Malawi_IHS_W3_land_rental_costs.dta", clear
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_wages_rainyseason.dta", nogen
merge 1:1 hhid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_wages_dryseason.dta", nogen
merge 1:1 hhid using "${Malawi_W3_created_data}/Malawi_IHS_W3_transportation_cropsales.dta", nogen
merge 1:! hhid using "{$Malawi_W3_created_data}/Malawi_IHS_W3_fertilizer_costs.dta", nogen
recode rental_cost_land cost_seed value_fertilizer value_herbicide value_pesticide wages_paid_rainy /*
*/ wages_paid_dry transport_costs_cropsales (.=0)
egen crop_production_expenses = rowtotal(rental_cost_land cost_seed value_fertilizer value_herbicide /* 
*/ value_pesticide wages_paid_dry wages_paid_rainy transport_costs_cropsales)
lab var crop_production_expenses "Total crop production expenses"
	ren hhid HHID 
save "${Malawi_IHS_W3_created_data}\MWI_IHS_IHPS_W3_crop_income.dta", replace*/



************
*SELF-EMPLOYMENT INCOME - HKS copied from MS AL Seasonal Hunger by FN on 6.29.23 - CNC
************
use "${MWI_IHS_IHPS_W3_appended_data}\HH_MOD_N2.dta", clear
rename hh_n40 last_months_profit 
gen self_employed_yesno = .
replace self_employed_yesno = 1 if last_months_profit !=.
replace self_employed_yesno = 0 if last_months_profit == .
*DYA.2.9.2022 Collapse this at the household level
collapse (max) self_employed_yesno (sum) last_months_profit, by(hhid)
drop if self != 1
ren last_months self_employ_income
*lab var self_employed_yesno "1=Household has at least one member with self-employment income"
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_self_employment_income.dta", replace



************
*WAGE INCOME - RH complete 8/2; HI checked 4/12/22 - needs review - CNC 
************

************
*NON-AG WAGE INCOME - RH complete 8/2; HI checked 4/12/22 - needs review - CNC 
use "${MWI_IHS_IHPS_W3_appended_data}\HH_MOD_E.dta", clear
rename hh_e06_4 wage_yesno 
rename hh_e22 number_months  //MW2:# of months worked at main wage job in last 12m. 
rename hh_e23 number_weeks  // MW2:# of weeks/month worked at main wage job in last 12m. 
rename hh_e24 number_hours  // MW2:# of hours/week worked at main wage job in last 12m. 
rename hh_e25 most_recent_payment // amount of last payment
replace most_recent_payment=. if inlist(hh_e19b,62 63 64) // VAP: main wage job 
**** 
* VAP: For MW2, above codes are in .dta. 62:Agriculture and animal husbandry worker; 63: Forestry workers; 64: Fishermen, hunters and related workers   
* For TZ: TASCO codes from TZ Basic Info Document http://siteresources.worldbank.org/INTLSMS/Resources/3358986-1233781970982/5800988-1286190918867/TZNPS_2014_2015_BID_06_27_2017.pdf
	* 921: Agricultural, Forestry, and Fishery Labourers
	* 613: Farmers and Crop Skilled Workers
	* 612: Animal Producers and Skilled Workers
	* 613: Forestry and Related Skilled Workers
	* 614: Fishery Workers, Hunters, and Trappers
	* 621: Subsistence Agricultural, Forestry, Fishery, and Related Workers
***
rename hh_e26b payment_period // What period of time did this payment cover?
rename hh_e27 most_recent_payment_other // What is the value of those (apart from salary) payments? 
replace most_recent_payment_other =. if inlist(hh_e19b,62,63,64) // code of main wage job 
rename hh_e28b payment_period_other // Over what time interval?
rename hh_e32 secondary_wage_yesno // In last 12m, employment in second wage job outside own hh, incl. casual/part-time labour, for a wage, salary, commission or any payment in kind, excluding ganyu
rename hh_e39 secwage_most_recent_payment // amount of last payment
replace secwage_most_recent_payment = . if hh_e33_code== 62 // code of secondary wage job; 
rename hh_e40b secwage_payment_period // What period of time did this payment cover?
rename hh_e41 secwage_recent_payment_other //  value of in-kind payments
rename hh_e42b secwage_payment_period_other // Over what time interval?
rename hh_e38_1 secwage_hours_pastweek // In the last 7 days, how many hours did you work in this job?
gen annual_salary_cash=.
replace annual_salary_cash = (number_months*most_recent_payment) if payment_period==5  // month
replace annual_salary_cash = (number_months*number_weeks*most_recent_payment) if payment_period== 4 // week
replace annual_salary_cash = (number_months*number_weeks*(number_hours/8)*most_recent_payment) if payment_period==3  // day
gen wage_salary_other=.
replace wage_salary_other = (number_months*most_recent_payment_other) if payment_period_other==5 // month
replace wage_salary_other = (number_months*number_weeks*most_recent_payment_other) if payment_period_other==4 //week
replace wage_salary_other = (number_months*number_weeks*(number_hours/8)*most_recent_payment_other) if payment_period_other==3 //day
recode annual_salary_cash wage_salary_other (.=0)
gen annual_salary = annual_salary_cash + wage_salary_other
tab secwage_payment_period
collapse (sum) annual_salary, by (hhid)
lab var annual_salary "Annual earnings from non-agricultural wage"
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_wage_income.dta", replace

************
*AG WAGE INCOME - Needs Review 

use "${MWI_IHS_IHPS_W3_appended_data}\HH_MOD_E.dta", clear
rename hh_e06_4 wage_yesno // MW3: last 12m,  work as an employee for a wage, salary, commission, or any payment in kind: incl. paid apprenticeship, domestic work or paid farm work, excluding ganyu
* TZ: last 12m, work as an unpaid apprentice OR employee for a wage, salary, commission or any payment in kind; incl. paid apprenticeship, domestic work or paid farm work 
rename hh_e22 number_months  //MW2:# of months worked at main wage job in last 12m. TZ: During the last 12 months, for how many months did [NAME] work in this job?
rename hh_e23 number_weeks  // MW2:# of weeks/month worked at main wage job in last 12m. TZ: During the last 12 months, how many weeks per month did [NAME] usually work in this job?
rename hh_e24 number_hours  // MW2:# of hours/week worked at main wage job in last 12m. TZ: During the last 12 months, how many hours per week did [NAME] usually work in this job?
rename hh_e25 most_recent_payment // amount of last payment

gen agwage = 1 if inlist(hh_e19b,62,63,64) // 62: Agriculture and animal husbandry worker; 63: Forestry workers; 64: Fishermen, hunters and related workers - RH note: occupation codes not in dta file for w3, see BID "Occupation Codes", pg 36

gen secagwage = 1 if inlist(hh_e33_code, 62,63,64) // 62: Agriculture and animal husbandry worker; 63: Forestry workers; 64: Fishermen, hunters and related workers - RH note: occupation codes not in dta file for w3, see BID "Occupation Codes", pg 36

*gen secagwage = 1 if hh_e33_code==62 //62: Agriculture and animal husbandry worker // double check this. Do we actually only want animal husbandry? - VAP code, RH changed to match secagwage codes to agwage codes.

replace most_recent_payment = . if agwage!=1
rename hh_e26b payment_period // What period of time did this payment cover?
rename hh_e27 most_recent_payment_other // What is the value of those (apart from salary) payments? 
replace most_recent_payment_other =. if agwage!=1 
rename hh_e28b payment_period_other // Over what time interval?
rename hh_e32 secondary_wage_yesno // In last 12m, employment in second wage job outside own hh, incl. casual/part-time labour, for a wage, salary, commission or any payment in kind, excluding ganyu
rename hh_e39 secwage_most_recent_payment // amount of last payment
replace secwage_most_recent_payment = . if secagwage!=1  // code of secondary wage job
rename hh_e40b secwage_payment_period // What period of time did this payment cover?
rename hh_e41 secwage_recent_payment_other //  value of in-kind payments
rename hh_e42b secwage_payment_period_other // Over what time interval?
rename hh_e38_1 secwage_hours_pastweek // In the last 7 days, how many hours did you work in this job?

gen annual_salary_cash=.
replace annual_salary_cash = (number_months*most_recent_payment) if payment_period==5  // month
replace annual_salary_cash = (number_months*number_weeks*most_recent_payment) if payment_period== 4 // week
replace annual_salary_cash = (number_months*number_weeks*(number_hours/8)*most_recent_payment) if payment_period==3  // day
gen wage_salary_other=.
replace wage_salary_other = (number_months*most_recent_payment_other) if payment_period_other==5 // month
replace wage_salary_other = (number_months*number_weeks*most_recent_payment_other) if payment_period_other==4 //week
replace wage_salary_other = (number_months*number_weeks*(number_hours/8)*most_recent_payment_other) if payment_period_other==3 //day
recode annual_salary_cash wage_salary_other (.=0)
gen annual_salary = annual_salary_cash + wage_salary_other
collapse (sum) annual_salary, by (hhid)
rename annual_salary annual_salary_agwage
lab var annual_salary_agwage "Annual earnings from agricultural wage"
recast str50 hhid, force 
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_agwage_income.dta", replace  

***************
*VACCINE USAGE - RH complete 8/3, rerun after confirming gender_merge; HI checked 4/27/22 - needs review
***************
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_R1.dta", clear
gen vac_animal=ag_r22>0
* MW3: How many of your[Livestock] are currently vaccinated? 
* TZ: Did you vaccinate your[ANIMAL] in the past 12 months? 
replace vac_animal = 0 if ag_r22==0  
replace vac_animal = . if ag_r22==. // VAP: 4092 observations on a hh-animal level

*Disagregating vaccine usage by animal type 
rename ag_r0a livestock_code
gen species = (inlist(livestock_code, 301,302,303,304,3304)) + 2*(inlist(livestock_code,307,308)) + 3*(livestock_code==309) + 4*(livestock_code==3305) + 5*(inlist(livestock_code, 313,313,315,319,3310,3314))
recode species (0=.)
la def species 1 "Large ruminants (calf, steer/heifer, cow, bull, ox)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
la val species species


*A loop to create species variables
foreach i in vac_animal {
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}

collapse (max) vac_animal*, by (hhid)
// VAP: After collapsing, the data is on hh level, vac_animal now has only 1883 observations
lab var vac_animal "1=Household has an animal vaccinated"
	foreach i in vac_animal {
		local l`i' : var lab `i'
		lab var `i'_lrum "`l`i'' - large ruminants"
		lab var `i'_srum "`l`i'' - small ruminants"
		lab var `i'_pigs "`l`i'' - pigs"
		lab var `i'_equine "`l`i'' - equine"
		lab var `i'_poultry "`l`i'' - poultry"
	}
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_vaccine.dta", replace

 
*vaccine use livestock keeper  
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_R1.dta", clear
gen all_vac_animal=ag_r22>0
* MW3: How many of your[Livestock] are currently vaccinated? 
* TZ: Did you vaccinate your[ANIMAL] in the past 12 months? 
replace all_vac_animal = 0 if ag_r22==0  
replace all_vac_animal = . if ag_r22==. // VAP: 4092 observations on a hh-animal level
keep hhid ag_r06a ag_r06b all_vac_animal

ren ag_r06a farmerid1
ren ag_r06b farmerid2
gen t=1
gen patid=sum(t)
reshape long farmerid, i(patid) j(idnum)
drop t patid

collapse (max) all_vac_animal , by(hhid farmerid)
gen indiv=farmerid
drop if indiv==.
recast str50 hhid, force
merge 1:1 hhid indiv using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_gender_merge.dta", nogen //RH NOTE: not yet created, run code after gender_merge
lab var all_vac_animal "1 = Individual farmer (livestock keeper) uses vaccines"
ren indiv indidy3 //renamed from indidy2
gen livestock_keeper=1 if farmerid!=.
recode livestock_keeper (.=0)
lab var livestock_keeper "1=Indvidual is listed as a livestock keeper (at least one type of livestock)" 
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_farmer_vaccine.dta", replace	


/*
***************
*ANIMAL HEALTH - DISEASES - RH IP; FN: unsure if complete; not checked 
***************
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_R1.dta", clear
gen disease_animal = 1 if ag_r20==1 // Answered "yes" for "Did livestock suffer from any disease in last 12m?"
replace disease_animal = 0 if ag_r20==2 // 2=No  
replace disease_animal = . if (ag_r22==.) 

* VAP: TZ main diseases: FMD, lumpy skin, brucelosis, CCPP, BQ. MW2 has different main diseases. 

//

//RH where are main diseases? BID? Do these change over waves?
gen disease_ASF = ag_r21a==1  //  African swine fever (RH, now 30)
gen disease_amapl = ag_r21a==2 // Amaplasmosis (now 18?)
gen disease_bruc = ag_r21a== 7 // Brucelosis (not incl w3?)
gen disease_mange = ag_r21a==18 // Mange (now 36)
gen disease_NC= ag_r21a==20 // New Castle disease (now 7)
gen disease_spox= ag_r21a==22 // Small pox (not incl?)

rename ag_r0a livestock_code
gen species = (inlist(livestock_code, 301,302,303,304,3304)) + 2*(inlist(livestock_code,307,308)) + 3*(livestock_code==309) + 4*(livestock_code==3305) + 5*(inlist(livestock_code, 313,313,315,319,3310,3314))
recode species (0=.)
la def species 1 "Large ruminants (cows, buffalos)" 2 "Small ruminants (sheep, goats)" 3 "Pigs" 4 "Equine (horses, donkeys)" 5 "Poultry"
la val species species

*A loop to create species variables
foreach i in disease_animal disease_ASF disease_amapl disease_bruc disease_mange disease_NC disease_spox{ //RH NOTE: may have to edit if diseases changed
	gen `i'_lrum = `i' if species==1
	gen `i'_srum = `i' if species==2
	gen `i'_pigs = `i' if species==3
	gen `i'_equine = `i' if species==4
	gen `i'_poultry = `i' if species==5
}

collapse (max) disease_*, by (HHID)
lab var disease_animal "1= Household has animal that suffered from disease"

//may have to edit below if diseases changed
lab var disease_ASF "1= Household has animal that suffered from African Swine Fever"
lab var disease_amapl"1= Household has animal that suffered from amaplasmosis disease"
lab var disease_bruc"1= Household has animal that suffered from brucelosis"
lab var disease_mange "1= Household has animal that suffered from mange disease"
lab var disease_NC "1= Household has animal that suffered from New Castle disease"
lab var disease_spox "1= Household has animal that suffered from small pox"

	foreach i in disease_animal disease_ASF disease_amapl disease_bruc disease_mange disease_NC disease_spox{ //RH edit flag
		local l`i' : var lab `i'
		lab var `i'_lrum "`l`i'' - large ruminants"
		lab var `i'_srum "`l`i'' - small ruminants"
		lab var `i'_pigs "`l`i'' - pigs"
		lab var `i'_equine "`l`i'' - equine"
		lab var `i'_poultry "`l`i'' - poultry"
	}

save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_livestock_diseases.dta", replace
*/

***************
*LIVESTOCK WATER, FEEDING, AND HOUSING - Cannot replicate for MWI
***************	
/* Cannot replicate this section as MWI w3 does not ask about livestock water, feeding, housing. */


***************
*USE OF INORGANIC FERTILIZER - RH complete 8/6/21; HI checked 4/27/22 - needs review
***************
use "${MWI_IHS_IHPS_W3_appended_data}/AG_MOD_D.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}/AG_MOD_K.dta" 
gen all_use_inorg_fert=.
replace all_use_inorg_fert=0 if ag_d38==2| ag_k39==2
replace all_use_inorg_fert=1 if ag_d38==1| ag_k39==1
recode all_use_inorg_fert (.=0)
lab var all_use_inorg_fert "1 = Household uses inorganic fertilizer"

keep hhid ag_d01 ag_d01_2a ag_d01_2b ag_k02 ag_k02_2a ag_k02_2b all_use_inorg_fert
ren ag_d01 farmerid1
replace farmerid1= ag_k02 if farmerid1==.
ren ag_d01_2a farmerid2
replace farmerid2= ag_k02_2a if farmerid2==.
ren ag_d01_2b farmerid3
replace farmerid2= ag_k02_2b if farmerid3==.	

//reshape long
gen t = 1
gen patid = sum(t)

reshape long farmerid, i(patid) j(decisionmakerid)
drop t patid

collapse (max) all_use_inorg_fert , by(hhid farmerid)
gen indiv=farmerid
drop if indiv==.
merge 1:1 hhid indiv using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_gender_merge.dta", nogen

lab var all_use_inorg_fert "1 = Individual farmer (plot manager) uses inorganic fertilizer"
ren indiv indidy3
gen farm_manager=1 if farmerid!=.
recode farm_manager (.=0)
lab var farm_manager "1=Individual is listed as a manager for at least one plot" 
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_farmer_fert_use.dta", replace
 

*********************
*REACHED BY AG EXTENSION - RH complete 8/26/21, HI checked 4/12/22 - verify sample size
*********************
use "${MWI_IHS_IHPS_W3_appended_data}/AG_MOD_T1.dta", clear
ren ag_t01 receive_advice
ren ag_t02 sourceids

**Government Extension
gen advice_gov = (sourceid==1|sourceid==3 & receive_advice==1) // govt ag extension & govt. fishery extension. 
**NGO
gen advice_ngo = (sourceid==4 & receive_advice==1)
**Cooperative/ Farmer Association
gen advice_coop = (sourceid==5 & receive_advice==1) // ag coop/farmers association
**Large Scale Farmer
gen advice_farmer =(sourceid== 10 & receive_advice==1) // lead farmers
**Radio/TV
gen advice_electronicmedia = (sourceid==12 & receive_advice==1) // electronic media:TV/Radio
**Publication
gen advice_pub = (sourceid==13 & receive_advice==1) // handouts, flyers
**Neighbor
gen advice_neigh = (sourceid==13 & receive_advice==1) // Other farmers: neighbors, relatives
** Farmer Field Days
gen advice_ffd = (sourceid==7 & receive_advice==1)
** Village Ag Extension Meeting
gen advice_village = (sourceid==8 & receive_advice==1)
** Ag Ext. Course
gen advice_course= (sourceid==9 & receive_advice==1)
** Private Ag. Extension 
gen advice_pvt= (sourceid==2 & receive_advice==1)
**Other
gen advice_other = (sourceid== 14 & receive_advice==1)

**advice on prices from extension
*Five new variables  ext_reach_all, ext_reach_public, ext_reach_private, ext_reach_unspecified, ext_reach_ict  // QUESTION - ffd and course in unspecified?
gen ext_reach_public=(advice_gov==1)
gen ext_reach_private=(advice_ngo==1 | advice_coop==1 | advice_pvt) //advice_pvt new addition
gen ext_reach_unspecified=(advice_neigh==1 | advice_pub==1 | advice_other==1 | advice_farmer==1 | advice_ffd==1 | advice_course==1 | advice_village==1) //RH - Re: VAP's check request - Farmer field days and courses incl. here - seems correct since we don't know who put those on, but flagging
gen ext_reach_ict=(advice_electronicmedia==1)
gen ext_reach_all=(ext_reach_public==1 | ext_reach_private==1 | ext_reach_unspecified==1 | ext_reach_ict==1)

collapse (max) ext_reach_* , by (hhid)
lab var ext_reach_all "1 = Household reached by extension services - all sources"
lab var ext_reach_public "1 = Household reached by extension services - public sources"
lab var ext_reach_private "1 = Household reached by extension services - private sources"
lab var ext_reach_unspecified "1 = Household reached by extension services - unspecified sources"
lab var ext_reach_ict "1 = Household reached by extension services through ICT"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_any_ext.dta", replace

********************************************************************************
* MOBILE OWNERSHIP * //RH complete 8/26/21 - HI checked 4/12/22
********************************************************************************
//Added based on TZA w5 code
use "${MWI_IHS_IHPS_W3_appended_data}\HH_MOD_F.dta", clear
//recode missing to 0 in hh_g301 (0 mobile owned if missing)
recode hh_f34 (.=0)
ren hh_f34 hh_number_mobile_owned
*recode hh_number_mobile_owned (.=0) 
gen mobile_owned = 1 if hh_number_mobile_owned>0 
recode mobile_owned (.=0) // recode missing to 0
collapse (max) mobile_owned, by(hhid)
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_mobile_own.dta", replace
 
*********************
*USE OF FORMAL FINANCIAL SERVICES - RH complete 8/10/21 - HI checked 4/12/22
*********************
use "${MWI_IHS_IHPS_W3_appended_data}\HH_MOD_F.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\HH_MOD_S1.dta"
gen borrow_bank= hh_s04==10 // VAP: Code source of loan. No microfinance or mortgage loan in Malawi W2 unlike TZ. 
gen borrow_relative=hh_s04==1|hh_s04==12 //RH Check request: w3 has village bank [12]. Confirm including under "Borrow_bank"?
gen borrow_moneylender=hh_s04==4 // NA in TZ
gen borrow_grocer=hh_s04==3 // local grocery/merchant
gen borrow_relig=hh_s04==6 // religious institution
gen borrow_other_fin=hh_s04==7|hh_s04==8|hh_s04==9 // VAP: MARDEF, MRFC, SACCO
gen borrow_neigh=hh_s04==2
gen borrow_employer=hh_s04==5
gen borrow_ngo=hh_s04==13
gen borrow_other=hh_s04==13

gen use_bank_acount=hh_f52==1
// VAP: No MM for MW2.  
// gen use_MM=hh_q01_1==1 | hh_q01_2==1 | hh_q01_3==1 | hh_q01_4==1 // use any MM services - MPESA ZPESA AIRTEL TIGO PESA. 
gen use_fin_serv_bank = use_bank_acount==1
gen use_fin_serv_credit= borrow_bank==1  | borrow_other_fin==1 // VAP: Include religious institution in this definition? No mortgage.  
// VAP: No digital and insurance in MW2
// gen use_fin_serv_insur= borrow_insurance==1
// gen use_fin_serv_digital=use_MM==1
gen use_fin_serv_others= borrow_other_fin==1
gen use_fin_serv_all=use_fin_serv_bank==1 | use_fin_serv_credit==1 |  use_fin_serv_others==1 /*use_fin_serv_insur==1 | use_fin_serv_digital==1 */ 
recode use_fin_serv* (.=0)

collapse (max) use_fin_serv_*, by (hhid)
lab var use_fin_serv_all "1= Household uses formal financial services - all types"
lab var use_fin_serv_bank "1= Household uses formal financial services - bank account"
lab var use_fin_serv_credit "1= Household uses formal financial services - credit"
// lab var use_fin_serv_insur "1= Household uses formal financial services - insurance"
// lab var use_fin_serv_digital "1= Household uses formal financial services - digital"
lab var use_fin_serv_others "1= Household uses formal financial services - others"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_fin_serv.dta", replace	

************
*MILK PRODUCTIVITY - RH complete 8/10/21 - HI checked 4/12/22 - verify sample size
************
//RH: only cow milk in MWI, not including large ruminant variables
*Total production
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_S.dta", clear
rename ag_s0a product_code
keep if product_code==401
rename ag_s02 months_milked // VAP: During the last 12 months, for how many months did your household produce any [PRODUCT]? (rh edited)
rename ag_s03a liters_month // VAP: During these months, what was the average quantity of [PRODUCT] produced PER MONTH?. (RH renamed to be more consistent with TZA (from qty_milk_per_month to liters_month))
gen milk_liters_produced = months_milked * liters_month if ag_s03b==1 // VAP: Only including liters, not including 2 obsns in "buckets". 
lab var milk_liters_produced "Liters of milk produced in past 12 months"

* lab var milk_animals "Number of large ruminants that was milk (household)": Not available in MW2 (only cow milk) 
lab var months_milked "Average months milked in last year (household)"
drop if milk_liters_produced==.
keep hhid product_code months_milked liters_month milk_liters_produced
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_milk_animals.dta", replace


************
*EGG PRODUCTIVITY - RH complete, HI checked 4/12/22 - needs review
************
use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_R1.dta", clear
rename ag_r0a lvstckid
gen poultry_owned = ag_r02 if inlist(lvstckid, 313, 313, 315, 318, 319, 3310, 3314) // For MW2: local hen, local cock, duck, other, dove/pigeon, chicken layer/chicken-broiler and turkey/guinea fowl - RH include other?
collapse (sum) poultry_owned, by(hhid)
tempfile eggs_animals_hh
recast str50 hhid, force 
save `eggs_animals_hh'

use "${MWI_IHS_IHPS_W3_appended_data}\AG_MOD_S.dta", clear
rename ag_s0a product_code
keep if product_code==402 | product_code==403
rename ag_s02 eggs_months // # of months in past year that hh. produced eggs
rename ag_s03a eggs_per_month  // avg. qty of eggs per month in past year
rename ag_s03b quantity_month_unit
replace quantity_month = round(quantity_month/0.06) if product_code==402 & quantity_month_unit==2 // VAP: converting obsns in kgs to pieces for eggs 
// using MW IHS Food Conversion factors.pdf. Cannot convert ox-cart & ltrs for eggs 
replace quantity_month_unit = 3 if product_code== 402 & quantity_month_unit==2    
replace quantity_month_unit =. if product_code==402 & quantity_month_unit!=3        // VAP: chicken eggs, pieces
replace quantity_month_unit =. if product_code== 403 & quantity_month_unit!=3      // guinea fowl eggs, pieces
recode eggs_months eggs_per_month (.=0)
collapse (sum) eggs_per_month (max) eggs_months, by (hhid) // VAP: Collapsing chicken & guinea fowl eggs
gen eggs_total_year = eggs_months* eggs_per_month // Units are pieces for eggs 
recast str50 hhid, force
merge 1:1 hhid using  `eggs_animals_hh', nogen keep(1 3)			
keep hhid eggs_months eggs_per_month eggs_total_year poultry_owned 

lab var eggs_months "Number of months eggs were produced (household)"
lab var eggs_per_month "Number of eggs that were produced per month (household)"
lab var eggs_total_year "Total number of eggs that was produced in a year (household)"
lab var poultry_owned "Total number of poultry owned (household)"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_eggs_animals.dta", replace


/*	
********************************************************************************
*CONSUMPTION -- RH 7/14/21 - complete, confirm case_id works instead of HHID; FN: unsure if complete; not checked
******************************************************************************** 
use "${MWI_IHS_IHPS_W3_appended_data}/ConsAggW3.dta", clear // RH - renamed dta file for consumption aggregate

ren expagg total_cons // using real consumption-adjusted for region price disparities -- this is nominal (but other option was per capita vs hh-level). Confirm?
gen peraeq_cons = (total_cons / adulteq)
gen percapita_cons = (total_cons / hhsize)
gen daily_peraeq_cons = peraeq_cons/365 
gen daily_percap_cons = percapita_cons/365
lab var total_cons "Total HH consumption"
lab var peraeq_cons "Consumption per adult equivalent"
lab var percapita_cons "Consumption per capita"
lab var daily_peraeq_cons "Daily consumption per adult equivalent"
lab var daily_percap_cons "Daily consumption per capita" 
keep case_id total_cons peraeq_cons percapita_cons daily_peraeq_cons daily_percap_cons adulteq // HHID not included in MLW w3 consagg dta, keeping case_id instead. Confirm?
save "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_consumption.dta", replace
*/

/*
***************************************************************************
*HOUSEHOLD FOOD PROVISION* - RH 7/14/21; FN: unsure if complete, not checked
***************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}\HH_MOD_H.dta", clear

// need to loop through alpha list a - y (25)
numlist "1/25"
forvalues k=1/25 {
    local num: word `k' of `r(numlist)'
	local alph: word `k' of `c(alpha)'
	ren hh_h05`alph' hh_h05_`num'
}
forvalues k = 1/25 {
    gen food_insecurity_`k' = (hh_h05_`k'=="X")
}
egen months_food_insec = rowtotal(food_insecurity_*) 
* replacing those that report over 12 months
replace months_food_insec = 12 if months_food_insec>12
keep HHID months_food_insec
lab var months_food_insec "Number of months of inadequate food provision"
save "${MWI_IHS_IHPS_W3_created_data}/MWI_IHS_IHPS_W3_food_insecurity.dta", replace		
*/

***************************************************************************
*HOUSEHOLD ASSETS* - RH complete 8/24/21 - HI checked 4/27/22
***************************************************************************
use "${MWI_IHS_IHPS_W3_appended_data}\HH_MOD_L.dta", clear
*ren hh_m03 price_purch  // RH: No price purchased, only total spent on item
ren hh_l05 value_today
ren hh_l04 age_item
ren hh_l03 num_items

collapse (sum) value_assets=value_today, by(hhid)
la var value_assets "Value of household assets"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_hh_assets.dta", replace 
		

/*		
************
*FARM SIZE / LAND SIZE FN 4/14 - not complete, only done until land_size.dta file for use in all plots; all ag land and total land holding not done
************

***Determining whether crops were grown on a plot
use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_g.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_m.dta"
drop if plotid==""
drop if crop_code==. 
gen crop_grown = 1 
collapse (max) crop_grown, by(HHID plotid gardenid)
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_crops_grown.dta", replace
***

use "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_k.dta", clear
append using "${MWI_IHS_IHPS_W3_appended_data}\ag_mod_d.dta"
gen cultivated = (ag_d14==1 | ag_k36==1) // VAP: cultivated plots in rainy or dry seasons
collapse (max) cultivated, by (HHID plotid gardenid)
lab var cultivated "1= Parcel was cultivated in this data set"
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_parcels_cultivated.dta", replace

use "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_parcels_cultivated.dta", clear
merge 1:1 HHID plotid gardenid using "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_plot_areas.dta",
drop if _merge==2
keep if cultivated==1
replace area_acres_meas=. if area_acres_meas<0 
replace area_acres_meas = area_acres_est if area_acres_meas==. 
collapse (sum) area_acres_meas, by (HHID)
rename area_acres_meas farm_area
replace farm_area = farm_area * (1/2.47105) /* Convert to hectares */
lab var farm_area "Land size (denominator for land productivitiy), in hectares" 
save "${MWI_IHS_IHPS_W3_created_data}\MWI_IHS_IHPS_W3_land_size.dta", replace
*/