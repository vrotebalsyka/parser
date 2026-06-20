# Form4Checker

Form4Checker is a local Windows desktop application for checking a completed candidate questionnaire based on Form 4.

The MVP is intentionally offline and single-user:

- WPF + MVVM desktop application.
- C# / .NET 10 LTS target.
- Self-contained `win-x64` publish.
- No Microsoft Office automation.
- No OCR in MVP.
- No external AI for real candidate data.
- No server, CRM, candidate database, network API, Docker, WSL, Python, or internet dependency for end users.

End users install one offline installer:

```powershell
artifacts/Form4CheckerSetup-x64.exe
```

After installation, the application must start from the desktop shortcut or Start menu and work without .NET Runtime, Office, LibreOffice, Tesseract, PaddleOCR, Visual Studio, or internet access.

## MVP Workflow

1. Select a completed questionnaire in DOCX, text-layer PDF, or Word 97-2003 DOC.
2. Optionally attach candidate documents: PDF, JPG/JPEG, PNG, TIF/TIFF.
3. Click "Проверить".
4. Review issues grouped by Form 4 points 1-21.
5. Export a DOCX validation report.
6. Export a DOCX personal data summary.
7. Copy a polite draft message for the candidate.
8. Manually verify the result before making a decision.

## Build

The repository is designed to build on Windows with the .NET 10 SDK installed.

```powershell
pwsh scripts/publish-release.ps1
pwsh scripts/build-installer.ps1
```

The build scripts are offline at installer runtime. Package restore during development/build still requires the project dependencies to be available in the local NuGet cache or an approved internal feed.

## Implementation Note

The repository structure matches this README. The implementation now treats `.doc` as a legacy questionnaire input, but only after extension and Compound File Binary signature checks. DOC extraction is local and deterministic; it does not use Office, LibreOffice, COM automation, OCR, AI, network APIs, or a background service. If DOC table boundaries cannot be recovered confidently, the extractor returns warnings and falls back to conservative text extraction so the UI can route the case to manual review instead of crashing.

## Security Defaults

- Privacy mode is `Strict` by default.
- External AI is disabled and locked in MVP.
- Logs are redacted through `IPiiRedactor`.
- Temporary files are stored under a controlled user-local directory and cleaned at startup/session end.
- File extension, signature, size, PDF page count, and extracted text volume are bounded.
- Real candidate data must not be used in tests, audits, demos, or CI.

## Vigolium

Vigolium is not required for end users.

It is a developer/CI-only security audit tool. It must never be installed on the specialist's PC by Form4Checker and must never be run on real questionnaires or candidate documents. Use only source code and synthetic test data.

## Repository Layout

```text
src/
  Form4Checker.App/          WPF UI and MVVM
  Form4Checker.Core/         domain models, validation rules, pipeline
  Form4Checker.Extraction/   DOCX/PDF extraction and Form 4 section parsing
  Form4Checker.Reporting/    DOCX report and personal data summary builders
  Form4Checker.Security/     secure temp files, PII redaction, settings, logging
  Form4Checker.Packaging/    installer scripts

tests/
  Form4Checker.Core.Tests/
  Form4Checker.Extraction.Tests/
  Form4Checker.Reporting.Tests/
  Form4Checker.Security.Tests/
  Form4Checker.GoldenTests/

rules/
  form4.sections.yaml
  form4.validation.yaml
  pii.patterns.yaml

docs/
  PRODUCT_SPEC.md
  ARCHITECTURE.md
  THREAT_MODEL.md
  SECURITY_REQUIREMENTS.md
  FORM4_RULES.md
  DATA_RETENTION.md
  INSTALLER_SPEC.md
  TEST_PLAN.md
  OPEN_QUESTIONS.md
```
