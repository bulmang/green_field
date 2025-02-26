import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_field/src/model/notice.dart';
import 'package:green_field/src/utilities/components/greenfield_image_widget.dart';
import 'package:green_field/src/viewmodels/post/post_edit_view_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../cores/image_type/image_type.dart';

import '../../model/post.dart';
import '../../viewmodels/notice/notice_edit_view_model.dart';
import '../../views/recruitment/recruit_setting_section.dart';
import '../design_system/app_icons.dart';
import '../design_system/app_texts.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import '../enums/feature_type.dart';
import 'greenfield_comunity_rules_text.dart';

class GreenFieldEditSection extends ConsumerStatefulWidget {
  final dynamic instanceModel;
  final FeatureType type;
  final Function(String title, String body, List<ImageType> images) onSubmit;
  final ValueNotifier<bool> isCompleteActive;

  const GreenFieldEditSection({
    super.key,
    required this.type,
    required this.onSubmit,
    required this.isCompleteActive,
    this.instanceModel,
  });

  @override
  GreenFieldEditSectionState createState() => GreenFieldEditSectionState();
}

class GreenFieldEditSectionState extends ConsumerState<GreenFieldEditSection> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  final ImagePicker _picker = ImagePicker();
  List<ImageType> tempImages = [];

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _bodyController = TextEditingController();

    print('instance Model: ${widget.instanceModel}');
    if (widget.instanceModel is Notice) {
      tempImages = ref
        .read(noticeEditViewModelProvider.notifier)
        .loadPostForEditing(_titleController, _bodyController, tempImages, widget.instanceModel);
    } else if(widget.instanceModel is Post) {
      tempImages = ref
          .read(postEditViewModelProvider.notifier)
          .loadPostForEditing(_titleController, _bodyController, tempImages, widget.instanceModel);
    }

    widget.isCompleteActive.addListener(_checkAndSubmit);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    widget.isCompleteActive.removeListener(_checkAndSubmit);
    super.dispose();
  }

  void _checkAndSubmit() {
    if (widget.isCompleteActive.value) {
      _submit();
    }
  }

  void _submit() {
    widget.onSubmit(_titleController.text, _bodyController.text, tempImages);
  }

  @override
  Widget build(BuildContext context) {
    final editState = ref.watch(noticeEditViewModelProvider.notifier);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      maxLength: 50,
                      maxLines: 1,
                      style: AppTextsTheme.main().gfHeading1.copyWith(
                            color: Theme.of(context).appColors.gfBlackColor,
                          ),
                      decoration: InputDecoration(
                        hintText: '제목',
                        hintStyle: TextStyle(
                            color: Theme.of(context).appColors.gfGray400Color),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).appColors.gfMainColor,
                              width: 2),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).appColors.gfGray400Color,
                              width: 1),
                        ),
                      ),
                    ),

                    TextField(
                      controller: _bodyController,
                      maxLength: 500,
                      minLines: 8,
                      maxLines: null,
                      style: AppTextsTheme.main().gfBody1.copyWith(
                            color: Theme.of(context).appColors.gfBlackColor,
                          ),
                      decoration: InputDecoration(
                        hintText: '내용을 입력하세요.',
                        hintStyle: TextStyle(
                            color: Theme.of(context).appColors.gfGray400Color),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).appColors.gfMainColor,
                              width: 2),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).appColors.gfGray400Color,
                              width: 1),
                        ),
                      ),
                    ),

                    SizedBox(height: 17),
                    if (widget.type == FeatureType.recruit)
                      RecruitSettingSection(),
                    SizedBox(height: 17),
                    if (tempImages != [])
                      GreenFieldImageWidget(tempImages: tempImages),
                    SizedBox(height: 17),
                    GreenFieldComunityRulesText(),
                  ],
                ),
              ),
            ),
            CupertinoButton(
              child: Image.asset(
                AppIcons.camera,
                width: 32,
                height: 32,
              ),
              onPressed: () async {
                FocusScope.of(context).unfocus();
                final List<XFile>? images = await _picker.pickMultiImage();
                setState(() {
                  editState.pickImages(tempImages, images);
                });
              },
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}


// Widget imageDeleteButton({
//   void Function()? onPressed,
// }) {
//   return Padding(
//     padding: const EdgeInsets.only(left: 16.0, right: 16.0),
//     child:  CupertinoButton(
//       padding: EdgeInsets.zero,
//       onPressed: () {
//         setState(() {
//           editState.removeImage(tempImages, index);
//         });
//       },
//       child: Container(
//         width: 30,
//         height: 30,
//         decoration: BoxDecoration(
//           color: Theme.of(context).appColors.gfWarningColor,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Icon(
//           CupertinoIcons.xmark,
//           color: Colors.white,
//           size: 12,
//         ),
//       ),
//     ),
//   );
// }
//
