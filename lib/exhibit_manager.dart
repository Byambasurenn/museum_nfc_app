import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:museumnfcapp/select_language.dart';
import 'package:museumnfcapp/plan.dart';
import 'package:museumnfcapp/contacts.dart';
import 'package:museumnfcapp/main.dart';
import 'package:museumnfcapp/time_table.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';
import './exhibits.dart';
import './exhibit_details.dart';
import './models/Exhibit.dart';
import './favorites.dart';
import 'localizations.dart';

Future<File> file(String filename) async {
  Directory dir = await getApplicationDocumentsDirectory();
  String pathName = p.join(dir.path, filename);
  return File(pathName);
}

class ExhibitManager extends StatefulWidget {
  final String language;
  ExhibitManager(this.language);
  @override
  State<StatefulWidget> createState() {
    return _ExhibitManagerState();
  }
}


class _ExhibitManagerState extends State<ExhibitManager> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  Exhibit mainEx;
  List<Exhibit> mainExList;
  bool responseBack = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    fetchAllExhibit();
    super.initState();
//    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  void fetchExhibit(String nfcId) async {
    final response =
        await http.get('http://08430bc6.ngrok.io/json/exhibits/' + nfcId + '/');
    if (response.statusCode == 200) {
      Exhibit tempEx =
          Exhibit.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      setState(() {
        mainEx = tempEx;
        responseBack = true;
      });
    } else {
      throw Exception('Failed to load exhibit');
    }
  }

  void fetchAllExhibit() async {
    final response =
    await http.get('http://08430bc6.ngrok.io/json/exhibits/');
    if (response.statusCode == 200) {
      List<Exhibit> tempExList = new List();
      Map<String,dynamic> tempJson = json.decode(utf8.decode(response.bodyBytes));
      for(var i = 0; i<tempJson['count']; i++) {
        tempExList.add(Exhibit.fromJson(tempJson['results'][i]));
      }
      setState(() {
        mainExList = tempExList;
        responseBack = true;
      });
    } else {
      throw Exception('Failed to load all exhibits');
    }
  }

  _getCustomAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(40),
      child: Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.orange,
              Colors.redAccent,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0, // has the effect of softening the shadow
              spreadRadius: 2.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                5.0, // vertical, move down 10
              ),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                color: Colors.white,
                icon: Icon(Icons.menu),
                onPressed: (){
                  _scaffoldKey.currentState.openDrawer();
                }),//_scaffoldKey.currentState.openDrawer
            Text(
              AppLocalizations.of(context).titleMuseum,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w300),
            ),
            IconButton(
                color: Colors.white,
                icon: Icon(Icons.favorite),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoritesPage()),
                  );
                }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: (){
//           NfcManager.instance.stopSession();
//           return null;
        },
        child: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
//            Colors.white,
//            Colors.white,
                Colors.grey[900],
                Colors.blue[900]
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        appBar: _getCustomAppBar(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  AppLocalizations.of(context).lblFeatured+'...',
                  style: TextStyle(fontSize: 30, color: Colors.white, fontFamily: 'Cats'),
                ),
              ),
              CarouselSlider(
                height: 400.0,
                items: [1, 2, 3].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: Colors.white
                          ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15)
                            ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0, // has the effect of softening the shadow
                              spreadRadius: 2.0, // has the effect of extending the shadow
                              offset: Offset(
                                10.0, // horizontal, move right 10
                                10.0, // vertical, move down 10
                              ),
                            )
                          ],
                        ),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                foregroundDecoration: BoxDecoration(
                                    color: Colors.black26,
                                borderRadius: BorderRadius.circular(15)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: mainExList==null ? Center(child: CircularProgressIndicator(),) :
                                  CachedNetworkImage(
                                    imageUrl: mainExList[i].image,
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 20,
                                left: 20,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width*0.6,
                                  child: Text(
                                    mainExList==null ? AppLocalizations.of(context).plExhibit :
                                    AppLocalizations.of(context).locale == 'en' ? mainExList[i].titleEn :
                                    mainExList[i].title,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30, fontFamily: 'Caslon'),
                                  ),
                                )
                              ),
                              Positioned(
                                bottom: 0,
                                left: 90,
                                right: 90,
                                child: ButtonTheme(
                                  minWidth: 0,
                                  height: 20,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(15),
                                        side: BorderSide(
                                            color: Colors.blue[900])),
                                    onPressed: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ExhibitDetailsPage(mainExList[i]))
//            MaterialPageRoute(builder: (context) => ImageZoomPage(exhibit.image)),
                                      );
                                    },
                                    color: Theme.of(context).primaryColor,
                                    textColor: Colors.white,
                                    child: Text(
                                      AppLocalizations.of(context).btnRead.toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ));
                    },
                  );
                }).toList(),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  AppLocalizations.of(context).lblPopular+'...',
                  style: TextStyle(fontSize: 30, color: Colors.white, fontFamily: 'Cats'),
                ),
              ),
              CarouselSlider(
                height: 400.0,
                items: [1, 2, 3].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 3,
                                color: Colors.white
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(15)
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10.0, // has the effect of softening the shadow
                                spreadRadius: 2.0, // has the effect of extending the shadow
                                offset: Offset(
                                  10.0, // horizontal, move right 10
                                  10.0, // vertical, move down 10
                                ),
                              )
                            ],
                          ),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                foregroundDecoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(15)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: mainExList==null ? Center(child: CircularProgressIndicator(),) : CachedNetworkImage(
                                    imageUrl: mainExList[mainExList.length-i].image,
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: 20,
                                  left: 20,
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width*0.6,
                                    child: Text(
                                      mainExList==null ? AppLocalizations.of(context).plExhibit :
                                      AppLocalizations.of(context).locale == 'en' ? mainExList[mainExList.length-i].titleEn :
                                      mainExList[mainExList.length-i].title,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 30, fontFamily: 'Caslon'),
                                    ),
                                  )
                              ),
                              Positioned(
                                bottom: 0,
                                left: 90,
                                right: 90,
                                child: ButtonTheme(
                                  minWidth: 0,
                                  height: 20,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        new BorderRadius.circular(15),
                                        side: BorderSide(
                                            color: Colors.blue[900])),
                                    onPressed: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ExhibitDetailsPage(mainExList[i]))
//            MaterialPageRoute(builder: (context) => ImageZoomPage(exhibit.image)),
                                      );
                                    },
                                    color: Theme.of(context).primaryColor,
                                    textColor: Colors.white,
                                    child: Text(
                                      'үзэх'.toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ));
                    },
                  );
                }).toList(),
              )
//            SafeArea(
//              child: FutureBuilder<bool>(
//                future: NfcManager.instance.isAvailable(),
//                builder: (context, ss) => ss.data != true
//                    ? Center(
//                        child: Text('NfcManager.isAvailable(): ${ss.data}'))
//                    : Column(
//                        children: [
////                      Container(
////                        width: 240.0,
////                        height: 18.0,
////                        decoration: BoxDecoration(border: Border.all()),
////                        child: SingleChildScrollView(
////                          child: ValueListenableBuilder<dynamic>(
////                            valueListenable: result,
////                            builder: (context, value, _) =>
////                                Text('${value ?? ''}'),
////                          ),
////                        ),
////                      ),
////                      Exhibits(_exhibits),
//                        ],
//                      ),
//              ),
//            ),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Column(children: <Widget>[
                  Text(AppLocalizations.of(context).titleMuseum, style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white),),
                  SizedBox(height: 10,),
                  Image.asset('assets/launcher/icon.png',width: 100,height: 100,)
                ],),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.orange,
                      Colors.redAccent,
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text(AppLocalizations.of(context).aBFavorite, style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoritesPage()),
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.add_to_home_screen),
                title: Text(AppLocalizations.of(context).btnScanExhibit, style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20),),
                onTap: () {
                  Navigator.pop(context);
                  _tagRead();
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.map),
                title: Text(AppLocalizations.of(context).drwPlan, style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlanPage()),
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text(AppLocalizations.of(context).drwTimeTable, style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TimeTablePage()),
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.contacts),
                title: Text(AppLocalizations.of(context).drwContacts, style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactsPage()),
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.language),
                title: Text(AppLocalizations.of(context).drwSelectLang, style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              Divider(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.transparent,
          child: Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15),
                side: BorderSide(color: Colors.blue[900])),
            onPressed: _tagRead,
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: Text(
              AppLocalizations.of(context).btnScanExhibit,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w300),
            ),
          ),
        ),)
      ),
    ),);
  }

  void _tagRead() {
        child: showDialog(
        context: context,
        child: new AlertDialog(
          backgroundColor: Colors.transparent,
          title: new Text(AppLocalizations.of(context).dScanExhibit, style: TextStyle(color: Colors.white),),
          content: new Image.asset("assets/nfc.gif"),
        ));
    NfcManager.instance.startTagSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data['id']
          .map((element) =>
              element.toRadixString(16).padLeft(2, '0').toUpperCase())
          .join(":");
      String temp = tag.data['id']
          .map((element) =>
              element.toRadixString(16).padLeft(2, '0').toUpperCase())
          .join(":");
      //result.value=tag.data['ndef']['cachedMessage']['records'][0]['payload'].map((element) => String.fromCharCode(element)).join(); //tag.data['ndef']['cachedMessage']['records']  .forEach((element) => String.fromCharCode(element))
      if(temp!=null){
        await fetchExhibit(temp);
      }
      NfcManager.instance.stopSession();
      Navigator.pop(context);

      if (responseBack) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ExhibitDetailsPage(mainEx)),
        );
      }

//      for(var i=0; i<=_exhibits.length; i++){
//        Map<String,String> tempMap = _exhibits[i];
//        if(tempMap['id']==temp){
//          Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => ExhibitDetailsPage(_exhibits[i])),
//          );
//        }
//      }
    });
  }
}
