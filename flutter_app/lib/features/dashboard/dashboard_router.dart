import 'package:flutter/material.dart';
import '../../core/navigation/dashboard_catalog.dart';
import '../../core/navigation/role_map.dart';
import '../../core/types/types.dart';
import '../../core/widgets/dashboard_layout.dart';
import '../dashboards/dashboards.dart';

/// Routes authenticated users to their dashboard based on activeRole.
class DashboardRouter extends StatefulWidget {
  final AuthUser user;
  final VoidCallback onLogout;
  final ValueChanged<RoleId> onSwitchRole;

  const DashboardRouter({
    super.key,
    required this.user,
    required this.onLogout,
    required this.onSwitchRole,
  });

  @override
  State<DashboardRouter> createState() => _DashboardRouterState();
}

class _DashboardRouterState extends State<DashboardRouter> {
  String _activeKey = 'overview';

  @override
  void didUpdateWidget(DashboardRouter oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset to first page when role changes
    if (oldWidget.user.activeRole != widget.user.activeRole) {
      final dashKey = roleToDashboardKey(widget.user.activeRole);
      final dash = dashboardMap[dashKey];
      if (dash != null && dash.pages.isNotEmpty) {
        _activeKey = dash.pages.first.key;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashKey = roleToDashboardKey(widget.user.activeRole);
    final dash = dashboardMap[dashKey] ??
        dashboardCatalog.first; // fallback to Headmaster

    final navItems = dash.pages
        .map((p) => NavItem(key: p.key, label: p.label))
        .toList();

    // Ensure activeKey is valid for this dashboard
    if (!navItems.any((n) => n.key == _activeKey)) {
      _activeKey = navItems.isNotEmpty ? navItems.first.key : 'overview';
    }

    return DashboardLayout(
      title: dash.label,
      navItems: navItems,
      activeKey: _activeKey,
      onNavigate: (key) => setState(() => _activeKey = key),
      user: widget.user,
      onLogout: widget.onLogout,
      onSwitchRole: widget.onSwitchRole,
      child: _buildPageContent(dash, _activeKey),
    );
  }

  Widget _buildPageContent(DashboardDef dash, String pageKey) {
    final page = dash.pages.where((p) => p.key == pageKey).firstOrNull;
    final pageTitle = page?.label ?? pageKey;

    // Route to the appropriate dashboard widget based on dashboard key.
    switch (dash.key) {
      case 'Headmaster':
        return HeadmasterDashboard(pageKey: pageKey);
      case 'Academic':
        return AcademicDashboard(pageKey: pageKey);
      case 'Bursary':
        return BursaryDashboard(pageKey: pageKey);
      case 'Accountant':
        return AccountantDashboard(pageKey: pageKey);
      case 'Registry':
        return RegistryDashboard(pageKey: pageKey);
      case 'Admin':
        return AdminDashboard(pageKey: pageKey);
      case 'Stores':
        return StoresDashboard(pageKey: pageKey);
      case 'Security':
        return SecurityDashboard(pageKey: pageKey);
      case 'House':
      case 'SeniorHousemaster':
        return HouseDashboard(pageKey: pageKey);
      case 'Catering':
        return CateringDashboard(pageKey: pageKey);
      case 'Transport':
        return TransportDashboard(pageKey: pageKey);
      case 'Cleaning':
        return CleaningDashboard(pageKey: pageKey);
      case 'Counselling':
        return CounsellingDashboard(pageKey: pageKey);
      case 'LibraryICT':
        return LibraryDashboard(pageKey: pageKey);
      case 'SportsClubs':
        return SportsDashboard(pageKey: pageKey);
      case 'PLC':
        return PLCDashboard(pageKey: pageKey);
      case 'Teacher':
        return TeacherDashboard(pageKey: pageKey);
      case 'PTA':
        return PtaDashboard(pageKey: pageKey);
      case 'SystemAdmin':
        return SystemAdminDashboard(pageKey: pageKey);
      case 'Chaplain':
        return ChaplainDashboard(pageKey: pageKey);
      case 'AcademicBoard':
        return AcademicBoardDashboard(pageKey: pageKey);
      case 'DiningHall':
        return DiningHallDashboard(pageKey: pageKey);
      case 'ExamCommittee':
        return ExamCommitteeDashboard(pageKey: pageKey);
      case 'SafeSpace':
        return SafeSpaceDashboard(pageKey: pageKey);
      case 'InternalAuditor':
        return InternalAuditorDashboard(pageKey: pageKey);
      case 'HeadmasterSecretary':
        return HeadmasterSecretaryDashboard(pageKey: pageKey);
      case 'Domestic':
        return DomesticDashboard(pageKey: pageKey);
      case 'Health':
        return HealthDashboard(pageKey: pageKey);
      case 'Student':
        return StudentDashboard(pageKey: pageKey);
      case 'Parent':
        return ParentDashboard(pageKey: pageKey);
      case 'SRC':
        return SrcDashboard(pageKey: pageKey);
      case 'ElectoralCommission':
        return ElectoralDashboard(pageKey: pageKey);
      case 'Staff':
        return StaffDashboard(pageKey: pageKey);
      case 'SubjectHOD':
        return SubjectHodDashboard(pageKey: pageKey);
      case 'GoverningBoard':
        return GoverningBoardDashboard(pageKey: pageKey);
      case 'WelfareCommittee':
        return WelfareDashboard(pageKey: pageKey);
      default:
        return GenericDashboard(
          dashboardKey: dash.key,
          dashboardLabel: dash.label,
          pageKey: pageKey,
          pageTitle: pageTitle,
        );
    }
  }
}
