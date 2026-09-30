import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  // REGISTER
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'role': role,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['detail'] ?? 'Registration failed');
  }

  // LOGIN
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['detail'] ?? 'Login failed');
  }

  // GET ALL EVENTS
  static Future<List<dynamic>> getEvents() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/events'),
      headers: {'Content-Type': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception('Failed to load events');
  }

  // CREATE EVENT
  static Future<Map<String, dynamic>> createEvent({
    required String name,
    required String type,
    required String description,
    required String date,
    required String time,
    required String location,
    required int organizerId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/events'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'type': type,
        'description': description,
        'date': date,
        'time': time,
        'location': location,
        'organizer_id': organizerId,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['detail'] ?? 'Event creation failed');
  }

  // APPLY FOR EVENT ROLE
  static Future<Map<String, dynamic>> applyForEvent({
    required int eventId,
    required int roleId,
    required int professionalId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/applications'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'event_id': eventId,
        'role_id': roleId,
        'professional_id': professionalId,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['detail'] ?? 'Application failed');
  }

  // GET ALL APPLICATIONS
  static Future<List<dynamic>> getApplications() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/applications'),
      headers: {'Content-Type': 'application/json'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception('Failed to load applications');
  }

  // UPDATE APPLICATION STATUS
  static Future<Map<String, dynamic>> updateApplicationStatus({
    required int applicationId,
    required String status,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/applications/$applicationId/status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['detail'] ?? 'Failed to update application status');
  }

  // CREATE EVENT ROLE
  static Future<Map<String, dynamic>> createEventRole({
    required int eventId,
    required String roleName,
    required String description,
    required int peopleRequired,
    required int payment,
    required String skills,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/events/$eventId/roles'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'role_name': roleName,
        'description': description,
        'people_required': peopleRequired,
        'payment': payment,
        'skills': skills,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['detail'] ?? 'Failed to create event role');
  }
}
