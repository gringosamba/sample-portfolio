***Stata do file sample
**Rludwig 
**********************OPTIMIZED 90 AND 120-360 ALGORITHMS*****************
**********Implemented Dec 5 2018 *************************************************
clear all

display %tdNN_CCYY date(c(current_date), "DMY")

local mesyr : di %tdNN_CCYY date(c(current_date), "DMY")
di "`mesyr'"


***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
*************************END OF AUTOMATED DIRECTORY AND PATH CODE *******************
*******************************get current date and then format for two digit days (instead of one if less than 10***************************
local DDMONCCYY : di %tdDD_Mon_CCYY date(c(current_date), "DMY")
di "`DDMONCCYY'"

local today = subinstr("`DDMONCCYY'", " ", "_", .)
display "`today'"

log using rb_pb_processing_`today'.log, replace

**************************move input files from ftp to current drive**************
! move /Y "C:\Filezilla\Clients\rb\Input Files\Base_Total_pb*.rar"

***********************powershell commands to extract compressed files*************
shell set path="C:\Program Files\WinRAR";%path% & unrar  e Base_Total_pb*.rar
! rename Base_Total_pb*.txt input_pb.txt

**********this line replaces NULL anywhere in the file with blank**********
filefilter input_pb.txt input_pb2.txt, from("NULL") to("") replace

*********************************This line deletes the original file*****************
! del input_pb.txt
*/
import delimited using input_pb2.txt, stripquotes(yes) encoding("utf-8") delimiters(";")varnames(nonames)

rename v1 numerocontrato
rename v2 cpf
rename v3 pago
rename v4 qtdcompras
rename v5 valormedio
rename v6 valorrisco
rename v7 fixo
rename v8 celular
rename v9 QtdEmail
rename v10 credito
rename v11 recebimentocontrato
rename v12 dataassociacao
rename v13 nascimento
rename v14 estadocivil
rename v15 minimovencimento
rename v16 idcbairro
rename v17 ufgeo
rename v18 cep
rename v19 carteira

duplicates drop

destring numerocontrato, replace force
format %9.0f numerocontrato

destring pago, replace dpcomma
destring valormedio, replace dpcomma
destring valorrisco, replace dpcomma
destring idcbairro, replace dpcomma


**** this next section creates automatic macro variable for todays date to be used in determining age of debtor (in combo with birthdate variable).*****
gen hoy= "`c_date'"
display hoy
gen hoje=date(hoy, "DMY") 
display hoje

****Data Nascimento ***********************************************************
gen dia_nasc=substr(nascimento,9,2)
gen mes_nasc=substr(nascimento,6,2)
gen ano_nasc=substr(nascimento,1,4)
egen mesnasc=concat(ano_nasc mes_nasc)
destring dia_nasc - ano_nasc, replace 
gen datanasc=mdy(mes_nasc,dia_nasc,ano_nasc)
format datanasc %td
drop dia_nasc mes_nasc ano_nasc 

**** Format Data contrataco*************
gen dia_contr=substr(dataassociacao,1,2)
gen mes_contr=substr(dataassociacao,4,2)
gen ano_contr=substr(dataassociacao,7,4)
egen mescontr=concat(ano_contr mes_contr)
destring dia_contr - ano_contr, replace 
gen dataacontr=mdy(mes_contr,dia_contr,ano_contr)
format dataacontr %td
drop dia_contr mes_contr ano_contr 

**** Format Data de entrada *****************
gen dia_asig=substr(recebimentocontrato,9,2)
gen mes_asig=substr(recebimentocontrato,6,2)
gen ano_asig=substr(recebimentocontrato,1,4)
egen mesasig=concat(ano_asig mes_asig)
destring dia_asig - ano_asig, replace 
gen dataasig=mdy(mes_asig,dia_asig,ano_asig)
format dataasig %td
drop dia_asig mes_asig ano_asig 
tab mesasig

**** Format Data de vencimento*****************
gen dia_venc=substr(minimovencimento,9,2)
gen mes_venc=substr(minimovencimento,6,2)
gen ano_venc=substr(minimovencimento,1,4)
destring dia_venc - ano_venc, replace 
gen datavenc=mdy(mes_venc,dia_venc,ano_venc)
format datavenc %td
drop dia_venc mes_venc ano_venc 

gen tenure=dataasig-dataacontr
gen atraso=dataasig-datavenc
gen age=(dataasig-datanasc)/365

gen young=0
replace young=1 if age<=25


gen casado=0
replace casado=1 if estadocivil=="CASADO"
gen other=0
replace other=1 if estadocivil=="OUTROS"
replace celular=2 if celular>2
replace qtdcompras=3 if qtdcompras>3


*****************merge with payments database*****************************
cd "C:\Bossa Nova\collections agency models\Censo"

***new code to obtain city from cep ***
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

*****Now derive some new variables from census dataset*************
replace PIB_PER_CAPiTA_PRECOS_CORRENTES=22851 if PIB_PER_CAPiTA_PRECOS_CORRENTES==.
gen balpib=valorrisco/PIB_PER_CAPiTA_PRECOS_CORRENTES
gen percalpha=POP_RESID_ALFABETIZADA/POPULACAO_RESIDENTE
gen percevang=POP_RESID_EVANGELICA/POPULACAO_RESIDENTE
gen perccatol=POP_RESID_CATOLICA/POPULACAO_RESIDENTE
gen peresperita=POP_RESID_ESPIRITA/POPULACAO_RESIDENTE

rename PIB_PER_CAPiTA_PRECOS_CORRENTES pib
drop POP_RESID_MULHERES POP_RESID_FREQUENTAVA_CRECHE_ESC REND_NOMINAL_DOMIC_RURAL REND_NOMINAL_DOMIC_URBANA REND_NOMINAL_PER_CAPITA_RURAL REND_NOMINAL_PER_CAPITA_URBANA  UNID_TERRETORIAL UNID_SUS MATRICULA_ENSINO_FUNDAMENTAL MATRICULA_ENSINO_MEDIO UNIDADES_LOCAIS PESSOAL_OCUPADO_TOTAL POPULACAO_RESIDENTE POP_RESID_HOMENS POP_RESID_ALFABETIZADA POP_RESID_CATOLICA POP_RESID_EVANGELICA
drop if numerocontrato==.

sort cpf
format %014.0f cpf
merge m:1 cpf using Payments_active_allagencies
tab _merge
drop if _merge==2
drop _merge

format %011.0f cpf

gen dslstconspg=dataasig-datapgcons
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

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"

gen faixa="90" if atraso<=90
replace faixa="120" if atraso<=120 & atraso>90
replace faixa="150" if atraso<=150 & atraso>120
replace faixa="180" if atraso<=180 & atraso>150
replace faixa="270" if atraso<=270 & atraso>180
replace faixa="360" if atraso<=360 & atraso>270
replace faixa="450" if atraso<=450 & atraso>360
replace faixa="540" if atraso<=540 & atraso>450
replace faixa="630" if atraso<=630 & atraso>540
replace faixa="720" if atraso<=720 & atraso>630
replace faixa="810" if atraso<=810 & atraso>720
replace faixa="900" if atraso<=900 & atraso>810
replace faixa="990" if atraso<=990 & atraso>900
replace faixa="1080" if atraso<=1080 & atraso>990
replace faixa="1170" if atraso<=1170 & atraso>1080
replace faixa="1260" if atraso<=1260 & atraso>1170
replace faixa="1350" if atraso<=1350 & atraso>1260
replace faixa="1440" if atraso<=1440 & atraso>1350
replace faixa="1530" if atraso<=1530 & atraso>1440
replace faixa="1620" if atraso<=1620 & atraso>1530
replace faixa="1710" if atraso<=1710 & atraso>1620
replace faixa="1800" if atraso<=1800 & atraso>1710
replace faixa=">1800" if atraso>1800
tab faixa, missing


preserve
keep if faixa=="90"
count

if _N>0 {
save base_faixa90.dta, replace
}
restore

preserve
keep if faixa=="120"
count

if _N>0 {
save base_faixa120.dta, replace
}
restore

preserve
keep if faixa=="150"
count

if _N>0 {
save base_faixa150.dta, replace
}
restore

preserve
keep if faixa=="180"
count

if _N>0 {
save base_faixa180.dta, replace
}
restore

preserve
keep if faixa=="270"
count

if _N>0 {
save base_faixa270.dta, replace
}
restore


preserve
keep if faixa=="360"

if _N>0 {
save base_faixa360.dta, replace
}
restore

preserve
keep if faixa=="450"
count

if _N>0 {
save base_faixa450.dta, replace
}
restore

preserve
keep if faixa=="540"
count

if _N>0 {
save base_faixa540.dta, replace
}
restore

preserve
keep if faixa=="630"
count

if _N>0 {
save base_faixa630.dta, replace
}
restore

preserve
keep if faixa=="720"
count

if _N>0 {
save base_faixa720.dta, replace
}
restore

preserve
keep if faixa=="810"

if _N>0 {
save base_faixa810.dta, replace
}
restore

preserve
keep if faixa=="900"

if _N>0 {
save base_faixa900.dta, replace
}
restore

preserve
keep if faixa=="990"

if _N>0 {
save base_faixa990.dta, replace
}
restore

preserve
keep if faixa=="1080"

if _N>0 {
save base_faixa1080.dta, replace
}
restore

preserve
keep if faixa=="1170"

if _N>0 {
save base_faixa1170.dta, replace
}
restore

preserve
keep if faixa=="1260"

if _N>0 {
save base_faixa1260.dta, replace
}
restore

preserve
keep if faixa=="1350"

if _N>0 {
save base_faixa1350.dta, replace
}
restore

preserve
keep if faixa=="1440"

if _N>0 {
save base_faixa1440.dta, replace
}
restore

preserve
keep if faixa=="1530"

if _N>0 {
save base_faixa1530.dta, replace
}
restore

preserve
keep if faixa=="1620"

if _N>0 {
save base_faixa1620.dta, replace
}
restore

preserve
keep if faixa=="1710"

if _N>0 {
save base_faixa1710.dta, replace
}
restore

preserve
keep if faixa=="1800"

if _N>0 {
save base_faixa1800.dta, replace
}
restore

preserve
keep if faixa==">1800"

if _N>0 {
save base_faixamais1800.dta, replace
}
restore
********************************Faixa90***************************************
capture confirm file base_faixa90.dta
if _rc==0 {
***************************************************************************************************************************
clear
use base_faixa90.dta

gen goodstates=0
replace goodstates=1 if uf=="MG" | uf=="MS" | uf=="MT"

gen nopago=0
replace nopago=1 if pago==. | pago==0
gen loc=0
replace loc=1 if strpos(carteira, "Loc - G")>0
gen pdd=0
replace pdd=1 if strpos(carteira, "PDD")>0 
gen pdd2=0
replace pdd2=1 if strpos(carteira, "PDD II")>0
gen repac=0
replace repac=1 if strpos(carteira, "REPAC")>0

xtile vlrrskgrp=valorrisco, nquantiles(4)
xtile atrasocat=atraso, nquantiles(4)

replace tenure=2447 if tenure==.
replace atraso=0 if atraso<0
replace atraso=34.4 if atraso==.
replace young=0.22 if young==.
replace perccatol=0.616 if perccatol==.
replace age=40 if age==.

gen newvlrrsk=valorrisco
replace newvlrrsk=1200 if newvlrrsk>1200

********iteraction variables******************************
gen atrasten=tenure*atraso
gen agecatbalcat=atrasocat* vlrrskgrp
gen lowten=0
replace lowten=1 if tenure<600
gen highage=0
replace highage=1 if atraso>50
gen lowhigh=lowten * highage
gen hibal=0
replace hibal=1 if valorrisco>1000
gen hibalhiage=0
replace hibalhiage=1 if hibal==1 & atraso>=62
****************************************************************************************

*******************************New Optimized Algorithm (this one was developed using only Faixa 90)****************************************************
gen scorepb=1/(1+exp(-(-0.1924115*lowhigh+0.4274897*highage+0.1950431*hibalhiage+0.000000453*atrasten-0.142815*vlrrskgrp-0.2955592*repac-0.1123754*nopago+0.0981288*goodstates+1.39661*conspag4+0.5273822*perccatol+0.1767953*other+0.1344006*casado+0.0075222*age-0.046725*atraso+0.0000404*tenure+0.8728746*credito+0.5504967*QtdEmail+0.0833767*celular-0.3047939)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*newvlrrsk
drop if scorepb==.


preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixa90_`today'.dta, replace
restore
}

********************************Faixa 120***************************************
capture confirm file base_faixa120.dta
if _rc==0 {
************************************************************************************************************************
clear
use base_faixa120.dta

gen nopago=0
replace nopago=1 if pago==. | pago==0
gen loc=0
replace loc=1 if strpos(carteira, "Loc - G")>0
gen pdd=0
replace pdd=1 if strpos(carteira, "PDD")>0 
gen pdd2=0
replace pdd2=1 if strpos(carteira, "PDD II")>0
gen repac=0
replace repac=1 if strpos(carteira, "REPAC")>0

xtile vlrrskgrp=valorrisco, nquantiles(4)
xtile atrasocat=atraso, nquantiles(4)

replace tenure=1973 if tenure==.
replace atraso=0 if atraso<0
replace atraso=174.34 if atraso==.
replace young=0.22 if young==.
replace perccatol=0.616 if perccatol==.
replace age=40 if age==.

gen newvlrrsk=valorrisco
replace newvlrrsk=2000 if newvlrrsk>2000

********iteraction variables******************************
gen atrasten=tenure*atraso
gen agecatbalcat=atrasocat* vlrrskgrp
gen lowten=0
replace lowten=1 if tenure<600
gen highage=0
replace highage=1 if atraso>250
gen lowhigh=lowten * highage
gen hibal=0
replace hibal=1 if valorrisco>2000
gen hibalhiage=0
replace hibalhiage=1 if hibal==1 & atraso>=250
****************************************************************************************
*******************************New Optimized Algorithm Faixas>90<360****************************************************
gen scorepb=1/(1+exp(-(-0.3694413*lowhigh-0.1965078*vlrrskgrp+0.5911015*pdd2-0.1826111*nopago+0.5234978*conspag4-1.279045*balpib+0.0945983*other+0.158883*casado+0.0107831*age-0.0058027*atraso+0.0000768*tenure-0.1259688*credito+0.4391091*celular+0.3013112*fixo+0.8392839*qtdcompras-3.57891)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*newvlrrsk
drop if scorepb==.


preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixa120_`today'.dta, replace
restore
}

********************************Faixa 150***************************************
capture confirm file base_faixa150.dta
if _rc==0 {
************************************************************************************************************************
clear
use base_faixa150.dta

gen nopago=0
replace nopago=1 if pago==. | pago==0
gen loc=0
replace loc=1 if strpos(carteira, "Loc - G")>0
gen pdd=0
replace pdd=1 if strpos(carteira, "PDD")>0 
gen pdd2=0
replace pdd2=1 if strpos(carteira, "PDD II")>0
gen repac=0
replace repac=1 if strpos(carteira, "REPAC")>0

xtile vlrrskgrp=valorrisco, nquantiles(4)
xtile atrasocat=atraso, nquantiles(4)

replace tenure=1973 if tenure==.
replace atraso=0 if atraso<0
replace atraso=174.34 if atraso==.
replace young=0.22 if young==.
replace perccatol=0.616 if perccatol==.
replace age=40 if age==.

gen newvlrrsk=valorrisco
replace newvlrrsk=2000 if newvlrrsk>2000

********iteraction variables******************************
gen atrasten=tenure*atraso
gen agecatbalcat=atrasocat* vlrrskgrp
gen lowten=0
replace lowten=1 if tenure<600
gen highage=0
replace highage=1 if atraso>250
gen lowhigh=lowten * highage
gen hibal=0
replace hibal=1 if valorrisco>2000
gen hibalhiage=0
replace hibalhiage=1 if hibal==1 & atraso>=250
****************************************************************************************
*******************************New Optimized Algorithm Faixas>90<360****************************************************
gen scorepb=1/(1+exp(-(-0.3694413*lowhigh-0.1965078*vlrrskgrp+0.5911015*pdd2-0.1826111*nopago+0.5234978*conspag4-1.279045*balpib+0.0945983*other+0.158883*casado+0.0107831*age-0.0058027*atraso+0.0000768*tenure-0.1259688*credito+0.4391091*celular+0.3013112*fixo+0.8392839*qtdcompras-3.57891)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*newvlrrsk
drop if scorepb==.

preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixa150_`today'.dta, replace
restore
}

********************************************************************
capture confirm file base_faixa180.dta
if _rc==0 {
************************************************************************************************************************
clear
use base_faixa180.dta

gen nopago=0
replace nopago=1 if pago==. | pago==0
gen loc=0
replace loc=1 if strpos(carteira, "Loc - G")>0
gen pdd=0
replace pdd=1 if strpos(carteira, "PDD")>0 
gen pdd2=0
replace pdd2=1 if strpos(carteira, "PDD II")>0
gen repac=0
replace repac=1 if strpos(carteira, "REPAC")>0

xtile vlrrskgrp=valorrisco, nquantiles(4)
xtile atrasocat=atraso, nquantiles(4)

replace tenure=1973 if tenure==.
replace atraso=0 if atraso<0
replace atraso=174.34 if atraso==.
replace young=0.22 if young==.
replace perccatol=0.616 if perccatol==.
replace age=40 if age==.

gen newvlrrsk=valorrisco
replace newvlrrsk=2000 if newvlrrsk>2000

********iteraction variables******************************
gen atrasten=tenure*atraso
gen agecatbalcat=atrasocat* vlrrskgrp
gen lowten=0
replace lowten=1 if tenure<600
gen highage=0
replace highage=1 if atraso>250
gen lowhigh=lowten * highage
gen hibal=0
replace hibal=1 if valorrisco>2000
gen hibalhiage=0
replace hibalhiage=1 if hibal==1 & atraso>=250
****************************************************************************************
*******************************New Optimized Algorithm Faixas>90<360****************************************************
gen scorepb=1/(1+exp(-(-0.3694413*lowhigh-0.1965078*vlrrskgrp+0.5911015*pdd2-0.1826111*nopago+0.5234978*conspag4-1.279045*balpib+0.0945983*other+0.158883*casado+0.0107831*age-0.0058027*atraso+0.0000768*tenure-0.1259688*credito+0.4391091*celular+0.3013112*fixo+0.8392839*qtdcompras-3.57891)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*newvlrrsk
drop if scorepb==.

preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixa180_`today'.dta, replace
restore
}

********************************************************************
capture confirm file base_faixa270.dta
if _rc==0 {
************************************************************************************************************************
clear
use base_faixa270.dta

gen nopago=0
replace nopago=1 if pago==. | pago==0
gen loc=0
replace loc=1 if strpos(carteira, "Loc - G")>0
gen pdd=0
replace pdd=1 if strpos(carteira, "PDD")>0 
gen pdd2=0
replace pdd2=1 if strpos(carteira, "PDD II")>0
gen repac=0
replace repac=1 if strpos(carteira, "REPAC")>0

xtile vlrrskgrp=valorrisco, nquantiles(4)
xtile atrasocat=atraso, nquantiles(4)

replace tenure=1973 if tenure==.
replace atraso=0 if atraso<0
replace atraso=174.34 if atraso==.
replace young=0.22 if young==.
replace perccatol=0.616 if perccatol==.
replace age=40 if age==.

gen newvlrrsk=valorrisco
replace newvlrrsk=2000 if newvlrrsk>2000

********iteraction variables******************************
gen atrasten=tenure*atraso
gen agecatbalcat=atrasocat* vlrrskgrp
gen lowten=0
replace lowten=1 if tenure<600
gen highage=0
replace highage=1 if atraso>250
gen lowhigh=lowten * highage
gen hibal=0
replace hibal=1 if valorrisco>2000
gen hibalhiage=0
replace hibalhiage=1 if hibal==1 & atraso>=250
****************************************************************************************
*******************************New Optimized Algorithm Faixas>90<360****************************************************
gen scorepb=1/(1+exp(-(-0.3694413*lowhigh-0.1965078*vlrrskgrp+0.5911015*pdd2-0.1826111*nopago+0.5234978*conspag4-1.279045*balpib+0.0945983*other+0.158883*casado+0.0107831*age-0.0058027*atraso+0.0000768*tenure-0.1259688*credito+0.4391091*celular+0.3013112*fixo+0.8392839*qtdcompras-3.57891)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*newvlrrsk
drop if scorepb==.

preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixa270_`today'.dta, replace
restore
}


********************************Faixa 360***************************************
capture confirm file base_faixa360.dta
if _rc==0 {
************************************************************************************************************************
clear
use base_faixa360.dta

gen nopago=0
replace nopago=1 if pago==. | pago==0
gen loc=0
replace loc=1 if strpos(carteira, "Loc - G")>0
gen pdd=0
replace pdd=1 if strpos(carteira, "PDD")>0 
gen pdd2=0
replace pdd2=1 if strpos(carteira, "PDD II")>0
gen repac=0
replace repac=1 if strpos(carteira, "REPAC")>0

xtile vlrrskgrp=valorrisco, nquantiles(4)
xtile atrasocat=atraso, nquantiles(4)

replace tenure=1973 if tenure==.
replace atraso=0 if atraso<0
replace atraso=174.34 if atraso==.
replace young=0.22 if young==.
replace perccatol=0.616 if perccatol==.
replace age=40 if age==.

gen newvlrrsk=valorrisco
replace newvlrrsk=2000 if newvlrrsk>2000

********iteraction variables******************************
gen atrasten=tenure*atraso
gen agecatbalcat=atrasocat* vlrrskgrp
gen lowten=0
replace lowten=1 if tenure<600
gen highage=0
replace highage=1 if atraso>250
gen lowhigh=lowten * highage
gen hibal=0
replace hibal=1 if valorrisco>2000
gen hibalhiage=0
replace hibalhiage=1 if hibal==1 & atraso>=250
****************************************************************************************
*******************************New Optimized Algorithm Faixas>90<360****************************************************
gen scorepb=1/(1+exp(-(-0.3694413*lowhigh-0.1965078*vlrrskgrp+0.5911015*pdd2-0.1826111*nopago+0.5234978*conspag4-1.279045*balpib+0.0945983*other+0.158883*casado+0.0107831*age-0.0058027*atraso+0.0000768*tenure-0.1259688*credito+0.4391091*celular+0.3013112*fixo+0.8392839*qtdcompras-3.57891)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*newvlrrsk
drop if scorepb==.

preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixa360_`today'.dta, replace
restore
}

********************************Faixa 450***************************************
capture confirm file base_faixa450.dta
if _rc==0 {
************************************************************************************************************************
clear
use base_faixa450.dta

replace idcbairro=7.2 if idcbairro==.
replace tenure=3453 if tenure==.
replace atraso=273 if atraso==.
replace age=42 if age==.
replace young=0.132 if young==.
gen lowten=0
replace lowten=1 if atraso<=1000
replace lowten=1 if lowten==.

gen scorepb=1/(1+exp(-(-0.3015372*qtdcompras+0.2394717*fixo-0.0001114*valorrisco+0.4133196*celular-0.6292216*other-0.077403*casado+0.0231537*idcbairro+0.0001207*tenure-0.0010495*atraso+0.0058684*age-0.2353244*young+0.5081742*lowten+0.8263592*conspag4-3.107766)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*valorrisco
drop if scorepb==.

preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixa450_`today'.dta, replace
restore
}

********************************Faixa 540***************************************
capture confirm file base_faixa540.dta
if _rc==0 {
************************************************************************************************************************
clear
use base_faixa540.dta

replace idcbairro=7.2 if idcbairro==.
replace tenure=3453 if tenure==.
replace atraso=273 if atraso==.
replace age=42 if age==.
replace young=0.132 if young==.
gen lowten=0
replace lowten=1 if atraso<=1000
replace lowten=1 if lowten==.

gen scorepb=1/(1+exp(-(-0.3015372*qtdcompras+0.2394717*fixo-0.0001114*valorrisco+0.4133196*celular-0.6292216*other-0.077403*casado+0.0231537*idcbairro+0.0001207*tenure-0.0010495*atraso+0.0058684*age-0.2353244*young+0.5081742*lowten+0.8263592*conspag4-3.107766)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*valorrisco
drop if scorepb==.

preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixa540_`today'.dta, replace
restore
}

********************************Faixa 630***************************************
capture confirm file base_faixa630.dta
if _rc==0 {
************************************************************************************************************************
clear
use base_faixa630.dta

replace idcbairro=7.2 if idcbairro==.
replace tenure=3453 if tenure==.
replace atraso=273 if atraso==.
replace age=42 if age==.
replace young=0.132 if young==.
gen lowten=0
replace lowten=1 if atraso<=1000
replace lowten=1 if lowten==.

gen scorepb=1/(1+exp(-(-0.3015372*qtdcompras+0.2394717*fixo-0.0001114*valorrisco+0.4133196*celular-0.6292216*other-0.077403*casado+0.0231537*idcbairro+0.0001207*tenure-0.0010495*atraso+0.0058684*age-0.2353244*young+0.5081742*lowten+0.8263592*conspag4-3.107766)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*valorrisco
drop if scorepb==.

preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixa630_`today'.dta, replace
restore
}

********************************Faixa 720***************************************
capture confirm file base_faixa720.dta
if _rc==0 {
************************************************************************************************************************
clear
use base_faixa720.dta

replace idcbairro=7.2 if idcbairro==.
replace tenure=3453 if tenure==.
replace atraso=273 if atraso==.
replace age=42 if age==.
replace young=0.132 if young==.
gen lowten=0
replace lowten=1 if atraso<=1000
replace lowten=1 if lowten==.

gen scorepb=1/(1+exp(-(-0.3015372*qtdcompras+0.2394717*fixo-0.0001114*valorrisco+0.4133196*celular-0.6292216*other-0.077403*casado+0.0231537*idcbairro+0.0001207*tenure-0.0010495*atraso+0.0058684*age-0.2353244*young+0.5081742*lowten+0.8263592*conspag4-3.107766)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*valorrisco
drop if scorepb==.

preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixa720_`today'.dta, replace
restore
}

********************************Faixa 810***************************************
capture confirm file base_faixa810.dta
if _rc==0 {
************************************************************************************************************************
clear
use base_faixa810.dta

replace idcbairro=7.2 if idcbairro==.
replace tenure=3453 if tenure==.
replace atraso=273 if atraso==.
replace age=42 if age==.
replace young=0.132 if young==.
gen lowten=0
replace lowten=1 if atraso<=1000
replace lowten=1 if lowten==.

gen scorepb=1/(1+exp(-(-0.3015372*qtdcompras+0.2394717*fixo-0.0001114*valorrisco+0.4133196*celular-0.6292216*other-0.077403*casado+0.0231537*idcbairro+0.0001207*tenure-0.0010495*atraso+0.0058684*age-0.2353244*young+0.5081742*lowten+0.8263592*conspag4-3.107766)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*valorrisco
drop if scorepb==.

preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixa810_`today'.dta, replace
restore
}


********************************Faixa 900***************************************
capture confirm file base_faixa900.dta
if _rc==0 {
************************************************************************************************************************
clear
use base_faixa900.dta

replace idcbairro=7.2 if idcbairro==.
replace tenure=3453 if tenure==.
replace atraso=273 if atraso==.
replace age=42 if age==.
replace young=0.132 if young==.
gen lowten=0
replace lowten=1 if atraso<=1000
replace lowten=1 if lowten==.

gen scorepb=1/(1+exp(-(-0.3015372*qtdcompras+0.2394717*fixo-0.0001114*valorrisco+0.4133196*celular-0.6292216*other-0.077403*casado+0.0231537*idcbairro+0.0001207*tenure-0.0010495*atraso+0.0058684*age-0.2353244*young+0.5081742*lowten+0.8263592*conspag4-3.107766)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*valorrisco
drop if scorepb==.

preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixa900_`today'.dta, replace
restore
}

********************************Faixa 990***************************************
capture confirm file base_faixa990.dta
if _rc==0 {
************************************************************************************************************************
clear
use base_faixa990.dta

replace idcbairro=7.2 if idcbairro==.
replace tenure=3453 if tenure==.
replace atraso=273 if atraso==.
replace age=42 if age==.
replace young=0.132 if young==.
gen lowten=0
replace lowten=1 if atraso<=1000
replace lowten=1 if lowten==.

gen scorepb=1/(1+exp(-(-0.3015372*qtdcompras+0.2394717*fixo-0.0001114*valorrisco+0.4133196*celular-0.6292216*other-0.077403*casado+0.0231537*idcbairro+0.0001207*tenure-0.0010495*atraso+0.0058684*age-0.2353244*young+0.5081742*lowten+0.8263592*conspag4-3.107766)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*valorrisco
drop if scorepb==.

preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixa990_`today'.dta, replace
restore
}

********************************Faixa 1080***************************************
capture confirm file base_faixa1080.dta
if _rc==0 {
************************************************************************************************************************
clear
use base_faixa1080.dta

replace idcbairro=7.2 if idcbairro==.
replace tenure=3453 if tenure==.
replace atraso=273 if atraso==.
replace age=42 if age==.
replace young=0.132 if young==.
gen lowten=0
replace lowten=1 if atraso<=1000
replace lowten=1 if lowten==.

gen scorepb=1/(1+exp(-(-0.3015372*qtdcompras+0.2394717*fixo-0.0001114*valorrisco+0.4133196*celular-0.6292216*other-0.077403*casado+0.0231537*idcbairro+0.0001207*tenure-0.0010495*atraso+0.0058684*age-0.2353244*young+0.5081742*lowten+0.8263592*conspag4-3.107766)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*valorrisco
drop if scorepb==.

preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixa1080_`today'.dta, replace
restore
}

********************************Faixa 1170***************************************
capture confirm file base_faixa1170.dta
if _rc==0 {
************************************************************************************************************************
clear
use base_faixa1170.dta

replace idcbairro=7.2 if idcbairro==.
replace tenure=3453 if tenure==.
replace atraso=273 if atraso==.
replace age=42 if age==.
replace young=0.132 if young==.
gen lowten=0
replace lowten=1 if atraso<=1000
replace lowten=1 if lowten==.

gen scorepb=1/(1+exp(-(-0.3015372*qtdcompras+0.2394717*fixo-0.0001114*valorrisco+0.4133196*celular-0.6292216*other-0.077403*casado+0.0231537*idcbairro+0.0001207*tenure-0.0010495*atraso+0.0058684*age-0.2353244*young+0.5081742*lowten+0.8263592*conspag4-3.107766)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*valorrisco
drop if scorepb==.

preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixa1170_`today'.dta, replace
restore
}

********************************Faixa 1260***************************************
capture confirm file base_faixa1260.dta
if _rc==0 {
************************************************************************************************************************
clear
use base_faixa1260.dta

replace idcbairro=7.2 if idcbairro==.
replace tenure=3453 if tenure==.
replace atraso=273 if atraso==.
replace age=42 if age==.
replace young=0.132 if young==.
gen lowten=0
replace lowten=1 if atraso<=1000
replace lowten=1 if lowten==.

gen scorepb=1/(1+exp(-(-0.3015372*qtdcompras+0.2394717*fixo-0.0001114*valorrisco+0.4133196*celular-0.6292216*other-0.077403*casado+0.0231537*idcbairro+0.0001207*tenure-0.0010495*atraso+0.0058684*age-0.2353244*young+0.5081742*lowten+0.8263592*conspag4-3.107766)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*valorrisco
drop if scorepb==.

preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixa1260_`today'.dta, replace
restore
}

********************************Faixa 1350***************************************
capture confirm file base_faixa1350.dta
if _rc==0 {
************************************************************************************************************************
clear
use base_faixa1350.dta

replace idcbairro=7.2 if idcbairro==.
replace tenure=3453 if tenure==.
replace atraso=273 if atraso==.
replace age=42 if age==.
replace young=0.132 if young==.
gen lowten=0
replace lowten=1 if atraso<=1000
replace lowten=1 if lowten==.

gen scorepb=1/(1+exp(-(-0.3015372*qtdcompras+0.2394717*fixo-0.0001114*valorrisco+0.4133196*celular-0.6292216*other-0.077403*casado+0.0231537*idcbairro+0.0001207*tenure-0.0010495*atraso+0.0058684*age-0.2353244*young+0.5081742*lowten+0.8263592*conspag4-3.107766)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*valorrisco
drop if scorepb==.

preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixa1350_`today'.dta, replace
restore
}

********************************Faixa 1440***************************************
capture confirm file base_faixa1440.dta
if _rc==0 {
************************************************************************************************************************
clear
use base_faixa1440.dta

replace idcbairro=7.2 if idcbairro==.
replace tenure=3453 if tenure==.
replace atraso=273 if atraso==.
replace age=42 if age==.
replace young=0.132 if young==.
gen lowten=0
replace lowten=1 if atraso<=1000
replace lowten=1 if lowten==.

gen scorepb=1/(1+exp(-(-0.3015372*qtdcompras+0.2394717*fixo-0.0001114*valorrisco+0.4133196*celular-0.6292216*other-0.077403*casado+0.0231537*idcbairro+0.0001207*tenure-0.0010495*atraso+0.0058684*age-0.2353244*young+0.5081742*lowten+0.8263592*conspag4-3.107766)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*valorrisco
drop if scorepb==.

preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixa1440_`today'.dta, replace
restore
}

********************************Faixa 1530***************************************
capture confirm file base_faixa1530.dta
if _rc==0 {
************************************************************************************************************************
clear
use base_faixa1530.dta

replace idcbairro=7.2 if idcbairro==.
replace tenure=3453 if tenure==.
replace atraso=273 if atraso==.
replace age=42 if age==.
replace young=0.132 if young==.
gen lowten=0
replace lowten=1 if atraso<=1000
replace lowten=1 if lowten==.

gen scorepb=1/(1+exp(-(-0.3015372*qtdcompras+0.2394717*fixo-0.0001114*valorrisco+0.4133196*celular-0.6292216*other-0.077403*casado+0.0231537*idcbairro+0.0001207*tenure-0.0010495*atraso+0.0058684*age-0.2353244*young+0.5081742*lowten+0.8263592*conspag4-3.107766)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*valorrisco
drop if scorepb==.

preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixa1530_`today'.dta, replace
restore
}

********************************Faixa 1620***************************************
capture confirm file base_faixa1620.dta
if _rc==0 {
************************************************************************************************************************
clear
use base_faixa1620.dta

replace idcbairro=7.2 if idcbairro==.
replace tenure=3453 if tenure==.
replace atraso=273 if atraso==.
replace age=42 if age==.
replace young=0.132 if young==.
gen lowten=0
replace lowten=1 if atraso<=1000
replace lowten=1 if lowten==.

gen scorepb=1/(1+exp(-(-0.3015372*qtdcompras+0.2394717*fixo-0.0001114*valorrisco+0.4133196*celular-0.6292216*other-0.077403*casado+0.0231537*idcbairro+0.0001207*tenure-0.0010495*atraso+0.0058684*age-0.2353244*young+0.5081742*lowten+0.8263592*conspag4-3.107766)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*valorrisco
drop if scorepb==.

preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixa1620_`today'.dta, replace
restore
}

********************************Faixa 1710***************************************
capture confirm file base_faixa1710.dta
if _rc==0 {
************************************************************************************************************************
clear
use base_faixa1710.dta

replace idcbairro=7.2 if idcbairro==.
replace tenure=3453 if tenure==.
replace atraso=273 if atraso==.
replace age=42 if age==.
replace young=0.132 if young==.
gen lowten=0
replace lowten=1 if atraso<=1000
replace lowten=1 if lowten==.

gen scorepb=1/(1+exp(-(-0.3015372*qtdcompras+0.2394717*fixo-0.0001114*valorrisco+0.4133196*celular-0.6292216*other-0.077403*casado+0.0231537*idcbairro+0.0001207*tenure-0.0010495*atraso+0.0058684*age-0.2353244*young+0.5081742*lowten+0.8263592*conspag4-3.107766)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*valorrisco
drop if scorepb==.

preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixa1710_`today'.dta, replace
restore
}

********************************Faixa 1800***************************************
capture confirm file base_faixa1800.dta
if _rc==0 {
************************************************************************************************************************
clear
use base_faixa1800.dta

replace idcbairro=7.2 if idcbairro==.
replace tenure=3453 if tenure==.
replace atraso=273 if atraso==.
replace age=42 if age==.
replace young=0.132 if young==.
gen lowten=0
replace lowten=1 if atraso<=1000
replace lowten=1 if lowten==.

gen scorepb=1/(1+exp(-(-0.3015372*qtdcompras+0.2394717*fixo-0.0001114*valorrisco+0.4133196*celular-0.6292216*other-0.077403*casado+0.0231537*idcbairro+0.0001207*tenure-0.0010495*atraso+0.0058684*age-0.2353244*young+0.5081742*lowten+0.8263592*conspag4-3.107766)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*valorrisco
drop if scorepb==.

preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixa1800_`today'.dta, replace
restore
}

********************************Faixa >1800***************************************
capture confirm file base_faixamais1800.dta
if _rc==0 {
************************************************************************************************************************
clear
use base_faixamais1800.dta

replace idcbairro=7.2 if idcbairro==.
replace tenure=3453 if tenure==.
replace atraso=273 if atraso==.
replace age=42 if age==.
replace young=0.132 if young==.
gen lowten=0
replace lowten=1 if atraso<=1000
replace lowten=1 if lowten==.

gen scorepb=1/(1+exp(-(-0.3015372*qtdcompras+0.2394717*fixo-0.0001114*valorrisco+0.4133196*celular-0.6292216*other-0.077403*casado+0.0231537*idcbairro+0.0001207*tenure-0.0010495*atraso+0.0058684*age-0.2353244*young+0.5081742*lowten+0.8263592*conspag4-3.107766)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*valorrisco
drop if scorepb==.

preserve

gsort -scorebf
gen orden2=[_n]
xtile groups_score2=orden2, nquantiles(10)
gen grupobf="1" if groups_score2==1
replace grupobf="2" if groups_score2==2
replace grupobf="3" if groups_score2==3
replace grupobf="4" if groups_score2==4
replace grupobf="5" if groups_score2==5
replace grupobf="6" if groups_score2==6
replace grupobf="7" if groups_score2==7
replace grupobf="8" if groups_score2==8
replace grupobf="9" if groups_score2==9
replace grupobf="10" if groups_score2==10
tab grupobf

keep numerocontrato cpf scorepb scorebf grupobf
order numerocontrato cpf scorepb scorebf grupobf
save scores_rb_pb_faixamais1800_`today'.dta, replace
restore
}


capture confirm file scores_rb_pb_faixa90_`today'.dta
if _rc==0 {
************new code to create dataset of cut offs by groups*********
use scores_rb_pb_faixa90_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixa90_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

capture confirm file scores_rb_pb_faixa120_`today'.dta
if _rc==0 {
use scores_rb_pb_faixa120_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixa120_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

capture confirm file scores_rb_pb_faixa150_`today'.dta
if _rc==0 {
use scores_rb_pb_faixa150_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixa150_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

capture confirm file scores_rb_pb_faixa180_`today'.dta
if _rc==0 {
use scores_rb_pb_faixa180_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixa180_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

capture confirm file scores_rb_pb_faixa270_`today'.dta
if _rc==0 {
use scores_rb_pb_faixa270_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixa270_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

capture confirm file scores_rb_pb_faixa360_`today'.dta
if _rc==0 {

use scores_rb_pb_faixa360_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixa360_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

capture confirm file scores_rb_pb_faixa450_`today'.dta
if _rc==0 {

use scores_rb_pb_faixa450_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixa450_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

capture confirm file scores_rb_pb_faixa540_`today'.dta
if _rc==0 {

use scores_rb_pb_faixa540_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixa540_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

capture confirm file scores_rb_pb_faixa630_`today'.dta
if _rc==0 {

use scores_rb_pb_faixa630_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixa630_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

capture confirm file scores_rb_pb_faixa720_`today'.dta
if _rc==0 {

use scores_rb_pb_faixa720_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixa720_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

capture confirm file scores_rb_pb_faixa810_`today'.dta
if _rc==0 {

use scores_rb_pb_faixa810_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixa810_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

capture confirm file scores_rb_pb_faixa900_`today'.dta
if _rc==0 {

use scores_rb_pb_faixa900_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixa900_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

capture confirm file scores_rb_pb_faixa990_`today'.dta
if _rc==0 {

use scores_rb_pb_faixa990_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixa990_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

capture confirm file scores_rb_pb_faixa1080_`today'.dta
if _rc==0 {

use scores_rb_pb_faixa1080_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixa1080_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

capture confirm file scores_rb_pb_faixa1170_`today'.dta
if _rc==0 {

use scores_rb_pb_faixa1170_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixa1170_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

capture confirm file scores_rb_pb_faixa1260_`today'.dta
if _rc==0 {

use scores_rb_pb_faixa1260_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixa1260_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

capture confirm file scores_rb_pb_faixa1350_`today'.dta
if _rc==0 {

use scores_rb_pb_faixa1350_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixa1350_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

capture confirm file scores_rb_pb_faixa1440_`today'.dta
if _rc==0 {

use scores_rb_pb_faixa1440_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixa1440_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

capture confirm file scores_rb_pb_faixa1530_`today'.dta
if _rc==0 {

use scores_rb_pb_faixa1530_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixa1530_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

capture confirm file scores_rb_pb_faixa1620_`today'.dta
if _rc==0 {

use scores_rb_pb_faixa1620_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixa1620_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

capture confirm file scores_rb_pb_faixa1710_`today'.dta
if _rc==0 {

use scores_rb_pb_faixa1710_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixa1710_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

capture confirm file scores_rb_pb_faixa1800_`today'.dta
if _rc==0 {

use scores_rb_pb_faixa1800_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixa1800_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

capture confirm file scores_rb_pb_faixamais1800_`today'.dta
if _rc==0 {

use scores_rb_pb_faixamais1800_`today'.dta, clear
egen minbf1=min(scorebf) if grupobf=="1"
egen minbf2=min(scorebf) if grupobf=="2"
egen maxbf2=min(scorebf) if grupobf=="1"
egen minbf3=min(scorebf) if grupobf=="3"
egen maxbf3=min(scorebf) if grupobf=="2"
egen minbf4=min(scorebf) if grupobf=="4"
egen maxbf4=min(scorebf) if grupobf=="3"
egen minbf5=min(scorebf) if grupobf=="5"
egen maxbf5=min(scorebf) if grupobf=="4"
egen minbf6=min(scorebf) if grupobf=="6"
egen maxbf6=min(scorebf) if grupobf=="5"
egen minbf7=min(scorebf) if grupobf=="7"
egen maxbf7=min(scorebf) if grupobf=="6"
egen minbf8=min(scorebf) if grupobf=="8"
egen maxbf8=min(scorebf) if grupobf=="7"
egen minbf9=min(scorebf) if grupobf=="9"
egen maxbf9=min(scorebf) if grupobf=="8"
egen maxbf10=min(scorebf) if grupobf=="9"

egen misminbf1=mean(minbf1)
replace minbf1=misminbf1 if minbf1==.
egen misminbf2=mean(minbf2)
replace minbf2=misminbf2 if minbf2==.
egen misminbf3=mean(minbf3)
replace minbf3=misminbf3 if minbf3==.
egen misminbf4=mean(minbf4)
replace minbf4=misminbf4 if minbf4==.
egen misminbf5=mean(minbf5)
replace minbf5=misminbf5 if minbf5==.
egen misminbf6=mean(minbf6)
replace minbf6=misminbf6 if minbf6==.
egen misminbf7=mean(minbf7)
replace minbf7=misminbf7 if minbf7==.
egen misminbf8=mean(minbf8)
replace minbf8=misminbf8 if minbf8==.
egen misminbf9=mean(minbf9)
replace minbf9=misminbf9 if minbf9==.
egen mismaxbf2=mean(maxbf2)
replace maxbf2=mismaxbf2 if maxbf2==.
egen mismaxbf3=mean(maxbf3)
replace maxbf3=mismaxbf3 if maxbf3==.
egen mismaxbf4=mean(maxbf4)
replace maxbf4=mismaxbf4 if maxbf4==.
egen mismaxbf5=mean(maxbf5)
replace maxbf5=mismaxbf5 if maxbf5==.
egen mismaxbf6=mean(maxbf6)
replace maxbf6=mismaxbf6 if maxbf6==.
egen mismaxbf7=mean(maxbf7)
replace maxbf7=mismaxbf7 if maxbf7==.
egen mismaxbf8=mean(maxbf8)
replace maxbf8=mismaxbf8 if maxbf8==.
egen mismaxbf9=mean(maxbf9)
replace maxbf9=mismaxbf9 if maxbf9==.
egen mismaxbf10=mean(maxbf10)
replace maxbf10=mismaxbf10 if maxbf10==.

keep if _n==1
rename grupobf bogus
sort bogus


cd "C:\Bossa Nova\collections agency models\rb\pb"
save rb_pb_faixamais1800_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
}

***********************CONSOLIDATE ALL FASES INTO ONE CONSOLIDATED TXT FILE *******
****************************compile fases into one consolidated txt file ********
clear
! dir scores_rb_pb_*.dta /a-d /b >outputfiles.txt, replace

file open outputfiles using outputfiles.txt, read
file read outputfiles line

use `line'
save rb_pb_output, replace
file read outputfiles line

while r(eof)==0 {
	append using `line'
	file read outputfiles line
}
file close outputfiles
outsheet using scores_rb_pb_cons_`today'.txt, delimiter (";")replace

cd "C:\Bossa Nova\collections agency models\rb\rb FTP"

outsheet using scores_rb_pb_cons_`today'.txt, delimiter (";")replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\rb\pb"
local drive = "`mesyr'"
cd "`drive'"
********************************End Automated Route & Path Code******************


! del base_faixa*
log close

exit, STATA clear

