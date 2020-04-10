import 'package:flutter/material.dart';
import 'package:museumnfcapp/main.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import './exhibits.dart';
import './exhibit_details.dart';
import './models/Exhibit.dart';



class ExhibitManager extends StatefulWidget {
  final List<Exhibit> startingExhibits;

  ExhibitManager(this.startingExhibits);

  @override
  State<StatefulWidget> createState() {
    return _ExhibitManagerState();
  }
}

class _ExhibitManagerState extends State<ExhibitManager> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  List<Exhibit> _exhibits = [];
  Exhibit mainEx;
  bool responseBack=false;

  @override
  void initState() {
    _exhibits = widget.startingExhibits;
    super.initState();

  }
  void fetchExhibit(String nfcId) async {
    final response =
    await http.get('http://66a04f9e.ngrok.io/json/exhibits/'+nfcId+'/');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Exhibit tempEx =  Exhibit.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      setState(() {
        mainEx = tempEx;
        responseBack = true;
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load exhibit');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          child: FutureBuilder<bool>(
            future: NfcManager.instance.isAvailable(),
            builder: (context, ss) => ss.data != true
                ? Center(child: Text('NfcManager.isAvailable(): ${ss.data}'))
                : Column(
                    children: [
                      Container(
                        width: 240.0,
                        height: 240.0,
                        decoration: BoxDecoration(border: Border.all()),
                        child: SingleChildScrollView(
                          child: ValueListenableBuilder<dynamic>(
                            valueListenable: result,
                            builder: (context, value, _) =>
                                Text('${value ?? ''}'),
                          ),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.all(10.0),
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          onPressed: _tagRead,
                          child: Text('Үзмэр унших'),
                        ),
                      ),
                      Exhibits(_exhibits),
                    ],
                  ),

          ),
        ),
      ],
    );
  }

  void _tagRead() {
    showDialog(context: context, child:
      new AlertDialog(
        title: new Text("Үзмэр уншуулна уу"),
        content: new Image.asset("assets/nfc.gif"),
      )
    );
    NfcManager.instance.startTagSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data['id'].map((element)=> element.toRadixString(16).padLeft(2, '0').toUpperCase()).join(":");
      String temp = tag.data['id'].map((element)=> element.toRadixString(16).padLeft(2, '0').toUpperCase()).join(":");
      //result.value=tag.data['ndef']['cachedMessage']['records'][0]['payload'].map((element) => String.fromCharCode(element)).join(); //tag.data['ndef']['cachedMessage']['records']  .forEach((element) => String.fromCharCode(element))
      await fetchExhibit(temp);
      NfcManager.instance.stopSession();
      Navigator.pop(context);

      if(responseBack){
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
