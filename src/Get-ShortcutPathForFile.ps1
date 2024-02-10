function Get-ShortcutPathForFile {
    param (
        [string]$parent,
        [string]$name,
        [string]$target
    )
    # Constants
    . "$PSScriptRoot\Set-ConstsRegexPatterns.ps1"

    # Return null if the target path is invalid 
    if (!(Test-Path -Path $target)) {
        Write-Host "Error: invalid target path $target"
        return $null
    }
    
    # Get the leaf of the target path if it is not listed in the CSV file
    if([string]::IsNullOrEmpty($name)){
        $name = (Split-Path -Leaf $target)
    }

    # Get the shortcut path
    $shortcutPath = $parent + "\" + $name + ".lnk"

    return $shortcutPath
}