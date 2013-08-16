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
$outputPath = $globalConfig.Root.Output.Path;

$solutions = $globalCOnfig.Root.Solutions.Solution;
if (-Not(Test-Path ([string]($outputPath + "\Stats.txt"))))
{
    New-Item -path $outputPath -name Stats.txt -type file;
}
    
$totalCoverageStats = New-Object Collections.Generic.List[PSObject]
foreach($solution in $solutions)
{
    $absoluteSolutionPath = [string]($globalCOnfig.Root.Solutions.RootPath + $solution.RelativePath);
    $absoluteCoverageConfigPath = $absoluteSolutionPath + "\" + $coverageConfigName;
    
    #dotCover analyse $absoluteCoverageConfigPath;
    .\ExtractCodeCoverageResults.ps1 -path $absoluteSolutionPath -outputPath ($outputPath + "\" + $solution.Name) -totalCoverageStats $totalCoverageStats -solutionName $solution.Name;           
}

$totalCoverageStats | Out-File $outputPath\Stats.txt;