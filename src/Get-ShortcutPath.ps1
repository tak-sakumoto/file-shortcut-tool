function Get-ShortcutPath {
    param (
        [string]$parent,
        [string]$name,
        [string]$targetPath,
        [string]$defaultParent 
    )
    # Get the default parent of the shortcut if it is not listed in the CSV file
    if([string]::IsNullOrEmpty($parent)){
        $parent = $defaultParent
    }

    # Convert the parent path to an absolute path
    $parent = (Resolve-Path -Path $parent).Path

    # Return null if the parent path is invalid
    if (!(Test-Path -IsValid -Path $parent -PathType Container)) {
        Write-Host "Error: invalid parent path $parent"
        return $null
    }

    # Get the leaf of the target path if it is not listed in the CSV file
    if([string]::IsNullOrEmpty($name)){
        $name = (Split-Path -Leaf $targetPath)
    }

    # Get the shortcut path
    $shortcutPath = $parent + "\" + $name + ".lnk"

    # Return null if the shortcut path is invalid
    if (!(Test-Path -IsValid -Path $shortcutPath -PathType Leaf)) {
        Write-Host "Error: invalid shortcut file path $shortcutPath"
        return $null
    }

    return $shortcutPath
}