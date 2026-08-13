import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/widgets.dart';

/// Verification dashboard for temp/voter logins.
/// Shows identity verification UI for students using temporary credentials.
class VerificationDashboard extends StatelessWidget {
  const VerificationDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionCard(
              title: 'Identity Verification',
              child: Column(
                children: [
                  Icon(Icons.verified_user, size: 48, color: AppColors.success),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    'Your identity has been verified.',
                    style: TextStyle(fontSize: AppFontSize.lg),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'You are logged in with temporary voter credentials.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const SectionCard(
              title: 'Election Information',
              child: PlaceholderPage(pageTitle: 'Election Details'),
            ),
            const SizedBox(height: AppSpacing.lg),
            const SectionCard(
              title: 'Cast Your Vote',
              child: PlaceholderPage(pageTitle: 'Voting'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              // The AppRouter will handle redirect to login
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
