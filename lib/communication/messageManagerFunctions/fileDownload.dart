//import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:dio/dio.dart';
//import 'package:file_picker/file_picker.dart';

import 'package:encrypt/encrypt.dart' as encrypt;
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:permission_handler/permission_handler.dart';
import '../messageManager.dart';

Future downloadFile(String url, String ivBase64, String filename) async {
  final MessageManager _messageManager = MessageManager();
  final Dio dio = Dio();
  print('Download.....');
  final Response<List<int>> response = await dio.get<List<int>>(url,
      options: Options(responseType: ResponseType.bytes));
  print('init decryption... ${DateTime.now()}');

  final iv = encrypt.IV.fromBase64(ivBase64);
  final encrypter = encrypt.Encrypter(
      encrypt.AES(_messageManager.key, mode: encrypt.AESMode.cbc));
  print('Starting decryption... ${DateTime.now()}');
  final decrypted =
      encrypter.decryptBytes(encrypt.Encrypted(response.data), iv: iv);
  print('Finished decryption... ${DateTime.now()}');

  saveFile(decrypted, filename);
}

void saveFile(List<int> decrypted, String filename) {
  final blob =
      html.Blob([Uint8List.fromList(decrypted)], 'application/octet-binary');

  // final blob = html.Blob([decrypted]);
  final blobUrl = html.Url.createObjectUrlFromBlob(blob);

  //dio.get(blobUrl);

  html.AnchorElement()
    ..href = blobUrl
    ..download = filename
    ..style.display = 'none'
    ..click();
}
