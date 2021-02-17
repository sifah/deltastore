// import 'package:flutter/material.dart';





// class DropdownDis extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() => _DropdownDis();
//
// }
//
// class _DropdownDis extends State {
//   final _formkey = GlobalKey<FormState>();
//   String distanceValue;
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return DropdownButtonFormField( decoration: InputDecoration(
//         labelText: 'รูปแบบการจัดส่ง',
//         labelStyle: TextStyle(color: Colors.black),
//         contentPadding: EdgeInsets.all(10)),
//       value: distanceValue,
//       validator: (value) =>
//       value == null ? 'กรุณาเลือกรูปแบบระยะทาง' : null,
//       onChanged: (String newValue) {
//         // This set state is trowing an error
//         setState(() {
//           distanceValue = newValue;
//         });
//       },
//       items: <String>[
//         'ตามระยะทาง',
//         'ตามจำนวน',
//         'ตามราคารวม',
//       ].map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: new Text(value),
//           onTap: () {},
//         );
//       }).toList(),
//     );
//   }
//
// }