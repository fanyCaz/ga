import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gallery_array/classes/ga_user.dart';
import 'package:gallery_array/classes/photo.dart';
import 'package:gallery_array/classes/post.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/pages/home_page.dart';
import 'package:gallery_array/pages/shared/app_bar.dart';
import 'package:gallery_array/pages/shared/drawer.dart';
import 'package:gallery_array/routes/auth_service.dart';
import 'package:gallery_array/routes/route_names.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

enum FeedState{
  havePosts,
  doesntHavePosts,
  loading
}

class upFeedPage extends StatefulWidget {
  @override
  _upFeedPageState createState() => _upFeedPageState();
}

class _upFeedPageState extends State<upFeedPage> {

  String usernameNow = "";

  FirebaseStorage storage = FirebaseStorage.instance;
  FeedState _currentState = FeedState.loading;

  int veces = 0;
  List<Post> current_posts = new List<Post>();
  List<String> liked_posts = new List<String>();
  void getCurrentPosts(String firebaseUid) async {
    GAUser hola;
    //await context.read<AuthenticationService>().getCurrentUser().then((value) => hola = value );
    current_posts = await context.read<AuthenticationService>().getImagesFeed();
    current_posts.sort((a,b) => b.date.compareTo(a.date));
    liked_posts = await context.read<AuthenticationService>().pastLikedPosts(firebaseUid);
    setState(() {
      _currentState = (current_posts != null) ? FeedState.havePosts : FeedState.doesntHavePosts;
      veces = 1;
    });
  }

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
    if(veces == 0){
      getCurrentPosts(firebaseUser.uid);
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
        ),
        custom: IconButton(
          onPressed: (){
            Navigator.pop(context);
            Navigator.pushNamed(context, upload_photo);
          },
          color: Colors.white,
          icon: Icon(Icons.file_upload)
        ),
      ),
      drawer: DrawerList(),
      body: (_currentState == FeedState.loading) ? Center(
        child: CircularProgressIndicator(),
      ) :
      Padding(
        padding: const EdgeInsets.all(20),
        child: (_currentState == FeedState.doesntHavePosts) ?
        Column(
          children: [
            Text(getTransValue(context, 'no-posts'))
          ],
        ): ListView.builder(
            itemCount: current_posts.length,
            itemBuilder: (context, index) {
              return Card(
                color: Color(0xffe3d5eb),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                ),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    _listPhoto(current_posts[index], firebaseUser.uid),
                    Image.network(current_posts[index].image),
                    _footerPhoto(context,current_posts[index].uid, firebaseUser.uid),
                  ]
                ),
              );
            },
          ),
        )
      );
  }

  Widget _listPhoto(Post minipost, String currentUser){
    bool _isLiked = liked_posts.contains(minipost.id);
    return ListTile(
      dense: false,
      title: Text(minipost.username),
      subtitle: Text(minipost.description,
        style: TextStyle(color: Colors.black.withOpacity(0.6)),
      ),
      trailing: Icon(
        (_isLiked) ? Icons.favorite : Icons.favorite_border,
        color:Colors.red,
      ),
      onTap: (){
        if(liked_posts.contains(minipost.id)){
          liked_posts.remove(minipost.id);
          changeLikesPosts(minipost.id, currentUser, false);
        }else{
          changeLikesPosts(minipost.id, currentUser, true);
          liked_posts.add(minipost.id);
        }
        setState(() {
        });
      },
    );
  }

  Widget _footerPhoto(BuildContext context, String userId, String currentUser){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ElevatedButton.icon(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
            ),
            icon: (currentUser != userId) ? Icon(Icons.forward_to_inbox) : null,
            label: Text(getTransValue(context, 'send-msg')),
            onPressed: (){
              print("send");
            },
          )
        ],
      ),
    );
  }

  void changeLikesPosts(String id, String currentUser, bool added) async {
    print(liked_posts.contains(id));
    context.read<AuthenticationService>().saveLikedPost(id, currentUser, added);
  }
}