import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';

class Facts extends StatelessWidget {
  Facts({this.text, this.name, this.type, this.date});
  FlutterTts flutterTts;
  final String text;
  final String name;
  final bool type;
  final  String date;

  List<Widget> botMessage(context) {
    return <Widget>[
    ];
  }

  List<Widget> userMessage(context) {
    return <Widget>[
      Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
           Container(
              padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,10.0),
             // color: Colors.blue[300],
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(text, style: TextStyle(fontSize: 20),),
            ),
            Container(
              padding: const EdgeInsets.only(left : 10.0),
              child: Text(date, style: TextStyle(fontSize: 15),),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? userMessage(context) : botMessage(context) ,
      ),
    );
  }
}