import 'package:deltastore/api/toJsonReason.dart';
import 'package:deltastore/config.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;

Future<List<Reason>> fetchReason() async {
  dynamic token = await FlutterSession().get('token');
  String idStore = token['data']['id_res_auto'];
  final res = await http.get("${Config.API_URL}get_reason_order/$idStore");
  if (res.statusCode != 200) {
    print(res.statusCode);
  }
  return reasonFromJson(res.body);
}
