class EvaluationModel {
  EvaluationModel({
    required this.evaluationId,
    required this.studentId,
    required this.studentName,
    required this.evaluationDate,
    required this.grandTotal,
    required this.marks,
    required this.percentage,
    this.hwrBatchId,
    this.batchName,
    this.hospitalId,
    this.hospitalName,
    this.empNo,
    this.supId,
    this.supervisorName,
    this.scoreAp,
    this.totalScoreAp,
    this.scoreAot,
    this.remarksAot,
    this.scoreCdh,
    this.remarksCdh,
    this.scoreFts,
    this.remarksFts,
    this.scoreLowp,
    this.remarksLowp,
    this.scoreDc,
    this.totalScoreDc,
    this.scoreMpu,
    this.remarksMpu,
    this.scoreFhs,
    this.remarksFhs,
    this.scoreMpe,
    this.remarksMpe,
    this.scoreAuc,
    this.remarksAuc,
    this.scoreSad,
    this.remarksSad,
    this.scoreLb,
    this.totalScoreLb,
    this.scoreSiil,
    this.remarksSiil,
    this.scoreAtaw,
    this.remarksAtaw,
    this.scoreAd,
    this.remarksAd,
    this.scoreOpc,
    this.remarksOpc,
    this.scoreArq,
    this.remarksArq,
    this.scoreAkp,
    this.remarksAkp,
    this.scoreCsp,
    this.totalScoreCsp,
    this.scoreHoi,
    this.remarksHoi,
    this.scoreIcp,
    this.remarksIcp,
    this.scorePh,
    this.remarksPh,
    this.scoreAip,
    this.remarksAip,
    this.scoreLbm,
    this.remarksLbm,
    this.scoreWep,
    this.totalScoreWep,
    this.scoreDb,
    this.remarksDb,
    this.scoreRts,
    this.remarksRts,
    this.scoreRtp,
    this.remarksRtp,
    this.scoreTwc,
    this.remarksTwc,
    this.scoreDcc,
    this.remarksDcc,
    this.scoreFs,
    this.remarksFs,
    this.scoreAit,
    this.remarksAit,
    this.scoreAtl,
    this.totalScoreAtl,
    this.scoreWtl,
    this.remarksWtl,
    this.scoreTi,
    this.remarksTi,
    this.scoreAfp,
    this.remarksAfp,
    this.scoreSr,
    this.remarksSr,
    this.levelId,
    this.levelName,
    this.attitudeId,
    this.attitudeName,
    this.overallRemarks,
    this.entryDate,
    this.enteredBy,
    this.editDate,
    this.editedBy,
  });

  final String evaluationId;
  final String studentId;
  final String studentName;
  final String evaluationDate;
  final int grandTotal;
  final String marks;
  final num percentage;

  final String? hwrBatchId;
  final String? batchName;
  final String? hospitalId;
  final String? hospitalName;
  final String? empNo;
  final String? supId;
  final String? supervisorName;

  // Attendance and Punctuality
  final int? scoreAp;
  final int? totalScoreAp;
  final int? scoreAot;
  final String? remarksAot;
  final int? scoreCdh;
  final String? remarksCdh;
  final int? scoreFts;
  final String? remarksFts;
  final int? scoreLowp;
  final String? remarksLowp;

  // Discipline and Compliance
  final int? scoreDc;
  final int? totalScoreDc;
  final int? scoreMpu;
  final String? remarksMpu;
  final int? scoreFhs;
  final String? remarksFhs;
  final int? scoreMpe;
  final String? remarksMpe;
  final int? scoreAuc;
  final String? remarksAuc;
  final int? scoreSad;
  final String? remarksSad;

  // Learning Behaviour
  final int? scoreLb;
  final int? totalScoreLb;
  final int? scoreSiil;
  final String? remarksSiil;
  final int? scoreAtaw;
  final String? remarksAtaw;
  final int? scoreAd;
  final String? remarksAd;
  final int? scoreOpc;
  final String? remarksOpc;
  final int? scoreArq;
  final String? remarksArq;
  final int? scoreAkp;
  final String? remarksAkp;

  // Clinical Skill and Performance
  final int? scoreCsp;
  final int? totalScoreCsp;
  final int? scoreHoi;
  final String? remarksHoi;
  final int? scoreIcp;
  final String? remarksIcp;
  final int? scorePh;
  final String? remarksPh;
  final int? scoreAip;
  final String? remarksAip;
  final int? scoreLbm;
  final String? remarksLbm;

  // Work Ethics and Professionalism
  final int? scoreWep;
  final int? totalScoreWep;
  final int? scoreDb;
  final String? remarksDb;
  final int? scoreRts;
  final String? remarksRts;
  final int? scoreRtp;
  final String? remarksRtp;
  final int? scoreTwc;
  final String? remarksTwc;
  final int? scoreDcc;
  final String? remarksDcc;
  final int? scoreFs;
  final String? remarksFs;
  final int? scoreAit;
  final String? remarksAit;

  // Attitude towards Learning
  final int? scoreAtl;
  final int? totalScoreAtl;
  final int? scoreWtl;
  final String? remarksWtl;
  final int? scoreTi;
  final String? remarksTi;
  final int? scoreAfp;
  final String? remarksAfp;
  final int? scoreSr;
  final String? remarksSr;

  //other Info
  final String? levelId;
  final String? levelName;
  final String? attitudeId;
  final String? attitudeName;
  final String? overallRemarks;
  final String? entryDate;
  final String? enteredBy;
  final String? editDate;
  final String? editedBy;

  factory EvaluationModel.fromJson(Map<String, dynamic> json) {
    return EvaluationModel(
      evaluationId: json["evaluation_id"]?.toString() ?? "",
      studentId: json["student_id"]?.toString() ?? "",
      studentName: json["student_name"]?.toString() ?? "",
      evaluationDate: json["evaluation_date"]?.toString() ?? "",
      grandTotal: json["grand_total"] ?? "0",
      marks: json["marks"]?.toString() ?? "",
      percentage: json["percentage"] ?? 0,

      hwrBatchId: json["hwr_batch_id"]?.toString(),
      batchName: json["batch_name"]?.toString(),
      hospitalId: json["hospital_id"]?.toString(),
      hospitalName: json["hospital_name"]?.toString(),
      empNo: json["emp_no"]?.toString(),
      supId: json["sup_id"]?.toString(),
      supervisorName: json["supervisor_name"]?.toString(),

      // Attendance and Punctuality
      scoreAp: json["ap"],
      totalScoreAp: json["total_score_ap"],
      scoreAot: json["score_aot"],
      remarksAot: json["remarks_aot"]?.toString(),
      scoreCdh: json["score_cdh"],
      remarksCdh: json["remarks_cdh"]?.toString(),
      scoreFts: json["score_fts"],
      remarksFts: json["remarks_fts"]?.toString(),
      scoreLowp: json["score_lowp"],
      remarksLowp: json["remarks_lowp"]?.toString(),

      // Discipline and Compliance
      scoreDc: json["dc"],
      totalScoreDc: json["total_score_dc"],
      scoreMpu: json["score_mpu"], // Mobile Phone Usage
      remarksMpu: json["remarks_mpu"]?.toString(),
      scoreFhs: json["score_fhs"], // Follow Hospital SOPs
      remarksFhs: json["remarks_fhs"]?.toString(),
      scoreMpe: json["score_mpe"], // Maintain Professional Environment
      remarksMpe: json["remarks_mpe"]?.toString(),
      scoreAuc: json["score_auc"], // Avoid Unnecessary Convertion
      remarksAuc: json["remarks_auc"]?.toString(),
      scoreSad: json["score_sad"], // Stay at Assigned Duty Station
      remarksSad: json["remarks_sad"]?.toString(),

      // Learning Behaviour
      scoreLb: json["lb"],
      totalScoreLb: json["total_score_lb"],
      scoreSiil: json["siil"], // Show Interest in Learning
      remarksSiil: json["remarks_siil"]?.toString(),
      scoreAtaw: json["score_ataw"], // Attention towards Assigned Work
      remarksAtaw: json["remarks_ataw"]?.toString(),
      scoreAd: json["score_ad"], // Avoids Disturbance
      remarksAd: json["remarks_ad"]?.toString(),
      scoreOpc: json["score_opc"], // Observe Procedure Carefully
      remarksOpc: json["remarks_opc"]?.toString(),
      scoreArq: json["score_arq"], // Ask Relevent Question
      remarksArq: json["remarks_arq"]?.toString(),
      scoreAkp: json["score_akp"], // Applies Knowledge Practically
      remarksAkp: json["remarks_akp"]?.toString(),

      // Clinical Skill and Performance
      scoreCsp: json["csp"],
      totalScoreCsp: json["total_score_csp"],
      scoreHoi: json["score_hoi"], // Handling of Instruments
      remarksHoi: json["remarks_hoi"]?.toString(),
      scoreIcp: json["score_icp"], // Infection Controll Practice
      remarksIcp: json["remarks_icp"]?.toString(),
      scorePh: json["score_ph"], // Patient Handling
      remarksPh: json["remarks_ph"]?.toString(),
      scoreAip: json["score_aip"], // Assistant in Procedure
      remarksAip: json["remarks_aip"]?.toString(),
      scoreLbm: json["score_lbm"], // Logbook Maintenance
      remarksLbm: json["remarks_lbm"]?.toString(),

      // Work Ethics and Professionalism
      scoreWep: json["wep"],
      totalScoreWep: json["total_score_wep"],
      scoreDb: json["score_db"], // Discipline and Behaviour
      remarksDb: json["remarks_db"]?.toString(),
      scoreRts: json["score_rts"], // Respect Towards Staff
      remarksRts: json["remarks_rts"]?.toString(),
      scoreRtp: json["score_rtp"], // Respect Towards Patient
      remarksRtp: json["remarks_rtp"]?.toString(),
      scoreTwc: json["score_twc"], // Teamwork and Cooperation
      remarksTwc: json["remarks_twc"]?.toString(),
      scoreDcc: json["score_dcc"], // Dress Code Compliances
      remarksDcc: json["remarks_dcc"]?.toString(),
      scoreFs: json["score_fs"], // Focus and Seriousness
      remarksFs: json["remarks_fs"]?.toString(),
      scoreAit: json["score_ait"], // Avoid Idle Time
      remarksAit: json["remarks_ait"]?.toString(),

      // Attitude towards Learning
      scoreAtl: json["atl"],
      totalScoreAtl: json["total_score_atl"],
      scoreWtl: json["score_wtl"], // Willingness to Learn
      remarksWtl: json["remarks_wtl"]?.toString(),
      scoreTi: json["score_ti"], // Takes Initiative
      remarksTi: json["remarks_ti"]?.toString(),
      scoreAfp: json["score_afp"], // Accept Feedback Positively
      remarksAfp: json["remarks_afp"]?.toString(),
      scoreSr: json["score_sr"], // Shows Responsibility
      remarksSr: json["remarks_sr"]?.toString(),

      // Other Info
      levelId: json["level_id"]?.toString(),
      levelName: json["level_name"]?.toString(),
      attitudeId: json["attitude_id"]?.toString(),
      attitudeName: json["attitude_name"]?.toString(),
      overallRemarks: json["overall_remarks"]?.toString(),
      entryDate: json["entry_date"]?.toString(),
      enteredBy: json["entered_by"]?.toString(),
      editDate: json["edit_date"]?.toString(),
      editedBy: json["edited_by"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "evaluation_id": evaluationId,
      "student_id": studentId,
      "student_name": studentName,
      "evaluation_date": evaluationDate,
      "grand_total": grandTotal,
      "marks": marks,
      "percentage": percentage,

      "hwr_batch_id": hwrBatchId,
      "batch_name": batchName,
      "hospital_id": hospitalId,
      "hospital_name": hospitalName,
      "emp_no": empNo,
      "sup_id": supId,
      "supervisor_name": supervisorName,

      // Attendance and Punctuality
      "ap": scoreAp,
      "total_score_ap": totalScoreAp,
      "score_aot": scoreAot,
      "remarks_aot": remarksAot,
      "score_cdh": scoreCdh,
      "remarks_cdh": remarksCdh,
      "score_fts": scoreFts,
      "remarks_fts": remarksFts,
      "score_lowp": scoreLowp,
      "remarks_lowp": remarksLowp,

      // Discipline and Compliance
      "dc": scoreDc,
      "total_score_dc": totalScoreDc,
      "score_mpu": scoreMpu,
      "remarks_mpu": remarksMpu,
      "score_fhs": scoreFhs,
      "remarks_fhs": remarksFhs,
      "score_mpe": scoreMpe,
      "remarks_mpe": remarksMpe,
      "score_auc": scoreAuc,
      "remarks_auc": remarksAuc,
      "score_sad": scoreSad,
      "remarks_sad": remarksSad,

      // Learning Behaviour
      "lb": scoreLb,
      "total_score_lb": totalScoreLb,
      "siil": scoreSiil,
      "remarks_siil": remarksSiil,
      "score_ataw": scoreAtaw,
      "remarks_ataw": remarksAtaw,
      "score_ad": scoreAd,
      "remarks_ad": remarksAd,
      "score_opc": scoreOpc,
      "remarks_opc": remarksOpc,
      "score_arq": scoreArq,
      "remarks_arq": remarksArq,
      "score_akp": scoreAkp,
      "remarks_akp": remarksAkp,

      // Clinical Skill and Performance
      "csp": scoreCsp,
      "total_score_csp": totalScoreCsp,
      "score_hoi": scoreHoi,
      "remarks_hoi": remarksHoi,
      "score_icp": scoreIcp,
      "remarks_icp": remarksIcp,
      "score_ph": scorePh,
      "remarks_ph": remarksPh,
      "score_aip": scoreAip,
      "remarks_aip": remarksAip,
      "score_lbm": scoreLbm,
      "remarks_lbm": remarksLbm,

      // Work Ethics and Professionalism
      "wep": scoreWep,
      "total_score_wep": totalScoreWep,
      "score_db": scoreDb,
      "remarks_db": remarksDb,
      "score_rts": scoreRts,
      "remarks_rts": remarksRts,
      "score_rtp": scoreRtp,
      "remarks_rtp": remarksRtp,
      "score_twc": scoreTwc,
      "remarks_twc": remarksTwc,
      "score_dcc": scoreDcc,
      "remarks_dcc": remarksDcc,
      "score_fs": scoreFs,
      "remarks_fs": remarksFs,
      "score_ait": scoreAit,
      "remarks_ait": remarksAit,

      // Attitude towards Learning
      "atl": scoreAtl,
      "total_score_atl": totalScoreAtl,
      "score_wtl": scoreWtl,
      "remarks_wtl": remarksWtl,
      "score_ti": scoreTi,
      "remarks_ti": remarksTi,
      "score_afp": scoreAfp,
      "remarks_afp": remarksAfp,
      "score_sr": scoreSr,
      "remarks_sr": remarksSr,

      // Other Info
      "level_id": levelId,
      "level_name": levelName,
      "attitude_id": attitudeId,
      "attitude_name": attitudeName,
      "overall_remarks": overallRemarks,
      "entry_date": entryDate,
      "entered_by": enteredBy,
      "edit_date": editDate,
      "edited_by": editedBy,
    };
  }
}
