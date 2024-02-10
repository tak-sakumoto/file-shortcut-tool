# Pattern for environment variables
Set-Variable -Name PATTERN_ENV_VARS -Value '%([A-Za-z0-9_]*)%' -Option constant
Set-Variable -Name PATTERN_PS_ENV_VARS -Value '\$env:([A-Za-z0-9_]*)' -Option constant

# Pattern for invalid characters in file names
Set-Variable -Name PATTERN_INVALID_NAME_CHARS -Value '[\\\/\:\*\?\"\<\>\|]' -Option constant

# Pattern for URL
Set-Variable -Name PATTERN_END_PATH_OF_URL -Value '([^/]+)$' -Option constant
Set-Variable -Name PATTERN_DOMAIN_OF_URL -Value 'https?://([^/]+)' -Option constant
