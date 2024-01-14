import 'package:fast_app_base/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//편집모드 여부. default값은 false
final notificationEditModeProvider = StateProvider((ref) => false);

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = ref.watch(notificationEditModeProvider);

    return Column(
      children: [
        AppBar(
          title: Text("알림"),
          actions: [
            Tap(
                onTap: () {
                  ref.read(notificationEditModeProvider.notifier).state =
                      !isEditMode; //토글
                },
                child: isEditMode ? const Text("완료").p(10) : const Text("편집").p(10)),
          ],
        ),
      ],
    );
  }
}
