import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/screen/main/fab/w_floating_daangn_button.dart';
import 'package:fast_app_base/screen/main/fab/w_floating_daangn_button.riverpod.dart';
import 'package:fast_app_base/screen/main/tab/home/w_product_post_item.dart';
import 'package:fast_app_base/screen/notification/s_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/widget/w_line.dart';
import '../../../../entity/dummies.dart';

class HomeFragment extends ConsumerStatefulWidget {
  const HomeFragment({super.key});

  @override
  ConsumerState<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends ConsumerState<HomeFragment> {
  final scrollController = ScrollController();
  String title = "플러터동";

  @override
  void initState() {
    scrollController.addListener(() {
      final floatingState = ref.read(floatingButtonStateProvider);

      //이해 필요
      //isSmall 값이 바뀌는 것은 아니다.
      //100 이상, 즉 아래로 내려오고 isSmall이 아닌 큰 상태라면 상태를 true
      if (scrollController.position.pixels > 100 && !floatingState.isSmall) {
        ref.read(floatingButtonStateProvider.notifier).changeButtonSize(true);
        //100 이하, 즉 위쪽이고 isSmall인 작은 상태라면 상태를 false
      } else if (scrollController.position.pixels < 100 &&
          floatingState.isSmall) {
        ref.read(floatingButtonStateProvider.notifier).changeButtonSize(false);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  //편집 탭으로 이동
                  Nav.push(const NotificationScreen());
                },
                icon: const Icon(Icons.notifications_none_rounded),
              )
            ],
            title: PopupMenuButton<String>(
              onSelected: (value) {
                // 특정 widget안에서만 사용되는 value이기 때문에 riverpod을 사용 안함.
                setState(() {
                  title = value;
                });
              },
              itemBuilder: (BuildContext context) => ["다트동", "맵동"]
                  .map((dong) => PopupMenuItem(
                        value: dong,
                        child: Text(dong), // text.make를 하면 안됨. 이유는 모르겠다.
                      ))
                  .toList(),
              child: Text(title),
            ),
            automaticallyImplyLeading: false, //햄버거 버튼 사라지게하기
          ),
          Expanded(
            child: ListView.separated(
              padding:
                  const EdgeInsets.only(bottom: FloatingDaangnButton.height),
              //분리된 List에서는 separated 사용
              controller: scrollController,
              itemBuilder: (context, index) => ProductPostItem(postList[index]),
              itemCount: postList.length,
              separatorBuilder: (context, index) =>
                  const Line().pSymmetric(h: 15),
              //기존 List일때는 map 사용
              //children: postList.map((post) => ProductPostItem(post)).toList()
            ),
          ),
        ],
      ),
    );
  }
}
