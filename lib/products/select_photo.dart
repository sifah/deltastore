import 'dart:io';
import 'package:deltastore/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectPhoto extends StatefulWidget {
  @override
  _SelectPhotoState createState() => _SelectPhotoState();
}

class _SelectPhotoState extends State<SelectPhoto> {
  static const String urlUpload =
      'https://develop.deltafood.co/upload/server/php/';
  List<File> images = [];

  void _openFileExplorer() async {
    List<File> files;
    try {
      FilePickerResult result = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: true);

      if (result != null) {
        files = result.paths.map((path) => File(path)).toList();
      } else {
        // User canceled the picker
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }

    // setState(() {
    //   images = files;
    // });
    print(images);
    managePhoto(files);
  }

  void managePhoto(List<File> list) {
    try {
      if (images.isEmpty) {
        list.forEach((element) {
          setState(() {
            images.add(element);
            print('aa');
          });
        });
      } else {
        list.forEach((element) {
          int index = images.indexWhere((file) => element.path == file.path);
          if (index == -1) {
            setState(() {
              images.add(element);
            });
            print('bb');
          }
        });
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }

  void uploadPhoto() async {
    print('upload');
    images.forEach((element) async {
      List<int> imageBytes = element.readAsBytesSync();
      String fileName = element.path.split(".").last;
      var base64Image = '$fileName;${base64Encode(imageBytes)}';
      print(base64Image);
      await http.post('${Config.API_URL}upload_picture',
          body: 'ddd').then((value) {
        print(value.body);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('อัพโหลดรูป'),
        backgroundColor: Color.fromRGBO(43, 108, 171, 1),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          images.isEmpty
              ? Center(
                  child: Text('โปรดเลือกรูปภาพ'),
                )
              : Container(
                  child: GridView.builder(
                      padding: EdgeInsets.only(top: 20),
                      shrinkWrap: true,
                      itemCount: images.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          mainAxisSpacing: 15,
                          childAspectRatio: 1.3,
                          maxCrossAxisExtent: 300),
                      itemBuilder: (context, i) {
                        return Image.file(images[i]
                            // height: 300,
                            // width: MediaQuery.of(context).size.width.toInt()
                            );
                      }),
                ),
          images.isEmpty
              ? Container()
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: RaisedButton(
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      color: Colors.blue,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.upload_outlined),
                          Text(
                            'อัพโหลด',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      onPressed: uploadPhoto,
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt_outlined),
        onPressed: _openFileExplorer,
      ),
    );
  }
}
