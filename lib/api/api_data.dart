import 'package:deltastore/config.dart';
import 'package:deltastore/main_order.dart';
import 'package:http/http.dart' as http;
import 'package:deltastore/api/toJsonPayment.dart';
import 'package:deltastore/api/toJsonDistance.dart';
import 'package:deltastore/api/toJsonPicture.dart';
import 'package:deltastore/api/toJsonRes.dart';

Future<List<Payments>> fetchPayment() async {
  String idRes = token['data']['id_res_auto'];
  final res = await http.get('${Config.API_URL}get_payments/$idRes');
  if (res.statusCode != 200) {
    print(res.statusCode);
  }
  return paymentsFromJson(res.body);
}

Future<Distance> fetchDistance() async {
  String idRes = token['data']['id_res_auto'];
  final res = await http.get('${Config.API_URL}send_options/$idRes');
  // print(res.body);
  if (res.statusCode != 200) {
    print(res.statusCode);
  }
  return distanceFromJson(res.body);
}

Future<List<StorePhoto>> fetchAllPicture() async {
  String idRes = token['data']['id_res_auto'];
  final res = await http.get('${Config.API_URL}store_photo/$idRes');
  // print('${Config.API_URL}store_photo/$idRes');
  // print(res.body);
  if (res.statusCode != 200) {
    print(res.statusCode);
  }
  return storePhotoFromJson(res.body);
}

Future<ResName> fetchRes() async {
  String idRes = token['data']['id_res_auto'];
  final res = await http.get('${Config.API_URL}/get_res/$idRes');
  if (res.statusCode != 200) {
    print(res.statusCode);
  }

  return resNameFromJson(res.body);
}
