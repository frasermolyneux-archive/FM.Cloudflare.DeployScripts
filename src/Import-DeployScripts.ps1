$InformationPreference = 'Continue'

Write-Information "Starting importing deploy script functions from $PSScriptRoot\Functions"

Get-ChildItem -Path "$PSScriptRoot\Internal", "$PSScriptRoot\Functions" -Filter "*.ps1" | ForEach-Object {
    . $_.FullName
    Write-Information "Imported function $($_.FullName)"
}

Write-Information "End importing deploy script functions"