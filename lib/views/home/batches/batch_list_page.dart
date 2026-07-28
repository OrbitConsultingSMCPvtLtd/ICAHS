import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/batch_controller.dart';
import 'package:icahs_hwr/core/Utils/color_utils.dart';
import 'package:icahs_hwr/core/Utils/date_utils.dart';
import 'package:icahs_hwr/core/custom_app_bar_method.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';
import 'package:icahs_hwr/views/home/batches/batch_detail_page.dart';
import 'package:icahs_hwr/widgets/my_list_tile.dart';

class BatchListPage extends StatefulWidget {
  const BatchListPage({super.key});

  @override
  State<BatchListPage> createState() => _BatchListPageState();
}

class _BatchListPageState extends State<BatchListPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final BatchController _batch = Get.find<BatchController>();

  final ScrollController allScrollController = ScrollController();
  RxBool isAllLoadingMore = false.obs;

  final ScrollController activeScrollController = ScrollController();
  RxBool isActiveLoadingMore = false.obs;

  final ScrollController inactiveScrollController = ScrollController();
  RxBool isInactiveLoadingMore = false.obs;

  Future<void> loadingBatches() async {
    await _batch.loadInitialBatches();
  }

  void _handleListTileOnTap(String batchId) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BatchDetailPage(batchId: batchId)),
    );
  }

  void _scrollListenser(RxBool loading, ScrollController controller) async {
    if (loading.value || _batch.isLoading.value) return;

    if (controller.position.pixels >=
        controller.position.maxScrollExtent - 50) {
      loading.value = true;

      await _batch.loadMoreBatches();

      loading.value = false;
    }
  }

  @override
  void initState() {
    _tabs = TabController(length: 3, vsync: this);
    allScrollController.addListener(() {
      _scrollListenser(isAllLoadingMore, allScrollController);
    });
    activeScrollController.addListener(() {
      _scrollListenser(isActiveLoadingMore, activeScrollController);
    });
    inactiveScrollController.addListener(() {
      _scrollListenser(isInactiveLoadingMore, inactiveScrollController);
    });
    loadingBatches();
    super.initState();
  }

  @override
  void dispose() {
    _tabs.dispose();
    allScrollController.dispose();
    activeScrollController.dispose();
    inactiveScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _buildBatchTileList("active", loadingBatches),
                _buildBatchTileList("inactive", loadingBatches),
                _buildBatchTileList("all", loadingBatches),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return getCustomAppBar(context, title: "My Batches", showLeading: false);
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: MyColorPalette.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 228, 228, 228),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: TabBar(
        controller: _tabs,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.label,
        splashBorderRadius: BorderRadius.circular(12),
        tabs: [
          Tab(
            child: Row(
              mainAxisSize: .min,
              crossAxisAlignment: .center,
              mainAxisAlignment: .center,
              spacing: 10,
              children: [
                Icon(
                  CupertinoIcons.checkmark_shield_fill,
                  size: 20,
                  color: MyColorPalette.green,
                ),
                Text("Active"),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: .min,
              crossAxisAlignment: .center,
              mainAxisAlignment: .center,
              spacing: 10,
              children: [
                Icon(
                  CupertinoIcons.xmark_shield_fill,
                  size: 20,
                  color: MyColorPalette.red,
                ),
                Text("Inactive"),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisSize: .min,
              crossAxisAlignment: .center,
              mainAxisAlignment: .center,
              spacing: 10,
              children: [
                Icon(
                  Icons.shield_sharp,
                  size: 20,
                  color: MyColorPalette.purple,
                ),
                Text("All"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? startEndTime(String? start, String? end) {
    if (start == null || end == null) {
      return null;
    } else {
      return "${formatTime(start)} - ${formatTime(end)}";
    }
  }

  Widget _buildBatchTileList(String filter, Future<void> Function() onRefresh) {
    return Obx(() {
      if (_batch.isLoading.value) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }

      switch (filter) {
        case "all":
          if (_batch.batches.isEmpty) {
            return const Center(child: Text("No batches found!"));
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: CustomScrollView(
              controller: allScrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final batch = _batch.batches[index];
                    return MyListTile(
                      title: batch.batchName,
                      sub1: batch.hospitalName,
                      sub2:
                          "${formatDateToDDMMMMYYYY(batch.startDate)} - ${formatDateToDDMMMMYYYY(batch.endDate)}",
                      sub3: startEndTime(batch.startTime, batch.endTime),
                      trailing: Text(
                        batch.status == "Y" ? "Active" : "Inactive",
                        style: TextStyle(
                          color: getColorFromStatus(
                            batch.status,
                            isBackground: false,
                          ),
                        ),
                      ),
                      chipColor: getColorFromStatus(
                        batch.status,
                        isBackground: true,
                      ),
                      onTap: () {
                        _handleListTileOnTap(batch.hwrBatchId);
                      },
                    );
                  }, childCount: _batch.batches.length),
                ),
              ],
            ),
          );

        case "active":
          if (_batch.activeBatches.isEmpty) {
            return const Center(child: Text("No Active batches!"));
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: CustomScrollView(
              controller: activeScrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final batch = _batch.activeBatches[index];
                    return MyListTile(
                      title: batch.batchName,
                      sub1: batch.hospitalName,
                      sub2:
                          "${formatDateToDDMMMMYYYY(batch.startDate)} - ${formatDateToDDMMMMYYYY(batch.endDate)}",
                      sub3: startEndTime(batch.startTime, batch.endTime),
                      trailing: Text(
                        "Active",
                        style: TextStyle(color: MyColorPalette.darkGreen),
                      ),
                      chipColor: MyColorPalette.lowOpacityGreen,
                      onTap: () {
                        _handleListTileOnTap(batch.hwrBatchId);
                      },
                    );
                  }, childCount: _batch.activeBatches.length),
                ),
              ],
            ),
          );
        case "inactive":
          if (_batch.inactiveBatches.isEmpty) {
            return const Center(child: Text("No Inactive batches!"));
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: CustomScrollView(
              controller: inactiveScrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final batch = _batch.inactiveBatches[index];
                    return MyListTile(
                      title: batch.batchName,
                      sub1: batch.hospitalName,
                      sub2:
                          "${formatDateToDDMMMMYYYY(batch.startDate)} - ${formatDateToDDMMMMYYYY(batch.endDate)}",
                      sub3: startEndTime(batch.startTime, batch.endTime),
                      trailing: Text(
                        "Inactive",
                        style: TextStyle(color: MyColorPalette.darkRed),
                      ),
                      chipColor: MyColorPalette.lowOpacityRed,
                      onTap: () {
                        _handleListTileOnTap(batch.hwrBatchId);
                      },
                    );
                  }, childCount: _batch.inactiveBatches.length),
                ),
              ],
            ),
          );

        default:
          return const SizedBox();
      }
    });
  }
}
