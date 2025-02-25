import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../cores/error_handler/result.dart';
import '../../viewmodels/setting/setting_view_model.dart';

class GreenFieldLoginAlertDialog extends StatelessWidget {
  final WidgetRef ref;

  const GreenFieldLoginAlertDialog({super.key, required this.ref});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('로그인 후 서비스를 이용해보세요'),
      content: Text('다양한 서비스를 이용할 수 있어요!'),
      actions: [
        CupertinoDialogAction(
          child: Text("취소", style: TextStyle(color: CupertinoColors.inactiveGray)),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          child: Text("확인", style: TextStyle(color: CupertinoColors.activeBlue)),
          onPressed: () async {
            Navigator.pop(context);
            final result = await ref.read(settingViewModelProvider.notifier).resetUser();

            switch (result) {
              case Success():
                context.go('/signIn');
              case Failure(exception: final e):
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('익명 로그인 초기화 실패'),
                    content: Text('에러 발생: $e'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('확인'),
                      ),
                    ],
                  ),
                );
            }
          },
        ),
      ],
    );
  }
}
