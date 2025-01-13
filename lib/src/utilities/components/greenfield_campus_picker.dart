import 'package:flutter/material.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:wheel_picker/wheel_picker.dart';
import '../design_system/app_texts.dart';

class GreenFieldCampusPicker extends StatefulWidget {
  final ValueChanged<String> onCampusSelected; // 콜백 함수

  GreenFieldCampusPicker({super.key, required this.onCampusSelected});

  @override
  State<GreenFieldCampusPicker> createState() => _GreenFieldCampusPickerState();
}

class _GreenFieldCampusPickerState extends State<GreenFieldCampusPicker> {
  late final _campusWheel = WheelPickerController(
    itemCount: campuses.length,
    initialIndex: 0,
  );

  late double screenWidth;
  String selectedCampus = campuses[0]; // 초기 선택된 캠퍼스

  static const campuses = [
    "---",
    "영등포",
    "금천",
    "마포",
    "용산",
    "강동",
    "강서",
    "동작",
    "서대문",
    "광진",
    "중구",
    "종로",
    "성동",
    "성북",
    "동대문",
    "도봉",
    "강북",
    "관악",
    "노원",
    "은평",
    "온라인"
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenWidth = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    final wheelStyle = WheelPickerStyle(
      itemExtent: 30.0,
      squeeze: 0.6,
      diameterRatio: screenWidth,
      surroundingOpacity: .25,
      magnification: 1.3,
    );

    Widget itemBuilder(BuildContext context, int index) {
      return Text(campuses[index], style: AppTextsTheme.main().gfHeading1);
    }

    final stringWheels = Expanded(
      child: WheelPicker(
        builder: itemBuilder,
        controller: _campusWheel,
        looping: true,
        style: wheelStyle.copyWith(
          itemExtent: 23.0,
        ),
        selectedIndexColor: Theme.of(context).appColors.gfMainColor,
        onIndexChanged: (index) {
          setState(() {
            selectedCampus = campuses[index];
            widget.onCampusSelected(selectedCampus); // 콜백 호출
          });
        },
      ),
    );

    return Center(
      child: SizedBox(
        width: screenWidth,
        height: 200.0,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _centerBar(context),
            Row(
              children: [
                stringWheels,
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _campusWheel.dispose();
    super.dispose();
  }

  Widget _centerBar(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
            height: 40.0,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).appColors.gfGray400Color,
                  width: 1.0,
                ),
                bottom: BorderSide(
                  color: Theme.of(context).appColors.gfGray400Color,
                  width: 1.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.25),
            child: Text(
              '캠퍼스',
              style: AppTextsTheme.main().gfHeading3.copyWith(color: Theme.of(context).appColors.gfMainColor),
            ),
          ),
        ],
      ),
    );
  }
}
