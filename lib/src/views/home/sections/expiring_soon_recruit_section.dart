import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/model/recruit.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import 'package:green_field/src/viewmodels/onboarding/onboarding_view_model.dart';
import 'package:green_field/src/viewmodels/recruit/recruit_view_model.dart';
import '../../../utilities/components/greefield_login_alert_dialog.dart';
import '../../../utilities/components/greenfield_expiring_soon_list.dart';
import '../../../utilities/design_system/app_texts.dart';
import '../../../utilities/design_system/app_icons.dart';

class ExpiringSoonRecruitSection extends ConsumerStatefulWidget {
  const ExpiringSoonRecruitSection({super.key});

  @override
  _ExpiringSoonRecruitSectionState createState() => _ExpiringSoonRecruitSectionState();
}

class _ExpiringSoonRecruitSectionState extends ConsumerState<ExpiringSoonRecruitSection> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(onboardingViewModelProvider);
    final recruitState = ref.watch(recruitViewModelProvider);

    return ((recruitState.value != null && recruitState.value!.isNotEmpty ))
        ? Flexible(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: (recruitState.value?.length ?? 0).clamp(0, 3),
                itemBuilder: (context, index) {
                  final recruit = recruitState.value?[index];
                  return (recruit != null)
                      ?  GreenFieldExpiringSoonList(
                          title: recruit.title,
                          body: recruit.body,
                          remainTime: '${DateTime.now().difference(recruit!.remainTime).inMinutes.abs()}',
                          currentParticipants: recruit.currentParticipants.length.toString(),
                          maxParticipants: recruit.maxParticipants.toString(),
                          onPressedCallback: () {
                            if (userState.value == null && !userState.isLoading) {
                              showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return GreenFieldLoginAlertDialog(ref: ref);
                                },
                              );
                            } else {
                              if (recruit.currentParticipants.contains(userState.value?.id)) {
                                context.go('/recruit/chat/${recruit.id}');
                              } else {
                                context.go('/recruit/detail/${recruit.id}');
                              }
                            }
                          },
                        )
                    : Image.asset(AppIcons.networkSesac, width: 300);
                },
              ),
            ),
          )
        : Flexible(
          child: GreenFieldExpiringSoonList(
              title: '모집글이 없습니다.',
              body: '모집글이 없습니다. 새로운 모집글을 작성해 보세요.',
              remainTime: '-',
              currentParticipants: '-',
              maxParticipants: '4',
              isDummyData: true,
              onPressedCallback: () {
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
        );
  }

}

