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