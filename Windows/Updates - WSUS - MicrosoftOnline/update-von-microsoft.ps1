cls

$sw = [Diagnostics.Stopwatch]::StartNew()
Write-Host "---> Stopping Services"
try{
    Stop-Service -Name wuauserv -Force
    Stop-Service -Name CryptSvc -Force
}
catch {
    Write-Host "!! Error Stopping Services" -ErrorAction Stop
}
finally{
    $sw.Stop()
    Write-Host ("Execution Time: {0} milliseconds." -f $sw.ElapsedMilliseconds)
}


$sw.Reset()
$sw.Start()
Write-Host "---> Changing Registry and Deleting Folders"
try{
    Set-Itemproperty -path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name 'UseWUServer' -value 0
    Remove-Item "C:\Windows\SoftwareDistribution" -Force -Recurse
    Remove-Item "C:\Windows\System32\catroot2" -Force -Recurse
}
catch {
    Write-Host "!! Error Deleting Files" -ErrorAction Stop
}
finally{
    $sw.Stop()
    Write-Host ("Execution Time: {0} milliseconds." -f $sw.ElapsedMilliseconds)
}

$sw.Reset()
$sw.Start()

Write-Host "---> Restarting Services"
Start-Service -Name "wuauserv"

$sw.Stop()
Write-Host ("Execution Time: {0} milliseconds." -f $sw.ElapsedMilliseconds)