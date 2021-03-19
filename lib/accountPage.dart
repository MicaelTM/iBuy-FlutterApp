import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'createAnnouncements.dart';
import 'app_localizations.dart';
import 'authentications.dart';
import 'homepage.dart';
import 'infoPage.dart';
import 'profile.dart';
import 'login.dart';

class accountPage extends StatefulWidget {
  @override
  _accountPageState createState () => _accountPageState ();
}

class _accountPageState extends State<accountPage> {

  authentications _auth = authentications();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,   // Serve para bloquear o voltar atrás através dos botões que tem por defeito o telemóvel
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

          body: Stack(
            alignment: Alignment.center,
            children: [
              accountList(),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: bottomNavigatorBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void logOutPopup(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text(AppLocalizations.of(context).translate('accountPage_popUp'), style: TextStyle(fontSize: 15.3.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.center),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Colors.white,
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 2.2.h),
          child: Container(
            width: 100.0.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (await FacebookAuth.instance.isLogged != null) {
                      await _auth.signOutFacebook();    // Método signOut com o facebook do authentications.
                    }
                    await _auth.signOut();              // Método signOut do email com password do authentications.
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
                  },
                  child: Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.black87, size: 6.0.h),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: Icon(CupertinoIcons.multiply_circle_fill, color: Colors.black87, size: 6.0.h),
                ),
              ],
            ),
          ),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      }
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget accountList() {
    return ListView(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: 3.8.h),
            child: Text(AppLocalizations.of(context).translate('accountPage_main_text'), style: TextStyle(fontSize: 16.8.sp, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 4.2.h, bottom: 2.5.h, left: 8.8.w, right: 8.8.w),
          child: Container(
            height: 12.0.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 35.0.h,
                  child: ListTile(title: Text(AppLocalizations.of(context).translate('accountPage_profile_text'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'))),
                ),
                Container(
                  width: 5.0.h,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => profile()));
                    },
                    child: Icon(CupertinoIcons.arrow_right_circle_fill, color: Colors.black87, size: 4.0.h),
                  ),
                ),
              ],
            )
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 2.5.h, left: 8.8.w, right: 8.8.w),
          child: Container(
            height: 12.0.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 35.0.h,
                  child: ListTile(title: Text(AppLocalizations.of(context).translate('accountPage_announcements_text'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'))),
                ),
                Container(
                  width: 5.0.h,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => createAnnouncements()));
                    },
                    child: Icon(CupertinoIcons.arrow_right_circle_fill, color: Colors.black87, size: 4.0.h),
                  ),
                ),
              ],
            )
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 2.5.h, left: 8.8.w, right: 8.8.w),
          child: Container(
            height: 12.0.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 35.0.h,
                  child: ListTile(title: Text(AppLocalizations.of(context).translate('accountPage_settings_text'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'))),
                ),
                Container(
                  width: 5.0.h,
                  child: GestureDetector(
                    onTap: () {
                      print('Sou o botão do "Definições".');
                    },
                    child: Icon(CupertinoIcons.arrow_right_circle_fill, color: Colors.black87, size: 4.0.h),
                  ),
                ),
              ],
            )
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 13.0.h, left: 8.8.w, right: 8.8.w),
          child: Container(
            height: 12.0.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 35.0.h,
                  child: ListTile(title: Text(AppLocalizations.of(context).translate('accountPage_logOut_text'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'))),
                ),
                Container(
                  width: 5.0.h,
                  child: GestureDetector(
                    onTap: () {
                      logOutPopup(context);
                    },
                    child: Icon(CupertinoIcons.arrow_right_circle_fill, color: Colors.black87, size: 4.0.h),
                  ),
                ),
              ],
            )
          ),
        ),
      ],
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget bottomNavigatorBar() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(28),
        topLeft: Radius.circular(28),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        onTap: (index) {
          switch(index) {
            case 0:
              Navigator.push(context, MaterialPageRoute(builder: (context) => homepage()));
              break;
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: (context) => accountPage()));
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (context) => infoPage()));
              break;
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.house_fill, color: Colors.black87, size: 3.5.h), label: ''),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_crop_circle_fill, color: Colors.black87, size: 3.5.h), label: ''),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.info_circle_fill, color: Colors.black87, size: 3.5.h), label: ''),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}