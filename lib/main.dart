import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Qr transfer'),
      ),
      body: Center(
          child: //TalkPage(),)
              ConnectedPage(host: "192.168.1.27:8000")),
    );
  }
}
