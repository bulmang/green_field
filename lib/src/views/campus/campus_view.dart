import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_field/src/views/campus/camus_floor_section.dart';
import 'package:green_field/src/views/campus/camus_map_section.dart';
import 'package:green_field/src/views/campus/campus_operating_section.dart';

import '../../design_system/app_colors.dart';
import '../../design_system/app_texts.dart';

class CampusView extends StatefulWidget {
  const CampusView({super.key});

  @override
  _CampusViewState createState() => _CampusViewState();
}

class _CampusViewState extends State<CampusView> {
  /// Categories keys
  final List<GlobalKey> campusCategories = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  /// Scroll Controller
  late ScrollController scrollController;

  /// Tab Context
  BuildContext? tabContext;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(animateToTab);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  /// Animate To Tab
  void animateToTab() {
    for (var i = 0; i < campusCategories.length; i++) {
      final context = campusCategories[i].currentContext;
      if (context != null) {
        RenderBox box = context.findRenderObject() as RenderBox;
        Offset position = box.localToGlobal(Offset.zero);
        if (scrollController.offset >= position.dy) {
          DefaultTabController.of(tabContext!).animateTo(
            i,
            duration: const Duration(milliseconds: 100),
          );
        }
      }
    }
  }

  /// Scroll to Index
  void scrollToIndex(int index) async {
    scrollController.removeListener(animateToTab);
    final categoriesContext = campusCategories[index].currentContext;
    if (categoriesContext != null) {
      await Scrollable.ensureVisible(
        categoriesContext,
        duration: const Duration(milliseconds: 100),
      );
    }
    scrollController.addListener(animateToTab);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (BuildContext context) {
          tabContext = context;
          return Scaffold(
            appBar: _buildAppBar(),
            body: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildCategoryTitle('위치 / 교통', 0),
                    CampusMapSection(),
                    SizedBox(height: 10),
                    _buildCategoryTitle('운영시간', 1),
                    CampusOperatingSection(),
                    SizedBox(height: 10),
                    _buildCategoryTitle('공간 소개', 2),
                    CampusFloorSection(),
                    SizedBox(height: 10),
                    // Empty Bottom Space
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// AppBar
  AppBar _buildAppBar() {
    List<String> titles = [
      '위치',
      '운영시간',
      '공간소개',
    ];

    return AppBar(
      title: Row(
        children: [
          Spacer(),
          CupertinoButton(
            onPressed: () {

            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColorsTheme().gfMainColor, // 테두리 색상
                  width: 1, // 테두리 두께
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: Text(
                        '관악 캠퍼스',
                        style: AppTextsTheme.main().gfHeading3.copyWith(
                              color: AppColorsTheme().gfMainColor,
                            ),
                      ),
                    ),
                    SizedBox(width: 3), // Space between icon and text
                    Icon(
                      CupertinoIcons.chevron_down,
                      color: AppColorsTheme().gfMainColor,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Spacer()
        ],
      ),
      bottom: TabBar(
        indicatorColor: AppColorsTheme().gfMainColor,
        labelColor: AppColorsTheme().gfMainColor,
        splashFactory: NoSplash.splashFactory,
        onTap: (int index) => scrollToIndex(index),
        tabs: List.generate(3, (int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              titles[index],
              style: AppTextsTheme.main().gfTitle1.copyWith(
                    color: AppColorsTheme().gfMainColor,
                  ),
            ),
          );
        }),
      ),
      backgroundColor: AppColorsTheme().gfBackGroundColor,
    );
  }

  /// Category Title
  Widget _buildCategoryTitle(String title, int index) {
    return Padding(
      key: campusCategories[index],
      padding: const EdgeInsets.only(bottom: 8, top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextsTheme.main().gfTitle1.copyWith(
                      color: AppColorsTheme().gfBlackColor,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
