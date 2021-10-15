# Configuration as Code (CaC) for File Server Shared Folders

### Situation

You have to manage permissions on many different shares, with many different requirements from different management positions

### Target

A scripted way to be sure that the permissions are set and kept correctly configured. Documentation to make internal and external audits faster and easier

### Action

Using Powershell to read JSON values and do the changes as necessary

### Result

Configuration does no longer need a GUI, is automatic, reproducible, and frees time from the employee. Changing 1 or 100 Shares takes the same time to the employee.

## JSON Values:

| Option              | Description                                                         | Settings                                         | Notes                                                  |
| ------------------- | ------------------------------------------------------------------- | ------------------------------------------------ | ------------------------------------------------------ |
| folderPath          | Folder Path after BasePath                                          | folder1 <br> folder1\\\\folder2                  | Backslash need to be escaped<br>"\\\\"                 |
| readOnlyGroups      | Which groups should have read permissions                           | acl_rosfs03_bsa_it_RO                            |                                                        |
| writeGroups         | Which groups should have write permissions                          | acl_rosfs03_bsa_it_RW                            |                                                        |
| isProtected         | Protect from or Allow Inheritance                                   | true: No Inheritance<br>false: Allow Inheritance | if(False) preserveInheritance is ignored               |
| preserveInheritance | Preserve or Remove Inherited Rules                                  | true: Preserve<br>false: Remove                  |                                                        |
| replaceSub          | If Child objects should be replaced with current folder permissions | true<br>false                                    | This can be used to ensure sub-directories consistency |
