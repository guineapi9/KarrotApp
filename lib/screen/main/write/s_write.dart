import 'package:fast_app_base/common/util/app_keyboard_util.dart';
import 'package:fast_app_base/common/widget/round_button_theme.dart';
import 'package:fast_app_base/common/widget/w_round_button.dart';
import 'package:fast_app_base/entity/post/vo_simple_product_post.dart';
import 'package:fast_app_base/entity/product/product_status.dart';
import 'package:fast_app_base/entity/product/vo_product.dart';
import 'package:fast_app_base/entity/user/vo_address.dart';
import 'package:fast_app_base/screen/main/tab/home/provider/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/common.dart';
import '../../../entity/dummies.dart';
import '../../post_detail/s_post_detail.dart';

class WriteScreen extends ConsumerStatefulWidget {
  const WriteScreen({super.key});

  @override
  ConsumerState<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends ConsumerState<WriteScreen> with KeyboardDetector {
  final List<String> imageList = [picSum(442)];
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
        title: Text("내 물건 팔기"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Nav.pop(context);
          },
        ),
        actions: [
          "임시저장".text.make().p(15),
        ],
      ),
      body: SingleChildScrollView(
        //padding: EdgeInsets.only(bottom: 150),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ImageSelectWidget(
              imageList,
              onTap: () {},
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
            child: CircularProgressIndicator()).pOnly(right: 100)
          : null,
      onTap: () {
        final title = titleController.text;
        final price = int.parse(priceController.text);
        final description = descriptionController.text;

        setState(() {
          isLoading=true;
        });
        final list = ref.read(postProivder); //기존 값 가져오기

        final newProductPost = SimpleProductPost(6, user3, Product(
          user3,
          title,
          price,
          ProductStatus.normal,
          imageList,
        ), title, Address("서울시 도화동", "도화동"), 0, 0, DateTime.now());
        //add는 void라서 점을 두개 찍어야 본인을 반환
        ref.read(postProivder.notifier).state = List.of(list)..add(newProductPost);
        Nav.pop(context);
        Nav.push(PostDetailScreen(newProductPost.id ,simpleProductPost: newProductPost));

        setState(() {
          isLoading = true;
        });
      },
    ),);
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

  const _ImageSelectWidget(this.imageList, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(
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
          ],
        ),
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
          decoration: const InputDecoration(
              hintText: "￦ 가격을 입력해주세요.",
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange,
                  )),
              border: OutlineInputBorder(
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
