//import 'dart:html';
import 'dart:async';
import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:qr_web_client/network/websocketManager.dart';
import 'package:qr_web_client/communication/encryption.dart' as aesCrypt;

import 'messageManagerFunctions/fileDownload.dart';
import 'messageManagerFunctions/fileUpload.dart';

class MessageManager {
  static final MessageManager _instance = MessageManager._internal();
  WebsocketManager ws;
  String _wsApiUrl;
  String _fileApiUrl;
  String _room;
  SecretKey _key;
  SecretKeyData _keyData;
  List<String> messageList = [];

  factory MessageManager() => _instance;

  MessageManager._internal() {
    print("New instance of Message Manager");
  }

  Future<String> connectNewRoom(String _wsHost, String _fileHost) async {
    // url = "ws://192.168.1.27:8000";
//        if (room == null) {
    if (_wsApiUrl == null) {
      _room = aesCrypt.getRandomString(length: 32); //.replaceAll('/', 'a');

      _key = await aesCrypt.getRandomKey();
      _keyData = await _key.extract();
      print("3333333333333333333333333");
      _wsApiUrl = _wsHost;
      _fileApiUrl = _fileHost;
      await connectToRoom();
    }
    return Future.value('bob');
  }

  Future<String> connectToRoom(
      [String _wsHost,
      String _fileHost,
      String _roomId,
      String _keyBase64]) async {
    if (_wsHost == null || _keyBase64 == null) {
      print("connection session deja existante");
      print(_wsHost);

      print(_keyBase64);
    } else {
      _key = await aesCrypt.getKeyFromString(keyString: _keyBase64);
      _keyData = await _key.extract();

      print('key : ');
      print(_key);
      _room = _roomId;
      _fileApiUrl = _fileHost;
      _wsApiUrl = _wsHost;
    }

    ws = WebsocketManager(wsApi, _key);
    print('url : ' + wsApi);

    assert(_wsApiUrl != null);
    ws.receiveTextEventStream.listen((message) {
      final decodedMessage = jsonDecode(message);
      print(decodedMessage);
      switch (decodedMessage['event']) {
        case "newText":
          {
            aesCrypt
                .decrypt(
                    decodedMessage['body']['content'].toString(),
                    decodedMessage['body']['iv'].toString(),
                    decodedMessage['body']['mac'].toString(),
                    _key)
                .then((decodedText) {
              messageList.add(decodedText);
              _updateMessageList.sink.add(decodedText);
            });
          }
          break;
        case 'newFile':
          {
            aesCrypt
                .decrypt(
                    decodedMessage['body']['content'].toString(),
                    decodedMessage['body']['iv'].toString(),
                    decodedMessage['body']['mac'].toString(),
                    _key)
                .then((decodedText) {
              messageList.add(decodedText);
              _updateMessageList.sink.add(decodedText);
              final mapDecoded = jsonDecode(decodedText);
              downloadFile(mapDecoded['url'], mapDecoded['iv'],
                  mapDecoded['mac'], mapDecoded['filename']);
            });
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
            aesCrypt
                .decrypt(
                    decodedMessage['body']['content'].toString(),
                    decodedMessage['body']['iv'].toString(),
                    decodedMessage['body']['mac'].toString(),
                    _key)
                .then((decodedBody) {
              final roomObject = jsonDecode(decodedBody);
              //print('url = ' + roomObject['url']);
              //print('key = ' + roomObject['key']);
              disconnect();

              connectToRoom(roomObject['wsHost'], roomObject['fileHost'],
                      roomObject['room'], roomObject['key'])
                  .then((value) => _systemEvent.sink.add('connected'));
            });
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
    _key = null;
    _keyData = null;
    _wsApiUrl = null;
  }

  sendText(text) async {
    if (text != "")
      ws.sendWs(
          _createJsonRequest('newText', await aesCrypt.encrypt(text, _key)));
  }

  _createJsonRequest(event, body) {
    var request = {'event': event, 'body': body};
    return jsonEncode(request);
  }

  Future sendFile() async {
    uploadFile().then((value) async {
      ws.sendWs(_createJsonRequest(
          'newFile',
          await aesCrypt.encrypt(
              jsonEncode({
                'url': (fileDownloadApi + '/' + value['name']),
                'iv': value['iv'],
                'mac': value['mac'],
                'filename': value['originFilename']
              }),
              _key)));
    });
  }

  final _updateMessageList = StreamController<String>.broadcast();

  Stream<String> get updateMessageListStream =>
      _updateMessageList.stream; // return new party id

  final _systemEvent = StreamController<String>.broadcast();

  Stream<String> get systemEventStream =>
      _systemEvent.stream; // return new party id

  get wsApi => (_wsApiUrl + '/' + _room);
  get key => _key;
  get fileApiUrl => _fileApiUrl;
  get fileUploadApi => (_fileApiUrl + '/upload/' + _room);
  get fileDownloadApi => (_fileApiUrl + '/download/' + _room);

  get room => _room;
  get keyData => _keyData;
}
