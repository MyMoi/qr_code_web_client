import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_web_client/pages/talk_page.dart';

import 'pages/qr_page.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: MyApp(),
    theme: ThemeData(
      brightness: Brightness.dark,
      //primarySwatch: Colors.orange,
    ),
  ));
}

class MyApp extends StatelessWidget {
// decode our json
//final json = jsonDecode(contents);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Qr transfer'),
        ),
        body: Center(
          child: //TalkPage(),)
              FutureBuilder(
            future: rootBundle.loadString('assets/config.json'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ConnectedPage(host: jsonDecode(snapshot.data)["apiUrl"]);
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ));
  }
}
