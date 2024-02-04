# Arguments
param (
    [string]$listPath,
    [string]$defaultParent = ".\"
)

# Dot sourcing
. .\new_shortcut.ps1
. .\set_regex_env_vars.ps1

# Get listed paths
$data = Import-Csv -Path $listPath

# Pattern for environment variables
$env_var_pattern = '%([A-Za-z0-9_]*)%'
$ps_env_var_pattern = '\$env:([A-Za-z0-9_]*)'

# Create shortcuts for each path
foreach ($line in $data) {
    $targetPath = $line.Path
    
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

    # Get the parent of the shortcut if it is listed in the CSV file
    $parent = $line.Parent
    # Get the default parent of the shortcut if it is not listed in the CSV file
    if([string]::IsNullOrEmpty($parent)){
        $parent = $defaultParent
    }

    # Convert the parent path to an absolute path
    $parent = (Resolve-Path -Path $parent).Path

    # Get the file name if it is listed in the CSV file
    $name = $line.Name
    # Get the leaf of the target path if it is not listed in the CSV file
    if([string]::IsNullOrEmpty($name)){
        $name = (Split-Path -Leaf $targetPath)
    }

    # Get the shortcut path
    $shortcutPath = $parent + "\" + $name + ".lnk"

    # Skip creating a shortcut if the path is invalid
    if (!(Test-Path -Path $shortcutPath -IsValid)) {
        Write-Host "Error: invalid shortcut file path $shortcutPath"
        continue
    }

    # Create the shortcut
    New-Shortcut -targetPath $targetPath -shortcutPath $shortcutPath
}
