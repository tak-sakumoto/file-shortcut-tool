# Arguments
param (
    [string]$listPath,
    [string]$defaultParent = ".\"
)

# Constants
. "$PSScriptRoot\Set-ConstsExitCodesMain.ps1"
. "$PSScriptRoot\Set-ConstsRegexPatterns.ps1"

# Dot sourcing
. "$PSScriptRoot\New-Shortcut.ps1"
. "$PSScriptRoot\Set-RegexEnvVars.ps1"
. "$PSScriptRoot\Get-ShortcutPath.ps1"

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
$data = Import-Csv -Path $listPath

# Create shortcuts for each path
foreach ($line in $data) {
    # Set the target path, parent, and name variables from the CSV file
    $targetPath = $line.Path
    $parent = $line.Parent
    $name = $line.Name

    # Remove invalid characters from the name
    $name = $name -replace $PATTERN_INVALID_NAME_CHARS, '_'
    
    # Create the shortcut
    $urlShortcutFlg = $false
    if ($targetPath -like "http://*" -or $targetPath -like "https://*") {
        $urlShortcutFlg = $true
    }

    # Replace environment variables in paths retrieved from CSV files with values
    foreach (
        $pattern in @($PATTERN_ENV_VARS, $PATTERN_PS_ENV_VARS)
    ) {
        $targetPath = Set-RegexEnvVars -str $targetPath -pattern $pattern
    }

    # Do not create the shortcut if the target path is invalid 
    if (!($urlShortcutFlg) -and !(Test-Path -Path $targetPath)) {
        Write-Host "Error: invalid target path $targetPath"
        continue
    }

    # Get the shortcut path
    $shortcutPath = Get-ShortcutPath -parent $parent -name $name -targetPath $targetPath -defaultParent $defaultParent 
    # Skip creating a shortcut if the path is invalid
    if ($null -eq $shortcutPath) {
        continue
    }

    # Create the shortcut
    New-Shortcut -targetPath $targetPath -shortcutPath $shortcutPath
}

# Exit with a success code
exit $EXIT_SUCCESS
