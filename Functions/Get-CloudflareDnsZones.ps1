function Get-CloudflareDnsZones {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] [String] $AuthKey,
        [Parameter(Mandatory = $true)] [String] $AuthEmail
    )
    
    begin {
        Write-Debug "Begin getting DNS zones from Cloudflare"
    }
    
    process {

        $headers = @{
            "Content-Type" = "application/json"
            "X-Auth-Key" = $AuthKey
            "X-Auth-Email" = $AuthEmail
        }

        try {
            $response = Invoke-RestMethod -Uri "https://api.cloudflare.com/client/v4/zones" -Headers $headers
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
            Write-Error "Failed to retrieve DNS zones from Cloudflare"
            Write-CloudflareErrorMessage -Response $response
        }
    }
    
    end {
        Write-Debug "End getting DNS zones from Cloudflare"
    }
}