// Models for GoWow / EventFlex Platform
// Ready for serialization with Node.js + Express + MongoDB backend

const List<String> eventTypes = [
  'Conferences',
  'Weddings',
  'Corporate Events',
  'Exhibitions',
  'Concerts',
  'Sports Events',
  'Cultural Events',
  'College Event',
  'Technical Event',
  'Non-Technical Event',
  'Other',
];

const List<String> commonStaffingRoles = [
  'Event Manager',
  'Host/Hostess',
  'Security Staff',
  'Registration Staff',
  'Photographer',
  'Videographer',
  'Technician',
  'Coordinator',
  'Volunteer',
  'Catering Staff',
  'Sound & Light Engineer',
  'Guest Relations Officer',
];

class StaffingRole {
  String id;
  String name;
  String description;
  int requiredPeople;
  int hiredCount;
  double payment;
  String requiredSkills;
  String experienceRequired;
  String workingHours;
  String date;
  String location;
  String? eventId;
  String? eventName;
  String? organizerName;
  bool isVerifiedOrganizer;

  StaffingRole({
    String? id,
    required this.name,
    required this.description,
    required this.requiredPeople,
    this.hiredCount = 0,
    required this.payment,
    required this.requiredSkills,
    this.experienceRequired = '1+ years',
    this.workingHours = '8 Hours (Full Day)',
    this.date = '',
    this.location = '',
    this.eventId,
    this.eventName,
    this.organizerName = '',
    this.isVerifiedOrganizer = false,
  }) : id = id ?? 'role_${DateTime.now().millisecondsSinceEpoch}_${name.hashCode.abs()}';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'requiredPeople': requiredPeople,
        'hiredCount': hiredCount,
        'payment': payment,
        'requiredSkills': requiredSkills,
        'experienceRequired': experienceRequired,
        'workingHours': workingHours,
        'date': date,
        'location': location,
        'eventId': eventId,
        'eventName': eventName,
        'organizerName': organizerName,
        'isVerifiedOrganizer': isVerifiedOrganizer,
      };

  factory StaffingRole.fromJson(Map<String, dynamic> json) => StaffingRole(
        id: json['id'],
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        requiredPeople: json['requiredPeople'] ?? 1,
        hiredCount: json['hiredCount'] ?? 0,
        payment: (json['payment'] as num?)?.toDouble() ?? 0.0,
        requiredSkills: json['requiredSkills'] ?? '',
        experienceRequired: json['experienceRequired'] ?? '1+ years',
        workingHours: json['workingHours'] ?? '8 Hours',
        date: json['date'] ?? '',
        location: json['location'] ?? '',
        eventId: json['eventId'],
        eventName: json['eventName'],
        organizerName: json['organizerName'] ?? 'Premier Event Group',
        isVerifiedOrganizer: json['isVerifiedOrganizer'] ?? true,
      );
}

class EventItem {
  String id;
  String name;
  String description;
  String eventType;
  String date;
  String time;
  String endTime;
  String location;
  String expectedAttendance;
  double budget;
  String contactInfo;
  String organizerId;
  String organizerName;
  String status; // 'Upcoming', 'Active', 'Completed'
  List<StaffingRole> roles;

  EventItem({
    String? id,
    required this.name,
    required this.description,
    required this.eventType,
    required this.date,
    required this.time,
    this.endTime = '6:00 PM',
    required this.location,
    this.expectedAttendance = '500+ Attendees',
    this.budget = 75000,
    this.contactInfo = 'contact@gowowevents.com',
    this.organizerId = 'org_1',
    this.organizerName = 'Apex Global Events',
    this.status = 'Upcoming',
    required this.roles,
  }) : id = id ?? 'evt_${DateTime.now().millisecondsSinceEpoch}_${name.hashCode.abs()}';

  int get totalWorkersNeeded => roles.fold(0, (acc, r) => acc + r.requiredPeople);
  int get totalWorkersHired => roles.fold(0, (acc, r) => acc + r.hiredCount);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'eventType': eventType,
        'date': date,
        'time': time,
        'endTime': endTime,
        'location': location,
        'expectedAttendance': expectedAttendance,
        'budget': budget,
        'contactInfo': contactInfo,
        'organizerId': organizerId,
        'organizerName': organizerName,
        'status': status,
        'roles': roles.map((r) => r.toJson()).toList(),
      };

  factory EventItem.fromJson(Map<String, dynamic> json) => EventItem(
        id: json['id'],
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        eventType: json['eventType'] ?? 'Conferences',
        date: json['date'] ?? '',
        time: json['time'] ?? '',
        endTime: json['endTime'] ?? '6:00 PM',
        location: json['location'] ?? '',
        expectedAttendance: json['expectedAttendance'] ?? '500+',
        budget: (json['budget'] as num?)?.toDouble() ?? 50000,
        contactInfo: json['contactInfo'] ?? '',
        organizerId: json['organizerId'] ?? 'org_1',
        organizerName: json['organizerName'] ?? '',
        status: json['status'] ?? 'Upcoming',
        roles: (json['roles'] as List<dynamic>?)
                ?.map((r) => StaffingRole.fromJson(r as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

class ProfessionalProfile {
  String id;
  String name;
  String email;
  String phone;
  String location;
  String eventType;
  String experience;
  List<String> skills;
  String profilePhoto;
  String verificationStatus; // 'Verified', 'Pending', 'Rejected'
  double rating;
  int completedJobs;
  double totalEarnings;
  int profileCompletion; // e.g. 80
  String bio;
  List<String> certifications;
  String portfolio;
  bool isAvailable;
  Map<String, String> details;

  ProfessionalProfile({
    String? id,
    required this.name,
    required this.email,
    required this.phone,
    this.location = 'Mumbai, Maharashtra',
    required this.eventType,
    this.experience = '3 years',
    List<String>? skills,
    this.profilePhoto = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&q=80',
    this.verificationStatus = 'Verified',
    this.rating = 4.9,
    this.completedJobs = 34,
    this.totalEarnings = 142500,
    this.profileCompletion = 85,
    this.bio = 'Experienced event lead, guest coordinator and registration manager with 3+ years handling large tech summits, weddings, and music festivals.',
    List<String>? certifications,
    this.portfolio = 'https://linkedin.com/in/event-pro',
    this.isAvailable = true,
    Map<String, String>? details,
  })  : id = id ?? 'pro_${DateTime.now().millisecondsSinceEpoch}',
        skills = skills ?? ['Guest Relations', 'Crowd Management', 'VIP Protocol', 'Ticketing CRM'],
        certifications = certifications ?? ['Certified Event Associate (CEA)', 'First Aid & CPR Certified'],
        details = details ?? {};

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'location': location,
        'eventType': eventType,
        'experience': experience,
        'skills': skills,
        'profilePhoto': profilePhoto,
        'verificationStatus': verificationStatus,
        'rating': rating,
        'completedJobs': completedJobs,
        'totalEarnings': totalEarnings,
        'profileCompletion': profileCompletion,
        'bio': bio,
        'certifications': certifications,
        'portfolio': portfolio,
        'isAvailable': isAvailable,
        'details': details,
      };

  factory ProfessionalProfile.fromJson(Map<String, dynamic> json) => ProfessionalProfile(
        id: json['id'],
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        location: json['location'] ?? '',
        eventType: json['eventType'] ?? 'Conferences',
        experience: json['experience'] ?? '',
        skills: (json['skills'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        profilePhoto: json['profilePhoto'] ?? '',
        verificationStatus: json['verificationStatus'] ?? 'Pending',
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        completedJobs: json['completedJobs'] ?? 0,
        totalEarnings: (json['totalEarnings'] as num?)?.toDouble() ?? 0.0,
        profileCompletion: json['profileCompletion'] ?? 0,
        bio: json['bio'] ?? '',
        certifications: (json['certifications'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        portfolio: json['portfolio'] ?? '',
        isAvailable: json['isAvailable'] ?? true,
        details: (json['details'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, v.toString())) ?? {},
      );
}

class OrganizerProfile {
  String id;
  String name;
  String companyName;
  String email;
  String phone;
  String location;
  String verificationStatus;
  int activeEventsCount;
  int totalHiredCount;
  double totalSpent;
  String avatarUrl;

  OrganizerProfile({
    String? id,
    required this.name,
    required this.companyName,
    required this.email,
    required this.phone,
    this.location = '',
    this.verificationStatus = 'Pending',
    this.activeEventsCount = 0,
    this.totalHiredCount = 0,
    this.totalSpent = 0.0,
    this.avatarUrl = '',
  }) : id = id ?? 'org_${DateTime.now().millisecondsSinceEpoch}';

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'companyName': companyName,
        'email': email,
        'phone': phone,
        'location': location,
        'verificationStatus': verificationStatus,
        'activeEventsCount': activeEventsCount,
        'totalHiredCount': totalHiredCount,
        'totalSpent': totalSpent,
        'avatarUrl': avatarUrl,
      };
}

class JobApplication {
  String id;
  String jobId;
  String eventId;
  String eventName;
  String roleName;
  String organizerName;
  double payment;
  String eventDate;
  String location;
  String professionalId;
  String professionalName;
  String professionalPhoto;
  double professionalRating;
  List<String> professionalSkills;
  String professionalExperience;
  String professionalLocation;
  bool isVerifiedPro;
  String status; // 'Applied', 'Under Review', 'Shortlisted', 'Accepted', 'Rejected'
  DateTime appliedAt;
  int matchScore; // e.g. 94%

  JobApplication({
    String? id,
    required this.jobId,
    required this.eventId,
    required this.eventName,
    required this.roleName,
    required this.organizerName,
    required this.payment,
    required this.eventDate,
    required this.location,
    required this.professionalId,
    required this.professionalName,
    required this.professionalPhoto,
    required this.professionalRating,
    required this.professionalSkills,
    required this.professionalExperience,
    required this.professionalLocation,
    this.isVerifiedPro = true,
    this.status = 'Applied',
    DateTime? appliedAt,
    this.matchScore = 88,
  })  : id = id ?? 'app_${DateTime.now().millisecondsSinceEpoch}_${professionalName.hashCode.abs()}',
        appliedAt = appliedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'jobId': jobId,
        'eventId': eventId,
        'eventName': eventName,
        'roleName': roleName,
        'organizerName': organizerName,
        'payment': payment,
        'eventDate': eventDate,
        'location': location,
        'professionalId': professionalId,
        'professionalName': professionalName,
        'professionalPhoto': professionalPhoto,
        'professionalRating': professionalRating,
        'professionalSkills': professionalSkills,
        'professionalExperience': professionalExperience,
        'professionalLocation': professionalLocation,
        'isVerifiedPro': isVerifiedPro,
        'status': status,
        'appliedAt': appliedAt.toIso8601String(),
        'matchScore': matchScore,
      };
}

class WorkforceMember {
  String id;
  String eventId;
  String eventName;
  String professionalId;
  String professionalName;
  String role;
  String date;
  String checkInTime;
  String checkOutTime;
  String totalHours;
  String attendanceStatus; // 'Present', 'Late', 'Absent'
  double performanceRating; // 1-5
  double paymentAmount;
  String paymentStatus; // 'Pending', 'Processing', 'Paid', 'Failed'
  String status; // 'Confirmed', 'Checked In', 'Working', 'Completed', 'Payment Pending', 'Paid'
  String photoUrl;
  String phone;

  WorkforceMember({
    String? id,
    required this.eventId,
    required this.eventName,
    required this.professionalId,
    required this.professionalName,
    required this.role,
    required this.date,
    this.checkInTime = '08:45 AM',
    this.checkOutTime = '05:15 PM',
    this.totalHours = '8.5 hrs',
    this.attendanceStatus = 'Present',
    this.performanceRating = 5.0,
    required this.paymentAmount,
    this.paymentStatus = 'Paid',
    this.status = 'Working',
    this.photoUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&q=80',
    this.phone = '+91 98765 43210',
  }) : id = id ?? 'wf_${DateTime.now().millisecondsSinceEpoch}_${professionalName.hashCode.abs()}';

  Map<String, dynamic> toJson() => {
        'id': id,
        'eventId': eventId,
        'eventName': eventName,
        'professionalId': professionalId,
        'professionalName': professionalName,
        'role': role,
        'date': date,
        'checkInTime': checkInTime,
        'checkOutTime': checkOutTime,
        'totalHours': totalHours,
        'attendanceStatus': attendanceStatus,
        'performanceRating': performanceRating,
        'paymentAmount': paymentAmount,
        'paymentStatus': paymentStatus,
        'status': status,
        'photoUrl': photoUrl,
        'phone': phone,
      };
}

class PaymentRecord {
  String id;
  String transactionId;
  String eventName;
  String role;
  double amount;
  String date;
  String status; // 'Pending', 'Processing', 'Paid', 'Failed'
  String professionalName;
  String organizerName;
  String paymentMethod;

  PaymentRecord({
    String? id,
    required this.transactionId,
    required this.eventName,
    required this.role,
    required this.amount,
    required this.date,
    required this.status,
    required this.professionalName,
    required this.organizerName,
    this.paymentMethod = 'UPI / Direct Bank Transfer',
  }) : id = id ?? 'pay_${DateTime.now().millisecondsSinceEpoch}';

  Map<String, dynamic> toJson() => {
        'id': id,
        'transactionId': transactionId,
        'eventName': eventName,
        'role': role,
        'amount': amount,
        'date': date,
        'status': status,
        'professionalName': professionalName,
        'organizerName': organizerName,
        'paymentMethod': paymentMethod,
      };
}

class ReviewItem {
  String id;
  String reviewerName;
  String reviewerRole; // 'Event Organizer' | 'Event Professional'
  String reviewerAvatar;
  String targetName;
  double rating;
  String comment;
  String date;
  String eventName;
  List<String> tags;

  ReviewItem({
    String? id,
    required this.reviewerName,
    required this.reviewerRole,
    required this.reviewerAvatar,
    required this.targetName,
    required this.rating,
    required this.comment,
    required this.date,
    required this.eventName,
    this.tags = const ['Punctual', 'Professional', 'Excellent Communication'],
  }) : id = id ?? 'rev_${DateTime.now().millisecondsSinceEpoch}';
}

class ChatMessage {
  String id;
  String conversationId;
  String senderId;
  String senderName;
  String senderRole;
  String receiverId;
  String message;
  String timestamp;
  bool isMe;

  ChatMessage({
    String? id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    this.senderRole = 'Professional',
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.isMe,
  }) : id = id ?? 'msg_${DateTime.now().millisecondsSinceEpoch}';
}

class NotificationItem {
  String id;
  String title;
  String message;
  String type; // 'job', 'application', 'attendance', 'payment', 'review'
  String timeAgo;
  bool isRead;

  NotificationItem({
    String? id,
    required this.title,
    required this.message,
    required this.type,
    required this.timeAgo,
    this.isRead = false,
  }) : id = id ?? 'notif_${DateTime.now().millisecondsSinceEpoch}';
}

class SmartMatchCandidate {
  final ProfessionalProfile profile;
  final int matchPercentage;
  final List<String> matchingReasons;
  final double distanceKm;

  SmartMatchCandidate({
    required this.profile,
    required this.matchPercentage,
    required this.matchingReasons,
    required this.distanceKm,
  });
}
