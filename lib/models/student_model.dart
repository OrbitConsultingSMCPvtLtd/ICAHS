class StudentModel {
  StudentModel({
    required this.id,
    required this.name,
    required this.programName,
    required this.programId,
    required this.hwrbatchId,
    required this.batchName,
  });

  final String id;
  final String name;
  final String programName;
  final String programId;
  final String hwrbatchId;
  final String batchName;

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['student_id']?.toString() ?? '',
      name: json['student_name']?.toString() ?? '',
      programName: json['program_name']?.toString() ?? '',
      programId: json['program_id']?.toString() ?? '',
      hwrbatchId: json['hwr_batch_id']?.toString() ?? '',
      batchName: json['batch_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': id,
      'student_name': name,
      'program_name': programName,
      'program_id': programId,
      'hwr_batch_id': hwrbatchId,
      'batch_name': batchName,
    };
  }
}