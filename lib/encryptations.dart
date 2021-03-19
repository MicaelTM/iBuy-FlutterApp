import 'package:flutter_string_encryption/flutter_string_encryption.dart';

class encryptations{
  final keyPssw = "jIkj0VOLhFpOJSpI7SibjA==:RZ03+kGZ/9Di3PT0a3xUDibD6gmb2RIhTVF+mQfZqy0=";
  String encrypted, decrypted;
  final cryptor = new PlatformStringCryptor();

  encryptPassword (String password) async {
    encrypted = await cryptor.encrypt(password, keyPssw);
    return encrypted;
  }

  decryptPassword (String password) async {
    decrypted = await cryptor.decrypt(password, keyPssw);
    return decrypted;
  }
}