import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:green_field/src/viewmodels/recruit/recruit_edit_view_model.dart';

import '../../utilities/design_system/app_texts.dart';
import '../../utilities/enums/recruit_setting_type.dart';
import '../../viewmodels/recruit/recruit_view_model.dart';

class RecruitSettingSection extends ConsumerStatefulWidget {
  const RecruitSettingSection({super.key});

  @override
  _RecruitSettingSectionState createState() => _RecruitSettingSectionState();
}

class _RecruitSettingSectionState extends ConsumerState<RecruitSettingSection> {
  RecruitSettingType? selectedType;

  @override
  Widget build(BuildContext context) {
    final settingNotifier = ref.watch(recruitSettingProvider.notifier);
    final settingState = ref.watch(recruitSettingProvider);

    return Row(
      children: [
        _recruitSettingBox(
          icon: CupertinoIcons.time,
          text: '${settingState.selectedTime.toString()}분 후 자동삭제',
          type: RecruitSettingType.autoDeleteTime,
          settingNotifier: settingNotifier,
          settingState: settingState,
        ),
        SizedBox(width: 14),
        _recruitSettingBox(
          icon: CupertinoIcons.person_2_fill,
          text: '최대 인원수 ${settingState.selectedPerson.toString()}명',
          type: RecruitSettingType.maxPerson,
          settingNotifier: settingNotifier,
          settingState: settingState,
        ),
      ],
    );
  }

  Widget _recruitSettingBox({
    required IconData icon,
    required String text,
    required RecruitSettingNotifier settingNotifier,
    required RecruitSettingState settingState,
    required RecruitSettingType type
  }) {
    bool isSelected = selectedType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          _showReportPicker(context, type, settingNotifier, settingState, (int selected, int selectedIndex) async {
            if ((type == RecruitSettingType.autoDeleteTime)) {
              settingNotifier.updateSelectedTime(selected);
              settingNotifier.updateSelectedTimeListIndex(selectedIndex);
            } else {
              settingNotifier.updateSelectedPerson(selected);
              settingNotifier.updateSelectedPersonListIndex(selectedIndex);
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).appColors.gfMainColor : Theme.of(context).appColors.gfBackGroundColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              if (!isSelected)
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: Offset(0, 4),
                ),
            ],
          ),
          height: 70,
          child: Padding(
            padding: const EdgeInsets.only(left: 7.0, top: 9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 32, color: isSelected ? Theme.of(context).appColors.gfBackGroundColor : Theme.of(context).appColors.gfMainColor),
                SizedBox(height: 5),
                Text(
                  text,
                  style: AppTextsTheme.main().gfBody5.copyWith(
                      color: isSelected ? Theme.of(context).appColors.gfBackGroundColor : Theme.of(context).appColors.gfMainColor
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showReportPicker(BuildContext context, RecruitSettingType type, RecruitSettingNotifier settingNotifier,RecruitSettingState settingState, Function(int, int) onConfirm) {
  const List<String> timeList = [
    '60',
    '90',
    '120',
  ];

  const List<String> maxParticipants = [
    '2',
    '3',
    '4',
  ];

  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 150,
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
                  scrollController: FixedExtentScrollController(initialItem: type == RecruitSettingType.autoDeleteTime ? settingState.selectedTimeListIndex : settingState.selectedPersonListIndex),
                  onSelectedItemChanged: (int index) {
                    if ((type == RecruitSettingType.autoDeleteTime)) {
                      onConfirm((int.parse(timeList[index])), index); // 시간 전달
                    } else {
                      onConfirm(int.parse(maxParticipants[index]), index); // 최대 인원수 전달
                    }
                  },
                  children: (type == RecruitSettingType.autoDeleteTime)
                      ? timeList.map((reason) => Center(child: Text('$reason 분'))).toList()
                      : maxParticipants.map((reason) => Center(child: Text('$reason 명'))).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

