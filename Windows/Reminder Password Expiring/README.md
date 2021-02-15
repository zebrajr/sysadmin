### Situation
Users connected to an Active Directory can't login to a service (via SSO) because the password is marked as to be changed, but the user has no idea the time to change the password is being enforced.

### Task
Notify users that the password needs to be change before disruption of service.

### Action
Make a copy of "secrets-sample.ps1" as "secrets.ps1"
Edit "secrets.ps1" with your Company Secrets
Run ./reminder-password.ps1 OR set it as a Scheduled Task

### Result
The users will become an email notifying them to change the Email

### Note
"ActiveDirectory" Powershell Module needs to be installed on the device running the script

### ToDo
