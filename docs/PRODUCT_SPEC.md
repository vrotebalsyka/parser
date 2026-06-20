# Product Specification

## Purpose

Form4Checker helps a specialist perform a first-pass check of a completed candidate questionnaire based on Form 4. It highlights omissions and suspicious entries, prepares a DOCX report, prepares a DOCX personal data summary, can fill a configured XLS success-form template, and drafts a polite message to the candidate.

The application is an assistant, not a decision-maker. A specialist must manually verify all results.

## User Scenario

1. The specialist launches Form4Checker.
2. The specialist selects a DOCX, text-layer PDF, or Word 97-2003 DOC questionnaire.
3. The specialist optionally attaches documents: passport, INN, SNILS, or other files.
4. The specialist clicks "Проверить".
5. The application shows issues grouped by Form 4 points.
6. The specialist exports:
   - DOCX validation report.
   - DOCX personal data summary.
   - XLS success form when there are no validation errors and the corporate template is configured.
   - Candidate correction message draft.

## Input Formats

Questionnaire:

- `.docx` supported and primary.
- `.pdf` supported only when it has a text layer.
- Word 97-2003 `.doc` is a required legacy format and is parsed only through deterministic local code/library support and file signature checks. Office automation, LibreOffice conversion, macro execution, OCR, network APIs, and external AI are forbidden.

Attached documents:

- `.pdf`
- `.jpg`
- `.jpeg`
- `.png`
- `.tif`
- `.tiff`

OCR is not implemented in MVP. Scans/photos and PDFs without text become manual review.

## Output Formats

Validation report:

- `Отчет_проверки_анкеты_<ФИО_или_ID>_<дата>.docx`
- Overall status.
- Errors, warnings, critical issues, and manual-review items.
- Error and critical issue text is highlighted in red.
- Notes for each Form 4 point.
- Recommendations.
- Candidate message draft.
- Document verification section.
- Technical information without debug noise.

Personal data summary:

- `Сводка_персональных_данных_<ФИО_или_ID>_<дата>.docx`
- Extracted personal fields and confidence status.
- Missing or manually reviewed fields are highlighted in red; correctly extracted fields are not red solely because of low parser confidence.

Success XLS form:

- `Итоговая_форма_персональных_данных_<ФИО_или_ID>_<дата>.xls`
- Uses a user-configured blank Excel 97-2003 `.xls` template.
- Only row 4 of the output copy is changed.
- Existing template files are never modified in place.
- If extracted values are missing but the questionnaire has no validation errors, the output XLS is still created with empty cells for missing values.
- If validation errors remain, export is blocked with a clear user message.

Technical JSON:

- Optional diagnostic artifact controlled by settings.
- Not the primary user-facing result.
- Must not contain unnecessary personal data.

## Extraction Pipeline

The product pipeline is:

`FileTypeDetector -> QuestionnaireExtractor -> Layout/Text/Table model -> Form4SectionParser -> Point-specific parsers -> ValidationPipeline -> Report/Summary/CandidateMessage`.

DOCX, PDF, and DOC extractors all produce a normalized text stream and, where available, paragraph/table/page evidence. If extraction loses table boundaries or the PDF has no usable text layer, the application must create a manual-review issue rather than making confident false claims.

## Main Window

- Questionnaire picker and status.
- Attached document picker and document status list.
- "Проверить" command.
- Form 4 points 1-21 with statuses: OK, Warning, Error, Critical, Manual review.
- Issue details: problem, value, source, reason, recommendation, candidate text.
- Buttons:
  - "Сформировать DOCX-отчёт"
  - "Сформировать DOCX-сводку персональных данных"
  - "Скопировать сообщение кандидату"
  - "Открыть папку с результатами"
  - "Очистить временные файлы"
- Settings:
  - Privacy mode `Strict` by default.
  - External AI disabled and locked.
  - Results folder is saved locally and reused on next launch.
  - Temp folder.
  - Temp retention.
  - Optional XLS success-form template path.
  - Technical JSON toggle.
  - Installer diagnostics.

## Out Of Scope For MVP

- OCR.
- Handwriting recognition.
- Automatic source questionnaire correction.
- Candidate database.
- CRM.
- Network operation.
- External AI.
- PDF report generation.
- Macro execution.
- Office automation.
- Vigolium in end-user app.
