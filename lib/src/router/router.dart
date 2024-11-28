import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/views/main_view.dart';
import 'package:green_field/src/views/notice/notice_view.dart';
import 'package:green_field/src/views/notice/notice_deatil_view.dart';
import 'package:green_field/src/views/recruitment/recruit_edit_view.dart';
import 'package:green_field/src/views/recruitment/recruitment_detail_view.dart';

import '../viewmodels/notice_view_model.dart';
import '../viewmodels/recruit_view_model.dart';

final noticeVM = NoticeViewModel();
final recruitVM = RecruitViewModel();

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MainView(),
      routes: [
        GoRoute(
          name: "Notice",
          path: '/notice',
          builder: (context, state) => const NoticeView(),
        ),
        GoRoute(
          name: "NoticeDetail",
          path: 'noticedetail/:id',
          builder: (context, state) => NoticeDetailView(notice: noticeVM.getNoticeById(state.pathParameters['id']!)),
        ),
        GoRoute(
          name: "RecruitDetail",
          path: 'recruitdetail/:id', // recruit ID를 URL 파라미터로 사용
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: RecruitDetailView(recruit: recruitVM.getRecruitById(state.pathParameters['id']!)),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0); // 아래에서 시작
                const end = Offset.zero; // 현재 위치
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            );
          },
        ),
        GoRoute(
          name: "RecruitEdit",
          path: 'recruitedit',
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: RecruitEditView(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0); // 아래에서 시작
                const end = Offset.zero; // 현재 위치
                const curve = Curves.easeInOut;

                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            );
          },
        ),

        /// DeepLink
        GoRoute(
          name: "NoticeDeepLink",
          path: 'notice',
          builder: (context, state) =>  NoticeView(),
          routes: [
            GoRoute(
              name: 'detail',
              path: 'detail/:id',
              builder: (context, state) =>  NoticeDetailView(notice: noticeVM.getNoticeById(state.pathParameters['id']!)),
            )
          ],
        ),
      ],
    ),
  ],
);