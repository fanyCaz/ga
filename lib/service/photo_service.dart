import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoService{
  final _storage = FirebaseStorage.instance;

  Future<String> uploadImage() async {
    final _picker = ImagePicker();

    PickedFile image;
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if(permissionStatus.isGranted){
      image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);

      if(image != null){
        var snapshot = await _storage.ref()
            .child('folderName/imageName')
            .putFile(file);

        var downloadUrl = await snapshot.ref.getDownloadURL();
        return "200";
      }else{
        print('no paht :c');
        return "no-path";
      }
    }else{
      print('grantt please');
      return "grant-please";
    }
  }


}