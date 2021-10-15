function Log-Message
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$LogMessage
    )

    #Write-Output ("{0} ::: {1}" -f (Get-Date), $LogMessage)
    $logOutput = ("{0} ::: {1}" -f (Get-Date), $LogMessage)
    $logName = Get-Date -Format "yyyy-MM-dd"
    echo "$logOutput" >> "$PSScriptRoot\logs\$logName.log"
    Write-Output $logOutput
}
