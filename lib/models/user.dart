import 'package:flutter/widgets.dart';

class User {
  final String id;
  final String username;
  final int userType;
  final String role;
  final String empNo;
  final String fullName;
  final String? hospitalId;
  final String? hospitalName;
  final String? email;
  final String? address;
  final String? contactNo;
  final String instituteId;
  final String instituteName;

  User({
    required this.id,
    required this.username,
    required this.userType,
    required this.role,
    required this.empNo,
    required this.fullName,
    required this.instituteId,
    required this.instituteName,
    this.hospitalId,
    this.hospitalName,
    this.email,
    this.address,
    this.contactNo,
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

    final roleKey = json['role'].toString().toLowerCase();
    return User(
      id: json['user_id'] ?? "",
      username: json['username'] ?? '',
      userType: json['user_type'] ?? 0,
      role: json['user_type_name'] ?? '',
      empNo: json[roleKey][empIdKey] ?? "",
      fullName: json[roleKey][fullNameKey] ?? '',
      hospitalId: json[roleKey]['hospital_id'],
      hospitalName: json[roleKey]['hospital_name'],
      email: json[roleKey]['email'],
      address: json[roleKey]['address'],
      contactNo: json['contact_no'],
      instituteId: json['institute_id'] ?? "",
      instituteName: json['institute_name'] ?? "",
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
      'hospital_id': hospitalId,
      'hospital_name': hospitalName,
      'email': email,
      'address': address,
      'contact_no': contactNo,
      'institute_id': instituteId,
      'institute_name': instituteName,
    };
  }

  bool get isSupervisor => userType == 1;
}
