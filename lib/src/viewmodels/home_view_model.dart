import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:green_field/src/datas/repositories/login_repository.dart';
import 'package:green_field/src/model/recruit.dart';
import 'package:green_field/src/viewmodels/login_view_model.dart';
import 'package:green_field/src/viewmodels/onboarding_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../cores/error_handler/result.dart';
import '../datas/repositories/onboarding_repository.dart';
import '../datas/services/firebase_auth_service.dart';
import '../model/user.dart' as myUser;

part 'home_view_model.g.dart';

@Riverpod(keepAlive: true)
class HomeViewModel extends _$HomeViewModel {

  @override
  Future<HomeSetState?> build() async {
    return HomeSetState(
        onboardingState: ref.read(onboardingViewModelProvider),
        loginState: ref.read(loginViewModelProvider),
    );
  }

  /// User DB 호출
  Future<Result<myUser.User, Exception>> getUser(String userId) async {
    final authRepository = ref.read(firebaseAuthServiceProvider);
    final firebaseUser = authRepository.currentUser;

    if (firebaseUser != null && firebaseUser.providerData.isNotEmpty) {
      final result = await ref
          .read(onboardingRepositoryProvider)
          .getUser(userId);

      switch (result) {
        case Success(value: final user):
          return Success(user);
        case Failure(exception: final e):
          return Failure(e);
      }
    } else {
      return Failure(Exception('사용자가 로그인되어 있지 않거나 제공자 데이터가 없습니다.'));
    }
  }
}


class HomeSetState {
  final onboardingState;
  final loginState; // LoginState를 정의해야 함

  HomeSetState({
    required this.onboardingState,
    required this.loginState,
  });
}


// class HomeSetNotifier extends StateNotifier<HomeSetState> {
//   HomeSetNotifier()
//       : super(HomeSetState(
//     onboardingState: OnboardingViewModel(),
//     loginState: LoginViewModel(), // 초기화 필요
//   ));
//
//   Future<void> fetchOnboardingData(ProviderReference ref) async {
//     state = HomeSetState(
//       onboardingState: OnboardingViewModel(),
//       loginState: state.loginState,
//       authState: state.authState,
//     );
//
//     try {
//       final result = await ref.read(onboardingViewModelProvider);
//       state = HomeSetState(
//         onboardingState: OnboardingState(isLoading: false, userResult: result),
//         loginState: state.loginState,
//         authState: state.authState,
//       );
//     } catch (e) {
//       state = HomeSetState(
//         onboardingState: OnboardingState(isLoading: false, userResult: Failure(e)),
//         loginState: state.loginState,
//         authState: state.authState,
//       );
//     }
//   }
//
// // 다른 상태를 업데이트하는 메서드 추가 가능
// }
