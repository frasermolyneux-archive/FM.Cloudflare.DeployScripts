function Write-CloudflareErrorMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)] [String] $Response
    )
    
    begin {
        Write-Debug "Begin getting Cloudflare error message from response"
    }
    
    process {

        if ($Response.success -eq $false)
        {
            Write-Error "Failed Cloudflare operation [$($Response.errors.code)] $($Response.errors.message)"

            $Response.errors.error_chain | ForEach-Object {
                Write-Error "Error Chain: [$($_.code)] $($_.message)"
            }
        }

    }
    
    end {
        Write-Debug "End getting Cloudflare error message from response"
    }
}