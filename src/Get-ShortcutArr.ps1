function Get-ShortcutArr {
    param (
        [string]$parent,
        [string]$name,
        [string]$target,
        [string]$defaultParent 
    )
    # Constants
    . "$PSScriptRoot\Set-ConstsRegexPatterns.ps1"
    . "$PSScriptRoot\Get-ShortcutPathForFile.ps1"
    . "$PSScriptRoot\Get-ShortcutPathForURL.ps1"

    # Get the default parent of the shortcut if a parent is not listed in the CSV file
    if([string]::IsNullOrEmpty($parent)){
        $parent = $defaultParent
    }

    # Replace environment variables in the parent path
    foreach (
        $pattern in @($PATTERN_ENV_VARS, $PATTERN_PS_ENV_VARS)
    ) {
        $parent = Set-RegexEnvVars -str $parent -pattern $pattern
    }
    
    # Convert the parent path to an absolute path
    $parent = (Resolve-Path -Path $parent).Path

    # Return null if the parent path is invalid
    if (!(Test-Path -IsValid -Path $parent -PathType Container)) {
        Write-Host "Error: invalid parent path $parent"
        return $null
    }

    # Remove invalid characters from the name
    $name = $name -replace $PATTERN_INVALID_NAME_CHARS, '_'

    # Get the shortcut path for the target
    if ($target -like "http://*" -or $target -like "https://*") {
        $shortcutPath = Get-ShortcutPathForURL -parent $parent -name $name -target $target
    }
    else {
        # Replace environment variables in the target path
        foreach (
            $pattern in @($PATTERN_ENV_VARS, $PATTERN_PS_ENV_VARS)
        ) {
            $target = Set-RegexEnvVars -str $target -pattern $pattern
        }
        
        $shortcutPath = Get-ShortcutPathForFile -parent $parent -name $name -target $target
    }

    # Return null if the shortcut path is null
    if ([string]::IsNullOrEmpty($shortcutPath)) {
        return $null
    }

    # Return null if the shortcut path is invalid
    if (!(Test-Path -IsValid -Path $shortcutPath -PathType Leaf)) {
        Write-Host "Error: invalid shortcut file path $shortcutPath"
        return $null
    }

    $shortcutArr = @{
        target = $target
        shortcutPath = $shortcutPath
    }
    return $shortcutArr
}