<#
    [CONFIGURATION]
#>
# Path for JSON files to be worked though
$JSONBasePath = "C:\Users\Administrator.BSDOM\Desktop\FolderPermissions\jsons\"

# Base Path of the Folder Structure
$FolderBasePath = "C:\Users\Administrator.BSDOM\Desktop\FolderPermissions\test\"

# Users / Groups who should have Full Control
$FullControlList = "Administrator@BSDOM.LOC", "VORDEFINIERT\Administratoren", "SYSTEM"


<#
    [TODO]
#>




<#
    [MAIN SCRIPT]
#>
cls
# Import Helper Functions
. "$PSScriptROot\functions.ps1"

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
        $currentPath = $FolderBasePath + $item.folderPath
        $acl = Get-Acl -Path $currentPath
        Log-Message "New Working Directory:"
        Log-Message "    $currentPath"


        # Identify all non FullControl permissions
        $rules = $acl.Access | Where-Object {
            ($_.IdentityReference -notin "$FullControlList")
        }

        # Removes all non FullControl permissions
        ForEach ($rule in $rules){
            $acl.RemoveAccessRule($rule) | Out-Null
        }

        # Sets Inheritance Settings
        $acl.SetAccessRuleProtection($item.isProtected, $item.preserveInheritance)
        $acl | Set-Acl $currentPath

        # Add the Groups with Full Control
        ForEach ($FullControlItem in $FullControlList){
            $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($FullControlItem, "FullControl", "ContainerInherit,ObjectInherit", "none", "Allow")
            $acl.SetAccessRule($accessRule)
            $acl | Set-Acl $currentPath
        }

        # Adds the Groups with Read and Execute Permissions
        foreach ($readGroup in $item.readOnlyGroups){
            $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($readGroup, "ReadAndExecute", "ContainerInherit,ObjectInherit", "none", "Allow")
            $acl.SetAccessRule($accessRule)
            $acl | Set-Acl $currentPath
        }

        # Adds the Groups with Write Permissions
        foreach ($writeGroup in $item.writeGroups){
            $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($writeGroup, "Modify", "ContainerInherit,ObjectInherit", "none", "Allow")
            $acl.SetAccessRule($accessRule)
            $acl | Set-Acl $currentPath
        }

        # Check if Child Permissions should be replaced with Parent Permissions
        if($item.replaceSub -eq $True){
            $subPathName = $currentPath + "\*"
            Log-Message "Overwriting SubDirectory Permissions"
            icacls $subPathName /q /c /t /reset | Out-Null
        }

        Log-Message "----------"

    }
    Log-Message "<<< JSON '$jsonItem' Ended >>>"
}
