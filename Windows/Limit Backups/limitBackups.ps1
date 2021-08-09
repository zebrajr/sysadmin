$BackupPath   = "C:\Lexware\Backup"
$BackupLimit  = 30
Get-ChildItem $BackupPath -Recurse| where{-not $_.PsIsContainer}| sort CreationTime -desc| select -Skip $BackupLimit | Remove-Item -Force
