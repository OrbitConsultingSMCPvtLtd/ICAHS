class ReportModel {
  final String reportId;
  final String studentName;
  final String studentId;
  final String reportDate;
  final String severity;
  final String severityId;
  final String? hwrBatchId;
  final String? batchName;
  final String? hospitalId;
  final String? hospitalName;
  final String? issueTypeId;
  final String? issueTypeName;
  final String? actionRequiredId;
  final String? actionRequiredName;
  final String? supId;
  final String? issueDetails;
  final String? recommendedAction;
  final String? reportedBy;

  ReportModel({
    required this.reportId,
    required this.studentName,
    required this.studentId,
    required this.reportDate,
    required this.severity,
    required this.severityId,
    this.hwrBatchId,
    this.batchName,
    this.hospitalId,
    this.hospitalName,
    this.issueTypeName,
    this.issueDetails,
    this.recommendedAction,
    this.reportedBy,
    this.issueTypeId,
    this.actionRequiredId,
    this.actionRequiredName,
    this.supId,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      reportId: json['report_id']?.toString() ?? '',
      studentName: json['student_name']?.toString() ?? '',
      studentId: json['student_id']?.toString() ?? '',
      reportDate: json['report_date'] ?? "",
      severityId: json['severity_id'] ?? "",
      severity: (json['severity'] ?? json['severity_name'])?.toString() ?? '',
      hwrBatchId: json['hwr_batch_id']?.toString(),
      batchName: json['batch_name']?.toString(),
      hospitalId: json['hospital_id']?.toString(),
      hospitalName: json['hospital_name']?.toString(),
      issueTypeId: json['issue_type_id']?.toString(),
      issueTypeName: json['issue_type_name']?.toString(),
      actionRequiredId: json['action_required_id']?.toString(),
      actionRequiredName: json['action_required_name']?.toString(),
      issueDetails: json['issue_details']?.toString(),
      recommendedAction: json['recommended_action']?.toString(),
      reportedBy: json['reported_by']?.toString(),
      supId: json['sup_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'report_id': reportId,
      'student_name': studentName,
      'student_id': studentId,
      'report_date': reportDate,
      'severity_id': severityId,
      'severity': severity,
      'hwr_batch_id': hwrBatchId,
      'batch_name': batchName,
      'hospital_id': hospitalId,
      'hospital_name': hospitalName,
      'issue_type_id': issueTypeId,
      'issue_type_name': issueTypeName,
      'action_required_id': actionRequiredId,
      'action_required_name': actionRequiredName,
      'issue_details': issueDetails,
      'recommended_action': recommendedAction,
      'reported_by': reportedBy,
      'sup_id': supId,
    };
  }
}
