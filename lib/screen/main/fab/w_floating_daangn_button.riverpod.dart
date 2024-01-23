import 'package:fast_app_base/common/cli_common.dart';
import 'package:fast_app_base/screen/main/fab/w_floating_daangn_button.state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//상태 변경은 프로바이더의 ref.read 또는 ref.watch를 통해 이루어집니다.
//chatGPT
final floatingButtonStateProvider = StateNotifierProvider<
    FloatingButtonStateNotifier,
    FloatingButtonState>(
        (ref) => FloatingButtonStateNotifier(FloatingButtonState(false, false, false)));

//상태 변경과 알림을 담당
//chatGPT
class FloatingButtonStateNotifier extends StateNotifier<FloatingButtonState> {
  FloatingButtonStateNotifier(super.state);

  //필요가 없어졌다
  // @override
  // bool updateShouldNotify(FloatingButtonState old, FloatingButtonState current) {
  //   // TODO: implement updateShouldNotify
  //   return super.updateShouldNotify(old, current);
  // }

  bool needToMakeButtonBigger = false;

  void toggleMenu() {
    final isExpanded = state.isExpanded;
    final isSmall = state.isSmall;


    state = FloatingButtonState(!state.isExpanded, needToMakeButtonBigger ? false : true, false);

    //이 코드와 같은 의미
    // state.isExpanded = !state.isExpanded; //값을 반대로 바꿈
    // state.isSmall = true; //클릭하면 버튼을 작게 바꿈

    if(needToMakeButtonBigger){
      needToMakeButtonBigger = false;
    }

    if(!isSmall&&!isExpanded){
      needToMakeButtonBigger = true;
    }
  }

  void changeButtonSize(bool isSmall) {
    state = state.copyWith(isSmall: isSmall);
    //아래와 위는 같다
    //state = FloatingButtonState(state.isExpanded, isSmall);
  }

  void hideButton() {
    state = state.copyWith(isHidden: true);
  }
  void showButton() {
    state = state.copyWith(isHidden: false);
  }
}



