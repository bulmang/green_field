import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/components/greenfield_app_bar.dart';
import 'package:green_field/src/components/greenfield_recruit_list.dart'; // Import your GreenFieldRecruitList
import 'package:green_field/src/design_system/app_colors.dart';
import 'package:green_field/src/views/recruitment/recruit_edit_view.dart';

import '../../viewmodels/recruit_view_model.dart';

class RecruitView extends StatefulWidget {
  const RecruitView({super.key});

  @override
  _RecruitViewState createState() => _RecruitViewState();
}

class _RecruitViewState extends State<RecruitView> {
  final recruitVM = RecruitViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsTheme().gfBackGroundColor,
      appBar: GreenFieldAppBar(
        backgGroundColor: AppColorsTheme().gfBackGroundColor,
        title: "모집",
        leadingIcon: SizedBox(),
        actions: [
          CupertinoButton(
              child: Icon(
                CupertinoIcons.square_pencil,
                size: 24,
                color: AppColorsTheme().gfGray400Color,
              ),
              onPressed: () {
                context.go('/recruit/edit');
              },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: recruitVM.recruits.length,
        itemBuilder: (context, index) {
          final recruit = recruitVM.recruits[index];
          return GreenFieldRecruitList(
            recruits: recruit,
            onTap: () {
              context.go('/recruit/detail/${recruit.id}');
            },
          );
        },
      ),
    );
  }
}
