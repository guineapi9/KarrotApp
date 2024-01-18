import 'package:fast_app_base/data/network/daangn_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../entity/post/vo_product_post.dart';

//분리된 id별로 데이터를 가져올 때는 Family를 사용
//notification과 달리 메모리 관리를 별도로 하지 않아서 StateProvider는 사용하지 않음.
final productPostProvider = FutureProviderFamily<ProductPost, int>((ref, id) async {
  //에러 처리도 riverpod이 하므로 불필요
  return await DaangnApi.getPost(id);
});