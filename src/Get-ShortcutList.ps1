function Get-ShortcutList {
    param (
        $CsvData,
        $defaultParent=".\"
    )
    # Constants
    . "$PSScriptRoot\Set-ConstsRegexPatterns.ps1"

    # Dot sourcing
    . "$PSScriptRoot\Get-ShortcutPath.ps1"

    # Function to get a list of shortcuts
    $shortcutList = @()
    
    foreach ($line in $csvData) {
        # Set the target path, parent, and name variables from the CSV file
        $targetPath = $line.Path
        $parent = $line.Parent
        $name = $line.Name

        # Remove invalid characters from the name
        $name = $name -replace $PATTERN_INVALID_NAME_CHARS, '_'
        
        # Create the shortcut
        $urlShortcutFlg = $false
        if ($targetPath -like "http://*" -or $targetPath -like "https://*") {
            $urlShortcutFlg = $true
        }

        # Replace environment variables in paths retrieved from CSV files with values
        foreach (
            $pattern in @($PATTERN_ENV_VARS, $PATTERN_PS_ENV_VARS)
        ) {
            $targetPath = Set-RegexEnvVars -str $targetPath -pattern $pattern
        }

        # Do not create the shortcut if the target path is invalid 
        if (!($urlShortcutFlg) -and !(Test-Path -Path $targetPath)) {
            Write-Host "Error: invalid target path $targetPath"
            continue
        }

        # Get the shortcut path
        $shortcutPath = Get-ShortcutPath -parent $parent -name $name -targetPath $targetPath -defaultParent $defaultParent 
        # Skip creating a shortcut if the path is invalid
        if ($null -eq $shortcutPath) {
            continue
        }
        
        # Add the shortcut to the list
        $shortcutList += @(@{
            targetPath = $targetPath
            shortcutPath = $shortcutPath
        })
    }

    return $shortcutList
}
