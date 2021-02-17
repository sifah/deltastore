import 'package:deltastore/api/toJsonOrder.dart';
import 'package:deltastore/config.dart';
import 'package:flutter_session/flutter_session.dart';
import 'toJsonDetailOrders.dart';
import 'package:http/http.dart' as http;

Future<List<Orders>> fetchOrders() async {
  dynamic token = await FlutterSession().get('token');
  String idStore = token['data']['id_res_auto'];
  final res = await http.get("${Config.API_URL}load_orders/$idStore");
  if (res.statusCode != 200){
    print(res.statusCode);
  }
  return ordersFromJson(res.body);
}

Stream<List<Orders>> getOrders() async* {
  Future.delayed(Duration(seconds: 2));
  print('get Orders');
  yield await fetchOrders();
}

Future<DetailOrders> fetchDetailOrders(String orderID) async{
  final res = await http.get("${Config.API_URL}order_detail/$orderID");
  //print("${Config.API_URL}order_detail/$orderID");
  if (res.statusCode != 200) {
    print(res.statusCode);
  }else{
   // print( jsonDecode(res.body)['items']);
  }
  return detailOrdersFromJson(res.body);
}
