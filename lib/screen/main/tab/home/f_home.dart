import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/screen/main/fab/w_floating_daangn_button.riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeFragment extends ConsumerStatefulWidget {
  const HomeFragment({super.key});

  @override
  ConsumerState<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends ConsumerState<HomeFragment> {
  final scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() {
      final floatingState = ref.read(floatingButtonStateProvider);

      //이해 필요
      //isSmall 값이 바뀌는 것은 아니다.
      //100 이상, 즉 아래로 내려오고 isSmall이 아닌 큰 상태라면 상태를 true
      if(scrollController.position.pixels > 100 && !floatingState.isSmall) {
        ref.read(floatingButtonStateProvider.notifier).changeButtonSize(true);
        //100 이하, 즉 위쪽이고 isSmall인 작은 상태라면 상태를 false
      } else if(scrollController.position.pixels < 100 && floatingState.isSmall){
        ref.read(floatingButtonStateProvider.notifier).changeButtonSize(false);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      children: [
        Container(height: 500, color: Colors.red,),
        Container(height: 500, color: Colors.blue,),
        Container(height: 500, color: Colors.green,),
        Container(height: 500, color: Colors.grey,),
      ],
    );
  }
}
