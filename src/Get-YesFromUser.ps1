function Get-YesFromUser {
    param (
        [string]$Message
    )
    $confirmation = Read-Host "$Message (y/n)"
    while (1) {
        if ($confirmation -eq "y") {
            break
        }
        elseif ($confirmation -eq "n") {
            return $false
        }
        else {
            $confirmation = Read-Host "Please enter y or n"
        }
    }
    return $true
}
