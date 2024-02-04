# Arguments
param (
    [string]$listPath,
    [string]$defaultParent = ".\"
)

# Dot sourcing
. .\New-Shortcut.ps1
. .\Set-RegexEnvVars.ps1
. .\Get-ShortcutPath.ps1

# Check if the list path is empty
if ([string]::IsNullOrEmpty($listCsv)) {
    # Display an error message and exit with a non-zero code
    Write-Host "Error: CSV file parameter is empty"
    exit 1
}

# Check if the list path is invalid
if (!(Test-Path $listCsv)) {
    # Display an error message and exit with a non-zero code
    Write-Host "Error: $listCsv does not exist"
    exit 1
}

# Check if the default parent path is invalid
if (!(Test-Path $defaultParent)) {
    # Display an error message and exit with a non-zero code
    Write-Host "Error: $defaultParent does not exist"
    exit 1
}

# Get listed paths
$data = Import-Csv -Path $listPath

# Pattern for environment variables
$envVarPattern = '%([A-Za-z0-9_]*)%'
$psEnvVarPattern = '\$env:([A-Za-z0-9_]*)'

# Create shortcuts for each path
foreach ($line in $data) {
    # Set the target path, parent, and name variables from the CSV file
    $targetPath = $line.Path
    $parent = $line.Parent
    $name = $line.Name
    
    # Remove invalid characters from the name
    $name = $name -replace '[\\\/\:\*\?\"\<\>\|]', '_'
    
    # Create the shortcut
    $urlShortcutFlg = $false
    if ($targetPath -like "http://*" -or $targetPath -like "https://*") {
        $urlShortcutFlg = $true
    }

    # Replace environment variables in paths retrieved from CSV files with values
    foreach (
        $pattern in @($envVarPattern, $psEnvVarPattern)
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
exit 0
