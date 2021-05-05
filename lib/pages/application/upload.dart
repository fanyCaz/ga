import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/pages/home_page.dart';
import 'package:gallery_array/pages/shared/app_bar.dart';
import 'package:gallery_array/pages/shared/drawer.dart';
import 'package:gallery_array/routes/auth_service.dart';
import 'package:gallery_array/routes/route_names.dart';
import 'package:path/path.dart' as path;
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
  FirebaseStorage storage = FirebaseStorage.instance;

  // Select and image from the gallery or take a picture with the camera
  // Then upload to Firebase Storage
  Future<void> _upload(String uid) async {
    final picker = ImagePicker();
    PickedFile pickedImage;
    try {
      pickedImage = await picker.getImage(
          source: ImageSource.gallery,
          maxWidth: 1920);

      final String fileName = path.basename(pickedImage.path);
      File imageFile = File(pickedImage.path);

      try {
        // Uploading the selected image with some custom meta data
        var snapshot = await storage.ref(fileName).putFile(
            imageFile,
            SettableMetadata(customMetadata: {
              'uploaded_by': uid,
            }));
        imageUrl = await snapshot.ref.getDownloadURL();
        // Refresh the UI
        setState(() {});
      } on FirebaseException catch (error) {
        print(error);
      }
    } catch (err) {
      print(err);
    }
  }

  // Delete the selected image
  // This function is called when a trash icon is pressed
  Future<void> _delete(String ref) async {
    await storage.ref(ref).delete();
    // Rebuild the UI
    setState(() {});
  }
  TextEditingController descriptionController = TextEditingController();
  String imageUrl;

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if( firebaseUser == null){
      return HomePage();
    }
    return Scaffold(
      appBar:  CommonAppBar(
          title: '',
          appBar: AppBar(),
          logout: Padding(
              padding: EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: (){
                  context.read<AuthenticationService>().signOut();
                  Navigator.pushNamed(context,home);
                },
                color: Colors.white,
                icon: Icon(Icons.logout),
              )
          )
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              (imageUrl != null) ? Image.network(imageUrl) :
                IconButton(
                  icon: Icon(Icons.add_photo_alternate),
                  color: Colors.deepPurple,
                  iconSize: MediaQuery.of(context).size.width * 0.3,
                  onPressed: () => _upload(firebaseUser.uid),
                ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: getTransValue(context, 'description'),
                ),
                controller: descriptionController,
                validator: (value) {
                  return null;
                }
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.file_upload),
                    color: Colors.deepPurple,
                    iconSize: MediaQuery.of(context).size.width * 0.3,
                    onPressed: ()
                    {
                      confirmUpload(
                          firebaseUser.uid, descriptionController.text,
                          imageUrl);
                      Navigator.pop(context);
                      Navigator.pushNamed(context, uploadAnimation);
                    }
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<File> getWatermarkFile() async {
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

  confirmUpload(String uid, String description, String image) {
    context.read<AuthenticationService>().confirmUploadPhoto(uid, image, description, 0);
  }
}
  // Select and image from the gallery or take a picture with the camera
  // Then upload to Firebase Storage

/*
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
      print(_originalImage);
/*
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

 */
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
*/