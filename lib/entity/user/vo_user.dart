import 'package:freezed_annotation/freezed_annotation.dart';

part 'vo_user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required final String nickname,
    required final String profileUrl,
    required final double temperature,
    required final int id,
  }) = _User;

//factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
