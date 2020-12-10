import 'dart:async';
import 'dart:convert';
//import 'package:encrypt/encrypt.dart';
import 'package:qr_web_client/communication/encryption.dart' as aesCrypt;
//import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/html.dart';

class WebsocketManager {
  static final WebsocketManager _websocketManager =
      WebsocketManager._internal();
  static var _channel;
  static String url;
  static var key;
  static bool isConnected = false;
  factory WebsocketManager() {
    print('WS Start');
    //_websocketManager.init();

    return _websocketManager;
  }

  WebsocketManager._internal();

  init(String _url, _key) async {
    print('WS init2');

    url = _url;
    key = _key; //getKeyFromBase64(_base64Key);

    print('_url : ' + url);
    //print('key : ' + key);

    print('Ws Connect');

    if (isConnected == false) {
      _channel = HtmlWebSocketChannel.connect(_url);
      _channel.stream.listen((message) {
        _receiveMessage(message);
      });
      isConnected = true;
    }
    return _websocketManager;
  }

  _receiveMessage(msg) {
    print(msg);
    _receiveFenEvent.sink.add(msg);
  }

  sendText(text) {
    if (text != "")
      _channel.sink
          .add(_createJsonRequest('newText', aesCrypt.encrypt(text, key)));
  }

  _createJsonRequest(event, body) {
    var request = {'event': event, 'body': body};
    return jsonEncode(request);
  }

  void disconnect() {
    _channel.sink.close(status.goingAway);
    isConnected = false;
    _receiveFenEvent.close();
  }

  final _receiveFenEvent = StreamController<String>.broadcast();

  Stream<String> get receiveTextEventStream =>
      _receiveFenEvent.stream; // return new party id

}
