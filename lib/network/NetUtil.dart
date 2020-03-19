import "Net.dart";
import 'NetUrl.dart';

class NetUtil {
  // 链接服务器
  static void connectServer({Function success, Function failure}) {
    Net().get(NetUrl.BASE_URL, null, success: success, failure: failure);
  }

  static void submitPointValue(Map<String, dynamic> params,
      {Function success, Function failure}) {
    Net().post(NetUrl.SUBMIT_VALUE, params, success: success, failure: failure);
  }
}
