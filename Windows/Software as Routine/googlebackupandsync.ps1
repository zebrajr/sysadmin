$ProcessPath = "C:\Program Files\Google\Drive\googledrivesync.exe"
$ProcessName = "googledrivesync"
$WaitTimeMinutes = 10




$Process = Start-Process -FilePath $ProcessPath
$WaitTimeMinutes = $WaitTimeMinutes*60
Start-Sleep -Seconds $WaitTimeMinutes
clear
$ProcessToHandle = Get-Process -Name $ProcessName
foreach ($i in $ProcessToHandle){
    Stop-Process -InputObject $i
}
