import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../cores/image_type/image_type.dart';
import '../../utilities/components/greenfield_app_bar.dart';
import '../../utilities/components/greenfield_edit_section.dart'; // Assuming you have a GreenFieldEditSection
import '../../utilities/enums/feature_type.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import '../../utilities/design_system/app_texts.dart';

class RecruitEditView extends StatefulWidget {
  const RecruitEditView({super.key});

  @override
  _RecruitEditViewState createState() => _RecruitEditViewState();
}

class _RecruitEditViewState extends State<RecruitEditView> {
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
        type:
            FeatureType.recruit, // Pass the recruit object to the edit section
        onSubmit: (String title, String body, List<ImageType> images) {
          // Handle the submitted data here

          // if (images.isNotEmpty) {
          //   for (int i = 0; i < images.length; i++) {
          //     File _file = File(images[i].path);
          //     await FirebaseStorage.instance
          //         .ref("test/multi/image_$i")
          //         .putFile(_file);
          //   }
          // }

          // You can also navigate to another screen or show a dialog
          // For example:
          // Navigator.push(context, MaterialPageRoute(builder: (context) => AnotherScreen()));
        }, isCompleteActive: ValueNotifier<bool>(false),
      ),
    );
  }
}
