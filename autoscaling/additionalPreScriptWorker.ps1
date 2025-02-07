param(
    [Parameter(Mandatory = $False)]
    [string]
    $branch = "master",

    [Parameter(Mandatory = $False)]
    [switch]
    $restart,

    [Parameter(Mandatory = $False)]
    [string]
    $authToken = $null
)

if (-not $restart) {
    # install WINS
    New-Item -Path c:\etc\rancher\wins -Force -ItemType Directory | Out-Null
    @{
        whiteList = @{
            proxyPorts = @(9323,9796)
        }
    } | ConvertTo-Json -Compress -Depth 32 | Out-File -NoNewline -Encoding utf8 -Force -FilePath "c:\etc\rancher\wins\config"

    New-Item -Path c:\wins\bin -Force -ItemType Directory | Out-Null
    $ProgressPreference = 'SilentlyContinue'
    [DownloadWithRetry]::DoDownloadWithRetry("https://github.com/rancher/wins/releases/download/v0.1.0/wins.exe", 5, 10, $null, "C:\wins\wins.exe")
    C:\wins\wins.exe srv app run --register
    Start-Service rancher-wins

    # activate dockerd metrics
    Stop-Service docker
    $dockerDaemonConfig = @"
{
    `"metrics-addr`": `"127.0.0.1:9323`",
    `"experimental`": true
}
"@
    $dockerDaemonConfig | Out-File "c:\programdata\docker\config\daemon.json" -Encoding ascii
    Start-Service docker
}


class DownloadWithRetry {
    static [string] DoDownloadWithRetry([string] $uri, [int] $maxRetries, [int] $retryWaitInSeconds, [string] $authToken, [string] $outFile) {
        $retryCount = 0
        $headers = $null
        if (-not ([string]::IsNullOrEmpty($authToken))) {
            $headers = @{
                'Authorization' = $authToken
            }
        }

        while ($retryCount -le $maxRetries) {
            try {
                if ($null -ne $headers) {
                    if ([string]::IsNullOrEmpty($outFile)) {
                        $result = Invoke-WebRequest -Uri $uri -Headers $headers -UseBasicParsing
                        return $result.Content
                    }
                    else {
                        $result = Invoke-WebRequest -Uri $uri -Headers $headers -UseBasicParsing -OutFile $outFile
                        return ""
                    }
                }
                else {
                    throw;
                }
            }
            catch {
                if ($null -ne $headers) {
                    write-host "download of $uri failed"
                }
                try {
                    if ([string]::IsNullOrEmpty($outFile)) {
                        $result = Invoke-WebRequest -Uri $uri -UseBasicParsing
                        return $result.Content
                    }
                    else {
                        $result = Invoke-WebRequest -Uri $uri -UseBasicParsing -OutFile $outFile
                        return ""
                    }
                }
                catch {
                    write-host "download of $uri failed"
                    $retryCount++;
                    if ($retryCount -le $maxRetries) {
                        Start-Sleep -Seconds $retryWaitInSeconds
                    }            
                }
            }
        }
        return ""
    }
}