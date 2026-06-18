# Data Retention

## MVP Policy

Form4Checker does not store a candidate database and does not maintain a history of processed questionnaires.

## Temporary Data

Temporary files are stored in:

```text
%LOCALAPPDATA%\Form4Checker\Temp
```

The application cleans temporary files:

- at startup;
- after a processing session;
- when the user clicks "Очистить временные файлы";
- according to the configured retention period.

## Output Data

Generated DOCX reports and summaries are written only when the user requests export. The specialist is responsible for storing and deleting generated outputs according to organizational policy.

## Logs

Logs are diagnostic only and must be redacted before write. Logs must not contain raw PII.

## Technical JSON

Technical JSON is optional and intended for diagnostics/tests. It should be disabled for normal operation unless explicitly enabled by the specialist.

