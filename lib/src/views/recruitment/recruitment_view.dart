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
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => RecruitEditView(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: RecruitViewModel().recruits.length,
        itemBuilder: (context, index) {
          final recruit = RecruitViewModel().recruits[index];
          return GreenFieldRecruitList(
            recruits: recruit,
            onTap: () {
              context.go('/recruitdetail/${recruit.id}');
            },
          );
        },
      ),
    );
  }
}
