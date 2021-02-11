//import 'dart:html';
import 'dart:async';
import 'dart:convert';

import 'package:qr_web_client/network/websocketManager.dart';
import 'package:qr_web_client/communication/encryption.dart' as aesCrypt;

class MessageManager {
  static final MessageManager _instance = MessageManager._internal();
  WebsocketManager ws;
  String url;
  String room;
  var key;
  List<String> messageList = [];

  factory MessageManager() => _instance;

  MessageManager._internal() {
    print("New instance of Message Manager");
  }

  Future<String> connectNewRoom(String _url) {
    // url = "ws://192.168.1.27:8000";
//        if (room == null) {
    if (url == null) {
      room = aesCrypt.getRandomString(length: 32); //.replaceAll('/', 'a');

      key = aesCrypt.getRandomKey();
      url = _url + '/' + room;
      connectToRoom();
    }
    return Future.value('bob');
  }

  Future<String> connectToRoom([String _url, String _keyBase64]) {
    if (_url == null || _keyBase64 == null) {
      print("connection session deja existante");
      print(_url);

      print(_keyBase64);
    } else {
      key = aesCrypt.getKeyFromString(keyString: _keyBase64);
      print('key : ');
      print(key);
      url = _url;
    }
    ws = WebsocketManager(url, key);
    print('url : ' + url);

    assert(url != null);
    ws.receiveTextEventStream.listen((message) {
      final decodedMessage = jsonDecode(message);
      print(decodedMessage);
      switch (decodedMessage['event']) {
        case "newText":
          {
            String decodedText = aesCrypt.decrypt(
                decodedMessage['body']['content'].toString(),
                decodedMessage['body']['iv'].toString(),
                key);
            messageList.add(decodedText);
            _updateMessageList.sink.add(decodedText);
          }
          break;

        case "deviceConnected":
          {
            _systemEvent.sink.add('newConnection');
            print("device connected");
          }
          break;

        case "connectSession":
          {
            final String decodedBody = aesCrypt.decrypt(
                decodedMessage['body']['content'].toString(),
                decodedMessage['body']['iv'].toString(),
                key);

            final roomObject = jsonDecode(decodedBody);
            print('url = ' + roomObject['url']);
            print('key = ' + roomObject['key']);
            disconnect();
            connectToRoom(roomObject['url'], roomObject['key'])
                .then((value) => _systemEvent.sink.add('connected'));
          }
          break;

        default:
          {
            print("Invalid event");
            print(decodedMessage['event']);
          }
          break;
      }
    });

    return Future.value('bob');
  }

  void disconnect() {
    print("mam disconnected;");
    ws.disconnect();
    // _updateMessageList.close();
    // _systemEvent.close();
    ws = null;
    key = null;
    url = null;
  }

  sendText(text) {
    if (text != "")
      ws.sendWs(_createJsonRequest('newText', aesCrypt.encrypt(text, key)));
  }

  _createJsonRequest(event, body) {
    var request = {'event': event, 'body': body};
    return jsonEncode(request);
  }

  final _updateMessageList = StreamController<String>.broadcast();

  Stream<String> get updateMessageListStream =>
      _updateMessageList.stream; // return new party id

  final _systemEvent = StreamController<String>.broadcast();

  Stream<String> get systemEventStream =>
      _systemEvent.stream; // return new party id

}
