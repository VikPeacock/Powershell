# Define hash table
$hashTable = @{
    "Key" = "Value" 
    "Key2" = "Value"    
}

# Get all properties and methods of the object
$hashTable | Get-Member
help Get-Member