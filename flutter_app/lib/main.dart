import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/state/auth_provider.dart';
import 'core/state/registry_provider.dart';
import 'core/state/bursary_provider.dart';
import 'core/state/academic_provider.dart';
import 'core/state/notification_provider.dart';
import 'core/state/security_provider.dart';
import 'core/state/transport_provider.dart';
import 'core/state/cleaning_provider.dart';
import 'core/state/counselling_provider.dart';
import 'core/state/library_provider.dart';
import 'core/state/sports_provider.dart';
import 'core/state/boarding_provider.dart';
import 'core/state/kitchen_provider.dart';
import 'core/state/plc_provider.dart';
import 'core/state/admin_provider.dart';
import 'core/state/teacher_provider.dart';
import 'core/state/pta_provider.dart';
import 'core/state/system_admin_provider.dart';
import 'core/state/chaplain_provider.dart';
import 'core/state/dynamic_dashboard_provider.dart';
import 'core/state/health_provider.dart';
import 'core/state/student_provider.dart';
import 'core/state/parent_provider.dart';
import 'core/state/src_electoral_provider.dart';
import 'core/state/misc_providers.dart';
import 'core/state/bursar_provider.dart';
import 'core/state/requisition_provider.dart';
import 'core/state/access_control_provider.dart';
import 'core/state/headmaster_provider.dart';
import 'features/login/login_screen.dart';
import 'features/dashboard/dashboard_router.dart';
import 'features/verification/verification_dashboard.dart';

void main() {
  runApp(const SIMSApp());
}

class SIMSApp extends StatelessWidget {
  const SIMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RegistryProvider()),
        ChangeNotifierProvider(create: (_) => BursaryProvider()),
        ChangeNotifierProvider(create: (_) => AcademicProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => SecurityProvider()),
        ChangeNotifierProvider(create: (_) => TransportProvider()),
        ChangeNotifierProvider(create: (_) => CleaningProvider()),
        ChangeNotifierProvider(create: (_) => CounsellingProvider()),
        ChangeNotifierProvider(create: (_) => LibraryProvider()),
        ChangeNotifierProvider(create: (_) => SportsProvider()),
        ChangeNotifierProvider(create: (_) => BoardingProvider()),
        ChangeNotifierProvider(create: (_) => KitchenProvider()),
        ChangeNotifierProvider(create: (_) => PLCProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => TeacherProvider()),
        ChangeNotifierProvider(create: (_) => PtaProvider()),
        ChangeNotifierProvider(create: (_) => SystemAdminProvider()),
        ChangeNotifierProvider(create: (_) => ChaplainProvider()),
        ChangeNotifierProvider(create: (_) => DynamicDashboardProvider()),
        ChangeNotifierProvider(create: (_) => HealthProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => ParentProvider()),
        ChangeNotifierProvider(create: (_) => SrcProvider()),
        ChangeNotifierProvider(create: (_) => ElectoralProvider()),
        ChangeNotifierProvider(create: (_) => StaffProvider()),
        ChangeNotifierProvider(create: (_) => HodProvider()),
        ChangeNotifierProvider(create: (_) => GoverningBoardProvider()),
        ChangeNotifierProvider(create: (_) => WelfareProvider()),
        ChangeNotifierProvider(create: (_) => BursarProvider()),
        ChangeNotifierProvider(create: (_) => RequisitionProvider()),
        ChangeNotifierProvider(create: (_) => AccessControlProvider()),
        ChangeNotifierProvider(create: (_) => HeadmasterProvider()),
      ],
      child: MaterialApp(
        title: 'SIMS',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const AppRouter(),
      ),
    );
  }
}

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!auth.isAuthenticated || auth.user == null) {
          return const LoginScreen();
        }

        if (auth.isTempLogin) {
          return const VerificationDashboard();
        }

        return DashboardRouter(
          user: auth.user!,
          onLogout: auth.logout,
          onSwitchRole: auth.switchRole,
        );
      },
    );
  }
}
