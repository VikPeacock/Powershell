# Get environment variables
$myEnvironment = $env;
$windowsDirectories = $env:path.Split(";")

# Console host
$myHost = Get-Host
Write-Host $myHost.Version