import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:green_field/src/utilities/components/greenfield_loading_widget.dart';
import 'package:green_field/src/viewmodels/onboarding/onboarding_view_model.dart';
import 'package:green_field/src/viewmodels/recruit/recruit_edit_view_model.dart';
import 'package:green_field/src/viewmodels/recruit/recruit_view_model.dart';

import '../../cores/error_handler/result.dart';
import '../../cores/image_type/image_type.dart';
import '../../model/recruit.dart';
import '../../utilities/components/greenfield_app_bar.dart';
import '../../utilities/components/greenfield_edit_section.dart';
import '../../utilities/enums/feature_type.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import '../../utilities/design_system/app_texts.dart';

class RecruitEditView extends ConsumerStatefulWidget {
  final Recruit? recruit;
  const RecruitEditView({super.key, this.recruit});

  @override
  ConsumerState<RecruitEditView> createState() => _RecruitEditViewState();
}

class _RecruitEditViewState extends ConsumerState<RecruitEditView> {
  ValueNotifier<bool> isCompleteActive = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(onboardingViewModelProvider);
    final editState = ref.watch(recruitEditViewModelProvider);

    return Stack(
      children: [
        Scaffold(
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
                  FocusScope.of(context).unfocus();
                  isCompleteActive.value = !isCompleteActive.value;
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
            instanceModel: widget.recruit,
            type: FeatureType.recruit,
            onSubmit: (String title, String body, List<ImageType> images) async {
              if (images.length > 8) {
                ref
                    .read(recruitEditViewModelProvider.notifier)
                    .flutterToast('사진은 최대 8장까지 업로드할 수 있어요.');
                return;
              }
              if (title != '' && body != '') {
                final result = await ref
                    .read(recruitEditViewModelProvider.notifier)
                    .createRecruittModel(userState.value, title, body, images, widget.recruit);

                switch (result) {
                  case Success(value: final value):
                    final getRecruit = await ref
                        .read(recruitViewModelProvider.notifier)
                        .getRecruit(widget.recruit?.id ?? value.id);

                    switch (getRecruit) {
                      case Success(value: final value):
                        if (widget.recruit == null) {
                          final getRecruitList = await ref
                              .read(recruitViewModelProvider.notifier)
                              .getRecruitList();

                          switch (getRecruitList) {
                            case Success():
                              context.go('/recruit/detail/${value.id}');
                            case Failure(exception: final e):
                              ref
                                  .read(recruitEditViewModelProvider.notifier)
                                  .flutterToast('모집글을 가져오기 실패하였습니다.');
                          }
                        } else {
                          context.go('/recruit/detail/${value.id}');
                        }

                      case Failure(exception: final e):
                        print('getPost:$e');
                        ref
                            .read(recruitEditViewModelProvider.notifier)
                            .flutterToast('모집글을 가져오기 실패하였습니다.');
                    }

                  case Failure(exception: final e):
                    ref
                        .read(recruitEditViewModelProvider.notifier)
                        .flutterToast('모집글 등록에 실패하였습니다.${e.toString()}');
                }
              } else {
                ref
                    .read(recruitEditViewModelProvider.notifier)
                    .flutterToast('제목과 내용을 입력해주세요.');
                isCompleteActive.value = !isCompleteActive.value;
              }
            },
            isCompleteActive: isCompleteActive,
          ),
        ),
        editState.isLoading
            ? GreenFieldLoadingWidget()
            : SizedBox.shrink(),
      ],
    );
  }
}
