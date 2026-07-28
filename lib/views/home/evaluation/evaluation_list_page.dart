import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/evaluation_controller.dart';
import 'package:icahs_hwr/core/Utils/date_utils.dart';
import 'package:icahs_hwr/core/Utils/utils.dart';
import 'package:icahs_hwr/core/custom_app_bar_method.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';
import 'package:icahs_hwr/views/home/evaluation/create_evaluation_page.dart';
import 'package:icahs_hwr/views/home/evaluation/evaluation_details_page.dart';
import 'package:icahs_hwr/widgets/my_list_tile.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class EvaluationListPage extends StatefulWidget {
  const EvaluationListPage({super.key, required this.batchId});

  final String batchId;

  @override
  State<EvaluationListPage> createState() => _EvaluationListPageState();
}

class _EvaluationListPageState extends State<EvaluationListPage> {
  final EvaluationController _eval = Get.find<EvaluationController>();

  final ScrollController _scrollController = ScrollController();
  RxBool isLoadingMore = false.obs;

  void _scrollListenser() async {
    if (isLoadingMore.value || _eval.isLoading.value) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      isLoadingMore.value = true;

      await _eval.loadMoreEvaluations(widget.batchId);

      isLoadingMore.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadingEvaluations();
    _scrollController.addListener(_scrollListenser);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _eval.loadLovs();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadingEvaluations() async {
    await _eval.loadInitialEvaluations(widget.batchId);
  }

  void _handleOnTap(String batchId, String evaluationId) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            EvaluationDetailsPage(batchId: batchId, evaluationId: evaluationId),
      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadingEvaluations();
        },
        child: _buildEvaluationList(),
      ),
      floatingActionButton: canCreateOrEdit()
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CreateEvaluationPage()),
                );
              },
              backgroundColor: MyColorPalette.purple,
              foregroundColor: MyColorPalette.white,
              label: Row(
                mainAxisSize: .min,
                spacing: 8,
                children: [Icon(LucideIcons.plus), Text("Add Evaluation")],
              ),
            )
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return getCustomAppBar(
      context,
      title: "Evaluations",
      icon: Hero(
        tag: "evaluation",
        child: Image.asset('assets/icons/evaluation-icon.png', width: 25),
      ),
      foregroundColor: MyColorPalette.white,
      backgroundColor: MyColorPalette.purple,
      hasDivider: false,
    );
  }

  Widget _buildEvaluationList() {
    return Obx(() {
      if (_eval.isLoading.value) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }

      if (_eval.evaluations.isEmpty) {
        return const Center(child: Text("No Records Found!"));
      }

      return RefreshIndicator(
        onRefresh: () async {
          _loadingEvaluations();
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                var eval = _eval.evaluations[index];
                return MyListTile(
                  elevation: 0,
                  borderRadius: 6,
                  horizontalMargin: 8,
                  title:
                      "${eval.studentName.toLowerCase().capitalize} (STU${eval.studentId})",
                  sub2: formatDateToDDMMMMYYYY(eval.evaluationDate),
                  trailing: Text(
                    eval.marks,
                    style: TextStyle(
                      color: _getChipTextColor(eval.percentage),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  trailingIsChip: false,
                  alignment: .center,
                  onTap: () {
                    _handleOnTap(widget.batchId, eval.evaluationId);
                  },
                );
              }, childCount: _eval.evaluations.length),
            ),

            SliverToBoxAdapter(child: const SizedBox(height: 10)),
          ],
        ),
      );
    });
  }
}
