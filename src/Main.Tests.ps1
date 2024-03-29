Import-Module Pester

Describe "Main.ps1" {
    BeforeAll {
        # Constants
        . "$PSScriptRoot\..\src\Set-ConstsExitCodesMain.ps1"

        # Target script
        $targetScript = "$PSScriptRoot\..\src\Main.ps1"

        # Make a directory for the test
        $testDirPath = "$PSScriptRoot\..\test"
        New-Item -Path $testDirPath -ItemType Directory -Force
        $listDirPath = "$testDirPath\lists"
        New-Item -Path $listDirPath -ItemType Directory -Force
        $defaultParent = "$testDirPath\shortcuts"
        New-Item -Path $defaultParent -ItemType Directory -Force
        $targetsDirPath = "$testDirPath\targets"
        New-Item -Path $targetsDirPath -ItemType Directory -Force

        $shortcutPath = ""
    }
    
    AfterEach {
        if (Test-Path $shortcutPath) {
            Remove-Item -Path $shortcutPath -Force
        }
    }

    Context "When the list path is empty" {
        It "Should exit with a non-zero code" {
            # Arrange
            $listPath = ""

            # Act
            & $targetScript -listPath $listPath
                    
            # Assert
            $LASTEXITCODE | Should -Be $EXIT_PARAM_CSV_EMPTY
        }
    }

    Import-Module Pester

    Context "When the list path does not exist" {
        It "Should exit with a non-zero code" {
            # Arrange
            $listPath = "$listDirPath\absent.csv"

            # Act
            & $targetScript -listPath $listPath
            
            # Assert
            $LASTEXITCODE | Should -Be $EXIT_PARAM_CSV_INVALID
        }
    }

    Context "When the default parent path does not exist" {
        It "Should exit with a non-zero code" {
            # Arrange
            $listPath = "$listDirPath\list.csv"
            New-Item -Path $listPath
            $defaultParent = "$testDirPath\absent"
            
            # Act
            & $targetScript -listPath $listPath -defaultParent $defaultParent

            # Assert
            $LASTEXITCODE | Should -Be $EXIT_PARAM_PARENT_INVALID
        }
    }
    
    Context "When the target path is invalid" {
        It "Should skip creating the shortcut" {
            # Arrange
            $listPath = "$listDirPath\list.csv"
            $target = "$targetsDirPath\absent.txt"
            $parent = $defaultParent
            $name = "shortcut"
            $data = @(
                [PSCustomObject]@{
                    Target = $target
                    Parent = $parent
                    Name = $name
                }
            )
            $data | Export-Csv -Path $listPath -NoTypeInformation
            
            # Act
            & $targetScript -listPath $listPath -defaultParent $defaultParent
            
            # Assert
            $LASTEXITCODE | Should -Be $EXIT_SUCCESS
            $shortcutPath = "$parent\$name.lnk"
            $shortcutPath | Should -Not -Exist
        }
    }
    
    Context "When the target path is valid" {
        It "Should create the shortcut" {
            # Arrange
            $listPath = "$listDirPath\list.csv"
            $target = "$targetsDirPath\valid.txt"
            $parent = $defaultParent
            $name = "shortcut"
            $data = @(
                [PSCustomObject]@{
                    Target = $target
                    Parent = $parent
                    Name = $name
                }
            )
            $data | Export-Csv -Path $listPath -NoTypeInformation
            New-Item -Path $target -ItemType File -Force
            
            # Act
            & $targetScript -listPath $listPath -defaultParent $defaultParent

            # Assert
            $LASTEXITCODE | Should -Be $EXIT_SUCCESS
            $shortcutPath = "$parent\$name.lnk"
            $shortcutPath | Should -Exist
        }
    }

    Context "When running in preview mode" {
        It "Should display the preview and create the shortcuts when confirmed" {
            # Arrange
            $listPath = "$listDirPath\list.csv"
            $target = "$targetsDirPath\valid.txt"
            $parent = $defaultParent
            $name = "shortcut"
            $data = @(
                [PSCustomObject]@{
                    Target = $target
                    Parent = $parent
                    Name = $name
                }
            )
            $data | Export-Csv -Path $listPath -NoTypeInformation
            New-Item -Path $target -ItemType File -Force

            # Mock Read-Host to simulate user input
            Mock Read-Host { "y" }

            # Act
            & $targetScript -listPath $listPath -defaultParent $defaultParent -preview

            # Assert
            $LASTEXITCODE | Should -Be $EXIT_SUCCESS
            $shortcutPath = "$parent\$name.lnk"
            $shortcutPath | Should -Exist
        }

        It "Should cancel the operation when preview is not confirmed" {
            # Arrange
            $listPath = "$listDirPath\list.csv"
            $target = "$targetsDirPath\valid.txt"
            $parent = $defaultParent
            $name = "shortcut"
            $data = @(
                [PSCustomObject]@{
                    Target = $target
                    Parent = $parent
                    Name = $name
                }
            )
            $data | Export-Csv -Path $listPath -NoTypeInformation
            New-Item -Path $target -ItemType File -Force

            # Mock Read-Host to simulate user input
            Mock Read-Host { "n" }

            # Act
            & $targetScript -listPath $listPath -defaultParent $defaultParent -preview

            # Assert
            $LASTEXITCODE | Should -Be $EXIT_SUCCESS_PREVIEW_CANCEL
            $shortcutPath = "$parent\$name.lnk"
            $shortcutPath | Should -Not -Exist
        }
    }

    AfterAll {
        # Remove a directory for the test
        Remove-Item -Path $defaultParent -Recurse
        Remove-Item -Path $listDirPath -Recurse
        Remove-Item -Path $targetsDirPath -Recurse
    }
}
