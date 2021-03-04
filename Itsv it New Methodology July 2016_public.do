* Sample Stata do file
* Rludwig- Prod it itsv Updated July 10 2016**

clear all
set mem 2000m

display %td_NN_CCYY date(c(current_date), "DMY")

local mesyr : di %td_NN_CCYY date(c(current_date), "DMY")
di "`mesyr'"

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\itsv\it PF"
local drive = "`mesyr'"
cd "`drive'"
********************************End Automated Route & Path Code******************
********** create macro variable to be used as date stamp in filenames*****************************
local c_date = c(current_date)
display "`c_date'"
local today = subinstr("`c_date'", " ", "_", .)
display "`today'"

log using itcorrentista_processing_`today'.log, replace

insheet using VAREJO_20072016.txt, delimiter (";")

rename v1 cpf
rename v2 datarecebimento
rename v3 numerocontrato
rename v4 numerotitulo
rename v5 vencimento
rename v6 valoravista
rename v7 desconto
rename v8 sdo_venc
rename v9 tipodebito
rename v10 dataassociacao
rename v11 uf
rename v12 cep
rename v13 qtdcelular
rename v14 qtdtelefone
rename v15 scbanco
rename v16 propensao
rename v17 oferta
rename v18 email
rename v19 flag_alo_cliente_3m
rename v20 digital
rename v21 nascimento
rename v22 gh_v2
rename v23 cluster
/*
replace flag_alo_cliente_3m="1" if flag_alo_cliente_3m!=""
destring flag_alo_cliente_3m, replace
replace flag_alo_cliente_3m=0 if flag_alo_cliente_3m==.
*/
gen goodigit=0
replace goodigit=1 if strpos(digital, "Presencial")>0
replace goodigit=1 if strpos(digital, "Digital")>0
replace goodigit=1 if strpos(digital, "Eletronizado")>0
replace goodigit=1 if strpos(digital, "Remoto")>0

gen svar = string(cpf, "%011.0f")
drop cpf
rename svar cpf
drop numerocontrato
format %20.0f numerotitulo 
bysort numerotitulo: keep if _n==1
destring cep, replace force
format %08.0f cep
gen str8 codpostal = string(cep, "%08.0f")
 
***this section to drop corrupt observations and destring several variables***********
keep if uf== "AC" | uf=="AL" | uf=="AM" | uf=="AP" | uf=="BA" | uf=="CE" | uf=="DF" | uf=="ES" | uf=="GO" | uf=="MA" | uf=="MG" | uf=="MS" | uf=="MT" | uf=="NI" | uf=="PA" | uf=="PB" | uf=="PE" | uf=="PI" | uf=="PR" | uf=="RJ" | uf=="RN" | uf=="RO" | uf=="RR" | uf=="RS" | uf=="SC" | uf=="SE" | uf=="SP" |uf=="TO" |uf==""
destring qtdtelefone, replace force
destring qtdcelular, replace force



**** this next section creates automatic macro variable for todays date to be used in determining age of debtor (in combo with birthdate variable).*****
gen hoy= "`c_date'"
display hoy
gen hoje=date(hoy, "DMY") 
display hoje

**** Data Recibimiento ****
replace datarecebimento="" if datarecebimento=="NULL"
gen mes_asig=substr(datarecebimento,4,2)
gen ano_asig=substr(datarecebimento,7,4)
egen mesasig=concat(ano_asig mes_asig)
destring mesasig, replace 
gen dia_asig=substr(datarecebimento,1,2)
destring mes_asig ano_asig dia_asig, replace
gen asig=mdy(mes_asig,dia_asig,ano_asig)
format asig %td
drop mes_asig ano_asig dia_asig
tab mesasig

* Data Vencimento
replace vencimento="" if vencimento=="NULL"
gen year_ref_end=substr(vencimento,7,2)
gen month_ref=substr(vencimento,4,2)
gen day_ref=substr(vencimento,1,2)
destring year_ref_end month_ref day_ref, replace
gen year_ref=20+year_ref_end
gen date_ref=mdy(month_ref, day_ref, year_ref)
format date_ref %td
drop year_ref month_ref day_ref
rename date_ref data_venc


*** Data Asociaci—n ****
replace dataassociacao="" if dataassociacao=="NULL"
gen mes_asoc=substr(dataassociacao,4,2)
gen ano_asoc_end=substr(dataassociacao,7,2)
destring ano_asoc_end, replace
gen ano_asoc_beg="20"
replace ano_asoc_beg="19" if ano_asoc_end>20
destring ano_asoc_beg, replace
egen ano_asoc=concat(ano_asoc_beg ano_asoc_end)
egen mesasoc=concat(ano_asoc mes_asoc)
destring mesasoc, replace 

gen dia_asoc=substr(dataassociacao,1,2)
destring mes_asoc ano_asoc dia_asoc, replace
gen asoc=mdy(mes_asoc,dia_asoc,ano_asoc)
format asoc %td
drop mes_asoc ano_asoc dia_asoc

************DERIVE AGE VARIABLE USING DATA RECIBMENTO DATA VENCIMENTO****************
gen age=(asig-data_venc)
replace age=0 if age<0
replace age=10000 if age>10000

**total phones=Tel+Cel****************
replace qtdtelefone=0 if qtdtelefone==.
replace qtdcelular=0 if qtdcelular==.
gen fonos=qtdtelefone+qtdcelular
replace fonos=3 if fonos>3
tab fonos 

******cel phones***********
replace qtdcelular=2 if qtdcelular>2
tab qtdcelular 

**Para clasificar Q de Tel **
replace qtdtelefone=2 if qtdtelefone>2
tab qtdtelefone 

gen nofixed=0
replace nofixed=1 if qtdtelefone==0

******************Estado*******************************************
gen dist="SP" if substr(codpostal,1,1)=="0"
replace dist="LSP" if substr(codpostal,1,1)=="1"
tab dist 

gen distsp=0
replace distsp=1 if dist=="SP"
gen distlsp=0
replace distlsp=1 if dist=="LSP"


gen sp=0
replace sp=1 if uf=="SP"
gen pr=0
replace pr=1 if uf=="PR"
gen mg=0
replace mg=1 if uf=="MG"
gen rj=0
replace rj=1 if uf=="RJ"
gen ms=0
replace ms=1 if uf=="MS"
gen ba=0
replace ba=1 if uf=="BA"
gen pe=0
replace pe=1 if uf=="PE"
gen rs=0
replace rs=1 if uf=="RS"
gen rn=0
replace rn=1 if uf=="RN"

*** Vemos antiguedad ***
gen antig=(asig-asoc)/365
replace antig=0 if antig<0
replace antig=50 if antig>50

***************products***********************
gen subprod="other"
replace subprod="LIS" if substr(tipodebito,1,3)=="LIS" | substr(tipodebito,1,22)=="LIMITE it PARA SAQUE" | substr(tipodebito,1,15)=="AD.DEPOSITANTES" | substr(tipodebito,1,15)=="SALDO PARC it"
replace subprod="REFIN" if substr(tipodebito,1,5)=="REFIN" | substr(tipodebito,1,7)=="RENEGOC"
replace subprod="TITCART" if substr(tipodebito,1,29)=="TITULARES CARTOES DE CREDITO"
replace subprod="Credicard" if substr(tipodebito,1,28)=="OPERACOES CREDITO CREDICARD"
replace subprod="Credaut" if substr(tipodebito,1,12)=="CRED AUT PRE"
tab subprod 

gen lis=0
replace lis=1 if subprod=="LIS"
gen titcart=0
replace titcart=1 if subprod=="TITCART"
gen credicard=0
replace credicard=1 if subprod=="Credicard"
gen refin=0
replace refin=1 if subprod=="REFIN"
gen subprdoth=0
replace subprdoth=1 if subprod=="other"
gen novouni=0
replace novouni=1 if tipodebito=="NOVO UNICARD"

**************subgroups according to classification by feist***************************************
gen subgroup="other"
replace subgroup="TDC" if substr(tipodebito,1,6)=="CART O" | substr(tipodebito,1,30)=="CONV ESP PP-MOV CARTAO LISPORT" | substr(tipodebito,1,12)=="EP GLOBEX PF" | substr(tipodebito,1,8)=="itCARD" | substr(tipodebito,1,12)=="NOVO UNICARD" | substr(tipodebito,1,27)=="OPERACOES CREDITO CREDICARD" | substr(tipodebito,1,29)=="TITULARES CARTOES DE CREDITO"
replace subgroup="Cheques" if substr(tipodebito,1,22)=="DESCONTO DE CHEQUES PF"
replace subgroup="Consignado" if substr(tipodebito,1,10)=="CONSIGNADO" | substr(tipodebito,6,6)=="CONSIG" | substr(tipodebito,1,18)=="CREDI RIO CONSIGNA" | substr(tipodebito,1,18)=="CREDITO CONSIGNADO"
replace subgroup="Crediario" if substr(tipodebito,1,9)=="CREDIARIO"
replace subgroup="Automatic" if substr(tipodebito,1,8)=="CRED AUT" | substr(tipodebito,1,13)=="CREDI RIO AUT" | substr(tipodebito,1,9)=="CREDIGOLD" | substr(tipodebito,1,8)=="CREDIPRE" | substr(tipodebito,1,18)=="CREDISHOP BANKLINE" | substr(tipodebito,1,11)=="CREDISILVER" | substr(tipodebito,1,23)=="CREDITO AUTOMATICO it" | substr(tipodebito,1,4)=="NSPI"
replace subgroup="Micro" if substr(tipodebito,1,12)=="MICROCREDITO"
replace subgroup="Renegoc" if substr(tipodebito,1,7)=="RENEGOC" | substr(tipodebito,1,7)=="COMPJUR" | substr(tipodebito,1,9)=="CREDICOMP"

gen automatic=0
replace automatic=1 if subgroup=="Automatic"
gen crediario=0
replace crediario=1 if subgroup=="Crediario"
gen renegoc=0
replace renegoc=1 if subgroup=="Renegoc"
gen tdc=0
replace tdc=1 if subgroup=="TDC"
gen other=0
replace other=1 if subgroup=="other"
 
gen titcnt=0
replace titcnt=1 if numerotitulo!=.
 
bysort cpf: egen valor_avista_acum=total(valoravista)
bysort cpf: egen valor_venc_acum=total(sdo_venc)
bysort cpf: egen num_titulo=sum(titcnt)
bysort cpf: egen max_age=max(age)
bysort cpf: egen max_antig=max(antig)
bysort cpf: egen lis_acum=sum(lis)
bysort cpf: egen titcart_acum=sum(titcart)
bysort cpf: egen credicard_acum=sum(credicard)
bysort cpf: egen refin_acum=sum(refin)
bysort cpf: egen novouni_acum=sum(novouni)
bysort cpf: egen automatic_acum=sum(automatic)
bysort cpf: egen crediario_acum=sum(crediario)
bysort cpf: egen reneg_acum=sum(renegoc)
bysort cpf: egen tdc_acum=sum(tdc)

bysort cpf:keep if _n==1

format %12.0g valor_avista_acum
format %12.0g valor_venc_acum

drop valoravista sdo_venc age antig lis titcart credicard refin novouni automatic crediario renegoc tdc titcnt

*******LETS LOOK AT THE TWO BALANCE VARIABLES AND DERIVE SOME NEW ONES***********
gen difbal=valor_avista_acum/valor_venc_acum
replace difbal=1 if difbal>1

****Balance Range*****************************************
gen balrange=1 if valor_avista_acum<1000
replace balrange=2 if valor_avista_acum>=1000 & valor_avista_acum<2500
replace balrange=3 if valor_avista_acum>=2500 
tab balrange 


***********Will change route to pick up files that contain census data******
cd "C:\Bossa Nova\collections agency models\Censo"

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

gen balpib=valor_avista_acum/PIB_PER_CAPiTA_PRECOS_CORRENTES
gen percalpha=POP_RESID_ALFABETIZADA/POPULACAO_RESIDENTE
gen percevang=POP_RESID_EVANGELICA/POPULACAO_RESIDENTE
gen perccatol=POP_RESID_CATOLICA/POPULACAO_RESIDENTE
gen peresperita=POP_RESID_ESPIRITA/POPULACAO_RESIDENTE

rename PIB_PER_CAPiTA_PRECOS_CORRENTES pib
drop POP_RESID_MULHERES POP_RESID_FREQUENTAVA_CRECHE_ESC REND_NOMINAL_DOMIC_RURAL REND_NOMINAL_DOMIC_URBANA REND_NOMINAL_PER_CAPITA_RURAL REND_NOMINAL_PER_CAPITA_URBANA
drop if cpf==""

destring cpf, replace
bysort cpf: keep if _n==1
format %014.0f cpf
merge 1:1 cpf using Payments_active_allagencies
tab _merge
drop if _merge==2
drop _merge


format %011.0f cpf

gen dslstconspg=asig-datapgcons

gen intpf=0
replace intpf=1 if agency=="itsv" & portfolio=="it_PF"
gen prepmnt=0
replace prepmnt=1 if dslstconspg<0

gen ngpmnt=0
replace ngpmnt=1 if intpf==1 & prepmnt==1

gen conspag=0
replace conspag=1 if datapgcons!=. & ngpmnt==0
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
cd "C:\Bossa Nova\collections agency models\itsv\it PF"
local drive = "`mesyr'"
cd "`drive'"
********************************End Automated Route & Path Code******************

drop if scbanco==.
drop if scbanco<1 
drop if scbanco>8
rename scbanco bankscore

drop if max_age==.

gen ap=0
replace ap=1 if propensao=="AP"
gen av=0
replace av=1 if propensao=="AV"

gen nooferta=0
replace nooferta=1 if oferta=="NÃO"
replace nooferta=1 if oferta=="NÃƒO"
replace nooferta=1 if oferta=="Não"

gen noemail=0
replace noemail=1 if email==.
replace noemail=1 if email==0

replace crediario_acum=1 if crediario_acum>1
replace lis_acum=1 if lis_acum>1
replace num_titulo=4 if num_titulo>4

tab cluster

gen grupo="Outro"
replace grupo="A" if cluster=="A1" | cluster=="A2" | cluster=="A3"
replace grupo="B" if cluster=="W1" | cluster=="W2"
replace grupo="C" if cluster=="W3" | cluster=="W4"
tab grupo


preserve
keep if grupo=="C"
save base_grupoC.dta, replace
restore

preserve
keep if grupo=="B"
save base_grupoB.dta, replace
restore

preserve
keep if grupo=="A"
save base_grupoA.dta,replace
restore

************************************Grupo C (using Cluster 7 algorithim) *********************************
clear
use base_grupoC.dta

replace  reneg_acum=1 if  reneg_acum>1
replace pib=26607 if pib==.
replace desconto=.48 if desconto<=0 | desconto==.
gen new_valor_avista_acum=valor_avista_acum
replace new_valor_avista_acum=4000 if new_valor_avista_acum>4000

*********Optimized Algorithm*****CLUSTER 7 ONLY *will use for Grupo C*****************************
gen scorepb=1/(1+exp(-(1.707979*conspag4-0.3043408*noemail-0.6903766*av-0.8048723*difbal-0.4038154*crediario_acum+0.3983573*bankscore-0.0215972*desconto+0.1311366*fonos-0.0001654*max_age+0.00000469*pib-2.067844)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*new_valor_avista_acum
drop if scorepb==.


replace scorebf=scorebf*1.30 if flag_alo_cliente_3m==1 & goodigit==0
replace scorebf=scorebf*1.50 if flag_alo_cliente_3m==1 & goodigit==1
replace scorebf=scorebf*1.25 if goodigit==1 & flag_alo_cliente_3m==0
replace scorebf=scorebf*.30 if scorepb<.01

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

rename grupobf grupobfABC
keep cpf cluster scorepb scorebf bankscore grupobfABC valor_avista_acum
save scores_internal_itsv_it_corr_grupoC_`today'.dta, replace


***********************Grupo A & B (using*ALL OTHER CLUSTERS (EXCEPT CLUSTER 7)) *********************************
clear
use base_grupoB.dta
append using base_grupoA

replace  reneg_acum=1 if  reneg_acum>1
replace pib=26607 if pib==.
replace desconto=.19 if desconto<0 | desconto==.
gen new_valor_avista_acum=valor_avista_acum
replace new_valor_avista_acum=5000 if new_valor_avista_acum>5000
*********Optimized Algorithm*****All CLUSTERS EXCEPT CLUSTER7 ******************************
gen scorepb=1/(1+exp(-(0.2336842*bankscore+0.064396*fonos-0.0005485*max_age+0.0184696*max_antig-0.1492675*lis_acum+0.1768948*titcart_acum-0.3218751*crediario_acum-0.3448461*tdc_acum-0.2960971*av-0.423786*noemail+1.357879*conspag4-3.0641)))					   												 							 				 								 						 		 					  		 										   		
gen scorebf=scorepb*scorepb*new_valor_avista_acum
drop if scorepb==.


preserve
keep if grupo=="A"

replace scorebf=scorebf*1.30 if flag_alo_cliente_3m==1 & goodigit==0
replace scorebf=scorebf*1.50 if flag_alo_cliente_3m==1 & goodigit==1
replace scorebf=scorebf*1.25 if goodigit==1 & flag_alo_cliente_3m==0
replace scorebf=scorebf*.30 if scorepb<0.0004

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

rename grupobf grupobfABC
keep cpf cluster scorepb scorebf bankscore grupobfABC valor_avista_acum
save scores_internal_itsv_it_corr_grupoA_`today'.dta, replace
restore

preserve
keep if grupo=="B"

replace scorebf=scorebf*1.30 if flag_alo_cliente_3m==1 & goodigit==0
replace scorebf=scorebf*1.50 if flag_alo_cliente_3m==1 & goodigit==1
replace scorebf=scorebf*1.25 if goodigit==1 & flag_alo_cliente_3m==0
replace scorebf=scorebf*.30 if scorepb<0.0003

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
rename grupobf grupobfABC
keep cpf cluster scorepb scorebf bankscore grupobfABC valor_avista_acum
save scores_internal_itsv_it_corr_grupoB_`today'.dta, replace
restore

******************consolidate grupo files into one dta grupo file
clear
use scores_internal_itsv_it_corr_grupoA_`today'.dta
append using scores_internal_itsv_it_corr_grupoB_`today'.dta
append using scores_internal_itsv_it_corr_grupoC_`today'.dta
sort cpf
save scores_iternal_itsv_it_corr_consolidated_grupos_`today'.dta, replace
**********************And now force by cluster*****************************************
clear
use scores_internal_itsv_it_corr_grupoA_`today'.dta

preserve
keep if cluster=="A1"

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
rename grupobf grupobfcluster
keep cpf cluster scorepb scorebf bankscore grupobfABC grupobfcluster valor_avista_acum
save scores_internal_itsv_it_corr_clusterA1_`today'.dta, replace
restore

preserve
keep if cluster=="A2"

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
rename grupobf grupobfcluster
keep cpf cluster scorepb scorebf bankscore grupobfABC grupobfcluster valor_avista_acum
save scores_internal_itsv_it_corr_clusterA2_`today'.dta, replace
restore

preserve
keep if cluster=="A3"

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
rename grupobf grupobfcluster
keep cpf cluster scorepb scorebf bankscore grupobfABC grupobfcluster valor_avista_acum
save scores_internal_itsv_it_corr_clusterA3_`today'.dta, replace
restore

******************************************Cluster W1 and W2********************

clear
use scores_internal_itsv_it_corr_grupoB_`today'.dta


preserve
keep if cluster=="W1"

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
rename grupobf grupobfcluster
keep cpf cluster scorepb scorebf bankscore grupobfABC grupobfcluster valor_avista_acum
save scores_internal_itsv_it_corr_clusterW1_`today'.dta, replace
restore

preserve
keep if cluster=="W2"

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
rename grupobf grupobfcluster
keep cpf cluster scorepb scorebf bankscore grupobfABC grupobfcluster valor_avista_acum
save scores_internal_itsv_it_corr_clusterW2_`today'.dta, replace
restore

******************************************Cluster W1 and W2********************

clear
use scores_internal_itsv_it_corr_grupoC_`today'.dta


preserve
keep if cluster=="W3"

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
rename grupobf grupobfcluster
keep cpf cluster scorepb scorebf bankscore grupobfABC grupobfcluster valor_avista_acum
save scores_internal_itsv_it_corr_clusterW3_`today'.dta, replace
restore

preserve
keep if cluster=="W4"

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
rename grupobf grupobfcluster
keep cpf cluster scorepb scorebf bankscore grupobfABC grupobfcluster valor_avista_acum
save scores_internal_itsv_it_corr_clusterW4_`today'.dta, replace
restore


*************Consolidate DTA cluster files into one consolidated dta file****
use scores_internal_itsv_it_corr_clusterW4_`today'.dta
append using scores_internal_itsv_it_corr_clusterW3_`today'.dta
append using scores_internal_itsv_it_corr_clusterW2_`today'.dta
append using scores_internal_itsv_it_corr_clusterW1_`today'.dta
append using scores_internal_itsv_it_corr_clusterA1_`today'.dta
append using scores_internal_itsv_it_corr_clusterA2_`today'.dta
append using scores_internal_itsv_it_corr_clusterA3_`today'.dta
sort cpf
save scores_internal_itsv_it_corr_consolidated_clusters_`today'.dta, replace

*****************************merge cluster and grupo dta file***********
clear
use scores_internal_itsv_it_corr_consolidated_clusters_`today'.dta
merge 1:1 cpf using scores_iternal_itsv_it_corr_consolidated_grupos_`today'.dta
tab _merge
keep if _merge==3

drop bankscore _merge
bysort cpf: keep if _n==1
outsheet using scores_itsv_it_corr_cons_`today'.txt, delimiter (";") replace

************new code to create dataset of cut offs by groups*********
use scores_internal_itsv_it_corr_grupoA_`today'.dta, clear
egen minbf1=min(scorebf) if grupobfABC=="1"
egen minbf2=min(scorebf) if grupobfABC=="2"
egen maxbf2=min(scorebf) if grupobfABC=="1"
egen minbf3=min(scorebf) if grupobfABC=="3"
egen maxbf3=min(scorebf) if grupobfABC=="2"
egen minbf4=min(scorebf) if grupobfABC=="4"
egen maxbf4=min(scorebf) if grupobfABC=="3"
egen minbf5=min(scorebf) if grupobfABC=="5"
egen maxbf5=min(scorebf) if grupobfABC=="4"
egen minbf6=min(scorebf) if grupobfABC=="6"
egen maxbf6=min(scorebf) if grupobfABC=="5"
egen minbf7=min(scorebf) if grupobfABC=="7"
egen maxbf7=min(scorebf) if grupobfABC=="6"
egen minbf8=min(scorebf) if grupobfABC=="8"
egen maxbf8=min(scorebf) if grupobfABC=="7"
egen minbf9=min(scorebf) if grupobfABC=="9"
egen maxbf9=min(scorebf) if grupobfABC=="8"
egen maxbf10=min(scorebf) if grupobfABC=="9"

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
rename grupobfABC bogus
sort bogus

cd "C:\Bossa Nova\collections agency models\itsv\it PF"
save itsv_it_corr_grupoA_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\itsv\it PF"
local drive = "`mesyr'"
cd "`drive'"
********************************End Automated Route & Path Code******************

************new code to create dataset of cut offs by groups*********
use scores_internal_itsv_it_corr_grupoB_`today'.dta, clear
egen minbf1=min(scorebf) if grupobfABC=="1"
egen minbf2=min(scorebf) if grupobfABC=="2"
egen maxbf2=min(scorebf) if grupobfABC=="1"
egen minbf3=min(scorebf) if grupobfABC=="3"
egen maxbf3=min(scorebf) if grupobfABC=="2"
egen minbf4=min(scorebf) if grupobfABC=="4"
egen maxbf4=min(scorebf) if grupobfABC=="3"
egen minbf5=min(scorebf) if grupobfABC=="5"
egen maxbf5=min(scorebf) if grupobfABC=="4"
egen minbf6=min(scorebf) if grupobfABC=="6"
egen maxbf6=min(scorebf) if grupobfABC=="5"
egen minbf7=min(scorebf) if grupobfABC=="7"
egen maxbf7=min(scorebf) if grupobfABC=="6"
egen minbf8=min(scorebf) if grupobfABC=="8"
egen maxbf8=min(scorebf) if grupobfABC=="7"
egen minbf9=min(scorebf) if grupobfABC=="9"
egen maxbf9=min(scorebf) if grupobfABC=="8"
egen maxbf10=min(scorebf) if grupobfABC=="9"

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
rename grupobfABC bogus
sort bogus

cd "C:\Bossa Nova\collections agency models\itsv\it PF"
save itsv_it_corr_grupoB_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\itsv\it PF"
local drive = "`mesyr'"
cd "`drive'"
********************************End Automated Route & Path Code******************

************new code to create dataset of cut offs by groups*********
use scores_internal_itsv_it_corr_grupoC_`today'.dta, clear

egen minbf1=min(scorebf) if grupobfABC=="1"
egen minbf2=min(scorebf) if grupobfABC=="2"
egen maxbf2=min(scorebf) if grupobfABC=="1"
egen minbf3=min(scorebf) if grupobfABC=="3"
egen maxbf3=min(scorebf) if grupobfABC=="2"
egen minbf4=min(scorebf) if grupobfABC=="4"
egen maxbf4=min(scorebf) if grupobfABC=="3"
egen minbf5=min(scorebf) if grupobfABC=="5"
egen maxbf5=min(scorebf) if grupobfABC=="4"
egen minbf6=min(scorebf) if grupobfABC=="6"
egen maxbf6=min(scorebf) if grupobfABC=="5"
egen minbf7=min(scorebf) if grupobfABC=="7"
egen maxbf7=min(scorebf) if grupobfABC=="6"
egen minbf8=min(scorebf) if grupobfABC=="8"
egen maxbf8=min(scorebf) if grupobfABC=="7"
egen minbf9=min(scorebf) if grupobfABC=="9"
egen maxbf9=min(scorebf) if grupobfABC=="8"
egen maxbf10=min(scorebf) if grupobfABC=="9"

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
rename grupobfABC bogus
sort bogus

cd "C:\Bossa Nova\collections agency models\itsv\it PF"
save itsv_it_corr_grupoC_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\itsv\it PF"
local drive = "`mesyr'"
cd "`drive'"
********************************End Automated Route & Path Code******************

************new code to create dataset of cut offs by groups*********
use scores_internal_itsv_it_corr_clusterA1_`today'.dta, clear
egen minbf1=min(scorebf) if grupobfcluster=="1"
egen minbf2=min(scorebf) if grupobfcluster=="2"
egen maxbf2=min(scorebf) if grupobfcluster=="1"
egen minbf3=min(scorebf) if grupobfcluster=="3"
egen maxbf3=min(scorebf) if grupobfcluster=="2"
egen minbf4=min(scorebf) if grupobfcluster=="4"
egen maxbf4=min(scorebf) if grupobfcluster=="3"
egen minbf5=min(scorebf) if grupobfcluster=="5"
egen maxbf5=min(scorebf) if grupobfcluster=="4"
egen minbf6=min(scorebf) if grupobfcluster=="6"
egen maxbf6=min(scorebf) if grupobfcluster=="5"
egen minbf7=min(scorebf) if grupobfcluster=="7"
egen maxbf7=min(scorebf) if grupobfcluster=="6"
egen minbf8=min(scorebf) if grupobfcluster=="8"
egen maxbf8=min(scorebf) if grupobfcluster=="7"
egen minbf9=min(scorebf) if grupobfcluster=="9"
egen maxbf9=min(scorebf) if grupobfcluster=="8"
egen maxbf10=min(scorebf) if grupobfcluster=="9"

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
rename grupobfcluster boguscluster
sort boguscluster

cd "C:\Bossa Nova\collections agency models\itsv\it PF"
save itsv_it_corr_clusterA1_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\itsv\it PF"
local drive = "`mesyr'"
cd "`drive'"
********************************End Automated Route & Path Code******************

************new code to create dataset of cut offs by groups*********
use scores_internal_itsv_it_corr_clusterA2_`today'.dta, clear
egen minbf1=min(scorebf) if grupobfcluster=="1"
egen minbf2=min(scorebf) if grupobfcluster=="2"
egen maxbf2=min(scorebf) if grupobfcluster=="1"
egen minbf3=min(scorebf) if grupobfcluster=="3"
egen maxbf3=min(scorebf) if grupobfcluster=="2"
egen minbf4=min(scorebf) if grupobfcluster=="4"
egen maxbf4=min(scorebf) if grupobfcluster=="3"
egen minbf5=min(scorebf) if grupobfcluster=="5"
egen maxbf5=min(scorebf) if grupobfcluster=="4"
egen minbf6=min(scorebf) if grupobfcluster=="6"
egen maxbf6=min(scorebf) if grupobfcluster=="5"
egen minbf7=min(scorebf) if grupobfcluster=="7"
egen maxbf7=min(scorebf) if grupobfcluster=="6"
egen minbf8=min(scorebf) if grupobfcluster=="8"
egen maxbf8=min(scorebf) if grupobfcluster=="7"
egen minbf9=min(scorebf) if grupobfcluster=="9"
egen maxbf9=min(scorebf) if grupobfcluster=="8"
egen maxbf10=min(scorebf) if grupobfcluster=="9"

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
rename grupobfcluster boguscluster
sort boguscluster

cd "C:\Bossa Nova\collections agency models\itsv\it PF"
save itsv_it_corr_clusterA2_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\itsv\it PF"
local drive = "`mesyr'"
cd "`drive'"
********************************End Automated Route & Path Code******************

************new code to create dataset of cut offs by groups*********
use scores_internal_itsv_it_corr_clusterA3_`today'.dta, clear
egen minbf1=min(scorebf) if grupobfcluster=="1"
egen minbf2=min(scorebf) if grupobfcluster=="2"
egen maxbf2=min(scorebf) if grupobfcluster=="1"
egen minbf3=min(scorebf) if grupobfcluster=="3"
egen maxbf3=min(scorebf) if grupobfcluster=="2"
egen minbf4=min(scorebf) if grupobfcluster=="4"
egen maxbf4=min(scorebf) if grupobfcluster=="3"
egen minbf5=min(scorebf) if grupobfcluster=="5"
egen maxbf5=min(scorebf) if grupobfcluster=="4"
egen minbf6=min(scorebf) if grupobfcluster=="6"
egen maxbf6=min(scorebf) if grupobfcluster=="5"
egen minbf7=min(scorebf) if grupobfcluster=="7"
egen maxbf7=min(scorebf) if grupobfcluster=="6"
egen minbf8=min(scorebf) if grupobfcluster=="8"
egen maxbf8=min(scorebf) if grupobfcluster=="7"
egen minbf9=min(scorebf) if grupobfcluster=="9"
egen maxbf9=min(scorebf) if grupobfcluster=="8"
egen maxbf10=min(scorebf) if grupobfcluster=="9"

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
rename grupobfcluster boguscluster
sort boguscluster

cd "C:\Bossa Nova\collections agency models\itsv\it PF"
save itsv_it_corr_clusterA3_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\itsv\it PF"
local drive = "`mesyr'"
cd "`drive'"
********************************End Automated Route & Path Code******************

************new code to create dataset of cut offs by groups*********
use scores_internal_itsv_it_corr_clusterW1_`today'.dta, clear

egen minbf1=min(scorebf) if grupobfcluster=="1"
egen minbf2=min(scorebf) if grupobfcluster=="2"
egen maxbf2=min(scorebf) if grupobfcluster=="1"
egen minbf3=min(scorebf) if grupobfcluster=="3"
egen maxbf3=min(scorebf) if grupobfcluster=="2"
egen minbf4=min(scorebf) if grupobfcluster=="4"
egen maxbf4=min(scorebf) if grupobfcluster=="3"
egen minbf5=min(scorebf) if grupobfcluster=="5"
egen maxbf5=min(scorebf) if grupobfcluster=="4"
egen minbf6=min(scorebf) if grupobfcluster=="6"
egen maxbf6=min(scorebf) if grupobfcluster=="5"
egen minbf7=min(scorebf) if grupobfcluster=="7"
egen maxbf7=min(scorebf) if grupobfcluster=="6"
egen minbf8=min(scorebf) if grupobfcluster=="8"
egen maxbf8=min(scorebf) if grupobfcluster=="7"
egen minbf9=min(scorebf) if grupobfcluster=="9"
egen maxbf9=min(scorebf) if grupobfcluster=="8"
egen maxbf10=min(scorebf) if grupobfcluster=="9"

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
rename grupobfcluster boguscluster
sort boguscluster

cd "C:\Bossa Nova\collections agency models\itsv\it PF"
save itsv_it_corr_clusterW1_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\itsv\it PF"
local drive = "`mesyr'"
cd "`drive'"
********************************End Automated Route & Path Code******************

************new code to create dataset of cut offs by groups*********
use scores_internal_itsv_it_corr_clusterW2_`today'.dta, clear

egen minbf1=min(scorebf) if grupobfcluster=="1"
egen minbf2=min(scorebf) if grupobfcluster=="2"
egen maxbf2=min(scorebf) if grupobfcluster=="1"
egen minbf3=min(scorebf) if grupobfcluster=="3"
egen maxbf3=min(scorebf) if grupobfcluster=="2"
egen minbf4=min(scorebf) if grupobfcluster=="4"
egen maxbf4=min(scorebf) if grupobfcluster=="3"
egen minbf5=min(scorebf) if grupobfcluster=="5"
egen maxbf5=min(scorebf) if grupobfcluster=="4"
egen minbf6=min(scorebf) if grupobfcluster=="6"
egen maxbf6=min(scorebf) if grupobfcluster=="5"
egen minbf7=min(scorebf) if grupobfcluster=="7"
egen maxbf7=min(scorebf) if grupobfcluster=="6"
egen minbf8=min(scorebf) if grupobfcluster=="8"
egen maxbf8=min(scorebf) if grupobfcluster=="7"
egen minbf9=min(scorebf) if grupobfcluster=="9"
egen maxbf9=min(scorebf) if grupobfcluster=="8"
egen maxbf10=min(scorebf) if grupobfcluster=="9"

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
rename grupobfcluster boguscluster
sort boguscluster

cd "C:\Bossa Nova\collections agency models\itsv\it PF"
save itsv_it_corr_clusterW2_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\itsv\it PF"
local drive = "`mesyr'"
cd "`drive'"
********************************End Automated Route & Path Code******************

************new code to create dataset of cut offs by groups*********
use scores_internal_itsv_it_corr_clusterW3_`today'.dta, clear
egen minbf1=min(scorebf) if grupobfcluster=="1"
egen minbf2=min(scorebf) if grupobfcluster=="2"
egen maxbf2=min(scorebf) if grupobfcluster=="1"
egen minbf3=min(scorebf) if grupobfcluster=="3"
egen maxbf3=min(scorebf) if grupobfcluster=="2"
egen minbf4=min(scorebf) if grupobfcluster=="4"
egen maxbf4=min(scorebf) if grupobfcluster=="3"
egen minbf5=min(scorebf) if grupobfcluster=="5"
egen maxbf5=min(scorebf) if grupobfcluster=="4"
egen minbf6=min(scorebf) if grupobfcluster=="6"
egen maxbf6=min(scorebf) if grupobfcluster=="5"
egen minbf7=min(scorebf) if grupobfcluster=="7"
egen maxbf7=min(scorebf) if grupobfcluster=="6"
egen minbf8=min(scorebf) if grupobfcluster=="8"
egen maxbf8=min(scorebf) if grupobfcluster=="7"
egen minbf9=min(scorebf) if grupobfcluster=="9"
egen maxbf9=min(scorebf) if grupobfcluster=="8"
egen maxbf10=min(scorebf) if grupobfcluster=="9"

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
rename grupobfcluster boguscluster
sort boguscluster

cd "C:\Bossa Nova\collections agency models\itsv\it PF"
save itsv_it_corr_clusterW3_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\itsv\it PF"
local drive = "`mesyr'"
cd "`drive'"
********************************End Automated Route & Path Code******************

************new code to create dataset of cut offs by groups*********
use scores_internal_itsv_it_corr_clusterW4_`today'.dta, clear
egen minbf1=min(scorebf) if grupobfcluster=="1"
egen minbf2=min(scorebf) if grupobfcluster=="2"
egen maxbf2=min(scorebf) if grupobfcluster=="1"
egen minbf3=min(scorebf) if grupobfcluster=="3"
egen maxbf3=min(scorebf) if grupobfcluster=="2"
egen minbf4=min(scorebf) if grupobfcluster=="4"
egen maxbf4=min(scorebf) if grupobfcluster=="3"
egen minbf5=min(scorebf) if grupobfcluster=="5"
egen maxbf5=min(scorebf) if grupobfcluster=="4"
egen minbf6=min(scorebf) if grupobfcluster=="6"
egen maxbf6=min(scorebf) if grupobfcluster=="5"
egen minbf7=min(scorebf) if grupobfcluster=="7"
egen maxbf7=min(scorebf) if grupobfcluster=="6"
egen minbf8=min(scorebf) if grupobfcluster=="8"
egen maxbf8=min(scorebf) if grupobfcluster=="7"
egen minbf9=min(scorebf) if grupobfcluster=="9"
egen maxbf9=min(scorebf) if grupobfcluster=="8"
egen maxbf10=min(scorebf) if grupobfcluster=="9"

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
rename grupobfcluster boguscluster
sort boguscluster

cd "C:\Bossa Nova\collections agency models\itsv\it PF"
save itsv_it_corr_clusterW4_cutoffs.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\itsv\it PF"
local drive = "`mesyr'"
cd "`drive'"
********************************End Automated Route & Path Code******************

log close
exit
