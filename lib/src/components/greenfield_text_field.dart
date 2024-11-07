import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:green_field/src/design_system/app_colors.dart';
import 'package:green_field/src/enums/feature_type.dart';
import '../design_system/app_texts.dart';

class GreenFieldTextField extends StatefulWidget {
  final FeatureType type;
  final Function(String) onAction;

  GreenFieldTextField({super.key, required this.type, required this.onAction});

  @override
  GreenFieldTextFieldState createState() => GreenFieldTextFieldState();
}

class GreenFieldTextFieldState extends State<GreenFieldTextField> {
  final TextEditingController _controller = TextEditingController();
  bool _isEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 90,
          color: AppColorsTheme().gfBackGroundColor,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 16.0, right: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColorsTheme().gfMainBackGroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _controller,
              onChanged: (text) {
                setState(() {
                  _isEmpty = text.isEmpty;
                });
              },
              decoration: InputDecoration(
                hintText: widget.type == FeatureType.post ? '댓글을 입력하세요.' : null,
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        widget.onAction(_controller.text);
                        _controller.clear();
                      }
                    },
                    color: Colors.transparent,
                    child: Icon(CupertinoIcons.paperplane_fill, color: AppColorsTheme().gfMainColor),
                  ),
                ),
              ),
              style: AppTextsTheme.main().gfTitle2.copyWith(
                color: _isEmpty ? AppColorsTheme().gfGray400Color : AppColorsTheme().gfBlackColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
