import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/screen/notification/provider/notification_provider.dart';
import 'package:fast_app_base/screen/notification/s_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import './vo/vo_notification.dart';

class NotificationItemWidget extends ConsumerStatefulWidget {
  final DaangnNotification notification;
  final VoidCallback onTap;

  const NotificationItemWidget(
      {required this.onTap, super.key, required this.notification});

  @override
  ConsumerState<NotificationItemWidget> createState() => _NotificationItemWidgetState();
}

class _NotificationItemWidgetState extends ConsumerState<NotificationItemWidget> {
  static const leftPadding = 15.0;
  static const iconWidth = 50.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = ref.watch(notificationEditModeProvider);

    return Tap(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: widget.notification.isRead
            ? context.backgroundColor
            : context.appColors.unreadColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              widget.notification.type.iconPath,
              width: iconWidth,
            ).p(10),
            width10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Width(leftPadding),
                  widget.notification.title.text
                      .size(15)
                      .make(),
                  height10,
                  widget.notification.description.text
                      .color(context.appColors.lessImportant)
                      .make(),
                      //.pOnly(left: leftPadding + iconWidth),
                  height10,
                  timeago
                      .format(widget.notification.time,
                      locale: context.locale.languageCode)
                      .text
                      .size(13)
                      .color(context.appColors.lessImportant)
                      .make(),
                      //.pOnly(left: leftPadding + iconWidth),
                ],
              ),
            ),

            if(isEditMode)
              IconButton(onPressed: (){
                final list = ref.read(notificationProvider)!;
                list.remove(widget.notification); //실무에서는 removewhere로 사용
                ref.read(notificationProvider.notifier).state = List.of(list); //그냥 list를 넘기면 같은 객체라 비교가 불가능
              }, icon: Icon(Icons.delete))
          ],
        ),
      ),
    );
  }
}
