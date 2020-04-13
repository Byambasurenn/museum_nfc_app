import 'package:flutter/material.dart';
import './database_helper.dart';
import './models/Exhibit.dart';

class FavoritesPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _FavoritesPageState();
  }
}
class _FavoritesPageState extends State<FavoritesPage>{
  Exhibit FavoriteExhibit;

  _read() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int rowId = 1;
    Exhibit exhibit = await helper.queryExhibit(rowId);
    if (exhibit == null) {
      print('read row $rowId: empty');
    } else {
      print('read row $rowId: ${exhibit.nfcId}');
      setState(() {
        FavoriteExhibit = exhibit;
      });
    }
  }

  @override
  void initState() {
    _read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(FavoriteExhibit.nfcId),),
    );
  }
}