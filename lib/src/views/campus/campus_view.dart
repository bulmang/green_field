import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:green_field/src/viewmodels/onboarding/onboarding_view_model.dart';
import 'package:green_field/src/views/campus/camus_floor_section.dart';
import 'package:green_field/src/views/campus/camus_map_section.dart';
import 'package:green_field/src/views/campus/campus_operating_section.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../cores/error_handler/result.dart';
import '../../model/campus.dart';
import '../../utilities/design_system/app_texts.dart';
import '../../viewmodels/campus/campus_view_model.dart';

class CampusView extends ConsumerStatefulWidget {
  const CampusView({super.key});

  @override
  _CampusViewState createState() => _CampusViewState();
}

class _CampusViewState extends ConsumerState<CampusView> {
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
    final campusState = ref.watch(campusViewModelProvider);

    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (BuildContext context) {
          tabContext = context;
          return Scaffold(
            backgroundColor: Theme.of(context).appColors.gfBackGroundColor,
            appBar: _buildAppBar(campusState),
            body: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildCategoryTitle('위치 / 교통', 0),
                    campusState.isLoading
                        ?  SizedBox(
                      height: 223,
                      child: Skeletonizer.zone(
                        effect: ShimmerEffect(
                          baseColor: Theme.of(context).appColors.gfMainBackGroundColor,
                          highlightColor: Theme.of(context).appColors.gfWhiteColor,
                          duration: const Duration(seconds: 2),
                        ),
                        child: Skeleton.leaf(
                          child: Card(
                            margin: EdgeInsets.zero,
                            shadowColor: Colors.transparent,
                            color: Theme.of(context).appColors.gfWhiteColor,
                            child: ListTile(
                              title: Bone.text(words: 3),
                              subtitle: Bone.text(),
                            ),
                          ),
                        ),
                      ),
                    )
                        : CampusMapSection(),
                    SizedBox(height: 10),
                    _buildCategoryTitle('운영시간', 1),
                    campusState.isLoading
                        ? Skeletonizer.zone(
                        effect: ShimmerEffect(
                          baseColor: Theme.of(context).appColors.gfMainBackGroundColor,
                          highlightColor:
                          Theme.of(context).appColors.gfWhiteColor,
                          duration: const Duration(seconds: 2),
                        ),
                        child: Column(
                          children: List.generate(3, (_) => ListTile(
                            title: Bone.text(words: 5),
                          )),
                        ),
                    )
                        : CampusOperatingSection(),
                    SizedBox(height: 10),
                    _buildCategoryTitle('공간 소개', 2),
                    campusState.isLoading
                        ? Skeletonizer.zone(
                      effect: ShimmerEffect(
                        baseColor: Theme.of(context).appColors.gfMainBackGroundColor,
                        highlightColor:
                        Theme.of(context).appColors.gfWhiteColor,
                        duration: const Duration(seconds: 2),
                      ),
                      child: Column(
                        children: List.generate(3, (_) => ListTile(
                          title: Bone.text(words: 5),
                        )),
                      ),
                    )
                    : CampusFloorSection(),
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
  AppBar _buildAppBar(
      AsyncValue<Campus?> campusState,
      ) {
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
              _showCampusPicker(context, (String selectedCampus) async {
                final result = await ref
                    .read(campusViewModelProvider.notifier)
                    .getCampus(selectedCampus);

                switch (result) {
                  case Success(value: final v):
                    print('t성공: $v');
                  case Failure(exception: final e):
                    ref
                        .read(campusViewModelProvider.notifier)
                        .showToast('에러가 발생했습니다');
                }
              });
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).appColors.gfMainColor, // 테두리 색상
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
                        '${campusState.value?.name ?? ''} 캠퍼스',
                        style: AppTextsTheme.main().gfHeading3.copyWith(
                              color: Theme.of(context).appColors.gfMainColor,
                            ),
                      ),
                    ),
                    SizedBox(width: 3), // Space between icon and text
                    Icon(
                      CupertinoIcons.chevron_down,
                      color: Theme.of(context).appColors.gfMainColor,
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
        indicatorColor: Theme.of(context).appColors.gfMainColor,
        labelColor: Theme.of(context).appColors.gfMainColor,
        splashFactory: NoSplash.splashFactory,
        onTap: (int index) => scrollToIndex(index),
        tabs: List.generate(3, (int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              titles[index],
              style: AppTextsTheme.main().gfTitle1.copyWith(
                    color: Theme.of(context).appColors.gfMainColor,
                  ),
            ),
          );
        }),
      ),
      backgroundColor: Theme.of(context).appColors.gfBackGroundColor,
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
                      color: Theme.of(context).appColors.gfBlackColor,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


void _showCampusPicker(BuildContext context, Function(String) onConfirm)  {
  int _selectedCampusIndex = 0;
  const List<String> _campusNames = [
    '관악',
    '영등포',
    '금천',
    '마포',
    '용산',
    '강동',
    '강서',
    '동작',
    '서대문',
    '광진',
    '중구',
    '종로',
    '성동',
    '성북',
    '동대문',
    '도봉',
    '강북1',
    '강북2',
    '노원',
    '은평',
  ];


  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 250,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  magnification: 1.2,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: 32.0,
                  scrollController: FixedExtentScrollController(initialItem: _selectedCampusIndex),
                  onSelectedItemChanged: (int index) {
                    _selectedCampusIndex = index;
                  },
                  children: _campusNames.map((reason) => Center(child: Text(reason))).toList(),
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text('확인', style: TextStyle(fontSize: 18, color: CupertinoColors.systemRed)),
                onPressed: () {
                  Navigator.pop(context); // Picker 닫기
                  onConfirm(_campusNames[_selectedCampusIndex]); // 신고 사유 전달
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}