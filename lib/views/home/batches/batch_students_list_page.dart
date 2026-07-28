import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/student_controller.dart';
import 'package:icahs_hwr/core/custom_app_bar_method.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';
import 'package:icahs_hwr/widgets/my_list_tile.dart';

class BatchStudentsListPage extends StatefulWidget {
  const BatchStudentsListPage({
    super.key,
    required this.batchId,
    required this.batchName,
    required this.totalStudents,
  });

  final String batchId;
  final String batchName;
  final int totalStudents;

  @override
  State<BatchStudentsListPage> createState() => _BatchStudentsListPageState();
}

class _BatchStudentsListPageState extends State<BatchStudentsListPage> {
  final StudentController _student = Get.find<StudentController>();

  final ScrollController _scrollController = ScrollController();
  RxBool isLoadingMore = false.obs;

  void _loadingStudents() async {
    await _student.loadInitialStudents(widget.batchId);
  }

  void _scrollListenser() async {
    if (isLoadingMore.value || _student.isLoading.value) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      isLoadingMore.value = true;

      await _student.loadMoreStudents(widget.batchId);

      isLoadingMore.value = false;
    }
  }

  @override
  void initState() {
    _loadingStudents();
    _scrollController.addListener(_scrollListenser);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Column(
          crossAxisAlignment: .start,
          children: [_buildBatchInfoCard(), _buildStudentList()],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return getCustomAppBar(
      context,
      title: "Batch Students",
      icon: Hero(
        tag: "student",
        child: Image.asset('assets/icons/student-icon.png', width: 25),
      ),
      foregroundColor: MyColorPalette.white,
      backgroundColor: MyColorPalette.purple,
      hasDivider: false,
    );
  }

  Widget _buildBatchInfoCard() {
    var stds = widget.totalStudents;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        spacing: 6,
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        children: [
          Text(
            widget.batchName,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            "${stds.toString()} ${stds == 1 ? "student" : "students"}",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    return Expanded(
      child: Obx(() {
        if (_student.isLoading.value) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        if (_student.students.isEmpty) {
          return const Center(child: Text("No Students!"));
        }

        return RefreshIndicator(
          onRefresh: () async {
            _loadingStudents();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  var std = _student.students[index];
                  return MyListTile(
                    elevation: 0,
                    borderRadius: 6,
                    horizontalMargin: 8,
                    leading: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage('assets/icons/profile.png'),
                      ),
                    ),
                    title: "STU${std.id}",
                    sub1: std.name,
                  );
                }, childCount: _student.students.length),
              ),
            ],
          ),
        );
      }),
    );
  }
}
