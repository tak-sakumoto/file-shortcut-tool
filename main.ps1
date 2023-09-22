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
        Write-Host "Created a shortcut: $shortcutPath -> $targetPath"
    } catch {
        Write-Host "Failed to create shortcut: $shortcutPath -> $targetPath"
        Write-Host "Error:" + $_.Exception.Message
    }
}

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
    Create-Shortcut -targetPath $targetPath -shortcutPath $shortcutPath
}
