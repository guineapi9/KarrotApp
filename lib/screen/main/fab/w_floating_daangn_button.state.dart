import 'package:freezed_annotation/freezed_annotation.dart';

part 'w_floating_daangn_button.state.freezed.dart';

@freezed
class FloatingButtonState with _$FloatingButtonState{
  //객체의 값이 바뀌는게 아니라 객체 자체가 바뀐다.
  //값의 변경이 없으므로 final로 선언
  factory FloatingButtonState(
    final bool isExpanded,
    final bool isSmall,
    final bool isHidden
      ) = _FloatingButtonState;
}