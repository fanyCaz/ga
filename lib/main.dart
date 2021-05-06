import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/localization/gallery_array_localization.dart';
import 'package:gallery_array/pages/application/feed_ex.dart';
import 'package:gallery_array/pages/application/principal.dart';
import 'package:gallery_array/pages/home_page.dart';
import 'package:gallery_array/routes/auth_service.dart';
import 'package:gallery_array/routes/custom_router.dart';
import 'package:gallery_array/routes/route_names.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  static void setLocale(BuildContext context, Locale locale){
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void setLocale(Locale locale){
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then(
      (locale) => setState((){
        this._locale = locale;
      }));
    super.didChangeDependencies();
  }
  //provider no es gestor de estados
//fluter bloc es para gestionar estados
  @override
  Widget build(BuildContext context) {
    if(_locale  == null ){
      return Container(
        child: CircularProgressIndicator(),
      );
    }
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_)=> AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
        )
      ],
      child: MaterialApp(
        title: 'Gallery Array',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        locale: _locale,
        supportedLocales: [
          Locale('es','MX'),
          Locale('en','US'),
          Locale('pt','PT'),
        ],
        localizationsDelegates: [
          GalleryArrayLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (deviceLocale, supportedLocales){
          for(var locale in supportedLocales){
            if(locale.languageCode == deviceLocale.languageCode && locale.countryCode == deviceLocale.countryCode){
              return deviceLocale;
            }
          }
          return supportedLocales.last;
        },
        onGenerateRoute: CustomRouter.allRoutes,
        initialRoute: auth,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if(firebaseUser != null){
      return upFeedPage();
    }
    return HomePage();//debe dirigir a la pantalla principal
  }
}

class Error extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        body: Text('no sepuedoeee'),
      ),
    );
  }
}

class Loading extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:  Container(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}