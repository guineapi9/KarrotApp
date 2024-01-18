import 'package:fast_app_base/data/network/daangn_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final remoteNotificationProvider = FutureProvider((ref)async{
  final result = await DaangnApi.getNotification();
  return result.successData;

});

final notificationProvider = StateProvider((ref){
  final list = ref.watch(remoteNotificationProvider);
  if (list.hasValue){
    return list.requireValue;
  }
  return null; //서버에서 아직 도착하지 않았다.
});