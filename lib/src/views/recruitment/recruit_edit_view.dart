import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/components/greenfield_app_bar.dart';
import 'package:green_field/src/components/greenfield_edit_section.dart'; // Assuming you have a GreenFieldEditSection
import 'package:green_field/src/design_system/app_colors.dart';
import 'package:green_field/src/enums/feature_type.dart';
import 'package:green_field/src/model/recruit.dart';

import '../../design_system/app_texts.dart'; // Assuming you have a Recruit model

class RecruitEditView extends StatefulWidget {
  const RecruitEditView({super.key});

  @override
  _RecruitEditViewState createState() => _RecruitEditViewState();
}

class _RecruitEditViewState extends State<RecruitEditView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsTheme().gfWhiteColor,
      appBar: GreenFieldAppBar(
        backgGroundColor: AppColorsTheme().gfWhiteColor,
        title: "모집글 쓰기",
        leadingIcon: Icon(
          CupertinoIcons.xmark,
          color: AppColorsTheme().gfGray400Color,
        ),
        leadingAction: () {
          context.pop();
        },
        actions: [
          CupertinoButton(
            onPressed: () {
              print("글쓰기 버튼 클릭");
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF308F5B), Color(0xFF666666)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              height: 30,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                child: Text(
                  '완료',
                  style: AppTextsTheme.main().gfCaption2.copyWith(
                    color: AppColorsTheme().gfWhiteColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: GreenFieldEditSection(
        type:
            FeatureType.recruit, // Pass the recruit object to the edit section
      ),
    );
  }
}
