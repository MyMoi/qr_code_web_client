import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_web_client/communication/messageManager.dart';
import 'package:qr_web_client/pages/talk_page.dart';

class ConnectedPage extends StatefulWidget {
  final String host;

  ConnectedPage({Key key, @required this.host}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ConnectedPageState();
}

class ConnectedPageState extends State<ConnectedPage> {
  bool isTextEmpty = true;
  TextEditingController _controller;
  MessageManager messageManager = MessageManager();
  var key;
  String room;
  String url;

  void initState() {
    super.initState();
    print(messageManager);
    messageManager.systemEventStream.listen((message) {
      print(message);
      print("abc");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TalkPage()),
      );
    });
    //messageManager.connect('ws://' + widget.host).then((value) => print(value));
    url = '';
    print('initState.');
  }

  void dispose() {
    _controller.dispose();
    // ws.disconnect();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      Center(
        child: FutureBuilder(
            future: messageManager.connect('ws://' + widget.host),
            builder: (context, snapshot) {
              print("future");
              print(messageManager.key);
              if (snapshot.hasData) {
                return QrImage(
                  data: jsonEncode({
                    'host': widget.host,
                    'room': messageManager.room,
                    'key': messageManager.key.base64
                  }),
                  version: QrVersions.auto,
                  size: 500.0,
                  backgroundColor: Colors.white,
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    ]));
  }
}
