# Security Policy

Form4Checker processes personal data locally. MVP security is based on data minimization, offline execution, deterministic validation, and redacted diagnostics.

## Supported Security Model

- Single specialist PC.
- Offline runtime.
- No server-side storage.
- No candidate database.
- No external AI services.
- No network calls in ordinary operation.
- No Office automation or macro execution.

## Reporting Security Issues

Document issues in the project tracker or send them to the project maintainer. Do not attach real questionnaires, passports, tax identifiers, insurance numbers, addresses, phone numbers, or screenshots containing personal data.

## Real Data Prohibition

Do not place real candidate data in:

- Git repositories.
- Test fixtures.
- Golden files.
- Logs.
- Vigolium input.
- Screenshots.
- CI artifacts.
- Bug reports.

## Dependency Policy

NuGet dependencies must be reviewed before upgrade. Installer builds should use a locked package graph and an internal cache/feed when possible. For normal distribution, both application executable and installer must be code-signed.

