# Get all services
$allServices = Get-Service
$allServices | Sort-Object Status

# Get all processes
$runningProcesses = Get-Process

