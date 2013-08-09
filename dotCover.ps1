# Alias to call it from anywhere
New-Item alias:dotCover -value "C:\Program Files (x86)\JetBrains\dotCover\v2.2\Bin\dotCover.exe"

# Usage. coverage.xml is a configuration file
dotCover analyse coverage.xml

# Cover with log
dotCover analyse coverage.xml /LogFile="dotCover.log"

