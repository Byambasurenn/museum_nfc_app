import 'package:flutter/material.dart';
import 'package:museumnfcapp/localizations.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:museumnfcapp/LocaleHelper.dart';
import './exhibit_manager.dart';

class SelectLanguagePage extends StatefulWidget {
  SelectLanguagePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _SelectLanguagePageState createState() => _SelectLanguagePageState();
}

class _SelectLanguagePageState extends State<SelectLanguagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).drwSelectLang),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50,),
            SizedBox(
              height: 250,
              child: Image.asset('assets/launcher/icon.png'),
            ),
            SizedBox(height: 50,),
            ButtonTheme(
              buttonColor: Theme.of(context).primaryColor,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)),
                child: Text('Монгол', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300)),
                onPressed: () {
                  this.setState(() {
                    helper.onLocaleChanged(new Locale("mn"));
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExhibitManager("mn"),
                      ));
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'эсвэл',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            ButtonTheme(
              child: RaisedButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Theme.of(context).primaryColor)),
                child: Text(
                  'English',
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w300
                  ),
                ),
                onPressed: () {
                  this.setState(() {
                    helper.onLocaleChanged(new Locale("en"));
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExhibitManager("en"),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
