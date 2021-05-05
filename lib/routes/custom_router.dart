import 'package:flutter/material.dart';
import 'package:gallery_array/main.dart';
import 'package:gallery_array/pages/about.dart';
import 'package:gallery_array/pages/application/feed_ex.dart';
import 'package:gallery_array/pages/application/principal.dart';
import 'package:gallery_array/pages/application/profile_page.dart';
import 'package:gallery_array/pages/application/upload.dart';
import 'package:gallery_array/pages/choose_profile.dart';
import 'package:gallery_array/pages/home_page.dart';
import 'package:gallery_array/pages/login.dart';
import 'package:gallery_array/pages/not_found.dart';
import 'package:gallery_array/pages/register.dart';
import 'package:gallery_array/pages/settings.dart';
import 'package:gallery_array/pages/shared/upload_animation.dart';
import 'package:gallery_array/routes/route_names.dart';
import 'package:gallery_array/pages/application/edit_profile.dart';

class CustomRouter{
  static Route<dynamic> allRoutes(RouteSettings settings){
    switch(settings.name){
      case auth:
        return MaterialPageRoute(builder: (_) => AuthenticationWrapper());
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case about:
        return MaterialPageRoute(builder: (_) => AboutPage());
      case internal_settings:
        return MaterialPageRoute(builder: (_) => SettingsPage());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case login:
        return MaterialPageRoute(builder: (_) => LogInPage());
      case principal:
        return MaterialPageRoute(builder: (_) => uploadAnimationHome());
      case upload_photo:
        return MaterialPageRoute(builder: (_) => UploadPage());
      case choose_profile:
        return MaterialPageRoute(builder: (_) => ChooseProfilePage());
      case profile_page:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case edit_profile:
        return MaterialPageRoute(builder: (_) => EditProfile());
      case uploadAnimation:
        return MaterialPageRoute(builder: (_) => uploadAnimationHome());
    }
    return MaterialPageRoute(builder: (_) => NotFoundPage());
  }
}