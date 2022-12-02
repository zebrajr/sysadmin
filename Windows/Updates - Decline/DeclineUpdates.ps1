Param(    
    [Parameter(Mandatory=$false, 
    ValueFromPipeline=$true, 
    ValueFromPipelineByPropertyName=$true, 
    ValueFromRemainingArguments=$false, 
    Position=0)] 
    [string]$wsus_name = "Localhost", #default to localhost
    [int]$wsus_port=8530
)


<#
    Configuration
#>
$declined_updates_log_name = 'log_declined_updates.txt'



<#
    Setup
#>

$declined_updates_log_file = $PSScriptRoot + '\' + $declined_updates_log_name



<#
    Logger Functions
#>
Function LogWrite{
    Param(
        [string]$log_string
    )
    $stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss:ffff")
    $output_string = "$stamp ::: $log_string"
    Add-Content $declined_updates_log_file -value $output_string
}



<#
    Main
#>

Function Decline-Updates{
    Param(
        [string]$wsus_name,
        [int]$wsus_port
    )
    Write-Host "Connecting to $wsus_name via $wsus_port"
    Write-Host "Logfile for declined updates: $declined_updates_log_file"
    
    
    $wsusserver = Get-WsusServer -Name $wsus_name -PortNumber $wsus_port
    $update_scope = New-Object -TypeName Microsoft.UpdateServices.Administration.UpdateScope

    $update_scope.ApprovedStates = 'NotApproved'

    $all_updates = $wsusserver.GetUpdates($update_scope)

    $changes_made = $false
    foreach($new_update in $all_updates){
        $decline_update = $false
        if ($new_update.IsBeta -eq $true){ $decline_update = $true }
        if ($new_update.PublicationState -eq "Expired"){ $decline_update = $true }
        if ($new_update.IsSuperseded -eq $true){ $decline_update = $true }
        if ($new_update.Title -match "ARM64"){ $decline_update = $true }
        if ($new_update.Title -match "x86"){$decline_update = $true }

        if ($decline_update -eq $true){
            LogWrite($new_update.Title)
            Get-WsusUpdate -UpdateId $new_update.Id.UpdateId | Deny-WsusUpdate
            $changes_made = $true
        }
    
    }

    # Invoke WSUS Server Cleanup
    if ($changes_made -eq $true){
        Write-Host "Changes were made, running cleanup"
        $response_cleanup = Invoke-WsusServerCleanup -updateServer $wsusserver -CleanupObsoleteComputers -CleanupUnneededContentFiles -CleanupObsoleteUpdates -CompressUpdates -DeclineExpiredUpdates -DeclineSupersededUpdates
    }
}


Decline-Updates -wsus_name $wsus_name -wsus_port $wsus_port