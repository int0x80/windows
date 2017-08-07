# Windows

This repository contains bits from messing around in Windows.  

# Table of Contents

1. [ADPasswordReset.ps1](#adpasswordresetps1)
2. [LabAccountImport-2008-R2.ps1](#labaccountimport-2008-r2ps1)
3. [Setup-VM.ps1](#setup-vmps1)

# ADPasswordReset.ps1

Reset all passwords for all domain users, excluding the default system users.

## Usage

```powershell
# First source in the cmdlet
> . Path\To\ADPasswordReset.ps1

# Then run with a password list
> ADPasswordReset -PasswordList .\500-worst-passwords.txt

# Optionally include -Verbose
> ADPasswordReset -PasswordList .\twitter-banned.txt -Verbose
```

# LabAccountImport-2008-R2.ps1

Create AD accounts using a CSV file from http://fakenamegenerator.com.  Originally by Carlos Perez (@darkoperator), this version is ported to 2008 R2.

## Usage

```powershell
# First source in the cmdlet
> . Path\To\LabAccountImport-2008-R2.ps1

# Dry-run and test the CSV
> Test-LabADUserList -Path .\FakeNameGenerator.com_cf327b9.csv

# Remove any duplicates from the CSV
> Remove-LabADUserDuplicate -Path .\FakeNameGenerator.com_cf327b9.csv -OutPath .\UniqueUsers.csv

# Import the generated users
> Import-LabADUser -Path .\UniqueUsers.csv -OrganizationalUnit Sales
```

# Setup-VM.ps1

Initialize base setup of free VMs from https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/.

## Usage

```powershell
> .\Setup-VM.ps1
```
