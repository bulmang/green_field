import 'package:flutter/cupertino.dart';

const double _kItemExtent = 32.0;
const List<String> _reportReasons = <String>[
  '불법촬영물등의 유통',
  '음란물/불건전한 만남 및 대화',
  '유출/사칭/사기',
  '게시판 성격에 부적절함',
  '욕설/비하',
  '정당/정치인 비하 및 선거운동',
  '상업적 광고 및 판매',
  '낚시/놀람/도배',
];

/// **신고 이유를 선택할 수 있는 GreenFieldReportPicker 위젯**
///
/// - 사용자가 신고 버튼을 누르면 신고 리스트를 선택할 수 있는 `CupertinoPicker`를 표시합니다.
/// - 선택된 신고 이유는 `onConfirm(String reason)` 콜백을 통해 전달됩니다.
class GreenFieldReportPicker extends StatefulWidget {
  final void Function(String selectedReason) onConfirm;

  const GreenFieldReportPicker({super.key, required this.onConfirm});

  @override
  State<GreenFieldReportPicker> createState() => _GreenFieldReportPickerState();
}

class _GreenFieldReportPickerState extends State<GreenFieldReportPicker> {
  int _selectedReasonIndex = 0;

  void _showPicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  magnification: 1.2,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: _kItemExtent,
                  scrollController: FixedExtentScrollController(initialItem: _selectedReasonIndex),
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      _selectedReasonIndex = index;
                    });
                  },
                  children: List<Widget>.generate(_reportReasons.length, (int index) {
                    return Center(child: Text(_reportReasons[index]));
                  }),
                ),
              ),
              CupertinoButton(
                child: const Text('확인', style: TextStyle(fontSize: 18, color: CupertinoColors.systemRed)),
                onPressed: () {
                  Navigator.pop(context); // 팝업 닫기
                  widget.onConfirm(_reportReasons[_selectedReasonIndex]); // 선택한 신고 이유 전달
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: const Text("신고하기", style: TextStyle(fontSize: 18, color: CupertinoColors.destructiveRed)),
      onPressed: _showPicker,
    );
  }
}
