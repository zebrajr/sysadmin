### Situation
Sometimes, a few of my server would not install a major patch.

### Task
Be able to fix the issue by installing the update from the Microsoft Servers, therefore updating it to the newest update, but be fast and quick to get the client back to WSUS.

### Action
`./update-von-microsoft-.ps1`

Will set the client to update from Microsoft Online. Don't forget to allow it on your firewall.

`./update-von-wsus-.ps1`

Will set the client to update from your local WSUS Server.

### Result
Will stop the update service, delete the local updates, set a registry key to use (1) / not use (2) your WSUS Server.
Just check for updates again and it should find and download the new(s) updates.

### Note
The script does NOT configure your WSUS Server. It's assumed that WSUS servers configurations are correct and on the client.

### ToDo
- Update the script so it's possible to run it against a remote client. Should accept a *.csv file as well.
