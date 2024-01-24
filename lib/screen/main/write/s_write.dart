import 'dart:io';

import 'package:fast_app_base/common/util/app_keyboard_util.dart';
import 'package:fast_app_base/common/widget/round_button_theme.dart';
import 'package:fast_app_base/common/widget/w_round_button.dart';
import 'package:fast_app_base/entity/post/vo_simple_product_post.dart';
import 'package:fast_app_base/entity/product/product_status.dart';
import 'package:fast_app_base/entity/product/vo_product.dart';
import 'package:fast_app_base/entity/user/vo_address.dart';
import 'package:fast_app_base/screen/dialog/d_message.dart';
import 'package:fast_app_base/screen/main/tab/home/provider/post_provider.dart';
import 'package:fast_app_base/screen/main/write/d_select_image_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/common.dart';
import '../../../entity/dummies.dart';
import '../../post_detail/s_post_detail.dart';

class WriteScreen extends ConsumerStatefulWidget {
  const WriteScreen({super.key});

  @override
  ConsumerState<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends ConsumerState<WriteScreen>
    with KeyboardDetector {
  final List<String> imageList = [];
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    //상태변화를 감지
    titleController.addListener(() {
      setState(() {});
    });
    priceController.addListener(() {
      setState(() {});
    });
    descriptionController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("sell_my_thing").tr(),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Nav.pop(context);
          },
        ),
        actions: [
          "temp_save".tr().text.make().p(15),
        ],
      ),
      body: SingleChildScrollView(
        //padding: EdgeInsets.only(bottom: 150),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ImageSelectWidget(
              imageList,
              onTap: () async {
                //화면 이동은 future 함수로 구현해야한다.
                //갤러리, 카메라 선택 화면
                final selectedSource = await SelectImageSourceDialog().show();

                if (selectedSource == null) {
                  return;
                }
                try {
                  //파일 선택 화면
                  final file =
                  await ImagePicker().pickImage(source: selectedSource);
                  //파일이 없으면 취소
                  if (file == null) {
                    return;
                  }
                  //List 전체를 넣는것이 아니므로 현재는 ref 사용을 안하는듯(내 생각)
                  setState(() {
                    imageList.add(file.path);
                  });
                } on PlatformException catch(e){
                  switch(e.code){
                    case 'invalid_image':
                      MessageDialog("지원하지 않는 이미지 형식입니다.").show();
                  }
                }catch(e){
                  //메세지 다이얼로그

                }


              }, onTapDeleteImage: (imagePath) {
                setState(() {
                  imageList.remove(imagePath);
                });
            },
            ),
            height30,
            _TitleEditor(titleController),
            height30,
            _PriceEditor(priceController),
            height30,
            _DescEditor(descriptionController),
          ],
        ).pSymmetric(h: 15),
      ),
      //키보드가 올라왔을 때는 "작성완료"가 보이지 않도록 설정
      //with KeyboardDetector를 추가
      bottomSheet: isKeyboardOn
          ? null
          : RoundButton(
              isFullWidth: true,
              bgColor: Vx.orange500,
              borderRadius: 10,
              isEnabled: isValid,
              text: isLoading ? "저장 중" : "작성 완료",
              rightWidget: isLoading
                  ? const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator())
                      .pOnly(right: 100)
                  : null,
              onTap: () {
                final title = titleController.text;
                final price = int.parse(priceController.text);
                final description = descriptionController.text;

                setState(() {
                  isLoading = true;
                });
                final list = ref.read(postProivder); //기존 값 가져오기

                final newProductPost = SimpleProductPost(
                    6,
                    user3,
                    Product(
                      user3,
                      title,
                      price,
                      ProductStatus.normal,
                      imageList,
                    ),
                    title,
                    Address("서울시 도화동", "도화동"),
                    0,
                    0,
                    DateTime.now());
                //add는 void라서 점을 두개 찍어야 본인을 반환
                ref.read(postProivder.notifier).state = List.of(list)
                  ..add(newProductPost);
                Nav.pop(context);
                Nav.push(PostDetailScreen(newProductPost.id,
                    simpleProductPost: newProductPost));

                setState(() {
                  isLoading = true;
                });
              },
            ),
    );
  }

  //컨트롤러에 텍스트가 비어있는지 검사.
  bool get isValid =>
      isNotBlank(titleController.text) &&
      isNotBlank(priceController.text) &&
      isNotBlank(descriptionController.text);
}

class _ImageSelectWidget extends StatelessWidget {
  final List<String> imageList;
  final VoidCallback onTap;
  final void Function(String path) onTapDeleteImage;

  const _ImageSelectWidget(this.imageList,
      {super.key, required this.onTap, required this.onTapDeleteImage});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: 100,
      child: SingleChildScrollView(
        //개수가 50개 이상이라면 List.View를 사용하는 편이 좋다.
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SelectImageButton(onTap: onTap, imageList: imageList)
                .pOnly(top: 10, right: 4),
            ...imageList.map((imagePath) => Stack(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            File(imagePath),
                            fit: BoxFit.fill,
                          ).box.rounded.border(color: Colors.grey).make()),
                    ).pOnly(left: 4, right: 10, top: 10),
                    Positioned.fill(
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Tap(
                                onTap: () {
                                  onTapDeleteImage(imagePath);
                                },
                                child: Icon(Icons.cancel)
                                    .pOnly(left: 10, bottom: 10))))
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class SelectImageButton extends StatelessWidget {
  const SelectImageButton({
    super.key,
    required this.onTap,
    required this.imageList,
  });

  final VoidCallback onTap;
  final List<String> imageList;

  @override
  Widget build(BuildContext context) {
    return Tap(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt),
            RichText(
                text: TextSpan(children: [
              TextSpan(text: imageList.length.toString()),
              TextSpan(text: "/10"),
            ])),
          ],
        ).box.rounded.border(color: Colors.grey).make(),
      ),
    );
  }
}

class _TitleEditor extends StatelessWidget {
  final TextEditingController controller;

  const _TitleEditor(this.controller);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "제목".text.bold.make(),
        height5,
        TextField(
          decoration: const InputDecoration(
              hintText: "제목",
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.orange,
              )),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.grey,
              ))),
          controller: controller,
        ),
      ],
    );
  }
}

class _PriceEditor extends StatefulWidget {
  final TextEditingController controller;

  const _PriceEditor(this.controller);

  @override
  State<_PriceEditor> createState() => _PriceEditorState();
}

class _PriceEditorState extends State<_PriceEditor> {
  bool isDonateMode = false;
  final priceNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "거래 방식".text.bold.make(),
        height5,
        Row(
          children: [
            RoundButton(
                text: "판매하기",
                theme: isDonateMode
                    ? RoundButtonTheme.whiteWithBlueBorder
                    : RoundButtonTheme.blue,
                onTap: () {
                  widget.controller.clear();
                  setState(() {
                    isDonateMode = false;
                  });
                  //아주 미세하게 딜레이를 만들어 키보드가 뜰 시간을 확보
                  delay(() {
                    AppKeyboardUtil.show(context, priceNode);
                  });
                }),
            width10,
            RoundButton(
                text: "나눔하기",
                theme: !isDonateMode
                    ? RoundButtonTheme.whiteWithBlueBorder
                    : RoundButtonTheme.blue,
                onTap: () {
                  setState(() {
                    isDonateMode = true;
                    widget.controller.text = "0";
                  });
                }),
          ],
        ),
        height5,
        TextField(
          keyboardType: TextInputType.number,
          focusNode: priceNode,
          enabled: !isDonateMode,
          decoration: InputDecoration(
              hintText: "input_price".tr(namedArgs: {'test':'💰'}),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.orange,
              )),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.grey,
              ))),
          controller: widget.controller,
        ),
      ],
    );
  }
}

class _DescEditor extends StatelessWidget {
  final TextEditingController controller;

  _DescEditor(this.controller);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "자세한 설명".text.bold.make(),
        height5,
        TextField(
          maxLines: 7,
          decoration: const InputDecoration(
              hintText: "에 올릴 게시글을 작성해 주세요.",
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.orange,
              )),
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.grey,
              ))),
          controller: controller,
        ),
      ],
    );
    ;
  }
}
