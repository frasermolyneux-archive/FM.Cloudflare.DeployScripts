param (
    [Parameter(Mandatory=$true)] [String] $ModuleRoot
)

Describe "Functions Tests" {
    Context "Functions Structure" {
        It "should not be empty" {
            (Get-ChildItem "$ModuleRoot\Functions" -File).Count | Should Not Be 0
        }
    }

    Get-ChildItem -Path "$ModuleRoot\Functions" -Filter "*.ps1" | ForEach-Object {
        
        $file = $_

        Context "$($file.Name)" {

            It "$($file.Name) is valid Powershell code" {
                $psFile = Get-Content -Path "$($file.FullName)" -ErrorAction Stop
                $errors = $null
                $null = [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
                if ($errors.Count -gt 0) {
                    Write-Host $errors.Message
                }
                $errors.Count | Should Be 0
            }

            It "$($file.Name) contains a maximum of one function" {
                (([string](Get-Content -Path $file.FullName)).Split(" ") | Where-Object { $_ -eq "function" }).Count | Should Be 1
            }

            It "$($file.Name)'s function is decorated with cmdletbinding attribute" {
                [string](Get-Content -Path $file.FullName) -match "[CmdletBinding()]" | Should Be $true
            } 

            It "$($file.Name)'s function has a begin block" {
                [string](Get-Content -Path $file.FullName) -match "begin {" | Should Be $true
            } 

            It "$($file.Name)'s function has a process block" {
                [string](Get-Content -Path $file.FullName) -match "process {" | Should Be $true
            }

            It "$($file.Name)'s function has a end block" {
                [string](Get-Content -Path $file.FullName) -match "end {" | Should Be $true
            }  

        }

    }

}