function Test-CloudflareDnsEntryMatch {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] $ExpectedDnsEntry,
        [Parameter(Mandatory = $true)] $ActualDnsEntry
    )
    
    begin {
        Write-Debug "Begin testing Cloudflare DNS entries match"
    }
    
    process {

        $testPassed = $true

        foreach($key in $ExpectedDnsEntry.Keys)
        {
            $expectedValue = $ExpectedDnsEntry.$key
            $actualValue = $ActualDnsEntry.$key

            if ($expectedValue -ne $actualValue)
            {
                Write-Warning "DNS entry value for $key has value $actualValue not $expectedValue"
                $testPassed = $false
            }
        }

        $testPassed

    }
    
    end {
        Write-Debug "End testing Cloudflare DNS entries match"
    }
}