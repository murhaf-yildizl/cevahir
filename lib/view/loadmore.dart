import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cevahir/database/database.dart';
import 'package:cevahir/models/customer.dart';
import 'package:cevahir/controller/customer_controller.dart';
import 'package:cevahir/models/image.dart';
import 'package:cevahir/controller/image_controller.dart';
import 'package:cevahir/models/model.dart';
import 'package:cevahir/controller/model_controller.dart';
import 'package:cevahir/utilities/Utilities.dart';
import 'package:cevahir/utilities/connection.dart';
import 'package:cevahir/view/add_model.dart';
import 'package:cevahir/view/create_drawer.dart';
import 'package:cevahir/view/homePage.dart';
import 'package:cevahir/view/show_model.dart';
import 'package:cevahir/view/text_style.dart';
import 'package:loadmore/loadmore.dart';
import 'package:carousel_slider/carousel_slider.dart';

class LoadMore extends StatefulWidget {
  @override
  _AllModelsState createState() => _AllModelsState();
}

class _AllModelsState extends State<LoadMore> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String qw = "";


    return Scaffold(
      body: Center(
        
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                Image(
                  width:200 ,
                  height: 200,
                  image: ExactAssetImage("assets/images/im8.jpg"),
                ),
                Image(
                  width:200 ,
                  height: 200,
                  image: ExactAssetImage("assets/images/im7.jpg"),
                ),
                Image(
                  width:200 ,
                  height: 200,
                  image: ExactAssetImage("assets/images/im5.jpg"),
                ),
                Image(
                  width:200 ,
                  height: 200,
                  image: ExactAssetImage("assets/images/im8.jpg"),
                ),
                Image(
                  width:200 ,
                  height: 200,
                  image: ExactAssetImage("assets/images/im7.jpg"),
                ),
                Image(
                  width:200 ,
                  height: 200,
                  image: ExactAssetImage("assets/images/im5.jpg"),
                )

              ].toList(),
            ),


    ),
        ),
      ) );
  }

}