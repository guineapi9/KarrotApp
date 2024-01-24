import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/screen/main/tab/chat/f_chat.dart';
import 'package:fast_app_base/screen/main/tab/home/f_home.dart';
import 'package:fast_app_base/screen/main/tab/my/f_my.dart';
import 'package:fast_app_base/screen/main/tab/nearMe/f_near_me.dart';
import 'package:flutter/material.dart';

import 'localLife/f_local_life.dart';

enum TabItem {
  home(Icons.home, 'home', HomeFragment()),
  localLife(Icons.star, 'local_life', LocalLifeFragment()),
  nearMe(Icons.star, 'nearMe', NearMeFragment()),
  chat(Icons.chat, 'chat', ChatFragment()),
  my(Icons.person, 'my_daangn', MyFragment());

  final IconData activeIcon;
  final IconData inActiveIcon;
  final String tabNameKey;
  final Widget firstPage;

  const TabItem(this.activeIcon, this.tabNameKey, this.firstPage, {IconData? inActiveIcon})
      : inActiveIcon = inActiveIcon ?? activeIcon;

  static TabItem find(String? name){
    return values.asNameMap()[name] ?? TabItem.home;
  }

  BottomNavigationBarItem toNavigationBarItem(BuildContext context, {required bool isActivated}) {
    return BottomNavigationBarItem(
        icon: Icon(
          key: ValueKey(tabNameKey),
          isActivated ? activeIcon : inActiveIcon,
          color:
              isActivated ? context.appColors.iconButton : context.appColors.iconButtonInactivate,
        ),
        label: tabNameKey.tr());
  }
}
