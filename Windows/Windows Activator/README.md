# Windows Activation Script

Read lists of targets and an activation key from json files, then for each target change the key and re-enable Windows activation.

## Note

Check the json files before running the script. Make sure you have a valid key for the targets you want to apply the script to.

### Error handling

At the beginning, the script requests the credentials to be used. If an error occurs (command invalid, not enough permissions, WinRM not enabled on the target computer, etc.), the script aborts to avoid locking out a user due to too many failed attempts.

### json file example

```
{
	
	"windows_key" : [ 12345-12345-12345-12345 ],
	"targets" : [
		"pc1.domain.tld",
		"pc2.domain.tld",
	]
}
```
