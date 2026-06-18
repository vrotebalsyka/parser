# Threat Model

## Assets

- Candidate questionnaire content.
- Passport data.
- INN.
- SNILS.
- Addresses.
- Phone and email.
- Generated reports and summaries.
- Configured results folder, temp folder, and optional XLS template path.
- Temporary extracted text.
- Logs and diagnostic JSON.

## Trust Boundaries

- User-selected files are untrusted.
- Extracted document text is untrusted.
- File names are untrusted.
- Output folder paths are user-controlled but must be normalized.
- NuGet packages and installer tooling are supply-chain dependencies.

## Threats And Controls

| Threat | Control |
| --- | --- |
| Malicious DOCX/PDF | Use parser libraries only; no macro execution; no Office automation; catch parser failures safely. |
| Path traversal through file name | Sanitize generated file names; never combine untrusted file names directly into output paths. |
| Zip bomb / oversized DOCX | Enforce file size limit and extracted text limit. |
| Oversized PDF / parser hang | Enforce file size, page count, extraction timeout, and extracted text limit. |
| PII leakage in logs | Redact through `IPiiRedactor` before writing logs. |
| PII leakage in temp files | Controlled temp directory; cleanup at startup, after session, and by user command. |
| PII leakage through reused XLS template row | Export writes a new copy, changes row 4, and clears unmapped row-4 cells instead of modifying the template in place. Users must configure a blank corporate template. |
| Local settings become candidate history | Settings store folders/template path only; no selected questionnaire path, extracted text, or candidate list is persisted. |
| Accidental internet transmission | `INetworkGuard`; no runtime network clients; external AI disabled and locked. |
| Prompt injection if LLM appears later | Treat extracted text as data; keep AI behind compile-time/feature flag default false. |
| Form template substitution | Detect 21-point vs 20-point template and warn on legacy/unknown layout. |
| Damaged PDF/DOCX | Safe user-facing errors; no crash; manual review where possible. |
| Parser denial of service | File size, page count, text size, and timeout limits. |
| Unsafe installer | Offline installer; no dependency downloads; code signing required before broad distribution. |
| Supply-chain NuGet risk | Review packages, pin versions, prefer internal feed/cache for release builds. |

## Security Assumptions

- The specialist PC is controlled by the organization.
- The Windows user account is trusted for local access to selected files.
- Form4Checker does not attempt to prevent screenshots, local file copying, or OS-level administrator access.

## Residual Risks

- Local malware can read files accessible to the current user.
- Unsigned MVP installer may trigger SmartScreen/corporate warnings.
- Text extraction can miss data or produce false positives.
- Manual verification remains required.
