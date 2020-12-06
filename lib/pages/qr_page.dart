import 'dart:convert';

import 'package:qr_web_client/communication/encryption.dart' as aesCrypt;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_web_client/network/websocketManager.dart';

class ConnectedPage extends StatefulWidget {
  final String host;

  ConnectedPage(this.host);

  @override
  State<StatefulWidget> createState() => ConnectedPageState();
}

class ConnectedPageState extends State<ConnectedPage> {
  String qrText = '';
  bool isTextEmpty = true;
  TextEditingController _controller;
  var ws;
  var key;
  String room;
  String url;

  void initState() {
    super.initState();
    _controller = TextEditingController();
    //url = "ws://192.168.1.27:8000";
    if (room == null) {
      //room = aesCrypt.getRandomString(length: 32);
      //key = aesCrypt.getRandomKey();
      //keyBase64 = cKey.base64();
      url = 'ws://' + widget.host + '/' + room;

      ws = WebsocketManager();
      ws.init(url, Key);
      print('url : ' + url);

      ws.receiveTextEventStream.listen((message) {
        print(
            '#~#~#~#~#~#~#~#~#~#~#~#~#~#~##~#~#~#~#~#~#~#~#~#~#~#~#~#~#stream#~#~#~#~#~#~#~#~#~#~#~#~#~#~##~#~#~#~#~#~#~#~#~#~#~#~#~#~#');
      });
    }
  }

  void dispose() {
    _controller.dispose();
    ws.disconnect();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: //Center(        child:
          Center(
              /*child: '' == null
                  ? QrImage(
                      data: jsonEncode(
                          {'host': widget.host, 'room': room, 'key': ''}),
                      version: QrVersions.auto,
                      size: 500.0,
                    )
                  : */
              child: CircularProgressIndicator()),
      //),
    );
  }
}
