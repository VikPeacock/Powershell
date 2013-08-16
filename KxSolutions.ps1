param($arg1, $arg2);function LoadConfiguration($arg1){
    [xml](Get-Content $arg1);
}

function AliasFor($arg1, $arg2){    
    if ($arg1 -ne $null -and $arg2 -ne $null){
        New-Item alias:$arg1 -value $arg2
    }
}

$globalConfig = LoadConfiguration("SolutionsToCover.xml")

# Make dotCover available
if (Test-Path $globalConfig.Root.dotCover.Path)
{
    Write-Host "dotCover executable found";
    Write-Host "creating alias for dotCover";
    
    AliasFor "dotCover" $globalConfig.Root.dotCover.Path;
}
else 
{
    Write-Error "dotCover executable not found in " $globalConfig.Root.dotCover.Path
    Return
}

$coverageConfigName = $globalConfig.Root.CoverageConfiguration.Name;
$extractCodeCoverageScript = $globalConfig.Root.CoverageScript.Path;
$outputPath = $globalConfig.Root.Output.Path;

$solutions = $globalCOnfig.Root.Solutions.Solution;
New-Item -path $outputPath -name Stats.txt -type file;

$totalCoverageStats = @{}
foreach($solution in $solutions)
{
    $absoluteCoverageConfigPath = $solution.Path + "\" + $coverageConfigName;
    
    #dotCover analyse $absoluteCoverageConfigPath;
    .\ExtractCodeCoverageResults.ps1 -path $solution.Path -outputPath ($outputPath + "\" + $solution.Name) -totalStats $totalCoverageStats -solutionName $solution.Name;           
}

$totalCoverageStats | Out-File $outputPath\Stats.txt;