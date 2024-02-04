# Arguments
param (
    [string]$listPath,
    [string]$defaultParent = ".\"
)

# Dot sourcing
. .\new_shortcut.ps1
. .\set_regex_env_vars.ps1
. .\Get-ShortcutPath.ps1

# Get listed paths
$data = Import-Csv -Path $listPath

# Pattern for environment variables
$env_var_pattern = '%([A-Za-z0-9_]*)%'
$ps_env_var_pattern = '\$env:([A-Za-z0-9_]*)'

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
        $pattern in @($env_var_pattern, $ps_env_var_pattern)
    ) {
        $targetPath = Set-Regex-Env-Vars -str $targetPath -pattern $pattern
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
