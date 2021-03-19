import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'app_localizations.dart';
import 'authentications.dart';
import 'encryptations.dart';
import 'homepage.dart';

class register extends StatefulWidget {
  @override
  _registerState createState () => _registerState ();
}

class _registerState extends State<register> {

  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _passwordVisible1 = false;
  String _firstName = "";
  String _lastName = "";
  String _emailValue = "";
  String _psswValue = "";
  String _confirmPsswValue = "";
  authentications _auth = authentications();
  encryptations _crypt = encryptations();

  @override
  Widget build(BuildContext context) {
    return Container(
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
                child: Text(AppLocalizations.of(context).translate('register_main_text'), style: TextStyle(fontSize: 16.8.sp, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
              ),
              _register_form(),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget _register_form() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(top: 15.0.h, bottom: 5.0.h, left: 8.8.w, right: 8.8.w),
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
                  padding: EdgeInsets.only(bottom: 2.7.h),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(AppLocalizations.of(context).translate('register_first_name'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                      ),
                      TextFormField(
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return AppLocalizations.of(context).translate('validators');
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _firstName = value;
                        },
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
                        child: Text(AppLocalizations.of(context).translate('register_last_name'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                      ),
                      TextFormField(
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return AppLocalizations.of(context).translate('validators');
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          _lastName = value;
                        },
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
                        child: Text(AppLocalizations.of(context).translate('register_email'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                      ),
                      TextFormField(
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return AppLocalizations.of(context).translate('validators');
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
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
                  padding: EdgeInsets.only(bottom: 2.7.h),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(AppLocalizations.of(context).translate('register_password'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                      ),
                      TextFormField(
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'),
                        obscureText: !_passwordVisible,
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
                          if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*(),.?\/:{}|<>]).{8,}$').hasMatch(value)) {
                            return AppLocalizations.of(context).translate('register_password_warning');
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
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(AppLocalizations.of(context).translate('register_password_confirmation'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                      ),
                      TextFormField(
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'),
                        obscureText: !_passwordVisible1,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(_passwordVisible1
                                ? Icons.visibility
                                : Icons.visibility_off,
                              color: Colors.blue[800],
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible1 = !_passwordVisible1;
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
                          _confirmPsswValue = value;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 3.2.h),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(text: AppLocalizations.of(context).translate('register_textSpan_1'), style: TextStyle(fontSize: 10.7.sp, color: Colors.black87, fontFamily: 'Comfortaa')),
                        TextSpan(text: AppLocalizations.of(context).translate('register_textSpan_2'), style: TextStyle(fontSize: 10.7.sp, color: Colors.blue, fontFamily: 'Comfortaa', decoration: TextDecoration.underline), recognizer: TapGestureRecognizer()..onTap=(){
                          print('Carregou nas politicas de privacidade!');
                        }),
                        TextSpan(text: AppLocalizations.of(context).translate('register_textSpan_3'), style: TextStyle(fontSize: 10.7.sp, color: Colors.black87, fontFamily: 'Comfortaa')),
                        TextSpan(text: AppLocalizations.of(context).translate('register_textSpan_4'), style: TextStyle(fontSize: 10.7.sp, color: Colors.blue, fontFamily: 'Comfortaa', decoration: TextDecoration.underline), recognizer: TapGestureRecognizer()..onTap=(){
                          print('Carregou nos termos de utilização!');
                        }),
                        TextSpan(text: AppLocalizations.of(context).translate('register_textSpan_5'), style: TextStyle(fontSize: 10.7.sp, color: Colors.black87, fontFamily: 'Comfortaa')),
                      ]
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 0),
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

                          if (_confirmPsswValue != _psswValue) {
                            Fluttertoast.showToast(
                              msg: AppLocalizations.of(context).translate('register_passwords_match'),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.black87,
                              textColor: Colors.white,
                            );
                            return ;
                          } else {
                            final result_snapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo:_emailValue).get();
                            final List <DocumentSnapshot> documents = result_snapshot.docs;
                            if (documents.length > 0) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              Fluttertoast.showToast(
                                msg: AppLocalizations.of(context).translate('register_email_exists'),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.black87,
                                textColor: Colors.white,
                              );
                            } else {
                              await _auth.signUp(_emailValue, _psswValue);                            // Passar os valores do email e pass que o utilizador inseriu para o método signUp.
                              String passEncrypt = await _crypt.encryptPassword(_psswValue);          // Passar a password para ser encriptada e guardar numa variavel.
                              await FirebaseFirestore.instance.collection('users').doc(_emailValue).set({
                                'first_name': _firstName,
                                'last_name': _lastName,
                                'email': _emailValue,
                                'password': passEncrypt,
                              });
                              Navigator.push(context, MaterialPageRoute(builder: (context) => homepage()));
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
                        child: Text(AppLocalizations.of(context).translate('register_confirmation'), style: TextStyle(fontSize: 12.2.sp, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.center),
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