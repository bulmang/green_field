import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../cores/error_handler/result.dart';
import '../../datas/repositories/recruit_repository.dart';
import '../../model/recruit.dart';

part 'recruit_view_model.g.dart';

@Riverpod(keepAlive: true)
class RecruitViewModel extends _$RecruitViewModel {
  @override
  Future<List<Recruit>> build() async {
    return [];
  }

  /// Post 리스트 가져오기
  Future<Result<List<Recruit>, Exception>> getRecruitList() async {
    state = AsyncLoading();
    final result = await ref
        .read(recruitRepositoryProvider) // Update repository
        .getRecruitList();

    switch (result) {
      case Success(value: final postList):
        state = AsyncData(postList);
        return Success(postList);
      case Failure(exception: final exception):
        print('exception: $exception');
        state = AsyncError(exception, StackTrace.current);
        return Failure(Exception(exception));
    }
  }
}