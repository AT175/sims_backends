import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/app_models.dart';
import '../../core/state/bursary_provider.dart';
import '../../core/state/bursar_provider.dart' as bursar;
import '../../core/state/kitchen_provider.dart';
import '../../core/widgets/widgets.dart';

String _fmtGH(double n) => 'GH\u20B5${n.toStringAsFixed(0)}';
String _today() => DateTime.now().toIso8601String().substring(0, 10);

const _paymentMethods = ['Cash', 'Bank Transfer', 'Mobile Money', 'Cheque', 'Card'];
const _expenditureCategories = ['Utilities', 'Stores', 'Repairs', 'Salaries', 'Transport', 'Equipment', 'Capital', 'Misc'];

Widget _chip(String text, Color color) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
  child: Text(text, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
);

Widget _actionBtn(BuildContext context, String label, VoidCallback onPressed) => SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2)),
    onPressed: onPressed,
    child: Text(label, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600)),
  ),
);

Widget _pickerChips(String label, String selected, List<String> options, ValueChanged<String> onSelected) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(label, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
    const SizedBox(height: AppSpacing.xs),
    Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: options.map((o) => GestureDetector(
      onTap: () => onSelected(o),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: selected == o ? AppColors.primary : Colors.transparent,
          border: Border.all(color: selected == o ? AppColors.primary : AppColors.border),
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Text(o, style: TextStyle(fontSize: AppFontSize.sm, color: selected == o ? Colors.white : AppColors.textSecondary, fontWeight: selected == o ? FontWeight.w600 : FontWeight.normal)),
      ),
    )).toList()),
  ],
);

Widget _formField(String label, TextEditingController ctrl, {String? hint, TextInputType? keyboardType, bool multiline = false}) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(label, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
    const SizedBox(height: AppSpacing.xs),
    TextField(
      controller: ctrl, keyboardType: keyboardType, maxLines: multiline ? 3 : 1,
      decoration: InputDecoration(hintText: hint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md))),
    ),
  ],
);

void _showFormModal(BuildContext context, String title, Widget formContent, VoidCallback onSubmit, {String submitLabel = 'Submit'}) {
  showModalBottomSheet(
    context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg))),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(title, style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
              GestureDetector(onTap: () => Navigator.pop(ctx), child: Icon(Icons.close, color: AppColors.textLight)),
            ]),
            const SizedBox(height: AppSpacing.md),
            formContent,
            const SizedBox(height: AppSpacing.lg),
            Row(children: [
              Expanded(child: TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel'))),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                onPressed: () { onSubmit(); Navigator.pop(ctx); },
                child: Text(submitLabel),
              )),
            ]),
          ]),
        ),
      ),
    ),
  );
}

Widget _alertCard(String title, String subtitle, Color color) => Container(
  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
  padding: const EdgeInsets.all(AppSpacing.md),
  decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: color, width: 4))),
  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: color)),
    Text(subtitle, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
  ]),
);

/// Accountant dashboard — 10 pages.
class AccountantDashboard extends StatelessWidget {
  final String pageKey;

  const AccountantDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview':
        return _OverviewPage();
      case 'fees':
        return _FeesPage();
      case 'invoices':
        return _InvoicesPage();
      case 'payroll':
        return _PayrollPage();
      case 'expenditure':
        return _ExpenditurePage();
      case 'budgetSubmissions':
        return _BudgetSubmissionsPage();
      case 'budget':
        return _BudgetPage();
      case 'kitchenFinance':
        return _KitchenFinancePage();
      case 'returnsApproval':
        return _ReturnsApprovalPage();
      case 'reports':
        return _ReportsPage();
      default:
        return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

class _OverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final b = context.watch<BursaryProvider>();
    final bs = context.watch<bursar.BursarProvider>();
    final ks = context.watch<KitchenProvider>();
    final overdue = b.overdueInvoices;
    final pendingSubs = b.pendingBudgetSubmissions;
    final pendingReqs = ks.financialReqs.where((r) => r.status == 'Pending').toList();
    final submittedReturns = bs.returns.where((r) => r.status == 'Submitted').toList();

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Fees Collected', value: _fmtGH(b.totalCollected), icon: Icons.payments, color: AppColors.success),
          StatCard(label: 'Outstanding', value: _fmtGH(b.totalOutstanding), icon: Icons.money_off, color: AppColors.danger),
          StatCard(label: 'Payroll (Net)', value: _fmtGH(b.totalPayrollNet), icon: Icons.people, color: AppColors.primaryLight),
          StatCard(label: 'Expenditure', value: _fmtGH(b.totalExpenditure), icon: Icons.shopping_cart, color: AppColors.warning),
          StatCard(label: 'Budget Remaining', value: _fmtGH(b.totalBudgetRemaining), icon: Icons.savings, color: AppColors.info),
          StatCard(label: 'Overdue Invoices', value: '${overdue.length}', icon: Icons.receipt_long, color: AppColors.danger),
          StatCard(label: 'Pending Budget Subs', value: '${pendingSubs.length}', icon: Icons.pending_actions, color: AppColors.accent),
          StatCard(label: 'Kitchen Pending', value: _fmtGH(pendingReqs.fold(0.0, (s, r) => s + r.amount)), icon: Icons.restaurant, color: AppColors.warning),
          StatCard(label: 'Returns to Approve', value: '${submittedReturns.length}', icon: Icons.assignment_turned_in, color: AppColors.primary),
        ]),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(title: 'Recent Expenditure', child: AppDataTable(
          columns: ['Date', 'Description', 'Category', 'Amount', 'Vendor'],
          rows: b.expenditure.take(5).map((e) => [
            Text(e.date), Text(e.description), Text(e.category.name),
            Text(_fmtGH(e.amount)), Text(e.vendor),
          ]).toList(),
        )),
        if (overdue.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Overdue Invoices', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
          const SizedBox(height: AppSpacing.sm),
          ...overdue.map((inv) => _alertCard(
            '${inv.invoiceNo} \u2014 ${inv.studentName}',
            '${inv.className} \u2014 Guardian: ${inv.guardianName} \u2014 Balance: ${_fmtGH(inv.balance)}',
            AppColors.danger,
          )),
        ],
        if (pendingSubs.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Budget Submissions Awaiting Action', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
          const SizedBox(height: AppSpacing.sm),
          ...pendingSubs.map((s) => _alertCard(
            '${s.department} \u2014 ${_fmtGH(s.totalRequested)}',
            'Submitted by: ${s.submittedBy} \u2014 Supervisor: ${s.supervisorName}',
            AppColors.warning,
          )),
        ],
        if (pendingReqs.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Kitchen Financial Requests', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
          const SizedBox(height: AppSpacing.sm),
          ...pendingReqs.map((r) => _alertCard(
            '${_fmtGH(r.amount)} \u2014 ${r.purpose}',
            'Requested by: ${r.requestedBy}',
            AppColors.warning,
          )),
        ],
        if (submittedReturns.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Returns Awaiting Approval', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
          const SizedBox(height: AppSpacing.sm),
          ...submittedReturns.map((r) => _alertCard(
            '${r.period} Return \u2014 ${r.dateFrom} to ${r.dateTo}',
            'Net: ${_fmtGH(r.netBalance)} \u2014 Submitted by: ${r.submittedBy}',
            AppColors.primary,
          )),
        ],
      ]),
    );
  }
}

class _FeesPage extends StatefulWidget {
  @override
  State<_FeesPage> createState() => _FeesPageState();
}

class _FeesPageState extends State<_FeesPage> {
  String _search = '';
  String _filterStatus = 'All';

  @override
  Widget build(BuildContext context) {
    final b = context.watch<BursaryProvider>();
    final q = _search.toLowerCase().trim();
    final filtered = b.fees.where((f) {
      final matchesSearch = q.isEmpty ||
        f.studentName.toLowerCase().contains(q) ||
        f.admNo.toLowerCase().contains(q) ||
        f.className.toLowerCase().contains(q);
      final matchesStatus = _filterStatus == 'All' || f.status.name == _filterStatus;
      return matchesSearch && matchesStatus;
    }).toList();

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Collected', value: _fmtGH(b.totalCollected), icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Outstanding', value: _fmtGH(b.totalOutstanding), icon: Icons.money_off, color: AppColors.danger),
          StatCard(label: 'Fee Records', value: '${b.fees.length}', icon: Icons.receipt, color: AppColors.info),
          StatCard(label: 'Receipts', value: '${b.receipts.length}', icon: Icons.receipt_long, color: AppColors.primary),
        ]),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          onChanged: (v) => setState(() => _search = v),
          decoration: InputDecoration(
            hintText: 'Search by name, adm no, class...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: ['All', 'Cleared', 'Partial', 'Owing'].map((s) => GestureDetector(
          onTap: () => setState(() => _filterStatus = s),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: _filterStatus == s ? AppColors.primary : Colors.transparent,
              border: Border.all(color: _filterStatus == s ? AppColors.primary : AppColors.border),
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(s, style: TextStyle(fontSize: AppFontSize.sm, color: _filterStatus == s ? Colors.white : AppColors.textSecondary, fontWeight: _filterStatus == s ? FontWeight.w600 : FontWeight.normal)),
          ),
        )).toList()),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(title: 'Fee / Capitation Ledger', child: AppDataTable(
          columns: ['Student', 'Adm No', 'Fee Type', 'Due', 'Paid', 'Balance', 'Status'],
          rows: filtered.map((f) => [
            Text(f.studentName), Text(f.admNo), Text(f.feeType),
            Text(_fmtGH(f.amountDue)), Text(_fmtGH(f.amountPaid)),
            Text(_fmtGH(f.balance)), _feeStatus(f.status),
          ]).toList(),
        )),
        if (filtered.any((f) => f.balance > 0)) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Quick Payment', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
          const SizedBox(height: AppSpacing.sm),
          ...filtered.where((f) => f.balance > 0).map((f) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${f.studentName} \u2014 ${f.admNo}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                Text('Balance: ${_fmtGH(f.balance)}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger)),
              ])),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                onPressed: () => _showPayModal(context, f, b),
                child: Text('Record Payment'),
              ),
            ]),
          )),
        ],
        if (b.receipts.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Payment Receipts', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
          const SizedBox(height: AppSpacing.sm),
          ...b.receipts.map((r) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r.receiptNo, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.bold, color: AppColors.primary)),
                Text('${r.studentName} \u2014 ${r.date}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                Text('${_fmtGH(r.amount)} via ${r.method}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.success)),
                if (r.notes.isNotEmpty) Text(r.notes, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
              ])),
              Text('Received by ${r.receivedBy}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
            ]),
          )),
        ],
      ]),
    );
  }

  void _showPayModal(BuildContext context, FeeRecord fee, BursaryProvider b) {
    String method = _paymentMethods[0];
    final amtCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    _showFormModal(context, 'Record Payment \u2014 ${fee.studentName}', StatefulBuilder(
      builder: (ctx, setState) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${fee.studentName} \u2014 ${fee.admNo}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
        Text('${fee.feeType} \u2014 ${fee.term}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
        Text('Due: ${_fmtGH(fee.amountDue)} | Paid: ${_fmtGH(fee.amountPaid)} | Balance: ${_fmtGH(fee.balance)}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Amount (GH\u20B5)', amtCtrl, hint: '${fee.balance.toStringAsFixed(0)}', keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Payment Method', method, _paymentMethods, (v) => setState(() => method = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Notes', notesCtrl, hint: 'Optional', multiline: true),
      ]),
    ), () {
      final amt = double.tryParse(amtCtrl.text);
      if (amt == null || amt <= 0) return;
      b.recordPayment(fee.id, amt, method, 'Accountant', notesCtrl.text);
    }, submitLabel: 'Record Payment');
  }

  Widget _feeStatus(FeeStatus s) {
    final color = s == FeeStatus.cleared ? AppColors.success : s == FeeStatus.partial ? AppColors.warning : AppColors.danger;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Text(s.name, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _InvoicesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final b = context.watch<BursaryProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Invoices', value: '${b.invoices.length}', icon: Icons.description, color: AppColors.info),
          StatCard(label: 'Overdue', value: '${b.overdueInvoiceCount}', icon: Icons.warning, color: AppColors.danger),
          StatCard(label: 'Total Billed', value: _fmtGH(b.invoices.fold(0.0, (s, i) => s + i.totalAmount)), icon: Icons.receipt, color: AppColors.primary),
          StatCard(label: 'Outstanding', value: _fmtGH(b.invoices.fold(0.0, (s, i) => s + i.balance)), icon: Icons.money_off, color: AppColors.warning),
        ]),
        const SizedBox(height: AppSpacing.lg),
        ...b.invoices.map((inv) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(inv.invoiceNo, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.primary)),
              _invStatus(inv.status),
            ]),
            const SizedBox(height: AppSpacing.xs),
            Text(inv.studentName, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
            Text('${inv.className} \u2014 ${inv.term}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            Text('Guardian: ${inv.guardianName}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            if (inv.items.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(padding: const EdgeInsets.only(top: AppSpacing.sm), decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
                child: Column(children: inv.items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(item.description, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.text)),
                    Text(_fmtGH(item.amount), style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.text, fontWeight: FontWeight.w500)),
                  ]),
                )).toList()),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Total: ${_fmtGH(inv.totalAmount)}', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.bold, color: AppColors.text)),
              Text('Paid: ${_fmtGH(inv.amountPaid)}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.success, fontWeight: FontWeight.w600)),
              Text('Balance: ${_fmtGH(inv.balance)}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.bold)),
            ]),
            Text('Issued: ${inv.dateIssued} \u2014 Due: ${inv.dueDate}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
            if (inv.status != InvoiceStatus.cancelled && inv.status != InvoiceStatus.paid) ...[
              const SizedBox(height: AppSpacing.sm),
              SizedBox(width: double.infinity, child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white),
                onPressed: () => b.cancelInvoice(inv.id),
                child: Text('Cancel Invoice'),
              )),
            ],
          ]),
        )),
      ]),
    );
  }

  Widget _invStatus(InvoiceStatus s) {
    final color = s == InvoiceStatus.paid ? AppColors.success : s == InvoiceStatus.overdue ? AppColors.danger : s == InvoiceStatus.cancelled ? AppColors.textLight : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Text(s.name, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _PayrollPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final b = context.watch<BursaryProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Gross Total', value: _fmtGH(b.totalPayrollGross), icon: Icons.attach_money, color: AppColors.primaryLight),
          StatCard(label: 'Deductions', value: _fmtGH(b.totalPayrollDeductions), icon: Icons.remove_circle, color: AppColors.danger),
          StatCard(label: 'Net Total', value: _fmtGH(b.totalPayrollNet), icon: Icons.savings, color: AppColors.success),
          StatCard(label: 'Pending', value: '${b.payroll.where((p) => p.status == PayrollStatus.pending).length}', icon: Icons.pending, color: AppColors.warning),
        ]),
        const SizedBox(height: AppSpacing.lg),
        ...b.payroll.map((p) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p.staffName, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                Text('${p.position} \u2014 ${p.department}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              ])),
              _payStatus(p.status),
            ]),
            const SizedBox(height: AppSpacing.sm),
            Row(children: [
              Expanded(child: _payCol('Gross', _fmtGH(p.grossSalary))),
              Expanded(child: _payCol('SSF', _fmtGH(p.ssfContribution))),
              Expanded(child: _payCol('Tax', _fmtGH(p.taxDeduction))),
              Expanded(child: _payCol('Net', _fmtGH(p.netSalary), highlight: true)),
            ]),
            if (p.status == PayrollStatus.pending) ...[
              const SizedBox(height: AppSpacing.sm),
              SizedBox(width: double.infinity, child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.info, foregroundColor: Colors.white),
                onPressed: () => b.processPayroll(p.id),
                child: Text('Process Payroll'),
              )),
            ],
            if (p.status == PayrollStatus.processed) ...[
              const SizedBox(height: AppSpacing.sm),
              Text('Awaiting Bursar payment', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
            ],
          ]),
        )),
      ]),
    );
  }

  Widget _payCol(String label, String value, {bool highlight = false}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
      Text(value, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: highlight ? AppColors.success : AppColors.text)),
    ],
  );

  Widget _payStatus(PayrollStatus s) {
    final color = s == PayrollStatus.paid ? AppColors.success : s == PayrollStatus.processed ? AppColors.info : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Text(s.name, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _ExpenditurePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final b = context.watch<BursaryProvider>();
    final byCategory = b.getExpenditureByCategory();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Expenditure', value: _fmtGH(b.totalExpenditure), icon: Icons.shopping_cart, color: AppColors.warning),
          StatCard(label: 'Entries', value: '${b.expenditure.length}', icon: Icons.list, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Record Expenditure', () => _showExpenditureModal(context, b)),
        const SizedBox(height: AppSpacing.lg),
        Text('By Category', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        ...byCategory.map((c) {
          final pct = b.totalExpenditure > 0 ? ((c['total'] as double) / b.totalExpenditure * 100).round() : 0;
          final catColor = _catColor(c['category'] as String);
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(children: [
              SizedBox(width: 100, child: Text(c['category'] as String, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary))),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Container(height: 12, decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.sm)), child: FractionallySizedBox(
                alignment: Alignment.centerLeft, widthFactor: pct / 100,
                child: Container(decoration: BoxDecoration(color: catColor, borderRadius: BorderRadius.circular(AppRadius.sm))),
              ))),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(width: 70, child: Text(_fmtGH(c['total'] as double), textAlign: TextAlign.right, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.text))),
            ]),
          );
        }),
        const SizedBox(height: AppSpacing.lg),
        Text('All Expenditure', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        ...b.expenditure.map((e) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(e.description, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
              Text('${e.date} \u2014 ${e.vendor} \u2014 ${e.paymentMethod}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              Text('Authorized by: ${e.authorizedBy}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
              if (e.notes.isNotEmpty) Text(e.notes, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight, fontStyle: FontStyle.italic)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(_fmtGH(e.amount), style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.danger)),
              _chip(e.category.name[0].toUpperCase() + e.category.name.substring(1), _catColor(e.category.name[0].toUpperCase() + e.category.name.substring(1))),
            ]),
          ]),
        )),
      ]),
    );
  }

  Color _catColor(String c) {
    switch (c) {
      case 'Utilities': return AppColors.info;
      case 'Salaries': return AppColors.success;
      case 'Repairs': return AppColors.warning;
      case 'Equipment': return AppColors.primary;
      case 'Capital': return AppColors.accent;
      default: return AppColors.textSecondary;
    }
  }

  void _showExpenditureModal(BuildContext context, BursaryProvider b) {
    String category = _expenditureCategories[0];
    String method = _paymentMethods[0];
    final descCtrl = TextEditingController();
    final amtCtrl = TextEditingController();
    final vendorCtrl = TextEditingController();
    final authCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    _showFormModal(context, 'Record Expenditure', StatefulBuilder(
      builder: (ctx, setState) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _pickerChips('Category', category, _expenditureCategories, (v) => setState(() => category = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Description', descCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Amount (GH\u20B5)', amtCtrl, keyboardType: TextInputType.number, hint: '500'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Vendor / Payee', vendorCtrl),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Payment Method', method, _paymentMethods, (v) => setState(() => method = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Authorized By', authCtrl, hint: 'Headmaster'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Notes', notesCtrl, multiline: true),
      ]),
    ), () {
      final amt = double.tryParse(amtCtrl.text);
      if (amt == null || amt <= 0 || descCtrl.text.isEmpty || vendorCtrl.text.isEmpty) return;
      b.recordExpenditure(
        category: category, description: descCtrl.text, amount: amt,
        vendor: vendorCtrl.text, paymentMethod: method,
        authorizedBy: authCtrl.text.isEmpty ? 'Accountant' : authCtrl.text,
        notes: notesCtrl.text,
      );
    }, submitLabel: 'Record');
  }
}

class _BudgetSubmissionsPage extends StatefulWidget {
  @override
  State<_BudgetSubmissionsPage> createState() => _BudgetSubmissionsPageState();
}

class _BudgetSubmissionsPageState extends State<_BudgetSubmissionsPage> {
  String? _expanded;

  @override
  Widget build(BuildContext context) {
    final b = context.watch<BursaryProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ...b.budgetSubmissions.map((s) {
          final expanded = _expanded == s.id;
          final canAct = s.status == 'Pending Accountant' || s.status == 'Supervisor Approved';
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              GestureDetector(
                onTap: () => setState(() => _expanded = expanded ? null : s.id),
                child: Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(s.department, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.text)),
                    Text('Submitted by: ${s.submittedBy}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                    Text('Supervisor: ${s.supervisorName}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                    Text('Date: ${s.dateSubmitted}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                    Text('Total Requested: ${_fmtGH(s.totalRequested)}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    _subStatus(s.status),
                    Text(expanded ? '\u2212' : '+', style: TextStyle(fontSize: AppFontSize.xl, color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ]),
                ]),
              ),
              if (expanded) ...[
                const SizedBox(height: AppSpacing.md),
                Container(padding: const EdgeInsets.only(top: AppSpacing.md), decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Justification:', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.text)),
                    Text(s.justification, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Requested Items:', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.text)),
                    ...s.items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(children: [
                        Expanded(child: Text(item.description, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.text))),
                        Text('${item.quantity} \u00D7 ${_fmtGH(item.unitCost)}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                        const SizedBox(width: AppSpacing.sm),
                        Text(_fmtGH(item.total), style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.text)),
                      ]),
                    )),
                    if (s.supervisorNotes.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text('Supervisor Notes:', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.text)),
                      Text(s.supervisorNotes, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                    ],
                    if (s.accountantNotes.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text('Accountant Notes:', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.text)),
                      Text(s.accountantNotes, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                    ],
                    if (canAct) ...[
                      const SizedBox(height: AppSpacing.md),
                      Row(children: [
                        Expanded(child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
                          onPressed: () => _showReviewModal(context, b, s.id, s.department, _fmtGH(s.totalRequested), true),
                          child: Text('Approve'),
                        )),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white),
                          onPressed: () => _showReviewModal(context, b, s.id, s.department, _fmtGH(s.totalRequested), false),
                          child: Text('Reject'),
                        )),
                      ]),
                    ],
                  ]),
                ),
              ],
            ]),
          );
        }),
      ]),
    );
  }

  Widget _subStatus(String s) {
    final color = s == 'Accountant Approved' ? AppColors.success : s == 'Rejected' ? AppColors.danger : s == 'Supervisor Approved' ? AppColors.info : s == 'Pending Accountant' ? AppColors.warning : AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Text(s, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
    );
  }

  void _showReviewModal(BuildContext context, BursaryProvider b, String id, String dept, String amount, bool approve) {
    final notesCtrl = TextEditingController();
    _showFormModal(context, approve ? 'Approve Budget Submission' : 'Reject Budget Submission', Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$dept \u2014 $amount', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Notes', notesCtrl, hint: approve ? 'Approval notes...' : 'Reason for rejection...', multiline: true),
      ],
    ), () {
      if (approve) {
        b.approveBudgetSubmissionAccountant(id, notesCtrl.text);
      } else {
        b.rejectBudgetSubmission(id, notesCtrl.text);
      }
    }, submitLabel: approve ? 'Approve' : 'Reject');
  }
}

class _BudgetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final b = context.watch<BursaryProvider>();
    final utilPct = b.totalBudgetAllocated > 0 ? (b.totalBudgetSpent / b.totalBudgetAllocated * 100).round() : 0;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Allocated', value: _fmtGH(b.totalBudgetAllocated), icon: Icons.account_balance, color: AppColors.primary),
          StatCard(label: 'Total Spent', value: _fmtGH(b.totalBudgetSpent), icon: Icons.trending_down, color: AppColors.warning),
          StatCard(label: 'Total Remaining', value: _fmtGH(b.totalBudgetRemaining), icon: Icons.savings, color: AppColors.success),
          StatCard(label: 'Utilization', value: '$utilPct%', icon: Icons.pie_chart, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        ...b.budgetItems.map((item) {
          final pct = item.allocated > 0 ? (item.spent / item.allocated * 100).round() : 0;
          final barColor = pct > 80 ? AppColors.danger : pct > 50 ? AppColors.warning : AppColors.success;
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(item.department, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                _chip(item.status.name, item.status == BudgetStatus.active ? AppColors.success : AppColors.warning),
              ]),
              if (item.notes.isNotEmpty)
                Text(item.notes, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.sm),
              Row(children: [
                Expanded(child: Container(height: 10, decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.sm)), child: FractionallySizedBox(
                  alignment: Alignment.centerLeft, widthFactor: pct / 100,
                  child: Container(decoration: BoxDecoration(color: barColor, borderRadius: BorderRadius.circular(AppRadius.sm))),
                ))),
                const SizedBox(width: AppSpacing.sm),
                Text('$pct%', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.text)),
              ]),
              const SizedBox(height: AppSpacing.sm),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Allocated: ${_fmtGH(item.allocated)}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                Text('Spent: ${_fmtGH(item.spent)}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.warning, fontWeight: FontWeight.w600)),
                Text('Remaining: ${_fmtGH(item.remaining)}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.success, fontWeight: FontWeight.w600)),
              ]),
            ]),
          );
        }),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, 'Submit for Board Approval', () {}),
      ]),
    );
  }
}

class _KitchenFinancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ks = context.watch<KitchenProvider>();
    final pendingReqs = ks.financialReqs.where((r) => r.status == 'Pending').toList();
    final totalPending = pendingReqs.fold(0.0, (s, r) => s + r.amount);
    final totalDisbursed = ks.financialReqs.where((r) => r.status == 'Disbursed').fold(0.0, (s, r) => s + r.amount);
    final totalApproved = ks.financialReqs.where((r) => r.status == 'Approved').fold(0.0, (s, r) => s + r.amount);

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Pending', value: '${pendingReqs.length}', icon: Icons.pending, color: AppColors.warning),
          StatCard(label: 'Pending Amount', value: _fmtGH(totalPending), icon: Icons.attach_money, color: AppColors.primary),
          StatCard(label: 'Approved', value: _fmtGH(totalApproved), icon: Icons.check_circle, color: AppColors.info),
          StatCard(label: 'Disbursed', value: _fmtGH(totalDisbursed), icon: Icons.paid, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        if (pendingReqs.isNotEmpty)
          _alertCard('\u26A0 ${pendingReqs.length} Pending Request${pendingReqs.length > 1 ? 's' : ''}', '${_fmtGH(totalPending)} awaiting your approval from the Kitchen.', AppColors.warning),
        const SizedBox(height: AppSpacing.md),
        Text('Kitchen Financial Requests', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        if (ks.financialReqs.isEmpty)
          Text('No kitchen financial requests.', style: TextStyle(color: AppColors.textSecondary))
        else
          ...ks.financialReqs.map((r) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_fmtGH(r.amount), style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  Text('${r.date} | ${r.purpose}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  Text('Requested by: ${r.requestedBy}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
                  if (r.notes.isNotEmpty) Text(r.notes, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight, fontStyle: FontStyle.italic)),
                ])),
                _finStatus(r.status),
              ]),
              if (r.status == 'Pending') ...[
                const SizedBox(height: AppSpacing.md),
                Row(children: [
                  Expanded(child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
                    onPressed: () => ks.updateFinancialReqStatus(r.id, 'Approved'),
                    child: Text('Approve'),
                  )),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white),
                    onPressed: () => ks.updateFinancialReqStatus(r.id, 'Rejected'),
                    child: Text('Reject'),
                  )),
                ]),
              ],
              if (r.status == 'Approved') ...[
                const SizedBox(height: AppSpacing.sm),
                Text('Awaiting Bursar disbursement', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
              ],
            ]),
          )),
        const SizedBox(height: AppSpacing.lg),
        Text('Kitchen Stock Issues', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        SectionCard(title: 'Issued Items', child: AppDataTable(
          columns: ['Date', 'Item', 'Qty', 'Issued To', 'Purpose'],
          rows: ks.issues.map((i) => [
            Text(i.date), Text(i.itemName), Text('${i.quantity} ${i.unit}'),
            Text(i.issuedTo), Text(i.purpose),
          ]).toList(),
        )),
      ]),
    );
  }

  Widget _finStatus(String s) {
    final color = s == 'Disbursed' ? AppColors.success : s == 'Approved' ? AppColors.info : s == 'Rejected' ? AppColors.danger : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Text(s, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _ReturnsApprovalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bs = context.watch<bursar.BursarProvider>();
    final submitted = bs.returns.where((r) => r.status == 'Submitted').toList();
    final approved = bs.returns.where((r) => r.status == 'Approved').toList();
    final rejected = bs.returns.where((r) => r.status == 'Rejected').toList();

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Submitted', value: '${submitted.length}', icon: Icons.inbox, color: AppColors.warning),
          StatCard(label: 'Approved', value: '${approved.length}', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Rejected', value: '${rejected.length}', icon: Icons.cancel, color: AppColors.danger),
        ]),
        const SizedBox(height: AppSpacing.lg),
        if (submitted.isNotEmpty)
          _alertCard('\u26A0 ${submitted.length} Return${submitted.length > 1 ? 's' : ''} Awaiting Approval', 'The Bursar has submitted returns that need your review.', AppColors.warning),
        const SizedBox(height: AppSpacing.md),
        if (bs.returns.isEmpty)
          Text('No bursary returns submitted.', style: TextStyle(color: AppColors.textSecondary))
        else
          ...bs.returns.map((r) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${r.period} Return \u2014 ${r.dateFrom} to ${r.dateTo}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.text)),
                  Text('Income: ${_fmtGH(r.totalIncome)} \u2014 Expense: ${_fmtGH(r.totalExpense)}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  Text('Net: ${_fmtGH(r.netBalance)}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: r.netBalance >= 0 ? AppColors.success : AppColors.danger)),
                  Text('Submitted by: ${r.submittedBy}${r.dateSubmitted.isNotEmpty ? ' on ${r.dateSubmitted}' : ''}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
                  if (r.approvedBy != null) Text('Approved by: ${r.approvedBy}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
                  if (r.notes.isNotEmpty) Text(r.notes, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight, fontStyle: FontStyle.italic)),
                ])),
                _retStatus(r.status),
              ]),
              if (r.status == 'Submitted') ...[
                const SizedBox(height: AppSpacing.md),
                Row(children: [
                  Expanded(child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
                    onPressed: () => bs.approveReturn(r.id, 'Accountant'),
                    child: Text('Approve'),
                  )),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white),
                    onPressed: () => bs.rejectReturn(r.id),
                    child: Text('Reject'),
                  )),
                ]),
              ],
            ]),
          )),
      ]),
    );
  }

  Widget _retStatus(String s) {
    final color = s == 'Approved' ? AppColors.success : s == 'Rejected' ? AppColors.danger : s == 'Submitted' ? AppColors.info : AppColors.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Text(s, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _ReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final b = context.watch<BursaryProvider>();
    final feeTotal = b.totalCollected + b.totalOutstanding;
    final collectedPct = feeTotal > 0 ? (b.totalCollected / feeTotal * 100).round() : 0;
    final outstandingPct = feeTotal > 0 ? (b.totalOutstanding / feeTotal * 100).round() : 0;
    final budgetUsedPct = b.totalBudgetAllocated > 0 ? (b.totalBudgetSpent / b.totalBudgetAllocated * 100).round() : 0;
    final budgetRemainingPct = b.totalBudgetAllocated > 0 ? (b.totalBudgetRemaining / b.totalBudgetAllocated * 100).round() : 0;

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Fees Collected', value: _fmtGH(b.totalCollected), icon: Icons.payments, color: AppColors.success),
          StatCard(label: 'Expenditure', value: _fmtGH(b.totalExpenditure), icon: Icons.shopping_cart, color: AppColors.danger),
          StatCard(label: 'Payroll (Net)', value: _fmtGH(b.totalPayrollNet), icon: Icons.people, color: AppColors.primary),
          StatCard(label: 'Budget Remaining', value: _fmtGH(b.totalBudgetRemaining), icon: Icons.savings, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, 'Generate Full Financial Report', () {}),
        const SizedBox(height: AppSpacing.md),
        Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
          _reportBtn('Fee Collection', AppColors.success),
          _reportBtn('Payroll Summary', AppColors.info),
          _reportBtn('Expenditure Report', AppColors.warning),
          _reportBtn('Budget vs Actual', AppColors.primary),
          _reportBtn('Invoice Report', AppColors.danger),
          _reportBtn('Budget Submissions', AppColors.accent),
        ]),
        const SizedBox(height: AppSpacing.lg),
        Text('Fee Collection', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
          child: Column(children: [
            _reportBar('Collected', collectedPct, AppColors.success, _fmtGH(b.totalCollected)),
            const SizedBox(height: AppSpacing.sm),
            _reportBar('Outstanding', outstandingPct, AppColors.danger, _fmtGH(b.totalOutstanding)),
          ]),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Budget Utilization', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
          child: Column(children: [
            _reportBar('Spent', budgetUsedPct, AppColors.warning, _fmtGH(b.totalBudgetSpent)),
            const SizedBox(height: AppSpacing.sm),
            _reportBar('Remaining', budgetRemainingPct, AppColors.success, _fmtGH(b.totalBudgetRemaining)),
          ]),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(title: 'Invoices', child: AppDataTable(
          columns: ['Invoice No', 'Student', 'Total', 'Paid', 'Balance', 'Status'],
          rows: b.invoices.map((inv) => [
            Text(inv.invoiceNo), Text(inv.studentName),
            Text(_fmtGH(inv.totalAmount)), Text(_fmtGH(inv.amountPaid)),
            Text(_fmtGH(inv.balance)), _invStatusChip(inv.status),
          ]).toList(),
        )),
      ]),
    );
  }

  Widget _reportBtn(String label, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm)),
      onPressed: () {},
      child: Text(label, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600)),
    );
  }

  Widget _reportBar(String label, int pct, Color color, String amount) {
    return Row(children: [
      SizedBox(width: 80, child: Text(label, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary))),
      const SizedBox(width: AppSpacing.sm),
      Expanded(child: Container(height: 12, decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.sm)), child: FractionallySizedBox(
        alignment: Alignment.centerLeft, widthFactor: pct / 100,
        child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AppRadius.sm))),
      ))),
      const SizedBox(width: AppSpacing.sm),
      SizedBox(width: 80, child: Text(amount, textAlign: TextAlign.right, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.text))),
    ]);
  }

  Widget _invStatusChip(InvoiceStatus status) {
    final color = status == InvoiceStatus.paid ? AppColors.success : status == InvoiceStatus.overdue ? AppColors.danger : status == InvoiceStatus.cancelled ? AppColors.textLight : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Text(status.name, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
    );
  }
}
