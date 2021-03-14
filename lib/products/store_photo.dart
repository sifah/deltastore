import 'dart:convert';

import 'package:deltastore/api/api_data.dart';
import 'package:deltastore/api/toJsonPicture.dart';
import 'package:deltastore/products/select_photo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image/image.dart' as Image;
// import 'package:multi_image_picker/multi_image_picker.dart';

import 'editimage.dart';

String photoUrl, photoId;
List listStorePhoto;

class StorePhotoPage extends StatefulWidget {
  final Function function;

  const StorePhotoPage({Key key, this.function}) : super(key: key);

  @override
  _StorePhotoPageState createState() => _StorePhotoPageState();
}

class _StorePhotoPageState extends State<StorePhotoPage> {
  List list;
  File _file;
  static const String urlUpload = 'https://develop.deltafood.co/upload/server/php/';

  String base64;

  void loadPicture() async {
    var res = await fetchAllPicture();
    setState(() {
      listStorePhoto = res;
    });
  }

  // void selectPhoto() async {
  //   var file = await ImagePicker().getImage(source: ImageSource.gallery);
  //   setState(() {
  //     _file = File(file.path);
  //   });
  //   // uploadPhoto();
  // }

  // void uploadPhoto() {
  //   if (_file == null) return;
  //   List<int> photoBytes = _file.readAsBytesSync();
  //   // String photoType = _file.path.split(".").last;
  //   // base64 = '$photoType;${base64Encode(photoBytes)}';
  //   base64 = base64Encode(photoBytes);
  //   final image = Image.decodeImage(photoBytes);
  //
  //
  //   print(_file.readAsBytesSync());
  //   // กดแล้วให้ส่งไป api
  //   http.post(urlUpload,body: _file.uri.path, ).then((res) {
  //     print(res.body);
  //   });
  // }

  Future alertDelete() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            title: Text('ยืนยันการลบ'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('ปิดออก')),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    'ยืนยัน',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    loadPicture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    // print(deviceWidth);
    return Scaffold(
      // backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 108, 171, 1),
        title: Text('คลังรูปภาพ'),
        // bottom: PreferredSize(
        //   preferredSize: Size(50, 50),
        //   child: ButtonBar(
        //     alignment: MainAxisAlignment.center,
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       RaisedButton(
        //         color: Colors.green,
        //         child: Row(
        //           children: [
        //             Icon(Icons.upload_outlined),
        //             Container(
        //               margin: EdgeInsets.only(left: 5),
        //               child: Text('อัพโหลดรูปจากเครื่อง'),
        //             )
        //           ],
        //         ),
        //         onPressed: () {},
        //       ),
        //     ],
        //   ),
        // ),
        centerTitle: true,
      ),
      body: listStorePhoto == null
          ? SpinKitFadingCircle(
              color: Colors.blue,
            )
          : GridView.builder(
              padding: EdgeInsets.only(top: 5),
              itemCount: listStorePhoto.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (deviceWidth < 400)
                      ? 3
                      : (deviceWidth < 800)
                          ? 6
                          : 9,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0),
              itemBuilder: (BuildContext context, int index) {
                return framePhoto(listStorePhoto[index]);
              },
            ),
      // persistentFooterButtons: [
      //   RaisedButton(
      //     color: Colors.green,
      //     child: Row(
      //       children: [
      //         Icon(Icons.upload_outlined),
      //         Container(
      //           margin: EdgeInsets.only(left: 5),
      //           child: Text('อัพโหลดรูปจากเครื่อง'),
      //         )
      //       ],
      //     ),
      //     onPressed: () {},
      //   )
      // ],
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_to_photos),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=>SelectPhoto()));
        },
      ),
    );
  }

  Widget framePhoto(StorePhoto storePhoto) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 2, spreadRadius: -0.1)
          ]),
      child: InkWell(
        child: Card(
          clipBehavior: Clip.antiAlias,
          // elevation: 5,
          color: Color.fromRGBO(43, 108, 171, 1),
          child: Container(
            padding: EdgeInsets.all(2),
            child: Stack(
              //mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(storePhoto.name),
                          fit: BoxFit.cover)),
                  // alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 20),
                  // child: Image.network(
                  //   images[index],
                  //   fit: BoxFit.fill,
                  // )
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Text('${storePhoto.title}',
                        style: TextStyle(color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () {
          setState(() {
            photoUrl = storePhoto.name;
            photoId = storePhoto.id;
          });
          // Navigator.pop(context);
          widget.function();
          Navigator.pop(context);

          // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => EditImage(photoUrl: storePhoto.name,)));
        },
        onLongPress: () {
          alertDelete();
          print('delete');
        },
      ),
    );
  }
}
