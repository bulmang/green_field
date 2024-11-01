import 'package:flutter/cupertino.dart';
import 'package:green_field/src/design_system/app_colors.dart';
import 'package:green_field/src/design_system/app_texts.dart';

class GreenFieldConfirmButton extends StatelessWidget {
  final String text; // 버튼에 표시할 텍스트
  final bool isAble; // 버튼 활성화 여부
  final Color textColor; // 텍스트 색상
  final Color backGroundColor; // 배경 색상
  final VoidCallback? onPressed; // 버튼 클릭 시 실행할 콜백

  const GreenFieldConfirmButton({
    super.key,
    required this.text,
    required this.isAble,
    required this.textColor,
    required this.backGroundColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: isAble ? onPressed : null, // 버튼 클릭 시 동작
      color: isAble ? backGroundColor : AppColorsTheme().gfGray300Color, // 배경 색상
      borderRadius: BorderRadius.circular(8.0), // 모서리 둥글게
      padding: EdgeInsets.zero, // 패딩을 0으로 설정하여 크기 조정
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 32, // 화면 너비에 맞춤
        height: 56.0, // 높이를 56으로 설정
        child: Center( // 텍스트를 중앙에 정렬
          child: Text(
            text,
            style: AppTextsTheme.main().gfTitle1.copyWith(
              color: textColor, // 텍스트 색상
            ),
          ),
        ),
      ),
    );
  }
}
