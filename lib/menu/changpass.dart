// import 'package:deltastore/main.dart';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MaterialApp(
//     home: ChangPass(),
//     debugShowCheckedModeBanner: false,
//   ));
// }
//
// class ChangPass extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _ChangPass();
// }
//
// class _ChangPass extends State {
//   TextEditingController _pass = TextEditingController();
//   TextEditingController _newPass = TextEditingController();
//   TextEditingController _newPassAgain = TextEditingController();
//
//   final _formkey = GlobalKey<FormState>();
//
//   bool visible = false;
//
//   void onSubmit() {
//     if (_formkey.currentState.validate()) {
//       _formkey.currentState.save();
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('เปลี่ยนรหัสผ่าน'),
//         backgroundColor: Color.fromRGBO(43, 108, 171, 1),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.all(10),
//           child: Form(
//             key: _formkey,
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: _pass,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: 'รหัสผ่านปัจจุบัน',
//                   ),
//                   validator: (input) =>
//                       input.length < 8 ? 'รหัสผ่านไม่ถูกต้อง' : null,
//                   onSaved: (input) => _pass = input as TextEditingController,
//                 ),
//                 TextFormField(
//                   controller: _newPass,
//                   decoration: InputDecoration(
//                     labelText: 'รหัสผ่านใหม่',
//                   ),
//                   validator: (input) {
//                     if (input.length < 8) {
//                       return 'รหัสผ่านของคุณต้องมีความยาว 8 ตัวอักษรขึ้นไป';
//                     }
//                     if (input != _newPass.text) {
//                       return 'รหัสผ่านไม่ตรงกัน';
//                     }
//                     return null;
//                   },
//                   onSaved: (input) => _newPass = input as TextEditingController,
//                 ),
//                 TextFormField(
//                   controller: _newPassAgain,
//                   decoration: InputDecoration(
//                     labelText: 'พิมพ์รหัสผ่านใหม่อีกคร้ง',
//                   ),
//                   validator: (input) => input.length < 8
//                       ? 'รหัสผ่านของคุณต้องมีความยาว 8 ตัวอักษรขึ้นไป'
//                       : null,
//                   onSaved: (input) =>
//                       _newPassAgain = input as TextEditingController,
//                 ),
//                 Container(
//                   padding: EdgeInsets.only(top: 50),
//                   width: 150,
//                   child: RaisedButton(
//                     onPressed: onSubmit,
//                     color: Colors.green,
//                     // shape: RoundedRectangleBorder(
//                     //     borderRadius:
//                     //     BorderRadius.all(Radius.circular(20))),
//                     child: Text(
//                       'บันทึก',
//                       style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
