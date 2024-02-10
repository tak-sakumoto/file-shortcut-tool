function Write-ShortcutsPreview {
    param (
        $shortcutList
    )
    Write-Host "[Shortcut path] -> [Target]"
    Write-Host "--------------------------------"
    foreach ($pair in $shortcutList) {
        Write-Host "$($pair.shortcutPath) -> $($pair.target)"
    }
}
