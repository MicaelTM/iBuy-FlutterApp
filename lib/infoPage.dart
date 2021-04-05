import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'app_localizations.dart';
import 'accountPage.dart';
import 'homepage.dart';

class infoPage extends StatefulWidget {
  @override
  _infoPageState createState () => _infoPageState ();
}

class _infoPageState extends State<infoPage> {

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
              Container(
                width: 100.0.w,
                height: 100.0.h,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 7.2.h),
                        child: Text(AppLocalizations.of(context).translate('infoPage_main_text'), style: TextStyle(fontSize: 16.8.sp, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                      ),
                      Container(
                        width: 100.0.w,
                        margin: EdgeInsets.all(5.0.h),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding (
                          padding: EdgeInsets.only(top: 2.0.h, bottom: 2.0.h, left: 2.0.h, right: 2.0.h),
                          child: Text(AppLocalizations.of(context).translate('infoPage_appBy'), style: TextStyle(fontSize: 11.2.sp, color: Colors.black38, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.center),
                        ),
                      ),
                    ]
                  ),
                ),
              ),
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