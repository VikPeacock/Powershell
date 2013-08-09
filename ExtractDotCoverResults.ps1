# Read coverage XML
$coverageOutput = [xml](Get-Content CoverageOutput.xml);

# Get percentage covered
$percentageCovered = $coverageOutput.Root.CoveragePercent;

# Get the assemblies
$projectAssemblies = $coverageOutput.Root.Assembly;

# Coverage stats
$table = New-Object Collections.Generic.List[PSObject]

foreach ($assembly in $projectAssemblies) {	
        
    # Load drawing assembly
    [void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization")
    $scriptpath = Split-Path -parent $MyInvocation.MyCommand.Definition
     
    # Create code coverage chart container
    $coverageChart = New-object System.Windows.Forms.DataVisualization.Charting.Chart
    $coverageChart.Width = 1024
    $coverageChart.Height = 768
    $coverageChart.BackColor = [System.Drawing.Color]::White
     
    # Title
    [void]$coverageChart.Titles.Add($assembly.Name)
    $coverageChart.Titles[0].Font = "Arial,13pt"
    $coverageChart.Titles[0].Alignment = "topLeft"
     
    # Chart Area
    $chartarea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
    $chartarea.Name = $assembly.Name
    $chartarea.AxisY.Title = ""
    $chartarea.AxisX.Title = ""
    
    # Set threshold at 100%   
    $chartarea.AxisY.Maximum = 100      
    $coverageChart.ChartAreas.Add($chartarea)
     
    # Legend
    $legend = New-Object system.Windows.Forms.DataVisualization.Charting.Legend
    $legend.name = "Coverage"
    $coverageChart.Legends.Add($legend)
        
    $notCoveredDataSource = @{}         
    $namespaces = $assembly.Namespace;
    foreach($namespace in $namespaces){    
       $notCoveredDataSource.Add($namespace.Name, (100 - [int]$namespace.CoveragePercent))      
    }
       
    [void]$coverageChart.Series.Add("Not Covered") 
    $coverageChart.Series["Not Covered"].Points.DataBindXY($notCoveredDataSource.Keys, $notCoveredDataSource.Values)
    $coverageChart.Series["Not Covered"].ChartType = "StackedColumn"
    $coverageChart.Series["Not Covered"].Color = "Red"   
        
    $coveredDataSource = @{}         
    $namespaces = $assembly.Namespace;
    foreach($namespace in $namespaces){    
       $coveredDataSource.Add($namespace.Name, $namespace.CoveragePercent)      
    }
       
    [void]$coverageChart.Series.Add("Covered") 
    $coverageChart.Series["Covered"].Points.DataBindXY($coveredDataSource.Keys, $coveredDataSource.Values)
    $coverageChart.Series["Covered"].ChartType = "StackedColumn"
    $coverageChart.Series["Covered"].Color = "Green"
    
    # save chart
    $coverageChart.SaveImage(("$scriptpath\ALM\CodeCoverage\Graphs\" + $assembly.Name + ".png"),"png")	
      
    Write-Host “==============================================================="  
    Write-Host “Assembly: ” $assembly.Name
	Write-Host “==============================================================="  
         
    # Print summary table        
    foreach($namespace in $namespaces){
        $stat = New-Object PSObject
        $stat | Add-Member -type NoteProperty -name Namespace  $namespace.Name
        $stat | Add-Member -type NoteProperty -name PctCovered $namespace.CoveragePercent
        $stat | Add-Member -type NoteProperty -name PctNotCovered (100 - [int]$namespace.CoveragePercent) 
        
        $table.Add($stat)
    }
    
    Write-Host ""
    Write-Host ""     
    Write-Host ""
    Write-Host ""
    Write-Host ""	
}

Write-Output $table	
Out-File -FilePath ("$scriptpath\ALM\CodeCoverage\Stats\Coverage.txt") -InputObject $table