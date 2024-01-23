import 'package:fast_app_base/common/cli_common.dart';
import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/widget/animated_width_collapse.dart';
import 'package:fast_app_base/screen/main/fab/w_floating_daangn_button.riverpod.dart';
import 'package:fast_app_base/screen/main/s_main.dart';
import 'package:fast_app_base/screen/main/write/s_write.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FloatingDaangnButton extends ConsumerWidget {
  FloatingDaangnButton({super.key});

  final duration = 300.ms;
  static const height = 100.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final floatingButtonState = ref.watch(floatingButtonStateProvider);
    final isExpanded = floatingButtonState.isExpanded;
    final isSmall = floatingButtonState.isSmall;
    final isHidden = floatingButtonState.isHidden;

    return AnimatedOpacity(
      opacity: isHidden ? 0 : 1,
      duration: duration,
      child: Stack(
        children: [
          //배경
          IgnorePointer(
            ignoring: !isExpanded,
            child:
            //Tap부분은 내가 추가. 글쓰기 버튼 누르고, 다시 나가고 싶을 때 배경 누르면 나갈 수 있도록 구현
            Tap(
              onTap: (){
                ref.read(floatingButtonStateProvider.notifier).toggleMenu();
              },
              child: AnimatedContainer(
                duration: duration,
                // 버튼이 팽창하면 불투명해진다
                color:
                    isExpanded ? Colors.black.withOpacity(0.3) : Colors.transparent,
              ),
            ),
          ),
          //버튼 전체
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                //팽창 후 아이콘
                //IgnorePointer 내가 추가
                IgnorePointer(
                  ignoring: !isExpanded,
                  child: AnimatedOpacity(
                    //팽창시에만 보이도록 설정
                    opacity: isExpanded ? 1 : 0,
                    duration: duration,
                    child: Column(
                      children: [
                        Container(
                          width: 160,
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.only(right: 15, bottom: 10),
                          decoration: BoxDecoration(
                              color: context.appColors.floatingActionLayer,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _floatItem('알바', '$basePath/fab/fab_01.png'),
                              _floatItem('과외/클라스', '$basePath/fab/fab_02.png'),
                              _floatItem('농수산물', '$basePath/fab/fab_03.png'),
                              _floatItem('부동산', '$basePath/fab/fab_04.png'),
                              _floatItem('중고차', '$basePath/fab/fab_05.png'),
                            ],
                          ),
                        ),
                        Tap(
                          onTap: (){
                            Nav.push(WriteScreen());
                            },
                          child: Container(
                            width: 160,
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.only(right: 15, bottom: 10),
                            decoration: BoxDecoration(
                                color: context.appColors.floatingActionLayer,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _floatItem('내 물건 팔기', '$basePath/fab/fab_06.png'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
      
                  ),
                ),
                // + 버튼
                IgnorePointer(
                  ignoring: isHidden,
                  child: Tap(
                    onTap: (){
                      //버튼을 클릭하면 값을 반대로 바꾸기
                      ref.read(floatingButtonStateProvider.notifier).toggleMenu();
                    },
                    child: AnimatedContainer(
                      duration: duration,
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                          color: isExpanded
                              ? context.appColors.floatingActionLayer
                              : Color(0xffff791f),
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, //작게 만들기
                        children: [
                          //팽창 시 + 버튼이 45도 돌아가도록 설정
                          //1/8 = 0.125 이 45도
                          AnimatedRotation(
                              turns: isExpanded ? 0.125 : 0,
                              duration: duration,
                              child: const Icon(Icons.add)),
                          //visible에 따라 MaxWidth가 변경됨
                          //visible에 따라 child도 변경됨
                          AnimatedWidthCollapse(
                            visible: !isSmall,
                            duration: duration,
                            child: "글쓰기".text.make(),
                          )
                        ],
                      ),
                    ),
                  ).pOnly(
                      bottom: MainScreenState.bottomNavigationBarHeight +
                          context.viewPaddingBottom +
                          10,
                      right: 20),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _floatItem(String title, String imagePath) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imagePath,
          width: 30,
        ),
        const Width(8),
        title.text.make(),
      ],
    );
  }
}
