[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization")
$scriptpath = Split-Path -parent $MyInvocation.MyCommand.Definition
 
# chart object
   $chart1 = New-object System.Windows.Forms.DataVisualization.Charting.Chart
   $chart1.Width = 600
   $chart1.Height = 600
   $chart1.BackColor = [System.Drawing.Color]::White
 
# title 
   [void]$chart1.Titles.Add("Top 5 - Memory Usage (as: Column)")
   $chart1.Titles[0].Font = "Arial,13pt"
   $chart1.Titles[0].Alignment = "topLeft"
 
# chart area 
   $chartarea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
   $chartarea.Name = "ChartArea1"
   $chartarea.AxisY.Title = "Coverage %"
   $chartarea.AxisX.Title = "Namespace"
   $chartarea.AxisY.Interval = 10
   $chartarea.AxisX.Interval = 10
   $chart1.ChartAreas.Add($chartarea)
 
# legend 
   $legend = New-Object system.Windows.Forms.DataVisualization.Charting.Legend
   $legend.name = "Namespaces"
   $chart1.Legends.Add($legend)

$object = New-Object PSObject –Prop $properties
# Write-Output $object
 
# data source
   $datasource = $properties # Get-Process | sort PrivateMemorySize -Descending  | Select-Object -First 5
 
# data series
   [void]$chart1.Series.Add("Kx.CRM.Data.Foo")
   $chart1.Series["Kx.CRM.Data.Foo"].ChartType = "Column"
   $chart1.Series["Kx.CRM.Data.Foo"].BorderWidth  = 3
   $chart1.Series["Kx.CRM.Data.Foo"].IsVisibleInLegend = $true
   $chart1.Series["Kx.CRM.Data.Foo"].chartarea = "ChartArea1"
   $chart1.Series["Kx.CRM.Data.Foo"].Legend = "Namespaces"
   $chart1.Series["Kx.CRM.Data.Foo"].color = "#62B5CC"
   $datasource | ForEach-Object {
    $chart1.Series["Kx.CRM.Data.Foo"].Points.addxy( $_.Namespace , ($_.CoveredPct)) 
   }

 
# save chart
   $chart1.SaveImage("$scriptpath\SplineArea.png","png")