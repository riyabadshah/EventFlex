import 'package:flutter/material.dart';
import 'data/mock_data.dart';
import 'models/models.dart';
import 'theme/app_theme.dart';

// Screens
import 'screens/landing_page.dart';
import 'screens/auth/auth_screens.dart';
import 'screens/organizer/organizer_dashboard.dart';
import 'screens/organizer/create_event_screen.dart';
import 'screens/organizer/post_requirement_screen.dart';
import 'screens/organizer/application_management_screen.dart';
import 'screens/organizer/workforce_management_screen.dart';
import 'screens/professional/professional_dashboard.dart';
import 'screens/professional/professional_profile_screen.dart';
import 'screens/jobs/job_discovery_screen.dart';
import 'screens/attendance/attendance_screen.dart';
import 'screens/payments/payment_management_screen.dart';
import 'screens/messages/messages_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/smart_matching/smart_matching_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EventFlexApp());
}

class EventFlexApp extends StatelessWidget {
  const EventFlexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppDataState.instance,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GoWow • EventFlex | Digital Event Staffing Platform',
          theme: AppTheme.lightTheme,
          initialRoute: '/',
          routes: {
            '/': (context) => const LandingPage(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/forgot-password': (context) => const ForgotPasswordScreen(),
            '/jobs': (context) => const JobDiscoveryScreen(),
            '/organizer': (context) => const OrganizerDashboardScreen(),
            '/organizer/create-event': (context) => const CreateEventScreen(),
            '/organizer/post-requirement': (context) => const PostRequirementScreen(),
            '/organizer/applications': (context) => const ApplicationManagementScreen(),
            '/organizer/workforce': (context) => const WorkforceManagementScreen(),
            '/professional': (context) => const ProfessionalDashboardScreen(),
            '/professional/profile': (context) => const ProfessionalProfileScreen(),
            '/attendance': (context) => const AttendanceScreen(),
            '/payments': (context) => const PaymentManagementScreen(),
            '/messages': (context) => const MessagesScreen(),
            '/notifications': (context) => const NotificationsScreen(),
            '/admin': (context) => const AdminDashboardScreen(),
            '/smart-match': (context) => const SmartMatchingScreen(),
          },
        );
      },
    );
  }
}

// ============================================================
// BACKWARD COMPATIBILITY ALIASES
// Preserving original screen classes for legacy tests and references
// ============================================================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => const LandingPage();
}

class OrganizerAuthScreen extends StatelessWidget {
  const OrganizerAuthScreen({super.key});

  @override
  Widget build(BuildContext context) => const LoginScreen(initialRole: 'Organizer');
}

class ProfessionalAuthScreen extends StatelessWidget {
  const ProfessionalAuthScreen({super.key});

  @override
  Widget build(BuildContext context) => const LoginScreen(initialRole: 'Professional');
}

class OrganizerDashboard extends StatelessWidget {
  const OrganizerDashboard({super.key});

  @override
  Widget build(BuildContext context) => const OrganizerDashboardScreen();
}

class ProfessionalDashboard extends StatelessWidget {
  final ProfessionalProfile? profile;
  const ProfessionalDashboard({super.key, this.profile});

  @override
  Widget build(BuildContext context) => const ProfessionalDashboardScreen();
}