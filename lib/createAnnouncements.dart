import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'announcementDetails.dart';
import 'app_localizations.dart';
import 'instances.dart';
import 'dart:io';

class createAnnouncements extends StatefulWidget {
  @override
  _createAnnouncementsState createState () => _createAnnouncementsState ();
}

class _createAnnouncementsState extends State<createAnnouncements> {

  final _formKey = GlobalKey<FormState>();
  final _scaffold = GlobalKey<ScaffoldState>();
  String _announcementTitle = "";
  int _announcementCategory = 0;
  String _announcementDescription = "";
  String _announcementLocalization = "";
  String _announcementPrice = "";
  String _fetchEmailAuth = FirebaseAuth.instance.currentUser.email;
  String _imageURL;
  String _fileName;
  PickedFile _imagePickedGLOBAL;
  File _fileToFirebaseGLOBAL;
  instances _inst = instances();

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
        key: _scaffold,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,

        // Aqui fiz uma lista dentro de um single child scroll view.

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
                      child: Text(AppLocalizations.of(context).translate('createAnnouncements_main_text'), style: TextStyle(fontSize: 16.8.sp, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                    ),
                    LimitedBox(
                      maxHeight: 9999999,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('announcements').where('userID', isEqualTo: _fetchEmailAuth).snapshots(),
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
                                    child: Text(AppLocalizations.of(context).translate('streamBuilder_if_noData_createAd'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black38, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.center),
                                  ),
                                );
                              } else {
                                return announcementsList(snapshot.data);
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
            Positioned.fill(
              bottom: 20,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    setState(() {                     // Este setState vai fazer com que em todas as situações que abra o popup de adicionar anúncio, neste, a imagem do anuncio vai ser sempre null.
                      _fileToFirebaseGLOBAL = null;
                      _imagePickedGLOBAL = null;
                      _imageURL = null;
                      _fileName = null;
                    });
                    addAnnouncementPopup(context);
                  },
                  child: Icon(CupertinoIcons.add_circled_solid, color: Colors.black87, size: 8.0.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void addAnnouncementPopup(BuildContext context) {
    var alertDialog = SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 7.0.h, bottom: 3.0.h),
        child: StatefulBuilder(                                 // Aqui preciso deste StatefulBuilder para poder mudar o estado do popup ao fazer refesh por alguma instrução, neste caso ao carregar a imagem do anuncio.
          builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context).translate('createAnnouncements_newAnnouncement_text'), style: TextStyle(fontSize: 15.3.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.center),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              backgroundColor: Colors.white,
              actions: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 0.5.h),
                        child: Container(
                          width: 60.0.w,
                          height: 20.0.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: (_fileToFirebaseGLOBAL != null) ? Image.file(_fileToFirebaseGLOBAL, fit: BoxFit.cover) : Image.asset('images/example.png', fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.7.h),
                        child: Container(
                          width: 60.0.w,
                          child: GestureDetector(
                            onTap: () async {
                              // Verificar permissões da app
                              await Permission.photos.request();
                              var permissionStatus = await Permission.photos.status;
                              if (permissionStatus.isGranted) {
                                // Selecionar a imagem que queremos
                                final _picker = ImagePicker();
                                PickedFile imagePicked = await _picker.getImage(source: ImageSource.gallery);
                                File fileToFirebase = File(imagePicked.path);
                                setState(() {
                                  _imagePickedGLOBAL = imagePicked;
                                  _fileToFirebaseGLOBAL = fileToFirebase;
                                  _fileName = _imagePickedGLOBAL.path.split('/').last;
                                });
                              } else {
                                print('Permissão para aceder à livraria de fotografias foi negada!!!');
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(AppLocalizations.of(context).translate('createAnnouncements_newAnnouncement_images'), style: TextStyle(fontSize: 11.2.sp, color: Colors.grey[600], fontFamily: 'Comfortaa')),
                                SizedBox(width: 2.0.h),
                                Icon(CupertinoIcons.add_circled, color: Colors.black87, size: 5.0.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.7.h),
                        child: Container(
                          width: 60.0.w,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(AppLocalizations.of(context).translate('createAnnouncements_newAnnouncement_title'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
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
                                  _announcementTitle = value;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.7.h),
                        child: Container(
                          width: 60.0.w,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(AppLocalizations.of(context).translate('createAnnouncements_newAnnouncement_category'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                              ),
                              DropdownButtonFormField(
                                isExpanded: true,
                                items: [
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_1'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 1),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_2'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 2),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_3'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 3),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_4'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 4),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_5'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 5),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_6'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 6),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_7'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 7),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_8'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 8),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_9'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 9),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_10'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 10),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_11'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 11),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_12'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 12),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_13'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 13),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_14'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 14),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_15'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 15),
                                ],
                                validator: (int value) {
                                  if (value == null) {
                                    return AppLocalizations.of(context).translate('validators');
                                  }
                                  return null;
                                },
                                onChanged: (int value) {
                                  _announcementCategory = value;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.7.h),
                        child: Container(
                          width: 60.0.w,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(AppLocalizations.of(context).translate('createAnnouncements_newAnnouncement_description'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                              ),
                              TextFormField(
                                maxLines: 5,
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return AppLocalizations.of(context).translate('validators');
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  _announcementDescription = value;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.7.h),
                        child: Container(
                          width: 60.0.w,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(AppLocalizations.of(context).translate('createAnnouncements_newAnnouncement_localization'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
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
                                  _announcementLocalization = value;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 3.2.h),
                        child: Container(
                          width: 60.0.w,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(AppLocalizations.of(context).translate('createAnnouncements_newAnnouncement_price'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 55.0.w,
                                    child: TextFormField(
                                      textAlign: TextAlign.left,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'),
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return AppLocalizations.of(context).translate('validators');
                                        }
                                        return null;
                                      },
                                      onSaved: (String value) {
                                        _announcementPrice = value;
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 5.0.w,
                                    child: Text('€', style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.right),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.2.h),
                        child: Container(
                          width: 100.0.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (!_formKey.currentState.validate()){
                                    return ;
                                  } else {
                                    _formKey.currentState.save();

                                    // Upload da imagem para o firebase storage
                                    if(_imagePickedGLOBAL != null) {
                                      var _directory = FirebaseStorage.instance.ref().child(_fetchEmailAuth).child('announcementsImages/');
                                      var _upload = await _directory.child(_fileName).putFile(_fileToFirebaseGLOBAL);
                                      var _downloadedURL = await _upload.ref.getDownloadURL();
                                      setState(() {
                                        _imageURL = _downloadedURL.toString();
                                      });
                                    } else {
                                      print ('Não se recebeu nenhum caminho da imagem!!!');
                                    }
                                    await FirebaseFirestore.instance.collection('announcements').doc().set({
                                      'title': _announcementTitle,
                                      'catID': _announcementCategory,
                                      'description': _announcementDescription,
                                      'localization': _announcementLocalization,
                                      'price' : _announcementPrice,
                                      'userID' : _fetchEmailAuth,
                                      'imageURL' : _imageURL,
                                      'imageName' : _fileName,
                                    });
                                  }
                                  Navigator.pop(context, false);
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
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      }
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void deleteAnnouncementPopup(docID, imageName) {
    var alertDialog = AlertDialog(
      title: Text(AppLocalizations.of(context).translate('createAnnouncements_newAnnouncement_deleteAd'), style: TextStyle(fontSize: 15.3.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.center),
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
                    await FirebaseStorage.instance.ref().child(_fetchEmailAuth).child('announcementsImages/').child(imageName).delete();
                    await FirebaseFirestore.instance.collection('announcements').doc(docID).delete();
                    Navigator.pop(context, false);
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
      context: _scaffold.currentContext,
      builder: (BuildContext context) {
        return alertDialog;
      }
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void editAnnouncementPopup(BuildContext context, imageURL, titleText, categoryText, descriptionText, localizationText, priceText, imageName, docID) {
    var alertDialog = SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 7.0.h, bottom: 3.0.h),
        child: StatefulBuilder(                                 // Aqui preciso deste StatefulBuilder para poder mudar o estado do popup ao fazer refesh por alguma instrução, neste caso ao carregar a imagem do anuncio.
          builder: (context, setState) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context).translate('createAnnouncements_editAnnouncement_text'), style: TextStyle(fontSize: 15.3.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.center),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              backgroundColor: Colors.white,
              actions: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 0.5.h),
                        child: Container(
                          width: 60.0.w,
                          height: 20.0.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: (_fileToFirebaseGLOBAL != null) ? Image.file(_fileToFirebaseGLOBAL, fit: BoxFit.cover)
                                : (imageURL != null) ? Image.network(imageURL, fit: BoxFit.cover)
                                : Image.asset('images/example.png', fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.7.h),
                        child: Container(
                          width: 60.0.w,
                          child: GestureDetector(
                            onTap: () async {
                              // Verificar permissões da app
                              await Permission.photos.request();
                              var permissionStatus = await Permission.photos.status;
                              if (permissionStatus.isGranted) {
                                // Selecionar a imagem que queremos
                                final _picker = ImagePicker();
                                PickedFile imagePicked = await _picker.getImage(source: ImageSource.gallery);
                                File fileToFirebase = File(imagePicked.path);
                                setState(() {
                                  _imagePickedGLOBAL = imagePicked;
                                  _fileToFirebaseGLOBAL = fileToFirebase;
                                  _fileName = _imagePickedGLOBAL.path.split('/').last;
                                });
                              } else {
                                print('Permissão para aceder à livraria de fotografias foi negada!!!');
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(AppLocalizations.of(context).translate('createAnnouncements_editAnnouncement_images'), style: TextStyle(fontSize: 10.2.sp, color: Colors.grey[600], fontFamily: 'Comfortaa')),
                                SizedBox(width: 2.0.h),
                                Icon(CupertinoIcons.add_circled, color: Colors.black87, size: 5.0.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.7.h),
                        child: Container(
                          width: 60.0.w,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(AppLocalizations.of(context).translate('createAnnouncements_newAnnouncement_title'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                              ),
                              TextFormField(
                                initialValue: titleText,
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return AppLocalizations.of(context).translate('validators');
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  _announcementTitle = value;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.7.h),
                        child: Container(
                          width: 60.0.w,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(AppLocalizations.of(context).translate('createAnnouncements_newAnnouncement_category'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                              ),
                              DropdownButtonFormField(
                                isExpanded: true,
                                items: [
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_1'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 1),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_2'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 2),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_3'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 3),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_4'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 4),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_5'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 5),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_6'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 6),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_7'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 7),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_8'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 8),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_9'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 9),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_10'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 10),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_11'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 11),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_12'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 12),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_13'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 13),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_14'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 14),
                                  DropdownMenuItem(child: Text(AppLocalizations.of(context).translate('category_text_15'), style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'), overflow: TextOverflow.visible), value: 15),
                                ],
                                validator: (int value) {
                                  if (value == null) {
                                    return AppLocalizations.of(context).translate('validators');
                                  }
                                  return null;
                                },
                                onChanged: (int value) {
                                  _announcementCategory = value;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.7.h),
                        child: Container(
                          width: 60.0.w,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(AppLocalizations.of(context).translate('createAnnouncements_newAnnouncement_description'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                              ),
                              TextFormField(
                                initialValue: descriptionText,
                                maxLines: 5,
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return AppLocalizations.of(context).translate('validators');
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  _announcementDescription = value;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.7.h),
                        child: Container(
                          width: 60.0.w,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(AppLocalizations.of(context).translate('createAnnouncements_newAnnouncement_localization'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                              ),
                              TextFormField(
                                initialValue: localizationText,
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return AppLocalizations.of(context).translate('validators');
                                  }
                                  return null;
                                },
                                onSaved: (String value) {
                                  _announcementLocalization = value;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 3.2.h),
                        child: Container(
                          width: 60.0.w,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(AppLocalizations.of(context).translate('createAnnouncements_newAnnouncement_price'), style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa')),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 55.0.w,
                                    child: TextFormField(
                                      initialValue: priceText,
                                      textAlign: TextAlign.left,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(fontSize: 12.2.sp, color: Colors.black54, fontFamily: 'Comfortaa'),
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return AppLocalizations.of(context).translate('validators');
                                        }
                                        return null;
                                      },
                                      onSaved: (String value) {
                                        _announcementPrice = value;
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 5.0.w,
                                    child: Text('€', style: TextStyle(fontSize: 13.8.sp, color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Comfortaa'), textAlign: TextAlign.right),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.2.h),
                        child: Container(
                          width: 100.0.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  if (!_formKey.currentState.validate()){
                                    return ;
                                  } else {
                                    _formKey.currentState.save();

                                    // Eliminar a imagem antiga do firebase storage
                                    await FirebaseStorage.instance.ref().child(_fetchEmailAuth).child('announcementsImages/').child(imageName).delete();

                                    // Upload da nova imagem para o firebase storage
                                    if(_imagePickedGLOBAL != null) {
                                      var _directory = FirebaseStorage.instance.ref().child(_fetchEmailAuth).child('announcementsImages/');
                                      var _upload = await _directory.child(_fileName).putFile(_fileToFirebaseGLOBAL);
                                      var _downloadedURL = await _upload.ref.getDownloadURL();
                                      setState(() {
                                        _imageURL = _downloadedURL.toString();
                                      });
                                    } else {
                                      print ('Não se recebeu nenhum caminho da imagem!!!');
                                    }

                                    await FirebaseFirestore.instance.collection('announcements').doc(docID).update({
                                      'title': _announcementTitle,
                                      'catID': _announcementCategory,
                                      'description': _announcementDescription,
                                      'localization': _announcementLocalization,
                                      'price' : _announcementPrice,
                                      'userID' : _fetchEmailAuth,
                                      'imageURL' : _imageURL,
                                      'imageName' : _fileName,
                                    });
                                  }
                                  Navigator.pop(context, false);
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
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      }
    );
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Widget announcementsList(QuerySnapshot snapshot) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        final doc = snapshot.docs[index];
        String titleText = doc['title'];
        int catID = doc['catID'];
        String description = doc['description'];
        String localizationText = doc['localization'];
        String priceText = doc['price'];
        String imageURL = doc['imageURL'];
        String imageName = doc['imageName'];
        String userID = doc['userID'];

        String categoryText = _inst.switchCategories(context, catID);

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
                          Positioned(
                            top: 1.0.h,
                            right: 1.0.h,
                            child: Container(
                              height: 5.1.h,
                              width: 5.1.h,
                              alignment: Alignment.topRight,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  deleteAnnouncementPopup(doc.id, imageName);
                                },
                                child: Icon(CupertinoIcons.multiply_circle_fill, color: Colors.black, size: 5.0.h),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 1.0.h,
                            left: 1.0.h,
                            child: Container(
                              height: 5.1.h,
                              width: 5.1.h,
                              alignment: Alignment.topRight,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _fileToFirebaseGLOBAL = null;
                                    _imagePickedGLOBAL = null;
                                    _imageURL = imageURL;
                                    //_fileName = null;
                                  });
                                  editAnnouncementPopup(context, imageURL, titleText, categoryText, description, localizationText, priceText, imageName, doc.id);
                                },
                                child: Icon(CupertinoIcons.pencil_circle_fill, color: Colors.black, size: 5.0.h),
                              ),
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
                        child: Text('${AppLocalizations.of(context).translate('createAnnouncements_category')}$categoryText', style: TextStyle(fontSize: 10.2.sp, color: Colors.grey[600], fontFamily: 'Comfortaa')),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 1.6.h, left: 3.0.h, right: 3.0.h),
                        child: Text('${AppLocalizations.of(context).translate('createAnnouncements_localization')}$localizationText', style: TextStyle(fontSize: 10.2.sp, color: Colors.grey[600], fontFamily: 'Comfortaa')),
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