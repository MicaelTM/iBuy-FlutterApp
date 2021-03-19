import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class authentications {
  UserCredential result;

  // Login com email e password //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future signUp(String email, String password) async {
    try {
      result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('Erro ao criar a conta: ' + e.toString());
    }
    return result;
  }
  Future signIn(String email, String password) async {
    try {
      result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    }
    catch (e) {
      print('Erro no login: ' + e.toString());
    }
    return result;
  }
  Future signOut() async {
    try {
      return await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('Erro ao sair da conta: ' + e.toString());
    }
  }

  // Login com facebook //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future <Map<String, dynamic>> signInFacebook () async {
    try {
      AccessToken accessToken = await FacebookAuth.instance.login();
      Map userData = await FacebookAuth.instance.getUserData(fields: 'first_name,last_name,email');
      AuthCredential credential = FacebookAuthProvider.credential(accessToken.token);
      await FirebaseAuth.instance.signInWithCredential(credential);
      return userData;
    } on FacebookAuthException catch (e) {
      switch (e.errorCode) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          print('Operação em progresso: ' + e.toString());
          break;
        case FacebookAuthErrorCode.CANCELLED:
          print('Operação cancelada: ' + e.toString());
          break;
        case FacebookAuthErrorCode.FAILED:
          print('Operação falhou: ' + e.toString());
          break;
      }
    }
  }

  Future signOutFacebook () async {
    try {
      return FacebookAuth.instance.logOut();
    } catch (e) {
      print('Erro ao sair da conta com o Facebook: ' + e.toString());
    }
  }
}