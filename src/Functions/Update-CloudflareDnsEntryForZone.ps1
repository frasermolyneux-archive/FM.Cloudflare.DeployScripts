function Update-CloudflareDnsEntryForZone {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] [String] $AuthKey,
        [Parameter(Mandatory = $true)] [String] $AuthEmail,
        [Parameter(Mandatory = $true)] [String] $ZoneId,
        [Parameter(Mandatory = $true)] [String] $DnsRecordId,
        [Parameter(Mandatory = $true)] [Hashtable] $DnsEntry
    )
    
    begin {
        Write-Debug "Begin updating existing DNS entry in $ZoneId for record $DnsRecordId"
    }
    
    process {

        $headers = @{
            "Content-Type" = "application/json"
            "X-Auth-Key" = $AuthKey
            "X-Auth-Email" = $AuthEmail
        }

        $body = ConvertTo-Json $DnsEntry

        Write-Debug "PATCH: https://api.cloudflare.com/client/v4/zones/$ZoneId/dns_records/$DnsRecordId"
        Write-Debug $body

        try {
            $response = Invoke-RestMethod -Uri "https://api.cloudflare.com/client/v4/zones/$ZoneId/dns_records" -Method "PATCH" -Body $body -Headers $headers
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
            Write-Error "Failed to update existing DNS entry"
            Write-CloudflareErrorMessage -Response $response
        }
    }
    
    end {
        Write-Debug "End updating existing DNS entry in $ZoneId for record $DnsRecordId"
    }
}