# Variables
# Change this values to fit your environment
$searchPath = "D:\f. Temp\keytechB7\imported"
$searchText = "12.62.3.163.0"


# Main Script
clear
cd $searchPath
$filesArray = New-Object System.Collections.ArrayList($null)

Get-ChildItem *.* -recurse | foreach-object {
    . "D:\f. Temp\keytechB7\searchExcel.ps1"
    $filesArray.Add($_) | Out-Null
}

$i=0
foreach ($f in $filesArray){
    Write-Progress -Activity “Searching Files” -status “Searching File: $f” -PercentComplete ($i / $filesArray.Count*100)
    Search-Excel -Source $f -SearchText $searchText | Format-Table
    $i++
}
