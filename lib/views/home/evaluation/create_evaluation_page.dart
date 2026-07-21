import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/batch_controller.dart';
import 'package:icahs_hwr/controllers/evaluation_controller.dart';
import 'package:icahs_hwr/controllers/student_controller.dart';
import 'package:icahs_hwr/core/custom_app_bar_method.dart';
import 'package:icahs_hwr/core/helper.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';
import 'package:icahs_hwr/models/evaluation_create_model.dart';
import 'package:icahs_hwr/models/evaluation_model.dart';
import 'package:icahs_hwr/views/home/evaluation/evaluation_details_page.dart';
import 'package:icahs_hwr/widgets/my_button.dart';
import 'package:icahs_hwr/widgets/my_dropdown_formfield.dart';
import 'package:icahs_hwr/widgets/my_input_label.dart';
import 'package:icahs_hwr/widgets/my_text_field.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'dart:math';

const titles = [
  "Attendance and Punctuality (AP)",
  "Discipline and Compliance (DC)",
  "Learning Behaviour (LB)",
  "Clinical Skill and Performance (CSP)",
  "Work Ethics and Professionalism (WEP)",
  "Attitude towards Learning (ATL)",
];

const scoreLov = [
  {'value': '1', 'label': '1'},
  {'value': '2', 'label': '2'},
  {'value': '3', 'label': '3'},
  {'value': '4', 'label': '4'},
  {'value': '5', 'label': '5'},
];

const keys = [
  [
    {'score': 'score_aot', 'remarks': 'remarks_aot'},
    {'score': 'score_cdh', 'remarks': 'remarks_cdh'},
    {'score': 'score_fts', 'remarks': 'remarks_fts'},
    {'score': 'score_lowp', 'remarks': 'remarks_lowp'},
  ],
  [
    {'score': 'score_mpu', 'remarks': 'remarks_mpu'},
    {'score': 'score_fhs', 'remarks': 'remarks_fhs'},
    {'score': 'score_mpe', 'remarks': 'remarks_mpe'},
    {'score': 'score_auc', 'remarks': 'remarks_auc'},
    {'score': 'score_sad', 'remarks': 'remarks_sad'},
  ],
  [
    {'score': 'siil', 'remarks': 'remarks_siil'},
    {'score': 'score_ataw', 'remarks': 'remarks_ataw'},
    {'score': 'score_ad', 'remarks': 'remarks_ad'},
    {'score': 'score_opc', 'remarks': 'remarks_opc'},
    {'score': 'score_arq', 'remarks': 'remarks_arq'},
    {'score': 'score_akp', 'remarks': 'remarks_akp'},
  ],
  [
    {'score': 'score_hoi', 'remarks': 'remarks_hoi'},
    {'score': 'score_icp', 'remarks': 'remarks_icp'},
    {'score': 'score_ph', 'remarks': 'remarks_ph'},
    {'score': 'score_aip', 'remarks': 'remarks_aip'},
    {'score': 'score_lbm', 'remarks': 'remarks_lbm'},
  ],
  [
    {'score': 'score_db', 'remarks': 'remarks_db'},
    {'score': 'score_rts', 'remarks': 'remarks_rts'},
    {'score': 'score_rtp', 'remarks': 'remarks_rtp'},
    {'score': 'score_twc', 'remarks': 'remarks_twc'},
    {'score': 'score_dcc', 'remarks': 'remarks_dcc'},
    {'score': 'score_fs', 'remarks': 'remarks_fs'},
    {'score': 'score_ait', 'remarks': 'remarks_ait'},
  ],
  [
    {'score': 'score_wtl', 'remarks': 'remarks_wtl'},
    {'score': 'score_ti', 'remarks': 'remarks_ti'},
    {'score': 'score_afp', 'remarks': 'remarks_afp'},
    {'score': 'score_sr', 'remarks': 'remarks_sr'},
  ],
];

const cardBody = [
  [
    {'label': 'AOT'},
    {'label': 'CDH'},
    {'label': 'FTS'},
    {'label': 'LOWP'},
  ],
  [
    {'label': 'MPU'},
    {'label': 'FHS'},
    {'label': 'MPE'},
    {'label': 'AUC'},
    {'label': 'SAD'},
  ],
  [
    {'label': 'SIIL'},
    {'label': 'ATAW'},
    {'label': 'AD'},
    {'label': 'OPC'},
    {'label': 'ARQ'},
    {'label': 'AKP'},
  ],
  [
    {'label': 'HOI'},
    {'label': 'ICP'},
    {'label': 'PH'},
    {'label': 'AIP'},
    {'label': 'LBM'},
  ],
  [
    {'label': 'DB'},
    {'label': 'RTS'},
    {'label': 'RTP'},
    {'label': 'TWC'},
    {'label': 'DCC'},
    {'label': 'FS'},
    {'label': 'AIT'},
  ],
  [
    {'label': 'WTL'},
    {'label': 'TI'},
    {'label': 'AFP'},
    {'label': 'SR'},
  ],
];

class CreateEvaluationPage extends StatefulWidget {
  const CreateEvaluationPage({super.key, this.evaluationModel});

  final EvaluationModel? evaluationModel;

  bool get isUpdate => evaluationModel != null;

  @override
  State<CreateEvaluationPage> createState() => _CreateEvaluationPageState();
}

class _CreateEvaluationPageState extends State<CreateEvaluationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final StudentController _studentController = Get.find<StudentController>();
  final EvaluationController _evaluationController =
      Get.find<EvaluationController>();
  final BatchController _batchController = Get.find<BatchController>();

  int _currentStep = 0;
  final int _totalSteps = 7;

  late final TextEditingController dateController;
  late final TextEditingController overallRemarksController;
  late final List<TextEditingController> apRemarksControllers;
  late final List<TextEditingController> dcRemarksControllers;
  late final List<TextEditingController> lbRemarksControllers;
  late final List<TextEditingController> cspRemarksControllers;
  late final List<TextEditingController> wepRemarksControllers;
  late final List<TextEditingController> atlRemarksControllers;

  late Map<String, dynamic> evaluation;

  final Map<int, bool> _stepValidationStatus = {};

  final List<GlobalKey<FormState>> _stepFormKeys = List.generate(
    6,
    (_) => GlobalKey<FormState>(),
  );

  Future<String?> _handleDatePicker() async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2500),
      initialDate: DateTime.now(),
    );

    if (date == null) return null;

    return date.toIso8601String().split("T")[0];
  }

  void _handleButtonTap() async {
    try {
      if (!_stepFormKeys.last.currentState!.validate()) {
        return;
      }
    } on Exception catch (e) {
      showSnackBar("Error", e.toString(), color: MyColorPalette.error);
      return;
    }
    evaluation['evaluation_date'] = dateController.text.trim();

    _handleRemarks();

    Map<String, dynamic> result;
    if (!widget.isUpdate) {
      result = await _evaluationController.createEvaluation(evaluation);
    } else {
      result = await _evaluationController.updateEvaluation(evaluation);
    }

    Color color;
    if (result['status'] != 'SUCCESS') {
      color = MyColorPalette.error;
    } else {
      color = MyColorPalette.success;
    }

    showSnackBar(
      result['status'].toString().toLowerCase().capitalize!,
      result['message'],
      color: color,
    );

    if (result['status'] != 'SUCCESS') return;

    if (!mounted) return;

    if (widget.isUpdate) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => EvaluationDetailsPage(
            batchId: evaluation['hwr_batch_id'],
            evaluationId: result['evaluation_id'],
          ),
        ),
        result: (_) => null,
      );
    }
  }

  void _initializeControllers() {
    if (widget.isUpdate) {
      _initApController();
      _initDcController();
      _initLbController();
      _initCspController();
      _initWepController();
      _initAtlController();
    }
  }

  void _initApController() {
    for (var i = 0; i < keys[0].length; i++) {
      apRemarksControllers[i].text = evaluation[keys[0][i]['remarks']!] ?? "";
    }
  }

  void _initDcController() {
    for (var i = 0; i < keys[1].length; i++) {
      dcRemarksControllers[i].text = evaluation[keys[1][i]['remarks']!] ?? "";
    }
  }

  void _initLbController() {
    for (var i = 0; i < keys[2].length; i++) {
      lbRemarksControllers[i].text = evaluation[keys[2][i]['remarks']!] ?? "";
    }
  }

  void _initCspController() {
    for (var i = 0; i < keys[3].length; i++) {
      cspRemarksControllers[i].text = evaluation[keys[3][i]['remarks']!] ?? "";
    }
  }

  void _initWepController() {
    for (var i = 0; i < keys[4].length; i++) {
      wepRemarksControllers[i].text = evaluation[keys[4][i]['remarks']!] ?? "";
    }
  }

  void _initAtlController() {
    for (var i = 0; i < keys[5].length; i++) {
      atlRemarksControllers[i].text = evaluation[keys[5][i]['remarks']!] ?? "";
    }
  }

  void _handleRemarks() {
    _handleApRemarks();
    _handleDcRemarks();
    _handleLbRemarks();
    _handleCspRemarks();
    _handleWepRemarks();
    _handleAtlRemarks();
    evaluation['overall_remarks'] = overallRemarksController.text.trim();
  }

  void _handleApRemarks() {
    for (var i = 0; i < keys[0].length; i++) {
      evaluation[keys[0][i]['remarks']!] = apRemarksControllers[i].text.trim();
    }
  }

  void _handleDcRemarks() {
    for (var i = 0; i < keys[1].length; i++) {
      evaluation[keys[1][i]['remarks']!] = dcRemarksControllers[i].text.trim();
    }
  }

  void _handleLbRemarks() {
    for (var i = 0; i < keys[2].length; i++) {
      evaluation[keys[2][i]['remarks']!] = lbRemarksControllers[i].text.trim();
    }
  }

  void _handleCspRemarks() {
    for (var i = 0; i < keys[3].length; i++) {
      evaluation[keys[3][i]['remarks']!] = cspRemarksControllers[i].text.trim();
    }
  }

  void _handleWepRemarks() {
    for (var i = 0; i < keys[4].length; i++) {
      evaluation[keys[4][i]['remarks']!] = wepRemarksControllers[i].text.trim();
    }
  }

  void _handleAtlRemarks() {
    for (var i = 0; i < keys[5].length; i++) {
      evaluation[keys[5][i]['remarks']!] = atlRemarksControllers[i].text.trim();
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _goToStep(int step) {
    if (step == _currentStep) {
      return;
    }

    if (step > _currentStep) {
      if (!_validateCurrentStep()) {
        return;
      }
    }

    setState(() {
      _currentStep = step;
    });
  }

  bool _validateCurrentStep() {
    if (_currentStep > 0) {
      return _stepFormKeys[_currentStep - 1].currentState!.validate();
    } else {
      return _formKey.currentState?.validate() ?? false;
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.isUpdate) {
      evaluation = EvaluationCreateModel.fromJson(
        widget.evaluationModel!.toJson(),
      ).toJson();
    } else {
      evaluation = EvaluationCreateModel(
        hwrBatchId: _batchController.batchDetail.value!.hwrBatchId,
        hospitalId: _batchController.batchDetail.value!.hospitalId,
      ).toJson();
    }
    dateController = TextEditingController(
      text: widget.evaluationModel?.evaluationDate.split("T")[0] ?? "",
    );
    overallRemarksController = TextEditingController(
      text: widget.evaluationModel?.overallRemarks ?? "",
    );
    apRemarksControllers = List.generate(4, (_) => TextEditingController());
    dcRemarksControllers = List.generate(5, (_) => TextEditingController());
    lbRemarksControllers = List.generate(6, (_) => TextEditingController());
    cspRemarksControllers = List.generate(5, (_) => TextEditingController());
    wepRemarksControllers = List.generate(7, (_) => TextEditingController());
    atlRemarksControllers = List.generate(4, (_) => TextEditingController());

    _initializeControllers();
    for (int i = 0; i < _totalSteps; i++) {
      _stepValidationStatus[i] = false;
    }
  }

  @override
  void dispose() {
    for (var ap in apRemarksControllers) {
      ap.dispose();
    }
    for (var dc in dcRemarksControllers) {
      dc.dispose();
    }
    for (var lb in lbRemarksControllers) {
      lb.dispose();
    }
    for (var csp in cspRemarksControllers) {
      csp.dispose();
    }
    for (var wep in wepRemarksControllers) {
      wep.dispose();
    }
    for (var atl in atlRemarksControllers) {
      atl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: MyColorPalette.white,
        resizeToAvoidBottomInset: false,
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                _buildProgressIndicator(),
                const SizedBox(height: 16),
                Expanded(child: _buildCurrentStep()),
                _buildNavigationButtons(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: List.generate(_totalSteps, (index) {
          bool isActive = index == _currentStep;
          bool isCompleted = index < _currentStep;

          return Expanded(
            child: InkWell(
              radius: 18,
              onTap: () => _goToStep(index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  children: [
                    Text(
                      _getCurrntStepProgressIndicatorTitle(index),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isActive
                            ? MyColorPalette.purple
                            : MyColorPalette.textGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? MyColorPalette.purple
                            : isActive
                            ? MyColorPalette.purple
                            : MyColorPalette.textGrey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  String _getCurrntStepProgressIndicatorTitle(int index) {
    switch (index) {
      case 0:
        return "Info";
      case 1:
        return "AP";
      case 2:
        return "DC";
      case 3:
        return "LB";
      case 4:
        return "CSP";
      case 5:
        return "WEP";
      case 6:
        return "ATL";
      default:
        return "$index + 1";
    }
  }

  Widget _buildCurrentStep() {
    if (_currentStep > 0) {
      // Score card steps
      return Form(
        key: _stepFormKeys[_currentStep - 1],
        child: _buildScoreCard(
          titles[_currentStep - 1],
          cardBody[_currentStep - 1],
          _getControllers(_currentStep),
        ),
      );
    } else {
      return Form(
        key: _formKey,
        child: ListView(
          children: [
            _buildDropdownMenuInputField(
              label: "Student",
              hintText: "Select student",
              initial: evaluation['student_id'],
              entries: _studentController.studentForLov,
              onSelected: (val) {
                if (val == null) return;
                evaluation['student_id'] = val;
              },
              isEnable: !widget.isUpdate,
            ),
            _buildInputTextField(
              controller: dateController,
              label: "Report date",
              hint: "YYYY-MM-DD",
              isEndabled: !widget.isUpdate,
              onTap: () async {
                var date = await _handleDatePicker();
                dateController.text = date ?? "";
              },
              trailing: IconButton(
                onPressed: () async {
                  var date = await _handleDatePicker();
                  dateController.text = date ?? "";
                },
                icon: Icon(LucideIcons.calendarDays),
              ),
              validator: (val) {
                if (val == "" || val == null) {
                  return "Please select a date";
                }
                return null;
              },
              readOnly: true,
            ),
            _buildDropdownMenuInputField(
              label: "Learning Attitude",
              hintText: "Select learning attitude",
              initial: evaluation['attitude_id'],
              entries: _evaluationController.learningAttitudeLov,
              onSelected: (val) {
                if (val == null) return;
                evaluation['level_id'] = val;
              },
            ),
            _buildDropdownMenuInputField(
              label: "Level of Seriousness",
              hintText: "Select level of seriousness",
              initial: evaluation['level_id'],
              entries: _evaluationController.levelOfSeriousnessLov,
              onSelected: (val) {
                if (val == null) return;
                evaluation['attitude_id'] = val;
              },
            ),
            _buildInputTextField(
              controller: overallRemarksController,
              label: "Overall Remarks",
              hint: "Enter remarks",
              minLines: 3,
              isRequired: false,
            ),
          ],
        ),
      );
    }
  }

  List<TextEditingController> _getControllers(int index) {
    switch (index) {
      case 1:
        return apRemarksControllers;
      case 2:
        return dcRemarksControllers;
      case 3:
        return lbRemarksControllers;
      case 4:
        return cspRemarksControllers;
      case 5:
        return wepRemarksControllers;
      case 6:
        return atlRemarksControllers;
      default:
        return [];
    }
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: MyButton(
                onTap: _previousStep,
                color: MyColorPalette.textGrey,
                child: const Text(
                  "Previous",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            child: MyButton(
              onTap: () {
                if (_validateCurrentStep()) {
                  if (_currentStep == _totalSteps - 1) {
                    _handleButtonTap();
                  } else {
                    _nextStep();
                  }
                }
              },
              child: Text(
                _currentStep == _totalSteps - 1
                    ? (widget.isUpdate
                          ? "Update Evaluation"
                          : "Submit Evaluation")
                    : "Next",
                style: const TextStyle(
                  color: MyColorPalette.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return getCustomAppBar(
      context,
      title: widget.isUpdate ? "Update Evaluation" : "Create Evaluation",
      backgroundColor: MyColorPalette.white,
    );
  }

  Widget _buildDropdownMenuInputField({
    required String label,
    required String hintText,
    required List<Map<String, dynamic>> entries,
    required void Function(String?)? onSelected,
    required String? initial,
    bool isRequired = true,
    bool isEnable = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0, left: 12, right: 12),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          MyInputLabel(
            label: label,
            isRequired: isRequired,
            textColor: MyColorPalette.darkPurple,
          ),
          MyDropdownFormfield(
            hintText: hintText,
            entries: entries,
            initial: initial,
            isEnable: isEnable,
            width: double.infinity,
            borderColor: MyColorPalette.textGrey,
            color: MyColorPalette.white,
            borderRadius: 8,
            menuColor: const Color.fromARGB(255, 244, 245, 252),
            onSelected: onSelected,
            elevation: 2,
            maxMenuWidth: MediaQuery.widthOf(context) - 24,
            validator: (val) {
              if (val == "" || val == null) {
                return "Please select a $label";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInputTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    Widget? trailing,
    int minLines = 1,
    bool isRequired = true,
    bool readOnly = false,
    bool isEndabled = true,
    void Function()? onTap,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0, left: 12, right: 12),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          MyInputLabel(
            label: label,
            isRequired: isRequired,
            textColor: MyColorPalette.darkPurple,
          ),
          MyTextField(
            controller: controller,
            borderRadius: BorderRadius.circular(8),
            hint: hint,
            maxLines: null,
            minLines: minLines,
            isEnable: isEndabled,
            onTap: onTap,
            readOnly: readOnly,
            trailing: trailing,
            validator: validator,
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(
    String title,
    List<Map<String, dynamic>> body,
    List<TextEditingController> controllers,
  ) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          spacing: 10,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: MyColorPalette.lowOpacityPurple,
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: MyColorPalette.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
            Column(
              mainAxisSize: .min,
              children: [
                Row(
                  crossAxisAlignment: .center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: MyButton(
                        onTap: () {
                          setState(() {
                            for (var i = 0; i < body.length; i++) {
                              evaluation[keys[_currentStep - 1][i]['score']!] =
                                  5;
                              controllers[i].text = "Excellent";
                            }
                          });
                        },
                        color: MyColorPalette.green,
                        hasFixedSize: false,
                        borderRadius: 14,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: const Text(
                            "Excellent",
                            style: TextStyle(color: MyColorPalette.white),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: MyButton(
                        onTap: () {
                          setState(() {
                            for (var i = 0; i < body.length; i++) {
                              evaluation[keys[_currentStep - 1][i]['score']!] =
                                  4;
                              controllers[i].text = "Good";
                            }
                          });
                        },
                        hasFixedSize: false,
                        borderRadius: 14,
                        color: MyColorPalette.blue,
                        child: const Text(
                          "Good",
                          style: TextStyle(color: MyColorPalette.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: .center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: MyButton(
                        onTap: () {
                          setState(() {
                            for (var i = 0; i < body.length; i++) {
                              evaluation[keys[_currentStep - 1][i]['score']!] =
                                  3;
                              controllers[i].text = "Average";
                            }
                          });
                        },
                        hasFixedSize: false,
                        borderRadius: 14,
                        color: MyColorPalette.orange,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: const Text(
                            "Average",
                            style: TextStyle(color: MyColorPalette.white),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: MyButton(
                        onTap: () {
                          setState(() {
                            for (var i = 0; i < body.length; i++) {
                              evaluation[keys[_currentStep - 1][i]['score']!] =
                                  2;
                              controllers[i].text = "Poor";
                            }
                          });
                        },
                        hasFixedSize: false,
                        borderRadius: 14,
                        color: MyColorPalette.red,
                        child: const Text(
                          "Poor",
                          style: TextStyle(color: MyColorPalette.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              crossAxisAlignment: .center,
              spacing: 8,
              children: [
                Expanded(
                  flex: 2,
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      Text(
                        "Score (1 ~ 5)",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: MyColorPalette.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 20,
                        child: Text(
                          "*",
                          style: const TextStyle(
                            fontSize: 16,
                            color: MyColorPalette.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "Remarks",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: MyColorPalette.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            for (var i = 0; i < body.length; i++)
              Row(
                crossAxisAlignment: .start,
                spacing: 8,
                children: [
                  Expanded(
                    flex: 2,
                    child: MyDropdownFormfield(
                      textAlign: TextAlign.center,
                      hintText: "Select ${body[i]['label']}",
                      labelText: body[i]['label'],
                      initial: evaluation[keys[_currentStep - 1][i]['score']!]
                          .toString(),
                      entries: scoreLov,
                      width: double.infinity,
                      borderColor: MyColorPalette.textGrey,
                      color: MyColorPalette.white,
                      borderRadius: 8,
                      menuColor: const Color.fromARGB(255, 244, 245, 252),
                      onSelected: (val) {
                        evaluation[keys[_currentStep - 1][i]['score']!] =
                            int.parse(val!);
                      },
                      validator: (val) {
                        bool chk =
                            val == null || val.trim().isEmpty || val == "null";
                        if (chk) {
                          return "Please select a score";
                        } else {
                          return null;
                        }
                      },
                      elevation: 2,
                      maxMenuWidth: 150,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: MyTextField(
                      controller: controllers[i],
                      borderRadius: BorderRadius.circular(8),
                      hint: "Enter remarks",
                      maxLines: 1,
                      minLines: 1,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
