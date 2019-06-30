$DebugPreference = 'SilentlyContinue'
$VerbosePreference = 'SilentlyContinue'
$InformationPreference = 'SilentlyContinue'

Import-Module Pester
Set-Location $PSScriptRoot

$moduleRoot = "$PSScriptRoot"

Get-ChildItem -Path "$PSScriptRoot\Internal", "$PSScriptRoot\Functions" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName
}

Get-ChildItem -Path "$PSScriptRoot\Tests" -Filter "*.Tests.ps1" | ForEach-Object {
    . $_.FullName -ModuleRoot $moduleRoot
}