# Function to create a shortcut
function New-Shortcut {
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
        Write-Host "Error: $_.Exception.Message"
    }
}
