# Arguments
param (
    [string]$listPath
)

# Function to create a shortcut
function Create-Shortcut {
    param (
        [string]$targetPath,
        [string]$shortcutPath
    )
    $WshShell = New-Object -ComObject WScript.Shell
    $shortcut = $WshShell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $targetPath
    $shortcut.Save()
}

# Get listed paths
$paths = Import-Csv -Path $listPath

# Create shortcuts for each path
foreach ($path in $paths) {
    $targetPath = $path.Path
    $shortcutPath = (Split-Path -Leaf $targetPath) + ".lnk"
    Create-Shortcut -targetPath $targetPath -shortcutPath $shortcutPath
}
