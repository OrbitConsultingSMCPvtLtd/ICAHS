class User {
  final String id;
  final String username;
  final int userType;
  final String role;
  final String empNo;
  final String fullName;
  final String instituteId;

  User({
    required this.id,
    required this.username,
    required this.userType,
    required this.role,
    required this.empNo,
    required this.fullName,
    required this.instituteId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    String empIdKey = '';
    String fullNameKey = '';

    switch (json['user_type']) {
      case 1:
        empIdKey = 'sup_id';
        fullNameKey = 'sup_name';
        break;
      case 2:
        empIdKey = 'emp_id';
        fullNameKey = 'full_name';
        break;
      default:
    }

    return User(
      id: json['user_id'] ?? "",
      username: json['username'] ?? '',
      userType: json['user_type'] ?? 0,
      role: json['user_type_name'] ?? '',
      empNo: json[empIdKey] ?? "",
      fullName: json[fullNameKey] ?? '',
      instituteId: json['institute_id'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    String empIdKey = '';
    String fullNameKey = '';

    switch (userType) {
      case 1:
        empIdKey = 'sup_id';
        fullNameKey = 'sup_name';
        break;
      case 2:
        empIdKey = 'emp_id';
        fullNameKey = 'full_name';
        break;
      default:
    }
    return {
      'user_id': id,
      'username': username,
      'user_type': userType,
      'user_type_name': role,
      empIdKey: empNo,
      fullNameKey: fullName,
      'institute_id': instituteId,
    };
  }

  bool get isSupervisor => userType == 1;
}
