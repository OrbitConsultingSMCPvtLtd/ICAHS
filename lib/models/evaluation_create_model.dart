class EvaluationCreateModel {
  EvaluationCreateModel({
    this.evaluationId,
    this.studentId,
    this.evaluationDate,
    this.hwrBatchId,
    this.hospitalId,
    this.scoreAot,
    this.remarksAot,
    this.scoreCdh,
    this.remarksCdh,
    this.scoreFts,
    this.remarksFts,
    this.scoreLowp,
    this.remarksLowp,
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
    this.scoreWtl,
    this.remarksWtl,
    this.scoreTi,
    this.remarksTi,
    this.scoreAfp,
    this.remarksAfp,
    this.scoreSr,
    this.remarksSr,
    this.levelId,
    this.attitudeId,
    this.overallRemarks,
  });

  String?evaluationId;
  String? studentId;
  String? evaluationDate;

  String? hwrBatchId;
  String? hospitalId;

  // Attendance and Punctuality
  int? scoreAot;
  String? remarksAot;
  int? scoreCdh;
  String? remarksCdh;
  int? scoreFts;
  String? remarksFts;
  int? scoreLowp;
  String? remarksLowp;

  // Discipline and Compliance
  int? scoreMpu;
  String? remarksMpu;
  int? scoreFhs;
  String? remarksFhs;
  int? scoreMpe;
  String? remarksMpe;
  int? scoreAuc;
  String? remarksAuc;
  int? scoreSad;
  String? remarksSad;

  // Learning Behaviour
  int? scoreSiil;
  String? remarksSiil;
  int? scoreAtaw;
  String? remarksAtaw;
  int? scoreAd;
  String? remarksAd;
  int? scoreOpc;
  String? remarksOpc;
  int? scoreArq;
  String? remarksArq;
  int? scoreAkp;
  String? remarksAkp;

  // Clinical Skill and Performance
  int? scoreHoi;
  String? remarksHoi;
  int? scoreIcp;
  String? remarksIcp;
  int? scorePh;
  String? remarksPh;
  int? scoreAip;
  String? remarksAip;
  int? scoreLbm;
  String? remarksLbm;

  // Work Ethics and Professionalism
  int? scoreDb;
  String? remarksDb;
  int? scoreRts;
  String? remarksRts;
  int? scoreRtp;
  String? remarksRtp;
  int? scoreTwc;
  String? remarksTwc;
  int? scoreDcc;
  String? remarksDcc;
  int? scoreFs;
  String? remarksFs;
  int? scoreAit;
  String? remarksAit;

  // Attitude towards Learning
  int? scoreWtl;
  String? remarksWtl;
  int? scoreTi;
  String? remarksTi;
  int? scoreAfp;
  String? remarksAfp;
  int? scoreSr;
  String? remarksSr;

  //other Info
  String? levelId;
  String? attitudeId;
  String? overallRemarks;

  factory EvaluationCreateModel.fromJson(Map<String, dynamic> json) {
    return EvaluationCreateModel(
      evaluationId: json["evaluation_id"]?.toString() ?? "",
      studentId: json["student_id"]?.toString() ?? "",
      evaluationDate: json["evaluation_date"]?.toString() ?? "",

      hwrBatchId: json["hwr_batch_id"]?.toString(),
      hospitalId: json["hospital_id"]?.toString(),

      // Attendance and Punctuality
      scoreAot: json["score_aot"],
      remarksAot: json["remarks_aot"]?.toString(),
      scoreCdh: json["score_cdh"],
      remarksCdh: json["remarks_cdh"]?.toString(),
      scoreFts: json["score_fts"],
      remarksFts: json["remarks_fts"]?.toString(),
      scoreLowp: json["score_lowp"],
      remarksLowp: json["remarks_lowp"]?.toString(),

      // Discipline and Compliance
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
      attitudeId: json["attitude_id"]?.toString(),
      overallRemarks: json["overall_remarks"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "evaluation_id": evaluationId,
      "student_id": studentId,
      "evaluation_date": evaluationDate,

      "hwr_batch_id": hwrBatchId,
      "hospital_id": hospitalId,

      // Attendance and Punctuality
      "score_aot": scoreAot,
      "remarks_aot": remarksAot,
      "score_cdh": scoreCdh,
      "remarks_cdh": remarksCdh,
      "score_fts": scoreFts,
      "remarks_fts": remarksFts,
      "score_lowp": scoreLowp,
      "remarks_lowp": remarksLowp,

      // Discipline and Compliance
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
      "attitude_id": attitudeId,
      "overall_remarks": overallRemarks,
    };
  }
}
