

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_field/src/views/recruitment/picker/recruit_picker_modal.dart';

import '../../design_system/app_colors.dart';
import '../../design_system/app_texts.dart';
import '../../enums/recruit_setting_type.dart';

class RecruitSettingSection extends StatefulWidget {
  const RecruitSettingSection({super.key});

  @override
  RecruitSettingSectionState createState() => RecruitSettingSectionState();
}

class RecruitSettingSectionState extends State<RecruitSettingSection> {
  RecruitSettingType? selectedType;

  void _selectType(RecruitSettingType type) {
    setState(() {
      selectedType = type;
    });
    print("선택된 타입: $selectedType");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _recruitSettingBox(
          icon: CupertinoIcons.time,
          text: '120분 후 자동삭제',
          type: RecruitSettingType.autoDeleteTime,
        ),
        SizedBox(width: 14),
        _recruitSettingBox(
          icon: CupertinoIcons.person,
          text: '현재 인원수 1명',
          type: RecruitSettingType.currentPerson,
        ),
        SizedBox(width: 14),
        _recruitSettingBox(
          icon: CupertinoIcons.person_2_fill,
          text: '최대 인원수 4명',
          type: RecruitSettingType.maxPerson,
        ),
      ],
    );
  }

  Widget _recruitSettingBox({required IconData icon, required String text, required RecruitSettingType type}) {
    bool isSelected = selectedType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          _selectType(type);
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: 300, // 원하는 높이 설정
                child: RecruitPickerModal(type: selectedType!),
              );
            },
          ).whenComplete(() {
            setState(() {
              selectedType = null;
            });
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColorsTheme().gfMainColor : AppColorsTheme().gfBackGroundColor,
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
                Icon(icon, size: 32, color: isSelected ? AppColorsTheme().gfBackGroundColor : AppColorsTheme().gfMainColor),
                SizedBox(height: 5),
                Text(
                  text,
                  style: AppTextsTheme.main().gfBody5.copyWith(
                      color: isSelected ? AppColorsTheme().gfBackGroundColor : AppColorsTheme().gfMainColor
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