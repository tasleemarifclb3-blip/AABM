import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import 'brand.dart';

class ReceiptActions {
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  /// Indian-numbering amount in words, suitable for receipts/vouchers.
  /// Example: 1250.50 -> "Rupees One Thousand Two Hundred Fifty and Paise Fifty Only".
  static String amountInWords(double value) {
    if (!value.isFinite || value < 0) return 'Rupees Zero Only';
    final roundedPaise = (value * 100).round();
    var rupees = roundedPaise ~/ 100;
    final paise = roundedPaise % 100;

    String underHundred(int n) {
      const ones = [
        '',
        'One',
        'Two',
        'Three',
        'Four',
        'Five',
        'Six',
        'Seven',
        'Eight',
        'Nine',
        'Ten',
        'Eleven',
        'Twelve',
        'Thirteen',
        'Fourteen',
        'Fifteen',
        'Sixteen',
        'Seventeen',
        'Eighteen',
        'Nineteen',
      ];
      const tens = [
        '',
        '',
        'Twenty',
        'Thirty',
        'Forty',
        'Fifty',
        'Sixty',
        'Seventy',
        'Eighty',
        'Ninety',
      ];
      if (n < 20) return ones[n];
      return '${tens[n ~/ 10]}${n % 10 == 0 ? '' : ' ${ones[n % 10]}'}';
    }

    String integerWords(int n) {
      if (n == 0) return 'Zero';
      final parts = <String>[];
      if (n >= 10000000) {
        parts.add('${integerWords(n ~/ 10000000)} Crore');
        n %= 10000000;
      }
      if (n >= 100000) {
        parts.add('${integerWords(n ~/ 100000)} Lakh');
        n %= 100000;
      }
      if (n >= 1000) {
        parts.add('${integerWords(n ~/ 1000)} Thousand');
        n %= 1000;
      }
      if (n >= 100) {
        parts.add('${underHundred(n ~/ 100)} Hundred');
        n %= 100;
      }
      if (n > 0) parts.add(underHundred(n));
      return parts.join(' ');
    }

    // Protect against an accidental negative zero after rounding.
    if (rupees == 0 && paise == 0) return 'Rupees Zero Only';
    final rupeePart = 'Rupees ${integerWords(rupees)}';
    final paisePart = paise == 0 ? '' : ' and Paise ${underHundred(paise)}';
    return '$rupeePart$paisePart Only';
  }

  static Future<void> printPdf({required Uint8List bytes, required String fileName}) async {
    await Printing.layoutPdf(onLayout: (_) async => bytes, name: fileName);
  }

  static Future<void> sharePdf({
    required Uint8List bytes,
    required String fileName,
    required String message,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        text: message,
        files: [XFile.fromData(bytes, mimeType: 'application/pdf', name: fileName)],
        fileNameOverrides: [fileName],
      ),
    );
  }

  static Future<void> showActionsDialog({
    required BuildContext context,
    required String documentNumber,
    required Future<Uint8List> Function() buildPdf,
    required String shareMessage,
    String title = 'Document Generated',
    String fileNamePrefix = 'Document',
  }) async {
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text('No: $documentNumber'),
        actions: [
          OutlinedButton.icon(
            icon: const Icon(Icons.print),
            label: const Text('Print / Save PDF'),
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                final bytes = await buildPdf();
                await printPdf(bytes: bytes, fileName: '$fileNamePrefix-$documentNumber.pdf');
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not print PDF: $e')));
                }
              }
            },
          ),
          FilledButton.icon(
            icon: const Icon(Icons.share),
            label: const Text('Send via WhatsApp'),
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                final bytes = await buildPdf();
                await sharePdf(
                  bytes: bytes,
                  fileName: '$fileNamePrefix-$documentNumber.pdf',
                  message: shareMessage,
                );
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not share PDF: $e')));
                }
              }
            },
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Compact two-column row used by thermal receipts across the app.
  static pw.TableRow thermalRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 7.5,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          child: pw.Text(
            value,
            style: const pw.TextStyle(fontSize: 7.5),
          ),
        ),
      ],
    );
  }

  static pw.Document thermalReceiptDocument({
    required String title,
    required String documentNumber,
    required DateTime date,
    required List<pw.TableRow> rows,
    String? amountWords,
    String? remarks,
    String? outstanding,
    String? totalSettled,
    String? balanceRemaining,
  }) {
    final document = pw.Document();
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat(80 * PdfPageFormat.mm, 180 * PdfPageFormat.mm),
        margin: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        build: (_) => [
          pw.Container(
            padding: const pw.EdgeInsets.all(7),
            decoration: pw.BoxDecoration(border: pw.Border.all(width: 1.0, color: PdfColors.black)),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Center(child: pw.Image(brandPdfLogo, width: 62, height: 62, fit: pw.BoxFit.contain)),
                pw.SizedBox(height: 3),
                pw.Text('AL-AMIN BAITUL MAAL TRUST', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                pw.Text('Regd. No. 5767', textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 8)),
                pw.Text('Dangerpora, Malla Bagh, Srinagar', textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 7)),
                pw.Divider(),
                pw.Text(title, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text('No: $documentNumber', style: const pw.TextStyle(fontSize: 8)),
                pw.Text('Date: ${formatDate(date)}', style: const pw.TextStyle(fontSize: 8)),
                pw.SizedBox(height: 5),
                pw.Table(border: pw.TableBorder.all(width: .5), children: rows),
                if (amountWords != null && amountWords.trim().isNotEmpty) ...[
                  pw.SizedBox(height: 7),
                  pw.Text('Amount in Words', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 2),
                  pw.Text(amountWords.trim(), style: const pw.TextStyle(fontSize: 8)),
                ],
                if (totalSettled != null && totalSettled.trim().isNotEmpty) ...[
                  pw.SizedBox(height: 6),
                  pw.Text('Total Settled: $totalSettled', textAlign: pw.TextAlign.left, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                ],
                if (outstanding != null) ...[
                  pw.SizedBox(height: 6),
                  pw.Text('OUTSTANDING: $outstanding', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                ],
                if (balanceRemaining != null && balanceRemaining.trim().isNotEmpty) ...[
                  pw.SizedBox(height: 6),
                  pw.Text('Balance Remaining: $balanceRemaining', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                ],
                if (remarks != null && remarks.trim().isNotEmpty) ...[
                  pw.SizedBox(height: 5),
                  pw.Text('Remarks: $remarks', style: const pw.TextStyle(fontSize: 8)),
                ],
                pw.SizedBox(height: 12),
                pw.Text('Thank you', textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 8)),
              ],
            ),
          ),
        ],
      ),
    );
    return document;
  }

  static pw.TableRow pdfRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(7),
          color: PdfColor.fromHex('#EEF4F1'),
          child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
        pw.Padding(padding: const pw.EdgeInsets.all(7), child: pw.Text(value)),
      ],
    );
  }

  static pw.Widget _linedArea(String value, {int lines = 1, double lineHeight = 15}) {
    final safeLines = lines < 1 ? 1 : lines;
    return pw.Container(
      padding: const pw.EdgeInsets.all(5),
      decoration: pw.BoxDecoration(border: pw.Border.all(width: .5, color: PdfColors.grey600)),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Text(value.trim().isEmpty ? ' ' : value.trim(), style: const pw.TextStyle(fontSize: 9)),
          pw.SizedBox(height: 3),
          ...List.generate(
            safeLines,
            (_) => pw.Container(
              height: lineHeight,
              decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(width: .35, color: PdfColors.grey500))),
            ),
          ),
        ],
      ),
    );
  }

  static pw.TableRow _linedRow(String label, String value, {int lines = 1}) {
    return pw.TableRow(
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(6),
          color: PdfColor.fromHex('#EEF4F1'),
          child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9)),
        ),
        _linedArea(value, lines: lines),
      ],
    );
  }

  /// Returns true only for image formats that package:pdf can decode
  /// directly from MemoryImage. Older records can contain arbitrary/legacy
  /// bytes in the signature column; those must not be handed to MemoryImage
  /// because it throws "Unable to guess the image type" while saving the PDF.
  static bool _isSupportedPdfImage(Uint8List bytes) {
    if (bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0D &&
        bytes[5] == 0x0A &&
        bytes[6] == 0x1A &&
        bytes[7] == 0x0A) {
      return true; // PNG
    }
    if (bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF) {
      return true; // JPEG
    }
    return false;
  }

  static pw.Widget _signature(String label, Uint8List? bytes) {
    final hasValidImage = bytes != null &&
        bytes.isNotEmpty &&
        _isSupportedPdfImage(bytes);

    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        if (hasValidImage)
          pw.Container(
            height: 58,
            width: 160,
            child: pw.Image(
              pw.MemoryImage(bytes!),
              fit: pw.BoxFit.contain,
            ),
          )
        else
          pw.SizedBox(height: 58),
        pw.SizedBox(height: 4),
        pw.Text(
          label,
          textAlign: pw.TextAlign.center,
          style: const pw.TextStyle(fontSize: 9),
        ),
        pw.SizedBox(height: 16),
      ],
    );
  }

  static pw.Widget _pdfSection(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 5, bottom: 4),
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#EAF4F0'),
        border: pw.Border(left: pw.BorderSide(color: PdfColor.fromHex('#145A4A'), width: 3)),
      ),
      child: pw.Text(
        title.toUpperCase(),
        style: pw.TextStyle(
          color: PdfColor.fromHex('#145A4A'),
          fontSize: 8.5,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  static pw.Widget _pdfField(
    String label,
    String value, {
    bool bold = false,
    int maxLines = 1,
    bool highlight = false,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: pw.BoxDecoration(
        color: highlight ? PdfColor.fromHex('#F3F8F5') : PdfColors.white,
        border: pw.Border.all(color: PdfColor.fromHex('#C9D8D2'), width: .55),
      ),
      child: pw.RichText(
        maxLines: maxLines,
        text: pw.TextSpan(
          children: [
            pw.TextSpan(
              text: '$label: ',
              style: pw.TextStyle(
                fontSize: 7,
                color: PdfColors.grey700,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.TextSpan(
              text: value.trim().isEmpty ? '—' : value.trim(),
              style: pw.TextStyle(
                fontSize: 8.5,
                fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _compactWritingField(String label, String value, {double height = 34}) {
    return pw.Container(
      height: height,
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColor.fromHex('#C9D8D2'), width: .55),
      ),
      child: pw.RichText(
        maxLines: 3,
        text: pw.TextSpan(
          children: [
            pw.TextSpan(
              text: '$label: ',
              style: pw.TextStyle(fontSize: 7, color: PdfColors.grey700, fontWeight: pw.FontWeight.bold),
            ),
            pw.TextSpan(
              text: value.trim().isEmpty ? '—' : value.trim(),
              style: const pw.TextStyle(fontSize: 8),
            ),
          ],
        ),
      ),
    );
  }

  static pw.Widget _receiptHeader(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.fromLTRB(10, 7, 10, 7),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#F7FBF9'),
        border: pw.Border.all(color: PdfColor.fromHex('#B9D8CD'), width: .8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Container(
            width: 46,
            height: 46,
            padding: const pw.EdgeInsets.all(2),
            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.circle,
              color: PdfColors.white,
              border: pw.Border.all(color: PdfColor.fromHex('#C9A44B'), width: 1.1),
            ),
            child: pw.Image(brandPdfLogo, fit: pw.BoxFit.contain),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            'AL-AMIN BAITUL MAAL',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              color: PdfColor.fromHex('#145A4A'),
              fontSize: 15,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            'Regd. No. 5767 • Dangerpora, Malla Bagh, Srinagar',
            textAlign: pw.TextAlign.center,
            style: const pw.TextStyle(fontSize: 7.2, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 5),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#145A4A'),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Text(
              title,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                color: PdfColors.white,
                fontSize: 10.5,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _metaRow(String numberLabel, String number, String date) {
    return pw.Row(
      children: [
        pw.Expanded(child: _pdfField(numberLabel, number, bold: true, highlight: true)),
        pw.SizedBox(width: 6),
        pw.Expanded(child: _pdfField('Date', date)),
      ],
    );
  }

  static pw.Widget _signatureLine(String label, Uint8List? bytes) {
    final valid = bytes != null && bytes.isNotEmpty && _isSupportedPdfImage(bytes);
    return pw.Expanded(
      child: pw.Column(
        children: [
          if (valid)
            pw.Container(height: 32, width: 115, child: pw.Image(pw.MemoryImage(bytes!), fit: pw.BoxFit.contain))
          else
            pw.SizedBox(height: 32),
          pw.Container(width: 150, height: 1, color: PdfColors.grey600),
          pw.SizedBox(height: 3),
          pw.Text(label, textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 7.2)),
        ],
      ),
    );
  }

  static pw.Widget _verifierBox(String label, String value) {
    return pw.Expanded(
      child: pw.Container(
        height: 45,
        padding: const pw.EdgeInsets.all(5),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColor.fromHex('#C9D8D2'), width: .55),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(label, textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 6.8, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
            pw.SizedBox(height: 4),
            pw.Text(value.trim().isEmpty ? '—' : value.trim(), maxLines: 1, textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 8)),
            pw.Spacer(),
            pw.Container(width: double.infinity, height: 1, color: PdfColors.grey500),
            pw.Text('Signature', style: const pw.TextStyle(fontSize: 5.8, color: PdfColors.grey700)),
          ],
        ),
      ),
    );
  }

  /// Kept for compatibility with the existing receipt/print callers.
  static pw.Document baseDocument({
    required String title,
    required String documentNumber,
    required String date,
    required List<pw.TableRow> rows,
    String? remarks,
    String footer = 'This document is generated from the saved accounting transaction.',
    String leftSignature = 'Authorized Signature: __________________',
    String rightSignature = 'Thank you',
    bool largeHeader = false,
  }) {
    final document = pw.Document();
    document.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            _receiptHeader(title),
            pw.SizedBox(height: 6),
            _metaRow('Document / Form No.', documentNumber, date),
            _pdfSection('Transaction Details'),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColor.fromHex('#C9D8D2'), width: .5),
              columnWidths: const {0: pw.FlexColumnWidth(1.25), 1: pw.FlexColumnWidth(2.75)},
              children: rows,
            ),
            if (remarks != null && remarks.trim().isNotEmpty) ...[
              pw.SizedBox(height: 5),
              _compactWritingField('Remarks', remarks, height: 42),
            ],
            pw.Spacer(),
            pw.Divider(color: PdfColor.fromHex('#C9D8D2')),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(leftSignature, style: const pw.TextStyle(fontSize: 7)),
                pw.Text(rightSignature, style: const pw.TextStyle(fontSize: 7)),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Text(footer, textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 6.5, color: PdfColors.grey700)),
          ],
        ),
      ),
    );
    return document;
  }

  static pw.Document ledgerDocument({required String title, required List<List<String>> rows, bool includeRemarks = true}) {
    final document = pw.Document();
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(18),
        build: (_) => [
          pdfBrandHeader(documentTitle: title, large: false),
          pw.Table(
            border: pw.TableBorder.all(width: .5),
            columnWidths: includeRemarks
                ? const {
                    0: pw.FixedColumnWidth(52), 1: pw.FixedColumnWidth(58), 2: pw.FixedColumnWidth(62), 3: pw.FixedColumnWidth(78),
                    4: pw.FlexColumnWidth(2.0), 5: pw.FixedColumnWidth(70), 6: pw.FixedColumnWidth(78), 7: pw.FixedColumnWidth(55),
                  }
                : const {
                    0: pw.FixedColumnWidth(58), 1: pw.FixedColumnWidth(62), 2: pw.FixedColumnWidth(68), 3: pw.FixedColumnWidth(82),
                    4: pw.FixedColumnWidth(78), 5: pw.FixedColumnWidth(82), 6: pw.FixedColumnWidth(58),
                  },
            children: [
              pw.TableRow(
                children: (includeRemarks
                        ? ['Date', 'Amount', 'Debit/Credit', 'Receipt No.', 'Remarks', 'Type', 'Running Balance', 'Username']
                        : ['Date', 'Amount', 'Debit/Credit', 'Receipt No.', 'Type', 'Running Balance', 'Username'])
                    .map((v) => pw.Container(
                          padding: const pw.EdgeInsets.all(4),
                          color: PdfColor.fromHex('#145A4A'),
                          child: pw.Text(v, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8)),
                        ))
                    .toList(),
              ),
              ...rows.map((row) => pw.TableRow(
                    children: row.map((v) => pw.Padding(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Text(v, style: const pw.TextStyle(fontSize: 7.5)),
                        )).toList(),
                  )),
            ],
          ),
        ],
      ),
    );
    return document;
  }

  static pw.Document qarzaVoucherDocument({
    required String documentNumber,
    required DateTime date,
    required String party,
    required String address,
    String parentage = '',
    required String aadhaar,
    required String phone,
    required double amount,
    required String chequeNumber,
    required String paymentMode,
    required String operation,
    String verification = '',
    String verifiedBy1 = '',
    String verifiedBy2 = '',
    String verifiedBy3 = '',
    required String remarks,
    Uint8List? recipientSignature,
    Uint8List? accountantSignature,
    String? preparedBy,
    String? conditions,
  }) {
    final document = pw.Document();
    final isIssue = operation.toUpperCase() == 'ISSUE';

    document.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(22),
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            _receiptHeader(isIssue ? 'QARZA — ISSUE VOUCHER' : 'QARZA — RECOVERY VOUCHER'),
            pw.SizedBox(height: 5),
            _metaRow('Voucher / Form No.', documentNumber, formatDate(date)),
            _pdfSection('Personal Details'),
            pw.Row(children: [
              pw.Expanded(flex: 2, child: _pdfField('Borrower Name', party, bold: true)),
              pw.SizedBox(width: 5),
              pw.Expanded(child: _pdfField('Parentage', parentage)),
              pw.SizedBox(width: 5),
              pw.Expanded(flex: 2, child: _pdfField('Address', address, maxLines: 1)),
            ]),
            pw.SizedBox(height: 5),
            pw.Row(children: [
              pw.Expanded(child: _pdfField('Aadhaar Card No.', aadhaar)),
              pw.SizedBox(width: 5),
              pw.Expanded(child: _pdfField('Phone Number', phone)),
              pw.SizedBox(width: 5),
              pw.Expanded(child: _pdfField('Cheque / Reference', chequeNumber)),
            ]),
            _pdfSection('Amount & Payment'),
            pw.Row(children: [
              pw.Expanded(flex: 2, child: _pdfField('Amount', '₹${amount.toStringAsFixed(2)}', bold: true, highlight: true)),
              pw.SizedBox(width: 5),
              pw.Expanded(flex: 4, child: _pdfField('Amount in Words', amountInWords(amount), bold: true)),
              pw.SizedBox(width: 5),
              pw.Expanded(flex: 2, child: _pdfField('Payment Mode', paymentMode)),
            ]),
            pw.SizedBox(height: 5),
            pw.Row(children: [
              pw.Expanded(child: _pdfField('Transaction', isIssue ? 'Qarza Issued' : 'Qarza Recovered')),
              pw.SizedBox(width: 5),
              pw.Expanded(child: _pdfField('Prepared By', preparedBy ?? '')),
            ]),
            if (isIssue) ...[
              _pdfSection('Verification'),
              pw.Row(children: [
                pw.Expanded(flex: 3, child: _compactWritingField('Verification Report', verification, height: 39)),
                pw.SizedBox(width: 5),
                _verifierBox('Verified by 1', verifiedBy1),
                pw.SizedBox(width: 4),
                _verifierBox('Verified by 2', verifiedBy2),
                pw.SizedBox(width: 4),
                _verifierBox('Verified by 3', verifiedBy3),
              ]),
              pw.SizedBox(height: 5),
              _compactWritingField('Conditions', conditions ?? '', height: 36),
            ],
            pw.SizedBox(height: 5),
            _compactWritingField('Remarks / Particulars', remarks, height: 36),
            _pdfSection('Signatures'),
            pw.Row(children: [
              _signatureLine('Borrower / Recipient Signature', recipientSignature),
              pw.SizedBox(width: 35),
              _signatureLine('Accountant Signature', accountantSignature),
            ]),
            pw.SizedBox(height: 3),
            pw.Text('Prepared by: ${(preparedBy ?? '').trim().isEmpty ? '—' : preparedBy!.trim()}', textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 6.8, color: PdfColors.grey700)),
          ],
        ),
      ),
    );
    return document;
  }

  static pw.Document zakaatVoucherDocument({
    required String voucherNumber,
    required DateTime date,
    required String recipientName,
    required String address,
    required String aadhaar,
    required String phone,
    required double amount,
    required String reason,
    required String authority,
    required String cheque,
    required String paymentMode,
    required String verification,
    required String verifiedBy1,
    required String verifiedBy2,
    required String verifiedBy3,
    required String remarks,
    Uint8List? recipientSignature,
    Uint8List? accountantSignature,
    String? preparedBy,
  }) {
    final document = pw.Document();
    document.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(22),
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            _receiptHeader('ZAKAAT — DISBURSEMENT VOUCHER'),
            pw.SizedBox(height: 5),
            _metaRow('Voucher / Form No.', voucherNumber, formatDate(date)),
            _pdfSection('Personal Details'),
            pw.Row(children: [
              pw.Expanded(flex: 2, child: _pdfField('Recipient Name', recipientName, bold: true)),
              pw.SizedBox(width: 5),
              pw.Expanded(flex: 3, child: _pdfField('Address', address, maxLines: 1)),
            ]),
            pw.SizedBox(height: 5),
            pw.Row(children: [
              pw.Expanded(child: _pdfField('Aadhaar Card No.', aadhaar)),
              pw.SizedBox(width: 5),
              pw.Expanded(child: _pdfField('Phone Number', phone)),
              pw.SizedBox(width: 5),
              pw.Expanded(child: _pdfField('Cheque / Reference', cheque)),
            ]),
            _pdfSection('Amount & Payment'),
            pw.Row(children: [
              pw.Expanded(flex: 2, child: _pdfField('Amount', '₹${amount.toStringAsFixed(2)}', bold: true, highlight: true)),
              pw.SizedBox(width: 5),
              pw.Expanded(flex: 4, child: _pdfField('Amount in Words', amountInWords(amount), bold: true)),
              pw.SizedBox(width: 5),
              pw.Expanded(flex: 2, child: _pdfField('Payment Mode', paymentMode)),
            ]),
            pw.SizedBox(height: 5),
            pw.Row(children: [
              pw.Expanded(flex: 3, child: _pdfField('Reason / Particulars', reason, maxLines: 1)),
              pw.SizedBox(width: 5),
              pw.Expanded(flex: 2, child: _pdfField('Issuing Authority / Report', authority, maxLines: 1)),
            ]),
            _pdfSection('Verification'),
            pw.Row(children: [
              pw.Expanded(flex: 3, child: _compactWritingField('Verification Report', verification, height: 39)),
              pw.SizedBox(width: 5),
              _verifierBox('Verified by 1', verifiedBy1),
              pw.SizedBox(width: 4),
              _verifierBox('Verified by 2', verifiedBy2),
              pw.SizedBox(width: 4),
              _verifierBox('Verified by 3', verifiedBy3),
            ]),
            pw.SizedBox(height: 5),
            _compactWritingField('Remarks / Particulars', remarks, height: 36),
            _pdfSection('Signatures'),
            pw.Row(children: [
              _signatureLine('Recipient Signature / Thumb Impression', recipientSignature),
              pw.SizedBox(width: 35),
              _signatureLine('Accountant Signature', accountantSignature),
            ]),
            pw.SizedBox(height: 3),
            pw.Text('Prepared by: ${(preparedBy ?? '').trim().isEmpty ? '—' : preparedBy!.trim()}', textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 6.8, color: PdfColors.grey700)),
          ],
        ),
      ),
    );
    return document;
  }

  static pw.Document qarzaWaiverVoucherDocument({
    required String waiverNumber,
    required DateTime date,
    required String borrowerName,
    required String originalQarzaNumber,
    required double amount,
    required String username,
    required String remarks,
  }) {
    final document = pw.Document();
    document.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(22),
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            _receiptHeader('QARZA WAIVER / ZAKAAT VOUCHER'),
            pw.SizedBox(height: 5),
            _metaRow('Waiver / Form No.', waiverNumber, formatDate(date)),
            _pdfSection('Personal Details'),
            pw.Row(children: [
              pw.Expanded(flex: 2, child: _pdfField('Borrower / Party', borrowerName, bold: true)),
              pw.SizedBox(width: 5),
              pw.Expanded(child: _pdfField('Original Qarza No.', originalQarzaNumber)),
              pw.SizedBox(width: 5),
              pw.Expanded(child: _pdfField('Prepared By', username)),
            ]),
            _pdfSection('Waiver Details'),
            pw.Row(children: [
              pw.Expanded(flex: 2, child: _pdfField('Waived Amount', '₹${amount.toStringAsFixed(2)}', bold: true, highlight: true)),
              pw.SizedBox(width: 5),
              pw.Expanded(flex: 4, child: _pdfField('Amount in Words', amountInWords(amount), bold: true)),
              pw.SizedBox(width: 5),
              pw.Expanded(child: _pdfField('Funding Source', 'Zakaat')),
            ]),
            pw.SizedBox(height: 5),
            _compactWritingField('Reason / Remarks', remarks, height: 55),
            pw.Spacer(),
            _pdfSection('Signatures'),
            pw.Row(children: [
              _signatureLine('Borrower / Recipient', null),
              pw.SizedBox(width: 35),
              _signatureLine('Authorized / Accountant', null),
            ]),
            pw.SizedBox(height: 3),
            pw.Text('Prepared by: ${username.trim().isEmpty ? '—' : username.trim()}', textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 6.8, color: PdfColors.grey700)),
          ],
        ),
      ),
    );
    return document;
  }

  static pw.Document fundAdjustmentVoucherDocument({
    required String title,
    required String documentNumber,
    required DateTime date,
    required String fundLabel,
    required String party,
    String? address,
    String? aadhaar,
    String? phone,
    required double amount,
    String? chequeNumber,
    required String paymentMode,
    String? verification,
    String? verifiedBy1,
    String? verifiedBy2,
    String? verifiedBy3,
    String? remarks,
    Uint8List? recipientSignature,
    Uint8List? accountantSignature,
    String? preparedBy,
  }) {
    final document = pw.Document();
    final needsVerification = (verification ?? '').trim().isNotEmpty ||
        (verifiedBy1 ?? '').trim().isNotEmpty ||
        (verifiedBy2 ?? '').trim().isNotEmpty ||
        (verifiedBy3 ?? '').trim().isNotEmpty;

    document.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(22),
        build: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            _receiptHeader(title.toUpperCase()),
            pw.SizedBox(height: 5),
            _metaRow('Document / Form No.', documentNumber, formatDate(date)),
            _pdfSection('Transaction Details'),
            pw.Row(children: [
              pw.Expanded(flex: 2, child: _pdfField('Particulars / Description', party, bold: true, maxLines: 1)),
              pw.SizedBox(width: 5),
              pw.Expanded(child: _pdfField('Fund / Account', fundLabel)),
              pw.SizedBox(width: 5),
              pw.Expanded(child: _pdfField('Cheque / Reference', chequeNumber ?? '')),
            ]),
            if ((address ?? '').trim().isNotEmpty || (aadhaar ?? '').trim().isNotEmpty || (phone ?? '').trim().isNotEmpty) ...[
              pw.SizedBox(height: 5),
              pw.Row(children: [
                if ((address ?? '').trim().isNotEmpty) pw.Expanded(flex: 2, child: _pdfField('Address', address!, maxLines: 1)),
                if ((address ?? '').trim().isNotEmpty) pw.SizedBox(width: 5),
                pw.Expanded(child: _pdfField('Aadhaar Card No.', (aadhaar ?? '').trim())),
                pw.SizedBox(width: 5),
                pw.Expanded(child: _pdfField('Phone Number', (phone ?? '').trim())),
              ]),
            ],
            _pdfSection('Amount & Payment'),
            pw.Row(children: [
              pw.Expanded(flex: 2, child: _pdfField('Amount', '₹${amount.toStringAsFixed(2)}', bold: true, highlight: true)),
              pw.SizedBox(width: 5),
              pw.Expanded(flex: 4, child: _pdfField('Amount in Words', amountInWords(amount), bold: true)),
              pw.SizedBox(width: 5),
              pw.Expanded(flex: 2, child: _pdfField('Payment Mode', paymentMode)),
            ]),
            if (needsVerification) ...[
              _pdfSection('Verification'),
              pw.Row(children: [
                pw.Expanded(flex: 3, child: _compactWritingField('Verification Report', verification ?? '', height: 39)),
                pw.SizedBox(width: 5),
                _verifierBox('Verified by 1', verifiedBy1 ?? ''),
                pw.SizedBox(width: 4),
                _verifierBox('Verified by 2', verifiedBy2 ?? ''),
                pw.SizedBox(width: 4),
                _verifierBox('Verified by 3', verifiedBy3 ?? ''),
              ]),
            ],
            pw.SizedBox(height: 5),
            _compactWritingField('Particulars / Remarks', remarks ?? '', height: 45),
            _pdfSection('Signatures'),
            pw.Row(children: [
              _signatureLine('Recipient / Party Signature', recipientSignature),
              pw.SizedBox(width: 35),
              _signatureLine('Accountant Signature', accountantSignature),
            ]),
            pw.SizedBox(height: 3),
            pw.Text('Prepared by: ${(preparedBy ?? '').trim().isEmpty ? '—' : preparedBy!.trim()}', textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 6.8, color: PdfColors.grey700)),
          ],
        ),
      ),
    );
    return document;
  }


}
