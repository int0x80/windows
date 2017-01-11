<#
.SYNOPSIS
  Change passwords for all AD users selecting from a password file.
.DESCRIPTION
  This script is used to reset all passwords for all domain users.  Valid uses include massive credential rotation, setting intentionally weak passwords for testing, etc.  A list of potential passwords must first be acquired/generated.  Run this on the Domain Controller.
  
  *IMPORTANT* Keep your password file small for fast testing.  The script reads the whole file into memory.  If you try to read rockyou.txt into memory, you might have a bad time.
.NOTES
  File Name     : ADPasswordReset.ps1
  Author        : int0x80
  Compatibility : PowerShell 2.0
  License       : WTFPL (http://www.wtfpl.net/)
.LINK
  Script hosted at https://github.com/int0x80/windows
.EXAMPLE
  ADPasswordReset -PasswordList .\500-worst-passwords.txt
.EXAMPLE
  ADPasswordReset -PasswordList .\twitter-banned.txt -Verbose
#>

function ADPasswordReset {
  [CmdletBinding()]
  Param (
    [Parameter(Mandatory=$TRUE,
                Position=0,
                ParameterSetName="PasswordList",
                ValueFromPipeline=$TRUE,
                ValueFromPipelineByPropertyName=$TRUE,
                HelpMessage="Path to password list.")]
    [ValidateNotNullOrEmpty()]
    [string]
    $PasswordList
  )

  Import-Module ActiveDirectory

  # -----------------------------------------------------------
  # Read the password list once into a variable.  This prevents
  # repeated file I/O.
  # -----------------------------------------------------------
  $password_list = Get-Content $PasswordList
  Write-Verbose "[+] Imported $($password_list.count) passwords from $($PasswordList)"

  # -----------------------------------------------------------
  # Get list of domain users. Exclude default accounts:
  #   Administrator, Guest, krbtgt
  # -----------------------------------------------------------
  $default_users = "Administrator", "Guest", "krbtgt"
  Get-ADUser -Filter * | Select-Object SamAccountName | ForEach-Object {
    If ($default_users -NotContains $_.SamAccountName) {
      $success = $FALSE
      
      Do {
        # -----------------------------------------------------------
        # Select a random password from the supplied list, and reset
        # the user's password.  Retry on failure.
        # -----------------------------------------------------------
        $plain_password = $password_list | Get-Random
        $new_password = $plain_password | ConvertTo-SecureString -AsPlainText -Force
        Set-ADAccountPassword $_.SamAccountName -NewPassword $new_password -Reset
        $success = $?
      } While ($success -eq $FALSE)  
      
      # -----------------------------------------------------------
      # Echo the new password for the account if -Verbose was set 
      # -----------------------------------------------------------
      Write-Verbose "[+] Set $($_.SamAccountName) to $($plain_password)"
    }
  }
}