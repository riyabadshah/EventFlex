import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class AppDataState extends ChangeNotifier {
  static final AppDataState instance = AppDataState._internal();
  AppDataState._internal() {
    _initData();
    _syncWithBackend();
  }

  // Active user mode
  String currentRole = 'Organizer'; // 'Organizer' | 'Professional' | 'Admin'
  
  // Active profiles
  late OrganizerProfile currentOrganizer;
  late ProfessionalProfile currentProfessional;

  // Lists
  List<EventItem> events = [];
  List<JobApplication> applications = [];
  List<WorkforceMember> workforce = [];
  List<PaymentRecord> payments = [];
  List<ReviewItem> reviews = [];
  List<ChatMessage> messages = [];
  List<NotificationItem> notifications = [];
  List<ProfessionalProfile> allProfessionals = [];

  // Notifications badge
  int get unreadNotificationsCount =>
      notifications.where((n) => !n.isRead).length;

  void setRole(String role) {
    currentRole = role;
    notifyListeners();
  }

  void _initData() {
    currentOrganizer = OrganizerProfile(
      name: '',
      companyName: '',
      email: '',
      phone: '',
      location: '',
      verificationStatus: 'Pending',
      activeEventsCount: 0,
      totalHiredCount: 0,
      totalSpent: 0,
      avatarUrl: '',
    );

    currentProfessional = ProfessionalProfile(
      name: '',
      email: '',
      phone: '',
      location: '',
      eventType: 'Conferences',
      experience: '',
      skills: [],
      verificationStatus: 'Pending',
      rating: 0.0,
      completedJobs: 0,
      totalEarnings: 0,
      profileCompletion: 0,
      bio: '',
      certifications: [],
      portfolio: '',
      isAvailable: true,
      details: {},
    );

    allProfessionals = [];
    events = [];
    applications = [];
    workforce = [];
    payments = [];
    reviews = [];
    messages = [];
    notifications = [];
  }

  Future<void> _syncWithBackend() async {
    try {
      final liveEvents = await ApiService.getEvents();
      if (liveEvents != null) {
        events = liveEvents;
      }

      final liveApps = await ApiService.getApplications();
      if (liveApps != null) {
        applications = liveApps;
      }

      final liveAtt = await ApiService.getAttendance();
      if (liveAtt != null) {
        workforce = liveAtt;
      }

      final livePayments = await ApiService.getPayments();
      if (livePayments != null) {
        payments = livePayments;
      }

      final livePros = await ApiService.getProfessionals();
      if (livePros != null) {
        allProfessionals = livePros;
        if (allProfessionals.isNotEmpty && currentProfessional.name.isEmpty) {
          currentProfessional = allProfessionals.first;
        }
      }

      notifyListeners();
    } catch (_) {}
  }

  // --- ACTIONS ---

  void addEvent(EventItem event) {
    events.insert(0, event);
    currentOrganizer.activeEventsCount += 1;
    notifyListeners();
    ApiService.createEvent(event);
  }

  void addStaffingRoleToEvent(String eventId, StaffingRole role) {
    final eventIndex = events.indexWhere((e) => e.id == eventId);
    if (eventIndex != -1) {
      events[eventIndex].roles.add(role);
      notifyListeners();
      ApiService.createJob(eventId, role);
    }
  }

  void applyForJob(StaffingRole role, EventItem event) {
    // Check if already applied
    final exists = applications.any(
        (a) => a.jobId == role.id && a.professionalId == currentProfessional.id);
    if (!exists) {
      final app = JobApplication(
        jobId: role.id,
        eventId: event.id,
        eventName: event.name,
        roleName: role.name,
        organizerName: event.organizerName,
        payment: role.payment,
        eventDate: role.date.isNotEmpty ? role.date : event.date,
        location: role.location.isNotEmpty ? role.location : event.location,
        professionalId: currentProfessional.id,
        professionalName: currentProfessional.name,
        professionalPhoto: currentProfessional.profilePhoto,
        professionalRating: currentProfessional.rating,
        professionalSkills: currentProfessional.skills,
        professionalExperience: currentProfessional.experience,
        professionalLocation: currentProfessional.location,
        status: 'Applied',
        matchScore: 94,
      );
      applications.insert(0, app);
      notifications.insert(
        0,
        NotificationItem(
          title: 'Application Submitted',
          message: 'Applied for "${role.name}" at ${event.name}.',
          type: 'application',
          timeAgo: 'Just now',
        ),
      );
      notifyListeners();
      ApiService.applyForJob(role.id, currentProfessional.id);
    }
  }

  void updateApplicationStatus(String applicationId, String newStatus) {
    final idx = applications.indexWhere((a) => a.id == applicationId);
    if (idx != -1) {
      applications[idx].status = newStatus;
      
      // If accepted, add to workforce automatically
      if (newStatus == 'Accepted') {
        final app = applications[idx];
        final existsInWf = workforce.any((w) =>
            w.eventId == app.eventId && w.professionalId == app.professionalId);
        if (!existsInWf) {
          workforce.insert(
            0,
            WorkforceMember(
              eventId: app.eventId,
              eventName: app.eventName,
              professionalId: app.professionalId,
              professionalName: app.professionalName,
              role: app.roleName,
              date: app.eventDate,
              paymentAmount: app.payment,
              status: 'Confirmed',
            ),
          );
        }
      }
      notifyListeners();
      ApiService.updateApplicationStatus(applicationId, newStatus);
    }
  }

  void markAttendance(String workforceId, String status, {String? checkIn, String? checkOut}) {
    final idx = workforce.indexWhere((w) => w.id == workforceId);
    if (idx != -1) {
      workforce[idx].attendanceStatus = status;
      if (checkIn != null) workforce[idx].checkInTime = checkIn;
      if (checkOut != null) workforce[idx].checkOutTime = checkOut;
      if (status == 'Present') {
        workforce[idx].status = 'Working';
      }
      notifyListeners();
      ApiService.recordCheckIn(workforce[idx].eventId, workforce[idx].professionalId);
    }
  }

  void markWorkforcePaid(String workforceId) {
    final idx = workforce.indexWhere((w) => w.id == workforceId);
    if (idx != -1) {
      final member = workforce[idx];
      member.paymentStatus = 'Paid';
      member.status = 'Completed';
      
      payments.insert(
        0,
        PaymentRecord(
          transactionId: 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          eventName: member.eventName,
          role: member.role,
          amount: member.paymentAmount,
          date: 'Today',
          status: 'Paid',
          professionalName: member.professionalName,
          organizerName: currentOrganizer.companyName,
        ),
      );
      notifyListeners();
      ApiService.updatePaymentStatus(member.id, 'Paid');
    }
  }

  void addReview(ReviewItem review) {
    reviews.insert(0, review);
    notifyListeners();
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    final msg = ChatMessage(
      conversationId: 'conv_1',
      senderId: currentRole == 'Organizer' ? 'org_1' : currentProfessional.id,
      senderName: currentRole == 'Organizer'
          ? currentOrganizer.name
          : currentProfessional.name,
      senderRole: currentRole,
      receiverId: currentRole == 'Organizer' ? currentProfessional.id : 'org_1',
      message: text.trim(),
      timestamp: 'Just now',
      isMe: true,
    );
    messages.add(msg);
    notifyListeners();
  }

  void receiveMessage(ChatMessage msg) {
    messages.add(msg);
    notifyListeners();
  }

  void markAllNotificationsAsRead() {
    for (var n in notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void updateProfessionalVerification(String proId, String status) {
    final idx = allProfessionals.indexWhere((p) => p.id == proId);
    if (idx != -1) {
      allProfessionals[idx].verificationStatus = status;
      if (currentProfessional.id == proId) {
        currentProfessional.verificationStatus = status;
      }
      notifyListeners();
    }
  }
}
