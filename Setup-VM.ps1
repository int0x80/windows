<#
.SYNOPSIS
  Initialize base setup of Windows 10 VM.
.DESCRIPTION
  This script is used to install a core set of applications and perform some configuration changes on the OS.  I personally use this for faster spin-up with the free VMs from https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/.  Edit at will.  Run as Administrator.
.NOTES
  File Name     : Setup-VM.ps1
  Author        : int0x80
  Compatibility : PowerShell 2.0
  License       : WTFPL (http://www.wtfpl.net/)
.LINK
  Script hosted at https://github.com/int0x80/WINDOWS
#>


function Disable-LockScreen {
  [CmdletBinding()]

  # -----------------------------------------------------------
  # Check the registry path
  # -----------------------------------------------------------
  $RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
  $RegistryKey = Get-ItemProperty -Path $RegistryPath -Name "NoLockScreen" -ErrorAction SilentlyContinue
  $LockScreenValue = $RegistryKey.NoLockScreen

  # -----------------------------------------------------------
  # Toggle the setting if necessary
  # -----------------------------------------------------------
  If($LockScreenValue -ne 1 ) {
    New-Item -Path $RegistryPath -ErrorAction SilentlyContinue  | Out-Null 
    New-ItemProperty -Path $RegistryPath -Type "DWORD" -Name "NoLockScreen" -Value 1 | Out-Null 
  }

  Write-Host "[+] Disabled the lock screen."
}


function Disable-Sleep {
  # -----------------------------------------------------------
  # I wrote this on an airplane
  # -----------------------------------------------------------
  C:\WINDOWS\System32\powercfg.exe -change -monitor-timeout-ac 0
  C:\WINDOWS\System32\powercfg.exe -change -monitor-timeout-dc 0
  C:\WINDOWS\System32\powercfg.exe -change -disk-timeout-ac 0
  C:\WINDOWS\System32\powercfg.exe -change -disk-timeout-dc 0
  C:\WINDOWS\System32\powercfg.exe -change -standby-timeout-ac 0
  C:\WINDOWS\System32\powercfg.exe -change -standby-timeout-dc 0
  C:\WINDOWS\System32\powercfg.exe -change -hibernate-timeout-ac 0
  C:\WINDOWS\System32\powercfg.exe -change -hibernate-timeout-dc 0

  Write-Host "[+] Disabled sleep mode."
}


function Install-Chocolatey {
  # -----------------------------------------------------------
  # Ez pz
  # -----------------------------------------------------------
  iex ((new-object net.webclient).DownloadString("https://chocolatey.org/install.ps1"))
  Write-Host "[+] Installed Chocolatey."
}


function Install-Apps {
  # -----------------------------------------------------------
  # My personal selection of apps, update with your own set
  # -----------------------------------------------------------
  choco install googlechrome -y
  choco install vmwarevsphereclient -y
  choco install libreoffice -y
  choco install notepadplusplus.install -y
  choco install vlc -y
  choco install cmder -y
  choco install conemu -y
  choco install peazip.install -y
  choco install firefox -y
  choco install sysinternals -y
  choco install gimp -y

  Write-Host "[+] Installed individual applications."
}


Disable-LockScreen
Disable-Sleep
Install-Chocolatey
Install-Apps
