function Get-ShortcutList {
    param (
        $CsvData,
        $defaultParent=".\"
    )
    # Dot sourcing
    . "$PSScriptRoot\Get-ShortcutArr.ps1"

    # Function to get a list of shortcuts
    $shortcutList = @()
    
    foreach ($line in $csvData) {
        # Set the target path, parent, and name variables from the CSV file
        $target = $line.Target
        $parent = $line.Parent
        $name = $line.Name

        # Get the shortcut array
        $shortcutArr = Get-ShortcutArr -parent $parent -name $name -target $target -defaultParent $defaultParent
        
        # Skip listing if the shortcut path is null
        if ($null -eq $shortcutArr) {
            continue
        }
        
        # Add the shortcut to the list
        $shortcutList += @(
            $shortcutArr
        )
    }

    return $shortcutList
}
