import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class GalleryWater extends StatefulWidget {
  @override
  _GalleryWaterState createState() => _GalleryWaterState();
}
class _GalleryWaterState extends State<GalleryWater> {
  File _originalImage;
  File _watermarkImage;
  File _watermarkedImage;
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                (_originalImage != null) && (_watermarkImage != null)
                    ? FlatButton(
                  child: Text("Apply Watermark Over Image"),
                  onPressed: () async {
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
                  },
                )
                    : Container(),

//<--------------- display watermarked image ---------------->
                _watermarkedImage != null
                    ? Image.file(_watermarkedImage)
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}