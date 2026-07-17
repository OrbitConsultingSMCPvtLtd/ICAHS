class DashboardStats {
  final int presentCount;
  final int absentCount;
  final int totalAttendanceCount;
  final int batchesCount;
  final int reportsCount;
  final int evaluationsCount;

  const DashboardStats({
    this.presentCount = 0,
    this.absentCount = 0,
    this.totalAttendanceCount = 0,
    this.batchesCount = 0,
    this.reportsCount = 0,
    this.evaluationsCount = 0,
  });

  DashboardStats copyWith({
    int? presentCount,
    int? absentCount,
    int? totalAttendanceCount,
    int? batchesCount,
    int? reportsCount,
    int? evaluationsCount,
  }) {
    return DashboardStats(
      presentCount: presentCount ?? this.presentCount,
      absentCount: absentCount ?? this.absentCount,
      totalAttendanceCount: totalAttendanceCount ?? this.totalAttendanceCount,
      batchesCount: batchesCount ?? this.batchesCount,
      reportsCount: reportsCount ?? this.reportsCount,
      evaluationsCount: evaluationsCount ?? this.evaluationsCount,
    );
  }
}