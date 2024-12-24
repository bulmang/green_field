import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/components/greenfield_app_bar.dart';
import 'package:green_field/src/components/greenfield_edit_section.dart';
import 'package:green_field/src/enums/feature_type.dart';
import 'package:green_field/src/extensions/theme_data_extension.dart';
import '../../design_system/app_texts.dart';

class PostEditView extends StatefulWidget {
  const PostEditView({super.key});

  @override
  _PostEditViewState createState() => _PostEditViewState();
}

class _PostEditViewState extends State<PostEditView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).appColors.gfWhiteColor,
      appBar: GreenFieldAppBar(
        backgGroundColor: Theme.of(context).appColors.gfWhiteColor,
        title: "모집글 쓰기",
        leadingIcon: Icon(
          CupertinoIcons.xmark,
          color: Theme.of(context).appColors.gfGray400Color,
        ),
        leadingAction: () {
          context.pop();
        },
        actions: [
          CupertinoButton(
            onPressed: () {
              context.pop();
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
                    color: Theme.of(context).appColors.gfWhiteColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: GreenFieldEditSection(
        type: FeatureType.post,
      ),
    );
  }
}
