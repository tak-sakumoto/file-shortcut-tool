# Arguments
param (
    [string]$listPath,
    [string]$defaultParent = ".\"
)

# Function to create a shortcut
function Create-Shortcut {
    param (
        [string]$targetPath,
        [string]$shortcutPath
    )
    try {
        $WshShell = New-Object -ComObject WScript.Shell
        $shortcut = $WshShell.CreateShortcut($shortcutPath)
        $shortcut.TargetPath = $targetPath
        $shortcut.Save()
    } catch {
        Write-Host "Failed to create shortcut: $targetPath"
        Write-Host "Error:" + $_.Exception.Message
    }
}

# Get listed paths
$paths = Import-Csv -Path $listPath

# Create shortcuts for each path
foreach ($path in $paths) {
    $targetPath = $path.Path
    $shortcutPath = $defaultParent + "\" + (Split-Path -Leaf $targetPath) + ".lnk"
    Create-Shortcut -targetPath $targetPath -shortcutPath $shortcutPath
}
