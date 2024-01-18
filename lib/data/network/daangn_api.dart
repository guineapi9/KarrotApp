import 'package:fast_app_base/common/cli_common.dart';
import 'package:fast_app_base/data/network/result/api_error.dart';
import 'package:fast_app_base/screen/notification/vo/notification_dummies.dart';
import 'package:fast_app_base/screen/notification/vo/vo_notification.dart';

import '../../entity/dummies.dart';
import '../../entity/post/vo_product_post.dart';
import '../simple_result.dart';

//실제라면 이곳에 Dio 혹은 Http로 작업
class DaangnApi {
//성공했을 때와 실패했을 때 서로 다른 결과값을 반환
  static Future<SimpleResult<List<DaangnNotification>, ApiError>>
  getNotification() async {
    //서버처럼 약간의 시간을 사용하기 위해
    await sleepAsync(1000.ms);
    return SimpleResult.success(notificationList);
  }

  static Future<ProductPost> getPost(int id) async {
    await sleepAsync(500.ms);
    return ProductPost(
        simpleProductPost: post1,
        content: '깨끗하게 잘 쓰던 물건이에요.'
            '잘 쓰면 좋겠습니다.'
            '감사합니다.');
  }
}
