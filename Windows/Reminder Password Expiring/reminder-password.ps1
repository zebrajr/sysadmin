Import-Module ActiveDirectory
. ./secrets.ps1

Get-ADUser -filter * -properties PasswordLastSet,EmailAddress,GivenName,Surname -SearchBase $SEARCHBASE | foreach {
  $PasswordSetDate=$_.PasswordLastSet
  $maxPasswordAgeTimeSpan = $null
  $maxPasswordAgeTimeSpan = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge

  $today=get-date
  $ExpiryDate=$passwordSetDate + $maxPasswordAgeTimeSpan

  $daysleft=$ExpiryDate-$today

  $display=$daysleft.days
  $UserName=$_.GivenName
  $SurName=$_.Surname

  if ($display -lt $AgeLimit -and $display -gt 0)
  {
    $MyVariable = "
    Dear $UserName $Surname,

    Your Windows password will expire in $display days. Please change your password whenever possible.

    When less then 15 Days remain, a few services will not allow a login, eg: VPN, ERP, etc.

    Tips for a secure password:
    A password doesn't have to be gibberish to be secure. We recommend a Passphrase that is easier to remember but hard to compromise.

    e.g:
    Want a new car? ThisYear:NewAudi300PS
    Waiting for Vacations? Target2021:VacationsinUSA
    Food? 1HotDogwithColaAfterWork
    Drinking? 5BeersADayIsNotMuch

    Do not use something like 'Test!1234', or Birthday, Working Place or similar combinations.

    With best regards,
    The IT Team

    *** This Message was automatically generated - please do not try to answer it.***

    "
    send-mailmessage -to $_.EmailAddress -from $EmailSender -Subject $EmailSubject -body $MyVariable  -smtpserver $EmailServerIP -encoding ([System.Text.Encoding]::UTF8)
  }
}
