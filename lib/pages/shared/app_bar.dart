import 'package:flutter/material.dart';
import 'package:gallery_array/classes/language.dart';
import 'package:gallery_array/localization/constants.dart';
import 'package:gallery_array/main.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget{
  final String title;
  final AppBar appBar;
  final Widget logout;
  final bool canGoBack;
  final Widget custom;

  const CommonAppBar({@required this.title, @required this.appBar,this.logout = const SizedBox(height: 10.0), this.canGoBack = true, this.custom = const SizedBox(height: 10.0)});

  @override
  _CommonAppBarState createState() => _CommonAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}

class _CommonAppBarState extends State<CommonAppBar> {
  void _changeLanguage(Language language) async {
    Locale _temp = await setLocale(language.languageCode);

    MyApp.setLocale(context, _temp);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: widget.canGoBack,
      backgroundColor: Color(0xFF7B39ED),
      shadowColor: Colors.white,
      title: Text(widget.title, style: TextStyle( color: Colors.white) ),
      actions: [
        widget.custom,
        Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: DropdownButton(
              onChanged: (Language language ){
              _changeLanguage(language);
            },
            underline: SizedBox(),
            icon: Icon(Icons.language, color: Colors.white),
            items: Language.languageList()
            .map<DropdownMenuItem<Language>>((lang) => DropdownMenuItem(
                value: lang,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [ Text(lang.name), Text(lang.flag)],
                )
              )
            ).toList(),
          ),
        ),
        widget.logout,
      ],
    );
  }
}

