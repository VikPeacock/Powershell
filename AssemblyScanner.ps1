function ScanAssembly($assemblyPath) {
    [reflection.assemblyname]::GetAssemblyName($assemblyPath) 
}

$assemblies = Get-ChildItem *.dll

foreach($assembly in $assemblies)
{
    $assemblyInfo = ScanAssembly($assembly);
    $assemblyInfo | Format-List; # | where $assemblyInfo.ProcessorArchitecture.value__ -eq "None";      
    $assemblyInfo
}