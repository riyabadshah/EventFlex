import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventflex/main.dart';
import 'package:eventflex/models/models.dart';
import 'package:eventflex/data/mock_data.dart';
import 'package:eventflex/widgets/navbar.dart';
import 'package:eventflex/theme/app_theme.dart';

void main() {
  testWidgets('EventFlex smoke test - mounts Landing Page', (WidgetTester tester) async {
    await tester.pumpWidget(const EventFlexApp());
    await tester.pumpAndSettle();

    // Verify Brand Logo and Landing Headline exist
    expect(find.text('Find the Right People\nfor Every Event'), findsOneWidget);
    expect(find.text('Find Event Staff'), findsOneWidget);
    expect(find.text('Find Event Jobs'), findsOneWidget);
  });

  test('Models JSON serialization test for Node.js & MongoDB compatibility', () {
    final role = StaffingRole(
      name: 'Lead Hostess',
      description: 'VIP Hostess for summit',
      requiredPeople: 3,
      payment: 4500,
      requiredSkills: 'Hospitality, English',
    );

    final jsonRole = role.toJson();
    expect(jsonRole['name'], 'Lead Hostess');
    expect(jsonRole['payment'], 4500.0);

    final recreatedRole = StaffingRole.fromJson(jsonRole);
    expect(recreatedRole.name, role.name);
    expect(recreatedRole.payment, role.payment);

    final event = EventItem(
      name: 'Test Event 2026',
      description: 'Testing event',
      eventType: 'Conferences',
      date: '2026-10-30',
      time: '10:00 AM',
      location: 'Mumbai',
      roles: [role],
    );

    final jsonEvent = event.toJson();
    expect(jsonEvent['name'], 'Test Event 2026');
    expect(jsonEvent['roles'], isA<List>());

    final recreatedEvent = EventItem.fromJson(jsonEvent);
    expect(recreatedEvent.name, event.name);
    expect(recreatedEvent.roles.length, 1);
  });

  test('AppDataState reactive updates test', () {
    final state = AppDataState.instance;
    final initialCount = state.events.length;
    state.addEvent(
      EventItem(
        name: 'Unit Test Hackathon',
        description: 'Testing state addition',
        eventType: 'Technical Event',
        date: '2026-12-12',
        time: '09:00 AM',
        location: 'Tech Hub',
        roles: [],
      ),
    );

    expect(state.events.length, initialCount + 1);
  });

  for (final width in [1920.0, 1440.0, 1200.0, 1024.0, 768.0, 375.0]) {
    testWidgets('Header renders with zero RenderFlex overflow at ${width.toInt()}px width', (WidgetTester tester) async {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            appBar: AppNavbar(activeRoute: 'home'),
            endDrawer: AppDrawer(),
            body: SizedBox(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Ensure no exception or RenderFlex overflow was thrown in header
      expect(tester.takeException(), isNull);
    });
  }

  for (final width in [1920.0, 1440.0, 1200.0, 1024.0]) {
    testWidgets('Menu Admin and Role Admin do not overlap at ${width.toInt()}px', (WidgetTester tester) async {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            appBar: AppNavbar(activeRoute: 'home'),
            endDrawer: AppDrawer(),
            body: SizedBox(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final adminFinders = find.text('Admin');
      expect(adminFinders, findsNWidgets(2));

      final menuAdminRect = tester.getRect(adminFinders.at(0));
      final roleAdminRect = tester.getRect(adminFinders.at(1));
      // ignore: avoid_print
      print('WIDTH $width => at(0): $menuAdminRect, at(1): $roleAdminRect');

      // Assert they do NOT overlap
      expect(menuAdminRect.overlaps(roleAdminRect), isFalse);
      // Assert menu Admin is to the left of role Admin with clean separation
      expect(menuAdminRect.right <= roleAdminRect.left, isTrue);
    });
  }

  testWidgets('Header role selector buttons fully visible at 768px width', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(768.0, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          appBar: AppNavbar(activeRoute: 'home'),
          endDrawer: AppDrawer(),
          body: SizedBox(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Role switcher buttons exist
    expect(find.text('Organizer'), findsOneWidget);
    expect(find.text('Professional'), findsOneWidget);
    expect(find.text('Admin'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
