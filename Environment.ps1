# Get environment variables
$myEnvironment = $env;
$windowsDirectories = $env:path.Split(";")

# Console host
$myHost = Get-Host
Write-Host $myHost.Version

# Useful
$profileExists = Test-Path $profile # Determine whether the profile exists
IF($profileExists -eq [bool]"False")
{
    New-Item -path $profile -type file -force
}
ELSE
{
    notepad $profile
}

# Set default location
Set-Location C:\

# Get compatibility aliases. Mainly DOS and Unix compatible
Get-Alias | Where-Object { $_.options -notmatch 'readonly' }

Get-Alias | Where-Object { $_.options -match 'readonly' }

# 1 character aliases that should simplify work in a console
Get-Alias ?