import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/screen/notification/vo/notification_type.dart';
import 'package:fast_app_base/screen/notification/vo/vo_notification.dart';

//getter로 해도 되고 final로 해도 된다.
//getter로 하면 hot reload때 반영이 잘 되는것 같은데, 이유는 모르겠다.
final notification1 = DaangnNotification(NotificationType.official, '💌 8월 가계부가 도착했어요!',
    '#당근 #당근가계부 #자원재순환 #따뜻한 거래', DateTime.now().subtract(3.hours));

get notification2 => DaangnNotification(NotificationType.legal, '당근페이 전자금융거래 이용약관 개정 안내',
    '개정사항 확인하기 (2023년 10월 1일 적용)', DateTime.now().subtract(3.days));

get notification3 => DaangnNotification(NotificationType.official, "지금 새로워진 '당근'을 만나보세요.🥕 ",
    '새 이름 새 로고를 소개할게요!', DateTime.now().subtract(4.days),
    isRead: true);

get notification4 => DaangnNotification(NotificationType.local, '가족집수리',
    '마음에 드셨다면 다른 이웃들을 위해 따뜻한 후기를 남겨주세요~', DateTime.now().subtract(7.days));

List<DaangnNotification> notificationList = [
  notification1,
  notification2,
  notification3,
  notification4,
];