import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_field/src/model/campus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../cores/error_handler/result.dart';
import '../../datas/repositories/campus_repository.dart';

part 'campus_view_model.g.dart';

@Riverpod(keepAlive: true)
class CampusViewModel extends _$CampusViewModel {
  @override
  Future<Campus?> build() async {
    final result = await getCampus('관악');
    switch (result) {
      case Success(value: final campus):
        return campus;
      case Failure(exception: final e):
        return CampusExample().error;
    }
  }

  Future<Result<Campus, Exception>> getCampus(String campusName) async {
    state = AsyncLoading();
    try {
      final result =
          await ref.read(campusRepositoryProvider).getCampus(campusName);

      switch (result) {
        case Success(value: final campus):
          state = AsyncData(campus);
          return Success(campus);

        case Failure(exception: final e):
          state = AsyncError(e, StackTrace.current);
          return Failure(Exception('캠퍼스 조회 실패: $e'));
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      return Failure(Exception('캠퍼스 조회 중 예외 발생: $e'));
    }
  }

  Future<Result<Campus, Exception>> createCampus() async {
    state = AsyncLoading();
    try {
      final campus = Campus(
          id: '은평',
          name: "은평",
          images: [
            "https://firebasestorage.googleapis.com/v0/b/green-field-c055f.appspot.com/o/images%2Fcampus%2F%EC%9D%80%ED%8F%89%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202025-03-10%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%208.07.07.png?alt=media&",
          ],
          address: {
            "CampusAddress": "서울 은평구 은평로 245 3층",
            "NaverMapURLScheme": "청년취업사관학교 은평캠퍼스",
            "NaverWebURL": "https://naver.me/xLWnpSzZ",
            "MapImageURL":
            "https://firebasestorage.googleapis.com/v0/b/green-field-c055f.appspot.com/o/images%2Fcampus%2F%EC%9D%80%ED%8F%89%2F%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202025-03-10%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%208.07.07.png?alt=media&",
          },
          operatingHours: [
            "월요일 10:00~22:00",
            "화요일 10:00~22:00",
            "수요일 10:00~22:00",
            "목요일 10:00~22:00",
            "금요일 10:00~22:00",
            "토요일 정기휴무(매주 토요일)",
            "일요일 정기휴무(매주 일요일)"
          ],
          contactNumber: "02-2138-2731",
          floorDescription: {
            "사진": [
              "https://firebasestorage.googleapis.com/v0/b/green-field-c055f.appspot.com/o/images%2Fcampus%2F%EC%9D%80%ED%8F%89%2F%E1%84%8B%E1%85%B3%E1%86%AB%E1%84%91%E1%85%A7%E1%86%BC(1).jpeg?alt=media&",
              "https://firebasestorage.googleapis.com/v0/b/green-field-c055f.appspot.com/o/images%2Fcampus%2F%EC%9D%80%ED%8F%89%2F%E1%84%8B%E1%85%B3%E1%86%AB%E1%84%91%E1%85%A7%E1%86%BC(2).jpeg?alt=media&",
              "https://firebasestorage.googleapis.com/v0/b/green-field-c055f.appspot.com/o/images%2Fcampus%2F%EC%9D%80%ED%8F%89%2F%E1%84%8B%E1%85%B3%E1%86%AB%E1%84%91%E1%85%A7%E1%86%BC(3).jpeg?alt=media&",
              "https://firebasestorage.googleapis.com/v0/b/green-field-c055f.appspot.com/o/images%2Fcampus%2F%EC%9D%80%ED%8F%89%2F%E1%84%8B%E1%85%B3%E1%86%AB%E1%84%91%E1%85%A7%E1%86%BC(4).jpeg?alt=media&",
              "https://firebasestorage.googleapis.com/v0/b/green-field-c055f.appspot.com/o/images%2Fcampus%2F%EC%9D%80%ED%8F%89%2F%E1%84%8B%E1%85%B3%E1%86%AB%E1%84%91%E1%85%A7%E1%86%BC(5).jpeg?alt=media&",
              "https://firebasestorage.googleapis.com/v0/b/green-field-c055f.appspot.com/o/images%2Fcampus%2F%EC%9D%80%ED%8F%89%2F%E1%84%8B%E1%85%B3%E1%86%AB%E1%84%91%E1%85%A7%E1%86%BC(6).jpeg?alt=media&",
            ],
          });

      final result =
          await ref.read(campusRepositoryProvider).createCampusDB(campus);

      switch (result) {
        case Success(value: final campus):
          state = AsyncData(campus);
          return Success(campus); // Token 객체 반환

        case Failure(exception: final e):
          state = AsyncError(e, StackTrace.current);
          return Failure(Exception('캠퍼스 생성 실패: $e'));
      }
    } catch (e, stackTrace) {
      // 예외가 발생한 경우 AsyncError에 에러와 스택 트레이스를 전달
      state = AsyncError(e, stackTrace);
      return Failure(Exception('캠퍼스 생성 중 예외 발생: $e'));
    }
  }

  void showToast(
      String alarmMessage, {
        ToastGravity? gravity,
        Color? backGroundColor,
        Color? textColor,
      }) {
    Fluttertoast.showToast(
      msg: alarmMessage, // 메시지 내용
      toastLength: Toast.LENGTH_SHORT, // 메시지 시간 - 안드로이드
      gravity: gravity ?? ToastGravity.TOP, // 메시지 위치
      timeInSecForIosWeb: 1, // 메시지 시간 - iOS 및 웹
      backgroundColor: backGroundColor ?? const Color(0xFFFF6A69), // 배경
      textColor: textColor ?? const Color(0xFFFBFBFD), // 글자
      fontSize: 16.0,
    );
  }
}
