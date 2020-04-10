import 'package:flutter/material.dart';
import './models/Exhibit.dart';

class Exhibits extends StatelessWidget {
  final List<Exhibit> exhibits;
  Exhibits(this.exhibits);
  @override
  Widget build(BuildContext context) {
    return Column(
        children: exhibits
            .map((element) => Card(
                  child: Column(
                    children: <Widget>[
                      Image.asset(element.image),
                      Text(element.title)
                    ],
                  ),
                ))
            .toList(),
      );
  }
}
