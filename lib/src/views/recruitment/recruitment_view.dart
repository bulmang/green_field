import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utilities/components/greenfield_app_bar.dart';
import '../../utilities/components/greenfield_recruit_list.dart'; // Import your GreenFieldRecruitList
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';

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
      backgroundColor: Theme.of(context).appColors.gfBackGroundColor,
      appBar: GreenFieldAppBar(
        backgGroundColor: Theme.of(context).appColors.gfBackGroundColor,
        title: "모집",
        leadingIcon: SizedBox(),
        actions: [
          CupertinoButton(
              child: Icon(
                CupertinoIcons.square_pencil,
                size: 24,
                color: Theme.of(context).appColors.gfGray400Color,
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
