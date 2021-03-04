************Development do file for Ag portfolio. Roy Ludwig April 2019*****
**********we received second set of files on March 20th**************************************************
clear all

display %tdNN_CCYY date(c(current_date), "DMY")

local mesyr : di %tdNN_CCYY date(c(current_date), "DMY")
di "`mesyr'"

local msyrnospc : di %tdNNCCYY date(c(current_date), "DMY")
di "`msyrnospc'"

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\ag"
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

! del trigfile.txt
log using ag_eavm_processing_`today'-`time'.log, replace

************Move any payment files from filezilla input to current directory***************
clear

cd "C:\Bossa Nova\collections agency models\ag\Payments"

! move /Y "C:\Filezilla\Clients\ag\Input\ag_pmnt_current.xlsx"
! rename *.xlsx Pagamentos_EAVM_current.xlsx

capture confirm file Pagamentos_EAVM_current.xlsx
if _rc==0 {
import excel using Pagamentos_EAVM_current.xlsx, clear allstring first case(l)
keep cpf_t pgt_vlr_debito_ctto pgt_pri_dt_pgto_ctto
gen newdate=date( pgt_pri_dt_pgto_ctto, "DMY")
format newdate %td
generate date_text2=string(newdate, "%tdDD/NN/CCYY")
drop pgt_pri_dt_pgto_ctto
rename date_text2 pgt_pri_dt_pgto_ctto
drop if pgt_vlr_debito_ctto==""
keep cpf_t pgt_vlr_debito_ctto pgt_pri_dt_pgto_ctto
save Pagamentos_curmes.dta, replace

cd "C:\Bossa Nova\collections agency models\ag\Payments\Previous"

! move /Y "C:\Bossa Nova\collections agency models\ag\Payments\Pagamentos_EAVM_current.xlsx"

cd "C:\Bossa Nova\collections agency models\ag\Payments"

*******************Compile Payments*******************************************************************
clear

use Pagamentos_Nov18.dta, clear
rename cpf cpf_t
append using Pagamentos_Dez18.dta
append using Pagamentos_Jan19.dta
append using Pagamentos_Fev19.dta
append using Pagamentos_Mar19.dta
append using Pagamentos_Apr19.dta
append using Pagamentos_curmes.dta
duplicates drop
gen lstcpf=substr(cpf_t,-2,2)

generate firstcpf= substr(cpf_t, 1, strlen(cpf_t) -6)

gen cpf11_pre=firstcpf + lstcpf
gen cpf11=string(real(cpf11), "%011.0f")

gen valorpagamento=pgt_vlr_debito_ctto
destring valorpagamento, replace
drop if valorpagamento==.

gen datapagamento=pgt_pri_dt_pgto_ctto

keep cpf11 valorpagamento datapagamento
sort cpf11
save pmnts_cpf_vlr_data_ag_eavm_nov18_curmes.dta, replace

******************now update bnds payment db************************************************************
clear
use pmnts_cpf_vlr_data_ag_eavm_nov18_curmes

rename cpf11 Col2
destring Col2, replace
rename datapagamento Col3
rename valorpagamento Col4

gen year_fp=substr(Col3,7,4)
gen month_fp=substr(Col3,4,2)
gen day_fp=substr(Col3,1,2)
replace Col3=year_fp+"-"+month_fp+"-"+day_fp

gen Col1="ag"
gen Col5="EAVM"
keep Col1 Col2 Col3 Col4 Col5
order Col1 Col2 Col3 Col4 Col5
count

drop if Col2==.

cd "C:\Bossa Nova\collections agency models\Censo"

save pmnts_ag_active.dta, replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\ag"
local drive = "`mesyr'"
cd "`drive'"
*/
************Move carga files from filezilla input to current directory***************
clear

! move /Y "C:\Filezilla\Clients\ag\Input\alga_*.txt"


*********************compile carga files *******************
clear
! dir alga_*.txt /a-d /b >filelist.txt, replace

infix str filename 1-50 using filelist.txt
count
gen ext=substr(filename,-3,.)
replace filename=subinstr(filename,".txt","",.)

keep filename 
local N=_N

forvalues i=1/`N' {
   preserve
   local name=filename[`i']
   infix str data_entrada 22-29 ///
	str  registro 1 ///
	str  location 2-7 ///
	str  basecpf 8-16 ///
	str  dvcpf 17-18 ///
	str  cacs 19-22 ///
	str  contr 23-25 ///
	str  cpf_cnpj_princ 26-34 ///
	str  cnpj_filial 35-38 ///
	str  cpf_cnpj_cntrl 39-40 ///
	str  func 41 ///
	str  banco 44-46 ///
	str  agencia 47-51 ///
	str  conta 52-64 ///
	str  dir_reg 65-68 ///
	str  cliente 69-113 ///
	str  seg_tit 114-158 ///
	str  dt_nasc 159-168 ///
	str  uf 169-170 ///
	str  iden_tel1 171 ///
	str  ddd_tel1 172-173 ///
	str  traco1_tel1 174 ///
	str  traco2_tel1 182 ///
	str  iden_tel2 187 ///
	str  ddd_tel2 188-189 ///
	str  traco1_tel2 190 ///
	str  traco2_tel2 198 ///
	str  iden_tel3 203 ///
	str  ddd_tel3 204-205 ///
	str  traco1_tel3 206 ///
	str  traco2_tel3 214 ///
	str  iden_tel4 219 ///
	str  ddd_tel4 220-221 ///
	str  traco1_tel4 222 ///
	str  traco2_tel4 230 ///
	str  iden_tel5 235 ///
	str  ddd_tel5 236-237 ///
	str  traco1_tel5 238 ///
	str  traco2_tel5 246 ///
	str  iden_tel6 251 ///
	str  ddd_tel6 252-253 ///
	str  traco1_tel6 254 ///
	str  traco2_tel6 262 ///
	str  rating 267-268 ///
	str  dt_desde 269-278 ///
	str  nat_oper 279-281 ///
	str  carteira 282-284 ///
	str  vcto_antig 285-294 ///
	str  vl_vcto_cor 295-309 ///
	str  perc_pagto 310-313 ///
	str  resp_contr 314-328 ///
	str  resp_cliente 329-343 ///
	str  prior_envio 344-346 ///
	str  ident_seg 347-355 ///
	str  produto 356-358 ///
	str  subproduto 359-361 ///
	str  familia 362 ///
	str  convenio 363-371 ///
	str  ger_regional 372-375 ///
	str  saldo_cart 376-396 ///
	str  saldo_ccmrcl 397-417 ///
	str  saldo_totcli 418-438 ///
	str  pd 439-443 ///
	str  bs1 444-446 ///
	str  cs1 447-449 ///
	str  ct1 450-452 ///
	str  num_contrato 453-469 ///
	str  dias_atraso 470-473 ///
	str  data_lig 478-483 ///
	str  term_code 487-488 ///
	str  cont_lig 489-491 ///
	using `name'.txt, clear
	count
	replace data_entrada=data_entrada[1]
	keep if registro=="1"
   save "`name'.dta", replace
   restore
}


********** *****************************
*************************now compile the dta files ******************************

clear

! dir alga_*.dta /a-d /b >dtafilelist.txt, replace

file open dtafiles using dtafilelist.txt, read
file read dtafiles line

use `line'
save eavm_ag_carga_ativa, replace
file read dtafiles line

while r(eof)==0 {
	append using `line'
	file read dtafiles line
}
file close dtafiles
save eavm_ag_carga_ativa, replace
*/
*******************************************************************
clear
use eavm_ag_carga_ativa

duplicates drop

drop registro func cliente seg_tit traco1_tel1 traco2_tel1 traco1_tel2 traco2_tel2 traco1_tel3 traco2_tel3 traco1_tel4 traco2_tel4 traco1_tel5 traco2_tel5
drop perc_pagto prior_envio ger_regional traco1_tel6 traco2_tel6 pd


tab bs1, missing
tab cs1, missing
****drop last 4 characters from a string**********
generate new4_saldo_totcli= substr(saldo_totcli, 1, strlen(saldo_totcli) -4)
generate new4_saldo_cart= substr(saldo_cart, 1, strlen(saldo_cart) -4)
generate new4_saldo_ccmrcl= substr(saldo_ccmrcl, 1, strlen(saldo_ccmrcl) -4)
destring new4_saldo_totcli new4_saldo_cart new4_saldo_ccmrcl , replace

gen saldo_totcli6=new4_saldo_totcli/100
gen saldo_cart6=new4_saldo_cart/100
gen saldo_ccmrcl6=new4_saldo_ccmrcl/100

drop saldo_cart saldo_ccmrcl saldo_totcli new4_saldo_totcli new4_saldo_cart new4_saldo_ccmrcl

destring vl_vcto_cor resp_contr resp_cliente dias_atraso, replace

**** Format Data de entrada *****************
gen dia_ref=substr(data_entrada,7,2)
gen mes_ref=substr(data_entrada,5,2)
gen ano_ref=substr(data_entrada,1,4)
egen mesasig=concat(ano_ref mes_ref)
destring dia_ref ano_ref  mes_ref , replace 
gen dataasig=mdy(mes_ref,dia_ref, ano_ref)
format dataasig %td
drop dia_ref mes_ref ano_ref data_entrada
tab mesasig

sort num_contrato dataasig
bysort num_contrato: keep if _n==1

gen pj=0
replace pj=1 if cnpj_filial!="0000"

gen cnpj15=cpf_cnpj_princ + cnpj_filial + cpf_cnpj_cntrl
gen	cpf11=cpf_cnpj_princ	+	cpf_cnpj_cntrl

gen cpfcnpj15 = string(real(cpf11),"%014.0f")
replace cpfcnpj15=cnpj15 if pj==1

*****************this code counts the number of unique dates for dataativa to determine number of unique lines***
by cpf11 num_contrato, sort: gen nvals = _n == 1 
by cpf11: replace nvals = sum(nvals)
by cpf11: replace nvals = nvals[_N] 
*******************************************************************************************
replace nvals=2 if nvals>2

gen loc101=0
replace loc101=1 if location=="010101"
gen loc102=0
replace loc102=1 if location=="010102"
gen loc301=0
replace loc301=1 if location=="301010"

drop location

gen bank237=0
replace bank237=1 if banco=="237"
drop banco

gen agency04025=0
replace agency04025=1 if agencia=="04025"
gen agency03750=0
replace agency03750=1 if agencia=="03750"

drop agencia

gen has_dir_reg=0
replace has_dir_reg=1 if dir_reg!=""
drop dir_reg

**** Format Data de nascimento *****************
replace dt_nasc="01/01/1975" if dt_nasc=="00/00/2000"
gen dia_ref=substr(dt_nasc,1,2)
gen mes_ref=substr(dt_nasc,4,2)
gen ano_ref=substr(dt_nasc,7,4)
destring dia_ref ano_ref  mes_ref , replace 
gen datanasc=mdy(mes_ref,dia_ref, ano_ref)
format datanasc %td
drop dia_ref mes_ref ano_ref dt_nasc

gen age=(dataasig-datanasc)/365
gen agerange=1 if age<=25 & age!=.
replace agerange=2 if age>25 & age<=35
replace agerange=3 if age>35
tab agerange

gen nouf=0
replace nouf=1 if uf==""

gen sp=0
replace sp=1 if uf=="SP"
gen rj=0
replace rj=1 if uf=="RJ"
gen ba=0
replace ba=1 if uf=="BA"
gen pe=0
replace pe=1 if uf=="PE"
gen mg=0
replace mg=1 if uf=="MG"
gen ce=0
replace ce=1 if uf=="CE"
gen al=0
replace al=1 if uf=="AL"
gen df=0
replace df=1 if uf=="DF"
gen pa=0
replace pa=1 if uf=="PA"
gen pb=0
replace pb=1 if uf=="PB"
gen am=0
replace am=1 if uf=="AM"
gen go=0
replace go=1 if uf=="GO"
gen ma=0
replace ma=1 if uf=="MA"
gen pr=0
replace pr=1 if uf=="PR"

gen tel1v=0
replace tel1v=1 if iden_tel1=="V"
gen tel1=0
replace tel1=1 if ddd_tel1!="00"
gen tel2v=0
replace tel2v=1 if iden_tel2=="V"
gen tel2=0
replace tel2=1 if ddd_tel2!="00"
gen tel3v=0
replace tel3v=1 if iden_tel3=="V"
gen tel3=0
replace tel3=1 if ddd_tel3!="00"
gen tel4v=0
replace tel4v=1 if iden_tel4=="V"
gen tel4=0
replace tel4=1 if ddd_tel4!="00"
gen tel5v=0
replace tel5v=1 if iden_tel5=="V"
gen tel5=0
replace tel5=1 if ddd_tel5!="00"
gen tel6v=0
replace tel6v=1 if iden_tel6=="V"
gen tel6=0
replace tel6=1 if ddd_tel6!="00"

gen fonos=tel1 + tel2 + tel3 + tel4 + tel5 + tel6
gen totalv=tel1v + tel2v + tel3v + tel4v + tel5v + tel6v

drop iden_tel1 ddd_tel1 iden_tel2 ddd_tel2 iden_tel3 ddd_tel3 iden_tel4 ddd_tel4 iden_tel5 ddd_tel5 iden_tel6 ddd_tel6

**** Format Data desde *****************
gen dia_ref=substr(dt_desde,1,2)
gen mes_ref=substr(dt_desde,4,2)
gen ano_ref=substr(dt_desde,7,4)
destring dia_ref  ano_ref  mes_ref , replace 
gen dataasoc=mdy(mes_ref,dia_ref, ano_ref)
format dataasoc %td
drop dia_ref mes_ref ano_ref dt_desde

gen tenure=dataasig-dataasoc
gen lowten=0
replace lowten=1 if tenure<360

gen nat_oper1=0
replace nat_oper1=1 if nat_oper=="001"
gen nat_oper13=0
replace nat_oper13=1 if nat_oper=="013"
gen nat_oper90=0
replace nat_oper90=1 if nat_oper=="090"
gen nat_oper93=0
replace nat_oper93=1 if nat_oper=="093"
gen nat_oper3=0
replace nat_oper3=1 if nat_oper=="3"
drop nat_oper

gen nocart=0
replace nocart=1 if carteira !=""
gen cart379=0
replace cart379=1 if carteira=="379"
gen cart385=0
replace cart385=1 if carteira=="385"
gen cart455=0
replace cart455=1 if carteira=="455"
gen cart530=0
replace cart530=1 if carteira=="530"
gen cart722=0
replace cart722=1 if carteira=="722"
gen cartdcc=0
replace cartdcc=1 if carteira=="DCC"

gen badcarts=0
replace badcarts=1 if inlist(carteira, "379", "385", "455", "530", "DCC")
drop carteira

**** Format vcto_antig *****************
gen dia_ref=substr(vcto_antig,1,2)
gen mes_ref=substr(vcto_antig,4,2)
gen ano_ref=substr(vcto_antig,7,4)
destring dia_ref  ano_ref  mes_ref , replace 
gen vctoantig=mdy(mes_ref,dia_ref, ano_ref)
format vctoantig %td
drop dia_ref mes_ref ano_ref vcto_antig

gen hasrating=0
replace hasrating=1 if rating !=""
gen arate=0
replace arate=1 if rating=="A"
gen drate=0
replace drate=1 if rating=="D"
gen crate=0
replace crate=1 if rating=="C"
drop rating

gen norte=0
replace norte=1 if inlist(uf, "RR", "AM", "AP", "PA", "TO", "RO", "AC")
gen nordeste=0
replace nordeste=1 if inlist(uf, "MA", "PI", "CE", "RN", "PE", "PB", "SE", "AL", "BA")
gen centeroeste=0
replace centeroeste=1 if inlist(uf, "MT", "MS", "GO")
gen sudeste=0
replace sudeste=1 if inlist(uf, "SP", "RJ", "ES", "MG")
gen sul=0
replace sul=1 if inlist(uf, "PR", "RS", "SC")

gen region="other"
replace region="norte" if norte==1
replace region="nordeste" if nordeste==1
replace region="centeroeste" if centeroeste==1
replace region="sudeste" if sudeste==1
replace region="sul" if sul==1
tab region

gen hasseg=0
replace hasseg=1 if ident_seg!=""
gen seg0=0
replace seg0=1 if ident_seg=="000"
gen seg2=0
replace seg2=1 if ident_seg=="002"
drop ident_seg

gen prod2=0
replace prod2=1 if produto=="002"
gen prod4=0
replace prod4=1 if produto=="004" | produto=="005"
gen prod11=0
replace prod11=1 if produto=="011"
gen badprods=0
replace badprods=1 if prod4==1 | prod11==1
drop produto

gen subprod1=0
replace subprod1=1 if subproduto=="001"
gen subprod6=0
replace subprod6=1 if subproduto=="006"
gen subprod8=0
replace subprod8=1 if subproduto=="008"
gen subprod157=0
replace subprod157=1 if subproduto=="157"
gen subprod255=0
replace subprod255=1 if subproduto=="255"
drop subproduto

gen fam3=0
replace fam3=1 if familia=="3"
gen fam5=0
replace fam5=1 if familia=="5"
gen fam6=0
replace fam6=1 if familia=="6"
drop familia

gen faixa="0"
replace faixa="1" if dias_atraso<=19
replace faixa="2" if dias_atraso>19 & dias_atraso<=29
replace faixa="3" if dias_atraso>29 & dias_atraso<=39
replace faixa="4" if dias_atraso>39
tab faixa

gen faixa2=1 if dias_atraso<=29
replace faixa2=2 if dias_atraso>29

gen nocon=0
replace nocon=1 if convenio=="000000000"

gen respcliente=0
replace respcliente=1 if resp_cliente>0

gen balrange=1 if saldo_totcli6<500
replace balrange=2 if saldo_totcli6>=500 & saldo_totcli6<1000
replace balrange=3 if saldo_totcli6>=1000 & saldo_totcli6<2000
replace balrange=4 if saldo_totcli6>=2000 & saldo_totcli6<2500
replace balrange=5 if saldo_totcli6>=2500 & saldo_totcli6<3000
replace balrange=6 if saldo_totcli6>=3000 & saldo_totcli6<3500
replace balrange=7 if saldo_totcli6>=3500 & saldo_totcli6<4500
replace balrange=8 if saldo_totcli6>=4500 & saldo_totcli6<5000
replace balrange=9 if saldo_totcli6>=5000

gen bs1_34=0
replace bs1_34 =1 if inlist(bs1, "003", "004", "013", "014", "023", "024")

gen cs1_0=0
replace cs1_0=1 if cs1=="000"
gen cs1_1=0
replace cs1_1=1 if cs1=="001"
gen cs1_2=0
replace cs1_2=1 if cs1=="002"
gen cs1_3=0
replace cs1_3=1 if cs1=="003"
gen cs1_11=0
replace cs1_11=1 if cs1=="011"
gen cs1_12=0
replace cs1_12=1 if cs1=="012"
gen cs1_13=0
replace cs1_13=1 if cs1=="013"
gen cs1_21=0
replace cs1_21=1 if cs1=="021"
gen cs1_22=0
replace cs1_22=1 if cs1=="022"
gen cs1_23=0
replace cs1_23=1 if cs1=="023"

drop uf mesasig cnpj15 cpfcnpj15 datanasc 
drop tel1v tel1 tel2v tel2 tel3v tel3 tel4v tel4 tel5v tel5 tel6v tel6
drop dataasoc vctoantig ct1 data_lig term_code cont_lig


bysort cpf11: egen  vlr_vcto_acum=total(vl_vcto_cor)
drop vl_vcto_cor
bysort cpf11: egen mean_dias_atraso=mean(dias_atraso)
drop dias_atraso
bysort cpf11: egen sdo_totcli_acum=total(saldo_totcli6)
drop saldo_totcli6
bysort cpf11: egen resp_cliente_acum=sum(respcliente)
drop respcliente
bysort cpf11: egen nocon_acum=sum(nocon)
drop nocon
bysort cpf11: egen mean_faixa2=mean(faixa2)
drop faixa2
bysort cpf11: egen fam6_acum=sum(fam6)
drop fam6
bysort cpf11: egen fam5_acum=sum(fam5)
drop fam5
bysort cpf11: egen fam3_acum=sum(fam3)
drop fam3
bysort cpf11: egen subprod1_acum=sum(subprod1)
drop subprod1
bysort cpf11: egen subprod6_acum=sum(subprod6)
drop subprod6
bysort cpf11: egen subprod8_acum=sum(subprod8)
drop subprod8
bysort cpf11: egen subprod157_acum=sum(subprod157)
drop subprod157
bysort cpf11: egen subprod255_acum=sum(subprod255)
drop subprod255
bysort cpf11: egen prod2_acum=sum(prod2)
drop prod2
bysort cpf11: egen prod4_acum=sum(prod4)
drop prod4
bysort cpf11: egen prod11_acum=sum(prod11)
drop prod11
bysort cpf11: egen seg2_acum=sum(seg2)
drop seg2
bysort cpf11: egen seg0_acum=sum(seg0)
drop seg0
bysort cpf11: egen hasseg_acum=sum(hasseg)
drop hasseg
bysort cpf11: egen sul_acum=sum(sul)
drop sul
bysort cpf11: egen sudeste_acum=sum(sudeste)
drop sudeste
bysort cpf11: egen centeroeste_acum=sum(centeroeste)
drop centeroeste
bysort cpf11: egen nordeste_acum=sum(nordeste)
drop nordeste
bysort cpf11: egen norte_acum=sum(norte)
drop norte
bysort cpf11: egen crate_acum=sum(crate)
drop crate
bysort cpf11: egen arate_acum=sum(arate)
drop arate
bysort cpf11: egen drate_acum=sum(drate)
drop drate
bysort cpf11: egen hasrating_acum=sum(hasrating)
drop hasrating
bysort cpf11: egen badcarts_acum=sum(badcarts)
drop badcarts
bysort cpf11: egen cartdcc_acum=sum(cartdcc)
drop cartdcc
bysort cpf11: egen cart722_acum=sum(cart722)
drop cart722
bysort cpf11: egen cart530_acum=sum(cart530)
drop cart530
bysort cpf11: egen cart455_acum=sum(cart455)
drop cart455
bysort cpf11: egen cart385_acum=sum(cart385)
drop cart385
bysort cpf11: egen cart379_acum=sum(cart379)
drop cart379
bysort cpf11: egen nocart_acum=sum(nocart)
drop nocart
bysort cpf11: egen nat_oper3_acum=sum(nat_oper3)
drop nat_oper3
bysort cpf11: egen nat_oper93_acum=sum(nat_oper93)
drop nat_oper93
bysort cpf11: egen nat_oper90_acum=sum(nat_oper90)
drop nat_oper90
bysort cpf11: egen nat_oper13_acum=sum(nat_oper13)
drop nat_oper13
bysort cpf11: egen nat_oper1_acum=sum(nat_oper1)
drop nat_oper1
bysort cpf11: egen lowten_acum=sum(lowten)
drop lowten
bysort cpf11: egen bank237_acum=sum(bank237)
drop bank237
bysort cpf11: egen loc301_acum=sum(loc301)
drop loc301
bysort cpf11: egen loc102_acum=sum(loc102)
drop loc102
bysort cpf11: egen loc101_acum=sum(loc101)
drop loc101
bysort cpf11: keep if _n==1

count

cd "C:\Bossa Nova\collections agency models\Censo"

gen cpf=cpf11
destring cpf, replace
format %014.0f cpf
merge 1:1 cpf using Payments_active_allagencies
tab _merge
drop if _merge==2
drop _merge

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
tab portfolio if conspag3==1

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\ag"
local drive = "`mesyr'"
cd "`drive'"

gen new_vlr_vcto_acum=vlr_vcto_acum
replace new_vlr_vcto_acum=1000  if new_vlr_vcto_acum>1000

****next algorithm is without collection score and behaviour score variables **********************************************
gen scrgdpmnt=1/(1+exp(-(0.2348365*pj+0.1089824*nvals+0.1769719*agency04025-1.01963*agency03750-0.9357907*has_dir_reg+0.0974707*fonos+0.0000503*tenure-0.036099*mean_dias_atraso+0.2464422*prod4_acum+0.0296438*sudeste_acum+0.4731535*nat_oper3_acum-0.0630887*lowten_acum+0.157672*conspag4-2.167189)))					   												 							 				 								 						 		 					  		 										   		
gen scrgdpmntbf=scrgdpmnt*scrgdpmnt*new_vlr_vcto_acum


gsort -scrgdpmntbf
gen orden2gd=[_n]
xtile groups_score2gd=orden2gd, nquantiles(4)
gen grupogdpmntbf="Alta" if groups_score2gd==1
replace grupogdpmntbf="Media Alta" if groups_score2gd==2
replace grupogdpmntbf="Media" if groups_score2gd==3
replace grupogdpmntbf="Baixa" if groups_score2gd==4
tab grupogdpmntbf

preserve
keep cpf11 dataasig grupogdpmntbf scrgdpmnt scrgdpmntbf vlr_vcto_acum sdo_totcli_acum
save internal_scores_ag_eavm_`today'-`time'.dta, replace
restore

rename grupogdpmntbf grupobossa
rename scrgdpmntbf scorebossa
drop vlr_vcto_acum sdo_totcli_acum scrgdpmnt dataasig
keep basecpf dvcpf contr cpf_cnpj_princ cnpj_filial cpf_cnpj_cntrl cpf11 grupobossa scorebossa 
order basecpf dvcpf contr cpf_cnpj_princ cnpj_filial cpf_cnpj_cntrl cpf11 grupobossa scorebossa
save scores_ag_eavm_`today'-`time'.dta, replace

outsheet using scores_ag_eavm_`today'-`time'.txt, noquote delimiter (";") replace

cd "C:\Filezilla\Clients\ag\Output"

*********next line to output file in filezilla output folder to trigger email notification***********
outsheet using scores_ag_eavm_`today'-`time'.txt, noquote delimiter (";") replace

***********next line to output file in winscp folder to trigger automatic upload via ag FTP********
cd "C:\Bossa Nova\collections agency models\ag\FTP"

outsheet using scores_ag_eavm_`today'-`time'.txt, noquote delimiter (";") replace

***DONT CHANGE FOLLOWING 3 LINES**** automatically ensures path is complete to current month and year**
cd "C:\Bossa Nova\collections agency models\ag"
local drive = "`mesyr'"
cd "`drive'"


outsheet using trigfile.txt, delimiter (";")replace


log close _all
exit, STATA clear 






