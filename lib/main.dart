import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:museumnfcapp/localizations.dart';
import 'package:museumnfcapp/LocaleHelper.dart';

import './select_language.dart';
import 'localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {

  SpecificLocalizationDelegate _specificLocalizationDelegate;

  @override
  void initState() {
    super.initState();
    helper.onLocaleChanged = onLocaleChange;
    _specificLocalizationDelegate = SpecificLocalizationDelegate(new Locale("mn"));
  }
  
  onLocaleChange(Locale locale){
    setState(() {
      _specificLocalizationDelegate = new SpecificLocalizationDelegate(locale);
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Museum',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        new FallbackCupertinoLocalisationsDelegate(),
        //app-specific localization
        _specificLocalizationDelegate
      ],

      supportedLocales: [Locale('en'), Locale('mn')],
      locale: _specificLocalizationDelegate.overriddenLocale,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.orange,
        accentColor: Colors.orangeAccent,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
//      SelectLanguagePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage( {Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(AppLocalizations.of(context).title),
          actions: <Widget>[
            new FlatButton(
              child: new Text("English"), color: AppLocalizations.of(context).locale == "en" ? Colors.grey : Colors.blue, onPressed: (){
              this.setState((){
                helper.onLocaleChanged(new Locale("en"));
              });
            },
            ),

            new FlatButton(
              child: Text("Монгол"),color:  AppLocalizations.of(context).locale == "mn" ? Colors.grey : Colors.blue,onPressed: (){
              this.setState((){
                helper.onLocaleChanged(new Locale("mn"));
              });
            },
            )
          ],

        ),
        body: new Form(
          key: _formKey,
          child: new SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 24.0),
                new TextFormField(
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    filled: true,
                    icon: const Icon(Icons.person),
                    hintText: '',
                    labelText: AppLocalizations.of(context).lblname,
                  ),
                  onSaved: (String value) {},
                ),
                const SizedBox(height: 24.0),
                new TextFormField(
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    filled: true,
                    icon: const Icon(Icons.phone),
                    hintText: '',
                    labelText: AppLocalizations.of(context).lblphone,
                    prefixText: '',
                  ),
                  keyboardType: TextInputType.phone,
                  onSaved: (String value) {},
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: 24.0),
                new TextFormField(
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    filled: true,
                    icon: const Icon(Icons.email),
                    labelText: AppLocalizations.of(context).lblemail,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (String value) {},
                ),
                const SizedBox(height: 24.0),
                const SizedBox(height: 24.0),
                new Center(
                  child: new RaisedButton(
                    child:  Text(AppLocalizations.of(context).btnsubmit),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ));
  }
}