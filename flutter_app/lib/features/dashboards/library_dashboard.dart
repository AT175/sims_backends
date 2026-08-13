import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/library_provider.dart';
import '../../core/widgets/widgets.dart';

class LibraryDashboard extends StatelessWidget {
  final String pageKey;
  const LibraryDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'catalogue': return const _CataloguePage();
      case 'circulation': return const _CirculationPage();
      case 'ict': return const _ICTPage();
      case 'equipment': return const _EquipmentPage();
      case 'digital': return const _DigitalPage();
      case 'access': return const _AccessPage();
      case 'requisitions': return const _RequisitionsPage();
      default: return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

// ── Helpers ──

Color _circStatusColor(String s) => s == 'Overdue' ? AppColors.danger : s == 'Returned' ? AppColors.success : AppColors.warning;
Color _labStatusColor(String s) => s == 'Booked' ? AppColors.info : s == 'Completed' ? AppColors.success : AppColors.danger;
Color _conditionColor(String c) => c == 'Good' ? AppColors.success : c == 'Fair' ? AppColors.warning : AppColors.danger;
Color _accessLevelColor(String l) => l == 'Full' ? AppColors.success : l == 'Read Only' ? AppColors.info : l == 'Restricted' ? AppColors.warning : AppColors.danger;

Widget _chip(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
    child: Text(text, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
  );
}

Widget _actionBtn(String label, VoidCallback onPressed, {Color? color}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    ),
  );
}

Widget _selectChip(String label, bool active, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.surfaceAlt,
        border: Border.all(color: active ? AppColors.primary : AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(label, style: TextStyle(fontSize: AppFontSize.xs, color: active ? Colors.white : AppColors.textSecondary, fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
    ),
  );
}

Widget _inputField(String label, TextEditingController ctrl, {String? hint, int maxLines = 1}) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
    const SizedBox(height: AppSpacing.xs),
    TextField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      ),
    ),
    const SizedBox(height: AppSpacing.sm),
  ]);
}

void _confirmDelete(BuildContext context, String message, VoidCallback onConfirm) {
  showDialog(context: context, builder: (ctx) => AlertDialog(
    title: const Text('Confirm Delete'),
    content: Text(message),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      TextButton(onPressed: () { Navigator.pop(ctx); onConfirm(); }, style: TextButton.styleFrom(foregroundColor: AppColors.danger), child: const Text('Delete')),
    ],
  ));
}

class _CataloguePage extends StatelessWidget {
  const _CataloguePage();
  @override
  Widget build(BuildContext context) {
    final l = context.watch<LibraryProvider>();
    return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total Copies', value: '${l.totalBooks}', icon: Icons.menu_book, color: AppColors.primary),
        StatCard(label: 'Available', value: '${l.availableBooks}', icon: Icons.bookmark_added, color: AppColors.success),
        StatCard(label: 'Borrowed', value: '${l.totalBooks - l.availableBooks}', icon: Icons.bookmark_remove, color: AppColors.warning),
        StatCard(label: 'Titles', value: '${l.books.length}', icon: Icons.book, color: AppColors.info),
      ]),
      const SizedBox(height: AppSpacing.lg),

      Text('Catalogue', style: TextStyle(fontSize: AppFontSize.xl, fontWeight: FontWeight.bold, color: AppColors.text)),
      const SizedBox(height: AppSpacing.md),
      _actionBtn('+ Add Book', () => _showAddBookModal(context)),
      const SizedBox(height: AppSpacing.md),

      ...l.books.map((b) => Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: AppColors.border), boxShadow: AppShadows.sm),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(b.title, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
            Text('${b.author} | ${b.category}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            if (b.isbn != null) Text('ISBN: ${b.isbn}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
            const SizedBox(height: AppSpacing.xs),
            Row(children: [
              _chip('${b.availableCopies}/${b.totalCopies} available', b.availableCopies > 0 ? AppColors.success : AppColors.danger),
              const SizedBox(width: AppSpacing.md),
              GestureDetector(onTap: () => _confirmDelete(context, 'Delete "${b.title}" from catalogue?', () => l.deleteBook(b.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.xs, fontWeight: FontWeight.w600, color: AppColors.danger))),
            ]),
          ])),
        ]),
      )),
    ]));
  }
}

class _CirculationPage extends StatelessWidget {
  const _CirculationPage();
  @override
  Widget build(BuildContext context) {
    final l = context.watch<LibraryProvider>();
    return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Active Loans', value: '${l.borrowedBooks}', icon: Icons.arrow_outward, color: AppColors.warning),
        StatCard(label: 'Overdue', value: '${l.overdueBooks}', icon: Icons.schedule, color: AppColors.danger),
        StatCard(label: 'Returned', value: '${l.circulation.where((c) => c.status == 'Returned').length}', icon: Icons.arrow_downward, color: AppColors.success),
        StatCard(label: 'Total Records', value: '${l.circulation.length}', icon: Icons.receipt, color: AppColors.info),
      ]),
      const SizedBox(height: AppSpacing.lg),

      Text('Borrow / Return Log', style: TextStyle(fontSize: AppFontSize.xl, fontWeight: FontWeight.bold, color: AppColors.text)),
      Text('Circulation tracking', style: TextStyle(fontSize: AppFontSize.md, color: AppColors.textSecondary)),
      const SizedBox(height: AppSpacing.md),
      _actionBtn('+ Log Borrow', () => _showBorrowModal(context)),
      const SizedBox(height: AppSpacing.md),

      ...l.circulation.map((c) => Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: AppColors.border), boxShadow: AppShadows.sm),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(c.bookTitle, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
            Text('${c.borrowerName} (${c.borrowerClass})', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            Text('Borrowed: ${c.date} | Due: ${c.dueDate}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
            if (c.returnDate != null) Text('Returned: ${c.returnDate}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
            const SizedBox(height: AppSpacing.xs),
            Row(children: [
              _chip(c.status, _circStatusColor(c.status)),
              if (c.status != 'Returned') ...[
                const SizedBox(width: AppSpacing.md),
                GestureDetector(onTap: () => l.returnBook(c.id), child: Text('Return Book', style: TextStyle(fontSize: AppFontSize.xs, fontWeight: FontWeight.w600, color: AppColors.primary))),
              ],
            ]),
          ])),
        ]),
      )),
    ]));
  }
}

class _ICTPage extends StatelessWidget {
  const _ICTPage();
  @override
  Widget build(BuildContext context) {
    final l = context.watch<LibraryProvider>();
    return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Upcoming', value: '${l.bookings.where((b) => b.status == 'Booked').length}', icon: Icons.event, color: AppColors.info),
        StatCard(label: 'Completed', value: '${l.bookings.where((b) => b.status == 'Completed').length}', icon: Icons.check_circle, color: AppColors.success),
        StatCard(label: 'Cancelled', value: '${l.bookings.where((b) => b.status == 'Cancelled').length}', icon: Icons.cancel, color: AppColors.danger),
      ]),
      const SizedBox(height: AppSpacing.lg),

      Text('ICT Lab Bookings', style: TextStyle(fontSize: AppFontSize.xl, fontWeight: FontWeight.bold, color: AppColors.text)),
      Text('Class and computer lab scheduling', style: TextStyle(fontSize: AppFontSize.md, color: AppColors.textSecondary)),
      const SizedBox(height: AppSpacing.md),
      _actionBtn('+ Book Lab', () => _showBookingModal(context)),
      const SizedBox(height: AppSpacing.md),

      ...l.bookings.map((b) => Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: AppColors.border), boxShadow: AppShadows.sm),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${b.date} | ${b.timeSlot}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
            Text('${b.className} — ${b.teacherName}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            Text('${b.lab} | ${b.purpose}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
            const SizedBox(height: AppSpacing.xs),
            Row(children: [
              _chip(b.status, _labStatusColor(b.status)),
              if (b.status == 'Booked') ...[
                const SizedBox(width: AppSpacing.md),
                GestureDetector(onTap: () => l.completeBooking(b.id), child: Text('Complete', style: TextStyle(fontSize: AppFontSize.xs, fontWeight: FontWeight.w600, color: AppColors.success))),
                const SizedBox(width: AppSpacing.md),
                GestureDetector(onTap: () => l.cancelBooking(b.id), child: Text('Cancel', style: TextStyle(fontSize: AppFontSize.xs, fontWeight: FontWeight.w600, color: AppColors.danger))),
              ],
            ]),
          ])),
        ]),
      )),
    ]));
  }
}

class _EquipmentPage extends StatelessWidget {
  const _EquipmentPage();
  @override
  Widget build(BuildContext context) {
    final l = context.watch<LibraryProvider>();
    return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total Items', value: '${l.equipment.fold(0, (s, e) => s + e.quantity)}', icon: Icons.devices, color: AppColors.primary),
        StatCard(label: 'Good Condition', value: '${l.equipment.where((e) => e.condition == 'Good').length}', icon: Icons.check_circle, color: AppColors.success),
        StatCard(label: 'Needs Repair', value: '${l.equipment.where((e) => e.condition == 'Needs Repair' || e.condition == 'Poor').length}', icon: Icons.build, color: AppColors.danger),
      ]),
      const SizedBox(height: AppSpacing.lg),

      Text('Equipment Inventory', style: TextStyle(fontSize: AppFontSize.xl, fontWeight: FontWeight.bold, color: AppColors.text)),
      Text('Computers, devices and maintenance status', style: TextStyle(fontSize: AppFontSize.md, color: AppColors.textSecondary)),
      const SizedBox(height: AppSpacing.md),
      _actionBtn('+ Add Equipment', () => _showEquipmentModal(context)),
      const SizedBox(height: AppSpacing.md),

      ...l.equipment.map((e) => Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: AppColors.border), boxShadow: AppShadows.sm),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(e.item, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
            Text('Qty: ${e.quantity} | Location: ${e.location}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            Text('Last Service: ${e.lastServiceDate}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
            if (e.notes != null) Text(e.notes!, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight, fontStyle: FontStyle.italic)),
            const SizedBox(height: AppSpacing.xs),
            Row(children: [
              _chip(e.condition, _conditionColor(e.condition)),
              const SizedBox(width: AppSpacing.md),
              GestureDetector(onTap: () => _confirmDelete(context, 'Delete "${e.item}"?', () => l.deleteEquipment(e.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.xs, fontWeight: FontWeight.w600, color: AppColors.danger))),
            ]),
          ])),
        ]),
      )),
    ]));
  }
}

class _DigitalPage extends StatelessWidget {
  const _DigitalPage();
  @override
  Widget build(BuildContext context) {
    final l = context.watch<LibraryProvider>();
    return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total Resources', value: '${l.digitalResources.length}', icon: Icons.cloud, color: AppColors.primary),
        StatCard(label: 'Total Downloads', value: '${l.totalDownloads}', icon: Icons.download, color: AppColors.info),
        StatCard(label: 'E-Books', value: '${l.digitalResources.where((r) => r.type == 'E-Book').length}', icon: Icons.book, color: AppColors.success),
      ]),
      const SizedBox(height: AppSpacing.lg),

      Text('Digital Resources', style: TextStyle(fontSize: AppFontSize.xl, fontWeight: FontWeight.bold, color: AppColors.text)),
      Text('E-books, past questions and multimedia', style: TextStyle(fontSize: AppFontSize.md, color: AppColors.textSecondary)),
      const SizedBox(height: AppSpacing.md),
      _actionBtn('+ Add Resource', () => _showDigitalModal(context)),
      const SizedBox(height: AppSpacing.md),

      ...l.digitalResources.map((r) => Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: AppColors.border), boxShadow: AppShadows.sm),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(r.title, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
            Text('${r.type} | ${r.fileSize} | Uploaded: ${r.uploadDate}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.xs),
            Row(children: [
              _chip('${r.downloads} downloads', AppColors.info),
              const SizedBox(width: AppSpacing.md),
              GestureDetector(onTap: () => l.incrementDownload(r.id), child: Text('+ Download', style: TextStyle(fontSize: AppFontSize.xs, fontWeight: FontWeight.w600, color: AppColors.primary))),
              const SizedBox(width: AppSpacing.md),
              GestureDetector(onTap: () => _confirmDelete(context, 'Delete "${r.title}"?', () => l.deleteDigitalResource(r.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.xs, fontWeight: FontWeight.w600, color: AppColors.danger))),
            ]),
          ])),
        ]),
      )),
    ]));
  }
}

class _AccessPage extends StatelessWidget {
  const _AccessPage();
  @override
  Widget build(BuildContext context) {
    final l = context.watch<LibraryProvider>();
    return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Access Records', value: '${l.accessRecords.length}', icon: Icons.lock_open, color: AppColors.primary),
        StatCard(label: 'Full Access', value: '${l.accessRecords.where((a) => a.accessLevel == 'Full').length}', icon: Icons.verified_user, color: AppColors.success),
        StatCard(label: 'Restricted', value: '${l.accessRecords.where((a) => a.accessLevel == 'Restricted' || a.accessLevel == 'No Access').length}', icon: Icons.block, color: AppColors.danger),
      ]),
      const SizedBox(height: AppSpacing.lg),

      Text('Access Control', style: TextStyle(fontSize: AppFontSize.xl, fontWeight: FontWeight.bold, color: AppColors.text)),
      Text('Manage who can access library and ICT resources', style: TextStyle(fontSize: AppFontSize.md, color: AppColors.textSecondary)),
      const SizedBox(height: AppSpacing.md),
      _actionBtn('+ Grant Access', () => _showAccessModal(context)),
      const SizedBox(height: AppSpacing.md),

      ...l.accessRecords.map((a) => Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: AppColors.border), boxShadow: AppShadows.sm),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(a.personName, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
            Text('${a.role} | ${a.resource}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            Text('Granted by: ${a.grantedBy} on ${a.grantedDate}', style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight)),
            if (a.notes != null) Text(a.notes!, style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.textLight, fontStyle: FontStyle.italic)),
            const SizedBox(height: AppSpacing.xs),
            Row(children: [
              _chip(a.accessLevel, _accessLevelColor(a.accessLevel)),
              const SizedBox(width: AppSpacing.md),
              GestureDetector(onTap: () => _confirmDelete(context, 'Revoke access for "${a.personName}"?', () => l.revokeAccess(a.id)), child: Text('Revoke', style: TextStyle(fontSize: AppFontSize.xs, fontWeight: FontWeight.w600, color: AppColors.danger))),
            ]),
          ])),
        ]),
      )),
    ]));
  }
}

class _RequisitionsPage extends StatelessWidget {
  const _RequisitionsPage();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      StatCardGrid(cards: [
        StatCard(label: 'Total Reqs', value: '0', icon: Icons.inventory_2, color: AppColors.primary),
        StatCard(label: 'Pending', value: '0', icon: Icons.hourglass_empty, color: AppColors.warning),
        StatCard(label: 'Issued', value: '0', icon: Icons.check_circle, color: AppColors.success),
      ]),
      const SizedBox(height: AppSpacing.lg),

      Text('Requisitions', style: TextStyle(fontSize: AppFontSize.xl, fontWeight: FontWeight.bold, color: AppColors.text)),
      Text('Request items from Stores for Library & ICT', style: TextStyle(fontSize: AppFontSize.md, color: AppColors.textSecondary)),
      const SizedBox(height: AppSpacing.lg),

      Container(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.lg), border: Border.all(color: AppColors.border)),
        child: Column(children: [
          Icon(Icons.inventory_2, size: 48, color: AppColors.textLight),
          const SizedBox(height: AppSpacing.sm),
          Text('No requisitions yet.', style: TextStyle(color: AppColors.textLight, fontSize: AppFontSize.md, fontWeight: FontWeight.w500)),
          Text('Tap "New Requisition" to request items from Stores.', style: TextStyle(color: AppColors.textLight, fontSize: AppFontSize.sm)),
        ]),
      ),
    ]));
  }
}

// ── Modal Dialogs ──

void _showAddBookModal(BuildContext context) {
  final l = context.read<LibraryProvider>();
  final titleCtrl = TextEditingController();
  final authorCtrl = TextEditingController();
  final isbnCtrl = TextEditingController();
  final qtyCtrl = TextEditingController(text: '1');
  String category = bookCategories[0];

  showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setState) => AlertDialog(
    title: const Text('Add Book'),
    content: SizedBox(width: 500, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text('Add a new title to the library catalogue', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
      const SizedBox(height: AppSpacing.sm),
      _inputField('Title', titleCtrl, hint: 'Book title'),
      _inputField('Author', authorCtrl, hint: 'Author name'),
      Text('Category', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: bookCategories.map((c) =>
        _selectChip(c, category == c, () => setState(() => category = c))).toList()),
      const SizedBox(height: AppSpacing.sm),
      _inputField('ISBN (optional)', isbnCtrl, hint: 'e.g. 9781234567890'),
      _inputField('Total Copies', qtyCtrl, hint: 'e.g. 5'),
    ]))),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      ElevatedButton(onPressed: () {
        if (titleCtrl.text.trim().isEmpty || authorCtrl.text.trim().isEmpty) return;
        final qty = int.tryParse(qtyCtrl.text) ?? 0;
        if (qty <= 0) return;
        l.addBook(title: titleCtrl.text.trim(), author: authorCtrl.text.trim(), category: category, isbn: isbnCtrl.text.trim().isEmpty ? null : isbnCtrl.text.trim(), totalCopies: qty);
        Navigator.pop(ctx);
      }, child: const Text('Add Book')),
    ],
  )));
}

void _showBorrowModal(BuildContext context) {
  final l = context.read<LibraryProvider>();
  final nameCtrl = TextEditingController();
  final classCtrl = TextEditingController();
  final dueCtrl = TextEditingController();
  String? bookId;

  showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setState) => AlertDialog(
    title: const Text('Log Borrow'),
    content: SizedBox(width: 500, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text('Issue a book to a student', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
      const SizedBox(height: AppSpacing.sm),
      Text('Book', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      if (l.availableBookList.isEmpty)
        Text('No books available', style: TextStyle(color: AppColors.textLight))
      else
        Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: l.availableBookList.map((b) =>
          _selectChip(b.title, bookId == b.id, () => setState(() => bookId = b.id))).toList()),
      const SizedBox(height: AppSpacing.sm),
      _inputField('Borrower Name', nameCtrl, hint: 'Student name'),
      _inputField('Class', classCtrl, hint: 'e.g. SHS2 Sci A'),
      _inputField('Due Date', dueCtrl, hint: 'YYYY-MM-DD'),
    ]))),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      ElevatedButton(onPressed: () {
        if (bookId == null || nameCtrl.text.trim().isEmpty || classCtrl.text.trim().isEmpty || dueCtrl.text.trim().isEmpty) return;
        l.borrowBook(bookId: bookId!, borrowerName: nameCtrl.text.trim(), borrowerClass: classCtrl.text.trim(), dueDate: dueCtrl.text.trim());
        Navigator.pop(ctx);
      }, child: const Text('Issue Book')),
    ],
  )));
}

void _showBookingModal(BuildContext context) {
  final l = context.read<LibraryProvider>();
  final dateCtrl = TextEditingController();
  final classCtrl = TextEditingController();
  final teacherCtrl = TextEditingController();
  final purposeCtrl = TextEditingController();
  String timeSlot = timeSlotsLib[0];
  String lab = labs[0];

  showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setState) => AlertDialog(
    title: const Text('Book ICT Lab'),
    content: SizedBox(width: 500, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text('Schedule a class in a computer lab', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
      const SizedBox(height: AppSpacing.sm),
      _inputField('Date', dateCtrl, hint: 'YYYY-MM-DD'),
      Text('Time Slot', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: timeSlotsLib.map((t) =>
        _selectChip(t, timeSlot == t, () => setState(() => timeSlot = t))).toList()),
      const SizedBox(height: AppSpacing.sm),
      Text('Lab', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: labs.map((lb) =>
        _selectChip(lb, lab == lb, () => setState(() => lab = lb))).toList()),
      const SizedBox(height: AppSpacing.sm),
      _inputField('Class', classCtrl, hint: 'e.g. SHS2 Sci A'),
      _inputField('Teacher', teacherCtrl, hint: 'Teacher name'),
      _inputField('Purpose (optional)', purposeCtrl, hint: 'e.g. Practical: Spreadsheets'),
    ]))),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      ElevatedButton(onPressed: () {
        if (dateCtrl.text.trim().isEmpty || classCtrl.text.trim().isEmpty || teacherCtrl.text.trim().isEmpty) return;
        l.addBooking(date: dateCtrl.text.trim(), timeSlot: timeSlot, className: classCtrl.text.trim(), teacherName: teacherCtrl.text.trim(), lab: lab, purpose: purposeCtrl.text.trim());
        Navigator.pop(ctx);
      }, child: const Text('Book Lab')),
    ],
  )));
}

void _showEquipmentModal(BuildContext context) {
  final l = context.read<LibraryProvider>();
  final itemCtrl = TextEditingController();
  final qtyCtrl = TextEditingController(text: '1');
  final locCtrl = TextEditingController();
  final serviceCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  String condition = equipmentConditions[0];

  showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setState) => AlertDialog(
    title: const Text('Add Equipment'),
    content: SizedBox(width: 500, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      _inputField('Item Name', itemCtrl, hint: 'e.g. Desktop PCs'),
      _inputField('Quantity', qtyCtrl, hint: 'e.g. 30'),
      Text('Condition', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: equipmentConditions.map((c) =>
        _selectChip(c, condition == c, () => setState(() => condition = c))).toList()),
      const SizedBox(height: AppSpacing.sm),
      _inputField('Location', locCtrl, hint: 'e.g. ICT Lab 1'),
      _inputField('Last Service Date', serviceCtrl, hint: 'YYYY-MM-DD'),
      _inputField('Notes (optional)', notesCtrl, hint: 'Maintenance notes...', maxLines: 3),
    ]))),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      ElevatedButton(onPressed: () {
        if (itemCtrl.text.trim().isEmpty || locCtrl.text.trim().isEmpty) return;
        final qty = int.tryParse(qtyCtrl.text) ?? 0;
        if (qty <= 0) return;
        l.addEquipment(item: itemCtrl.text.trim(), quantity: qty, condition: condition, location: locCtrl.text.trim(), lastServiceDate: serviceCtrl.text.trim(), notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim());
        Navigator.pop(ctx);
      }, child: const Text('Add')),
    ],
  )));
}

void _showDigitalModal(BuildContext context) {
  final l = context.read<LibraryProvider>();
  final titleCtrl = TextEditingController();
  final sizeCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  String type = digitalResourceTypes[0];

  showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setState) => AlertDialog(
    title: const Text('Add Digital Resource'),
    content: SizedBox(width: 500, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      _inputField('Title', titleCtrl, hint: 'Resource title'),
      Text('Type', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: digitalResourceTypes.map((t) =>
        _selectChip(t, type == t, () => setState(() => type = t))).toList()),
      const SizedBox(height: AppSpacing.sm),
      _inputField('File Size', sizeCtrl, hint: 'e.g. 12.4 MB'),
      _inputField('Upload Date', dateCtrl, hint: 'YYYY-MM-DD'),
    ]))),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      ElevatedButton(onPressed: () {
        if (titleCtrl.text.trim().isEmpty) return;
        l.addDigitalResource(title: titleCtrl.text.trim(), type: type, fileSize: sizeCtrl.text.trim().isEmpty ? 'Unknown' : sizeCtrl.text.trim(), uploadDate: dateCtrl.text.trim());
        Navigator.pop(ctx);
      }, child: const Text('Add')),
    ],
  )));
}

void _showAccessModal(BuildContext context) {
  final l = context.read<LibraryProvider>();
  final nameCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  String role = accessRoles[2];
  String? resource;
  String accessLevel = accessLevels[1];

  showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setState) => AlertDialog(
    title: const Text('Grant Access'),
    content: SizedBox(width: 500, child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text('Assign resource access to a person', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
      const SizedBox(height: AppSpacing.sm),
      _inputField('Person Name', nameCtrl, hint: 'Person or group name'),
      Text('Role', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: accessRoles.map((r) =>
        _selectChip(r, role == r, () => setState(() => role = r))).toList()),
      const SizedBox(height: AppSpacing.sm),
      Text('Resource', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: accessResources.map((r) =>
        _selectChip(r, resource == r, () => setState(() => resource = r))).toList()),
      const SizedBox(height: AppSpacing.sm),
      Text('Access Level', style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
      Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: accessLevels.map((lv) =>
        _selectChip(lv, accessLevel == lv, () => setState(() => accessLevel = lv))).toList()),
      const SizedBox(height: AppSpacing.sm),
      _inputField('Notes (optional)', notesCtrl, hint: 'Access notes...', maxLines: 2),
    ]))),
    actions: [
      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
      ElevatedButton(onPressed: () {
        if (nameCtrl.text.trim().isEmpty || resource == null) return;
        l.grantAccess(personName: nameCtrl.text.trim(), role: role, resource: resource!, accessLevel: accessLevel, grantedBy: 'Librarian', notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim());
        Navigator.pop(ctx);
      }, child: const Text('Grant Access')),
    ],
  )));
}
