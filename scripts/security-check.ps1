$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$SourceRoot = Join-Path $Root "src"

$networkPatterns = @(
    "HttpClient",
    "WebRequest",
    "WebClient",
    "TcpClient",
    "UdpClient",
    "Socket",
    "OpenAI",
    "api\.openai",
    "https?://"
)

$matches = Get-ChildItem -Path $SourceRoot -Recurse -Include *.cs,*.xaml |
    Select-String -Pattern $networkPatterns -CaseSensitive:$false |
    Where-Object { $_.Line -notmatch 'xmlns(:\w+)?="http://schemas\.microsoft\.com/winfx/' }

if ($matches) {
    Write-Host "Potential network/AI references found:"
    $matches | ForEach-Object { Write-Host "$($_.Path):$($_.LineNumber): $($_.Line.Trim())" }
    throw "Security check failed."
}

Write-Host "Security check passed: no obvious network or external AI references in src."
