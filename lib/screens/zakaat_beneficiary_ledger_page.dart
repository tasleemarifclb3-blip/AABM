import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../database/workflow_service.dart';
import 'brand.dart';
import 'receipt_actions.dart';

class ZakaatBeneficiaryLedgerPage extends StatefulWidget {
  final AppDatabase database;
  final ZakaatBeneficiary beneficiary;
  const ZakaatBeneficiaryLedgerPage({super.key, required this.database, required this.beneficiary});

  @override
  State<ZakaatBeneficiaryLedgerPage> createState() => _ZakaatBeneficiaryLedgerPageState();
}

class _ZakaatBeneficiaryLedgerPageState extends State<ZakaatBeneficiaryLedgerPage> {
  late Future<List<ZakaatDisbursement>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<ZakaatDisbursement>> _load() async {
    final pending = await WorkflowService.pendingKeys(widget.database);
    final rows = await (widget.database.select(widget.database.zakaatDisbursements)
          ..where((d) => d.beneficiaryId.equals(widget.beneficiary.id))
          ..orderBy([(d) => OrderingTerm(expression: d.disbursementDate, mode: OrderingMode.desc)]))
        .get();
    return rows.where((r) => !pending.contains('zakaat_disbursements:${r.id}')).toList();
  }

  Future<void> _print(List<ZakaatDisbursement> rows) async {
    final table = rows.map((r) => [
          ReceiptActions.formatDate(r.disbursementDate),
          'INR ${r.amount.toStringAsFixed(2)}',
          'DEBIT',
          r.voucherNumber ?? '—',
          'Month: ${_month(r.disbursementDate)}; Cheque: ${r.chequeNumber ?? '—'}',
          'Zakaat',
          r.remarks ?? '—',
        ]).toList();
    final doc = ReceiptActions.ledgerDocument(title: '${widget.beneficiary.name} - Zakaat', rows: table);
    await ReceiptActions.printPdf(bytes: await doc.save(), fileName: 'Zakaat-${widget.beneficiary.name}.pdf');
  }

  Future<void> _share(List<ZakaatDisbursement> rows) async {
    final table = rows.map((r) => [
          ReceiptActions.formatDate(r.disbursementDate),
          'INR ${r.amount.toStringAsFixed(2)}',
          'DEBIT',
          r.voucherNumber ?? '—',
          'Month: ${_month(r.disbursementDate)}; Cheque: ${r.chequeNumber ?? '—'}',
          'Zakaat',
          r.remarks ?? '—',
        ]).toList();
    final doc = ReceiptActions.ledgerDocument(title: '${widget.beneficiary.name} - Zakaat', rows: table);
    await ReceiptActions.sharePdf(bytes: await doc.save(), fileName: 'Zakaat-${widget.beneficiary.name}.pdf', message: 'Al-Amin Baitul Maal - Zakaat beneficiary ledger for ${widget.beneficiary.name}');
  }

  String _month(DateTime d) => const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][d.month - 1];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zakaat Beneficiary Ledger')),
      body: FutureBuilder<List<ZakaatDisbursement>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          if (snap.hasError) return Center(child: Text('Could not load ledger:\n${snap.error}'));
          final rows = snap.data!;
          final total = rows.fold<double>(0, (s, r) => s + r.amount);
          return Column(children: [
            Padding(padding: const EdgeInsets.all(16), child: Column(children: [const BrandLogo(size: 60), const SizedBox(height: 6), Text(widget.beneficiary.name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kBrandGreen)), const SizedBox(height: 4), Text('Total Zakaat paid: ₹${total.toStringAsFixed(2)}')])) ,
            Expanded(child: rows.isEmpty ? const Center(child: Text('No monthly payments recorded.')) : SingleChildScrollView(scrollDirection: Axis.horizontal, child: SingleChildScrollView(child: DataTable(columns: const [DataColumn(label: Text('Month')), DataColumn(label: Text('Date')), DataColumn(label: Text('Amount')), DataColumn(label: Text('Cheque No.')), DataColumn(label: Text('Voucher No.')), DataColumn(label: Text('Remarks'))], rows: rows.map((r) => DataRow(cells: [DataCell(Text('${_month(r.disbursementDate)} ${r.disbursementDate.year}')), DataCell(Text(ReceiptActions.formatDate(r.disbursementDate))), DataCell(Text('₹${r.amount.toStringAsFixed(2)}')), DataCell(Text(r.chequeNumber ?? '—')), DataCell(Text(r.voucherNumber ?? '—')), DataCell(Text(r.remarks ?? '—'))])).toList())))),
          ]);
        },
      ),
      floatingActionButton: FutureBuilder<List<ZakaatDisbursement>>(future: _future, builder: (context, snap) => snap.hasData ? Row(mainAxisSize: MainAxisSize.min, children: [FloatingActionButton.small(heroTag: 'zk-print', onPressed: () => _print(snap.data!), child: const Icon(Icons.print)), const SizedBox(width: 8), FloatingActionButton.small(heroTag: 'zk-share', onPressed: () => _share(snap.data!), child: const Icon(Icons.share))]) : const SizedBox.shrink()),
    );
  }
}
