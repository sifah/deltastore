import 'package:flutter/material.dart';

class Userfield extends StatelessWidget {
  Icon fieldIcon;
  String hintText;

  TextEditingController _user = TextEditingController();

  Userfield(this.fieldIcon, this.hintText, this._user);

  void Login() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.orange,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(padding: const EdgeInsets.only(left: 12), child: fieldIcon),
            Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                width: 200,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextField(
                    controller: _user,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hintText,
                        fillColor: Colors.white,
                        filled: true),
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
