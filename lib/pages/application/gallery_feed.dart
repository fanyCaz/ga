import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pp;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:watermark_shareable/watermark_shareable.dart';

class GalleryWater extends StatefulWidget {
  @override
  _GalleryWaterState createState() => _GalleryWaterState();
}
class _GalleryWaterState extends State<GalleryWater> {
  File _originalImage;
  File _watermarkImage;
  File _watermarkedImage;
  dynamic imajen;
  final picker = ImagePicker();

  Future getOriginalImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _originalImage = File(pickedFile.path);
    });
  }

  Future getWatermarkImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _watermarkImage = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Watermark Example"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
//<--------------- select original image ---------------->
                _originalImage == null
                    ? FlatButton(
                  child: Text("Select Original Image"),
                  onPressed: getOriginalImage,
                )
                    : Image.file(_originalImage),

//<--------------- select watermark image ---------------->
                _watermarkImage == null
                    ? FlatButton(
                  child: Text("Select Watermark Image"),
                  onPressed: getWatermarkImage,
                )
                    : Image.file(_watermarkImage),

                SizedBox(
                  height: 50,
                ),
//<--------------- apply watermark over image ---------------->
                (_originalImage != null)
                    ? FlatButton(
                  child: Text("Apply Watermark Over Image"),
                  onPressed: () async {
                    FirebaseStorage storage = FirebaseStorage.instance;
                    final picker = ImagePicker();
                    PickedFile pickedImage;
                    var image2 = await picker.getImage(
                        source: ImageSource.gallery,
                        maxWidth: 1920);
                    try{
                      var imgg = await WatermarkShareable.getPostWithWaterMark(
                      image2.path, "post");
                      var tempDir = (await pp.getTemporaryDirectory()).path;
                      var fileName = "${DateTime.now()}.png";

                      var imageFile = await File('$tempDir/$fileName').writeAsBytes(imgg);

                      var snapshot = await storage.ref('tes2t2ean3do2.png').putFile(
                          imageFile,
                          //File(imajen),
                          SettableMetadata(customMetadata: {
                            'uploaded_by': 'mememeahora si??',
                          }));
                      setState(() {

                        imajen = imgg;
                      });
                    }catch(exception){
                      print("Error de watermakr");
                      print(exception);
                    }

                    /*pickedImage = await picker.getImage(
                        source: ImageSource.gallery,
                        maxWidth: 1920);
                    final String fileName = path.basename(pickedImage.path);
                    File imageFile = File(pickedImage.path);


                    FirebaseStorage storage = FirebaseStorage.instance;
                    //img.Image image = img.Image(_originalImage.);
                    //img.Image image = img.Image(320,240);


                    img.Image image =  FileImage(_originalImage) as img.Image;//_originalImage as img.Image;
                    img.fill(image, img.getColor(0,0,255));
                    img.drawString(image,img.arial_24,20, 20, 'holiii');
                    img.drawLine(image, 0, 0, 320, 420, img.getColor(255, 0, 0), thickness: 3);
                    img.gaussianBlur(image, 10);
                    Directory tempDir = await getTemporaryDirectory();
                    String tempPath = tempDir.path;

                    Directory appDocDir = await getApplicationDocumentsDirectory();
                    await appDocDir.create(recursive: true);
                    var dbPath = path.join(appDocDir.path, 'test.png');
                    String appDocPath = appDocDir.path;
                    print(dbPath);
                    //_watermarkImage = img;
                    //path.basename( dbPath);
                    try {
                      File(_originalImage.path).writeAsBytesSync(img.encodePng(image));
                    }catch(exception){
                      print(exception);
                    }
                    File imageeee = File(_originalImage.path);
                    var snapshot = await storage.ref('tes2t2ean3do2.png').putFile(
                        imageeee,
                        SettableMetadata(customMetadata: {
                          'uploaded_by': 'mememe',
                        }));
                    _watermarkImage = File(await snapshot.ref.getDownloadURL());


                    img.Image originalImage =
                    img.decodeImage(_originalImage.readAsBytesSync());
                    img.Image watermarkImage = img
                        .decodeImage(_watermarkImage.readAsBytesSync());

                    // add watermark over originalImage
                    // initialize width and height of watermark image
                    img.Image image = img.Image(160, 50);
                    img.drawImage(image, watermarkImage);

                    // give position to watermark over image
                    // originalImage.width - 160 - 25 (width of originalImage - width of watermarkImage - extra margin you want to give)
                    // originalImage.height - 50 - 25 (height of originalImage - height of watermarkImage - extra margin you want to give)
                    img.copyInto(originalImage, image,
                        dstX: originalImage.width - 160 - 25,
                        dstY: originalImage.height - 50 - 25);
print("LLEGA AQUIII");
                    // for adding text over image
                    // Draw some text using 24pt arial font
                    // 100 is position from x-axis, 120 is position from y-axis
                    img.drawString(originalImage, img.arial_24, 100, 120,
                        'Think Different');
print("LLEGA A THINK DIFFERENT does it work?? hay que checar con otra cosa");
                    // Store the watermarked image to a File
                    List<int> wmImage = img.encodePng(originalImage);
print(wmImage);

                    setState(() {

                      _watermarkedImage =
                          File.fromRawPath(Uint8List.fromList(wmImage));
                      print(_watermarkedImage);
                      Image.file(_watermarkedImage);
                    });
                    */
                  },
                )
                    : Container(),

//<--------------- display watermarked image ---------------->
                imajen != null
                    ? Image.memory(imajen)
                    : Container(),
              ],
            ),
          ),
        ),
    );
  }
}