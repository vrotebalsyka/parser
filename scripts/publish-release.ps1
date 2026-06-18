param(
    [string]$Configuration = "Release"
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$AppProject = Join-Path $Root "src\Form4Checker.App\Form4Checker.App.csproj"
$PublishDir = Join-Path $Root "artifacts\publish\win-x64"

function Invoke-Checked {
    param(
        [Parameter(Mandatory = $true)]
        [string]$FilePath,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments
    )

    & $FilePath @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "Command failed with exit code ${LASTEXITCODE}: $FilePath $($Arguments -join ' ')"
    }
}

Write-Host "Form4Checker release publish"
Write-Host "Root: $Root"

if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) {
    throw "dotnet SDK is required to build Form4Checker."
}

$sdkList = & dotnet --list-sdks
if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace(($sdkList | Out-String))) {
    throw "На этой машине не найден .NET SDK. Установите .NET 10 SDK x64, затем повторите запуск скрипта."
}

if (-not ($sdkList | Where-Object { $_ -match '^10\.' })) {
    Write-Warning "В списке SDK не найден .NET 10. Проект целится в net10.0/net10.0-windows; сборка может не пройти."
}

New-Item -ItemType Directory -Force -Path $PublishDir | Out-Null

Invoke-Checked dotnet restore (Join-Path $Root "Form4Checker.sln")
Invoke-Checked dotnet test (Join-Path $Root "Form4Checker.sln") --configuration $Configuration --no-restore
Invoke-Checked dotnet publish $AppProject `
    --configuration $Configuration `
    --runtime win-x64 `
    --self-contained true `
    --no-restore `
    --output $PublishDir `
    /p:PublishSingleFile=true `
    /p:PublishReadyToRun=true `
    /p:PublishTrimmed=false `
    /p:SelfContained=true `
    /p:RuntimeIdentifier=win-x64

Write-Host "Publish output: $PublishDir"
Write-Host "TODO: sign Form4Checker.exe before broad distribution."
