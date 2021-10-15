<#
    [CONFIGURATION]
#>
# Path for JSON files to be worked though
$JSONBasePath = "C:\Users\Administrator.BSDOM\Desktop\FolderPermissions\jsons\"

# Base Path of the Folder Structure
$FolderBasePath = "D:\Shares\bsA"

# Users / Groups who should have Full Control
$FullControlList = "Administrator@BSDOM.LOC", "VORDEFINIERT\Administratoren", "SYSTEM"


<#
    [TODO]
    - Change Configuration to JSON
    - Base Path of the Folder Structure should be a sub configuration of the indiv. json
    - Set Owner
#>




<#
    [MAIN SCRIPT]
#>
cls
# Import Helper Functions
. "$PSScriptRoot\functions.ps1"

# Get all JSON files to work though
$jsonFiles = Get-ChildItem -Path $JSONBasePath

# For each json File Found
ForEach ($jsonItem in $jsonFiles){
    Log-Message "<<< New JSON '$jsonItem' >>>"
    # Loads the current JSON in memory
    $FullPath = $JSONBasePath + $jsonItem.Name
    $json = (Get-Content $FullPath -RAW) | ConvertFrom-Json

    # For Each Value in the JSON
    ForEach ($item in $json){
        # Get current ACL
        $currentPath = $FolderBasePath + "\" + $item.folderPath
        $acl = Get-Acl -Path $currentPath
        Log-Message "New Working Directory:"
        Log-Message "    $currentPath"


        # Identify all non FullControl permissions
        $rules = $acl.Access | Where-Object {
            ($_.IdentityReference -notin "$FullControlList")
        }

        Log-Message "Removing All Except FullControl"
        ForEach ($rule in $rules){
            $acl.RemoveAccessRule($rule) | Out-Null
        }

        Log-Message "Setting Inheritance Settings"
        $acl.SetAccessRuleProtection($item.isProtected, $item.preserveInheritance)
        $acl | Set-Acl $currentPath

        ForEach ($FullControlItem in $FullControlList){
            Log-Message "Adding Full Control Users: $FullControlItem"
            $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($FullControlItem, "FullControl", "ContainerInherit,ObjectInherit", "none", "Allow")
            $acl.SetAccessRule($accessRule)
            $acl | Set-Acl $currentPath
        }

        foreach ($readGroup in $item.readOnlyGroups){
            Log-Message "Adding Read and Execute Permissions: $readGroup"
            $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($readGroup, "ReadAndExecute", "ContainerInherit,ObjectInherit", "none", "Allow")
            $acl.SetAccessRule($accessRule)
            $acl | Set-Acl $currentPath
        }

        foreach ($writeGroup in $item.writeGroups){
            Log-Message "Adding Write Permissions: $writeGroup"
            $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($writeGroup, "Modify", "ContainerInherit,ObjectInherit", "none", "Allow")
            $acl.SetAccessRule($accessRule)
            $acl | Set-Acl $currentPath
        }

        if($item.replaceSub -eq $True){
            Log-Message "Overwriting SubDirectory Permissions"
            $subPathName = $currentPath + "\*"
            icacls $subPathName /q /c /t /reset | Out-Null
        }

    }
    Log-Message "<<< JSON '$jsonItem' Ended >>>"
    Log-Message "----------"
}
