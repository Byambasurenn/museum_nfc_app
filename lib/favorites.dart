import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

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

  _delete(String nfcId) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    int result = await helper.queryDeleteRow(nfcId);
    if (result > 0) {
      print('$result row deleted');
    } else {
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
      appBar: AppBar(
        title: Text('Таалагдсан үзмэрүүд', style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white),),
      ),
      body: Container(
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
        padding: EdgeInsets.all(12),
        child: favoriteExhibits == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : new StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                itemCount: favoriteExhibits.length,
                itemBuilder: (context, index) {
                  return Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: InkWell(
                  onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => ExhibitDetailsPage(favoriteExhibits[index]))
//            MaterialPageRoute(builder: (context) => ImageZoomPage(exhibit.image)),
                  );
                  },
                  child: Stack(
                        children: <Widget>[
                          Container(
                            foregroundDecoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(15)),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: favoriteExhibits[index].image,
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Positioned(
                              top: 20,
                              left: 20,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(
                                  favoriteExhibits[index].title,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'Caslon'),
                                ),
                              )),
                          Positioned(
                            bottom: 0,
                            right: 10,
                            child: ButtonTheme(
                              minWidth: 0,
                              height: 40,
                              child: IconButton(
                                icon: Icon(Icons.favorite),
                                onPressed: () {
                                  _delete(favoriteExhibits[index].nfcId);
                                  _read();
                                },
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),),
                  );
                },
                staggeredTileBuilder: (index) {
                  return new StaggeredTile.count(1, index.isEven ? 1.2 : 1.8);
                }),
      ),
    );
  }
}
