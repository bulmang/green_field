import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_field/src/design_system/app_texts.dart';
import 'package:green_field/src/enums/recruit_setting_type.dart';
import '../../../design_system/app_colors.dart';

class RecruitPickerModal extends StatefulWidget {
  final RecruitSettingType type; // Type of picker (timer or people)

  const RecruitPickerModal({super.key, required this.type});

  @override
  _RecruitPickerModalState createState() => _RecruitPickerModalState();
}

class _RecruitPickerModalState extends State<RecruitPickerModal> {
  String timeString = "30";
  int currentSelectedCount = 1;
  int maxSeletedCOunt = 2;

  final List<String> time = List.generate(10, (index) => ((index + 3) * 10).toString());
  final List<int> currentPeopleCount = List.generate(3, (index) => index + 1);
  final List<int> maxPeopleCount = List.generate(4, (index) => index + 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 280,
            child:
                _buildPicker(), // Call the method to build the appropriate picker
          ),
          Text(
            widget.type == RecruitSettingType.autoDeleteTime
                ? '$timeString 분'
                : '$currentSelectedCount 명', // 선택된 값 표시
            style: AppTextsTheme.main().gfCaption2.copyWith(
                  color: AppColorsTheme().gfBlackColor,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildPicker() {
    switch (widget.type) {
      case RecruitSettingType.autoDeleteTime:
        return CupertinoPicker.builder(
          itemExtent: 50,
          childCount: time.length,
          onSelectedItemChanged: (i) {
            setState(() {
              timeString = time[i];
            });
          },
          itemBuilder: (context, index) {
            return Center(
              child: Text(
                '${time[index]} 분',
                style: AppTextsTheme.main().gfHeading1.copyWith(
                      color: AppColorsTheme().gfBlackColor,
                    ),
              ),
            );
          },
        );
      case RecruitSettingType.currentPerson:
        return CupertinoPicker.builder(
          itemExtent: 50,
          childCount: currentPeopleCount.length,
          onSelectedItemChanged: (i) {
            setState(() {
              currentSelectedCount = currentPeopleCount[i];
            });
          },
          itemBuilder: (context, index) {
            return Center(
              child: Text(
                '${currentPeopleCount[index]} 명',
                style: AppTextsTheme.main().gfHeading1.copyWith(
                      color: AppColorsTheme().gfBlackColor,
                    ),
              ),
            );
          },
        );
      case RecruitSettingType.maxPerson:
        return CupertinoPicker.builder(
          itemExtent: 50,
          childCount: maxPeopleCount.length,
          onSelectedItemChanged: (i) {
            setState(() {
              maxSeletedCOunt = maxPeopleCount[i];
            });
          },
          itemBuilder: (context, index) {
            return Center(
              child: Text(
                '${maxPeopleCount[index]} 명',
                style: AppTextsTheme.main().gfHeading1.copyWith(
                      color: AppColorsTheme().gfBlackColor,
                    ),
              ),
            );
          },
        );
      default:
        return Container();
    }
  }
}
