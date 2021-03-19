import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_localizations.dart';
import 'homepage.dart';
import 'login.dart';
import 'dart:async';

class loader extends StatefulWidget {
  @override
  _loaderState createState() => _loaderState();
}

class _loaderState extends State<loader> {

  final Connectivity _connectivity = Connectivity();

  startTime() async {
    var duration = new Duration(seconds: 2);      // Tempo do loading do ecrã.
    return new Timer(duration, navigationPage);
  }

  Future<void> navigationPage() async {
    var _connectionResult = await _connectivity.checkConnectivity();

    if (_connectionResult == ConnectivityResult.none) {
      FocusScope.of(context).requestFocus(FocusNode());
      Fluttertoast.showToast(
        msg: AppLocalizations.of(context).translate('loader_toast'),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );
      SystemNavigator.pop();
    } else {
      if (await FirebaseAuth.instance.currentUser != null){
        Navigator.push(context, MaterialPageRoute(builder: (context) => homepage()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.blue[800]),
          strokeWidth: 10,
        ),
      ),
    );
  }
}