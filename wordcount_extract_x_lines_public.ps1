#####ROY LUDWIG updated July 1, 2020#####
## Extract x number of lines from each transcription and get wordcount from transcriptions 

Set-Location "C:\Bossa Nova\audiototext\sc\Text Transcripts"

$results= @{}
Get-ChildItem -Path "C:\Bossa Nova\audiototext\sc\Text Transcripts" -Filter *transcript.txt -Recurse | ForEach-Object{

    $count = Get-Content $_.FullName -Encoding UTF8| Measure-Object -Character -IgnoreWhiteSpace
    $results.Add($_.BaseName, $count.Characters)}
     
    
$results | Out-File "C:\Bossa Nova\audiototext\sc\Text Transcripts\wordcount.txt" 

###########this section to remove bom's from all csv files before processing in stata####
$MyPath = "C:\Bossa Nova\audiototext\sc\Text Transcripts\wordcount.txt" # read the file in
$MyFile = Get-Content $MyPath
$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
$MyPathOut = "C:\Bossa Nova\audiototext\sc\Text Transcripts\wordcount.txt" # export it here without BOM
[System.IO.File]::WriteAllLines($MyPathOut, $MyFile, $Utf8NoBomEncoding)


### extract first 25 lines from transcript files and output to new file with "beg" at end before extension
set-location "C:\Bossa Nova\audiototext\sc\Text Transcripts"
$files = Get-ChildItem "C:\Bossa Nova\audiototext\sc\Text Transcripts" -Filter *transcript.txt 
foreach ($f in $files){
    $outfile =$f.BaseName + "beg.txt"  
    Get-Content -Encoding UTF8 $f.FullName | Where-Object { $_.Trim() -ne '' } |Select -first 25 | Set-Content -Encoding UTF8 $outfile
}


### extract first 15 lines from transcript files and output to new file with "015" at end before extension
set-location "C:\Bossa Nova\audiototext\sc\Text Transcripts"
$files = Get-ChildItem "C:\Bossa Nova\audiototext\sc\Text Transcripts" -Filter *transcript.txt 
foreach ($f in $files){
    $outfile =$f.BaseName + "015.txt"  
    Get-Content -Encoding UTF8 $f.FullName | Where-Object { $_.Trim() -ne '' } | Select -first 15 | Set-Content -Encoding UTF8 $outfile
}


###extract last 25 lines from transcript files and output to new file with "end" at end before extension
set-location "C:\Bossa Nova\audiototext\sc\Text Transcripts"
$files = Get-ChildItem "C:\Bossa Nova\audiototext\sc\Text Transcripts" -Filter *transcript.txt 
foreach ($f in $files){
    $outfile =$f.BaseName + "end.txt"  
    Get-Content -Encoding UTF8 $f.FullName | Where-Object { $_.Trim() -ne '' }| Select -last 25 | Set-Content -Encoding UTF8 $outfile
}


### extract last2 lines from transcript files and output to new file with "lst2" at end before extension
set-location "C:\Bossa Nova\audiototext\sc\Text Transcripts"
$files = Get-ChildItem "C:\Bossa Nova\audiototext\sc\Text Transcripts" -Filter *transcript.txt 
foreach ($f in $files){
    $outfile =$f.BaseName + "lst2.txt"  
    Get-Content -Encoding UTF8 $f.FullName | Where-Object { $_.Trim() -ne '' }| Select -last 2 | Set-Content -Encoding UTF8 $outfile
}
#>