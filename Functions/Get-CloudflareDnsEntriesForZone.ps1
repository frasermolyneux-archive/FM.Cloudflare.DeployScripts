function Get-CloudflareDnsEntriesForZone {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] [String] $AuthKey,
        [Parameter(Mandatory = $true)] [String] $AuthEmail,
        [Parameter(Mandatory = $true)] [String] $ZoneId
    )
    
    begin {
        Write-Debug "Begin getting DNS entries for from Cloudflare for $ZoneId"
    }
    
    process {

        $headers = @{
            "Content-Type" = "application/json"
            "X-Auth-Key" = $AuthKey
            "X-Auth-Email" = $AuthEmail
        }

        $response = Invoke-RestMethod -Uri "https://api.cloudflare.com/client/v4/zones/$ZoneId/dns_records" -Headers $headers
        
        Write-Debug $response

        if ($response.success -eq $true) {
            $response.result
        }
        else {
            Write-Error "Failed to retrieve DNS entries from Cloudflare"
            Write-CloudflareErrorMessage -Response $response
        }
    }
    
    end {
        Write-Debug "End getting DNS entries for from Cloudflare for $ZoneId"
    }
}