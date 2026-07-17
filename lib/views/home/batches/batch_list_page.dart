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

  @override
  void initState() {
    _tabs = TabController(length: 3, vsync: this);
    loadingBatches();
    super.initState();
  }

  Future<void> loadingBatches() async {
    await _batch.loadInitialBatches();
  }

  void _handleListTileOnTap(String batchId) async {

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BatchDetailPage(batchId: batchId)),
    );
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
    return getCustomAppBar(
      context,
      title: "My Batches",
    );
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
            child: ListView.builder(
              itemCount: _batch.batches.length,
              itemBuilder: (context, index) {
                final batch = _batch.batches[index];

                return MyListTile(
                  title: batch.batchName,
                  sub1: batch.hospitalName,
                  sub2:
                      "${formatDateToDDMMMMYYYY(batch.startDate)} - ${formatDateToDDMMMMYYYY(batch.endDate)}",
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
              },
            ),
          );

        case "active":
          if (_batch.activeBatches.isEmpty) {
            return const Center(child: Text("No Active batches!"));
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              itemCount: _batch.activeBatches.length,
              itemBuilder: (context, index) {
                final batch = _batch.activeBatches[index];
                return MyListTile(
                  title: batch.batchName,
                  sub1: batch.hospitalName,
                  sub2:
                      "${formatDateToDDMMMMYYYY(batch.startDate)} - ${formatDateToDDMMMMYYYY(batch.endDate)}",
                  trailing: Text(
                    "Active",
                    style: TextStyle(color: MyColorPalette.darkGreen),
                  ),
                  chipColor: MyColorPalette.lowOpacityGreen,
                  onTap: () {
                    _handleListTileOnTap(batch.hwrBatchId);
                  },
                );
              },
            ),
          );

        case "inactive":
          if (_batch.inactiveBatches.isEmpty) {
            return const Center(child: Text("No Inactive batches!"));
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              itemCount: _batch.inactiveBatches.length,
              itemBuilder: (context, index) {
                final batch = _batch.inactiveBatches[index];

                return MyListTile(
                  title: batch.batchName,
                  sub1: batch.hospitalName,
                  sub2:
                      "${formatDateToDDMMMMYYYY(batch.startDate)} - ${formatDateToDDMMMMYYYY(batch.endDate)}",
                  trailing: Text(
                    "Inactive",
                    style: TextStyle(color: MyColorPalette.darkRed),
                  ),
                  chipColor: MyColorPalette.lowOpacityRed,
                  onTap: () {
                    _handleListTileOnTap(batch.hwrBatchId);
                  },
                );
              },
            ),
          );

        default:
          return const SizedBox();
      }
    });
  }
}
