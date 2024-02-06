Import-Module Pester

BeforeAll {
    # Make a directory for the test
    $testDirPath = "$PSScriptRoot\..\test"
    New-Item -Path $testDirPath -ItemType Directory -Force
    $listDirPath = "$testDirPath\lists"
    New-Item -Path $listDirPath -ItemType Directory -Force
    $defaultParent = "$testDirPath\shortcuts"
    New-Item -Path $defaultParent -ItemType Directory -Force
    $targetsDirPath = "$testDirPath\targets"
    New-Item -Path $targetsDirPath -ItemType Directory -Force
}

Describe "Main.ps1" {
    Context "When the list path is empty" {
        It "Should exit with a non-zero code" {
            # Arrange
            $listPath = ""

            # Act
            & "$PSScriptRoot\Main.ps1" -listPath $listPath
                    
            # Assert
            $LASTEXITCODE | Should -Be 1
        }
    }

    Import-Module Pester

    Context "When the list path does not exist" {
        It "Should exit with a non-zero code" {
            # Arrange
            $testDirPath = "$PSScriptRoot\..\test"
            $listPath = "$testDirPath\lists\absent.csv"

            # Act
            & "$PSScriptRoot\Main.ps1" -listPath $listPath
            
            # Assert
            $LASTEXITCODE | Should -Be 1
        }
    }

    Context "When the default parent path does not exist" {
        It "Should exit with a non-zero code" {
            # Arrange
            $testDirPath = "$PSScriptRoot\..\test"
            $listPath = "$testDirPath\lists\list.csv"
            $defaultParent = "$testDirPath\absent"
            
            # Act
            & "$PSScriptRoot\Main.ps1" -listPath $listPath -defaultParent $defaultParent

            # Assert
            $LASTEXITCODE | Should -Be 1
        }
    }
    
    Context "When the target path is invalid" {
        It "Should skip creating the shortcut" {
            # Arrange
            $testDirPath = "$PSScriptRoot\..\test"
            $listPath = "$testDirPath\lists\list.csv"
            $defaultParent = "$testDirPath\shortcuts"
            $targetPath = "$testDirPath\targets\absent.txt"
            $parent = "$testDirPath\shortcuts"
            $name = "shortcut"
            $data = @(
                [PSCustomObject]@{
                    Path = $targetPath
                    Parent = $parent
                    Name = $name
                }
            )
            $data | Export-Csv -Path $listPath -NoTypeInformation
            
            # Act
            & "$PSScriptRoot\Main.ps1" -listPath $listPath -defaultParent $defaultParent
            
            # Assert
            $LASTEXITCODE | Should -Be 0
            $shortcutPath = "$parent\$name.lnk"
            $shortcutPath | Should -Not -Exist
        }
    }
    
    Context "When the target path is valid" {
        It "Should create the shortcut" {
            # Arrange
            $testDirPath = "$PSScriptRoot\..\test"
            $listPath = "$testDirPath\lists\list.csv"
            $defaultParent = "$testDirPath\shortcuts"
            $targetPath = "$testDirPath\targets\valid.txt"
            $parent = "$testDirPath\shortcuts"
            $name = "shortcut"
            $data = @(
                [PSCustomObject]@{
                    Path = $targetPath
                    Parent = $parent
                    Name = $name
                }
            )
            $data | Export-Csv -Path $listPath -NoTypeInformation
            New-Item -Path $targetPath -ItemType File -Force
            
            # Act
            & "$PSScriptRoot\Main.ps1" -listPath $listPath -defaultParent $defaultParent

            # Assert
            $LASTEXITCODE | Should -Be 0
            $shortcutPath = "$parent\$name.lnk"
            $shortcutPath | Should -Exist
        }
    }
}

AfterAll {
    # Remove a directory for the test
    $testDirPath = "$PSScriptRoot\..\test"
    $defaultParent = "$testDirPath\shortcuts"
    Remove-Item -Path $defaultParent -Recurse
    $listDirPath = "$testDirPath\lists"
    Remove-Item -Path $listDirPath -Recurse
    $targetsDirPath = "$testDirPath\targets"
    Remove-Item -Path $targetsDirPath -Recurse
}