* Rludwig Update Sept. 3 2020
* This STATA do file to process AWS costs report and break out expenses for different Caperio accounts

clear

cd "C:\Filezilla\Clients\Sertec\S3 Cost Report\Unzipped Report"

import delimited using AWS_First_Cost_Usage_Report-00001.csv

drop if strpos(lineitemlineitemdescription, "free tier")>0

keep if strpos(lineitemproductcode, "transcribe")>0

if strpos(lineitemproductcode, "transcribe")>0 {
gen transdate=substr(lineitemusagestartdate, 1,10)

gen statatransdate=date(transdate, "YMD")

sort statatransdate

keep if productregion=="us-east-2"
keep if lineitemlineitemtype=="Usage"

gen year=substr(transdate, 1,4)
gen month=substr(transdate, 6,2)
gen day=substr(transdate, 9,2)

gen caspiodate=month + "/" + day + "/" + year
gen caspiodate2=caspiodate

rename lineitemunblendedcost awscharge
rename lineitemblendedrate cost
rename lineitemusageamount seconds
gen minutes=seconds/60
replace minutes=round(minutes)

bysort caspiodate: egen awscharge_a=sum(awscharge)
bysort caspiodate: egen cost_a=sum(cost)
bysort caspiodate: egen seconds_a=sum(seconds)
bysort caspiodate: egen minutes_a=sum(minutes)

bysort caspiodate: keep if _n==1
drop awscharge cost seconds minutes
rename awscharge_a awscharge
rename cost_a cost
rename seconds_a seconds
rename minutes_a minutes

keep caspiodate awscharge cost seconds minutes caspiodate2
order caspiodate awscharge cost seconds minutes caspiodate2

export delimited using aws_transcribe_costs_agencias.csv, replace
}

exit, STATA clear
