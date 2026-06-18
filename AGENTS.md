# AGENTS.md

Instructions for engineering agents working on Form4Checker.

## Non-Negotiable MVP Boundaries

- Do not add OCR.
- Do not add external AI.
- Do not add network APIs.
- Do not add a server, database, CRM, account system, or candidate history store.
- Do not use Microsoft Office automation.
- Word 97-2003 `.doc` support is allowed only through deterministic local libraries and explicit file signature checks; never use Office/COM automation.
- Do not process real candidate data in tests, fixtures, demos, or security audits.
- Do not log PII.
- Do not make Vigolium part of the end-user application or installer.

## Required Order For Major Work

1. Update product/security docs and Form 4 rules.
2. Update threat model if the data flow changes.
3. Implement core/domain behavior.
4. Implement extraction/reporting/security services.
5. Implement UI.
6. Add or update tests.
7. Update installer/build scripts if needed.

## Coding Standards

- Prefer explicit domain models over dictionaries for candidate data.
- Keep validation rules deterministic and explainable.
- Every validation issue should include source evidence when available.
- Keep user-facing Russian text human, concise, and non-technical.
- Keep internal identifiers out of candidate messages.
- Use Open XML SDK for DOCX reading/writing.
- Use a local PDF text extractor only for PDFs with text layers.
- Treat scanned documents as manual review in MVP.

## Security Review Checklist

- Are file extension and signature checked?
- Are file size and extracted text size bounded?
- Are PDF pages bounded?
- Are temp files under `LocalApplicationData\Form4Checker\Temp`?
- Is PII redacted before logs?
- Are network calls absent from runtime code?
- Is AI disabled by default and locked in MVP?
- Are generated outputs written only to the selected results folder?
- Are path traversal and hostile filenames neutralized?
