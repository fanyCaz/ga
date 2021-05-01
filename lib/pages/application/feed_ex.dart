import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gallery_array/classes/photo.dart';
import 'package:gallery_array/pages/home_page.dart';
import 'package:gallery_array/pages/shared/app_bar.dart';
import 'package:gallery_array/pages/shared/drawer.dart';
import 'package:gallery_array/routes/auth_service.dart';
import 'package:gallery_array/routes/route_names.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class upFeedPage extends StatefulWidget {
  @override
  _upFeedPageState createState() => _upFeedPageState();
}

class _upFeedPageState extends State<upFeedPage> {
  FirebaseStorage storage = FirebaseStorage.instance;

  final _loved = <Photo>{};


  // Retriew the uploaded images
  // This function is called when the app launches for the first time or when an image is uploaded or deleted
  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage.ref().list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "uploaded_by": fileMeta.customMetadata['uploaded_by'],
        "description": fileMeta.customMetadata['description']
      });
    });

    return files;
  }

  // Delete the selected image
  // This function is called when a trash icon is pressed
  Future<void> _delete(String ref) async {
    await storage.ref(ref).delete();
    // Rebuild the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if( firebaseUser == null){
      return HomePage();
    }
    return Scaffold(
      appBar: CommonAppBar(
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
      drawer: DrawerList(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                    onPressed: () => _upload('camera', firebaseUser.uid),
                    icon: Icon(Icons.camera),
                    label: Text('camera')),
                ElevatedButton.icon(
                    onPressed: () => _upload('gallery', firebaseUser.uid),
                    icon: Icon(Icons.library_add),
                    label: Text('Gallery')),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: _loadImages(),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        final image = snapshot.data[index];
                        return Card(
                          color: Color(0xffe3d5eb),
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)
                          ),
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: [
                              _listPhoto(image),
                              Image.network(image['url'])
                            ]
                          ),
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listPhoto(final image){
    final isSaved = _loved.contains(image['id']);
    print(_loved);
    return ListTile(
      dense: false,
      title: Text(image['uploaded_by']),
      subtitle: Text(
        image['description'],
        style: TextStyle(color: Colors.black.withOpacity(0.6)),
      ),
      trailing: Icon(
        isSaved ? Icons.favorite : Icons.favorite_border,
        color: isSaved ? Colors.red : null
      ),
      onTap: (){
        setState(() {
          if(isSaved){
            _loved.remove(image['id']);
          }else{
            _loved.add(image['id']);
          }
        });
      },
    );
  }
}