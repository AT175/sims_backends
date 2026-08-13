import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import 'notification_center.dart';
import '../state/auth_provider.dart';
import '../types/role_id.dart';
import '../types/models.dart';

/// A navigation item in the sidebar.
class NavItem {
  final String key;
  final String label;
  final IconData? icon;

  const NavItem({required this.key, required this.label, this.icon});
}

/// Callback for building page content.
typedef PageBuilder = Widget Function(BuildContext context);

/// DashboardLayout — responsive sidebar + header + content area.
///
/// On desktop: fixed sidebar on the left.
/// On mobile/narrow: drawer-based sidebar.
class DashboardLayout extends StatefulWidget {
  final String title;
  final List<NavItem> navItems;
  final String activeKey;
  final ValueChanged<String> onNavigate;
  final Widget child;
  final Widget? headerRight;
  final AuthUser? user;
  final VoidCallback onLogout;
  final ValueChanged<RoleId>? onSwitchRole;

  const DashboardLayout({
    super.key,
    required this.title,
    required this.navItems,
    required this.activeKey,
    required this.onNavigate,
    required this.child,
    this.headerRight,
    this.user,
    required this.onLogout,
    this.onSwitchRole,
  });

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _sidebarCollapsed = false;
  bool _sidebarHidden = false;

  static const _sidebarWidth = 280.0;
  static const _sidebarCollapsedWidth = 72.0;

  void _handleNavigate(String key) {
    widget.onNavigate(key);
    if (MediaQuery.of(context).size.width < 900) {
      Navigator.of(context).pop();
    } else {
      setState(() => _sidebarHidden = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    final activeLabel = widget.navItems
        .where((n) => n.key == widget.activeKey)
        .map((n) => n.label)
        .firstOrNull;

    if (isWide) {
      return Scaffold(
        key: scaffoldKey,
        body: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              width: _sidebarHidden
                  ? 0
                  : (_sidebarCollapsed ? _sidebarCollapsedWidth : _sidebarWidth),
              child: _sidebarHidden
                  ? const SizedBox.shrink()
                  : _buildSidebar(context),
            ),
            Expanded(
              child: Column(
                children: [
                  _buildHeader(context, activeLabel ?? widget.title, isWide),
                  Expanded(child: _buildContent()),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: _buildAppBar(context, activeLabel ?? widget.title),
      drawer: Drawer(
        child: _buildSidebar(context),
      ),
      body: _buildContent(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String title) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
      ),
      actions: [
        if (widget.headerRight != null) widget.headerRight!,
        IconButton(
          icon: const Icon(Icons.sync),
          onPressed: () {},
          tooltip: 'Sync Status',
        ),
        const NotificationCenterButton(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, String title, bool isWide) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.sm,
      ),
      child: Row(
        children: [
          if (isWide)
            GestureDetector(
              onTap: () => setState(() {
                if (_sidebarHidden) {
                  _sidebarHidden = false;
                } else {
                  _sidebarCollapsed = !_sidebarCollapsed;
                }
              }),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  _sidebarHidden
                      ? Icons.menu
                      : (_sidebarCollapsed ? Icons.menu_open : Icons.menu),
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          if (isWide) const SizedBox(width: AppSpacing.md),
          Text(
            title,
            style: const TextStyle(
              fontSize: AppFontSize.lg,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const Spacer(),
          if (widget.headerRight != null) widget.headerRight!,
          if (widget.headerRight != null) const SizedBox(width: AppSpacing.sm),
          const NotificationCenterButton(),
          IconButton(
            icon: const Icon(Icons.sync, size: 20),
            onPressed: () {},
            tooltip: 'Sync',
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
          const SizedBox(width: AppSpacing.sm),
          if (widget.user != null) _buildHeaderAvatar(),
        ],
      ),
    );
  }

  Widget _buildHeaderAvatar() {
    final user = widget.user!;
    return GestureDetector(
      onTap: () => _showProfileModal(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
              ),
              child: Center(
                child: Text(
                  user.displayName[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: AppFontSize.xs,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              user.displayName.split(' ').first,
              style: const TextStyle(
                fontSize: AppFontSize.sm,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.sidebarStart, AppColors.sidebarEnd],
        ),
      ),
      child: Column(
        children: [
          _buildSidebarHeader(),
          if (!_sidebarCollapsed) _buildDashboardLabel(),
          if (!_sidebarCollapsed)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm, top: AppSpacing.sm),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => setState(() => _sidebarHidden = true),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Icon(
                      Icons.chevron_left,
                      size: 16,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              ),
            ),
          Expanded(child: _buildNavList()),
          _buildUserFooter(),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.xl,
        bottom: AppSpacing.lg,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.accent, AppColors.accentLight],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'S',
                style: TextStyle(
                  fontSize: AppFontSize.lg,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ),
          if (!_sidebarCollapsed) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SIMS',
                    style: TextStyle(
                      fontSize: AppFontSize.md,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    'School Management',
                    style: TextStyle(
                      fontSize: AppFontSize.xs,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDashboardLabel() {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: AppSpacing.sm,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.title.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.accent.withValues(alpha: 0.8),
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildNavList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      itemCount: widget.navItems.length,
      itemBuilder: (context, index) {
        final item = widget.navItems[index];
        final isActive = item.key == widget.activeKey;
        return _NavTile(
          label: item.label,
          isActive: isActive,
          collapsed: _sidebarCollapsed,
          onTap: () => _handleNavigate(item.key),
        );
      },
    );
  }

  Widget _buildUserFooter() {
    final user = widget.user;
    final hasMultipleRoles = user != null && user.roles.length > 1;

    if (_sidebarCollapsed) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0x1AFFFFFF))),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _showProfileModal(context),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ),
                ),
                child: Center(
                  child: Text(
                    (user?.displayName ?? 'U')[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: AppFontSize.xs,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            IconButton(
              icon: const Icon(Icons.power_settings_new, color: AppColors.danger, size: 18),
              onPressed: widget.onLogout,
              tooltip: 'Logout',
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0x1AFFFFFF))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showProfileModal(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
              ),
              child: Center(
                child: Text(
                  (user?.displayName ?? 'U')[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: GestureDetector(
              onTap: () => _showProfileModal(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.displayName ?? 'User',
                    style: const TextStyle(
                      fontSize: AppFontSize.sm,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    user != null ? user.activeRole.label : widget.title,
                    style: TextStyle(
                      fontSize: AppFontSize.xs,
                      color: AppColors.textLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          if (hasMultipleRoles)
            IconButton(
              icon: const Icon(Icons.swap_horiz, color: AppColors.accent, size: 18),
              onPressed: () => _showRoleSwitcher(context),
              tooltip: 'Switch Role',
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              padding: EdgeInsets.zero,
            ),
          IconButton(
            icon: const Icon(Icons.power_settings_new,
                color: AppColors.danger, size: 18),
            onPressed: widget.onLogout,
            tooltip: 'Logout',
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  void _showRoleSwitcher(BuildContext context) {
    final user = widget.user;
    if (user == null) return;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Switch Role'),
          content: SizedBox(
            width: 320,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: user.roles.length,
              itemBuilder: (ctx, index) {
                final role = user.roles[index];
                final isActive = role == user.activeRole;
                return ListTile(
                  leading: isActive
                      ? const Icon(Icons.check, color: AppColors.accent)
                      : const SizedBox(width: 24),
                  title: Text(role.label),
                  onTap: () {
                    if (widget.onSwitchRole != null && !isActive) {
                      widget.onSwitchRole!(role);
                    }
                    Navigator.of(ctx).pop();
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showProfileModal(BuildContext context) {
    final user = widget.user;
    if (user == null) return;

    showDialog(
      context: context,
      builder: (ctx) {
        return const _ProfileDialog();
      },
    );
  }

  Widget _buildContent() {
    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: widget.child,
      ),
    );
  }
}

class _NavTile extends StatefulWidget {
  final String label;
  final bool isActive;
  final bool collapsed;
  final VoidCallback onTap;

  const _NavTile({
    required this.label,
    required this.isActive,
    required this.collapsed,
    required this.onTap,
  });

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    if (widget.collapsed) {
      return Tooltip(
        message: widget.label,
        preferBelow: false,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: widget.isActive
                    ? AppColors.primary.withValues(alpha: 0.25)
                    : _hovered
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Center(
                child: Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: widget.isActive ? AppColors.accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 2),
          padding: const EdgeInsets.symmetric(
            vertical: 11,
            horizontal: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.primary.withValues(alpha: 0.25)
                : _hovered
                    ? Colors.white.withValues(alpha: 0.08)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 3,
                height: 20,
                decoration: BoxDecoration(
                  color: widget.isActive ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppSpacing.sm + 2),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    color: widget.isActive
                        ? AppColors.white
                        : _hovered
                            ? const Color(0xCCFFFFFF)
                            : const Color(0x88FFFFFF),
                    fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Editable profile dialog with Profile / Edit / Password tabs.
class _ProfileDialog extends StatefulWidget {
  const _ProfileDialog();

  @override
  State<_ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<_ProfileDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    if (user == null) return const SizedBox.shrink();

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    user.displayName[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName,
                        style: const TextStyle(
                          fontSize: AppFontSize.md,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text,
                        ),
                      ),
                      Text(
                        '@${user.username}',
                        style: TextStyle(
                          fontSize: AppFontSize.sm,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'Profile'),
              Tab(text: 'Edit'),
              Tab(text: 'Password'),
            ],
          ),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: TabBarView(
          controller: _tabController,
          children: [
            _ProfileTab(user: user),
            _EditProfileTab(user: user),
            const _ChangePasswordTab(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _ProfileTab extends StatelessWidget {
  final AuthUser user;
  const _ProfileTab({required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('School', user.schoolName),
          _infoRow('Username', user.username),
          _infoRow('Display Name', user.displayName),
          _infoRow('Active Role', user.activeRole.label),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Roles',
            style: TextStyle(
              fontSize: AppFontSize.sm,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: user.roles
                .map((r) => Chip(
                      label: Text(r.label),
                      backgroundColor: r == user.activeRole
                          ? AppColors.primaryLight
                          : AppColors.surfaceAlt,
                      labelStyle: TextStyle(
                        color: r == user.activeRole
                            ? AppColors.white
                            : AppColors.textSecondary,
                        fontSize: AppFontSize.xs,
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppFontSize.sm,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: AppFontSize.sm,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditProfileTab extends StatefulWidget {
  final AuthUser user;
  const _EditProfileTab({required this.user});

  @override
  State<_EditProfileTab> createState() => _EditProfileTabState();
}

class _EditProfileTabState extends State<_EditProfileTab> {
  late final TextEditingController _nameController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.displayName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Update Display Name',
            style: TextStyle(
              fontSize: AppFontSize.sm,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Display Name',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save, size: 18),
              label: Text(_saving ? 'Saving...' : 'Save Changes'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _saving = true);
    await context.read<AuthProvider>().updateProfile(displayName: name);
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

class _ChangePasswordTab extends StatefulWidget {
  const _ChangePasswordTab();

  @override
  State<_ChangePasswordTab> createState() => _ChangePasswordTabState();
}

class _ChangePasswordTabState extends State<_ChangePasswordTab> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _saving = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  String? _error;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_error != null)
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, size: 16, color: AppColors.danger),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _error!,
                      style: TextStyle(fontSize: AppFontSize.xs, color: AppColors.danger),
                    ),
                  ),
                ],
              ),
            ),
          _passwordField('Current Password', _currentController, _obscureCurrent,
              (v) => setState(() => _obscureCurrent = v)),
          const SizedBox(height: AppSpacing.sm),
          _passwordField('New Password', _newController, _obscureNew,
              (v) => setState(() => _obscureNew = v)),
          const SizedBox(height: AppSpacing.sm),
          _passwordField('Confirm Password', _confirmController, _obscureConfirm,
              (v) => setState(() => _obscureConfirm = v)),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saving ? null : _submit,
              icon: _saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.lock_outline, size: 18),
              label: Text(_saving ? 'Changing...' : 'Change Password'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordField(
    String label,
    TextEditingController controller,
    bool obscure,
    ValueChanged<bool> onToggle,
  ) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility, size: 18),
          onPressed: () => onToggle(!obscure),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final current = _currentController.text;
    final newPwd = _newController.text;
    final confirm = _confirmController.text;

    if (current.isEmpty || newPwd.isEmpty || confirm.isEmpty) {
      setState(() => _error = 'All fields are required.');
      return;
    }
    if (newPwd.length < 6) {
      setState(() => _error = 'New password must be at least 6 characters.');
      return;
    }
    if (newPwd != confirm) {
      setState(() => _error = 'Passwords do not match.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    await context.read<AuthProvider>().changePassword(current, newPwd);

    if (mounted) {
      final auth = context.read<AuthProvider>();
      setState(() => _saving = false);
      if (auth.error != null) {
        setState(() => _error = auth.error);
      } else {
        _currentController.clear();
        _newController.clear();
        _confirmController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password changed successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}

/// Extension to add `firstOrNull` to Iterable.
extension FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
