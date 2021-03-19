import 'package:auth_app/announcementDetails.dart';
import 'package:auth_app/homepageChosenCategory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'app_localizations.dart';
import 'accountPage.dart';
import 'infoPage.dart';

class homepage extends StatefulWidget {
  @override
  _homepageState createState () => _homepageState ();
}

class _homepageState extends State<homepage> {

  String _fetchEmailAuth = FirebaseAuth.instance.currentUser.email;

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
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance.collection('users').doc(_fetchEmailAuth).snapshots(),
                          builder: (context, snapshot) {
                            if(!snapshot.hasData) {
                              return LinearProgressIndicator();
                            } else {
                              return Text(AppLocalizations.of(context).translate('homepage_main_text') + snapshot.data.get('first_name'), style: TextStyle(fontSize: 16.8.sp, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'));
                            }
                          }
                        ),
                      ),
                      Container(
                        width: 100.0.w,
                        height: 20.0.h,
                        margin: EdgeInsets.only(top: 2.7.h),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                        ),
                        child: getCategoriesItems(),
                      ),
                      LimitedBox(
                        maxHeight: 9999999,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('announcements').snapshots(),
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
                                      child: Text(AppLocalizations.of(context).translate('streamBuilder_if_noData_homepage'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black38, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.center),
                                    ),
                                  );
                                } else {
                                  return allAnnouncementsList(snapshot.data);
                                }
                              }
                            }
                          }
                        ),
                      ),
                      SizedBox(height: 10.0.h),
                    ],
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

  Widget getCategoriesItems() {

    List<IconData> categoriesListIcons = [
      CupertinoIcons.tree,
      CupertinoIcons.paw,
      CupertinoIcons.rocket_fill,
      CupertinoIcons.car_detailed,
      CupertinoIcons.sportscourt_fill,
      CupertinoIcons.briefcase_fill,
      CupertinoIcons.hammer_fill,
      CupertinoIcons.house_alt_fill,
      CupertinoIcons.gamecontroller_alt_fill,
      CupertinoIcons.wand_stars,
      CupertinoIcons.bed_double_fill,
      CupertinoIcons.paintbrush_fill,
      CupertinoIcons.desktopcomputer,
      CupertinoIcons.device_phone_portrait,
      CupertinoIcons.question_diamond_fill
    ];
    List<String> categoriesListText = [
      AppLocalizations.of(context).translate('category_text_1'),
      AppLocalizations.of(context).translate('category_text_2'),
      AppLocalizations.of(context).translate('category_text_3'),
      AppLocalizations.of(context).translate('category_text_4'),
      AppLocalizations.of(context).translate('category_text_5'),
      AppLocalizations.of(context).translate('category_text_6'),
      AppLocalizations.of(context).translate('category_text_7'),
      AppLocalizations.of(context).translate('category_text_8'),
      AppLocalizations.of(context).translate('category_text_9'),
      AppLocalizations.of(context).translate('category_text_10'),
      AppLocalizations.of(context).translate('category_text_11'),
      AppLocalizations.of(context).translate('category_text_12'),
      AppLocalizations.of(context).translate('category_text_13'),
      AppLocalizations.of(context).translate('category_text_14'),
      AppLocalizations.of(context).translate('category_text_15')
    ];

    return ListView.builder(
      itemCount: 15,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            int catIDFromHomepage = index + 1;
            Navigator.push(context, MaterialPageRoute(builder: (context) => homepageChosenCategory(catIDFromHomepageChosenCat:catIDFromHomepage)));
          },
          child: Container(
            width: 30.0.w,
            height: 10.0.h,
            margin: EdgeInsets.all(2.0.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Padding (
              padding: EdgeInsets.all(2.0.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 8.0.h,
                    width: 30.0.w,
                    alignment: Alignment.center,
                    child: Icon(categoriesListIcons[index], color: Colors.black87, size: 6.0.h),
                  ),
                  Container(
                    height: 3.0.h,
                    width: 30.0.w,
                    alignment: Alignment.bottomCenter,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(categoriesListText[index], style: TextStyle(fontSize: 10.2.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget allAnnouncementsList(QuerySnapshot snapshot) {
    return ListView.builder (
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        final doc = snapshot.docs[index];
        String titleText = doc['title'];
        String localizationText = doc['localization'];
        String priceText = doc['price'];
        String imageURL = doc['imageURL'];
        String userID = doc['userID'];
        String description = doc['description'];
        int catID = doc['catID'];

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 2.5.h, left: 8.8.w, right: 8.8.w),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => announcementDetails(
                    titleTextDetails:titleText,
                    localizationTextDetails:localizationText,
                    priceTextDetails:priceText,
                    imageURLDetails:imageURL,
                    userIDDetails:userID,
                    descriptionDetails:description,
                    catIDDetails:catID,
                  )));
                },
                child: Container(
                  width: 100.0.w,
                  height: 34.0.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 100.0.w,
                            height: 20.0.h,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: (imageURL != null) ? Image.network(imageURL, fit: BoxFit.cover) : Image.asset('images/example.png', fit: BoxFit.cover),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 1.6.h, left: 3.0.h, right: 3.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(titleText, style: TextStyle(fontSize: 12.2.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                            Text(priceText + ' €', style: TextStyle(fontSize: 12.2.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 1.6.h, left: 3.0.h, right: 3.0.h),
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance.collection('users').doc(userID).snapshots(),
                          builder: (context, snapshot) {
                            if(!snapshot.hasData) {
                              return LinearProgressIndicator();
                            } else {
                              return Text('${AppLocalizations.of(context).translate('homepage_announcements_from')}' + snapshot.data.get('first_name') + ' ' + snapshot.data.get('last_name'), style: TextStyle(fontSize: 10.2.sp, color: Colors.grey[600], fontFamily: 'Comfortaa'));
                            }
                          }
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 1.6.h, left: 3.0.h, right: 3.0.h),
                        child: Text('${AppLocalizations.of(context).translate('homepage_announcements_localization')}$localizationText', style: TextStyle(fontSize: 10.2.sp, color: Colors.grey[600], fontFamily: 'Comfortaa')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }
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