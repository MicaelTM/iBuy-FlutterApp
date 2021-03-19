import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'app_localizations.dart';
import 'profileChangePssw.dart';
import 'profileEdit.dart';

class profile extends StatefulWidget {
  @override
  _profileState createState () => _profileState ();
}

class _profileState extends State<profile> {

  String _fetchEmailAuth = FirebaseAuth.instance.currentUser.email;
  AccessToken imLoggedWithFB;

  @override
  void initState() {
    super.initState();
    access();
  }

  void access () async{
    imLoggedWithFB = await FacebookAuth.instance.isLogged;
  }

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

        body: Stack(
          alignment: Alignment.center,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').where('email', isEqualTo:_fetchEmailAuth).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 5.0.h,
                    width: 5.0.h,
                    margin: EdgeInsets.all(5.0.h),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.black38),
                    ),
                  );
                } else {
                  if (snapshot.connectionState == ConnectionState.none) {
                    return Container(
                      width: 100.0.w,
                      margin: EdgeInsets.all(5.0.h),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding (
                        padding: EdgeInsets.only(top: 2.0.h, bottom: 2.0.h, left: 2.0.h, right: 2.0.h),
                        child: Text(AppLocalizations.of(context).translate('streamBuilder_if_none'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black38, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.center),
                      ),
                    );
                  } else {
                    if (snapshot.data.size == 0) {
                      return Container(
                        width: 100.0.w,
                        margin: EdgeInsets.all(5.0.h),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding (
                          padding: EdgeInsets.only(top: 2.0.h, bottom: 2.0.h, left: 2.0.h, right: 2.0.h),
                          child: Text(AppLocalizations.of(context).translate('streamBuilder_if_none'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black38, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.center),
                        ),
                      );
                    } else {
                      return profileList(snapshot.data);
                    }
                  }
                }
              }
            ),
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget profileList(QuerySnapshot snapshot) {
    return ListView.builder(
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        final doc = snapshot.docs[index];
        String _firstName = doc['first_name'];
        String _lastName = doc['last_name'];
        String _email = doc['email'];
        return Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 3.8.h),
                child: Text(AppLocalizations.of(context).translate('profile_main_text'), style: TextStyle(fontSize: 16.8.sp, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.2.h, bottom: 5.0.h, left: 8.8.w, right: 8.8.w),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 3.2.h, bottom: 5.0.h, left: 3.6.h, right: 3.6.h),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.0.h),
                        child: ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(bottom: 1.5.h),
                            child: Text(AppLocalizations.of(context).translate('profile_first_name'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                          ),
                          subtitle: Text(_firstName, style: TextStyle(fontSize: 12.2.sp, color: Colors.black87, fontFamily: 'Comfortaa')),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.0.h),
                        child: ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(bottom: 1.5.h),
                            child: Text(AppLocalizations.of(context).translate('profile_last_name'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                          ),
                          subtitle: Text(_lastName, style: TextStyle(fontSize: 12.2.sp, color: Colors.black87, fontFamily: 'Comfortaa')),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 0),
                        child: ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(bottom: 1.5.h),
                            child: Text(AppLocalizations.of(context).translate('profile_email'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                          ),
                          subtitle: Text(_email, style: TextStyle(fontSize: 12.2.sp, color: Colors.black87, fontFamily: 'Comfortaa')),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.7.h),
                        child: ButtonTheme(
                          height: 0,
                          minWidth: 0,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => profileEdit(FirstName:_firstName, LastName:_lastName)));
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
                              child: Text(AppLocalizations.of(context).translate('profile_btn_edit'), style: TextStyle(fontSize: 12.2.sp, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.center),
                              padding: EdgeInsets.symmetric(horizontal: 4.0.h, vertical: 2.0.h),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: imLoggedWithFB != null ? false : true,   // Faz com que só seja visivel o botão alterar password se estiver logado com um email e password.
                        child: Padding(
                          padding: EdgeInsets.only(top: 3.2.h),
                          child: ButtonTheme(
                            height: 0,
                            minWidth: 0,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => profileChangePssw()));
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
                                child: Text(AppLocalizations.of(context).translate('profile_btn_change_password'), style: TextStyle(fontSize: 12.2.sp, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.center),
                                padding: EdgeInsets.symmetric(horizontal: 4.0.h, vertical: 2.0.h),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
              ),
            ),
          ]
        );
      },
    );
  }
}