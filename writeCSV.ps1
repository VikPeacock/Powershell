# Define file content
$csv = @"
    "Namespace", "PctCovered", "PctNotCovered"
    "Kx.NamespaceOne", 50, 50
    "Kx.NamespaceTwo", 30, 70
    "Kx.NamespaceThree", 0, 100
"@

# Write to file
$csv >> C:\PSScripts\Test.csv
Import-CSV C:\PSScripts\TEst.csv