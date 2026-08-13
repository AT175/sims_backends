import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/state/auth_provider.dart';
import '../../core/api/api.dart';
/// Login screen with three panels: Staff Login, Admission Application, Status Check.
///
/// Mirrors the React Native LoginScreen.tsx but adapted for Flutter/Material.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _wardNameController = TextEditingController();
  final _placementRefController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _parentPhoneController = TextEditingController();
  final _parentEmailController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSubmittingAdmission = false;
  String? _admissionResult;
  String? _admissionError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _wardNameController.dispose();
    _placementRefController.dispose();
    _parentNameController.dispose();
    _parentPhoneController.dispose();
    _parentEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryDark, AppColors.primary, AppColors.primaryLight],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.xxl),
                    boxShadow: AppShadows.xl,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(),
                      if (auth.error != null) _buildErrorBanner(auth.error!),
                      TabBar(
                        controller: _tabController,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: AppColors.textSecondary,
                        indicatorColor: AppColors.accent,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: AppFontSize.sm),
                        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: AppFontSize.sm),
                        tabs: const [
                          Tab(text: 'Staff Login'),
                          Tab(text: 'Admission'),
                          Tab(text: 'Status'),
                        ],
                      ),
                      SizedBox(
                        height: 420,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildLoginTab(auth),
                            _buildAdmissionTab(),
                            _buildStatusTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.xl,
        bottom: AppSpacing.lg,
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.accent, AppColors.accentLight],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'SIMS',
                style: TextStyle(
                  fontSize: AppFontSize.xs,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'School Information\nManagement System',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSize.lg,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
              height: 1.3,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Sign in to access your dashboard',
            style: TextStyle(
              fontSize: AppFontSize.sm,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String error) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      padding: const EdgeInsets.all(AppSpacing.sm + 2),
      decoration: BoxDecoration(
        color: AppColors.dangerBg,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.danger, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(
                fontSize: AppFontSize.sm,
                color: AppColors.danger,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () =>
                context.read<AuthProvider>().clearError(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginTab(AuthProvider auth) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Icons.person_outline),
            ),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            obscureText: _obscurePassword,
            onSubmitted: (_) => _handleLogin(auth),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: auth.isLoading ? null : () => _handleLogin(auth),
              child: auth.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : const Text('Sign In'),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton.icon(
            onPressed: () => _showVoterLoginDialog(auth),
            icon: const Icon(Icons.how_to_vote, size: 18),
            label: const Text('Voter / Temp Login'),
          ),
        ],
      ),
    );
  }

  void _handleLogin(AuthProvider auth) {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    if (username.isEmpty || password.isEmpty) return;
    auth.login(username, password);
  }

  void _showVoterLoginDialog(AuthProvider auth) {
    final tempUserController = TextEditingController();
    final tempPassController = TextEditingController();
    bool obscureTemp = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Voter / Temp Login'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tempUserController,
                decoration: const InputDecoration(
                  labelText: 'Voter ID / Temp Username',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: tempPassController,
                decoration: InputDecoration(
                  labelText: 'Password / Master Key',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureTemp
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => obscureTemp = !obscureTemp),
                  ),
                ),
                obscureText: obscureTemp,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: auth.isLoading
                  ? null
                  : () {
                      final u = tempUserController.text.trim();
                      final p = tempPassController.text;
                      if (u.isEmpty || p.isEmpty) return;
                      Navigator.of(ctx).pop();
                      auth.loginTemp(u, p);
                    },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdmissionTab() {
    if (_admissionResult != null) {
      return _buildAdmissionSuccess();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _wardNameController,
            decoration: const InputDecoration(
              labelText: "Applicant's Full Name",
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _placementRefController,
            decoration: const InputDecoration(
              labelText: 'CSSPS Placement Reference (optional)',
              prefixIcon: Icon(Icons.confirmation_number_outlined),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _parentNameController,
            decoration: const InputDecoration(
              labelText: "Parent / Guardian Name",
              prefixIcon: Icon(Icons.family_restroom),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _parentPhoneController,
            decoration: const InputDecoration(
              labelText: 'Parent Phone Number',
              prefixIcon: Icon(Icons.phone_outlined),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _parentEmailController,
            decoration: const InputDecoration(
              labelText: 'Parent Email (optional)',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmittingAdmission ? null : _submitAdmission,
              child: _isSubmittingAdmission
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : const Text('Submit Application'),
            ),
          ),
          if (_admissionError != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              _admissionError!,
              style: const TextStyle(color: AppColors.danger),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _submitAdmission() async {
    final wardName = _wardNameController.text.trim();
    final parentName = _parentNameController.text.trim();
    final parentPhone = _parentPhoneController.text.trim();

    if (wardName.isEmpty || parentName.isEmpty || parentPhone.isEmpty) {
      setState(() => _admissionError = 'Please fill all required fields');
      return;
    }

    setState(() {
      _isSubmittingAdmission = true;
      _admissionError = null;
    });

    try {
      final result = await authApi.submitAdmissionApplication(
        applicantName: wardName,
        parentName: parentName,
        parentPhone: parentPhone,
        parentEmail: _parentEmailController.text.trim().isEmpty
            ? null
            : _parentEmailController.text.trim(),
        csspsPlacementRef: _placementRefController.text.trim().isEmpty
            ? null
            : _placementRefController.text.trim(),
      );
      setState(() {
        _admissionResult = result['id'] as String?;
      });
    } catch (e) {
      setState(() {
        _admissionError = e.toString();
      });
    } finally {
      setState(() => _isSubmittingAdmission = false);
    }
  }

  Widget _buildAdmissionSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle,
                size: 64, color: AppColors.success),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Application Submitted!',
              style: TextStyle(
                fontSize: AppFontSize.xl,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Your application ID: ${_admissionResult ?? "N/A"}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSize.sm,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () => setState(() {
                _admissionResult = null;
                _wardNameController.clear();
                _placementRefController.clear();
                _parentNameController.clear();
                _parentPhoneController.clear();
                _parentEmailController.clear();
              }),
              child: const Text('Submit Another'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTab() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: AppColors.textLight),
            SizedBox(height: AppSpacing.lg),
            Text(
              'Check Application Status',
              style: TextStyle(
                fontSize: AppFontSize.xl,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Enter your application ID or phone number to track your admission status.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            SizedBox(height: AppSpacing.lg),
            TextField(
              decoration: InputDecoration(
                labelText: 'Application ID or Phone',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
