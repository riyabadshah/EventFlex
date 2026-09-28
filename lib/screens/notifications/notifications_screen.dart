import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/navbar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppDataState.instance;
    final isDesktop = Responsive.isDesktop(context);

    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        return Scaffold(
          appBar: const AppNavbar(activeRoute: 'notifications'),
          endDrawer: const AppDrawer(),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 32 : 16,
                  vertical: 36,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Notifications Center',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.textDark,
                              ),
                            ),
                            if (state.unreadNotificationsCount > 0) ...[
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.danger,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${state.unreadNotificationsCount} New',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        TextButton(
                          onPressed: () => state.markAllNotificationsAsRead(),
                          child: const Text('Mark all as read'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    if (state.notifications.isEmpty)
                      const EmptyStateWidget(
                        title: 'All Caught Up!',
                        subtitle: 'No notifications at this time.',
                      )
                    else
                      ...state.notifications.map((notif) {
                        IconData icon;
                        Color iconBg;
                        Color iconColor;

                        switch (notif.type) {
                          case 'job':
                            icon = Icons.bolt_rounded;
                            iconBg = AppTheme.primaryLight;
                            iconColor = AppTheme.primary;
                            break;
                          case 'application':
                            icon = Icons.assignment_turned_in_rounded;
                            iconBg = const Color(0xFFDCFCE7);
                            iconColor = const Color(0xFF15803D);
                            break;
                          case 'payment':
                            icon = Icons.currency_rupee;
                            iconBg = const Color(0xFFDCFCE7);
                            iconColor = const Color(0xFF15803D);
                            break;
                          case 'review':
                            icon = Icons.star_rounded;
                            iconBg = const Color(0xFFFEF3C7);
                            iconColor = const Color(0xFFB45309);
                            break;
                          default:
                            icon = Icons.notifications_rounded;
                            iconBg = AppTheme.surfaceSubtle;
                            iconColor = AppTheme.textMuted;
                        }

                        return Card(
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: notif.isRead ? AppTheme.border : AppTheme.primary.withOpacity(0.3),
                              width: notif.isRead ? 1 : 1.5,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: iconBg,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(icon, color: iconColor, size: 22),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    notif.title,
                                    style: TextStyle(
                                      fontWeight: notif.isRead ? FontWeight.bold : FontWeight.w900,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Text(
                                  notif.timeAgo,
                                  style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                notif.message,
                                style: const TextStyle(fontSize: 13, color: AppTheme.textDark),
                              ),
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
