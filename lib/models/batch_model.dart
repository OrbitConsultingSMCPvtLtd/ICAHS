class BatchModel {
  final String hwrBatchId;
  final String batchName;
  final String hospitalId;
  final String hospitalName;
  final String startDate;
  final String endDate;
  final String? startTime;
  final String? endTime;
  final String? remarks;
  final String status;
  // final String entryDate;
  // final String enteredBy;
  // final String editDate;
  // final String editedBy;
  final String? supervisorName;
  final int totalStudents;
  final int? presentStudents;
  final String? attendance;
  final int? totalEvaluations;
  final int? totalReports;

  const BatchModel({
    required this.hwrBatchId,
    required this.batchName,
    required this.hospitalName,
    required this.hospitalId,
    this.startTime,
    this.endTime,
    this.remarks,
    required this.status,
    this.supervisorName,
    required this.totalStudents,
    this.presentStudents,
    this.attendance,
    this.totalEvaluations,
    this.totalReports,
    required this.startDate,
    required this.endDate,
  });

  factory BatchModel.fromJson(Map<String, dynamic> json) {
    return BatchModel(
      hwrBatchId: json['hwr_batch_id'] ?? '',
      batchName: json['batch_name'] ?? '',
      hospitalName: json['hospital_name'] ?? '',
      hospitalId: json['hospital_id'] ?? '',
      startTime: json['start_time'],
      endTime: json['end_time'],
      remarks: json['remarks'],
      status: json['status'] ?? '',
      supervisorName: json['supervisor_name'],
      totalStudents: json['total_students'] ?? '',
      presentStudents: json['present_students'],
      attendance: json['attendance'],
      totalEvaluations: json['total_evaluations'],
      totalReports: json['total_reports'],
      startDate: json['start_date'] ?? "",
      endDate: json['end_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hwr_batch_id': hwrBatchId,
      'batch_name': batchName,
      'hospital_id': hospitalId,
      'hospital_name': hospitalName,
      'start_date': startDate,
      'end_date': endDate,
      'start_time': startTime,
      'end_time': endTime,
      'remarks': remarks,
      'status': status,
      'supervisor_name': supervisorName,
      'total_students': totalStudents,
      'present_students': presentStudents,
      'attendance': attendance,
      'total_evaluations': totalEvaluations,
      'total_reports': totalReports,
    };
  }

  bool isActive() {
    return status == 'Y';
  }
}
