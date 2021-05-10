import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/pages/home_page.dart';
import 'package:gallery_array/pages/shared/app_bar.dart';
import 'package:gallery_array/routes/auth_service.dart';
import 'package:gallery_array/routes/route_names.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_array/classes/ga_user.dart';
import 'package:watermark_shareable/watermark_shareable.dart';
import 'package:path_provider/path_provider.dart' as pp;

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  FirebaseStorage storage = FirebaseStorage.instance;
  DateTime hoy = DateTime.now();
  // Select and image from the gallery or take a picture with the camera
  // Then upload to Firebase Storage
  Future<void> _upload(String uid) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    final picker = ImagePicker();
    PickedFile pickedImage;
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted){
      var image2 = await picker.getImage(
          source: ImageSource.gallery,
          maxWidth: 1920);
      try {
        var imgg = await WatermarkShareable.getPostWithWaterMark(
            image2.path, "post");
        var tempDir = (await pp.getTemporaryDirectory()).path;
        var fileName = "${DateTime.now()}.png";

        var imageFile = await File('$tempDir/$fileName').writeAsBytes(imgg);

        var snapshot = await storage.ref(fileName).putFile(
            imageFile,
            SettableMetadata(customMetadata: {
              'uploaded': 'yes',
            }));
        imageUrl = await snapshot.ref.getDownloadURL();
        setState(() {

        });
      }catch(exception){
        print(exception);
      }
    }else{
      print('necesita permisos');
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

  int veces = 0;
  String usernameNow = "";

  void getUserNow() async {
    GAUser hola;
    var currentUser = await context.read<AuthenticationService>()
        .getCurrentUser()
        .then((value) => hola = value);
    setState(() {
      veces = 1;
      usernameNow = hola.username;
    });
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if( firebaseUser == null){
      return HomePage();
    }
    if (veces == 0) {
      getUserNow();
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
                        imageUrl,usernameNow, hoy);
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
    final byteData = await rootBundle.load('lib/images/watermark.png');

    final tempFile =
    File("${(await getTemporaryDirectory()).path}/$path");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    return file;
  }

  confirmUpload(String uid, String description, String image, String username, DateTime date) {
    context.read<AuthenticationService>().confirmUploadPhoto(uid, image, description, 0, username, date);
  }
}