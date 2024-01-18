import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/screen/notification/f_notifiction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//편집모드 여부. default값은 false
final notificationEditModeProvider = StateProvider((ref) => false);

class NotificationScreen extends HookConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);
    final isEditMode = ref.watch(notificationEditModeProvider);

    return Material(
      child: Column(
        children: [
          AppBar(
            title: const Text("알림"),
            actions: [
              Tap(
                  onTap: () {
                    ref.read(notificationEditModeProvider.notifier).state =
                        !isEditMode; //토글
                  },
                  child: isEditMode
                      ? const Text("완료").p(10)
                      : const Text("편집").p(10)),
            ],
          ),
          TabBar(
            controller: tabController,
            tabs: ['활동 알림'.text.white.make(), '키워드 알림'.text.white.make()],
            labelStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            labelPadding: const EdgeInsets.symmetric(vertical: 20),
            indicatorColor: Colors.white,
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                //Container(color: Colors.red),
                NotificationFragment(),
                Container(color: Colors.blue),
              ],
            ),
          )
        ],
      ),
    );
  }
}
