import 'dart:convert';

import 'package:deltastore/api/toJsonProduct.dart';
import 'package:deltastore/api/toJsonEmployee.dart';
import 'package:deltastore/api/toJsonOrder.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import 'toJsonGroup_product.dart';

Future<List<GroupProduct>> fetchGroupProduct() async {
  dynamic token = await FlutterSession().get('token');
  String idStore = token['data']['id_res_auto'];
  final res = await http.get("${Config.API_URL}get_group/$idStore");
  if (res.statusCode != 200) {
    print(res.statusCode);
  }
  //print(jsonDecode(res.body));
  return groupProductFromJson(res.body);
}

Future<List<Product>> fetchProduct() async {
  dynamic token = await FlutterSession().get('token');
  String idStore = token['data']['id_res_auto'];
  final res = await http.get("${Config.API_URL}get_foods/$idStore");
  if (res.statusCode != 200) {
    print(res.statusCode);
  }
  //print(jsonDecode(res.body));
  return productFromJson(res.body);
}

Future fetchLocation() async {
  dynamic token = await FlutterSession().get('token');
  String idStore = token['data']['id_res_auto'];
  final res = await http.get('${Config.API_URL}get_location/$idStore');
  if (res.statusCode != 200) {
    print(res.statusCode);
  }
  return jsonDecode(res.body);
}

Stream<List<GroupProduct>> getGroupProduct() async* {
  Future.delayed(Duration(seconds: 2));
  print('get Group Product');
  yield await fetchGroupProduct();
}

Stream<List<Product>> getProduct() async* {
  Future.delayed(Duration(seconds: 2));
  print('get Product');
  yield await fetchProduct();
}

Future<List<Employees>> fetchEmployee() async {
  dynamic token = await FlutterSession().get('token');
  String idRes = token['data']['id_res_auto'];
  final res = await http.get('${Config.API_URL}/load_users/$idRes');
  if (res.statusCode != 200) {
    print(res.statusCode);
  }
  return employeesFromJson(res.body);
}

