function Write-ShortcutsPreview {
    param (
        $shortcutList
    )
    Write-Host "[Target path] -> [Shortcut path]"
    Write-Host "--------------------------------"
    foreach ($pair in $shortcutList) {
        Write-Host "$($pair.targetPath) -> $($pair.shortcutPath)"
    }
}
