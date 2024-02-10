# Arguments
param (
    [string]$listPath,
    [string]$defaultParent = ".\",
    [switch]$preview
)

# Constants
. "$PSScriptRoot\Set-ConstsExitCodesMain.ps1"

# Dot sourcing
. "$PSScriptRoot\New-Shortcut.ps1"
. "$PSScriptRoot\Set-RegexEnvVars.ps1"
. "$PSScriptRoot\Get-ShortcutList.ps1"
. "$PSScriptRoot\Write-ShortcutsPreview.ps1"
. "$PSScriptRoot\Get-YesFromUser.ps1"

# Check if the list path is empty
if ([string]::IsNullOrEmpty($listPath)) {
    # Display an error message and exit with a non-zero code
    Write-Host "Error: CSV file parameter is empty"
    exit $EXIT_PARAM_CSV_EMPTY
}

# Check if the list path is invalid
if (!(Test-Path $listPath)) {
    # Display an error message and exit with a non-zero code
    Write-Host "Error: $listPath does not exist"
    exit $EXIT_PARAM_CSV_INVALID
}

# Check if the default parent path is invalid
if (!(Test-Path $defaultParent)) {
    # Display an error message and exit with a non-zero code
    Write-Host "Error: $defaultParent does not exist"
    exit $EXIT_PARAM_PARENT_INVALID
}

# Get listed paths
$csvData = Import-Csv -Path $listPath

# Get a list of shortcuts
$shortcutList = Get-ShortcutList -CsvData $csvData -defaultParent $defaultParent

# Preview the shortcuts at once
if ($preview) {
    # Display the preview
    Write-Host "Preview the shortcuts"
    Write-ShortcutsPreview -shortcutList $shortcutList
    Write-Host 

    # Confirm the preview
    if (!(Get-YesFromUser -Message 'Do you want to create the shortcuts?')) {
        Write-Host "Canceled"
        exit $EXIT_SUCCESS_PREVIEW_CANCEL
    }
    Write-Host
}

# Create the shortcut
foreach ($pair in $shortcutList) {
    # Create the shortcut
    New-Shortcut -targetPath $pair.targetPath -shortcutPath $pair.shortcutPath
}

Write-Host "Done"

# Exit with a success code
exit $EXIT_SUCCESS
