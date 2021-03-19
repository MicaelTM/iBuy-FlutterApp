import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'announcementDetails.dart';
import 'app_localizations.dart';
import 'instances.dart';

class homepageChosenCategory extends StatefulWidget {

  final int catIDFromHomepageChosenCat;

  @override
  _homepageChosenCategoryState createState () => _homepageChosenCategoryState ();

  homepageChosenCategory({Key key, @required this.catIDFromHomepageChosenCat});
}

class _homepageChosenCategoryState extends State<homepageChosenCategory> {

  String categoryText = "";
  instances _inst = instances();

  @override
  Widget build(BuildContext context) {

    categoryText = _inst.switchCategories(context, widget.catIDFromHomepageChosenCat);

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
            Container(
            width: 100.0.w,
            height: 100.0.h,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 7.2.h),
                      child: Text(categoryText, style: TextStyle(fontSize: 16.8.sp, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                    ),
                    LimitedBox(
                      maxHeight: 9999999,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('announcements').where('catID', isEqualTo: widget.catIDFromHomepageChosenCat).snapshots(),
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
                                    child: Text(AppLocalizations.of(context).translate('streamBuilder_if_noData_chosenCat'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black38, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.center),
                                  ),
                                );
                              } else {
                                return categoryAnnouncementsList(snapshot.data);
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
          ]
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget categoryAnnouncementsList(QuerySnapshot snapshot) {
    return ListView.builder(
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
                              return Text('${AppLocalizations.of(context).translate('homepageChosenCategory_from')}' + snapshot.data.get('first_name') + ' ' + snapshot.data.get('last_name'), style: TextStyle(fontSize: 10.2.sp, color: Colors.grey[600], fontFamily: 'Comfortaa'));
                            }
                          }
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 1.6.h, left: 3.0.h, right: 3.0.h),
                        child: Text('${AppLocalizations.of(context).translate('homepageChosenCategory_localization')}$localizationText', style: TextStyle(fontSize: 10.2.sp, color: Colors.grey[600], fontFamily: 'Comfortaa')),
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
}