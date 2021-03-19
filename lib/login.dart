import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'app_localizations.dart';
import 'authentications.dart';
import 'encryptations.dart';
import 'register.dart';
import 'homepage.dart';

class login extends StatefulWidget {
  @override
  _loginState createState () => _loginState ();
}

class _loginState extends State<login> {

  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;  // Booleano para esconder a password.
  String _emailValue = "";        // Variavel para guardar o email.
  String _psswValue = "";         // Variavel para guardar a password.
  authentications _auth = authentications();
  encryptations _crypt = encryptations();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue,
              Colors.blue[900],
            ],
          ),
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,

          body: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 8.0.h,
                  child: Text('iBuy', style: TextStyle(fontSize: 30.0.sp, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                ),
                _login_form(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget _login_form() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(top: 18.0.h, bottom: 5.0.h, left: 8.8.w, right: 8.8.w),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 5.0.h, bottom: 5.0.h, left: 5.4.h, right: 5.4.h),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 3.2.h),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(AppLocalizations.of(context).translate('login_main_text'), style: TextStyle(fontSize: 16.8.sp, color: Colors.blue[800], fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 2.7.h),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(AppLocalizations.of(context).translate('login_email_text'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                      ),
                      TextFormField(
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return AppLocalizations.of(context).translate('validators');
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {      // Garantir que o utilizador coloca um email válido.
                            return AppLocalizations.of(context).translate('validators_1');
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _emailValue = value;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 3.2.h),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(AppLocalizations.of(context).translate('login_password_text'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                      ),
                      TextFormField(
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'),
                        obscureText: !_passwordVisible,                                                           // Isto vai fazer com que o texto se esconda automaticamente.
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(_passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                              color: Colors.blue[800],
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return AppLocalizations.of(context).translate('validators');
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _psswValue = value;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 3.2.h),
                  child: ButtonTheme(                   // Este wrap com o ButtonTheme a volta do botão serve para tirar um "padding" adicional que tinha por defeito a volta do RaisedButton
                    height: 0,
                    minWidth: 0,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: RaisedButton(
                      onPressed: () async {
                        if (!_formKey.currentState.validate()){
                          return ;
                        } else {
                          _formKey.currentState.save();

                          final result_snapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo:_emailValue).get();
                          final List <DocumentSnapshot> documents = result_snapshot.docs;
                          if (documents.length == 0) {
                            FocusScope.of(context).requestFocus(FocusNode());
                            Fluttertoast.showToast(
                              msg: AppLocalizations.of(context).translate('login_btnToast_loginEmail'),       // Email não está registado!
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.black87,
                              textColor: Colors.white,
                            );
                          } else {
                            Map data = documents.single.data();                         // Como só retorna 1 documento, uso o single para guardar os dados desse documento.
                            String pass = data['password'];                             // Guardo o valor do campo password desse documento.
                            String passDecrypt = await _crypt.decryptPassword(pass);    // Desencriptar a password.
                            if (passDecrypt == _psswValue) {
                              await _auth.signIn(_emailValue, _psswValue);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => homepage()));
                            } else {
                              FocusScope.of(context).requestFocus(FocusNode());
                              Fluttertoast.showToast(
                                msg: AppLocalizations.of(context).translate('login_btnToast_loginEmail'),      // Password inserida pelo utilizador está errada.
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.black87,
                                textColor: Colors.white,
                              );
                            }
                          }
                        }
                      },
                      textColor: Colors.white,
                      shape: StadiumBorder(),
                      padding: EdgeInsets.all(0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue,
                              Colors.blue[900],
                            ],
                          ),
                        ),
                        child: Text(AppLocalizations.of(context).translate('login_btn_loginEmail'), style: TextStyle(fontSize: 12.2.sp, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.center),
                        padding: EdgeInsets.symmetric(horizontal: 4.0.h, vertical: 2.0.h),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 3.2.h),
                  child: ButtonTheme(                   // Este wrap com o ButtonTheme a volta do botão serve para tirar um "padding" adicional que tinha por defeito a volta do RaisedButton
                    height: 0,
                    minWidth: 0,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: RaisedButton(
                      onPressed: () async {
                        Map <String, dynamic> userData = await _auth.signInFacebook();
                        String _firstNameFacebook = userData['first_name'];
                        String _lastNameFacebook = userData['last_name'];
                        String _emailFacebook = userData['email'];
                        final resultSnapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo:_emailFacebook).get();
                        final List <DocumentSnapshot> documents = resultSnapshot.docs;
                        if (documents.length > 0) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => homepage()));
                        } else {
                          await FirebaseFirestore.instance.collection('users').doc(_emailFacebook).set({
                            'first_name': _firstNameFacebook,
                            'last_name': _lastNameFacebook,
                            'email': _emailFacebook,
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context) => homepage()));
                        }
                      },
                      textColor: Colors.white,
                      shape: StadiumBorder(),
                      padding: EdgeInsets.all(0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue,
                              Colors.blue[900],
                            ],
                          ),
                        ),
                        child: Text(AppLocalizations.of(context).translate('login_btn_loginFacebook'), style: TextStyle(fontSize: 12.2.sp, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.center),
                        padding: EdgeInsets.symmetric(horizontal: 4.0.h, vertical: 2.0.h),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 3.2.h),
                  child: Text (AppLocalizations.of(context).translate('login_withoutAccount'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.center),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 0),
                  child: ButtonTheme(                   // Este wrap com o ButtonTheme a volta do botão serve para tirar um "padding" adicional que tinha por defeito a volta do RaisedButton
                    height: 0,
                    minWidth: 0,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => register()));
                      },
                      textColor: Colors.white,
                      shape: StadiumBorder(),
                      padding: EdgeInsets.all(0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue,
                              Colors.blue[900],
                            ],
                          ),
                        ),
                        child: Text(AppLocalizations.of(context).translate('login_btn_SignUp'), style: TextStyle(fontSize: 12.2.sp, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.center),
                        padding: EdgeInsets.symmetric(horizontal: 4.0.h, vertical: 2.0.h),
                      ),
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}