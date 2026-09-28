import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../theme/app_theme.dart';
import 'common_widgets.dart';

class AppNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String activeRoute;
  final VoidCallback? onNotificationTap;

  const AppNavbar({
    super.key,
    this.activeRoute = 'home',
    this.onNotificationTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final state = AppDataState.instance;

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final showDesktopNav = screenWidth >= 960;
            final showDrawerIcon = screenWidth < 1150;
            final showProfileName = screenWidth >= 1280;

            final double hPadding = screenWidth >= 1200 ? 20 : (screenWidth >= 768 ? 16 : 12);
            final double logoMaxWidth = screenWidth >= 1200 ? 220 : (screenWidth >= 768 ? 160 : 120);

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(
                  bottom: BorderSide(color: AppTheme.border, width: 1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: hPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. LEFT SECTION: Logo
                  _buildLeftSection(context, logoMaxWidth),

                  SizedBox(width: showDesktopNav ? 16 : 8),

                  // 2. CENTER SECTION: Main Navigation Menu (completely contained and clipped)
                  if (showDesktopNav)
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, centerConstraints) {
                          return _buildCenterSection(
                            context,
                            centerConstraints.maxWidth,
                            screenWidth,
                            activeRoute,
                          );
                        },
                      ),
                    )
                  else
                    const Spacer(),

                  SizedBox(width: showDesktopNav ? 16 : 8),

                  // 3. RIGHT SECTION: Role Selector, Notifications, Profile, Menu
                  if (!showDesktopNav)
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: (screenWidth - logoMaxWidth - (hPadding * 2) - 20).clamp(100.0, double.infinity),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: _buildRightSection(
                          context,
                          state,
                          screenWidth,
                          showProfileName,
                          showDrawerIcon,
                        ),
                      ),
                    )
                  else
                    _buildRightSection(
                      context,
                      state,
                      screenWidth,
                      showProfileName,
                      showDrawerIcon,
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 1. LEFT SECTION: Brand Logo
  Widget _buildLeftSection(BuildContext context, double logoMaxWidth) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/'),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: logoMaxWidth),
          child: const FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: GoWowLogo(size: 34),
          ),
        ),
      ),
    );
  }

  // 2. CENTER SECTION: Main Navigation Menu (completely contained within available width)
  Widget _buildCenterSection(
    BuildContext context,
    double availableWidth,
    double screenWidth,
    String activeRoute,
  ) {
    final EdgeInsetsGeometry navPadding;
    final EdgeInsetsGeometry navMargin;
    final double fontSize;

    if (screenWidth >= 1440) {
      navPadding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8);
      navMargin = const EdgeInsets.symmetric(horizontal: 3);
      fontSize = 13.5;
    } else if (screenWidth >= 1200) {
      navPadding = const EdgeInsets.symmetric(horizontal: 7, vertical: 7);
      navMargin = const EdgeInsets.symmetric(horizontal: 2);
      fontSize = 13.0;
    } else {
      navPadding = const EdgeInsets.symmetric(horizontal: 5, vertical: 6);
      navMargin = const EdgeInsets.symmetric(horizontal: 1.5);
      fontSize = 12.0;
    }

    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _navItem(context, 'Explore Jobs', '/jobs', activeRoute == 'jobs', margin: navMargin, padding: navPadding, fontSize: fontSize),
            _navItem(context, 'Organizer Hub', '/organizer', activeRoute == 'organizer', margin: navMargin, padding: navPadding, fontSize: fontSize),
            _navItem(context, 'Professional Hub', '/professional', activeRoute == 'professional', margin: navMargin, padding: navPadding, fontSize: fontSize),
            _navItem(context, 'Smart Match', '/smart-match', activeRoute == 'smart-match', margin: navMargin, padding: navPadding, fontSize: fontSize),
            _navItem(context, 'Attendance QR', '/attendance', activeRoute == 'attendance', margin: navMargin, padding: navPadding, fontSize: fontSize),
            _navItem(context, 'Payments', '/payments', activeRoute == 'payments', margin: navMargin, padding: navPadding, fontSize: fontSize),
            _navItem(context, 'Messages', '/messages', activeRoute == 'messages', margin: navMargin, padding: navPadding, fontSize: fontSize),
            _navItem(context, 'Admin', '/admin', activeRoute == 'admin', margin: navMargin, padding: navPadding, fontSize: fontSize),
          ],
        ),
      ),
    );
  }

  // 3. RIGHT SECTION: Role Selector, Notification Bell, User Profile, Drawer Menu
  Widget _buildRightSection(
    BuildContext context,
    AppDataState state,
    double screenWidth,
    bool showProfileName,
    bool showDrawerIcon,
  ) {
    final rightContent = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Role Switcher Segment (Keeps Organizer, Professional, Admin buttons visible inside viewport)
        _buildRoleSwitcher(state, screenWidth),

        SizedBox(width: screenWidth >= 1200 ? 10 : 6),

        // Notification Bell with Badge
        IconButton(
          visualDensity: VisualDensity.compact,
          tooltip: 'Notifications',
          onPressed: () {
            if (onNotificationTap != null) {
              onNotificationTap!();
            } else {
              Navigator.pushNamed(context, '/notifications');
            }
          },
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_outlined, size: 24, color: AppTheme.textDark),
              if (state.unreadNotificationsCount > 0)
                Positioned(
                  top: -3,
                  right: -3,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppTheme.danger,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${state.unreadNotificationsCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(width: 4),

        // User Profile Avatar / Action Button
        PopupMenuButton<String>(
          offset: const Offset(0, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          onSelected: (val) {
            if (val == 'profile') {
              if (state.currentRole == 'Organizer') {
                Navigator.pushNamed(context, '/organizer');
              } else {
                Navigator.pushNamed(context, '/professional/profile');
              }
            } else if (val == 'login') {
              Navigator.pushNamed(context, '/login');
            } else if (val == 'logout') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Switched session')),
              );
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  const Icon(Icons.account_circle_outlined, size: 18),
                  const SizedBox(width: 10),
                  Text(state.currentRole == 'Organizer'
                      ? state.currentOrganizer.name
                      : state.currentProfessional.name),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'login',
              child: Row(
                children: [
                  Icon(Icons.swap_horiz_rounded, size: 18),
                  SizedBox(width: 10),
                  Text('Switch / Login Account'),
                ],
              ),
            ),
          ],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppTheme.primaryLight,
                child: Text(
                  state.currentRole == 'Organizer' ? 'PS' : 'RM',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              if (showProfileName) ...[
                const SizedBox(width: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.currentRole == 'Organizer'
                            ? state.currentOrganizer.name
                            : state.currentProfessional.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textDark,
                        ),
                      ),
                      Text(
                        state.currentRole,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: AppTheme.textMuted),
              ],
            ],
          ),
        ),

        // Drawer trigger for mobile/tablet/compact view
        if (showDrawerIcon) ...[
          const SizedBox(width: 4),
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: 'Menu',
            icon: const Icon(Icons.menu_rounded),
            onPressed: () {
              final scaffold = Scaffold.maybeOf(context);
              if (scaffold != null && scaffold.hasEndDrawer) {
                scaffold.openEndDrawer();
              } else {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const AppDrawer(),
                );
              }
            },
          ),
        ],
      ],
    );

    return rightContent;
  }

  Widget _buildRoleSwitcher(AppDataState state, double screenWidth) {
    if (screenWidth >= 720) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppTheme.surfaceSubtle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _roleBtn(state, 'Organizer', Icons.business_center_rounded),
            _roleBtn(state, 'Professional', Icons.person_rounded),
            _roleBtn(state, 'Admin', Icons.shield_rounded),
          ],
        ),
      );
    } else if (screenWidth >= 600) {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppTheme.surfaceSubtle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _roleBtn(state, 'Organizer', Icons.business_center_rounded),
            _roleBtn(state, 'Professional', Icons.person_rounded),
          ],
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          state.setRole(state.currentRole == 'Organizer' ? 'Professional' : 'Organizer');
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                state.currentRole == 'Organizer'
                    ? Icons.business_center_rounded
                    : Icons.person_rounded,
                size: 13,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                state.currentRole,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _navItem(
    BuildContext context,
    String label,
    String route,
    bool isActive, {
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? fontSize,
  }) {
    return Padding(
      padding: margin ?? const EdgeInsets.symmetric(horizontal: 3),
      child: InkWell(
        onTap: () {
          if (!isActive) {
            Navigator.pushNamed(context, route);
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: fontSize ?? 14,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive ? AppTheme.primary : AppTheme.textDark,
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleBtn(AppDataState state, String role, IconData icon) {
    final isSelected = state.currentRole == role;
    return InkWell(
      onTap: () => state.setRole(role),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? AppTheme.primary : AppTheme.textMuted,
            ),
            const SizedBox(width: 4),
            Text(
              role,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.primary : AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Mobile Navigation Drawer
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppDataState.instance;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const GoWowLogo(size: 34),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _drawerItem(context, Icons.home_rounded, 'Landing Page', '/'),
                  _drawerItem(context, Icons.search_rounded, 'Explore Jobs', '/jobs'),
                  _drawerItem(context, Icons.business_center_rounded, 'Organizer Hub', '/organizer'),
                  _drawerItem(context, Icons.person_rounded, 'Professional Hub', '/professional'),
                  _drawerItem(context, Icons.auto_awesome_rounded, 'Smart Match Engine', '/smart-match'),
                  _drawerItem(context, Icons.qr_code_scanner_rounded, 'Attendance QR', '/attendance'),
                  _drawerItem(context, Icons.account_balance_wallet_rounded, 'Payments & Escrow', '/payments'),
                  _drawerItem(context, Icons.chat_bubble_outline_rounded, 'Messages', '/messages'),
                  _drawerItem(context, Icons.notifications_none_rounded, 'Notifications', '/notifications'),
                  _drawerItem(context, Icons.admin_panel_settings_rounded, 'Admin Dashboard', '/admin'),
                  const Divider(height: 24),
                  _drawerItem(context, Icons.lock_outline_rounded, 'Auth / Login / Register', '/login'),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppTheme.primary,
                    child: Icon(Icons.bolt, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Viewing as: ${state.currentRole}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryDark,
                          ),
                        ),
                        const Text(
                          'Switch role in top bar anytime',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary, size: 22),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}
