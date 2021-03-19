import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'app_localizations.dart';
import 'instances.dart';

class announcementDetails extends StatefulWidget {

  final String titleTextDetails;
  final String localizationTextDetails;
  final String priceTextDetails;
  final String imageURLDetails;
  final String userIDDetails;
  final String descriptionDetails;
  final int catIDDetails;

  @override
  _announcementDetailsState createState () => _announcementDetailsState ();

  announcementDetails({Key key, @required
    this.titleTextDetails,
    this.localizationTextDetails,
    this.priceTextDetails,
    this.imageURLDetails,
    this.userIDDetails,
    this.descriptionDetails,
    this.catIDDetails,
  });
}

class _announcementDetailsState extends State<announcementDetails> {

  String categoryTextDetails = "";
  instances _inst = instances();

  @override
  Widget build(BuildContext context) {

    categoryTextDetails = _inst.switchCategories(context, widget.catIDDetails);

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
          child: Column(
            children: [
              Container(
                width: 100.0.w,
                height: 40.0.h,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(28),
                    bottomLeft: Radius.circular(28),
                  ),
                  child: (widget.imageURLDetails != null) ? Image.network(widget.imageURLDetails, fit: BoxFit.cover) : Image.asset('images/example.png', fit: BoxFit.cover),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 2.0.h, bottom: 3.0.h, left: 2.0.h, right: 2.0.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 100.0.w,
                      margin: EdgeInsets.only(top: 2.0.h, left: 3.0.h, right: 3.0.h),
                      child: Padding(
                        padding: EdgeInsets.only(top: 2.0.h, bottom: 3.0.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.titleTextDetails, style: TextStyle(fontSize: 16.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                            Text(widget.priceTextDetails + ' €', style: TextStyle(fontSize: 16.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 3.0.h, right: 3.0.h),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    Container(
                      width: 100.0.w,
                      margin: EdgeInsets.only(left: 3.0.h, right: 3.0.h),
                      child: Padding(
                        padding: EdgeInsets.only(top: 3.0.h, bottom: 3.0.h),
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context).translate('announcementDetails_category'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                            Text(categoryTextDetails, style: TextStyle(fontSize: 12.2.sp, color: Colors.grey[600], fontFamily: 'Comfortaa')),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 3.0.h, right: 3.0.h),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    Container(
                      width: 100.0.w,
                      margin: EdgeInsets.only(left: 3.0.h, right: 3.0.h),
                      child: Padding(
                        padding: EdgeInsets.only(top: 3.0.h, bottom: 3.0.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppLocalizations.of(context).translate('announcementDetails_description'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                            Padding(
                              padding: EdgeInsets.only(top: 1.0.h),
                              child: Text(widget.descriptionDetails, style: TextStyle(fontSize: 12.2.sp, color: Colors.grey[600], fontFamily: 'Comfortaa')),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 3.0.h, right: 3.0.h),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    Container(
                      width: 100.0.w,
                      margin: EdgeInsets.only(left: 3.0.h, right: 3.0.h),
                      child: Padding(
                        padding: EdgeInsets.only(top: 3.0.h, bottom: 3.0.h),
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context).translate('announcementDetails_contact'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                            Text(widget.userIDDetails, style: TextStyle(fontSize: 12.2.sp, color: Colors.grey[600], fontFamily: 'Comfortaa')),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 3.0.h, right: 3.0.h),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    Container(
                      width: 100.0.w,
                      margin: EdgeInsets.only(bottom: 2.0.h, left: 3.0.h, right: 3.0.h),
                      child: Padding(
                        padding: EdgeInsets.only(top: 3.0.h, bottom: 2.0.h),
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context).translate('announcementDetails_localization'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                            Text(widget.localizationTextDetails, style: TextStyle(fontSize: 12.2.sp, color: Colors.grey[600], fontFamily: 'Comfortaa')),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}