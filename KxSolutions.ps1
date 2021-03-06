param($arg1, $arg2);function LoadConfiguration($arg1){
    [xml](Get-Content $arg1);
}

$globalConfig = LoadConfiguration("SolutionsToCover.xml")

# Make dotCover available
if (Test-Path $globalConfig.Root.dotCover.Path)
{
    Write-Host "dotCover executable found";    
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


$title = "Extract Code Coverage Results";
$message = "Do you want to execute all unit tests prior to extracting the code coverage results?";
$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", 
    "Yes, execute the tests"
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No",
    "No, just extract the results"
    
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
$result = $host.ui.PromptForChoice($title, $message, $options, 0)
    
$totalCoverageStats = New-Object Collections.Generic.List[PSObject]
foreach($solution in $solutions)
{
    $absoluteSolutionPath = [string]($globalCOnfig.Root.Solutions.RootPath + $solution.RelativePath);
    $absoluteCoverageConfigPath = $absoluteSolutionPath + "\" + $coverageConfigName;
    
    if($result -eq 0)
    {
        &($globalConfig.Root.dotCover.Path) analyse $absoluteCoverageConfigPath;
    }
    
    .\ExtractCodeCoverageResults.ps1 -path $absoluteSolutionPath -outputPath ($outputPath + "\" + $solution.Name) -totalCoverageStats $totalCoverageStats -solutionName $solution.Name;           
}

$totalCoverageStats | Out-File $outputPath\Stats.txt;