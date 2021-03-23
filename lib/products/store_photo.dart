import 'dart:convert';
// import 'dart:html';

import 'package:deltastore/api/api_data.dart';
import 'package:deltastore/api/toJsonPicture.dart';
import 'package:deltastore/config.dart';
import 'package:deltastore/main_order.dart';
import 'package:deltastore/products/select_photo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image/image.dart' as Image;
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
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
  static const String urlUpload =
      'https://develop.deltafood.co/upload/server/php/';

  String base64;
  BuildContext _context;

  File _selectedFile;
  Response response;
  String progress;
  Dio dio = new Dio();

  Future loadPicture() async {
    if (!mounted) return;
    if (mounted) {
      var res = await fetchAllPicture();
      setState(() {
        listStorePhoto = res;
      });
    }
  }

  void selectPhoto() async {
    if (!mounted) return;
    if (mounted) {
      var file = await ImagePicker().getImage(source: ImageSource.gallery);
      setState(() {
        _file = File(file.path);
      });
      uploadPhoto();
    }
  }

  void uploadPhoto() async {
    String uploadUrl = "${Config.API_URL}upload_picture";
    if (_file == null) return;
    List<int> photoBytes = _file.readAsBytesSync();
    String photoType = _file.path.split(".").last;
    base64 = '$photoType;${base64Encode(photoBytes)}';
    // base64 = base64Encode(photoBytes);
    // final image = Image.decodeImage(photoBytes);
    String fileName = _file.path.split('/').last;

    String params = jsonEncode({
      'admin_id': token['data']['admin_id'],
      'id_res_auto': token['data']['id_res_auto'],
      'photo': base64
    });
    print(params);
    // กดแล้วให้ส่งไป api
    http.post('${Config.API_URL}upload_picture', body: params).then((res) {
      print(res.body);
      loadPicture();
    });
  }

  Future alertDelete() {
    return showDialog(
        // context: context,
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
    if (listStorePhoto == null) {
      loadPicture();
    }
    super.initState();
  }

  // @override
  // void dispose() {
  //   loadPicture();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    _context = context;
    // print(deviceWidth);
    return Scaffold(
      // backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(43, 108, 171, 1),
        title: Text('คลังรูปภาพ'),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.drive_folder_upload,
            size: 35, color: Colors.white.withOpacity(0.9)),
        onPressed: () {
          selectPhoto();
          //  SelectPhoto();
          // selectFile();
        },
      ),
    );
  }

  Widget framePhoto(StorePhoto storePhoto) {
    return InkWell(
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 10,
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
        Navigator.pop(_context);
        widget.function();
        // Navigator.pop(context);
      },
      onLongPress: () {
        alertDelete();
        print('delete');
      },
    );
  }
}
