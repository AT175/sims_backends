import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/transport_provider.dart';
import '../../core/widgets/widgets.dart';

const _vehicleStatuses = ['Active', 'Maintenance', 'Retired'];
const _vehicleTypes = ['Coaster Bus (30-seater)', 'Mini Bus (15-seater)', 'Pickup Truck', 'Saloon Car', 'Van', 'Truck'];
const _maintenanceStatuses = ['Upcoming', 'Scheduled', 'In Progress', 'Completed'];
const _maintenanceTypes = ['Oil Change', 'Tire Replacement', 'Engine Repair', 'General Service', 'Brake Service', 'Body Work', 'Other'];
const _driverStatuses = ['On Duty', 'Off Duty', 'On Leave'];
const _licenseClasses = ['B', 'C', 'D', 'E'];

String _today() => DateTime.now().toIso8601String().substring(0, 10);
int _daysUntil(String dateStr) {
  final d = DateTime.tryParse(dateStr);
  if (d == null) return 9999;
  return d.difference(DateTime.now()).inDays;
}

Color _statusColor(String s) {
  switch (s) {
    case 'Active': case 'On Duty': case 'Completed': return AppColors.success;
    case 'Maintenance': case 'In Progress': case 'Scheduled': return AppColors.warning;
    case 'Retired': case 'Off Duty': return AppColors.textSecondary;
    case 'On Leave': case 'Upcoming': return AppColors.info;
    default: return AppColors.primary;
  }
}

Widget _chip(String text, Color color) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppRadius.sm)),
  child: Text(text, style: TextStyle(fontSize: AppFontSize.xs, color: color, fontWeight: FontWeight.w600)),
);

Widget _actionBtn(BuildContext context, String label, VoidCallback onPressed, {Color? color}) => SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(backgroundColor: color ?? AppColors.primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2)),
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

void _showFormModal(BuildContext context, String title, Widget formContent, VoidCallback onSubmit, {String submitLabel = 'Save'}) {
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

void _confirmDelete(BuildContext context, String message, VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Delete'),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel')),
        TextButton(style: TextButton.styleFrom(foregroundColor: AppColors.danger), onPressed: () { onConfirm(); Navigator.pop(ctx); }, child: Text('Delete')),
      ],
    ),
  );
}

class TransportDashboard extends StatelessWidget {
  final String pageKey;
  const TransportDashboard({super.key, required this.pageKey});

  @override
  Widget build(BuildContext context) {
    switch (pageKey) {
      case 'overview': return const _OverviewPage();
      case 'vehicles': return const _VehiclesPage();
      case 'trips': return const _TripsPage();
      case 'maintenance': return const _MaintenancePage();
      case 'fuel': return const _FuelPage();
      case 'drivers': return const _DriversPage();
      case 'reports': return const _ReportsPage();
      default: return PlaceholderPage(pageTitle: pageKey);
    }
  }
}

class _OverviewPage extends StatelessWidget {
  const _OverviewPage();
  @override
  Widget build(BuildContext context) {
    final t = context.watch<TransportProvider>();
    final expiringIns = t.expiringInsurance;
    final inProgress = t.inProgressMaintenance;
    final upcoming = t.upcomingMaintenance;

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Vehicles', value: '${t.vehicles.length}', icon: Icons.directions_bus, color: AppColors.primary),
          StatCard(label: 'In Maintenance', value: '${t.maintenanceVehicles}', icon: Icons.build, color: AppColors.warning),
          StatCard(label: 'Trips Logged', value: '${t.trips.length}', icon: Icons.route, color: AppColors.info),
          StatCard(label: 'On-Duty Drivers', value: '${t.onDutyDrivers}', icon: Icons.person, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        if (expiringIns.isNotEmpty) ...[
          _alertCard('Insurance Expiring Soon (${expiringIns.length})', expiringIns.map((v) {
            final days = _daysUntil(v.insuranceExpiry);
            return '${v.plate} \u2014 expires ${v.insuranceExpiry} (${days > 0 ? '$days days' : 'EXPIRED'})';
          }).join('\n'), AppColors.warning),
        ],
        if (inProgress.isNotEmpty) ...[
          _alertCard('Maintenance In Progress (${inProgress.length})', inProgress.map((m) => '${m.vehiclePlate} \u2014 ${m.type}${m.notes != null ? ' | ${m.notes}' : ''}').join('\n'), AppColors.danger),
        ],
        if (upcoming.isNotEmpty) ...[
          _alertCard('Upcoming Maintenance (${upcoming.length})', upcoming.map((m) => '${m.vehiclePlate} \u2014 ${m.type} due ${m.dueDate}').join('\n'), AppColors.info),
        ],
        const SizedBox(height: AppSpacing.md),
        Text('Fuel Summary', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Row(children: [
            Expanded(child: Column(children: [
              Text('GHS ${t.totalFuelCost.toStringAsFixed(0)}', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.danger)),
              Text('Total Cost', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            ])),
            Expanded(child: Column(children: [
              Text('${t.totalFuelLitres} L', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.info)),
              Text('Total Litres', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            ])),
            Expanded(child: Column(children: [
              Text('${t.fuelLogs.length}', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.primary)),
              Text('Fill-ups', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            ])),
          ]),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Quick Actions', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white), onPressed: () => _showTripModal(context, t), child: Text('+ Log Trip')),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white), onPressed: () => _showFuelModal(context, t), child: Text('+ Log Fuel')),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning, foregroundColor: Colors.white), onPressed: () => _showMaintModal(context, t), child: Text('+ Schedule Maint.')),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.info, foregroundColor: Colors.white), onPressed: () => _showVehicleModal(context, t), child: Text('+ Add Vehicle')),
        ]),
      ]),
    );
  }

  void _showTripModal(BuildContext context, TransportProvider t) {
    String vehiclePlate = t.vehicles.isNotEmpty ? t.vehicles.first.plate : '';
    String driverName = t.vehicles.isNotEmpty ? (t.vehicles.first.assignedDriver ?? '') : '';
    final routeCtrl = TextEditingController();
    final mileageCtrl = TextEditingController();
    final purposeCtrl = TextEditingController();
    final depCtrl = TextEditingController(text: '08:00');
    final retCtrl = TextEditingController();
    _showFormModal(context, 'Log New Trip', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _pickerChips('Vehicle', vehiclePlate, t.vehicles.map((v) => v.plate).toList(), (v) {
          final veh = t.vehicles.firstWhere((x) => x.plate == v);
          setState(() { vehiclePlate = v; driverName = veh.assignedDriver ?? ''; });
        }),
        const SizedBox(height: AppSpacing.sm),
        _formField('Driver Name', TextEditingController(text: driverName)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Route *', routeCtrl, hint: 'e.g. Campus -> Kumasi'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Mileage (km) *', mileageCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _formField('Purpose', purposeCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Departure Time', depCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Return Time', retCtrl, hint: 'Optional'),
      ],
    )), () {
      if (routeCtrl.text.isEmpty || mileageCtrl.text.isEmpty) return;
      t.addTrip(vehiclePlate: vehiclePlate, driverName: driverName, route: routeCtrl.text, mileage: int.tryParse(mileageCtrl.text) ?? 0, purpose: purposeCtrl.text, departureTime: depCtrl.text, returnTime: retCtrl.text.isEmpty ? null : retCtrl.text);
    });
  }

  void _showFuelModal(BuildContext context, TransportProvider t) {
    String vehiclePlate = t.vehicles.isNotEmpty ? t.vehicles.first.plate : '';
    final litresCtrl = TextEditingController();
    final costCtrl = TextEditingController(text: '14');
    final odoCtrl = TextEditingController();
    final filledByCtrl = TextEditingController();
    _showFormModal(context, 'Log Fuel Entry', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _pickerChips('Vehicle', vehiclePlate, t.vehicles.map((v) => v.plate).toList(), (v) => setState(() => vehiclePlate = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Litres *', litresCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _formField('Cost per Litre (GHS)', costCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _formField('Odometer (km)', odoCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _formField('Filled By', filledByCtrl, hint: 'Driver/officer name'),
      ],
    )), () {
      if (litresCtrl.text.isEmpty) return;
      t.addFuelLog(vehiclePlate: vehiclePlate, litres: int.tryParse(litresCtrl.text) ?? 0, costPerLitre: double.tryParse(costCtrl.text) ?? 14, odometer: int.tryParse(odoCtrl.text), filledBy: filledByCtrl.text.isEmpty ? 'Transport Officer' : filledByCtrl.text);
    });
  }

  void _showMaintModal(BuildContext context, TransportProvider t) {
    String vehiclePlate = t.vehicles.isNotEmpty ? t.vehicles.first.plate : '';
    String type = _maintenanceTypes[0];
    final dueCtrl = TextEditingController(text: _today());
    final costCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    _showFormModal(context, 'Schedule Maintenance', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _pickerChips('Vehicle', vehiclePlate, t.vehicles.map((v) => v.plate).toList(), (v) => setState(() => vehiclePlate = v)),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Maintenance Type', type, _maintenanceTypes, (v) => setState(() => type = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Due Date', dueCtrl, hint: 'YYYY-MM-DD'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Estimated Cost (GHS)', costCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _formField('Notes', notesCtrl, multiline: true),
      ],
    )), () {
      t.addMaintenance(vehiclePlate: vehiclePlate, type: type, dueDate: dueCtrl.text, cost: costCtrl.text.isEmpty ? null : double.tryParse(costCtrl.text), notes: notesCtrl.text.isEmpty ? null : notesCtrl.text);
    });
  }

  void _showVehicleModal(BuildContext context, TransportProvider t) {
    String type = _vehicleTypes[0];
    String status = _vehicleStatuses[0];
    final plateCtrl = TextEditingController();
    final insCtrl = TextEditingController(text: '2026-12-31');
    final rwCtrl = TextEditingController(text: '2026-12-31');
    final driverCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    _showFormModal(context, 'Add Vehicle', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Plate Number *', plateCtrl, hint: 'e.g. GV-1122-1'),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Vehicle Type', type, _vehicleTypes, (v) => setState(() => type = v)),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Status', status, _vehicleStatuses, (v) => setState(() => status = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Insurance Expiry', insCtrl, hint: 'YYYY-MM-DD'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Roadworthiness Expiry', rwCtrl, hint: 'YYYY-MM-DD'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Assigned Driver', driverCtrl, hint: 'Optional'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Notes', notesCtrl, multiline: true),
      ],
    )), () {
      if (plateCtrl.text.isEmpty) return;
      t.addVehicle(plate: plateCtrl.text, type: type, insuranceExpiry: insCtrl.text, roadworthinessExpiry: rwCtrl.text, status: status, assignedDriver: driverCtrl.text.isEmpty ? null : driverCtrl.text, notes: notesCtrl.text.isEmpty ? null : notesCtrl.text);
    });
  }
}

class _VehiclesPage extends StatelessWidget {
  const _VehiclesPage();
  @override
  Widget build(BuildContext context) {
    final t = context.watch<TransportProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total', value: '${t.vehicles.length}', icon: Icons.directions_bus, color: AppColors.primary),
          StatCard(label: 'Active', value: '${t.activeVehicles}', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Maintenance', value: '${t.maintenanceVehicles}', icon: Icons.build, color: AppColors.warning),
          StatCard(label: 'Retired', value: '${t.vehicles.where((v) => v.status == 'Retired').length}', icon: Icons.block, color: AppColors.textSecondary),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Add Vehicle', () => _showVehicleModal(context, t)),
        const SizedBox(height: AppSpacing.lg),
        Text('Vehicle Registry', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        ...t.vehicles.map((v) {
          final insDays = _daysUntil(v.insuranceExpiry);
          final rwDays = _daysUntil(v.roadworthinessExpiry);
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: _statusColor(v.status), width: 4))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(v.plate, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.text)),
                  Text(v.type, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  Text('Insurance: ${v.insuranceExpiry} (${insDays > 0 ? '${insDays}d left' : 'EXPIRED'})', style: TextStyle(fontSize: AppFontSize.sm, color: insDays < 30 ? AppColors.danger : AppColors.textSecondary)),
                  Text('Roadworthiness: ${v.roadworthinessExpiry} (${rwDays > 0 ? '${rwDays}d left' : 'EXPIRED'})', style: TextStyle(fontSize: AppFontSize.sm, color: rwDays < 30 ? AppColors.danger : AppColors.textSecondary)),
                  if (v.assignedDriver != null) Text('Driver: ${v.assignedDriver}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  if (v.notes != null) Text(v.notes!, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
                ])),
                _chip(v.status, _statusColor(v.status)),
              ]),
              const SizedBox(height: AppSpacing.sm),
              Row(children: [
                GestureDetector(onTap: () {
                  final idx = _vehicleStatuses.indexOf(v.status);
                  final next = _vehicleStatuses[(idx + 1) % _vehicleStatuses.length];
                  t.updateVehicleStatus(v.id, next);
                }, child: Text('Status: ${v.status} \u2192', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600))),
                const SizedBox(width: AppSpacing.md),
                GestureDetector(onTap: () => _confirmDelete(context, 'Delete vehicle ${v.plate}?', () => t.deleteVehicle(v.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
              ]),
            ]),
          );
        }),
      ]),
    );
  }

  void _showVehicleModal(BuildContext context, TransportProvider t) {
    String type = _vehicleTypes[0];
    String status = _vehicleStatuses[0];
    final plateCtrl = TextEditingController();
    final insCtrl = TextEditingController(text: '2026-12-31');
    final rwCtrl = TextEditingController(text: '2026-12-31');
    final driverCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    _showFormModal(context, 'Add Vehicle', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Plate Number *', plateCtrl, hint: 'e.g. GV-1122-1'),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Vehicle Type', type, _vehicleTypes, (v) => setState(() => type = v)),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Status', status, _vehicleStatuses, (v) => setState(() => status = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Insurance Expiry', insCtrl, hint: 'YYYY-MM-DD'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Roadworthiness Expiry', rwCtrl, hint: 'YYYY-MM-DD'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Assigned Driver', driverCtrl, hint: 'Optional'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Notes', notesCtrl, multiline: true),
      ],
    )), () {
      if (plateCtrl.text.isEmpty) return;
      t.addVehicle(plate: plateCtrl.text, type: type, insuranceExpiry: insCtrl.text, roadworthinessExpiry: rwCtrl.text, status: status, assignedDriver: driverCtrl.text.isEmpty ? null : driverCtrl.text, notes: notesCtrl.text.isEmpty ? null : notesCtrl.text);
    });
  }
}

class _TripsPage extends StatelessWidget {
  const _TripsPage();
  @override
  Widget build(BuildContext context) {
    final t = context.watch<TransportProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Trips', value: '${t.trips.length}', icon: Icons.route, color: AppColors.primary),
          StatCard(label: 'Total Mileage', value: '${t.totalMileage} km', icon: Icons.speed, color: AppColors.success),
          StatCard(label: 'Active Vehicles', value: '${t.activeVehicles}', icon: Icons.directions_bus, color: AppColors.warning),
          StatCard(label: 'Drivers', value: '${t.drivers.length}', icon: Icons.person, color: AppColors.info),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Log New Trip', () => _showTripModal(context, t)),
        const SizedBox(height: AppSpacing.lg),
        Text('Trip History', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        if (t.trips.isEmpty)
          Text('No trips logged.', style: TextStyle(color: AppColors.textSecondary))
        else
          ...t.trips.map((tr) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${tr.date} \u2014 ${tr.vehiclePlate}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
              Text('${tr.route} (${tr.mileage} km)', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              Text('Driver: ${tr.driverName} | Purpose: ${tr.purpose}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              Text('Departure: ${tr.departureTime}${tr.returnTime != null ? ' | Return: ${tr.returnTime}' : ''}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(onTap: () => _confirmDelete(context, 'Delete this trip?', () => t.deleteTrip(tr.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
            ]),
          )),
      ]),
    );
  }

  void _showTripModal(BuildContext context, TransportProvider t) {
    String vehiclePlate = t.vehicles.isNotEmpty ? t.vehicles.first.plate : '';
    String driverName = t.vehicles.isNotEmpty ? (t.vehicles.first.assignedDriver ?? '') : '';
    final routeCtrl = TextEditingController();
    final mileageCtrl = TextEditingController();
    final purposeCtrl = TextEditingController();
    final depCtrl = TextEditingController(text: '08:00');
    final retCtrl = TextEditingController();
    _showFormModal(context, 'Log New Trip', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _pickerChips('Vehicle', vehiclePlate, t.vehicles.map((v) => v.plate).toList(), (v) {
          final veh = t.vehicles.firstWhere((x) => x.plate == v);
          setState(() { vehiclePlate = v; driverName = veh.assignedDriver ?? ''; });
        }),
        const SizedBox(height: AppSpacing.sm),
        _formField('Driver Name', TextEditingController(text: driverName)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Route *', routeCtrl, hint: 'e.g. Campus -> Kumasi'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Mileage (km) *', mileageCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _formField('Purpose', purposeCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Departure Time', depCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Return Time', retCtrl, hint: 'Optional'),
      ],
    )), () {
      if (routeCtrl.text.isEmpty || mileageCtrl.text.isEmpty) return;
      t.addTrip(vehiclePlate: vehiclePlate, driverName: driverName, route: routeCtrl.text, mileage: int.tryParse(mileageCtrl.text) ?? 0, purpose: purposeCtrl.text, departureTime: depCtrl.text, returnTime: retCtrl.text.isEmpty ? null : retCtrl.text);
    });
  }
}

class _MaintenancePage extends StatelessWidget {
  const _MaintenancePage();
  @override
  Widget build(BuildContext context) {
    final t = context.watch<TransportProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Records', value: '${t.maintenance.length}', icon: Icons.build, color: AppColors.primary),
          StatCard(label: 'In Progress', value: '${t.inProgressMaintenance.length}', icon: Icons.pending, color: AppColors.danger),
          StatCard(label: 'Upcoming', value: '${t.upcomingMaintenance.length}', icon: Icons.schedule, color: AppColors.warning),
          StatCard(label: 'Completed', value: '${t.maintenance.where((m) => m.status == 'Completed').length}', icon: Icons.check_circle, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Schedule Maintenance', () => _showMaintModal(context, t), color: AppColors.warning),
        const SizedBox(height: AppSpacing.lg),
        Text('Maintenance Schedule', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        ...t.maintenance.map((m) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: _statusColor(m.status), width: 4))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${m.vehiclePlate} \u2014 ${m.type}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
                Text('Due: ${m.dueDate}${m.completedDate != null ? ' | Completed: ${m.completedDate}' : ''}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                if (m.cost != null) Text('Cost: GHS ${m.cost!.toStringAsFixed(2)}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                if (m.notes != null) Text(m.notes!, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
              ])),
              _chip(m.status, _statusColor(m.status)),
            ]),
            const SizedBox(height: AppSpacing.sm),
            Row(children: [
              GestureDetector(onTap: () {
                final idx = _maintenanceStatuses.indexOf(m.status);
                final next = _maintenanceStatuses[(idx + 1) % _maintenanceStatuses.length];
                t.updateMaintenanceStatus(m.id, next);
              }, child: Text('Status: ${m.status} \u2192', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600))),
              const SizedBox(width: AppSpacing.md),
              GestureDetector(onTap: () => _confirmDelete(context, 'Delete maintenance record for ${m.vehiclePlate}?', () => t.deleteMaintenance(m.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
            ]),
          ]),
        )),
      ]),
    );
  }

  void _showMaintModal(BuildContext context, TransportProvider t) {
    String vehiclePlate = t.vehicles.isNotEmpty ? t.vehicles.first.plate : '';
    String type = _maintenanceTypes[0];
    final dueCtrl = TextEditingController(text: _today());
    final costCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    _showFormModal(context, 'Schedule Maintenance', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _pickerChips('Vehicle', vehiclePlate, t.vehicles.map((v) => v.plate).toList(), (v) => setState(() => vehiclePlate = v)),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Maintenance Type', type, _maintenanceTypes, (v) => setState(() => type = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Due Date', dueCtrl, hint: 'YYYY-MM-DD'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Estimated Cost (GHS)', costCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _formField('Notes', notesCtrl, multiline: true),
      ],
    )), () {
      t.addMaintenance(vehiclePlate: vehiclePlate, type: type, dueDate: dueCtrl.text, cost: costCtrl.text.isEmpty ? null : double.tryParse(costCtrl.text), notes: notesCtrl.text.isEmpty ? null : notesCtrl.text);
    });
  }
}

class _FuelPage extends StatelessWidget {
  const _FuelPage();
  @override
  Widget build(BuildContext context) {
    final t = context.watch<TransportProvider>();
    final avgFill = t.fuelLogs.isNotEmpty ? (t.totalFuelLitres / t.fuelLogs.length).round() : 0;
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Cost', value: 'GHS ${t.totalFuelCost.toStringAsFixed(0)}', icon: Icons.payments, color: AppColors.danger),
          StatCard(label: 'Total Litres', value: '${t.totalFuelLitres} L', icon: Icons.local_gas_station, color: AppColors.info),
          StatCard(label: 'Fill-ups', value: '${t.fuelLogs.length}', icon: Icons.receipt, color: AppColors.primary),
          StatCard(label: 'Avg/Fill', value: '$avgFill L', icon: Icons.trending_up, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Log Fuel', () => _showFuelModal(context, t)),
        const SizedBox(height: AppSpacing.lg),
        Text('Fuel Log', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        ...t.fuelLogs.map((f) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${f.date} \u2014 ${f.vehiclePlate}', style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.w600, color: AppColors.text)),
              Text('${f.litres} L @ GHS ${f.costPerLitre.toStringAsFixed(2)}/L = GHS ${f.totalCost.toStringAsFixed(2)}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              if (f.odometer > 0) Text('Odometer: ${f.odometer} km', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
              Text('Filled by: ${f.filledBy}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
            ])),
            GestureDetector(onTap: () => _confirmDelete(context, 'Delete fuel log for ${f.vehiclePlate}?', () => t.deleteFuelLog(f.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
          ]),
        )),
      ]),
    );
  }

  void _showFuelModal(BuildContext context, TransportProvider t) {
    String vehiclePlate = t.vehicles.isNotEmpty ? t.vehicles.first.plate : '';
    final litresCtrl = TextEditingController();
    final costCtrl = TextEditingController(text: '14');
    final odoCtrl = TextEditingController();
    final filledByCtrl = TextEditingController();
    _showFormModal(context, 'Log Fuel Entry', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _pickerChips('Vehicle', vehiclePlate, t.vehicles.map((v) => v.plate).toList(), (v) => setState(() => vehiclePlate = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Litres *', litresCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _formField('Cost per Litre (GHS)', costCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _formField('Odometer (km)', odoCtrl, keyboardType: TextInputType.number),
        const SizedBox(height: AppSpacing.sm),
        _formField('Filled By', filledByCtrl, hint: 'Driver/officer name'),
      ],
    )), () {
      if (litresCtrl.text.isEmpty) return;
      t.addFuelLog(vehiclePlate: vehiclePlate, litres: int.tryParse(litresCtrl.text) ?? 0, costPerLitre: double.tryParse(costCtrl.text) ?? 14, odometer: int.tryParse(odoCtrl.text), filledBy: filledByCtrl.text.isEmpty ? 'Transport Officer' : filledByCtrl.text);
    });
  }
}

class _DriversPage extends StatelessWidget {
  const _DriversPage();
  @override
  Widget build(BuildContext context) {
    final t = context.watch<TransportProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Drivers', value: '${t.drivers.length}', icon: Icons.person, color: AppColors.primary),
          StatCard(label: 'On Duty', value: '${t.onDutyDrivers}', icon: Icons.check_circle, color: AppColors.success),
          StatCard(label: 'Off Duty', value: '${t.drivers.where((d) => d.status == 'Off Duty').length}', icon: Icons.pause_circle, color: AppColors.textSecondary),
          StatCard(label: 'On Leave', value: '${t.drivers.where((d) => d.status == 'On Leave').length}', icon: Icons.beach_access, color: AppColors.warning),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, '+ Add Driver', () => _showDriverModal(context, t)),
        const SizedBox(height: AppSpacing.lg),
        Text('Driver Roster', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        ...t.drivers.map((d) {
          final licDays = _daysUntil(d.licenseExpiry);
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md), border: Border(left: BorderSide(color: _statusColor(d.status), width: 4))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(d.name, style: TextStyle(fontSize: AppFontSize.md, fontWeight: FontWeight.bold, color: AppColors.text)),
                  Text('Phone: ${d.phone} | License: Class ${d.license}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  Text('License Expiry: ${d.licenseExpiry} (${licDays > 0 ? '${licDays}d left' : 'EXPIRED'})', style: TextStyle(fontSize: AppFontSize.sm, color: licDays < 30 ? AppColors.danger : AppColors.textSecondary)),
                  Text('Assigned: ${d.assignedVehicle.isEmpty ? 'Unassigned' : d.assignedVehicle}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                  if (d.dutyStart != null) Text('Duty: ${d.dutyStart}${d.dutyEnd != null ? ' - ${d.dutyEnd}' : ''}', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary)),
                ])),
                _chip(d.status, _statusColor(d.status)),
              ]),
              const SizedBox(height: AppSpacing.sm),
              Row(children: [
                GestureDetector(onTap: () {
                  final idx = _driverStatuses.indexOf(d.status);
                  final next = _driverStatuses[(idx + 1) % _driverStatuses.length];
                  t.updateDriverStatus(d.id, next);
                }, child: Text('Status: ${d.status} \u2192', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.primary, fontWeight: FontWeight.w600))),
                const SizedBox(width: AppSpacing.md),
                GestureDetector(onTap: () => _confirmDelete(context, 'Delete driver ${d.name}?', () => t.deleteDriver(d.id)), child: Text('Delete', style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.danger, fontWeight: FontWeight.w600))),
              ]),
            ]),
          );
        }),
      ]),
    );
  }

  void _showDriverModal(BuildContext context, TransportProvider t) {
    String license = _licenseClasses[1];
    String status = _driverStatuses[1];
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final licExpCtrl = TextEditingController(text: '2027-12-31');
    final vehicleCtrl = TextEditingController();
    final dutyStartCtrl = TextEditingController();
    final dutyEndCtrl = TextEditingController();
    _showFormModal(context, 'Add Driver', StatefulBuilder(builder: (ctx, setState) => Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        _formField('Driver Name *', nameCtrl),
        const SizedBox(height: AppSpacing.sm),
        _formField('Phone', phoneCtrl),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('License Class', license, _licenseClasses, (v) => setState(() => license = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('License Expiry', licExpCtrl, hint: 'YYYY-MM-DD'),
        const SizedBox(height: AppSpacing.sm),
        _pickerChips('Status', status, _driverStatuses, (v) => setState(() => status = v)),
        const SizedBox(height: AppSpacing.sm),
        _formField('Assigned Vehicle Plate', vehicleCtrl, hint: 'e.g. GV-1122-1'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Duty Start Time', dutyStartCtrl, hint: 'e.g. 08:00'),
        const SizedBox(height: AppSpacing.sm),
        _formField('Duty End Time', dutyEndCtrl, hint: 'e.g. 16:00'),
      ],
    )), () {
      if (nameCtrl.text.isEmpty) return;
      t.addDriver(name: nameCtrl.text, phone: phoneCtrl.text, license: license, licenseExpiry: licExpCtrl.text, assignedVehicle: vehicleCtrl.text, status: status, dutyStart: dutyStartCtrl.text.isEmpty ? null : dutyStartCtrl.text, dutyEnd: dutyEndCtrl.text.isEmpty ? null : dutyEndCtrl.text);
    });
  }
}

class _ReportsPage extends StatelessWidget {
  const _ReportsPage();
  @override
  Widget build(BuildContext context) {
    final t = context.watch<TransportProvider>();
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        StatCardGrid(cards: [
          StatCard(label: 'Total Vehicles', value: '${t.vehicles.length}', icon: Icons.directions_bus, color: AppColors.primary),
          StatCard(label: 'Total Trips', value: '${t.trips.length}', icon: Icons.route, color: AppColors.info),
          StatCard(label: 'Fuel Cost', value: 'GHS ${t.totalFuelCost.toStringAsFixed(0)}', icon: Icons.local_gas_station, color: AppColors.danger),
          StatCard(label: 'Drivers', value: '${t.drivers.length}', icon: Icons.person, color: AppColors.success),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _actionBtn(context, 'Generate Full Report', () {}),
        const SizedBox(height: AppSpacing.md),
        Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
          _reportBtn('Activity Summary', AppColors.primary),
          _reportBtn('Vehicle Registry', AppColors.info),
          _reportBtn('Trip Log', AppColors.success),
          _reportBtn('Maintenance', AppColors.warning),
          _reportBtn('Fuel Log', AppColors.danger),
          _reportBtn('Driver Roster', AppColors.purple),
        ]),
        const SizedBox(height: AppSpacing.lg),
        _breakdownChart(context, 'Vehicle Status Breakdown', _vehicleStatuses, (st) => t.vehicles.where((v) => v.status == st).length, t.vehicles.length, _statusColor),
        const SizedBox(height: AppSpacing.lg),
        _breakdownChart(context, 'Maintenance Status', _maintenanceStatuses, (st) => t.maintenance.where((m) => m.status == st).length, t.maintenance.length, _statusColor),
        const SizedBox(height: AppSpacing.lg),
        _breakdownChart(context, 'Driver Status', _driverStatuses, (st) => t.drivers.where((d) => d.status == st).length, t.drivers.length, _statusColor),
        const SizedBox(height: AppSpacing.lg),
        Text('Fuel Cost by Vehicle', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        Container(padding: const EdgeInsets.all(AppSpacing.md), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Column(children: t.vehicles.map((v) {
            final vCost = t.fuelLogs.where((f) => f.vehiclePlate == v.plate).fold(0.0, (s, f) => s + f.totalCost);
            final pct = t.totalFuelCost > 0 ? (vCost / t.totalFuelCost * 100).round() : 0;
            return Padding(padding: const EdgeInsets.only(bottom: AppSpacing.sm), child: Row(children: [
              SizedBox(width: 100, child: Text(v.plate, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary))),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Container(height: 10, decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.sm)), child: FractionallySizedBox(alignment: Alignment.centerLeft, widthFactor: pct / 100, child: Container(decoration: BoxDecoration(color: AppColors.danger, borderRadius: BorderRadius.circular(AppRadius.sm)))))),              const SizedBox(width: AppSpacing.sm),
              SizedBox(width: 60, child: Text('GHS ${vCost.toStringAsFixed(0)}', textAlign: TextAlign.right, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.text))),
            ]));
          }).toList()),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Mileage by Vehicle', style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
        const SizedBox(height: AppSpacing.sm),
        Container(padding: const EdgeInsets.all(AppSpacing.md), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
          child: Column(children: t.vehicles.map((v) {
            final vMileage = t.trips.where((tr) => tr.vehiclePlate == v.plate).fold(0, (s, tr) => s + tr.mileage);
            final pct = t.totalMileage > 0 ? (vMileage / t.totalMileage * 100).round() : 0;
            return Padding(padding: const EdgeInsets.only(bottom: AppSpacing.sm), child: Row(children: [
              SizedBox(width: 100, child: Text(v.plate, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary))),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Container(height: 10, decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.sm)), child: FractionallySizedBox(alignment: Alignment.centerLeft, widthFactor: pct / 100, child: Container(decoration: BoxDecoration(color: AppColors.info, borderRadius: BorderRadius.circular(AppRadius.sm)))))),              const SizedBox(width: AppSpacing.sm),
              SizedBox(width: 50, child: Text('$vMileage km', textAlign: TextAlign.right, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.text))),
            ]));
          }).toList()),
        ),
      ]),
    );
  }

  Widget _reportBtn(String label, Color color) => ElevatedButton(
    style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm)),
    onPressed: () {},
    child: Text(label, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600)),
  );

  Widget _breakdownChart(BuildContext context, String title, List<String> statuses, int Function(String) countFn, int total, Color Function(String) colorFn) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: TextStyle(fontSize: AppFontSize.lg, fontWeight: FontWeight.bold, color: AppColors.text)),
      const SizedBox(height: AppSpacing.sm),
      Container(padding: const EdgeInsets.all(AppSpacing.md), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(AppRadius.md)),
        child: Column(children: statuses.map((st) {
          final count = countFn(st);
          final pct = total > 0 ? (count / total * 100).round() : 0;
          return Padding(padding: const EdgeInsets.only(bottom: AppSpacing.sm), child: Row(children: [
            SizedBox(width: 100, child: Text(st, style: TextStyle(fontSize: AppFontSize.sm, color: AppColors.textSecondary))),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Container(height: 10, decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.sm)), child: FractionallySizedBox(alignment: Alignment.centerLeft, widthFactor: pct / 100, child: Container(decoration: BoxDecoration(color: colorFn(st), borderRadius: BorderRadius.circular(AppRadius.sm)))))),            const SizedBox(width: AppSpacing.sm),
            SizedBox(width: 30, child: Text('$count', textAlign: TextAlign.right, style: TextStyle(fontSize: AppFontSize.sm, fontWeight: FontWeight.w600, color: AppColors.text))),
          ]));
        }).toList()),
      ),
    ]);
  }
}
