function Get-ShortcutPathForURL {
    param (
        [string]$parent,
        [string]$name,
        [string]$target
    )
    # Constants
    . "$PSScriptRoot\Set-ConstsRegexPatterns.ps1"

    # Extract a name from the target URL if it is not listed in the CSV file
    if([string]::IsNullOrEmpty($name)){
        foreach ($pattern in @($PATTERN_END_PATH_OF_URL, $PATTERN_DOMAIN_OF_URL)) {
            $matchResults = [Regex]::Matches($target, $pattern)
            if ($matchResults.Count -gt 0) {
                $name = $matchResults[0].Value
                break
            }
        }        
    }

    # Get the shortcut path
    $shortcutPath = $parent + "\" + $name + ".lnk"

    return $shortcutPath
}
