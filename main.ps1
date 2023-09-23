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
    $parent = $line.Parent
    if([string]::IsNullOrEmpty($parent)){
        $parent = $defaultParent
    }
    $shortcutPath = $parent + "\" + (Split-Path -Leaf $targetPath) + ".lnk"
    New-Shortcut -targetPath $targetPath -shortcutPath $shortcutPath
}
