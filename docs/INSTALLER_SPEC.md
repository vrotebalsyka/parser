# Installer Specification

## Goal

Produce one offline installer:

```text
artifacts/Form4CheckerSetup-x64.exe
```

The installer must not download dependencies during installation.

## Publish Requirements

`scripts/publish-release.ps1` runs:

- `dotnet restore`
- `dotnet test`
- `dotnet publish src/Form4Checker.App/Form4Checker.App.csproj -c Release -r win-x64 --self-contained true`

Publish properties:

- `PublishSingleFile=true`
- `SelfContained=true`
- `RuntimeIdentifier=win-x64`
- `PublishReadyToRun=true` when stable
- no trimming for WPF without separate testing

## Installer Requirements

The installer:

- installs to per-user application directory by default;
- creates a desktop shortcut;
- creates a Start menu shortcut;
- adds uninstall entry;
- runs offline;
- does not require .NET Runtime, Office, LibreOffice, Python, Docker, WSL, Visual Studio, OCR engines, or internet access.

## Tooling

MVP uses Inno Setup because it is simple and sufficient for a single-machine desktop application. WiX can be reconsidered later if enterprise MSI deployment becomes required.

## Code Signing

For normal distribution, both the application executable and installer must be signed.

MVP build scripts contain signing TODO hooks. If the installer is not signed, Windows SmartScreen or corporate policy can show warnings or block installation.

## Acceptance Installation Test

1. Start a clean Windows 10/11 x64 VM.
2. Ensure no .NET Runtime, Office, Python, OCR engines, Docker, WSL, or internet are available.
3. Run `Form4CheckerSetup-x64.exe`.
4. Install the application.
5. Launch from desktop shortcut.
6. Open synthetic DOCX questionnaire.
7. Generate DOCX report.
8. Generate DOCX personal data summary.
9. Uninstall from Windows Apps/Programs.

