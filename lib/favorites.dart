import 'dart:math';

import 'package:flutter/material.dart';


import './database_helper.dart';
import './models/Exhibit.dart';
import './exhibit_details.dart';


class FavoritesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FavoritesPageState();
  }
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Exhibit> favoriteExhibits;

  _read() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    List<Exhibit> exhibits = await helper.queryAllExhibit();
    if (exhibits == null) {
      print('read row empty');
    } else {
      print('read row ${exhibits.length}');
      setState(() {
        favoriteExhibits = exhibits;
      });
    }
  }
  _delete(String nfcId) async{
    DatabaseHelper helper = DatabaseHelper.instance;
    int result = await helper.queryDeleteRow(nfcId);
    if(result>0){
      print('$result row deleted');
    }else{
      print('failed to delete row');
    }
  }

  @override
  initState() {
    super.initState();
    _read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: favoriteExhibits==null ? RaisedButton(child: Text('read'),onPressed: _read,) : SingleChildScrollView(child: Column(
        children: favoriteExhibits.map((e) => Card(
          child: Column(
            children: <Widget>[
              Image.network(e.image),
              Text(e.title),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Үзэх'),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ExhibitDetailsPage(e)),
                      );
                    },
                  ),
                  SizedBox(width: 30,),
                  RaisedButton(
                    child: Text('Хасах'),
                    onPressed: (){
                      _delete(e.nfcId);
                      _read();
                    },
                  )
                ],
              )
            ],
          ),
        )).toList(),
      ),
    ),);
  }
}
