# Function to replace a string with environment variables that matches the regular expression
function Set-Regex-Env-Vars {
    param (
        [string]$str,
        [string]$pattern
    )
    $matchResults = [Regex]::Matches($str, $pattern)
    foreach ($match in $matchResults) {
        $varName = $match.Groups[1].Value
        $varValue = [System.Environment]::GetEnvironmentVariable($varName)
        if ($varValue -ne $null) {
            $str = $str -replace $pattern, $varValue
        }
    }
    return $str
}