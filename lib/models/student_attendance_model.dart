class StudentAttendanceModel {
  final String studentId;
  final String studentName;
  final String studentStatus;
  final String? remarks;

  StudentAttendanceModel({
    required this.studentId,
    required this.studentName,
    required this.studentStatus,
    this.remarks,
  });

  factory StudentAttendanceModel.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceModel(
      studentId: json['student_id']?.toString() ?? '',
      studentName: json['student_name'] ?? '',
      studentStatus: json['student_status'] ?? '',
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_name': studentName,
      'student_status': studentStatus,
      'remarks': remarks,
    };
  }

  Map<String, dynamic> toNewAttendanceJson() {
    return {
      'student_id': studentId,
      'student_status': studentStatus,
      'remarks': remarks,
    };
  }
}
