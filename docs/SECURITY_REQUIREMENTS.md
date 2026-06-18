# Security Requirements

## Runtime

- Process all data locally.
- Do not perform network requests in ordinary operation.
- External AI is disabled and locked in MVP.
- Do not store a candidate database.
- Do not create processing history with PII.
- Do not execute document content.
- Do not run macros.
- Do not use Office automation.
- Excel 97-2003 `.xls` output, when enabled, must be written through a local library and must never execute workbook content.

## File Controls

- Validate extension and file signature.
- Word 97-2003 `.doc` must be signature-checked and processed only by local libraries; if the local parser is unavailable, show a clear user-facing rejection.
- Limit file size.
- Limit PDF page count.
- Limit extracted text volume.
- Sanitize all generated file names.
- Treat unsupported documents as manual review or clear user-facing rejection.
- Do not modify source questionnaires or XLS templates in place; write generated outputs only to the selected results folder.

## Logging

- Logs must never contain raw:
  - full names;
  - passport numbers;
  - INN;
  - SNILS;
  - addresses;
  - phones;
  - emails.
- Every log entry passes through `IPiiRedactor`.
- Technical JSON is optional and disabled by default for normal users.
- Persisted settings may contain local folders and a template path only; they must not store candidate files, extracted questionnaire text, or generated candidate history.

## Temporary Files

- Use `LocalApplicationData\Form4Checker\Temp`.
- Clean temp files at app startup.
- Clean session temp files after processing.
- Provide "Очистить временные файлы".
- Use safe file names and avoid real questionnaire names in temp paths.

## AI Policy

No real candidate data may be sent to external AI services. Future AI stubs must be disabled by compile-time or feature flag, default false, and must not be reachable from MVP settings.
