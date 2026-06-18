# Form 4 Rules

The primary MVP template contains 21 points. A 20-point template is legacy-compatible and must produce a warning: "Использован вариант бланка без пункта 21, проверьте актуальность формы".

Applications to points 2, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, and 18 are parsed as additional text and merged with the main point when detected.

## Severity

- `Info`
- `Warning`
- `Error`
- `Critical`
- `ManualReview`

## Point Rules

1. FIO: surname, name, patronymic required unless no patronymic is explicit; reject digits/special symbols and junk values.
2. FIO changes: explicit "не изменял(а)" or complete change details: previous FIO, new FIO, when, where, reason.
3. Birth: date and place required; date must not be future; support numeric and word dates.
4. Russian passport: series, number, issuer, issue date required; missing series/number is critical; issue date must not be future. Issuer detection accepts common Russian authority markers such as УФМС, МВД, ОВД, ОМВД, УМВД, and ТП УФМС even when the word "выдан" is absent. Dates with `г.` suffix are valid.
5. Foreign passport: explicit absence or details; if details exist, require series/number, issuer, issue date, expiry date.
6. Marital status: explicit answer; if married/divorced/widowed, require relevant person/date/place details.
7. Citizenship: current citizenship, change status, and other citizenship status required; if another citizenship exists, require country/details plus acquisition date or basis; flag known broken wording such as "другого государство".
8. Residence permit/right abroad: explicit absence or document details; if present, require country/document details and a real expiry date or explicit indefinite status. Template words like "срок его действия" alone are not enough.
9. Education: level, graduation year, organization, study form, diploma identifier, and registration number when expected.
10. Foreign travel: explicit absence or trips with country, dates, and purpose for each trip; remind that all trips outside Russia including CIS after 1991 are needed.
11. Criminal/legal questions: separate answers for A, B, and C; one common "нет" is insufficient; flag grammatically invalid legal answers that change the meaning, for example "уголовное преследование ... не имею".
12. State secret clearance: explicit answer; if issued, require date, organization, form, and current status. Template prompt words must not satisfy organization/form checks.
13. Employment: table periods with start/end, role/status, organization, and address; check empty rows, ordering, overlaps, gaps over one month, current period, military/business details. A row with work/study/status but no address must be reported separately.
14. Relatives: table rows with relationship, FIO, birth, citizenship, work/status, role, organization location, and residence/registration address; handle deceased/unknown cases. For employed adult relatives, one address-like fragment is treated as insufficient because it can be only the work address.
15. Close relatives abroad: explicit absence or details with FIO/initials, relationship, country, residence period, document, issuing state, expiry.
16. Residence/registration places since birth: continuous periods from birth to present; every period needs address and residence/registration labels when different.
17. Phone/contact: phone or other contact required; validate phone and email if present, including malformed email-like values without `@`. Phone-like 10/11 digit values must not be reused as SNILS in the personal data summary.
18. Additional information: "не имею" allowed; blank is warning.
19. State secret law acknowledgement: point presence required; signature is manual review.
20. False information acknowledgement: point presence required; signature is manual review.
21. Consent to state secret clearance: point presence required in primary template; signature/date are manual review.

## Candidate Message

The candidate message must be polite, grouped by point, and free of internal `ruleId` values and debug text.

## Personal Data Summary

- SNILS is extracted only from explicit SNILS context or from a value that passes the SNILS checksum.
- Phone-context values such as "тел.", "моб.", or "номер телефона" are never treated as SNILS.
- INN is extracted only from explicit INN context or from a valid 12-digit checksum value outside phone/passport context.
- Residence address extraction must ignore table headers such as "адреса в других государствах" and use an actual address line.
- The success XLS form may be exported when the questionnaire has no validation errors. Missing extracted values are written as empty cells.
