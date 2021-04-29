import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/pages/shared/app_bar.dart';
import 'package:gallery_array/pages/shared/drawer.dart';
import 'package:image/image.dart' as ui;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File _originalImage;
  File _watermarkImage;
  File _watermarkedImage;
  final picker = ImagePicker();

  String imageUrl;
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    return Scaffold(
        appBar: CommonAppBar(title: getTransValue(context, 'upload-photo'),appBar: AppBar()),
        drawer: DrawerList(),
        body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('Photo'),
              (imageUrl != null) ? Image.network(imageUrl) : Placeholder(fallbackHeight: 200.0, fallbackWidth: double.infinity,),
              Spacer(),
              ElevatedButton(
                onPressed: (){
                  uploadImage(firebaseUser.uid);
                },
                child: Text(
                  getTransValue(context, 'upload-file'),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<File> getWatermarkFile() async{
    String path = 'lib/images/watermark.png';
    /*final byteDae = await rootBundle.load('lib/images/watermark.png');
    var pathNow = (await getTemporaryDirectory()).path;

    final file = File('$pathNow/$path');
    await file.writeAsBytes(byteDae.buffer.asUint8List(byteDae.offsetInBytes, byteDae.lengthInBytes));
    return file;*/
    final byteData = await rootBundle.load('lib/images/watermark.png');

    final tempFile =
    File("${(await getTemporaryDirectory()).path}/$path");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    return file;
  }

  uploadImage(String uid) async {

    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;

    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted){
      //Select Image
      image = await _picker.getImage(source: ImageSource.gallery);
      _originalImage = File(image.path);

      ui.Image image_original = ui.decodeImage(_originalImage.readAsBytesSync());

      _watermarkImage = await getWatermarkFile();
      ui.Image watermarkImage = ui.decodeImage( _watermarkImage.readAsBytesSync() );

      ui.Image _image = ui.Image(100,50);
      ui.drawImage(_image, watermarkImage);

      ui.copyInto(image_original, _image, dstX: image_original.width - 100 - 25, dstY: image_original.height- 50 -25);
      ui.drawString(image_original, ui.arial_24, 100, 120, 'gallery array');

      List<int> wmImage = ui.encodePng(image_original);
      setState(() {
        _watermarkedImage = File.fromRawPath(Uint8List.fromList(wmImage));
      });
      var rng = new Random();

      if (image != null){
        //Upload to Firebase
        var snapshot = await _storage.ref()
            .child(uid+'/'+rng.nextInt(10000).toString())
            .putFile(_originalImage);

        var downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          imageUrl = downloadUrl;
        });
      } else {
        print('No Path Received');
      }

    } else {
      print('Grant Permissions and try again');
    }

  }
}
