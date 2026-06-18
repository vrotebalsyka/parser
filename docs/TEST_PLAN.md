# Test Plan

## Synthetic Fixtures Only

No real candidate data is allowed. All fixtures must use invented names, fake numbers, and fake addresses.

Required fixture scenarios:

1. Fully correct questionnaire.
2. Missing foreign passport answer.
3. Passport without issue date.
4. Missing birth place.
5. Missing citizenship.
6. Missing residence permit answer.
7. Education without diploma number.
8. Foreign travel without purposes.
9. Criminal point answered with one common "нет".
10. Employment gap over one month.
11. Employment row without organization address.
12. Foreign travel row without purpose while other rows have purposes.
13. Invalid email-like contact without `@`.
14. Marriage answer with date but without place.
15. Other citizenship without acquisition basis/date and malformed citizenship wording.
16. Residence permit answer with no expiry date.
17. Education answer without diploma and registration numbers.
18. Criminal/legal answer with broken "не имею" wording.
19. State secret clearance issued without organization or form.
20. Residence period gap over one month.
12. Relative without citizenship.
13. Relative without address.
14. Residence places with period gap.
15. Missing phone/email.
16. Legacy Word 97-2003 `.doc` is signature-checked and either parsed by a local library or rejected with a clear message when the parser is unavailable.
17. PDF without text layer produces manual review/no crash.
18. 20-point form warns about legacy template.
19. 21-point form is primary successful template.
20. Questionnaire with application to point 13.
21. Questionnaire with application to point 14.
22. Phone-like 11-digit value is not extracted as SNILS.
23. Labelled valid SNILS is extracted and normalized.
24. Phone-like 10-digit value is not extracted as INN.
25. Labelled valid INN is extracted.
26. Address extraction ignores table headers and returns an actual address line.
27. DOCX report highlights error/critical issue text in red.
28. DOCX personal data summary highlights missing fields in red, but not correctly extracted low-confidence fields.
29. XLS success form fills only row 4 of a synthetic `.xls` template.
30. XLS success form is blocked when validation errors remain.
31. XLS success form is created with empty cells when optional extracted fields are missing.
32. Results/temp/settings paths persist between launches without storing selected questionnaire history.

## Unit Tests

- Point rules 1-21.
- Date parsing and future date detection.
- Period parsing.
- Employment gaps and overlaps.
- Residence-period gaps and overlaps.
- Row-level checks for travel purpose, employment address, relative residence address, and malformed contact/email values.
- Residence gaps and overlaps.
- Relatives table required fields.
- DOCX report generation.
- DOCX summary generation.
- Red highlighting in DOCX outputs.
- XLS success-form generation from a synthetic template.
- SNILS extraction must not reuse phone values.
- INN extraction must not reuse phone values.
- Residence address extraction must not reuse table headers.
- App settings persistence.
- PII redaction in logs.
- Secure temp cleanup.
- Network disabled by default.
- Word 97-2003 `.doc` signature handling.
- Oversized file rejection.
- Path traversal filename sanitization.

## Golden Tests

Golden tests compare deterministic JSON diagnostics for synthetic questionnaires. Golden outputs must not include PII that looks real.

## Manual Acceptance

Use a clean offline VM and follow `docs/INSTALLER_SPEC.md`.
