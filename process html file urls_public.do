* Rludwig Updated Aug. 20 2020
* Stata do file to process html files for Caperio

clear


cd "C:\Users\roytl\Stata to Python"
import delimited using batchname.txt, varnames(nonames)stringcols(_all)

tostring v1, replace
rename v1 batch

save batchname_html_cat.dta, replace

*******new code for list2 url********************************
clear


cd "C:\Users\roytl\Stata to Python"
import delimited using sc_s3_urllist_list2files.csv, varnames(1)

split name, p(_)

gen subcat_code = subinstr(name2, "list2", "", .)

replace archivo_list2 = subinstr(archivo_list2, " ", "", .)

cd "C:\Bossa Nova\audiototext\sc\Do Files"


do subcat_code_to_cat_code.do
do subcat_code_to_subcategory_sc_agencias.do
do cat_code_to_category_sc_agencias.do

drop subcat_code cat_code name1 name2 name3

cd "C:\Users\roytl\Stata to Python"
******************change fecha_update to current date*****************************
local mmddaaaa : di %tdNN/DD/CCYY date(c(current_date), "DMY")
di "`mmddaaaa'"

gen fecha_update="`mmddaaaa'"

display %tdNN_CCYY date(c(current_date), "DMY")

local aaaammdd : di %tdCCYY-NN-DD date(c(current_date), "DMY")
di "`aaaammdd'"

gen file_date="`aaaammdd'"

append using batchname_html_cat.dta

gen filenamedate=substr(name,13,10) 
gsort -batch
replace batch=batch[_n-1] if batch==""

gen batch_url=substr(name, -12,8)

keep if batch_url==batch
drop if name==""
*************turn off next line if running this do file on a date different than the date the html files were created***
*drop if filenamedate!=file_date
drop batch batch_url

gen namebatch=substr(name,-12,8)

gen key = subcategory + namebatch

keep key archivo_list2
order key archivo_list2

sort key

save sc_list2_urls.dta, replace


clear

cd "C:\Users\roytl\Stata to Python"

import delimited using sc_s3_urllist_htmlfiles.csv, varnames(1)

split name, p(_)

gen subcat_code = subinstr(name2, "contexto", "", .)

replace archivo_html = subinstr(archivo_html, " ", "", .)

cd "C:\Bossa Nova\audiototext\sc\Do Files"


do subcat_code_to_cat_code.do
do subcat_code_to_subcategory_sc_agencias.do
do cat_code_to_category_sc_agencias.do

drop subcat_code cat_code name1 name2 name3

cd "C:\Users\roytl\Stata to Python"

******************change fecha_update to current date*****************************
local mmddaaaa : di %tdNN/DD/CCYY date(c(current_date), "DMY")
di "`mmddaaaa'"

gen fecha_update="`mmddaaaa'"

display %tdNN_CCYY date(c(current_date), "DMY")

local aaaammdd : di %tdCCYY-NN-DD date(c(current_date), "DMY")
di "`aaaammdd'"

gen file_date="`aaaammdd'"

***Turn off next line if running this do file on a date different than the date the html files were created****
*keep if strpos(archivo_html, "`aaaammdd'")

append using batchname_html_cat.dta

gen filenamedate=substr(name,13,10) 
gsort -batch
replace batch=batch[_n-1] if batch==""

gen batch_url=substr(name, -13,8)

keep if batch_url==batch
****************Turn off this next line if running this do file on a date different than the date the html files were created***
*drop if filenamedate!=file_date

drop if name==""
drop if archivo_html==""
drop batch batch_url

************new code to merge with list2 url file***********
gen namebatch=substr(name,-13,8)

gen key = subcategory + namebatch

sort key

merge m:1 key using sc_list2_urls

drop _merge key namebatch file_date filenamedate

order archivo_html fecha_update category subcategory name archivo_list2


export delimited using agencias_htmlfiles.csv, delimiter (",") replace datafmt q

exit, STATA clear


