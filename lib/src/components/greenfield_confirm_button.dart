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
      onPressed: isAble ? onPressed : null,
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          color: backGroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        height: 56.0,
        child: Center(
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
