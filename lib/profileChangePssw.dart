import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'app_localizations.dart';
import 'authentications.dart';
import 'encryptations.dart';

class profileChangePssw extends StatefulWidget {
  @override
  _profileChangePsswState createState () => _profileChangePsswState ();
}

class _profileChangePsswState extends State<profileChangePssw> {

  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _passwordVisible1 = false;
  String _newPsswValue = "";
  String _confirmNewPsswValue = "";
  String _passDecrypt = "";
  String _fetchEmailAuth = FirebaseAuth.instance.currentUser.email;
  encryptations _crypt = encryptations();
  authentications _auth = authentications();

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
                top: 7.0.h,
                child: Text(AppLocalizations.of(context).translate('profileChangePssw_main_text'), style: TextStyle(fontSize: 16.8.sp, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
              ),
              _changePassword_form(),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget _changePassword_form() {
    return Form(
      key: _formKey,
      child: Container(
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
                          child: Text(AppLocalizations.of(context).translate('profileChangePssw_new_password'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
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
                              return AppLocalizations.of(context).translate('profileChangePssw_password_warning');
                            }
                            return null;
                          },
                          onSaved: (String value) {
                            _newPsswValue = value;
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
                          child: Text(AppLocalizations.of(context).translate('profileChangePssw_confirm_password'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
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
                            _confirmNewPsswValue = value;
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 3.2.h),
                    child: ButtonTheme(
                      height: 0,
                      minWidth: 0,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        textColor: Colors.white,
                        shape: StadiumBorder(),
                        padding: EdgeInsets.all(0),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                          child: Text(AppLocalizations.of(context).translate('profileChangePssw_btn_cancel'), style: TextStyle(fontSize: 12.2.sp, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.center),
                          padding: EdgeInsets.symmetric(horizontal: 4.0.h, vertical: 2.0.h),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 0),
                    child: ButtonTheme(
                      height: 0,
                      minWidth: 0,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: RaisedButton(
                        onPressed: () async {
                          if (!_formKey.currentState.validate()){
                            return ;
                          } else {
                            _formKey.currentState.save();

                            if (_confirmNewPsswValue != _newPsswValue) {
                              Fluttertoast.showToast(
                                msg: AppLocalizations.of(context).translate('profileChangePssw_passwords_match'),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.black87,
                                textColor: Colors.white,
                              );
                              return ;
                            } else {
                              final resultSnapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo:_fetchEmailAuth).get();
                              final List <DocumentSnapshot> documents = resultSnapshot.docs;
                              Map data = documents.single.data();
                              String pass = data['password'];
                              _passDecrypt = await _crypt.decryptPassword(pass);
                              if (_passDecrypt == _newPsswValue) {
                                Fluttertoast.showToast(
                                  msg: AppLocalizations.of(context).translate('profileChangePssw_same_password_as_old'),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.black87,
                                  textColor: Colors.white,
                                );
                              } else {
                                await _auth.signIn(_fetchEmailAuth, _passDecrypt);              // Reautentico o user para garantir a atualização da pass no auth.
                                try{
                                  await FirebaseAuth.instance.currentUser.updatePassword(_newPsswValue);
                                  print ("Atualizou com sucesso!");
                                } catch (e) {
                                  print ("Erro na atualização: $e");
                                }
                                String passEncrypt = await _crypt.encryptPassword(_newPsswValue);
                                await FirebaseFirestore.instance.collection('users').doc(_fetchEmailAuth).update({'password':passEncrypt});
                                await Navigator.pop(context, false);
                                Fluttertoast.showToast(
                                  msg: AppLocalizations.of(context).translate('profileChangePssw_toast_success'),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black87,
                                );
                              }
                            }
                          }
                        },
                        textColor: Colors.white,
                        shape: StadiumBorder(),
                        padding: EdgeInsets.all(0),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                          child: Text(AppLocalizations.of(context).translate('profileChangePssw_btn_save'), style: TextStyle(fontSize: 12.2.sp, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.center),
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
      ),
    );
  }
}