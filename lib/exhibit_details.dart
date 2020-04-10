import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:museumnfcapp/models/Exhibit.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'image_zoom.dart';

class ExhibitDetailsPage extends StatefulWidget {
  final Exhibit exhibitStart;
  ExhibitDetailsPage(this.exhibitStart);
  @override
  State<StatefulWidget> createState() {
    return _ExhibitDetailsPageState();
  }
}

class _ExhibitDetailsPageState extends State<ExhibitDetailsPage> {
  static final String path = "lib/exhibit_details.dart";
  final String image = "assets/exhibit/golden_boots.jpg";
  Exhibit exhibit;
  Duration _duration = new Duration();
  Duration _position = new Duration();
  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  bool isPlaying = false;

  @override
  void initState() {
    exhibit = widget.exhibitStart;
    super.initState();
    initPlayer();
  }

  void initPlayer() {
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);

    advancedPlayer.durationHandler = (d) => setState(() {
          _duration = d;
        });

    advancedPlayer.positionHandler = (p) => setState(() {
          _position = p;
        });
  }

  play() {
    audioCache.play('audio/Theme.mp3');
  }

  pause() {
    advancedPlayer.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ImageZoomPage(exhibit.image, exhibit.title))
//            MaterialPageRoute(builder: (context) => ImageZoomPage(exhibit.image)),
              );
        },
        child: Stack(
          children: <Widget>[
            Container(
              foregroundDecoration: BoxDecoration(color: Colors.black26),
              height: 400,
              child: CachedNetworkImage(imageUrl: exhibit.image),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 250),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      exhibit.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      const SizedBox(width: 16.0),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Text(
                          "XX зууны эхэн үе",
                          style: TextStyle(color: Colors.white, fontSize: 13.0),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        color: Colors.white,
                        icon: Icon(Icons.favorite_border),
                        onPressed: () {},
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(32.0),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.star,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      Icon(
                                        Icons.star_border,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ],
                                  ),
                                  Text.rich(
                                    TextSpan(children: [
                                      WidgetSpan(
                                          child: Icon(
                                        Icons.location_on,
                                        size: 16.0,
                                        color: Colors.grey,
                                      )),
                                      TextSpan(text: "Өвлийн ордон")
                                    ]),
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12.0),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30.0),
                        Container(
                          child: isPlaying
                              ? SizedBox(
                                  width: double.infinity,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    color: Theme.of(context).primaryColor,
                                    textColor: Colors.white,
                                    child: Text(
                                      "Зогсоох",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16.0,
                                      horizontal: 32.0,
                                    ),
                                    onPressed: () {
                                      pause();
                                      setState(() {
                                        isPlaying = false;
                                      });
                                    },
                                  ),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    color: Theme.of(context).primaryColor,
                                    textColor: Colors.white,
                                    child: Text(
                                      "Сонсох",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16.0,
                                      horizontal: 32.0,
                                    ),
                                    onPressed: () {
                                      play();
                                      setState(() {
                                        isPlaying = true;
                                      });
                                    },
                                  ),
                                ),
                        ),
                        const SizedBox(height: 30.0),
                        Text(
                          "Тайлбар".toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14.0),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          exhibit.description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  exhibit.nfcId,
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: BottomNavigationBar(
                backgroundColor: Colors.white54,
                elevation: 0,
                selectedItemColor: Colors.black,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.search), title: Text("Хайх")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_border), title: Text("Нэмэх")),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), title: Text("Тохиргоо")),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
