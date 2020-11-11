import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

import 'dialog_flow.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      
      title: 'Attune voice assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blue,
      ),
      home: FlutterFactsChatBot(),
    );
  }
}