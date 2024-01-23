import 'package:fast_app_base/common/dart/extension/snackbar_context_extension.dart';
import 'package:fast_app_base/screen/main/fab/w_floating_daangn_button.riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app.dart';
import '../common.dart';

class FcmManager {
  static void requestPermission() {
    FirebaseMessaging.instance.requestPermission();
  }

  static void initialized(WidgetRef ref) async {
    ///Foreground
    FirebaseMessaging.onMessage.listen((message) async {
      final title = message.notification?.title;
      if (title == null) {
        return;
      }
      ref.read(floatingButtonStateProvider.notifier).hideButton();
      final controller = App.navigatorKey.currentContext?.showSnackbar(
        title,
        extraButton: Tap(onTap: () {
          App.navigatorKey.currentContext!.go(message.data['deeplink']);
        }, child: "열기".text.bold.make().p(20)),
      );
      await controller?.closed; //닫힐 때 까지 기다린다.(스스로는 닫히지 않는다.)
      ref.read(floatingButtonStateProvider.notifier).showButton();
    });

    ///Background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      App.navigatorKey.currentContext!.go(message.data['deeplink']);
    });

    ///Not Running
    final firstMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (firstMessage != null) {
      await sleepUntil(() =>
      App.navigatorKey.currentContext != null && App.navigatorKey.currentContext!.mounted);
      // ignore: use_build_context_synchronously
      App.navigatorKey.currentContext!.go(firstMessage.data['deeplink']);
    }

    final token = await FirebaseMessaging.instance.getToken();
    print("token");
    print(token);

    // FirebaseMessaging.instance.onTokenRefresh.listen((event) {
    //   //매번 바뀌는 토큰을 API를 통해 서버로 전송
    // });
  }
}
