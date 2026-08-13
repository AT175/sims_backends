import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/app_models.dart';
import '../../core/state/bursary_provider.dart' as bursary;
import '../../core/state/bursar_provider.dart';
import '../../core/state/kitchen_provider.dart';
import '../../core/widgets/widgets.dart';

const _cashTxnCategories = ['Fees', 'Pocket Money', 'Feeding', 'Boarding Supplies', 'Utilities', 'Stationery', 'Transport', 'Miscellaneous'];
const _supplyUnits = ['bags', 'gallons', 'crates', 'sacks', 'cartons', 'boxes', 'loads', 'kg', 'litres', 'units', 'sets', 'pieces'];
const _mealTypes = ['Breakfast', 'Lunch', 'Dinner'];
const _returnPeriods = ['Daily', 'Weekly', 'Monthly'];
const _houses = ['House 1 (Boys)', 'House 2 (Boys)', 'House 3 (Girls)', 'House 4 (Girls)', 'All Houses'];

String _today() => DateTime.now().toIso8601String().substring(0, 10);
String _fmtGH(double n) => 'GH\u20B5${n.toStringAsFixed(0)}';

/// Bursary dashboard — 11 pages.
class BursaryDashboard extends StatelessWidget {
  final String pageKey;

  const BursaryDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview':
        return _OverviewPage();
      case 'cashbook':
        return _CashbookPage();
      case 'studentAccounts':
        return _StudentAccountsPage();
      case 'pettyCash':
        return _PettyCashPage();
      case 'imprest':
        return _ImprestPage();
      case 'procurement':
        return _ProcurementPage();
      case 'feeding':
        return _FeedingPage();
      case 'boardingSupplies':
        return _BoardingSuppliesPage();
      case 'disbursements':
        return _DisbursementsPage();
      case 'returns':
        return _ReturnsPage();
      case 'reports':
        return _ReportsPage();
      default:
        return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

Widget _chip(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
    child: Text(text, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
  );
}

Widget _actionBtn(BuildContext context, String label, VoidCallback onPressed, {Color? color}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600)),
    ),
  );
}

Widget _pickerChips(String label, String value, List<String> options, ValueChanged<String> onChanged) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
    const SizedBox(height: AppSpacing.xs),
    Wrap(spacing: 6, runSpacing: 6, children: options.map((opt) => ChoiceChip(
      label: Text(opt),
      selected: value == opt,
      onSelected: (_) => onChanged(opt),
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(color: value == opt ? Colors.white : AppColors.textSecondary, fontSize: AppFontSize.sm),
    )).toList()),
  ]);
}

Widget _formField(String label, TextEditingController ctrl, {String? hint, bool multiline = false, TextInputType? keyboardType}) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
    const SizedBox(height: AppSpacing.xs),
    TextField(
      controller: ctrl,
      maxLines: multiline ? 3 : 1,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      ),
    ),
  ]);
}

void _showFormModal(BuildContext context, String title, Widget formContent, VoidCallback onSubmit, {String submitLabel = 'Submit'}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg))),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
          const SizedBox(height: AppSpacing.md),
          formContent,
          const SizedBox(height: AppSpacing.md),
          Row(children: [
            Expanded(child: TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel'))),
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
  );
}

Widget _alertCard(String title, String subtitle, Color accentColor) {
  return Container(
    padding: const EdgeInsets.all(AppSpacing.md),
    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
    decoration: BoxDecoration(
      color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md),
      border: Border(left: BorderSide(color: accentColor, width: 4)),
    ),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
        Text(subtitle, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
      ])),
    ]),
  );
}

class _OverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final b = context.watch<bursary.BursaryProvider>();
    final bs = context.watch<BursarProvider>();
    final kitchen = context.watch<KitchenProvider>();
    final pendingPetty = bs.pettyCash.where((p) => p.status == 'Requested').toList();
    final pendingProc = bs.procurement.where((p) => p.status == 'Requisitioned').toList();
    final pendingImprest = bs.imprest.where((i) => i.status == 'Pending Retirement').toList();
    final draftReturns = bs.returns.where((r) => r.status == 'Draft').toList();
    final approvedBudgetSubs = b.approvedBudgetSubmissions;
    final approvedKitchenReqs = kitchen.financialReqs.where((r) => r.status == 'Approved').toList();
    final processedPayroll = b.processedPayroll;
    final totalToDisburse =
      approvedBudgetSubs.fold(0.0, (s, x) => s + x.totalRequested) +
      approvedKitchenReqs.fold(0.0, (s, r) => s + r.amount) +
      processedPayroll.fold(0.0, (s, p) => s + p.netSalary);

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Cash Balance', value: _fmtGH(bs.cashBalance), icon: Icons.account_balance, color: AppColors.success),
          StatCard(label: 'Total Income', value: _fmtGH(bs.totalIncome), icon: Icons.trending_up, color: AppColors.primary),
          StatCard(label: 'Total Expense', value: _fmtGH(bs.totalExpense), icon: Icons.trending_down, color: AppColors.danger),
          StatCard(label: 'Student Accounts', value: '${bs.studentAccounts.length}', icon: Icons.account_circle, color: AppColors.info),
          StatCard(label: 'Feeding Records', value: '${bs.feeding.length}', icon: Icons.restaurant, color: AppColors.warning),
          StatCard(label: 'Boarding Supplies', value: _fmtGH(bs.boardingSupplyTotal), icon: Icons.shopping_bag, color: AppColors.primary),
          StatCard(label: 'Pending Petty Cash', value: '${pendingPetty.length}', icon: Icons.pending, color: AppColors.accent),
          StatCard(label: 'Pending Procurement', value: '${pendingProc.length}', icon: Icons.shopping_cart, color: AppColors.danger),
          StatCard(label: 'To Disburse', value: _fmtGH(totalToDisburse), icon: Icons.payments, color: AppColors.primary),
        ]),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(title: 'Budget Summary', child: AppDataTable(
          columns: ['Department', 'Allocated', 'Spent', 'Remaining'],
          rows: b.budgetItems.map((item) => [
            Text(item.department),
            Text(_fmtGH(item.allocated)),
            Text(_fmtGH(item.spent)),
            Text(_fmtGH(item.remaining)),
          ]).toList(),
        )),
        if (pendingPetty.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Pending Petty Cash Requests', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
          const SizedBox(height: AppSpacing.sm),
          ...pendingPetty.map((p) => _alertCard(
            '${_fmtGH(p.amount)} \u2014 ${p.description}',
            'Requested by: ${p.requestedBy}',
            AppColors.warning,
          )),
        ],
        if (pendingProc.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Pending Procurement Requisitions', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
          const SizedBox(height: AppSpacing.sm),
          ...pendingProc.map((p) => _alertCard(
            '${p.item} \u2014 ${p.quantity} ${p.unit}',
            'Est. ${_fmtGH(p.estimatedCost)} \u2014 ${p.department}',
            AppColors.warning,
          )),
        ],
        if (pendingImprest.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Imprest Pending Retirement', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
          const SizedBox(height: AppSpacing.sm),
          ...pendingImprest.map((i) => _alertCard(
            '${i.holder} \u2014 ${_fmtGH(i.amount)}',
            'Retired: ${_fmtGH(i.retiredAmount ?? 0)} \u2014 Awaiting voucher',
            AppColors.warning,
          )),
        ],
        if (draftReturns.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Draft Returns \u2014 Not Yet Submitted', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
          const SizedBox(height: AppSpacing.sm),
          ...draftReturns.map((r) => _alertCard(
            '${r.period} Return \u2014 ${r.dateFrom} to ${r.dateTo}',
            'Net: ${_fmtGH(r.netBalance)} \u2014 Needs submission',
            AppColors.textSecondary,
          )),
        ],
      ]),
    );
  }
}

class _CashbookPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bs = context.watch<BursarProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Cash Balance', value: _fmtGH(bs.cashBalance), icon: Icons.account_balance, color: AppColors.primaryLight),
          StatCard(label: 'Total Income', value: _fmtGH(bs.totalIncome), icon: Icons.trending_up, color: AppColors.success),
          StatCard(label: 'Total Expense', value: _fmtGH(bs.totalExpense), icon: Icons.trending_down, color: AppColors.danger),
          StatCard(label: 'Transactions', value: '${bs.cashTransactions.length}', icon: Icons.receipt, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Record Cash Transaction', () {
          String txnType = 'Income';
          String category = _cashTxnCategories[0];
          final descCtrl = TextEditingController();
          final amtCtrl = TextEditingController();
          final fromToCtrl = TextEditingController();
          _showFormModal(context, 'Record Cash Transaction', StatefulBuilder(
            builder: (ctx, setState) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _pickerChips('Type', txnType, ['Income', 'Expense'], (v) => setState(() => txnType = v)),
              const SizedBox(height: AppSpacing.sm),
              _pickerChips('Category', category, _cashTxnCategories, (v) => setState(() => category = v)),
              const SizedBox(height: AppSpacing.sm),
              _formField('Description', descCtrl),
              const SizedBox(height: AppSpacing.sm),
              _formField('Amount (GH\u20B5)', amtCtrl, hint: '500', keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.sm),
              _formField(txnType == 'Income' ? 'Received From' : 'Paid To', fromToCtrl, hint: 'Vendor / Source'),
            ]),
          ), () {
            final amt = double.tryParse(amtCtrl.text);
            if (amt == null || amt <= 0 || descCtrl.text.isEmpty) return;
            bs.recordCashTransaction(
              type: txnType, category: category, description: descCtrl.text,
              amount: amt, handledBy: 'Bursar',
              receivedFrom: txnType == 'Income' ? fromToCtrl.text : null,
              paidTo: txnType == 'Expense' ? fromToCtrl.text : null,
            );
          }, submitLabel: 'Record');
        }),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(title: 'Cash Book', child: AppDataTable(
          columns: ['Date', 'Receipt', 'Type', 'Category', 'Description', 'Amount', 'Balance'],
          rows: bs.cashTransactions.map((t) => [
            Text(t.date), Text(t.receiptNo),
            _chip(t.type, t.type == 'Income' ? AppColors.success : AppColors.danger),
            Text(t.category), Text(t.description),
            Text(_fmtGH(t.amount)), Text(_fmtGH(t.balanceAfter)),
          ]).toList(),
        )),
      ]),
    );
  }
}

class _StudentAccountsPage extends StatefulWidget {
  @override
  State<_StudentAccountsPage> createState() => _StudentAccountsPageState();
}

class _StudentAccountsPageState extends State<_StudentAccountsPage> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final b = context.watch<bursary.BursaryProvider>();
    final bs = context.watch<BursarProvider>();
    final q = _search.toLowerCase().trim();
    final filtered = bs.studentAccounts.where((a) {
      return q.isEmpty ||
        a.studentName.toLowerCase().contains(q) ||
        a.admNo.toLowerCase().contains(q) ||
        a.className.toLowerCase().contains(q);
    }).toList();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Fee Accounts', value: '${b.fees.length}', icon: Icons.account_circle, color: AppColors.primaryLight),
          StatCard(label: 'Pocket Money Accts', value: '${bs.studentAccounts.length}', icon: Icons.savings, color: AppColors.info),
          StatCard(label: 'Cleared', value: '${b.fees.where((f) => f.status == FeeStatus.cleared).length}', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Owing', value: '${b.fees.where((f) => f.status == FeeStatus.owing).length}', icon: Icons.error, color: AppColors.danger),
        ]),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(title: 'Student Fee Accounts', child: AppDataTable(
          columns: ['Student', 'Adm No', 'Fee Type', 'Due', 'Paid', 'Balance', 'Status'],
          rows: b.fees.map((f) => [
            Text(f.studentName), Text(f.admNo), Text(f.feeType),
            Text(_fmtGH(f.amountDue)), Text(_fmtGH(f.amountPaid)),
            Text(_fmtGH(f.balance)), _feeStatusChip(f.status),
          ]).toList(),
        )),
        const SizedBox(height: AppSpacing.lg),
        Text('Pocket Money Accounts', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
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
        ...filtered.map((a) => _AccountCard(account: a)),
      ]),
    );
  }

  Widget _feeStatusChip(FeeStatus status) {
    final color = status == FeeStatus.cleared ? AppColors.success : status == FeeStatus.partial ? AppColors.warning : AppColors.danger;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Text(status.name, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _AccountCard extends StatefulWidget {
  final StudentAccount account;
  const _AccountCard({required this.account});

  @override
  State<_AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<_AccountCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final bs = context.read<BursarProvider>();
    final a = widget.account;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${a.studentName} \u2014 ${a.admNo}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
              Text('${a.className} \u2014 Guardian: ${a.guardianName}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              Text('Balance: ${_fmtGH(a.balance)}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.success)),
            ])),
            Text(_expanded ? '\u2212' : '+', style: TextStyle(fontSize: AppFontSize.xl, color: AppColors.primary, fontWeight: FontWeight.bold)),
          ]),
        ),
        if (_expanded) ...[
          const Divider(height: AppSpacing.md),
          Text('Transaction History', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.text)),
          const SizedBox(height: AppSpacing.xs),
          ...a.transactions.map((t) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(children: [
              SizedBox(width: 80, child: Text(t.date, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textSecondary))),
              _chip(t.type, t.type == 'Deposit' ? AppColors.success : AppColors.danger),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(t.description, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.text))),
              Text(_fmtGH(t.amount), style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: t.type == 'Deposit' ? AppColors.success : AppColors.danger)),
            ]),
          )),
          const SizedBox(height: AppSpacing.sm),
          Row(children: [
            Expanded(child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
              onPressed: () => _showTxnModal(context, a, 'Deposit', bs),
              child: const Text('Deposit'),
            )),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning, foregroundColor: Colors.white),
              onPressed: () => _showTxnModal(context, a, 'Withdrawal', bs),
              child: const Text('Withdraw'),
            )),
          ]),
        ],
      ]),
    );
  }

  void _showTxnModal(BuildContext context, StudentAccount a, String type, BursarProvider bs) {
    final amtCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    _showFormModal(context, '$type \u2014 ${a.studentName}', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Current Balance: ${_fmtGH(a.balance)}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
      const SizedBox(height: AppSpacing.sm),
      _formField('Amount (GH\u20B5)', amtCtrl, hint: '50', keyboardType: TextInputType.number),
      const SizedBox(height: AppSpacing.sm),
      _formField('Description', descCtrl, hint: 'Pocket money / Toiletries / etc.'),
    ]), () {
      final amt = double.tryParse(amtCtrl.text);
      if (amt == null || amt <= 0) return;
      if (type == 'Deposit') {
        bs.depositPocketMoney(a.id, amt, descCtrl.text.isEmpty ? 'Deposit' : descCtrl.text, 'Bursar');
      } else {
        bs.withdrawPocketMoney(a.id, amt, descCtrl.text.isEmpty ? 'Withdrawal' : descCtrl.text, 'Bursar');
      }
    }, submitLabel: 'Record $type');
  }
}

class _PettyCashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bs = context.watch<BursarProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Disbursed', value: _fmtGH(bs.pettyCashBalance), icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Requested', value: _fmtGH(bs.pettyCashRequested), icon: Icons.pending, color: AppColors.warning),
          StatCard(label: 'Pending Approval', value: '${bs.pendingPettyCash}', icon: Icons.hourglass_empty, color: AppColors.danger),
          StatCard(label: 'Total Entries', value: '${bs.pettyCash.length}', icon: Icons.receipt_long, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Add Petty Cash Request', () {
          final descCtrl = TextEditingController();
          final amtCtrl = TextEditingController();
          final reqByCtrl = TextEditingController();
          final notesCtrl = TextEditingController();
          _showFormModal(context, 'Petty Cash Request', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _formField('Description', descCtrl),
            const SizedBox(height: AppSpacing.sm),
            _formField('Amount (GH\u20B5)', amtCtrl, hint: '30', keyboardType: TextInputType.number),
            const SizedBox(height: AppSpacing.sm),
            _formField('Requested By', reqByCtrl, hint: 'Department / Staff'),
            const SizedBox(height: AppSpacing.sm),
            _formField('Notes', notesCtrl, hint: 'Optional', multiline: true),
          ]), () {
            final amt = double.tryParse(amtCtrl.text);
            if (amt == null || amt <= 0 || descCtrl.text.isEmpty) return;
            bs.addPettyCashEntry(description: descCtrl.text, amount: amt, requestedBy: reqByCtrl.text.isEmpty ? 'Bursar' : reqByCtrl.text, notes: notesCtrl.text);
          }, submitLabel: 'Add Request');
        }),
        const SizedBox(height: AppSpacing.lg),
        ...bs.pettyCash.map((p) => _PettyCashCard(entry: p)),
      ]),
    );
  }
}

class _PettyCashCard extends StatelessWidget {
  final PettyCashEntry entry;
  const _PettyCashCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final bs = context.read<BursarProvider>();
    final statusColor = entry.status == 'Disbursed' ? AppColors.success : entry.status == 'Approved' ? AppColors.info : entry.status == 'Rejected' ? AppColors.danger : AppColors.warning;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_fmtGH(entry.amount), style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.primary)),
            Text('${entry.date} | ${entry.description}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            Text('Requested by: ${entry.requestedBy}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
            if (entry.notes.isNotEmpty) Text(entry.notes, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight, fontStyle: FontStyle.italic)),
            if (entry.receiptNo != null) Text('Receipt: ${entry.receiptNo}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
          ])),
          _chip(entry.status, statusColor),
        ]),
        if (entry.status == 'Requested') ...[
          const SizedBox(height: AppSpacing.sm),
          Row(children: [
            Expanded(child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
              onPressed: () => bs.approvePettyCash(entry.id, 'Bursar'),
              child: const Text('Approve'),
            )),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white),
              onPressed: () => bs.rejectPettyCash(entry.id),
              child: const Text('Reject'),
            )),
          ]),
        ],
        if (entry.status == 'Approved') ...[
          const SizedBox(height: AppSpacing.sm),
          SizedBox(width: double.infinity, child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            onPressed: () => bs.disbursePettyCash(entry.id),
            child: const Text('Mark Disbursed'),
          )),
        ],
      ]),
    );
  }
}

class _ImprestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bs = context.watch<BursarProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Active Imprest', value: _fmtGH(bs.activeImprestTotal), icon: Icons.account_balance_wallet, color: AppColors.primaryLight),
          StatCard(label: 'Total Accounts', value: '${bs.imprest.length}', icon: Icons.folder, color: AppColors.info),
          StatCard(label: 'Active', value: '${bs.imprest.where((i) => i.status == 'Active').length}', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Pending Retirement', value: '${bs.imprest.where((i) => i.status == 'Pending Retirement').length}', icon: Icons.pending, color: AppColors.warning),
        ]),
        const SizedBox(height: AppSpacing.lg),
        ...bs.imprest.map((i) => _ImprestCard(account: i)),
      ]),
    );
  }
}

class _ImprestCard extends StatelessWidget {
  final ImprestAccount account;
  const _ImprestCard({required this.account});

  @override
  Widget build(BuildContext context) {
    final bs = context.read<BursarProvider>();
    final statusColor = account.status == 'Retired' ? AppColors.success : account.status == 'Pending Retirement' ? AppColors.warning : AppColors.info;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_fmtGH(account.amount), style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.primary)),
            Text('${account.holder} \u2014 ${account.department}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            Text('Issued: ${account.dateIssued} \u2014 Purpose: ${account.purpose}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
            if (account.retiredAmount != null) Text('Retired: ${_fmtGH(account.retiredAmount!)} \u2014 Voucher: ${account.retirementVoucherNo ?? 'N/A'}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
            if (account.notes.isNotEmpty) Text(account.notes, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight, fontStyle: FontStyle.italic)),
          ])),
          _chip(account.status, statusColor),
        ]),
        if (account.status == 'Pending Retirement') ...[
          const SizedBox(height: AppSpacing.sm),
          SizedBox(width: double.infinity, child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            onPressed: () {
              final amtCtrl = TextEditingController(text: account.retiredAmount?.toString() ?? '');
              final voucherCtrl = TextEditingController();
              _showFormModal(context, 'Retire Imprest \u2014 ${account.holder}', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Issued: ${_fmtGH(account.amount)} \u2014 Purpose: ${account.purpose}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.sm),
                _formField('Retired Amount (GH\u20B5)', amtCtrl, hint: '2850', keyboardType: TextInputType.number),
                const SizedBox(height: AppSpacing.sm),
                _formField('Retirement Voucher No.', voucherCtrl, hint: 'RV-002'),
              ]), () {
                final amt = double.tryParse(amtCtrl.text);
                if (amt == null || amt < 0 || voucherCtrl.text.isEmpty) return;
                bs.retireImprest(account.id, amt, voucherCtrl.text);
              }, submitLabel: 'Retire');
            },
            child: const Text('Retire Imprest'),
          )),
        ],
      ]),
    );
  }
}

class _ProcurementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bs = context.watch<BursarProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Requests', value: '${bs.procurement.length}', icon: Icons.shopping_cart, color: AppColors.primaryLight),
          StatCard(label: 'Pending', value: '${bs.pendingProcurement}', icon: Icons.pending, color: AppColors.warning),
          StatCard(label: 'Delivered', value: '${bs.procurement.where((p) => p.status == 'Delivered').length}', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Ordered', value: '${bs.procurement.where((p) => p.status == 'Ordered').length}', icon: Icons.local_shipping, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ New Requisition', () {
          String unit = _supplyUnits[0];
          final itemCtrl = TextEditingController();
          final qtyCtrl = TextEditingController();
          final costCtrl = TextEditingController();
          final supplierCtrl = TextEditingController();
          final reqByCtrl = TextEditingController();
          final deptCtrl = TextEditingController();
          final notesCtrl = TextEditingController();
          _showFormModal(context, 'New Procurement Requisition', StatefulBuilder(
            builder: (ctx, setState) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _formField('Item', itemCtrl),
              const SizedBox(height: AppSpacing.sm),
              _formField('Quantity', qtyCtrl, hint: '10', keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.sm),
              _pickerChips('Unit', unit, _supplyUnits, (v) => setState(() => unit = v)),
              const SizedBox(height: AppSpacing.sm),
              _formField('Estimated Cost (GH\u20B5)', costCtrl, hint: '4000', keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.sm),
              _formField('Supplier', supplierCtrl),
              const SizedBox(height: AppSpacing.sm),
              _formField('Requested By', reqByCtrl, hint: 'Department / Staff'),
              const SizedBox(height: AppSpacing.sm),
              _formField('Department', deptCtrl, hint: 'Kitchen / Science Lab / etc.'),
              const SizedBox(height: AppSpacing.sm),
              _formField('Notes', notesCtrl, multiline: true),
            ]),
          ), () {
            final qty = int.tryParse(qtyCtrl.text);
            final cost = double.tryParse(costCtrl.text);
            if (itemCtrl.text.isEmpty || qty == null || qty <= 0 || cost == null || cost <= 0 || supplierCtrl.text.isEmpty) return;
            bs.addProcurement(item: itemCtrl.text, quantity: qty, unit: unit, estimatedCost: cost, supplier: supplierCtrl.text, requestedBy: reqByCtrl.text, department: deptCtrl.text, notes: notesCtrl.text);
          }, submitLabel: 'Submit');
        }),
        const SizedBox(height: AppSpacing.lg),
        ...bs.procurement.map((p) => _ProcurementCard(req: p)),
      ]),
    );
  }
}

class _ProcurementCard extends StatelessWidget {
  final ProcurementRequest req;
  const _ProcurementCard({required this.req});

  @override
  Widget build(BuildContext context) {
    final bs = context.read<BursarProvider>();
    final statusColor = req.status == 'Delivered' ? AppColors.success : req.status == 'Ordered' ? AppColors.info : req.status == 'Approved' ? AppColors.primary : req.status == 'Rejected' ? AppColors.danger : AppColors.warning;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${req.item} \u2014 ${req.quantity} ${req.unit}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.text)),
            Text('Est. ${_fmtGH(req.estimatedCost)} \u2014 ${req.supplier}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            Text('Requested by: ${req.requestedBy} (${req.department})', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
            if (req.actualCost != null) Text('Actual: ${_fmtGH(req.actualCost!)} \u2014 Delivered: ${req.dateDelivered}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
            if (req.notes.isNotEmpty) Text(req.notes, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight, fontStyle: FontStyle.italic)),
          ])),
          _chip(req.status, statusColor),
        ]),
        if (req.status == 'Requisitioned') ...[
          const SizedBox(height: AppSpacing.sm),
          Row(children: [
            Expanded(child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
              onPressed: () => bs.approveProcurement(req.id),
              child: const Text('Approve'),
            )),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white),
              onPressed: () => bs.rejectProcurement(req.id),
              child: const Text('Reject'),
            )),
          ]),
        ],
        if (req.status == 'Approved') ...[
          const SizedBox(height: AppSpacing.sm),
          SizedBox(width: double.infinity, child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            onPressed: () => bs.orderProcurement(req.id),
            child: const Text('Mark Ordered'),
          )),
        ],
        if (req.status == 'Ordered') ...[
          const SizedBox(height: AppSpacing.sm),
          SizedBox(width: double.infinity, child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
            onPressed: () {
              final costCtrl = TextEditingController();
              _showFormModal(context, 'Mark Delivered \u2014 ${req.item}', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Est. Cost: ${_fmtGH(req.estimatedCost)}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                const SizedBox(height: AppSpacing.sm),
                _formField('Actual Cost (GH\u20B5)', costCtrl, hint: req.estimatedCost.toStringAsFixed(0), keyboardType: TextInputType.number),
              ]), () {
                final cost = double.tryParse(costCtrl.text);
                if (cost == null || cost <= 0) return;
                bs.deliverProcurement(req.id, cost);
              }, submitLabel: 'Confirm Delivery');
            },
            child: const Text('Mark Delivered'),
          )),
        ],
      ]),
    );
  }
}

class _FeedingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bs = context.watch<BursarProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Feeding Cost', value: _fmtGH(bs.feedingTotalCost), icon: Icons.restaurant, color: AppColors.primaryLight),
          StatCard(label: 'Meals Served', value: '${bs.feeding.length}', icon: Icons.dining, color: AppColors.info),
          StatCard(label: 'Avg Headcount', value: '${bs.feeding.isEmpty ? 0 : (bs.feeding.fold(0, (s, f) => s + f.headcount) / bs.feeding.length).round()}', icon: Icons.people, color: AppColors.success),
          StatCard(label: 'Avg Cost/Head', value: _fmtGH(bs.feeding.isEmpty ? 0 : bs.feeding.fold(0.0, (s, f) => s + f.costPerHead) / bs.feeding.length), icon: Icons.payments, color: AppColors.warning),
        ]),
        const SizedBox(height: AppSpacing.lg),
        if (bs.feedingCostByMeal.isNotEmpty) ...[
          StatCardGrid(cards: bs.feedingCostByMeal.map((m) => StatCard(
            label: m.meal, value: _fmtGH(m.total), icon: Icons.restaurant_menu,
            color: m.meal == 'Breakfast' ? AppColors.warning : m.meal == 'Lunch' ? AppColors.primary : AppColors.info,
          )).toList()),
          const SizedBox(height: AppSpacing.lg),
        ],
        _actionBtn(context, '+ Add Feeding Record', () {
          String meal = _mealTypes[0];
          final dateCtrl = TextEditingController(text: _today());
          final hcCtrl = TextEditingController();
          final cphCtrl = TextEditingController();
          final notesCtrl = TextEditingController();
          _showFormModal(context, 'Add Feeding Record', StatefulBuilder(
            builder: (ctx, setState) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _formField('Date', dateCtrl, hint: 'YYYY-MM-DD'),
              const SizedBox(height: AppSpacing.sm),
              _pickerChips('Meal', meal, _mealTypes, (v) => setState(() => meal = v)),
              const SizedBox(height: AppSpacing.sm),
              _formField('Headcount', hcCtrl, hint: '480', keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.sm),
              _formField('Cost Per Head (GH\u20B5)', cphCtrl, hint: '5', keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.sm),
              _formField('Notes', notesCtrl, hint: 'Menu description', multiline: true),
            ]),
          ), () {
            final hc = int.tryParse(hcCtrl.text);
            final cph = double.tryParse(cphCtrl.text);
            if (hc == null || hc <= 0 || cph == null || cph <= 0) return;
            bs.addFeedingRecord(date: dateCtrl.text, meal: meal, headcount: hc, costPerHead: cph, notes: notesCtrl.text);
          }, submitLabel: 'Add Record');
        }),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(title: 'Feeding Account', child: AppDataTable(
          columns: ['Date', 'Meal', 'Headcount', 'Cost/Head', 'Total', 'Status'],
          rows: bs.feeding.map((f) => [
            Text(f.date), Text(f.meal), Text('${f.headcount}'),
            Text(_fmtGH(f.costPerHead)), Text(_fmtGH(f.totalCost)),
            _chip(f.status, AppColors.success),
          ]).toList(),
        )),
      ]),
    );
  }
}

class _BoardingSuppliesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bs = context.watch<BursarProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Cost', value: _fmtGH(bs.boardingSupplyTotal), icon: Icons.shopping_bag, color: AppColors.primaryLight),
          StatCard(label: 'Items', value: '${bs.boardingSupplies.length}', icon: Icons.inventory, color: AppColors.info),
          StatCard(label: 'Houses Covered', value: '${bs.boardingSupplies.map((b) => b.house).toSet().length}', icon: Icons.home, color: AppColors.success),
          StatCard(label: 'Suppliers', value: '${bs.boardingSupplies.map((b) => b.supplier).toSet().length}', icon: Icons.local_shipping, color: AppColors.warning),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Add Boarding Supply', () {
          String unit = _supplyUnits[0];
          String house = _houses[0];
          final itemCtrl = TextEditingController();
          final qtyCtrl = TextEditingController();
          final ucCtrl = TextEditingController();
          final dateCtrl = TextEditingController(text: _today());
          final supplierCtrl = TextEditingController();
          final notesCtrl = TextEditingController();
          _showFormModal(context, 'Add Boarding Supply', StatefulBuilder(
            builder: (ctx, setState) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _formField('Item', itemCtrl),
              const SizedBox(height: AppSpacing.sm),
              _formField('Quantity', qtyCtrl, hint: '20', keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.sm),
              _pickerChips('Unit', unit, _supplyUnits, (v) => setState(() => unit = v)),
              const SizedBox(height: AppSpacing.sm),
              _formField('Unit Cost (GH\u20B5)', ucCtrl, hint: '80', keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.sm),
              _formField('Date Purchased', dateCtrl, hint: 'YYYY-MM-DD'),
              const SizedBox(height: AppSpacing.sm),
              _formField('Supplier', supplierCtrl),
              const SizedBox(height: AppSpacing.sm),
              _pickerChips('House', house, _houses, (v) => setState(() => house = v)),
              const SizedBox(height: AppSpacing.sm),
              _formField('Notes', notesCtrl, multiline: true),
            ]),
          ), () {
            final qty = int.tryParse(qtyCtrl.text);
            final uc = double.tryParse(ucCtrl.text);
            if (itemCtrl.text.isEmpty || qty == null || qty <= 0 || uc == null || uc <= 0 || supplierCtrl.text.isEmpty) return;
            bs.addBoardingSupply(item: itemCtrl.text, quantity: qty, unit: unit, unitCost: uc, datePurchased: dateCtrl.text, supplier: supplierCtrl.text, house: house, notes: notesCtrl.text);
          }, submitLabel: 'Add Supply');
        }),
        const SizedBox(height: AppSpacing.lg),
        SectionCard(title: 'Boarding Supplies', child: AppDataTable(
          columns: ['Item', 'Qty', 'Unit Cost', 'Total', 'House', 'Date'],
          rows: bs.boardingSupplies.map((b) => [
            Text(b.item), Text('${b.quantity} ${b.unit}'),
            Text(_fmtGH(b.unitCost)), Text(_fmtGH(b.totalCost)),
            Text(b.house), Text(b.datePurchased),
          ]).toList(),
        )),
      ]),
    );
  }
}

class _DisbursementsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bs = context.watch<BursarProvider>();
    final b = context.watch<bursary.BursaryProvider>();
    final kitchen = context.watch<KitchenProvider>();
    final approvedBudgetSubs = b.approvedBudgetSubmissions;
    final approvedKitchenReqs = kitchen.financialReqs.where((r) => r.status == 'Approved').toList();
    final processedPayroll = b.processedPayroll;
    final totalToDisburse =
      approvedBudgetSubs.fold(0.0, (s, x) => s + x.totalRequested) +
      approvedKitchenReqs.fold(0.0, (s, r) => s + r.amount) +
      processedPayroll.fold(0.0, (s, p) => s + p.netSalary);

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total to Disburse', value: _fmtGH(totalToDisburse), icon: Icons.payments, color: AppColors.primary),
          StatCard(label: 'Budget Submissions', value: '${approvedBudgetSubs.length}', icon: Icons.account_balance, color: AppColors.info),
          StatCard(label: 'Kitchen Requests', value: '${approvedKitchenReqs.length}', icon: Icons.restaurant, color: AppColors.warning),
          StatCard(label: 'Payroll (Processed)', value: '${processedPayroll.length}', icon: Icons.people, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        if (approvedBudgetSubs.isNotEmpty) ...[
          Text('Approved Budget Submissions', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
          const SizedBox(height: AppSpacing.sm),
          ...approvedBudgetSubs.map((x) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_fmtGH(x.totalRequested), style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  Text('${x.department} \u2014 Submitted by: ${x.submittedBy}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  if (x.accountantNotes.isNotEmpty) Text(x.accountantNotes, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight, fontStyle: FontStyle.italic)),
                ])),
                _chip('Approved', AppColors.info),
              ]),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(width: double.infinity, child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
                onPressed: () {
                  b.disburseBudgetSubmission(x.id, 'Bursar');
                  bs.recordCashTransaction(
                    type: 'Expense', category: 'Miscellaneous',
                    description: 'Disbursement \u2014 ${x.department} budget (Accountant approved)',
                    amount: x.totalRequested, paidTo: x.department, handledBy: 'Bursar',
                  );
                },
                child: Text('Disburse ${_fmtGH(x.totalRequested)}'),
              )),
            ]),
          )),
          const SizedBox(height: AppSpacing.lg),
        ],
        if (approvedKitchenReqs.isNotEmpty) ...[
          Text('Approved Kitchen Finance Requests', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
          const SizedBox(height: AppSpacing.sm),
          ...approvedKitchenReqs.map((r) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_fmtGH(r.amount), style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  Text('${r.date} | ${r.purpose}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  Text('Requested by: ${r.requestedBy}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
                  if (r.notes.isNotEmpty) Text(r.notes, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight, fontStyle: FontStyle.italic)),
                ])),
                _chip('Approved', AppColors.info),
              ]),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(width: double.infinity, child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
                onPressed: () {
                  kitchen.updateFinancialReqStatus(r.id, 'Disbursed');
                  bs.recordCashTransaction(
                    type: 'Expense', category: 'Feeding',
                    description: 'Disbursement \u2014 Kitchen: ${r.purpose}',
                    amount: r.amount, paidTo: 'Catering Department', handledBy: 'Bursar',
                  );
                },
                child: Text('Disburse ${_fmtGH(r.amount)}'),
              )),
            ]),
          )),
          const SizedBox(height: AppSpacing.lg),
        ],
        if (processedPayroll.isNotEmpty) ...[
          Text('Processed Payroll \u2014 Awaiting Payment', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
          const SizedBox(height: AppSpacing.sm),
          ...processedPayroll.map((p) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_fmtGH(p.netSalary), style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  Text('${p.staffName} \u2014 ${p.position}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  Text('${p.department} \u2014 ${p.payPeriod}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
                  Text('Gross: ${_fmtGH(p.grossSalary)} \u2014 SSF: ${_fmtGH(p.ssfContribution)} \u2014 Tax: ${_fmtGH(p.taxDeduction)}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
                ])),
                _chip('Processed', AppColors.info),
              ]),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(width: double.infinity, child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
                onPressed: () {
                  b.payPayroll(p.id);
                  bs.recordCashTransaction(
                    type: 'Expense', category: 'Miscellaneous',
                    description: 'Salary payment \u2014 ${p.staffName}',
                    amount: p.netSalary, paidTo: p.staffName, handledBy: 'Bursar',
                  );
                },
                child: Text('Pay ${_fmtGH(p.netSalary)}'),
              )),
            ]),
          )),
        ],
        const SizedBox(height: AppSpacing.lg),
        SectionCard(title: 'Petty Cash Disbursements', child: AppDataTable(
          columns: ['Date', 'Description', 'Amount', 'Requested By', 'Approved By', 'Receipt'],
          rows: bs.pettyCash.where((p) => p.status == 'Disbursed').map((p) => [
            Text(p.date), Text(p.description), Text(_fmtGH(p.amount)),
            Text(p.requestedBy), Text(p.approvedBy ?? '\u2014'), Text(p.receiptNo ?? '\u2014'),
          ]).toList(),
        )),
      ]),
    );
  }
}

class _ReturnsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bs = context.watch<BursarProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Returns', value: '${bs.returns.length}', icon: Icons.assessment, color: AppColors.primaryLight),
          StatCard(label: 'Draft', value: '${bs.returns.where((r) => r.status == 'Draft').length}', icon: Icons.edit_note, color: AppColors.warning),
          StatCard(label: 'Submitted', value: '${bs.returns.where((r) => r.status == 'Submitted').length}', icon: Icons.send, color: AppColors.info),
          StatCard(label: 'Approved', value: '${bs.returns.where((r) => r.status == 'Approved').length}', icon: Icons.check_circle, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Generate Return', () {
          String period = 'Daily';
          final fromCtrl = TextEditingController(text: _today());
          final toCtrl = TextEditingController(text: _today());
          _showFormModal(context, 'Generate Return', StatefulBuilder(
            builder: (ctx, setState) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _pickerChips('Period', period, _returnPeriods, (v) => setState(() => period = v)),
              const SizedBox(height: AppSpacing.sm),
              _formField('From Date', fromCtrl, hint: 'YYYY-MM-DD'),
              const SizedBox(height: AppSpacing.sm),
              _formField('To Date', toCtrl, hint: 'YYYY-MM-DD'),
            ]),
          ), () {
            bs.generateReturn(period, fromCtrl.text, toCtrl.text);
          }, submitLabel: 'Generate');
        }),
        const SizedBox(height: AppSpacing.lg),
        ...bs.returns.map((r) => _ReturnCard(ret: r)),
      ]),
    );
  }
}

class _ReturnCard extends StatelessWidget {
  final BursaryReturn ret;
  const _ReturnCard({required this.ret});

  @override
  Widget build(BuildContext context) {
    final bs = context.read<BursarProvider>();
    final statusColor = ret.status == 'Approved' ? AppColors.success : ret.status == 'Submitted' ? AppColors.info : ret.status == 'Rejected' ? AppColors.danger : AppColors.textSecondary;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${ret.period} Return \u2014 ${ret.dateFrom} to ${ret.dateTo}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.text)),
            Text('Income: ${_fmtGH(ret.totalIncome)} \u2014 Expense: ${_fmtGH(ret.totalExpense)}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            Text('Net: ${_fmtGH(ret.netBalance)}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: ret.netBalance >= 0 ? AppColors.success : AppColors.danger)),
            Text('Submitted by: ${ret.submittedBy}${ret.dateSubmitted.isNotEmpty ? ' on ${ret.dateSubmitted}' : ''}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
            if (ret.approvedBy != null) Text('Approved by: ${ret.approvedBy}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
            if (ret.notes.isNotEmpty) Text(ret.notes, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight, fontStyle: FontStyle.italic)),
          ])),
          _chip(ret.status, statusColor),
        ]),
        if (ret.status == 'Draft') ...[
          const SizedBox(height: AppSpacing.sm),
          SizedBox(width: double.infinity, child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            onPressed: () => bs.submitReturn(ret.id),
            child: const Text('Submit to Accountant'),
          )),
        ],
      ]),
    );
  }
}

class _ReportsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final b = context.watch<bursary.BursaryProvider>();
    final bs = context.watch<BursarProvider>();
    final totalIn = bs.totalIncome;
    final totalOut = bs.totalExpense;
    final total = totalIn + totalOut;
    final incomePct = total > 0 ? (totalIn / total * 100).round() : 0;
    final expensePct = total > 0 ? (totalOut / total * 100).round() : 0;

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Payroll (Gross)', value: _fmtGH(b.totalPayrollGross), icon: Icons.people, color: AppColors.primaryLight),
          StatCard(label: 'Payroll (Net)', value: _fmtGH(b.totalPayrollNet), icon: Icons.people_outline, color: AppColors.success),
          StatCard(label: 'Overdue Invoices', value: '${b.overdueInvoiceCount}', icon: Icons.receipt_long, color: AppColors.danger),
          StatCard(label: 'Total Invoices', value: '${b.invoices.length}', icon: Icons.description, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, 'Generate Full Bursary Report', () {}),
        const SizedBox(height: AppSpacing.md),
        Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
          _reportBtn('Cash Book', AppColors.success),
          _reportBtn('Student Accounts', AppColors.info),
          _reportBtn('Petty Cash', AppColors.warning),
          _reportBtn('Imprest', AppColors.primary),
          _reportBtn('Procurement', AppColors.accent),
          _reportBtn('Feeding', AppColors.warning),
          _reportBtn('Boarding', AppColors.danger),
          _reportBtn('Returns', AppColors.primary),
        ]),
        const SizedBox(height: AppSpacing.lg),
        Text('Cash Flow', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg)),
          child: Column(children: [
            _reportBar('Income', incomePct, AppColors.success, _fmtGH(totalIn)),
            const SizedBox(height: AppSpacing.sm),
            _reportBar('Expense', expensePct, AppColors.danger, _fmtGH(totalOut)),
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
        alignment: Alignment.centerLeft,
        widthFactor: pct / 100,
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
