import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  // Configurable base URL for Node.js Express Backend
  static const String baseUrl = 'http://localhost:5000/api';

  static String? authToken;

  // --- HEALTH CHECK ---
  static Future<bool> isBackendOnline() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 2));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // --- AUTHENTICATION ---
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 4));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        authToken = data['token'];
        return data;
      }
    } catch (e) {
      // Backend offline or timeout
    }
    return null;
  }

  static Future<Map<String, dynamic>?> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? phone,
    String? organizationName,
    String? location,
    List<String>? skills,
    String? experience,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
          'phone': phone ?? '',
          'organizationName': organizationName ?? '',
          'location': location ?? '',
          'skills': skills ?? [],
          'experience': experience ?? '1 year',
        }),
      ).timeout(const Duration(seconds: 4));

      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        authToken = data['token'];
        return data;
      }
    } catch (e) {
      // Backend offline or timeout
    }
    return null;
  }

  // --- EVENTS ---
  static Future<List<EventItem>?> getEvents() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/events'))
          .timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final list = (body['data'] as List<dynamic>?) ?? [];
        return list.map((json) {
          final eventMap = json as Map<String, dynamic>;
          final rolesList = (eventMap['roles'] as List<dynamic>?) ?? [];
          final roles = rolesList.map((r) {
            final rMap = r as Map<String, dynamic>;
            return StaffingRole(
              id: rMap['_id'] ?? rMap['id'],
              name: rMap['title'] ?? rMap['role'] ?? '',
              description: rMap['description'] ?? '',
              requiredPeople: rMap['workersRequired'] ?? 1,
              payment: (rMap['payment'] as num?)?.toDouble() ?? 3000,
              requiredSkills: (rMap['requiredSkills'] is List)
                  ? (rMap['requiredSkills'] as List).join(', ')
                  : rMap['requiredSkills']?.toString() ?? '',
              experienceRequired: rMap['experienceRequired'] ?? '1+ years',
              eventId: eventMap['_id'],
              eventName: eventMap['eventName'],
              location: eventMap['location'] ?? '',
              date: eventMap['date'] ?? '',
            );
          }).toList();

          return EventItem(
            id: eventMap['_id'],
            name: eventMap['eventName'] ?? '',
            description: eventMap['description'] ?? '',
            eventType: eventMap['eventType'] ?? 'Conferences',
            date: eventMap['date'] ?? '',
            time: eventMap['startTime'] ?? '09:00 AM',
            endTime: eventMap['endTime'] ?? '06:00 PM',
            location: eventMap['location'] ?? '',
            status: eventMap['status'] ?? 'Upcoming',
            roles: roles,
          );
        }).toList();
      }
    } catch (_) {}
    return null;
  }

  static Future<bool> createEvent(EventItem event) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/events'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'eventName': event.name,
          'eventType': event.eventType,
          'description': event.description,
          'location': event.location,
          'date': event.date,
          'startTime': event.time,
          'endTime': event.endTime,
          'status': event.status,
        }),
      ).timeout(const Duration(seconds: 4));

      return res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  // --- JOBS ---
  static Future<bool> createJob(String eventId, StaffingRole role) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/jobs'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'eventId': eventId,
          'title': role.name,
          'role': role.name,
          'workersRequired': role.requiredPeople,
          'requiredSkills': role.requiredSkills.split(',').map((s) => s.trim()).toList(),
          'experienceRequired': role.experienceRequired,
          'payment': role.payment,
          'description': role.description,
        }),
      ).timeout(const Duration(seconds: 4));

      return res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  // --- APPLICATIONS ---
  static Future<bool> applyForJob(String jobId, String professionalId) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/applications'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'jobId': jobId,
          'professionalId': professionalId,
        }),
      ).timeout(const Duration(seconds: 4));

      return res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> updateApplicationStatus(String appId, String status) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/applications/$appId/status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': status}),
      ).timeout(const Duration(seconds: 4));

      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<List<JobApplication>?> getApplications() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/applications'))
          .timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final list = (body['data'] as List<dynamic>?) ?? [];
        return list.map((json) {
          final map = json as Map<String, dynamic>;
          final jobMap = map['jobId'] is Map ? map['jobId'] as Map<String, dynamic> : <String, dynamic>{};
          final eventMap = jobMap['eventId'] is Map ? jobMap['eventId'] as Map<String, dynamic> : <String, dynamic>{};
          final proMap = map['professionalId'] is Map ? map['professionalId'] as Map<String, dynamic> : <String, dynamic>{};
          final userMap = proMap['userId'] is Map ? proMap['userId'] as Map<String, dynamic> : <String, dynamic>{};

          return JobApplication(
            id: map['_id'] ?? map['id'],
            jobId: jobMap['_id'] ?? '',
            eventId: eventMap['_id'] ?? '',
            eventName: eventMap['eventName'] ?? '',
            roleName: jobMap['title'] ?? jobMap['role'] ?? '',
            organizerName: '',
            payment: (jobMap['payment'] as num?)?.toDouble() ?? 0.0,
            eventDate: eventMap['date'] ?? '',
            location: eventMap['location'] ?? '',
            professionalId: proMap['_id'] ?? '',
            professionalName: userMap['name'] ?? '',
            professionalPhoto: proMap['profilePhoto'] ?? '',
            professionalRating: (proMap['rating'] as num?)?.toDouble() ?? 0.0,
            professionalSkills: (proMap['skills'] is List)
                ? (proMap['skills'] as List).map((s) => s.toString()).toList()
                : [],
            professionalExperience: proMap['experience'] ?? '',
            professionalLocation: proMap['location'] ?? '',
            status: map['status'] ?? 'Applied',
            matchScore: 90,
          );
        }).toList();
      }
    } catch (_) {}
    return null;
  }

  // --- ATTENDANCE ---
  static Future<List<WorkforceMember>?> getAttendance() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/attendance'))
          .timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final list = (body['data'] as List<dynamic>?) ?? [];
        return list.map((json) {
          final map = json as Map<String, dynamic>;
          final jobMap = map['jobId'] is Map ? map['jobId'] as Map<String, dynamic> : <String, dynamic>{};
          final eventMap = jobMap['eventId'] is Map ? jobMap['eventId'] as Map<String, dynamic> : <String, dynamic>{};
          final proMap = map['professionalId'] is Map ? map['professionalId'] as Map<String, dynamic> : <String, dynamic>{};
          final userMap = proMap['userId'] is Map ? proMap['userId'] as Map<String, dynamic> : <String, dynamic>{};

          return WorkforceMember(
            id: map['_id'] ?? map['id'],
            eventId: eventMap['_id'] ?? '',
            eventName: eventMap['eventName'] ?? '',
            professionalId: proMap['_id'] ?? '',
            professionalName: userMap['name'] ?? '',
            role: jobMap['title'] ?? jobMap['role'] ?? '',
            date: eventMap['date'] ?? '',
            checkInTime: map['checkIn'] != null ? map['checkIn'].toString() : '--:--',
            checkOutTime: map['checkOut'] != null ? map['checkOut'].toString() : '--:--',
            totalHours: '8.0 hrs',
            attendanceStatus: map['status'] ?? 'Present',
            performanceRating: 0.0,
            paymentAmount: (jobMap['payment'] as num?)?.toDouble() ?? 0.0,
            paymentStatus: 'Pending',
            status: 'Confirmed',
          );
        }).toList();
      }
    } catch (_) {}
    return null;
  }

  static Future<bool> recordCheckIn(String jobId, String professionalId, {String method = 'QR'}) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/attendance/check-in'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'jobId': jobId,
          'professionalId': professionalId,
          'method': method,
        }),
      ).timeout(const Duration(seconds: 4));

      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // --- PAYMENTS ---
  static Future<List<PaymentRecord>?> getPayments() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/payments'))
          .timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final list = (body['data'] as List<dynamic>?) ?? [];
        return list.map((json) {
          final map = json as Map<String, dynamic>;
          final jobMap = map['jobId'] is Map ? map['jobId'] as Map<String, dynamic> : <String, dynamic>{};
          final eventMap = jobMap['eventId'] is Map ? jobMap['eventId'] as Map<String, dynamic> : <String, dynamic>{};
          final proMap = map['professionalId'] is Map ? map['professionalId'] as Map<String, dynamic> : <String, dynamic>{};
          final userMap = proMap['userId'] is Map ? proMap['userId'] as Map<String, dynamic> : <String, dynamic>{};

          return PaymentRecord(
            id: map['_id'] ?? map['id'],
            transactionId: 'TXN-${(map['_id'] ?? '000000').toString().substring(0, 6).toUpperCase()}',
            eventName: eventMap['eventName'] ?? '',
            role: jobMap['title'] ?? jobMap['role'] ?? '',
            amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
            date: map['paidAt'] != null ? map['paidAt'].toString().split('T').first : 'Pending',
            status: map['paymentStatus'] ?? 'Pending',
            professionalName: userMap['name'] ?? '',
            organizerName: '',
          );
        }).toList();
      }
    } catch (_) {}
    return null;
  }

  static Future<bool> updatePaymentStatus(String paymentId, String status) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/payments/$paymentId/status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'paymentStatus': status}),
      ).timeout(const Duration(seconds: 4));

      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // --- PROFESSIONALS ---
  static Future<List<ProfessionalProfile>?> getProfessionals() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/professionals'))
          .timeout(const Duration(seconds: 4));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final list = (body['data'] as List<dynamic>?) ?? [];
        return list.map((json) {
          final map = json as Map<String, dynamic>;
          final userMap = map['userId'] is Map ? map['userId'] as Map<String, dynamic> : <String, dynamic>{};
          return ProfessionalProfile(
            id: map['_id'] ?? map['id'],
            name: userMap['name'] ?? '',
            email: userMap['email'] ?? '',
            phone: userMap['phone'] ?? '',
            location: map['location'] ?? '',
            eventType: map['eventType'] ?? 'Conferences',
            skills: (map['skills'] is List)
                ? (map['skills'] as List).map((s) => s.toString()).toList()
                : [],
            experience: map['experience'] ?? '',
            rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
            verificationStatus: map['verificationStatus'] ?? 'Pending',
          );
        }).toList();
      }
    } catch (_) {}
    return null;
  }
}
