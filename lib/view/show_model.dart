import 'package:camera/camera.dart';
import 'package:cevahir/view/all_models.dart';
import 'package:flutter/material.dart';
import 'package:cevahir/database/database.dart';
import 'package:cevahir/models/material.dart';
import 'package:cevahir/controller/material_controller.dart';
import 'package:cevahir/utilities/connection.dart';
import 'package:cevahir/view/add_image.dart';
import 'package:cevahir/view/add_model.dart';
import 'package:cevahir/view/create_drawer.dart';
import 'package:cevahir/view/homePage.dart';
import 'package:cevahir/view/showdetails.dart';
 import 'package:cevahir/view/text_style.dart';

import 'total_details.dart';
import 'add_order.dart';

class ShowModl  extends StatefulWidget {
  Map<String, dynamic> model={};
  String type;

   ShowModl(this.model,this.type);

  @override
   createState() => ShowModel_State(model,type);

}

class ShowModel_State extends State with SingleTickerProviderStateMixin{
  TabController tabcontroller;
  Map<String, dynamic> model={};
  String type;

   ShowModel_State(this.model,this.type);

   @override
  void initState() {
    // TODO: implement initState
      tabcontroller=TabController(length: 3,vsync:this);

    super.initState();

   }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: CreateDrawer(["طلبية جديدة","الموديلات","الصفحة الرئيسية"],[AddOrder(model,type),AllModels(),HomePage()]),
      body: CustomScrollView(
          slivers: [
            SliverAppBar(
              //automaticallyImplyLeading: false,
               backgroundColor:Colors.indigo.withOpacity(0.9),
               expandedHeight:80 ,
              collapsedHeight:60 ,
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.only(top:10),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text(model['name']==null?"غير معروف":model['name'].toString().toUpperCase(),style:TextStyle(fontSize: 20,fontWeight:FontWeight.bold,letterSpacing: 2 )),
                    Text(" (${model['model_no']}) ",style:TextStyle(fontSize: 20,fontWeight:FontWeight.bold ,letterSpacing: 2)),

                  ],),
                ),
              ),
              bottom: TabBar(
              controller: tabcontroller,
              tabs: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),child: Text_Style("تفاصيل كلية",18,Colors.white,"rtl"),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 15),child: Text_Style("الصور",18,Colors.white,"rtl"),
                  ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 15),child: Text_Style("التفاصيل",18,Colors.white,"rtl"),
                  ),

              ],
            ) ,

            ),

              SliverFillRemaining(
                  child:TabBarView(
     physics: ScrollPhysics(),
    controller: tabcontroller,
    children: [
      Padding(
        padding: const EdgeInsets.only(top:10),
        child: TotalDetails(model['model_id'],type)
     ),
      Padding(
    padding: const EdgeInsets.only(top:10),
    child: AddImage.constructor(model,type),
    ),
      Padding(
    padding: const EdgeInsets.only(top:10),
    child:ShowDetails(model['model_id'],type),
    ),

    ],
    ),
              )



          ]
      )

    );
  }

  }

