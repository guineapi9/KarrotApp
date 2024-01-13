import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/screen/main/tab/chat/f_chat.dart';
import 'package:fast_app_base/screen/main/tab/home/f_home.dart';
import 'package:fast_app_base/screen/main/tab/my/f_my.dart';
import 'package:fast_app_base/screen/main/tab/nearMe/f_near_me.dart';
import 'package:flutter/material.dart';

import 'localLife/f_local_life.dart';

enum TabItem {
  home(Icons.home, '홈', HomeFragment()),
  localLife(Icons.star, '동네생활', LocalLifeFragment()),
  nearMe(Icons.star, '내 근처', NearMeFragment()),
  chat(Icons.chat, '채팅', ChatFragment()),
  my(Icons.person, '나의 당근', MyFragment());

  final IconData activeIcon;
  final IconData inActiveIcon;
  final String tabName;
  final Widget firstPage;

  const TabItem(this.activeIcon, this.tabName, this.firstPage, {IconData? inActiveIcon})
      : inActiveIcon = inActiveIcon ?? activeIcon;

  BottomNavigationBarItem toNavigationBarItem(BuildContext context, {required bool isActivated}) {
    return BottomNavigationBarItem(
        icon: Icon(
          key: ValueKey(tabName),
          isActivated ? activeIcon : inActiveIcon,
          color:
              isActivated ? context.appColors.iconButton : context.appColors.iconButtonInactivate,
        ),
        label: tabName);
  }
}
