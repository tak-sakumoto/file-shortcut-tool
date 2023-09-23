# Arguments
param (
    [string]$listPath,
    [string]$defaultParent = ".\"
)

# Dot sourcing
. .\new_shortcut.ps1

# Get listed paths
$data = Import-Csv -Path $listPath

# Create shortcuts for each path
foreach ($line in $data) {
    $targetPath = $line.Path

    # Get the parent of the shortcut if it is listed in the CSV file
    $parent = $line.Parent
    # Get the default parent of the shortcut if it is not listed in the CSV file
    if([string]::IsNullOrEmpty($parent)){
        $parent = $defaultParent
    }

    # Get the file name if it is listed in the CSV file
    $name = $line.Name
    # Get the leaf of the target path if it is not listed in the CSV file
    if([string]::IsNullOrEmpty($name)){
        $name = (Split-Path -Leaf $targetPath)
    }

    # Get the shortcut path
    $shortcutPath = $parent + "\" + $name + ".lnk"

    # Create the shoutcut
    New-Shortcut -targetPath $targetPath -shortcutPath $shortcutPath
}
