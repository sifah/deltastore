import 'package:deltastore/api/toJsonDetailOrders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
//จะมีแยกกัน เป็น toppings กับ detailย่อย
class HtmlDetail extends StatelessWidget {
  Item dataItem;

  HtmlDetail(this.dataItem);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: """<ul>${dataItem.html}</ul>""",
      style: {"li": Style(fontFamily: 'Kanit', color: Colors.white)},
    );
  }
}

// class HtmlTopping extends StatelessWidget{
//   Item toppings;
//
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
//
// }
