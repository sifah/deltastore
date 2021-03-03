import 'package:deltastore/api/toJsonDetailHis.dart';
import 'package:deltastore/api/toJsonHistory.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

// Future<List<History>> fetchHistory() async {
//   dynamic token = await FlutterSession().get('token');
//   String idStore = token['data']['id_res_auto'];
//   String date = dateFormatA.format(_dateTime.date);
//   final res = await http.get("${Config.API_URL}get_history/$idStore/$date");
//   if (res.statusCode != 200) {
//     print(res.statusCode);
//   }
//   return historyFromJson(res.body);
// }

Future<DetailHistory> fetchDetailHistory(String orderId) async {
  dynamic token = await FlutterSession().get('token');
  String idStore = token['data']['id_res_auto'];
  final res = await http.get("${Config.API_URL}get_detail/$idStore/$orderId");
  if (res.statusCode != 200){
    print(res.statusCode);

  }
  print("${Config.API_URL}get_detail/$idStore/$orderId");
  return detailHistoryFromJson(res.body);
}
