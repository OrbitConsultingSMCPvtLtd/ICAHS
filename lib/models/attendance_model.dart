class AttendanceModel {
  final String hwrAttendanceId;
  final String hwrBatchId;
  final String batchName;
  final String dated;
  final int totalStudents;
  final int present;
  final int absent;
  final String attendanceStatus;

  AttendanceModel({
    required this.hwrAttendanceId,
    required this.hwrBatchId,
    required this.batchName,
    required this.dated,
    required this.totalStudents,
    required this.present,
    required this.absent,
    required this.attendanceStatus,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
  return AttendanceModel(
    hwrAttendanceId: json['hwr_attendance_id']?.toString() ?? '',
    hwrBatchId: json['hwr_batch_id']?.toString() ?? '',
    batchName: json['batch_name'] ?? '',
    dated: json['dated'] ?? '',
    totalStudents: json['total_students'] ?? 0,
    present: json['present'] ?? 0,
    absent: json['absent'] ?? 0,
    attendanceStatus: json['attendance_status'] ?? '',
  );
}

Map<String, dynamic> toJson() {
  return {
    'hwr_attendance_id': hwrAttendanceId,
    'hwr_batch_id': hwrBatchId,
    'batch_name': batchName,
    'dated': dated,
    'total_students': totalStudents,
    'present': present,
    'absent': absent,
    'attendance_status': attendanceStatus,
  };
}
}
