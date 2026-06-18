using Form4Checker.Core.Domain;
using Form4Checker.Core.Presentation;
using Form4Checker.Core.Validation;
using Form4Checker.Extraction;

if (args.Length < 2)
{
    Console.WriteLine("Usage: Form4Checker.Tools extract-pdf <pdfPath> | parse-pdf <pdfPath> | parse-docx <docxPath> | validate-pdf <pdfPath> | validate-docx <docxPath>");
    return 2;
}

var command = args[0];
var path = args[1];

if (command == "extract-pdf")
{
    var text = await new PdfTextExtractor().ExtractTextAsync(path, CancellationToken.None);
    Console.WriteLine(text);
    return 0;
}

if (command == "parse-pdf")
{
    var text = await new PdfTextExtractor().ExtractTextAsync(path, CancellationToken.None);
    var parser = new Form4SectionParser(new Form4TableParser());
    var questionnaire = parser.Parse(path, SourceFileType.Pdf, text, []);
    foreach (var point in questionnaire.Points)
    {
        Console.WriteLine($"--- POINT {point.Number}: {point.Title} [{(point.IsMissing ? "missing" : "text")}] ---");
        Console.WriteLine(point.Text.Length > 1200 ? point.Text[..1200] : point.Text);
        Console.WriteLine();
    }

    return 0;
}

if (command == "parse-docx")
{
    var parser = new Form4SectionParser(new Form4TableParser());
    var extractor = new DocxQuestionnaireExtractor(parser);
    var questionnaire = await extractor.ExtractAsync(path, [], CancellationToken.None);
    foreach (var point in questionnaire.Points)
    {
        Console.WriteLine($"--- POINT {point.Number}: {point.Title} [{(point.IsMissing ? "missing" : "text")}] ---");
        Console.WriteLine(point.Text.Length > 1600 ? point.Text[..1600] : point.Text);
        Console.WriteLine();
    }

    return 0;
}

if (command == "validate-pdf")
{
    var text = await new PdfTextExtractor().ExtractTextAsync(path, CancellationToken.None);
    var parser = new Form4SectionParser(new Form4TableParser());
    var questionnaire = parser.Parse(path, SourceFileType.Pdf, text, []);
    var result = new Form4ValidationPipeline(new PersonalDataSummaryBuilder(), new CandidateMessageBuilder()).Validate(questionnaire);
    foreach (var point in result.PointResults)
    {
        Console.WriteLine($"{point.PointNumber}. {point.PointTitle}: {DisplayText.PointStatus(point.Status)}");
        foreach (var issue in point.Issues)
        {
            Console.WriteLine($"  - {DisplayText.Severity(issue.Severity)}: {issue.MessageForSpecialist}");
            if (!string.IsNullOrWhiteSpace(issue.FoundValue))
            {
                Console.WriteLine($"    Найдено: {issue.FoundValue}");
            }
        }
    }

    return 0;
}

if (command == "validate-docx")
{
    var parser = new Form4SectionParser(new Form4TableParser());
    var extractor = new DocxQuestionnaireExtractor(parser);
    var questionnaire = await extractor.ExtractAsync(path, [], CancellationToken.None);
    var result = new Form4ValidationPipeline(new PersonalDataSummaryBuilder(), new CandidateMessageBuilder()).Validate(questionnaire);
    foreach (var point in result.PointResults)
    {
        Console.WriteLine($"{point.PointNumber}. {point.PointTitle}: {DisplayText.PointStatus(point.Status)}");
        foreach (var issue in point.Issues)
        {
            Console.WriteLine($"  - {DisplayText.Severity(issue.Severity)}: {issue.MessageForSpecialist}");
            if (!string.IsNullOrWhiteSpace(issue.FoundValue))
            {
                Console.WriteLine($"    Найдено: {issue.FoundValue}");
            }
        }
    }

    return 0;
}

Console.WriteLine($"Unknown command: {command}");
return 2;
