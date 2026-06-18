param(
    [string]$Configuration = "Release"
)

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$PublishScript = Join-Path $Root "scripts\publish-release.ps1"
$InstallerScript = Join-Path $Root "src\Form4Checker.Packaging\Form4Checker.iss"
$ArtifactsDir = Join-Path $Root "artifacts"
$ExpectedInstaller = Join-Path $ArtifactsDir "Form4CheckerSetup-x64.exe"

& $PublishScript -Configuration $Configuration
if ($LASTEXITCODE -ne 0) {
    throw "Publish failed. Installer build stopped."
}

$PublishedExe = Join-Path $Root "artifacts\publish\win-x64\Form4Checker.exe"
if (-not (Test-Path $PublishedExe)) {
    throw "Published application was not found: $PublishedExe. Install .NET 10 SDK and make sure publish-release.ps1 completes successfully."
}

$isccCommand = Get-Command iscc -ErrorAction SilentlyContinue
$iscc = if ($isccCommand) { $isccCommand.Source } else { $null }

if (-not $iscc) {
    $candidates = @(
        "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
        "$env:ProgramFiles\Inno Setup 6\ISCC.exe"
    )
    $iscc = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
}

if (-not $iscc) {
    throw "Inno Setup Compiler (ISCC.exe) was not found. Install Inno Setup 6 on the build machine."
}

New-Item -ItemType Directory -Force -Path $ArtifactsDir | Out-Null
& $iscc $InstallerScript

if (-not (Test-Path $ExpectedInstaller)) {
    throw "Installer was not produced: $ExpectedInstaller"
}

Write-Host "Installer output: $ExpectedInstaller"
Write-Host "TODO: sign Form4CheckerSetup-x64.exe before broad distribution."
