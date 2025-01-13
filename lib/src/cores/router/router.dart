import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:green_field/src/cores/router/go_router_refresh_stream.dart';
import 'package:green_field/src/datas/services/firebase_auth_service.dart';
import 'package:green_field/src/viewmodels/onboarding_view_model.dart';
import 'package:green_field/src/viewmodels/post_view_model.dart';
import 'package:green_field/src/views/campus/campus_view.dart';
import 'package:green_field/src/views/home/home_view.dart';
import 'package:green_field/src/views/login/login_view.dart';
import 'package:green_field/src/views/onboarding/onboarding_view.dart';
import 'package:green_field/src/views/main_view.dart';
import 'package:green_field/src/views/notice/notice_view.dart';
import 'package:green_field/src/views/notice/notice_deatil_view.dart';
import 'package:green_field/src/views/post/post_detail_view.dart';
import 'package:green_field/src/views/post/post_edit_view.dart';
import 'package:green_field/src/views/post/post_view.dart';
import 'package:green_field/src/views/recruitment/recruit_edit_view.dart';
import 'package:green_field/src/views/recruitment/recruitment_detail_view.dart';
import 'package:green_field/src/views/recruitment/recruitment_view.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../viewmodels/notice_view_model.dart';
import '../../viewmodels/recruit_view_model.dart';

part 'router.g.dart';

final noticeVM = NoticeViewModel();
final recruitVM = RecruitViewModel();
final postVM = PostViewModel();

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _homeTabNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'homeTab');
final GlobalKey<NavigatorState> _recruitTabNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'recruitTab');
final GlobalKey<NavigatorState> _postTabNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'postTab');
final GlobalKey<NavigatorState> _campusTabNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'campusTab');

@riverpod
GoRouter goRouter(Ref ref) {
  final authState = ref.watch(firebaseAuthServiceProvider);
  return GoRouter(
    initialLocation: '/',
    navigatorKey: GlobalKey<NavigatorState>(debugLabel: 'root'),
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // final isLoggedIn = authState.currentUser != null;
      // if (isLoggedIn) {
      //   return '/home';
      // }

      return null;
    },
    refreshListenable: GoRouterRefreshStream(authState.authStateChanges()),
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => LoginView(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => OnboardingView(), // OnBoardingView로 이동
      ),
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) => NoTransitionPage(
          child:  MainView(navigationShell: navigationShell),
        ),
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeTabNavigatorKey,
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomeView(),
                ),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'notice',
                    builder: (context, state) => NoticeView(),
                    routes: <RouteBase>[
                      GoRoute(
                        name: 'notice_detail',
                        path: 'detail/:id',
                        builder: (context, state) => NoticeDetailView(
                            notice: noticeVM
                                .getNoticeById(state.pathParameters['id']!)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _recruitTabNavigatorKey,
            routes: [
              GoRoute(
                path: '/recruit',
                builder: (BuildContext context, GoRouterState state) {
                  return RecruitView();
                },
                routes: <RouteBase>[
                  GoRoute(
                    name: 'recruit_detial',
                    path: 'detail/:id',
                    pageBuilder: (context, state) {
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: RecruitDetailView(
                            recruit: recruitVM
                                .getRecruitById(state.pathParameters['id']!)),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0); // 아래에서 시작
                          const end = Offset.zero; // 현재 위치
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
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
                    name: 'recruit_edit',
                    path: 'edit',
                    pageBuilder: (context, state) {
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: RecruitEditView(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0); // 아래에서 시작
                          const end = Offset.zero; // 현재 위치
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      );
                    },
                  ),
                ],
              )
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _postTabNavigatorKey,
            routes: [
              GoRoute(
                path: '/post',
                builder: (BuildContext context, GoRouterState state) {
                  return PostView();
                },
                routes: <RouteBase>[
                  GoRoute(
                    name: 'post_detail',
                    path: 'detail/:id',
                    builder: (context, state) => PostDetailView(
                        post: postVM.getPostById(state.pathParameters['id']!)),
                  ),
                  GoRoute(
                    name: "post_edit",
                    path: 'edit',
                    pageBuilder: (context, state) {
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: PostEditView(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0); // 아래에서 시작
                          const end = Offset.zero; // 현재 위치
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _campusTabNavigatorKey,
            routes: [
              GoRoute(
                path: '/campus',
                builder: (BuildContext context, GoRouterState state) {
                  return CampusView();
                },
              ),
            ],
          ),
        ],
      )
    ],
  );
}
