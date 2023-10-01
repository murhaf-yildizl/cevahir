import 'dart:io';
 import 'package:cevahir/widgets/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cevahir/database/database.dart';
import 'package:cevahir/utilities/Utilities.dart';
import 'package:cevahir/utilities/connection.dart';
import 'package:cevahir/widgets/add_image.dart';
import 'package:cevahir/widgets/all_customers.dart';
import 'package:cevahir/widgets/all_models.dart';
import 'package:cevahir/widgets/homePage.dart';
import 'package:cevahir/widgets/showdetails.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cevahir/widgets/text_style.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());



}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  String company,logo;


  @override
  Widget build(BuildContext context) {

     //SystemChrome.setEnabledSystemUIOverlays.setEnabledSystemUIModel(SystemUiMode.manual,overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    return MaterialApp(
              debugShowCheckedModeBanner: false,

               theme: ThemeData(primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: AnimatedSplashScreen(
                        splashIconSize: (512),
                        splash:Image.asset("assets/images/logo1.png"),
                        nextScreen:Login(),
                        duration: 3000,
                        splashTransition: SplashTransition.rotationTransition,
    )
    );
    }



}

