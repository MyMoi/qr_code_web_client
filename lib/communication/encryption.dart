import 'package:encrypt/encrypt.dart';

/*
void main() {
  print(decrypt('8a117aa0329689a62911c4bcbf6834a0',
      '75b7d73ea05d349e1adc97f4ff2d6327', '7x!A%D*G-JaNdRgUkXp2s5v8y/B?E(H+'));
}
*/
String decrypt(String content, String iv, String key) {
  final encrypter = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.cbc));
  return encrypter.decrypt(Encrypted.fromBase16(content),
      iv: IV.fromBase16(iv));
}

encrypt(String content, Key key) {
  final iv = IV.fromSecureRandom(16);
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  return {
    'content': encrypter.encrypt(content, iv: iv).base16,
    'iv': iv.base16
  };
}

Key getRandomKey() {
  final Key key = Key.fromSecureRandom(256);

  //'7x!A%D*G-JaNdRgUkXp2s5v8y/B?E(H+'); // Key.fromSecureRandom(256);

  //print(decrypt('8a117aa0329689a62911c4bcbf6834a0',      '75b7d73ea05d349e1adc97f4ff2d6327', '7x!A%D*G-JaNdRgUkXp2s5v8y/B?E(H+'));
  //print(encrypt("content", key));
  return key;
}

String getRandomString({int length = 256}) {
  return SecureRandom(length).base64;
}
