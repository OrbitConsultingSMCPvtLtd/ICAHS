import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/auth_controller.dart';
import 'package:icahs_hwr/controllers/batch_controller.dart';
import 'package:icahs_hwr/controllers/evaluation_controller.dart';
import 'package:icahs_hwr/core/Utils/date_utils.dart';
import 'package:icahs_hwr/core/Utils/utils.dart';
import 'package:icahs_hwr/core/custom_app_bar_method.dart';
import 'package:icahs_hwr/core/helper.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';
import 'package:icahs_hwr/core/shimmer_loading.dart';
import 'package:icahs_hwr/views/home/evaluation/create_evaluation_page.dart';
import 'package:icahs_hwr/widgets/my_input_label.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class EvaluationDetailsPage extends StatefulWidget {
  const EvaluationDetailsPage({
    super.key,
    required this.batchId,
    required this.evaluationId,
  });

  final String batchId;
  final String evaluationId;

  @override
  State<EvaluationDetailsPage> createState() => _EvaluationDetailsPageState();
}

class _EvaluationDetailsPageState extends State<EvaluationDetailsPage>
    with WidgetsBindingObserver {
  final EvaluationController _evaluationController =
      Get.find<EvaluationController>();
  final BatchController _batchController = Get.find<BatchController>();
  final AuthController _authController = Get.find<AuthController>();

  void _handleDelete() async {
    final delete = await deleteDialog(
      context,
      title: "Delete?",
      content:
          "This Evaluation record will be permanently deleted. Are you sure you want to delete it?",
      onTap: () async {
        var result = await _evaluationController.deleteEvaluation(
          widget.batchId,
          widget.evaluationId,
        );

        showSnackBar(
          result['status'].toString().toLowerCase().capitalize!,
          result['message'],
          color: result['status'] == "SUCCESS"
              ? MyColorPalette.success
              : MyColorPalette.error,
        );

        if (!mounted) return;
        Navigator.pop(context, true);
      },
    );

    if (delete == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _evaluationController.loadEvaluationDetails(
        widget.batchId,
        widget.evaluationId,
      );
    });
    super.initState();
  }

  @override
  build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Obx(() {
          if (_evaluationController.isDetailLoading.value) {
            return const ShimmerLoading();
          }

          if (_evaluationController.evaluationDetail.value == null) {
            return const Center(child: Text("No evaluation found"));
          }

          final evaluation = _evaluationController.evaluationDetail.value;

          return ListView(
            children: [
              _buildStudentInfoCard(),
              _buildScoreCard(
                "Attendance and Punctuality (AP) ",
                [
                  {
                    "title": "Arrives on Time",
                    "score": evaluation?.scoreAot?.toString() ?? "0",
                    "remarks": _evaluationController
                        .evaluationDetail
                        .value
                        ?.remarksAot,
                  },
                  {
                    "title": "Complete Duty Hour",
                    "score": evaluation?.scoreCdh?.toString() ?? "0",
                    "remarks": _evaluationController
                        .evaluationDetail
                        .value
                        ?.remarksCdh,
                  },
                  {
                    "title": "Follow Timing Strictly",
                    "score": evaluation?.scoreFts?.toString() ?? "0",
                    "remarks": _evaluationController
                        .evaluationDetail
                        .value
                        ?.remarksFts,
                  },
                  {
                    "title": "Leave only with Permission",
                    "score": evaluation?.scoreLowp?.toString() ?? "0",
                    "remarks": _evaluationController
                        .evaluationDetail
                        .value
                        ?.remarksLowp,
                  },
                ],
                evaluation?.scoreAp?.toString() ?? "0",
              ),
              _buildScoreCard(
                "Discipline and Compliance (DC) ",
                [
                  {
                    "title": "Mobile Phone Usage",
                    "score": evaluation?.scoreMpu?.toString() ?? "0",
                    "remarks": _evaluationController
                        .evaluationDetail
                        .value
                        ?.remarksMpu,
                  },
                  {
                    "title": "Follow Hospital SOPs",
                    "score": evaluation?.scoreFhs?.toString() ?? "0",
                    "remarks": _evaluationController
                        .evaluationDetail
                        .value
                        ?.remarksFhs,
                  },
                  {
                    "title": "Maintain Professional Environment",
                    "score": evaluation?.scoreMpe?.toString() ?? "0",
                    "remarks": _evaluationController
                        .evaluationDetail
                        .value
                        ?.remarksMpe,
                  },
                  {
                    "title": "Avoid Unnecessary Convertion",
                    "score": evaluation?.scoreAuc?.toString() ?? "0",
                    "remarks": _evaluationController
                        .evaluationDetail
                        .value
                        ?.remarksAuc,
                  },
                  {
                    "title": "Stay at Assigned Duty Station",
                    "score": evaluation?.scoreSad?.toString() ?? "0",
                    "remarks": _evaluationController
                        .evaluationDetail
                        .value
                        ?.remarksSad,
                  },
                ],
                evaluation?.scoreDc?.toString() ?? "0",
              ),
              _buildScoreCard("Learning Behaviour (LB) ", [
                {
                  "title": "Show Interest in Learning",
                  "score": evaluation?.scoreSiil?.toString() ?? "0",
                  "remarks":
                      _evaluationController.evaluationDetail.value?.remarksSiil,
                },
                {
                  "title": "Attention towards Assigned Work",
                  "score": evaluation?.scoreAtaw?.toString() ?? "0",
                  "remarks":
                      _evaluationController.evaluationDetail.value?.remarksAtaw,
                },
                {
                  "title": "Avoids Disturbance",
                  "score": evaluation?.scoreAd?.toString() ?? "0",
                  "remarks": evaluation?.remarksAd,
                },
                {
                  "title": "Observe Procedure Carefully",
                  "score": evaluation?.scoreOpc?.toString() ?? "0",
                  "remarks":
                      _evaluationController.evaluationDetail.value?.remarksOpc,
                },
                {
                  "title": "Ask Relevent Question",
                  "score": evaluation?.scoreArq?.toString() ?? "0",
                  "remarks":
                      _evaluationController.evaluationDetail.value?.remarksArq,
                },
                {
                  "title": "Applies Knowledge Practically",
                  "score": evaluation?.scoreAkp?.toString() ?? "0",
                  "remarks":
                      _evaluationController.evaluationDetail.value?.remarksAkp,
                },
              ], evaluation?.scoreLb?.toString() ?? "0"),
              _buildScoreCard(
                "Clinical Skill and Performance (CSP) ",
                [
                  {
                    "title": "Handling of Instruments",
                    "score": evaluation?.scoreHoi?.toString() ?? "0",
                    "remarks": _evaluationController
                        .evaluationDetail
                        .value
                        ?.remarksHoi,
                  },
                  {
                    "title": "Infection Controll Practice",
                    "score": evaluation?.scoreIcp?.toString() ?? "0",
                    "remarks": _evaluationController
                        .evaluationDetail
                        .value
                        ?.remarksIcp,
                  },
                  {
                    "title": "Patient Handling",
                    "score": evaluation?.scorePh?.toString() ?? "0",
                    "remarks": evaluation?.remarksPh,
                  },
                  {
                    "title": "Assistant in Procedure",
                    "score": evaluation?.scoreAip?.toString() ?? "0",
                    "remarks": _evaluationController
                        .evaluationDetail
                        .value
                        ?.remarksAip,
                  },
                  {
                    "title": "Logbook Maintenance",
                    "score": evaluation?.scoreLbm?.toString() ?? "0",
                    "remarks": _evaluationController
                        .evaluationDetail
                        .value
                        ?.remarksLbm,
                  },
                ],
                evaluation?.scoreCsp?.toString() ?? "0",
              ),
              _buildScoreCard(
                "Work Ethics and Professionalism (WEP) ",
                [
                  {
                    "title": "Discipline and Behaviour",
                    "score": evaluation?.scoreDb?.toString() ?? "0",
                    "remarks": evaluation?.remarksDb,
                  },
                  {
                    "title": "Respect Towards Staff",
                    "score": evaluation?.scoreRts?.toString() ?? "0",
                    "remarks": _evaluationController
                        .evaluationDetail
                        .value
                        ?.remarksRts,
                  },
                  {
                    "title": "Respect Towards Patient",
                    "score": evaluation?.scoreRtp?.toString() ?? "0",
                    "remarks": _evaluationController
                        .evaluationDetail
                        .value
                        ?.remarksRtp,
                  },
                  {
                    "title": "Teamwork and Cooperation",
                    "score": evaluation?.scoreTwc?.toString() ?? "0",
                    "remarks": _evaluationController
                        .evaluationDetail
                        .value
                        ?.remarksTwc,
                  },
                  {
                    "title": "Dress Code Compliances",
                    "score": evaluation?.scoreDcc?.toString() ?? "0",
                    "remarks": _evaluationController
                        .evaluationDetail
                        .value
                        ?.remarksDcc,
                  },
                  {
                    "title": "Focus and Seriousness",
                    "score": evaluation?.scoreFs?.toString() ?? "0",
                    "remarks": evaluation?.remarksFs,
                  },
                  {
                    "title": "Avoid Idle Time",
                    "score": evaluation?.scoreAit?.toString() ?? "0",
                    "remarks": _evaluationController
                        .evaluationDetail
                        .value
                        ?.remarksAit,
                  },
                ],
                evaluation?.scoreWep?.toString() ?? "0",
              ),
              _buildScoreCard(
                "Attitude towards Learning (ATL) ",
                [
                  {
                    "title": "Willingness to Learn",
                    "score": evaluation?.scoreWtl?.toString() ?? "0",
                    "remarks": _evaluationController
                        .evaluationDetail
                        .value
                        ?.remarksWtl,
                  },
                  {
                    "title": "Takes Initiative",
                    "score": evaluation?.scoreTi?.toString() ?? "0",
                    "remarks": evaluation?.remarksTi,
                  },
                  {
                    "title": "Accept Feedback Positively",
                    "score": evaluation?.scoreAfp?.toString() ?? "0",
                    "remarks": _evaluationController
                        .evaluationDetail
                        .value
                        ?.remarksAfp,
                  },
                  {
                    "title": "Shows Responsibility",
                    "score": evaluation?.scoreSr?.toString() ?? "0",
                    "remarks": evaluation?.remarksSr,
                  },
                ],
                evaluation?.scoreAtl?.toString() ?? "0",
              ),
              _buildObservationCard(
                evaluation?.levelName,
                evaluation?.attitudeName,
              ),
              _buildGradeRemarksCard(
                evaluation?.marks,
                evaluation?.overallRemarks,
              ),
              const SizedBox(height: 10),
            ],
          );
        }),
        floatingActionButton: canCreateOrEdit()
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateEvaluationPage(
                        evaluationModel:
                            _evaluationController.evaluationDetail.value,
                      ),
                    ),
                  );
                },
                backgroundColor: MyColorPalette.purple,
                foregroundColor: MyColorPalette.white,
                child: Icon(LucideIcons.pencil),
              )
            : null,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return getCustomAppBar(
      context,
      title: "Evaluation Details",
      icon: Image.asset('assets/icons/evaluation-icon.png', width: 25),
      foregroundColor: MyColorPalette.white,
      backgroundColor: MyColorPalette.purple,
      hasActionsPadding: false,
      actions:
          _authController.user!.isSupervisor &&
              _batchController.batchDetail.value!.isActive()
          ? [
              IconButton(
                onPressed: _handleDelete,
                icon: Icon(
                  Icons.delete_rounded,
                  size: 28,
                  color: MyColorPalette.red,
                ),
              ),
            ]
          : null,
      hasDivider: false,
    );
  }

  Color _getChipTextColor(num marks) {
    Color color = MyColorPalette.purple;
    if (marks > 80) {
      color = MyColorPalette.green;
    } else if (marks <= 80 && marks > 60) {
      color = MyColorPalette.blue;
    } else if (marks <= 60 && marks > 40) {
      color = MyColorPalette.orange;
    } else if (marks <= 40) {
      color = MyColorPalette.red;
    }
    return color;
  }

  String _getEvaluationStatus(num marks) {
    String status = "";
    if (marks > 80) {
      status = "Excellent";
    } else if (marks <= 80 && marks > 60) {
      status = "Good";
    } else if (marks <= 60 && marks > 40) {
      status = "Average";
    } else if (marks <= 40 && marks > 20) {
      status = "Poor";
    } else if (marks <= 20) {
      status = "Very poor";
    }
    return status;
  }

  Widget _buildStudentInfoCard() {
    var eval = _evaluationController.evaluationDetail.value;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: MyColorPalette.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(25, 0, 0, 0),
            blurRadius: 4,
            spreadRadius: 2,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        crossAxisAlignment: .center,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              spacing: 8,
              children: [
                Text(
                  "${eval?.studentName} [STU${eval?.studentId}]",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MyColorPalette.darkPurple,
                  ),
                ),
                Text(eval?.batchName ?? "--"),

                Text(
                  eval?.hospitalName ?? "--",
                  style: TextStyle(color: MyColorPalette.textGrey),
                ),
                Text(
                  formatDateToDDMMMMYYYY(eval!.evaluationDate),
                  style: TextStyle(color: MyColorPalette.textGrey),
                ),
                Text(
                  "Supervisor",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  eval.supervisorName ?? "--",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              spacing: 6,
              crossAxisAlignment: .center,
              children: [
                MyInputLabel(
                  label: _getEvaluationStatus(eval.percentage),
                  textColor: _getChipTextColor(eval.percentage),
                  isRequired: false,
                  fontSize: 20,
                  height: 1,
                ),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Stack(
                    alignment: AlignmentGeometry.center,
                    children: [
                      PieChart(
                        PieChartData(
                          centerSpaceRadius: 42,
                          sections: [
                            PieChartSectionData(
                              radius: 8,
                              cornerRadius: 12,
                              value: eval.percentage.toDouble(),
                              showTitle: false,
                              color: _getChipTextColor(eval.percentage),
                            ),
                            PieChartSectionData(
                              value: 100.0 - (eval.percentage.toDouble()),
                              cornerRadius: 12,
                              radius: 8,
                              showTitle: false,
                              color: MyColorPalette.lowOpacityPurple.withAlpha(
                                5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "${eval.percentage.toStringAsFixed(1)} %",
                        style: TextStyle(
                          color: MyColorPalette.darkPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(
    String title,
    List<Map<String, dynamic>> scores,
    String sectionTotal,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: MyColorPalette.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(25, 0, 0, 0),
            blurRadius: 3,
            spreadRadius: 1,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 40,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              color: MyColorPalette.lowOpacityPurple,
            ),
            alignment: Alignment(-0.8, 0),
            child: Text(
              title,
              style: TextStyle(
                color: MyColorPalette.darkPurple,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: .start,
              spacing: 8,
              children: [
                Row(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .center,
                  children: [
                    Expanded(
                      child: Text(
                        "Scores (1 ~ 5)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Remarks",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                ...scores.map(
                  (score) => Row(
                    spacing: 8,
                    crossAxisAlignment: .center,
                    children: [
                      Expanded(
                        child: _buildScoreField(score['score'], score['title']),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            score["remarks"] ?? "No remarks",
                            style: TextStyle(
                              height: 1.5,
                              color: score['remarks'] == null
                                  ? MyColorPalette.textGrey.withAlpha(165)
                                  : MyColorPalette.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: .center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        "Section Total Score",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: _buildScoreField(
                        "$sectionTotal / ${5 * scores.length}",
                        "Total Score",
                        labelColor: MyColorPalette.purple,
                        scoreColor: MyColorPalette.purple,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreField(
    String score,
    String title, {
    Color? labelColor,
    Color? scoreColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              score,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: scoreColor ?? MyColorPalette.black,
              ),
            ),
          ),

          Positioned(
            left: 10,
            top: -9,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 2.6,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              color: Colors.white,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: labelColor ?? Colors.grey.shade700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObservationCard(
    String? levelOfSeriousness,
    String? learningAttitude,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: MyColorPalette.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(25, 0, 0, 0),
            blurRadius: 3,
            spreadRadius: 1,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 40,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              color: MyColorPalette.lowOpacityPurple,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              "Observation",
              style: TextStyle(
                color: MyColorPalette.darkPurple,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsGeometry.all(12),
            child: Row(
              crossAxisAlignment: .center,
              spacing: 8,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    mainAxisSize: .min,
                    children: [
                      MyInputLabel(
                        label: "Level of Seriousness",
                        fontSize: 16,
                        isRequired: false,
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          levelOfSeriousness ?? "--",
                          style: TextStyle(
                            height: 1.5,
                            color: levelOfSeriousness == null
                                ? MyColorPalette.textGrey.withAlpha(165)
                                : MyColorPalette.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    mainAxisSize: .min,
                    children: [
                      MyInputLabel(
                        label: "Learning Attitude",
                        fontSize: 16,
                        isRequired: false,
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          learningAttitude ?? "--",
                          style: TextStyle(
                            height: 1.5,
                            color: learningAttitude == null
                                ? MyColorPalette.textGrey.withAlpha(165)
                                : MyColorPalette.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeRemarksCard(String? totalGrade, String? overallRemarks) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: MyColorPalette.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(25, 0, 0, 0),
            blurRadius: 3,
            spreadRadius: 1,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              color: MyColorPalette.lowOpacityPurple,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              "Grand Total & Overall Remarks",
              style: TextStyle(
                color: MyColorPalette.darkPurple,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                // Total Marks
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: MyInputLabel(
                          label: "Total Marks",
                          textColor: MyColorPalette.darkPurple,
                          fontSize: 16,
                          isRequired: false,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: _buildScoreField(
                          totalGrade!,
                          "grand Total",
                          labelColor: MyColorPalette.purple,
                        ),
                      ),
                    ],
                  ),
                ),
                // Overall Remarks
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      MyInputLabel(
                        label: "Overall Remarks",
                        fontSize: 16,
                        textColor: MyColorPalette.darkPurple,
                        isRequired: false,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          overallRemarks ?? "No Remarks",
                          style: TextStyle(
                            height: 1.5,
                            color: overallRemarks == null
                                ? MyColorPalette.textGrey.withAlpha(165)
                                : MyColorPalette.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
