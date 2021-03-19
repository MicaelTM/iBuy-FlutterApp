import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'app_localizations.dart';

class profileEdit extends StatefulWidget {
  final String FirstName;
  final String LastName;

  @override
  _profileEditState createState () => _profileEditState ();

  profileEdit({Key key, @required this.FirstName, @required this.LastName});
}

class _profileEditState extends State<profileEdit> {

  final _formKey = GlobalKey<FormState>();
  String _firstName = "";
  String _lastName = "";
  String _fetchEmailAuth = FirebaseAuth.instance.currentUser.email;

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
                child: Text(AppLocalizations.of(context).translate('profileEdit_main_text'), style: TextStyle(fontSize: 16.8.sp, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
              ),
              _profileEditForm(),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget _profileEditForm() {
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
                        child: Text(AppLocalizations.of(context).translate('profileEdit_first_name'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                      ),
                      TextFormField(
                        initialValue: widget.FirstName,
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
                  padding: EdgeInsets.only(bottom: 3.2.h),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(AppLocalizations.of(context).translate('profileEdit_last_name'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                      ),
                      TextFormField(
                        initialValue: widget.LastName,
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
                        child: Text(AppLocalizations.of(context).translate('profileEdit_btn_cancel'), style: TextStyle(fontSize: 12.2.sp, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.center),
                        padding: EdgeInsets.symmetric(horizontal: 4.0.h, vertical: 2.0.h),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0),
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
                          await FirebaseFirestore.instance.collection('users').doc(_fetchEmailAuth).update({'first_name':_firstName, 'last_name':_lastName});
                          await Navigator.pop(context, false);
                          Fluttertoast.showToast(
                            msg: AppLocalizations.of(context).translate('profileEdit_toast_success'),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.white,
                            textColor: Colors.black87,
                          );
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
                        child: Text(AppLocalizations.of(context).translate('profileEdit_btn_save'), style: TextStyle(fontSize: 12.2.sp, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.center),
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