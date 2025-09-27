class UserModel {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final UserType userType;
  final bool isVerified;
  final bool isActive;
  final String? profileImageUrl;
  final String? bio;
  final String? authToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    required this.userType,
    this.isVerified = false,
    this.isActive = true,
    this.profileImageUrl,
    this.bio,
    this.authToken,
    this.createdAt,
    this.updatedAt,
  });

  // Helper method for safe DateTime parsing
  static DateTime? _parseDateTime(dynamic dateString) {
    if (dateString == null) return null;
    try {
      return DateTime.parse(dateString.toString());
    } catch (e) {
      print('Error parsing date: $dateString, error: $e');
      return null;
    }
  }

  String get fullName {
    final first = firstName.isNotEmpty ? firstName : '';
    final last = lastName.isNotEmpty ? lastName : '';
    return '$first $last'.trim();
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      userType: json['userType'] != null 
          ? UserType.values.firstWhere(
              (e) => e.name == json['userType'],
              orElse: () => UserType.TENANT,
            )
          : UserType.TENANT,
      isVerified: json['isVerified'] ?? false,
      isActive: json['isActive'] ?? true,
      profileImageUrl: json['profileImageUrl'],
      bio: json['bio'],
      authToken: json['authToken'],
      createdAt: json['createdAt'] != null 
          ? UserModel._parseDateTime(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? UserModel._parseDateTime(json['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'userType': userType.name,
      'isVerified': isVerified,
      'isActive': isActive,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'authToken': authToken,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  UserModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    UserType? userType,
    bool? isVerified,
    bool? isActive,
    String? profileImageUrl,
    String? bio,
    String? authToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userType: userType ?? this.userType,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      authToken: authToken ?? this.authToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum UserType {
  LANDLORD,
  AGENT,
  TENANT,
  INVESTOR,
  ADMIN,
}

extension UserTypeExtension on UserType {
  String get displayName {
    switch (this) {
      case UserType.LANDLORD:
        return 'Landlord';
      case UserType.AGENT:
        return 'Agent';
      case UserType.TENANT:
        return 'Tenant';
      case UserType.INVESTOR:
        return 'Investor';
      case UserType.ADMIN:
        return 'Admin';
    }
  }

  String get emoji {
    switch (this) {
      case UserType.LANDLORD:
        return '🏠';
      case UserType.AGENT:
        return '🏢';
      case UserType.TENANT:
        return '🏘️';
      case UserType.INVESTOR:
        return '💰';
      case UserType.ADMIN:
        return '👨‍💼';
    }
  }
}
