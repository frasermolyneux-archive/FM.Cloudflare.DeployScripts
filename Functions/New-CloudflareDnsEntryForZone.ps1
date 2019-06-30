function New-CloudflareDnsEntryForZone {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] [String] $AuthKey,
        [Parameter(Mandatory = $true)] [String] $AuthEmail,
        [Parameter(Mandatory = $true)] [String] $ZoneId,
        [Parameter(Mandatory = $true)] [Hashtable] $DnsEntry
    )
    
    begin {
        Write-Debug "Begin creating new DNS entry in $ZoneId"
    }
    
    process {

        $headers = @{
            "Content-Type" = "application/json"
            "X-Auth-Key" = $AuthKey
            "X-Auth-Email" = $AuthEmail
        }

        $body = ConvertTo-Json $DnsEntry

        Write-Debug "POST: https://api.cloudflare.com/client/v4/zones/$ZoneId/dns_records"
        Write-Debug $body

        try {
            $response = Invoke-RestMethod -Uri "https://api.cloudflare.com/client/v4/zones/$ZoneId/dns_records" -Method "POST" -Body $body -Headers $headers
        }
        catch {
            $result = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($result)
            $reader.BaseStream.Position = 0
            $reader.DiscardBufferedData()
            $response = $reader.ReadToEnd();
        }

        Write-Debug $response

        if ($response.success -eq $true) {
            $response.result
        }
        else {
            Write-Error "Failed to create new DNS entry"
            Write-CloudflareErrorMessage -Response $response
        }
    }
    
    end {
        Write-Debug "End creating new DNS entry in $ZoneId"
    }
}