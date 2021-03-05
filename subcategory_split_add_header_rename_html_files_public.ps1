# RLudwig Powershell script to split Caperio html files creating keyword snippets
# Updated Aug 8 2020

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat1.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat1_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat1_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat1.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat1.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat1.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat2.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat2_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat2_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat2.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat2.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat2.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat3.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat3_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat3_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat3.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat3.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat3.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat4.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat4_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat4_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat4.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat4.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat4.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat5.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat5_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat5_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat5.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat5.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat5.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat6.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat6_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat6_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat6.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat6.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat6.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat7.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat7_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat7_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat7.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat7.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat7.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }



#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat8.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat8_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat8_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat8.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat8.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat8.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


##########################################################################33

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat9.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat9_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat9_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat9.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat9.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat9.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat10.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat10_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat10_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat10.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat10.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat10.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################

#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat11.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat11_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat11_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat11.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat11.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat11.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat12.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat12_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat12_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat12.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat12.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat12.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat13.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat13_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat13_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat13.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat13.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat13.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat14.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat14_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat14_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat14.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat14.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat14.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################
<#
Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat15.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat15_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat15_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat15.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat15.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat15.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }
#>

#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat16.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat16_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat16_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat16.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat16.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat16.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat17.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat17_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat17_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat17.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat17.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat17.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat18.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat18_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat18_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat18.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat18.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat18.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat19.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat19_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat19_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat19.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat19.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat19.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat20.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat20_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat20_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat20.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat20.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat20.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat21.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat21_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat21_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat21.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat21.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat21.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat22.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat22_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat22_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat22.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat22.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat22.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat23.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat23_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat23_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat23.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat23.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat23.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat24.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat24_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat24_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat24.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat24.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat24.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat25.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat25_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat25_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat25.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat25.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat25.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat26.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat26_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat26_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat26.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat26.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat26.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat27.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat27_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat27_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat27.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat27.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat27.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat28.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat28_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat28_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat28.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat28.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat28.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat29.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat29_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat29_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat29.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat29.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat29.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat30.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat30_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat30_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat30.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat30.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat30.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat31.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat31_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat31_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat31.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat31.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat31.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat32.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat32_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat32_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat32.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat32.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat32.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat33.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat33_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat33_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat33.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat33.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat33.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat34.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat34_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat34_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat34.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat34.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat34.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat35.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat35_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat35_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat35.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat35.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat35.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat36.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat36_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat36_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat36.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat36.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat36.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat37.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat37_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat37_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat37.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat37.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat37.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat38.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat38_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat38_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat38.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat38.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat38.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat39.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat39_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat39_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat39.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat39.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat39.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat40.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat40_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat40_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat40.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat40.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat40.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat41.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat41_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat41_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat41.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat41.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat41.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################
<#
Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat42.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat42_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat42_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat42.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat42.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat42.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }
#>

#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat43.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat43_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat43_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat43.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat43.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat43.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat44.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat44_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat44_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat44.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat44.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat44.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat45.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat45_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat45_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat45.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat45.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat45.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat46.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat46_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat46_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat46.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat46.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat46.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat47.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat47_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat47_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat47.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat47.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat47.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat48.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat48_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat48_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat48.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat48.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat48.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat49.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat49_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat49_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat49.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat49.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat49.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }

#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat50.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat50_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat50_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat50.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat50.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat50.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat51.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat51_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat51_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat51.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat51.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat51.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }



#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat52.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat52_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat52_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat52.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat52.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat52.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat53.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat53_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat53_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat53.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat53.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat53.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat54.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat54_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat54_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat54.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat54.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat54.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat55.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat55_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat55_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat55.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat55.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat55.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat56.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat56_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat56_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat56.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat56.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat56.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat57.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat57_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat57_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat57.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat57.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat57.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat58.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat58_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat58_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat58.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat58.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat58.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat59.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat59_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat59_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat59.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat59.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat59.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat60.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat60_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat60_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat60.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat60.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat60.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat61.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat61_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat61_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat61.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat61.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat61.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat62.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat62_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat62_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat62.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat62.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat62.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat63.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat63_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat63_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat63.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat63.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat63.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat64.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat64_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat64_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat64.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat64.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat64.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat65.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat65_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat65_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat65.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat65.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat65.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat66.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat66_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat66_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat66.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat66.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat66.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################

#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat67.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat67_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat67_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat67.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat67.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat67.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################

#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat68.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat68_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat68_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat68.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat68.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat68.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat69.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat69_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat69_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat69.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat69.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat69.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }



#################################################

#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat70.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat70_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat70_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat70.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat70.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat70.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat71.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat71_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat71_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat71.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat71.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat71.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat72.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat72_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat72_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat72.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat72.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat72.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat73.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat73_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat73_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat73.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat73.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat73.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################
<#
Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat74.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat74_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat74_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat74.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat74.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat74.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }
#>

#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat75.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat75_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat75_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat75.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat75.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat75.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat76.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat76_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat76_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat76.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat76.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat76.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat77.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat77_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat77_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat77.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat77.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat77.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat78.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat78_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat78_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat78.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat78.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat78.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat79.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat79_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat79_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat79.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat79.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat79.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


#################################################
#################################################
#################################################

Set-Location -path "C:\Bossa Nova\audiototext\sc\pg Output"

$Default = [System.Text.Encoding]::Default

$InputFile = "C:\Bossa Nova\audiototext\sc\pg Output\subcat80.html"
$Reader = New-Object System.IO.StreamReader ($InputFile, $Default)
$a = 1


While (($Line = $Reader.ReadLine()) -ne $null)  {
    If ($Line -match "file:") {
        $OutputFile = "subcat80_split$a.html" 
        $a++
    }    
    Add-Content $OutputFile $Line 
}


Set-Location 'C:\Bossa Nova\audiototext\sc\pg Output'

$SearchPath = 'C:\Bossa Nova\audiototext\sc\pg Output'
$Searches = Select-String -Path $SearchPath\subcat80_split*.html -Pattern "Transcripts\\(.*?)\.flac.json-transcript.txt"
ForEach ($Search in $Searches)
{
    $NewName = $Search.Matches.Groups[1].Value.Replace(".flac.json-transcript.txt", "")
    write-host Rename: $($Search.Path) to "$NewName-subcat80.html"
    Rename-Item -Path $Search.Path -NewName "$NewName-subcat80.html" 
}

$header=@"
<HTML><HEAD><meta http-equiv="Content-Type" content="text/html; charset=windows-1252"><TITLE>Bossa Nova Data Solutions</TITLE><STYLE TYPE="text/css">
<!--
.syntax0 { }
.syntax4 { color: #000000; background-color: #FFF000; text-decoration: underline; }
.syntax5 { color: #000000; background-color: #80C0FF; text-decoration: underline; }
.syntax6 { color: #000000; background-color: #C0FF80; text-decoration: underline; }
.syntax7 { color: #000000; background-color: #FFC080; text-decoration: underline; }
.syntax8 { color: #000000; background-color: #C0C0C0; text-decoration: underline; }
.syntax9 { color: #000000; background-color: #80FFC0; text-decoration: underline; }
.syntax10 { color: #000000; background-color: #C080FF; text-decoration: underline; }
.syntax11 { color: #000000; background-color: #00F000; text-decoration: underline; }
.syntax12 { color: #000000; background-color: #FF80C0; text-decoration: underline; }
.syntax13 { text-decoration: underline; }
.syntax15 { color: #0000FF; font-weight: bold; text-decoration: underline; }
.syntax18 { color: #0000FF; text-decoration: underline; }
.syntax21 { color: #008000; font-weight: bold; }
-->
</STYLE></HEAD><BODY><PRE>
"@


Get-ChildItem "C:\Bossa Nova\audiototext\sc\pg Output" -Recurse -Filter 20*subcat80.html | Foreach-Object { 
    
    $header + (Get-Content $_.FullName | Out-String) | Set-Content $_.FullName
    }


