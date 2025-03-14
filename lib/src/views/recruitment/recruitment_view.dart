import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/utilities/components/greenfield_loading_widget.dart';
import 'package:green_field/src/viewmodels/onboarding/onboarding_view_model.dart';
import 'package:green_field/src/viewmodels/recruit/recruit_edit_view_model.dart';
import '../../cores/error_handler/result.dart';
import '../../utilities/components/greefield_login_alert_dialog.dart';
import '../../utilities/components/greenfield_app_bar.dart';
import '../../utilities/components/greenfield_recruit_list.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import '../../utilities/design_system/app_icons.dart';
import '../../utilities/design_system/app_texts.dart';
import '../../viewmodels/recruit/recruit_view_model.dart';

class RecruitView extends ConsumerStatefulWidget {
  const RecruitView({super.key});

  @override
  _RecruitViewState createState() => _RecruitViewState();
}

class _RecruitViewState extends ConsumerState<RecruitView> {
  final controller = ScrollController();

  bool hasMore = true;
  bool loading = false;

  Future refresh() async {
    final recruitNotifier = ref.watch(recruitViewModelProvider.notifier);
    final recruitEditNotifier = ref.watch(recruitEditViewModelProvider.notifier);
    final result = await recruitNotifier.getRecruitList();

    switch (result) {
      case Success():
        hasMore = true;

      case Failure(exception: final e):
        recruitEditNotifier.flutterToast('에러가 발생했어요!');
    }
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if ((controller.position.maxScrollExtent * 0.8 <= controller.offset) &&
          !loading) {
        setState(() {
          loading = true;
        });
        fetch();
      }
    });
  }

  Future fetch() async {
    final recruitNotifier = ref.watch(recruitViewModelProvider.notifier);
    final recruitEditNotifier = ref.watch(recruitEditViewModelProvider.notifier);
    final result = await recruitNotifier.getRecruitList();

    setState(() {
      switch (result) {
        case Success(value: final value):
          if (value.isEmpty) {
            hasMore = false;
          }
          loading = false;

        case Failure(exception: final e):
          loading = false;
          recruitEditNotifier.flutterToast('에러가 발생했어요!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(onboardingViewModelProvider);
    final recruitState = ref.watch(recruitViewModelProvider);
    final recruitEditNotifier = ref.watch(recruitEditViewModelProvider.notifier);
    print('recruitState: ${recruitState.value}');

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
              if (userState.value == null && !userState.isLoading) {
                showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return GreenFieldLoginAlertDialog(ref: ref);
                  },
                );
              } else {
                context.go('/recruit/edit');
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
              onRefresh: refresh,
              color: Theme.of(context).appColors.gfGray400Color,
              backgroundColor: Colors.white,
              strokeWidth: 2.0,
              child: recruitState.value == null
                  ? Center(
                      child: GreenFieldLoadingWidget()
                    )
                  : recruitState.value!.isEmpty
                    ? Center(
                child: Column(
                  children: [
                    Text(
                      '현재 모집글이 없습니다.\n새싹 커뮤니티 회원들과 함께 모임을 만들어요!',
                      overflow: TextOverflow.ellipsis,
                      style: AppTextsTheme.main().gfTitle1.copyWith(
                        color: Theme.of(context).appColors.gfBlackColor,
                      ),
                    ),
                    Spacer(),
                    CupertinoButton(
                      onPressed: () async {
                        final result = await ref.read(recruitViewModelProvider.notifier).getRecruitList();

                        switch (result) {
                          case Success(value: final v):
                            recruitEditNotifier.flutterToast('새로고침 했어요!', backgroundColor: Theme.of(context).appColors.gfMainColor);

                          case Failure(exception: final e):
                            recruitEditNotifier.flutterToast('에러가 발생했어요!');
                        }
                      },
                      child: CachedNetworkImage(
                        imageUrl: 'https://firebasestorage.googleapis.com/v0/b/green-field-c055f.appspot.com/o/hello.gif?alt=media',
                        width: 240,
                        height: 240,
                      ),
                    )
                  ],
                ),
              )
                    : ListView.builder(
                itemCount: recruitState.value!.length,
                itemBuilder: (context, index) {
                  final recruit = recruitState.value?[index];
                  return GreenFieldRecruitList(
                    recruits: recruit!,
                    onTap: () async {
                      if (userState.value == null && !userState.isLoading) {
                        showCupertinoDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return GreenFieldLoginAlertDialog(ref: ref);
                          },
                        );
                      } else {
                        final result = await ref.read(recruitViewModelProvider.notifier).getRecruit(recruit.id);

                        switch (result) {
                          case Success(value: final v):
                            if (DateTime.now().isBefore(v.remainTime)) {
                              context.go('/recruit/detail/${v.id}');
                            } else {
                              recruitEditNotifier.flutterToast('시간이 지난 채팅방이에요');
                            }

                          case Failure(exception: final e):
                            recruitEditNotifier.flutterToast('에러가 발생했어요!');
                        }

                      }
                    },
                  );
                },
              )
            )
    );
  }
}
