//import 'dart:convert';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'dart:io';

import 'dart:typed_data';

//import 'package:dio/dio.dart';
import 'package:qr_web_client/communication/encryption.dart';
//import 'package:file_picker/file_picker.dart';

//import 'package:encrypt/encrypt.dart' as encrypt;
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:permission_handler/permission_handler.dart';
import '../messageManager.dart';
//import 'package:cryptography/cryptography.dart';

Future downloadFile(
    String url, String ivBase64, String macBase64, String filename) async {
  final MessageManager _messageManager = MessageManager();
  //final Dio dio = Dio();
  print('Download.....');
  //final Response<List<int>> response = await
/*
  dio
      .get<List<int>>(url, options: Options(responseType: ResponseType.bytes))
      .then((response) {
  });
  */
  http.get(Uri.parse(url)).then((response) {
    print('init decryption... ${DateTime.now()}');

    print('Starting decryption... ${DateTime.now()}');

    decryptFile(response.bodyBytes, ivBase64, macBase64, _messageManager.key)
        .then((decrypted) => {
              print('Finished decryption... ${DateTime.now()}'),
              saveFile(decrypted, filename),
            });
  });
}

void saveFile(List<int> decrypted, String filename) {
  print('Starting Blob Creation... ${DateTime.now()}');
  final blob =
      html.Blob([Uint8List.fromList(decrypted)], 'application/octet-binary');
  print('Finished Blob Creation... ${DateTime.now()}');

  // final blob = html.Blob([decrypted]);
  print('Starting BlobToUrl... ${DateTime.now()}');
  final blobUrl = html.Url.createObjectUrlFromBlob(blob);
  print('Finished BlobToUrl... ${DateTime.now()}');
  //dio.get(blobUrl);

  html.AnchorElement()
    ..href = blobUrl
    ..download = filename
    ..style.display = 'none'
    ..click();
}
