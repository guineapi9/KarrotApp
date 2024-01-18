import 'package:fast_app_base/entity/post/vo_simple_product_post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../entity/dummies.dart';

//postList = 초기값
final postProivder = StateProvider<List<SimpleProductPost>>((ref) => postList);
