***RLudwig**************************
********new do file prepared on July 5, 2018 to automatically process files on AWS EC2 Windows instance*********************
***May 3 2018 changed the list of files in payment db to match list from payment db do file*****************************
*****************************THIS DO FILE IS STEP 1 IN PAYMENT PROCESSING*******************************************************

clear

display %tdNN_CCYY date(c(current_date), "DMY")

local mesyr : di %tdNN_CCYY date(c(current_date), "DMY")
di "`mesyr'"

local msyrnospc : di %tdNNCCYY date(c(current_date), "DMY")
di "`msyrnospc'"

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\fd"
local drive = "`mesyr'"
cd "`drive'"
**********create macro variable to be used as date stamp in filenames*****************************
local DDMONCCYY : di %tdDD_Mon_CCYY date(c(current_date), "DMY")
di "`DDMONCCYY'"
local today = subinstr("`DDMONCCYY'", " ", "_", .)
display "`today'"

**********create macro variable to be used as date stamp in output file fixed width*****************************
local aaaammdd : di %tdCCYYNNDD date(c(current_date), "DMY")
di "`aaaammdd'"


local dymonyr : di %tdDDNNCCYY date(c(current_date), "DMY")
di "`dymonyr'"

local c_time= c(current_time)
display "`c_time'"
local time= subinstr("`c_time'", ":", "_", .)
display "`time'"

log using fd_production_processing_`today'-`time'.log, replace

! del trigfile.txt

*********************END OF AUTOMATED DIRECTORY AND PATH CODE *******************
! dir fisv*.txt /a-d /b >filelist.txt, replace

infix str filename 1-40 using filelist.txt
count
gen ext=substr(filename,-3,.)
replace filename=subinstr(filename,".txt","",.)

keep filename 
local N=_N

forvalues i=1/`N' {
   preserve
   local name=filename[`i']
   infix str orgcta 1-3 ///
	str  classe 4-6 ///
	str  orgcms 7-9 ///
	str  numcta 10-28 ///
	str  account 29-47 ///
	str  telres 88-100 ///
	str  celular 101-113 ///
	str  telcom 114-126 ///
	str  telref1 127-139 ///
	str  telref2 140-152 ///
	str  telpdv 153-165 ///
	str  telloc 166-178 ///
	str  diavenc 179-180 ///
	str  sinsaldo 181 ///
	str  vlrsaldo 182-198 ///
	str  statacor 199 ///
	str  nuorgcli 200-202 ///
	str  codlog 203-205 ///
	str  behavsco 206-210 ///
	str  dtanasc 211-218 ///
	str  cpfstr 221-235 ///
	str  cep 236-243 ///
	str  idsist 244 ///
	str  flagtel 245 ///
	str  lojacad 246-248 ///
	str  ultacao 249-252 ///
	str  uf 283-284 ///
	str  diaatraso 285-287 ///
	str  nomlista 288-295 ///
	str  telad1 296-308 ///
	str  telad2 309-321 ///
	using `name'.txt, clear
   save "`name'.dta", replace
   restore
}


********** *****************************
*********************************************first get placement date from filename****************************
clear

log using "datasets.log", name(log2) text replace
ls fisv*.dta
log close log2


infix 8 first 1 lines 1: str size 1-8 str time 11-25 str filename 26-60 using datasets.log
gen ext=substr(filename,-3,.)
drop if ext!="dta"
gen datareceb=substr(filename,-8,4)

keep filename datareceb
local N=_N

forvalues i=1/`N' {
   preserve
   local name=filename[`i']
   local data_receb=datareceb[`i']
   use "`name'", clear
   gen datarecebimento="`data_receb'"
   save "`name'", replace
   cd Previous
   save "`name'", replace
   restore
}
*************************now compile the dta files ******************************

clear

! dir fisv*.dta /a-d /b >dtafilelist.txt, replace

file open dtafiles using dtafilelist.txt, read
file read dtafiles line

use `line'
save fd_p2_001_carga_`msyrnospc', replace
file read dtafiles line

while r(eof)==0 {
	append using `line'
	file read dtafiles line
}
file close dtafiles
save fd_p2_001_carga_`msyrnospc', replace

**********************************create subfile with numcta and cpfstr for payments merge for bnss payments db***

clear
use fd_p2_001_carga_`msyrnospc'

preserve
keep numcta cpfstr
rename cpfstr cpf
sort numcta
save fd_p2_carga_001_`msyrnospc'_cpfacct.dta, replace
restore
*/
******************************************************************************************************************************************
cd "C:\Bossa Nova\collections agency models\fd\Payments"

**************************move payment files from ftp to current drive**************
! move /Y "C:\Filezilla\Clients\FIS\Input\AR0O04_LPAR*.TXT"
! move /Y "C:\Filezilla\Clients\FIS\Input\AR0O04_202*.TXT"

clear
! dir AR0O04_*.TXT /a-d /b >arfilelist.txt, replace

infix str filename 1-50 using arfilelist.txt
count
gen ext=substr(filename,-3,.)
replace filename=subinstr(filename,".TXT","",.)

keep filename 
local N=_N

forvalues i=1/`N' {
   preserve
   local name=filename[`i']
   infix 19 first str numcta 1-19 ///
	str  eff_date 21-28 ///
	str  txn_lm 30-35 ///
	str  trans_desc 37-50 ///
	str  amount 52-62 ///
	str  sign 63 ///
	using `name'.TXT, clear
	drop if numcta==""
	gen byte notnumericcta = real(numcta)==.
drop if notnumericcta==1
drop notnumericcta
	keep if sign=="-"
	gen lm=substr(txn_lm, 5,2)
	gen txn=substr(txn_lm,1,3)
	keep if lm=="30"
	drop if inlist(txn,"132","136","098")
	count
	rename eff_date datapagamento
	keep numcta datapagamento amount
	destring amount, replace dpcomma force
	drop if amount==.
   save "`name'.dta", replace
   restore
   }

   
   cd "C:\Bossa Nova\collections agency models\fd\Payments\Previous"
   ******************move a file to current directory and overwrite*****************
! move  /Y "C:\Bossa Nova\collections agency models\fd\Payments\AR0O04_*.TXT"


   cd "C:\Bossa Nova\collections agency models\fd\Payments"
   
*************************now compile the dta files ******************************

clear

! dir AR0O04_*.dta /a-d /b >ardtafiles.txt, replace

file open dtafiles using ardtafiles.txt, read
file read dtafiles line

use `line'
save fd_payments_nocpf, replace
file read dtafiles line

while r(eof)==0 {
	append using `line'
	file read dtafiles line
}
file close dtafiles
sort numcta
save fd_payments_nocpf, replace

clear

cd "C:\Bossa Nova\collections agency models\fd\01 2020\Previous"
use fd_p2_carga_001_012020_cpfacct


cd "C:\Bossa Nova\collections agency models\fd\Payments"

bysort numcta: keep if _n==1
save fd_p2_carga_2020_cpfacct.dta, replace


clear
use fd_p2_carga_2019_cpfacct
append using fd_p2_carga_2020_cpfacct
bysort numcta: keep if _n==1
save fd_p2_carga_2019_2020_cpfacct.dta,replace

**************************************************************************************************************************************************
use fd_payments_nocpf.dta, clear

count
sort numcta

merge m:1 numcta using fd_p2_carga_2019_2020_cpfacct.dta
tab _merge

preserve
keep if _merge==1
sort numcta
save fd_payments_cpf_notfound.dta, replace
restore

keep if _merge==3
rename cpf Col2
destring Col2, replace
gen month_fp=substr(datapagamento, 4,2)
gen day_fp=substr(datapagamento, 1,2)
gen year_end=substr(datapagamento, 7,2)
gen year_beg="20"
egen year=concat(year_beg year_end)

gen Col3=year+"-"+month_fp+"-"+day_fp
rename amount Col4

keep Col2 Col3 Col4
order Col2 Col3 Col4
save pagos_fd_p2_cpf_db.dta, replace

****************************fd P2****************************************
clear

cd "C:\Bossa Nova\collections agency models\fd\Payments"

use pagos_fd_p2_cpf_db

duplicates drop

gen year_fp=substr(Col3,1,4)
gen month_fp=substr(Col3,6,2)
gen day_fp=substr(Col3,9,2)

destring month_fp, replace
destring day_fp, replace
destring year_fp, replace

gen fecha_de_pago=mdy(month_fp,day_fp,year_fp)
tab month_fp year_fp 

format fecha_de_pago %td

gsort Col2 -fecha_de_pago
bysort Col2: keep if _n==1

gen Col1="fd"
gen Col5="bd_P2"

keep Col1 Col2 Col3 Col4 Col5
order Col1 Col2 Col3 Col4 Col5
count

cd "C:\Bossa Nova\collections agency models\Censo"
**************************************************

save fd_p2_active.dta, replace

*************************now compile the dta files ******************************
clear

! del fddtafiles.txt
! dir fd_bd_newmerge_*.dta /a-d /b >fddtafiles.txt, replace

file open dtafiles using fddtafiles.txt, read
file read dtafiles line

use `line'
save fd_pmnts_compiled_newmerge, replace
file read dtafiles line

while r(eof)==0 {
	append using `line'
	file read dtafiles line
}
file close dtafiles

gen Col1="fd"
gen Col5="bd_P2"

keep Col1 Col2 Col3 Col4 Col5
order Col1 Col2 Col3 Col4 Col5
count

gen pmntyr=substr(Col3, 1,4)
destring pmntyr, replace
drop if pmntyr<=2017
drop pmntyr

save fd_pmnts_compiled_newmerge, replace

***********************************Consolidated clients and portfolios**********
clear


use pmnt_base_rbrasil_active
append using fd_p2_active.dta
append using fd_pmnts_compiled_newmerge
append using pmnts_fis_eavm_active

rename Col1 agency
rename Col2 cpf
rename Col3 datapagcons
rename Col4 valorpagcons
rename Col5 portfolio

format %014.0f cpf
format %10s datapagcons
format %9.2f valorpagcons
drop if cpf==00000000000000
**********create text file for use in ACCESS******************************
*outsheet using payments_active.txt, delimiter (";") replace

***** Compile the payments ******************************
gen year_fp=substr(datapagcons,1,4)
gen month_fp=substr(datapagcons,6,2)
gen day_fp=substr(datapagcons,9,2)

destring month_fp, replace
destring day_fp, replace
destring year_fp, replace

gen fecha_de_pago=mdy(month_fp,day_fp,year_fp)
tab month_fp year_fp 

format fecha_de_pago %td
drop month_fp day_fp year_fp datapagcons
rename fecha_de_pago datapgcons

********** create macro variable to be used as date stamp in filenames*****************************
local c_date = c(current_date)
display "`c_date'"

**** this next section creates automatic macro variable for todays date to be used in determining age of debtor (in combo with birthdate variable).*****
gen hoy= "`c_date'"
display hoy
gen hoje=date(hoy, "DMY") 
display hoje

gen dssncpmnt=hoje-datapgcons

bysort cpf: egen monto_pago_cons=total(valorpagcons)
keep if monto_pago_cons>0

bysort cpf: egen lastdate=max(datapgcons)
format %td lastdate
bysort cpf: keep if _n==1
count

**************drop if most recent payment is >270****************
drop if dssncpmnt>270
*****************************************************************
count
preserve
drop datapgcons
rename lastdate datapgcons
keep agency cpf valorpagcons portfolio datapgcons monto_pago_cons
order agency cpf valorpagcons portfolio datapgcons monto_pago_cons
save Payments_active_allagencies.dta, replace
restore

***********************************now update separate file that can be used to cross numcta with other portfolios**********************************************************
clear

cd "C:\Bossa Nova\collections agency models\fd\Payments"

use fd_payments_cpf_notfound.dta

gen month_fp=substr(datapagamento, 4,2)
gen day_fp=substr(datapagamento, 1,2)
gen year_end=substr(datapagamento, 7,2)
gen year_beg="20"
egen year_fp=concat(year_beg year_end)
gen Col3=year_fp+"-"+month_fp+"-"+day_fp
destring month_fp, replace
destring day_fp, replace
destring year_fp, replace

gen fecha_de_pago=mdy(month_fp,day_fp,year_fp)
tab month_fp year_fp 

format fecha_de_pago %td
drop month_fp day_fp year_fp datapagamento
rename fecha_de_pago datapgcons

**** this next section creates automatic macro variable for todays date to be used in determining age of debtor (in combo with birthdate variable).*****
********** create macro variable to be used as date stamp in filenames*****************************
local c_date = c(current_date)
display "`c_date'"


gen hoy= "`c_date'"
display hoy
gen hoje=date(hoy, "DMY") 
display hoje

gen dssncpmntcta=hoje-datapgcons


gen agencycta="fd"
gen portfoliocta="bd"

bysort numcta: egen monto_pago_cons_cta=total(amount)
keep if monto_pago_cons>0

bysort numcta: egen lastdate=max(datapgcons)
format %td lastdate
gsort numcta -lastdate
bysort numcta: keep if _n==1
count

cd "C:\Bossa Nova\collections agency models\Censo"

keep numcta dssncpmntcta agencycta portfoliocta monto_pago_cons_cta Col3
save fd_payments_nocpf_forothermerges.dta, replace

clear


display %tdNN_CCYY date(c(current_date), "DMY")

local mesyr : di %tdNN_CCYY date(c(current_date), "DMY")
di "`mesyr'"

local msyrnospc : di %tdNNCCYY date(c(current_date), "DMY")
di "`msyrnospc'"

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\fd"
local drive = "`mesyr'"
cd "`drive'"
**********create macro variable to be used as date stamp in filenames*****************************
local DDMONCCYY : di %tdDD_Mon_CCYY date(c(current_date), "DMY")
di "`DDMONCCYY'"
local today = subinstr("`DDMONCCYY'", " ", "_", .)
display "`today'"

**********create macro variable to be used as date stamp in output file fixed width*****************************
local aaaammdd : di %tdCCYYNNDD date(c(current_date), "DMY")
di "`aaaammdd'"


local dymonyr : di %tdDDNNCCYY date(c(current_date), "DMY")
di "`dymonyr'"

local c_time= c(current_time)
display "`c_time'"
local time= subinstr("`c_time'", ":", "_", .)
display "`time'"

*****************************************************************************************************************************88
***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\fd"
local drive = "`mesyr'"
cd "`drive'"
cd Previous

clear
use fd_p2_001_carga_`msyrnospc'
count

*** this next section creates automatic macro variable for todays date to be used in determining age of debtor (in combo with birthdate variable).*****
gen hoy= "`c_date'"
display hoy
gen hoje=date(hoy, "DMY") 
display hoje


drop sinsaldo idsist flagtel lojacad
gen cpfnum=cpfstr
destring vlrsaldo behavsco cpfnum, replace
replace vlrsaldo=vlrsaldo/100
format %014.0f cpfnum


sort numcta diaatraso
bysort numcta: keep if _n==1


**** Format Data de entrada *****************
gen dia_asig=substr(datarecebimento,1,2)
gen mes_asig=substr(datarecebimento,3,2)
gen ano_asig="2020"
egen mesasig=concat(ano_asig mes_asig)
destring dia_asig - ano_asig, replace 
gen dataasig=mdy(mes_asig,dia_asig,ano_asig)
format dataasig %td
drop dia_asig mes_asig ano_asig 
tab mesasig

*******************************classe****************************

gen clas08=0
replace clas08=1 if classe=="008"
gen clas26=0
replace clas26=1 if classe=="026"
gen clas43=0
replace clas43=1 if classe=="043"
gen clas47=0
replace clas47=1 if classe=="047"
gen clas51=0
replace clas51=1 if classe=="051"
gen clas116=0
replace clas116=1 if classe=="116"
gen clas117=0
replace clas117=1 if classe=="117"
gen clas118=0
replace clas118=1 if classe=="118"
gen clas71=0
replace clas71=1 if classe=="071"
gen clas48=0
replace clas48=1 if classe=="048"
gen clas50=0
replace clas50=1 if classe=="050"
gen clas72=0
replace clas72=1 if classe=="072"
gen clas110=0
replace clas110=1 if classe=="110"
drop classe
************************statacor********************************************
gen stat0=0
replace stat0=1 if statacor=="0"
gen stat3=0
replace stat3=1 if statacor=="3"
gen stat7=0
replace stat7=1 if statacor=="7"
gen stat8=0
replace stat8=1 if statacor=="8"
gen stata=0
replace stata=1 if statacor=="A"
gen statb=0
replace statb=1 if statacor=="B"
gen statd=0
replace statd=1 if statacor=="D"
gen stati=0
replace stati=1 if statacor=="I"
gen statk=0
replace statk=1 if statacor=="K"
drop statacor


*******orgcta*******************
gen org1=0
replace org1=1 if orgcta=="001"
gen org23=0
replace org23=1 if orgcta=="023"
gen org24=0
replace org24=1 if orgcta=="024"
gen org33=0
replace org33=1 if orgcta=="033"
gen org34=0
replace org34=1 if orgcta=="034"
gen org38=0
replace org38=1 if orgcta=="038"
gen org40=0
replace org40=1 if orgcta=="040"
gen org46=0
replace org46=1 if orgcta=="046"
gen org57=0
replace org57=1 if orgcta=="057"
gen org59=0
replace org59=1 if orgcta=="059"
gen org74=0
replace org74=1 if orgcta=="074"
gen org76=0
replace org76=1 if orgcta=="076"
gen org79=0
replace org79=1 if orgcta=="079"
gen org89=0
replace org89=1 if orgcta=="089"
gen org91=0
replace org91=1 if orgcta=="091"
gen org94=0
replace org94=1 if orgcta=="094"
gen org102=0
replace org102=1 if orgcta=="102"



**********************orgcms********************************
gen cms10=0
replace cms10=1 if orgcms=="010"
gen cms11=0
replace cms11=1 if orgcms=="011"
gen cms13=0
replace cms13=1 if orgcms=="013"
gen cms33=0
replace cms33=1 if orgcms=="033"
gen cms38=0
replace cms38=1 if orgcms=="038"
gen cms44=0
replace cms44=1 if orgcms=="044"
gen cms46=0
replace cms46=1 if orgcms=="046"
gen cms52=0
replace cms52=1 if orgcms=="052"
gen cms53=0
replace cms53=1 if orgcms=="053"
gen cms59=0
replace cms59=1 if orgcms=="059"
gen cms74=0
replace cms74=1 if orgcms=="074"
gen cms77=0
replace cms77=1 if orgcms=="077"
gen cms79=0
replace cms79=1 if orgcms=="079"
gen cms89=0
replace cms89=1 if orgcms=="089"
gen cms91=0
replace cms91=1 if orgcms=="091"
gen cms102=0
replace cms102=1 if orgcms=="102"


gen segment="Other"
replace segment="TR" if orgcta=="001" | orgcta=="003" | orgcta=="004" | orgcta=="021" | orgcta=="022" | orgcta=="023" | orgcta=="024"
replace segment="TR" if orgcta=="026" | orgcta=="031" | orgcta=="032" | orgcta=="033" | orgcta=="034" | orgcta=="063" 
replace segment="TR" if orgcms=="010" | orgcms=="011" | orgcms=="013" | orgcms=="017"
replace segment="Parceiros" if orgcta=="006" | orgcta=="009" | orgcta=="038" | orgcta=="040" | orgcta=="046" | orgcta=="047" | orgcta=="048"
replace segment="Parceiros" if orgcta=="049" | orgcta=="055" | orgcta=="056" | orgcta=="057" | orgcta=="058" | orgcta=="059" | orgcta=="062"
replace segment="Parceiros" if orgcta=="067" | orgcta=="070" | orgcta=="074" | orgcta=="076" | orgcta=="079" | orgcta=="080" | orgcta=="081"
replace segment="Parceiros" if orgcta=="089" | orgcta=="091" | orgcta=="094" | orgcta=="096" | orgcta=="097" | orgcta=="102" | orgcta=="569"
replace segment="Parceiros" if orgcms=="020" | orgcms=="027" | orgcms=="030" | orgcms=="032" | orgcms=="033" | orgcms=="034" | orgcms=="036"
replace segment="Parceiros" if orgcms=="038" | orgcms=="044" | orgcms=="046" | orgcms=="047" | orgcms=="048" | orgcms=="049" | orgcms=="052"
replace segment="Parceiros" if orgcms=="053" | orgcms=="055" | orgcms=="057" | orgcms=="059" | orgcms=="062" | orgcms=="063" | orgcms=="067"
replace segment="Parceiros" if orgcms=="072" | orgcms=="074" | orgcms=="077" | orgcms=="079" | orgcms=="081" | orgcms=="089" | orgcms=="091"
replace segment="Parceiros" if orgcms=="072" | orgcms=="074" | orgcms=="077" | orgcms=="079" | orgcms=="081" | orgcms=="089" | orgcms=="091"
replace segment="Parceiros" if orgcms=="102" | orgcms=="569" 
tab segment

gen goodorgs=0
replace goodorgs=1 if cms33==1 | cms74==1 | cms77==1 | cms79==1 | cms89==1 | cms91==1
gen badorgs=0
replace badorgs=1 if cms44==1 | cms52==1 | cms53==1 | cms59==1

gen visint=0
replace visint=1 if orgcms=="013" & codlog=="030"

*****************************phones****************************
replace celular="" if celular=="X"
gen qtdcel=0
replace qtdcel=1 if celular!=""
drop celular
replace telres="" if telres=="X"
gen t1=0
replace t1=1 if telres!=""
drop telres
replace telcom="" if telcom=="X"
gen t2=0
replace t2=1 if telcom!=""
drop telcom
replace telref1="" if telref1=="X"
gen t3=0
replace t3=1 if telref1!=""
drop telref1
replace telref2="" if telref2=="X"
gen t4=0
replace t4=1 if telref2!=""
drop telref2
replace telpdv="" if telpdv=="X"
gen t5=0
replace t5=1 if telpdv!=""
drop telpdv
replace telloc="" if telloc=="X"
gen t6=0
replace t6=1 if telloc!=""
drop telloc
replace telad1="" if telad1=="X"
gen t7=0
replace t7=1 if telad1!=""
drop telad1
replace telad2="" if telad2=="X"
gen t8=0
replace t8=1 if telad2!=""
drop telad2

********************nuorgcli********************************
gen nuor1=0
replace nuor1=1 if  nuorgcli=="001"
gen nuor6=0
replace nuor6=1 if  nuorgcli=="006"
gen nuor8=0
replace nuor8=1 if  nuorgcli=="008"
gen nuor37=0
replace nuor37=1 if  nuorgcli=="037"
gen nuor43=0
replace nuor43=1 if  nuorgcli=="043"
gen nuor51=0
replace nuor51=1 if  nuorgcli=="051"
gen nuor58=0
replace nuor58=1 if  nuorgcli=="058"
gen nuor73=0
replace nuor73=1 if  nuorgcli=="073"
gen nuor76=0
replace nuor76=1 if  nuorgcli=="076"
gen nuor78=0
replace nuor78=1 if  nuorgcli=="078"
gen nuor88=0
replace nuor88=1 if  nuorgcli=="088"
gen nuor90=0
replace nuor90=1 if  nuorgcli=="090"
gen nuor101=0
replace nuor101=1 if  nuorgcli=="101"
drop nuorgcli

************************codlog***************************************
gen codlog10=0
replace codlog10=1 if codlog=="010"
gen codlog20=0
replace codlog20=1 if codlog=="020"
gen codlog22=0
replace codlog22=1 if codlog=="022"
gen codlog30=0
replace codlog30=1 if codlog=="030"
gen codlog33=0
replace codlog33=1 if codlog=="033"
gen codlog40=0
replace codlog40=1 if codlog=="040"
gen codlog44=0
replace codlog44=1 if codlog=="044"
gen codlog70=0
replace codlog70=1 if codlog=="070"

*******************************nascimento*********************************
gen ano_nasc=substr(dtanasc,1,4)
destring ano_nasc, replace
drop dtanasc

gen yrsold=2018-ano_nasc

gen noaction=0
replace noaction=1 if ultacao==""
gen agen=0
replace agen=1 if ultacao=="AGEN"
gen brkn=0
replace brkn=1 if ultacao=="BRKN"
gen lmud=0
replace lmud=1 if ultacao=="LMUD"
gen ppgt=0
replace ppgt=1 if ultacao=="PPGT"
gen rcom=0
replace rcom=1 if ultacao=="RCOM"
gen recp=0
replace recp=1 if ultacao=="RECP"
gen rref=0
replace rref=1 if ultacao=="RREF"
gen rres=0
replace rres=1 if ultacao=="RRES"
gen vlc=0
replace vlc=1 if ultacao=="VLC"


*******************Merge with BNSS Payment DB ****************************************
cd "C:\Bossa Nova\collections agency models\Censo"
destring cep, replace force
sort cep

merge m:1 cep using cepbr_excel.dta
tab _merge
drop if _merge==2
drop _merge

*****now merge with IBGE file to obtain additional demographic variables*****
sort cidade

merge m:m cidade uf using Censo2010.dta
tab _merge
drop _merge

*****Now derive some new variables from census dataset*************8
replace PIB_PER_CAPiTA_PRECOS_CORRENTES=25000 if PIB_PER_CAPiTA_PRECOS_CORRENTES==.
gen balpib=vlrsaldo/PIB_PER_CAPiTA_PRECOS_CORRENTES
gen percalpha=POP_RESID_ALFABETIZADA/POPULACAO_RESIDENTE
gen percevang=POP_RESID_EVANGELICA/POPULACAO_RESIDENTE
gen perccatol=POP_RESID_CATOLICA/POPULACAO_RESIDENTE
gen peresperita=POP_RESID_ESPIRITA/POPULACAO_RESIDENTE

rename PIB_PER_CAPiTA_PRECOS_CORRENTES pib
drop POP_RESID_MULHERES POP_RESID_FREQUENTAVA_CRECHE_ESC REND_NOMINAL_DOMIC_RURAL REND_NOMINAL_DOMIC_URBANA REND_NOMINAL_PER_CAPITA_RURAL REND_NOMINAL_PER_CAPITA_URBANA
drop if cpfstr==""


bysort cpfnum: keep if _n==1
format %014.0f cpfnum
rename cpfnum cpf
merge 1:1 cpf using Payments_active_allagencies
tab _merge
drop if _merge==2
drop _merge

drop cpf

**************************************new code to include merge by numcta with additional fd payment file info*****
sort numcta
merge m:m numcta using fd_payments_nocpf_forothermerges
tab _merge
drop if _merge==2
tab _merge
gen newpickup=0
replace newpickup=1  if agency=="" & _merge==3
replace agency=agencycta if agency=="" & _merge==3
replace portfolio=portfoliocta if portfolio=="" & _merge==3
replace monto_pago_cons=monto_pago_cons_cta if monto_pago_cons==. & _merge==3

gen dslstconspg=dataasig-datapgcons
replace dslstconspg=dssncpmntcta if dslstconspg==. & _merge==3

preserve
keep if newpickup==1
count

rename cpf Col2
rename monto_pago_cons Col4
destring Col2, replace
format %011.0f Col2
keep Col2 Col3 Col4
save fd_bd_newmerge_p2_`today'.dta, replace
restore
drop _merge agencycta portfoliocta monto_pago_cons_cta dssncpmntcta
********************************************************************************************************************************

gen conspag=0
replace conspag=1 if datapgcons!=.
tab conspag
gen conspag2=0
replace conspag2=1 if conspag==1 & dslstconspg<360
tab conspag2
gen conspag3=0
replace conspag3=1 if conspag==1 & dslstconspg<180
tab conspag3
gen conspag4=0
replace conspag4=1 if conspag==1 & dslstconspg<90
tab conspag4
tab portfolio if conspag3==1
***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\fd"
local drive = "`mesyr'"
cd "`drive'"
******************END OF AUTOMATED DIRECTORY AND PATH CODE *******************

destring diaatraso, replace

gen fonos=t1+ t2+ t3+ t4+ t5+ t6+ t7+ t8

rename cpfstr cpf


replace percalpha=0.85 if percalpha==.
replace peresperita=0.0232 if peresperita==.
replace idhm=0.75 if idhm==.

gen young=0
replace young=1 if yrsold<25
gen old=0
replace old=1 if yrsold>55


gen lowfon=0
replace lowfon=1 if fonos<=3


*** Lets look at UF variable****MG PE RJ SP RS BA PR**********
gen sp1=0
replace sp1=1 if uf=="SP"
gen mg1=0 
replace mg1=1 if uf=="MG"
gen pe1=0
replace pe1=1 if uf=="PE"
gen rj1=0
replace rj1=1 if uf=="RJ"
gen ba1=0
replace ba1=1 if uf=="BA"
gen pr1=0
replace pr1=1 if uf=="PR"
gen al1=0
replace al1=1 if uf=="AL"
gen am1=0
replace am1=1 if uf=="AM"
gen ce1=0
replace ce1=1 if uf=="CE"
gen df1=0
replace df1=1 if uf=="DF"
gen go1=0
replace go1=1 if uf=="GO"
gen ma=0
replace ma=1 if uf=="MA"
gen ms1=0
replace ms1=1 if uf=="MS"
gen pi1=0
replace pi1=1 if uf=="PI"
gen rs1=0
replace rs1=1 if uf=="RS"
gen sc1=0
replace sc1=1 if uf=="SC"
gen se=0
replace se=1 if uf=="SE"
gen pa=0
replace pa=1 if uf=="PA"
gen mt=0
replace mt=1 if uf=="MT"

gen badstates=0
replace badstates=1 if am1==1 | ba1==1 | ce1==1
gen goodstates=0
replace goodstates=1 if df1==1 | go1==1 | pr1==1 | rs1==1 | sc1==1 | sp1==1

gen hibal=0
replace hibal=1 if vlrsaldo>1000



gen new_valor_divida_acum=vlrsaldo

gen pettybal=0

preserve
keep if segment=="TR"
count

gen bucket=0
replace bucket=1 if diaatraso<30
replace bucket=2 if diaatraso>=30 & diaatraso<60
replace bucket=3 if diaatraso>=60 & diaatraso<90
replace bucket=4 if diaatraso>=90
tab bucket

replace new_valor_divida_acum=800 if new_valor_divida_acum>800 & bucket<=2
replace new_valor_divida_acum=1300 if vlrsaldo>1300 & bucket>2

*********for second iteration on goodpmnt definition (v6) lowered pettybal amount from 100 to 50***
replace pettybal=1 if vlrsaldo<=50 & bucket<=2
replace pettybal=1 if vlrsaldo<=100 & bucket>2


save base_tr.dta, replace
restore


preserve
keep if segment=="Parceiros"

replace new_valor_divida_acum=1600 if vlrsaldo>1600
replace pettybal=1 if vlrsaldo<=100

destring diavenc, replace
gen goodvenc=0
replace goodvenc=1 if diavenc>=27
gen badvenc=0
replace badvenc=1 if diavenc<=15

gen FISPBK1=0
replace FISPBK1=1 if nomlista=="FISPBK1"

count
save base_parceiros.dta, replace
restore

**********ALGORITHIM  BUCKET 1 *******************************************************
clear
use base_tr.dta

preserve
keep if bucket==1
count
gen scrgdpmnt=1/(1+exp(-(-0.4110356*noaction+0.658408*conspag3-0.2071*young-0.0443698*lowfon-0.1628694*badstates+0.0013056*behavsco+0.1880098*cms13-1.043328*clas71-0.1241675*clas08+0.731169*clas116-0.3458277*stat0-0.0749177*statd-0.0292793*goodstates+0.1142091*old-0.0414354*diaatraso-1.745812*pettybal+0.586054)))		
		 							 				 								 						 		 					  		 										   		
gen score=scrgdpmnt*scrgdpmnt*new_valor_divida_acum
drop if scrgdpmnt==.

*******generate four equal groups***************************************

gsort -score
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(4)
gen grupobf="Alta" if groups_score2==1
replace grupobf="Media Alta" if groups_score2==2
replace grupobf="Media" if groups_score2==3
replace grupobf="Baixa" if groups_score2==4
tab grupobf


keep numcta cpf vlrsaldo bucket segment orgcms orgcta behavsco score dataasig grupobf diaatraso
save internal_score_fd_p2_b1_`msyrnospc'_`today'-`time'.dta, replace
restore

**********ALGORITHIM BUCKET 2 *******************************************************
preserve 
keep if bucket==2
count
gen scrgdpmnt=1/(1+exp(-(-0.4758566*noaction+1.586329*conspag3-0.2175794*young+0.0827681*lowfon-0.2847787*badstates+0.0056588*behavsco+0.1164932*cms13-1.729143*clas71-0.1565325*clas08+1.578565*clas116-0.5878367*stat0+0.1465372*statd-0.1136715*goodstates+0.1214379*old-0.0283171*diaatraso-0.8623287*pettybal+0.0000568*vlrsaldo-1.314151)))		
			 		 					  		 										   		
gen score=scrgdpmnt*scrgdpmnt*new_valor_divida_acum
drop if scrgdpmnt==.

*******generate four equal groups***************************************

gsort -score
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(4)
gen grupobf="Alta" if groups_score2==1
replace grupobf="Media Alta" if groups_score2==2
replace grupobf="Media" if groups_score2==3
replace grupobf="Baixa" if groups_score2==4
tab grupobf

keep numcta cpf vlrsaldo bucket segment orgcms orgcta behavsco score dataasig grupobf diaatraso
save internal_score_fd_p2_b2_`msyrnospc'_`today'-`time'.dta, replace
restore

**********ALGORITHIM BUCKET 3 *******************************************************
preserve
keep if bucket==3
count
gen scrgdpmnt=1/(1+exp(-(-0.3438381*noaction+2.11159*conspag3-0.1842006*young+0.1324707*lowfon-0.3037816*badstates+0.0103504*behavsco+0.1112296*cms13-2.433766*clas71-0.4302483*clas08+1.776892*clas116-0.5358145*stat0+0.4558605*statd-0.0683436*goodstates+0.1479173*old-0.0341371*diaatraso-0.6392883*pettybal+0.0000334*vlrsaldo-2.67595)))		
gen score=scrgdpmnt*scrgdpmnt*new_valor_divida_acum
drop if scrgdpmnt==.


gsort -score
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(4)
gen grupobf="Alta" if groups_score2==1
replace grupobf="Media Alta" if groups_score2==2
replace grupobf="Media" if groups_score2==3
replace grupobf="Baixa" if groups_score2==4
tab grupobf

keep numcta cpf vlrsaldo bucket segment orgcms orgcta behavsco score dataasig grupobf diaatraso
save internal_score_fd_p2_b3_`msyrnospc'_`today'-`time'.dta, replace
restore

**********ALGORITHIM BUCKET 4 *******************************************************
preserve
keep if bucket==4
count
gen scrgdpmnt=1/(1+exp(-(-0.4281052*pettybal+0.0441216*fonos+0.1070911*old-0.1613711*young+1.313925*conspag2+0.83677*statk+0.335376*stat8-0.2956748*stat0+0.5770615*clas116+0.5032578*clas110-4.033476*clas72-0.3335877*clas50-0.6281263*clas48-0.024012*diaatraso-0.3082473*badstates-0.0757573*goodstates+0.3119144*brkn-0.6326211*noaction+0.0028533*behavsco-0.8924758*org1+0.6501229)))		
gen score=scrgdpmnt*scrgdpmnt*new_valor_divida_acum
drop if scrgdpmnt==.

gsort -score
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(4)
gen grupobf="Alta" if groups_score2==1
replace grupobf="Media Alta" if groups_score2==2
replace grupobf="Media" if groups_score2==3
replace grupobf="Baixa" if groups_score2==4
tab grupobf


keep numcta cpf vlrsaldo bucket segment orgcms orgcta behavsco score dataasig grupobf diaatraso
save internal_score_fd_p2_b4_`msyrnospc'_`today'-`time'.dta, replace
restore

*TURNED ON MARCH 8 2018 TO IMPLEMENT NEW OPTIMIZED ALGORITHIM******THIS IS NEW OPTIMIZED*ALGORITHIM Parceiros*******************************************************
clear
use base_parceiros.dta

gen scrgdpmnt=1/(1+exp(-(-1.300697*pettybal+0.1887199*hibal+0.6804911*balpib+0.8689945*conspag3+0.3030918*clas116-1.381403*clas51-0.5524732*clas43-0.2495934*clas26+0.7157201*statk-0.6306058*stat0+0.1937657*FISPBK1-0.0153859*diaatraso-0.711068*noaction+0.0022625*behavsco-0.1815113*codlog33-0.152849*badvenc+0.4731114*org91+0.0816803)))		
gen score=scrgdpmnt*scrgdpmnt*new_valor_divida_acum
drop if scrgdpmnt==.

preserve

gsort -score
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(4)
gen grupobf="Alta" if groups_score2==1
replace grupobf="Media Alta" if groups_score2==2
replace grupobf="Media" if groups_score2==3
replace grupobf="Baixa" if groups_score2==4
tab grupobf

gen bucket=.
keep numcta cpf vlrsaldo bucket segment orgcms orgcta behavsco score dataasig grupobf diaatraso
save internal_score_fd_p2_parceiros_`msyrnospc'_`today'-`time'.dta, replace
restore


***************************NEW FIXED FORMAT FILE REQUESTED BY EMAIL FROM IVAN SANTOS (EMAIL CHAIN FROM MILENE DIAS ON OCT 10, 2017)****************************************

clear
use internal_score_fd_p2_b1_`msyrnospc'_`today'-`time'
append using internal_score_fd_p2_b2_`msyrnospc'_`today'-`time'
append using internal_score_fd_p2_b3_`msyrnospc'_`today'-`time'
append using internal_score_fd_p2_b4_`msyrnospc'_`today'-`time'
append using internal_score_fd_p2_parceiros_`msyrnospc'_`today'-`time'

rename numcta numero_contrato
rename diaatraso faixaatraso
rename segment segmento
rename score scorebossanova
rename grupobf grupo

****************************on aug. 18, 2017, fd (luis and danielle) told us their crm field could contain maximum 5 digits (99999)**
******therefore, for their output file, will cap max score at 99998*****************************************
replace scorebossanova=99998 if scorebossanova>99998
format %05.0f scorebossanova

gen tip_reg="1"
format %1s tip_reg
gen cod_siste="00"
format %2s cod_siste
gen dat_movto="`aaaammdd'"
format %8s dat_movto
gen tip_inter="B"
format %1s tip_inter
gen cod_credor="BRAD_P2"
format %8s cod_credor
gen des_regis=cpf
format %30s des_regis
gen cod_produt=""
format %8s cod_produt
gen des_contr=""
format %30s des_contr
gen cod_indicador="SCORE"
format %8s cod_indicador
gen cod_conteudo=grupo
replace cod_conteudo="SCORE_ALTO" if cod_conteudo=="Alta"
replace cod_conteudo="SCORE_MEDIOALTO" if cod_conteudo=="Media Alta"
replace cod_conteudo="SCORE_MEDIO" if cod_conteudo=="Media"
replace cod_conteudo="SCORE_BAIXO" if cod_conteudo=="Baixa"
format %20s cod_conteudo
gen ind_alter="1"
format %1s ind_alter
gen ind_tipo="1"
format %1s ind_tipo
gen des_conteudo=""
format %50s des_conteudo


keep tip_reg cod_siste dat_movto tip_inter cod_credor des_regis cod_produt des_contr cod_indicador cod_conteudo ind_alter ind_tipo des_conteudo
order tip_reg cod_siste dat_movto tip_inter cod_credor des_regis cod_produt des_contr cod_indicador cod_conteudo ind_alter ind_tipo des_conteudo

cd "C:\Bossa Nova\collections agency models\fd\Output Files"
export delimited using fdbody.csv, novarnames nolabel datafmt replace


**********************************now create a trailer row and place in a separate file********************************************
preserve
egen qtd_regnum=count(_n)
tostring qtd_regnum, generate(qtd_reg) format(%08.0f)
keep if _n==1
replace tip_reg="9"
replace cod_siste="99"
gen qtd_reg1="00000000"
gen qtd_reg2="00000000"
gen qtd_reg3="00000000"
gen qtd_reg4="00000000"
gen qtd_reg5="00000000"
gen qtd_reg6="00000000"
gen qtd_reg7="00000000"
gen qtd_reg8="00000000"
gen qtd_reg9="00000000"
gen qtd_regA="00000000"
gen qtd_regB=qtd_reg

************next two variables should have 60 zeros each and the eight in following************************
gen lastvar1="000000000000000000000000000000000000000000000000000000000000"
gen lastvar2="000000000000000000000000000000000000000000000000000000000000"
gen lastvar3="00000000"
keep tip_reg cod_siste dat_movto qtd_reg qtd_reg1 qtd_reg2 qtd_reg3 qtd_reg4 qtd_reg5 qtd_reg6 qtd_reg7 qtd_reg8 qtd_reg9 qtd_regA qtd_regB lastvar1 lastvar2 lastvar3
order tip_reg cod_siste dat_movto qtd_reg qtd_reg1 qtd_reg2 qtd_reg3 qtd_reg4 qtd_reg5 qtd_reg6 qtd_reg7 qtd_reg8 qtd_reg9 qtd_regA qtd_regB lastvar1 lastvar2 lastvar3
export delimited using fdtrailer.csv, novarnames nolabel datafmt replace
restore

*************************now create a header row and place in a separate file****************************************************
preserve
keep if _n==1

replace tip_reg="0"
replace cod_siste="75"
gen dat_proc=dat_movto
gen dat_siste="00000001"
gen ind_movim="MOVIMENTO"
gen cod_seg="00000001"

keep tip_reg cod_siste dat_movto dat_proc cod_seg dat_siste ind_movim
order tip_reg cod_siste dat_movto dat_proc cod_seg dat_siste ind_movim
export delimited using pre_fdheader.csv, datafmt replace
restore

**************************************need to merge with counter file to generate correct cod_seg value*******
clear
import delimited using pre_fdheader.csv
drop cod_seg
gen bogus="1"
merge 1:1 bogus using fd_sequence_variable.dta
tab _merge
gen cod_seg=old_cod_seg+1

**************************now need to update the old_cod_seg number in fd_sequence_variable.dta file*****
preserve
replace old_cod_seg=cod_seg
keep bogus old_cod_seg
save fd_sequence_variable.dta, replace
restore
***********************************************************************************************************
keep if _n==1
gen cod_segstr= string(cod_seg, "%08.0f")
drop cod_seg
rename cod_segstr cod_seg
gen dat_siststr= string(dat_siste, "%08.0f")
drop dat_siste
rename dat_siststr dat_siste
keep tip_reg cod_siste dat_movto dat_proc cod_seg dat_siste ind_movim
order tip_reg cod_siste dat_movto dat_proc cod_seg dat_siste ind_movim
export delimited using fdheader.csv, novarnames nolabel datafmt replace

cd "C:\Bossa Nova\collections agency models\fd\Powershell scripts"
! powershell.exe ./convertcsvtofixedwidth.ps1

************************************************create cut-off files*********************************************************************
***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\fd"
local drive = "`mesyr'"
cd "`drive'"
******************END OF AUTOMATED DIRECTORY AND PATH CODE *******************


clear
use internal_score_fd_p2_b1_`msyrnospc'_`today'-`time'

egen minbfalta=min(score) if grupobf=="Alta"
egen minbfmediaalta=min(score) if grupobf=="Media Alta"
egen maxbfmediaalta=min(score) if grupobf=="Alta"
egen minbfmedia=min(score) if grupobf=="Media"
egen maxbfmedia=min(score) if grupobf=="Media Alta"
egen maxbfbaixa=min(score) if grupobf=="Media"

egen misminbfalta=mean(minbfalta)
replace minbfalta=misminbfalta if minbfalta==.
egen misminbfmediaalta=mean(minbfmediaalta)
replace minbfmediaalta=misminbfmediaalta if minbfmediaalta==.
egen misminbfmedia=mean(minbfmedia)
replace minbfmedia=misminbfmedia if minbfmedia==.
egen mismaxbfmediaalta=mean(maxbfmediaalta)
replace maxbfmediaalta=mismaxbfmediaalta if maxbfmediaalta==.
egen mismaxbfmedia=mean(maxbfmedia)
replace maxbfmedia=mismaxbfmedia if maxbfmedia==.
egen mismaxbfbaixa=mean(maxbfbaixa)
replace maxbfbaixa=mismaxbfbaixa if maxbfbaixa==.

keep if _n==1
drop grupobf
gen bogus="1"

cd "C:\Bossa Nova\collections agency models\fd"
save fd_p2_b1_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\fd"
local drive = "`mesyr'"
cd "`drive'"
********************************End Automated Route & Path Code******************

clear
use internal_score_fd_p2_b2_`msyrnospc'_`today'-`time'

egen minbfalta=min(score) if grupobf=="Alta"
egen minbfmediaalta=min(score) if grupobf=="Media Alta"
egen maxbfmediaalta=min(score) if grupobf=="Alta"
egen minbfmedia=min(score) if grupobf=="Media"
egen maxbfmedia=min(score) if grupobf=="Media Alta"
egen maxbfbaixa=min(score) if grupobf=="Media"

egen misminbfalta=mean(minbfalta)
replace minbfalta=misminbfalta if minbfalta==.
egen misminbfmediaalta=mean(minbfmediaalta)
replace minbfmediaalta=misminbfmediaalta if minbfmediaalta==.
egen misminbfmedia=mean(minbfmedia)
replace minbfmedia=misminbfmedia if minbfmedia==.
egen mismaxbfmediaalta=mean(maxbfmediaalta)
replace maxbfmediaalta=mismaxbfmediaalta if maxbfmediaalta==.
egen mismaxbfmedia=mean(maxbfmedia)
replace maxbfmedia=mismaxbfmedia if maxbfmedia==.
egen mismaxbfbaixa=mean(maxbfbaixa)
replace maxbfbaixa=mismaxbfbaixa if maxbfbaixa==.

keep if _n==1
drop grupobf
gen bogus="1"

cd "C:\Bossa Nova\collections agency models\fd"
save fd_p2_b2_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\fd"
local drive = "`mesyr'"
cd "`drive'"
********************************End Automated Route & Path Code******************

clear
use internal_score_fd_p2_b3_`msyrnospc'_`today'-`time'

egen minbfalta=min(score) if grupobf=="Alta"
egen minbfmediaalta=min(score) if grupobf=="Media Alta"
egen maxbfmediaalta=min(score) if grupobf=="Alta"
egen minbfmedia=min(score) if grupobf=="Media"
egen maxbfmedia=min(score) if grupobf=="Media Alta"
egen maxbfbaixa=min(score) if grupobf=="Media"

egen misminbfalta=mean(minbfalta)
replace minbfalta=misminbfalta if minbfalta==.
egen misminbfmediaalta=mean(minbfmediaalta)
replace minbfmediaalta=misminbfmediaalta if minbfmediaalta==.
egen misminbfmedia=mean(minbfmedia)
replace minbfmedia=misminbfmedia if minbfmedia==.
egen mismaxbfmediaalta=mean(maxbfmediaalta)
replace maxbfmediaalta=mismaxbfmediaalta if maxbfmediaalta==.
egen mismaxbfmedia=mean(maxbfmedia)
replace maxbfmedia=mismaxbfmedia if maxbfmedia==.
egen mismaxbfbaixa=mean(maxbfbaixa)
replace maxbfbaixa=mismaxbfbaixa if maxbfbaixa==.

keep if _n==1
drop grupobf
gen bogus="1"

cd "C:\Bossa Nova\collections agency models\fd"
save fd_p2_b3_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\fd"
local drive = "`mesyr'"
cd "`drive'"
********************************End Automated Route & Path Code******************

clear
use internal_score_fd_p2_b4_`msyrnospc'_`today'-`time'

egen minbfalta=min(score) if grupobf=="Alta"
egen minbfmediaalta=min(score) if grupobf=="Media Alta"
egen maxbfmediaalta=min(score) if grupobf=="Alta"
egen minbfmedia=min(score) if grupobf=="Media"
egen maxbfmedia=min(score) if grupobf=="Media Alta"
egen maxbfbaixa=min(score) if grupobf=="Media"

egen misminbfalta=mean(minbfalta)
replace minbfalta=misminbfalta if minbfalta==.
egen misminbfmediaalta=mean(minbfmediaalta)
replace minbfmediaalta=misminbfmediaalta if minbfmediaalta==.
egen misminbfmedia=mean(minbfmedia)
replace minbfmedia=misminbfmedia if minbfmedia==.
egen mismaxbfmediaalta=mean(maxbfmediaalta)
replace maxbfmediaalta=mismaxbfmediaalta if maxbfmediaalta==.
egen mismaxbfmedia=mean(maxbfmedia)
replace maxbfmedia=mismaxbfmedia if maxbfmedia==.
egen mismaxbfbaixa=mean(maxbfbaixa)
replace maxbfbaixa=mismaxbfbaixa if maxbfbaixa==.

keep if _n==1
drop grupobf
gen bogus="1"

cd "C:\Bossa Nova\collections agency models\fd"
save fd_p2_b4_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\fd"
local drive = "`mesyr'"
cd "`drive'"
********************************End Automated Route & Path Code******************

clear
use internal_score_fd_p2_parceiros_`msyrnospc'_`today'-`time'

egen minbfalta=min(score) if grupobf=="Alta"
egen minbfmediaalta=min(score) if grupobf=="Media Alta"
egen maxbfmediaalta=min(score) if grupobf=="Alta"
egen minbfmedia=min(score) if grupobf=="Media"
egen maxbfmedia=min(score) if grupobf=="Media Alta"
egen maxbfbaixa=min(score) if grupobf=="Media"

egen misminbfalta=mean(minbfalta)
replace minbfalta=misminbfalta if minbfalta==.
egen misminbfmediaalta=mean(minbfmediaalta)
replace minbfmediaalta=misminbfmediaalta if minbfmediaalta==.
egen misminbfmedia=mean(minbfmedia)
replace minbfmedia=misminbfmedia if minbfmedia==.
egen mismaxbfmediaalta=mean(maxbfmediaalta)
replace maxbfmediaalta=mismaxbfmediaalta if maxbfmediaalta==.
egen mismaxbfmedia=mean(maxbfmedia)
replace maxbfmedia=mismaxbfmedia if maxbfmedia==.
egen mismaxbfbaixa=mean(maxbfbaixa)
replace maxbfbaixa=mismaxbfbaixa if maxbfbaixa==.

keep if _n==1
drop grupobf
gen bogus="1"

cd "C:\Bossa Nova\collections agency models\fd"
save fd_p2_parceiros_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\fd"
local drive = "`mesyr'"
cd "`drive'"
********************************End Automated Route & Path Code******************
! move /Y "C:\Bossa Nova\collections agency models\fd\Output Files\scores_cons_fd_p2_*.txt"

outsheet using trigfile.txt, delimiter (";")replace

cd "C:\Bossa Nova\collections agency models\fd\WAJ Control"
outsheet using waj.txt, delimiter (";") replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\fd"
local drive = "`mesyr'"
cd "`drive'"
********************************End Automated Route & Path Code******************

log close _all
exit, STATA clear




