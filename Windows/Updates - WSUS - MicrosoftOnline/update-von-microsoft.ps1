cls


$sw = [Diagnostics.Stopwatch]::StartNew()


try{
  Set-Itemproperty -path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name 'UseWUServer' -value 0
  Write-Host 'Stopping all necessary services…'
  Get-Service -Name wuauserv,bits,cryptsvc,msiserver | Stop-Service

  Write-Host 'Removing all qmgr.dat files…'
  Remove-Item -Path "$env:ALLUSERSPROFILE\Application Data\Microsoft\Network\Downloader\qmgr*.dat"

  Write-Host 'Backing up Windows Update cache folders…'
  Rename-Item -Path "$env:SYSTEMROOT\SoftwareDistribution\DataStore" -NewName 'DataStore.bak'
  Rename-Item -Path "$env:SYSTEMROOT\SoftwareDistribution\Download" -NewName 'Download.bak'
  Rename-Item -Path "$env:SYSTEMROOT\System32\catroot2" -NewName 'catroot2.bak'

  Write-Host 'Resetting BITS and Windows Update services security descriptors…'
  $null = Start-Process -FilePath 'sc.exe' -ArgumentList 'sdset bits D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)'
  $null = Start-Process -FilePath 'sc.exe' -ArgumentList 'sdset wuauserv D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)'

  Write-Host 'Re-registering all requisite DLLs…'
  $dlls = @(
     'atl.dll'
     'urlmon.dll'
     'mshtml.dll'
     'shdocvw.dll'
     'browseui.dll'
     'jscript.dll'
     'vbscript.dll'
     'scrrun.dll'
     'msxml.dll'
     'msxml3.dll'
     'msxml6.dll'
     'actxprxy.dll'
     'softpub.dll'
     'wintrust.dll'
     'dssenh.dll'
     'rsaenh.dll'
     'gpkcsp.dll'
     'sccbase.dll'
     'slbcsp.dll'
     'cryptdlg.dll'
     'oleaut32.dll'
     'ole32.dll'
     'shell32.dll'
     'initpki.dll'
     'wuapi.dll'
     'wuaueng.dll'
     'wuaueng1.dll'
     'wucltui.dll'
     'wups.dll'
     'wups2.dll'
     'wuweb.dll'
     'qmgr.dll'
     'qmgrprxy.dll'
     'wucltux.dll'
     'muweb.dll'
     'wuwebv.dll'
  )
  foreach ($dll in $dlls) {
    regsvr32.exe "$env:SYSTEMROOT\System32\$dll" /s
  }

  Write-Host 'Removing WSUS registry values…'
  @('AccountDomainSid','PingID','SusClientId','SusClientIDValidation') | ForEach-Object {
     Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" -Name $_ -ErrorAction Ignore
  }

  ## Resets computer group membership
  Write-Host 'Resetting WSUS client cookie..,'
  $null = wuauclt.exe /resetauthorization

  Write-Host 'Starting all necessary services…'
  Get-Service -Name wuauserv,bits,cryptsvc | Start-Service

  Write-Host 'Initiating update cycle…'
  (New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()
  Write-Host 'Windows Update reset complete.'
}
catch {
    Write-Host "!! Something went wrong" -ErrorAction Stop
}
finally{
    $sw.Stop()
    Write-Host ("Execution Time: {0} milliseconds." -f $sw.ElapsedMilliseconds)
}
