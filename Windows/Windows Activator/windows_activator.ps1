cls
# Load JSON Configuration
$jsonConfig = Get-Content -Path .\jobs\*.json -Raw | ConvertFrom-Json

$credential = Get-Credential

foreach ($input_file in $jsonConfig){
    foreach ($target in $input_file.targets) {
        Write-Output "Connecting to $target..."

        # Initialize PowerShell Session
        try {
            $session = New-PSSession -ComputerName $target -Credential $credential
        } catch {
            Write-Output "Failed to establish a connection to $target. Check if the server is running and accessible. Error: $_"
            exit
        }

        # Execute command and capture the output
        try {
            $output = Invoke-Command -Session $session -ScriptBlock {
                param($new_key)
                slmgr -ipk $new_key
                sleep 5
                slmgr -ato
                sleep 5
            } -ArgumentList $input_file.windows_key
        } catch {
            Write-Output "Failed to execute the command on $target. Error: $_"
            exit
        } finally {
            # Close the session
            Remove-PSSession -Session $session
        }
    }
}