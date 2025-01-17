<#
.SYNOPSIS
Uninstall Winget-AutoUpdate 

.DESCRIPTION
Uninstall Winget-AutoUpdate (DEFAULT: clean old install)
https://github.com/Romanitho/Winget-AutoUpdate

.PARAMETER NoClean
Uninstall Winget-AutoUpdate (keep critical files)

.EXAMPLE
.\WAU-Uninstall.ps1 -NoClean

#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $False)] [Switch] $NoClean = $false
)

Write-Host "`n"
Write-Host "`t        888       888        d8888  888     888" -ForegroundColor Magenta
Write-Host "`t        888   o   888       d88888  888     888" -ForegroundColor Magenta
Write-Host "`t        888  d8b  888      d88P888  888     888" -ForegroundColor Magenta
Write-Host "`t        888 d888b 888     d88P 888  888     888" -ForegroundColor Magenta
Write-Host "`t        888d88888b888    d88P  888  888     888" -ForegroundColor Magenta
Write-Host "`t        88888P Y88888   d88P   888  888     888" -ForegroundColor Cyan
Write-Host "`t        8888P   Y8888  d88P    888  888     888" -ForegroundColor Magenta
Write-Host "`t        888P     Y888 d88P     888   Y8888888P`n" -ForegroundColor Magenta
Write-Host "`t                    Winget-AutoUpdate`n" -ForegroundColor Cyan
Write-Host "`t     https://github.com/Romanitho/Winget-AutoUpdate`n" -ForegroundColor Magenta
Write-Host "`t________________________________________________________`n`n"

try {
    Write-host "Uninstalling WAU..." -ForegroundColor Yellow
    #Get registry install location
    $InstallLocation = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Winget-AutoUpdate\" -Name InstallLocation
    
    #Check if installed location exists and delete
    if (Test-Path ($InstallLocation)) {

        if (!$NoClean) {
            Remove-Item "$InstallLocation\*" -Force -Recurse -Exclude "*.log"
        }
        else {
            #Keep critical files
            Get-ChildItem -Path $InstallLocation -Exclude *.txt,mods,logs | Remove-Item -Recurse -Force
        }
        Get-ScheduledTask -TaskName "Winget-AutoUpdate" -ErrorAction SilentlyContinue | Unregister-ScheduledTask -Confirm:$False
        Get-ScheduledTask -TaskName "Winget-AutoUpdate-Notify" -ErrorAction SilentlyContinue | Unregister-ScheduledTask -Confirm:$False    
        & reg delete "HKCR\AppUserModelId\Windows.SystemToast.Winget.Notification" /f | Out-Null
        & reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Winget-AutoUpdate" /f | Out-Null
        if (Test-Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Winget-AutoUpdate") {
            & reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Winget-AutoUpdate" /f | Out-Null
        }

        Write-host "Uninstallation succeeded!" -ForegroundColor Green
    }
    else {
        Write-host "$InstallLocation not found! Uninstallation failed!" -ForegroundColor Red
    }
}
catch {
    Write-host "`nUninstallation failed! Run as admin ?" -ForegroundColor Red
}

Start-sleep 2
