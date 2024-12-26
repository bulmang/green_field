import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:green_field/src/design_system/app_icons.dart';
import 'package:green_field/src/design_system/app_texts.dart';
import 'package:green_field/src/enums/feature_type.dart';
import 'package:green_field/src/utilities/extensions/theme_data_extension.dart';
import '../views/recruitment/recruit_setting_section.dart';

class GreenFieldEditSection extends StatefulWidget {
  final FeatureType type;

  const GreenFieldEditSection({super.key, required this.type});

  @override
  GreenFieldEditSectionState createState() => GreenFieldEditSectionState();
}

class GreenFieldEditSectionState extends State<GreenFieldEditSection> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<File> imageFiles = [];

  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        imageFiles.addAll(images.map((image) => File(image.path)).toList());
      });
    }
  }

  void _removeImage(File file) {
    setState(() {
      imageFiles.remove(file);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      maxLength: 50,
                      maxLines: 1,
                      style: AppTextsTheme.main().gfHeading1.copyWith(
                        color: Theme.of(context).appColors.gfBlackColor,
                      ),
                      decoration: InputDecoration(
                        hintText: '제목',
                        hintStyle: TextStyle(color: Theme.of(context).appColors.gfGray400Color),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).appColors.gfMainColor, width: 2),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).appColors.gfGray400Color, width: 1),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _bodyController,
                      maxLength: 500,
                      minLines: 8,
                      maxLines: null,
                      style: AppTextsTheme.main().gfBody1.copyWith(
                        color: Theme.of(context).appColors.gfBlackColor,
                      ),
                      decoration: InputDecoration(
                        hintText: '내용을 입력하세요.',
                        hintStyle: TextStyle(color: Theme.of(context).appColors.gfGray400Color),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).appColors.gfMainColor, width: 2),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).appColors.gfGray400Color, width: 1),
                        ),
                      ),
                    ),
                    SizedBox(height: 17),
                    if (widget.type == FeatureType.recruit)
                      RecruitSettingSection(),
                      SizedBox(height: 17),

                    if (imageFiles.isNotEmpty)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: imageFiles.map((file) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      file,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      _removeImage(file);
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).appColors.gfWarningColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        CupertinoIcons.xmark,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      )

                    else
                      Text(
                        '그린필드는 커뮤니티 이용규칙을 제정하여 운영하며, 규칙 위반 시 게시물이 삭제되고 서비스 이용이 제한될 수 있습니다.\n게시물 작성 전 커뮤니티 이용규칙 전문을 확인해야 합니다.\n'
                        '1. 정치·사회 관련 행위 금지\n'
                        '- 국가기관, 정치 단체, 언론, 시민단체에 대한 언급 및 관련 행위 금지\n'
                        '- 정책·외교·정치·정파에 대한 의견, 주장, 이념, 가치관 표현 금지\n'
                        '- 성별, 종교, 인종, 출신, 지역, 직업, 이념 등 사회적 이슈 언급 금지\n'
                        '- 관련된 비유나 은어 사용 행위 금지\n'
                        '- 시사·이슈 게시판 외 작성 금지\n'
                        '2. 홍보 및 판매 관련 행위 금지\n'
                        '- 영리 여부와 관계없이 사업체, 기관, 단체, 개인에게 영향을 줄 수 있는 게시물 금지\n'
                        '- 관련된 바이럴 홍보나 명칭, 단어 언급 금지\n'
                        '- 홍보게시판 외 작성 금지\n'
                        '3. 불법촬영물 유통 금지\n'
                        '- 불법촬영물 게시 시 전기통신사업법에 따라 삭제 조치 및 영구 이용 제한\n'
                        '- 관련 법률에 따른 처벌 가능\n'
                        '- 그 외 규칙 위반\n'
                        '4. 타인의 권리 침해 또는 불쾌감을 주는 행위 금지\n'
                        '- 범죄 및 불법 행위, 욕설, 비하, 차별, 혐오, 자살, 폭력 관련 게시물 금지\n'
                        '- 음란물 및 성적 수치심 유발 행위 금지\n'
                        '- 스포일러, 공포, 속임수, 놀라게 하는 행위 금지',
                        style: AppTextsTheme.main().gfCaption4.copyWith(
                          color: Theme.of(context).appColors.gfGray400Color,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            CupertinoButton(
              child: Image.asset(
                AppIcons.camera,
                width: 32,
                height: 32,
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();
                _pickImages();
              },
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
