function Get-WAUAvailableVersion{
    #Get Github latest version
    $WAUurl = 'https://api.github.com/repos/Romanitho/Winget-AutoUpdate/releases/latest'
    $Script:WAULatestVersion = ((Invoke-WebRequest $WAUurl -UseBasicParsing | ConvertFrom-Json)[0].tag_name).Replace("v","")
    return [version]$WAULatestVersion
}