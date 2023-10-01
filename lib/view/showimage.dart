import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cevahir/database/database.dart';
import 'package:cevahir/models/image.dart';
import 'package:cevahir/controller/image_controller.dart';
import 'package:cevahir/models/setting.dart';
import 'package:cevahir/controller/setting_controller.dart';
import 'package:cevahir/utilities/Utilities.dart';
import 'package:cevahir/view/homePage.dart';
import 'package:cevahir/view/setting_interface.dart';
import 'package:cevahir/view/show_model.dart';
import 'package:cevahir/view/text_style.dart';
import 'package:sqflite/sqlite_api.dart';

class ShowImage extends StatefulWidget {
  String path;
  Map<String, dynamic> model;
  String type;

  ShowImage(this.path,this.model,this.type);

  @override
  _ShowImageState createState() => _ShowImageState(path,model,type);
}

class _ShowImageState extends State<ShowImage> {
  String path;
  Map<String, dynamic> model;
  TextEditingController name_controller=TextEditingController();
  String type;

  _ShowImageState(this.path,this.model,this.type);

  @override
  Widget build(BuildContext context) {

    File f=File(path);
    f.readAsBytes().then((value){
      print("WWWWWWWWW${value.length}");

    });
    return Scaffold(
      appBar:AppBar(
        backgroundColor:Colors.indigo ,
        toolbarHeight:1 ,
        //title:Center(child:Text_Style("") ,) ,

      ) ,
      body:Center(
        child: Container(
           padding: EdgeInsets.only(top:6),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                 children:[
            path!=null?Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                height:MediaQuery.of(context).size.height*0.6 ,
                  width:MediaQuery.of(context).size.width ,
                  child: Image.memory(base64Decode(path),fit: BoxFit.cover)),
            ):Text("no data"),

            MyUtilities.addTextFormFeild(name_controller,"أدخل الاسم", true, null,false,false),
           SizedBox(height: 15),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,

             children: [
             Container(
               width: 100,
               child: TextButton(
                   style:ButtonStyle(

                       shape:MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                           borderRadius:BorderRadius.circular(100) ,
                           side: BorderSide(color: Colors.teal,width: 3)
                       ))
                   ) ,
                   child:Text_Style("حفظ",18,Colors.teal,"rtl"),
                   onPressed: ()async{

                     if(path==null || path.isEmpty)
                       return 0;
                     try
                     {
                       print(type);
                       if(type=="setting")
                          await DataBaseHelper.insertToDataBase("start_images", ImageController.to_map(ImageDetails(0,path,name_controller.text,model['model_id']))).then((value) {
                            Navigator.pop(context);
                            Navigator.push(context,MaterialPageRoute(builder:(context){
                              return HomePage();
                               }));
                          });

                   else await DataBaseHelper.insertToDataBase("images", ImageController.to_map(ImageDetails(0,path,name_controller.text,model['model_id']))).then((value) {
                           Navigator.pop(context);
                           Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context){
                             return  ShowModl(model,type);
                           }));
                         });

                     }  catch(e){}

                   }),
             ),
             SizedBox(width:30 ),
             Container(
               width: 100,
               child: TextButton(
                   style:ButtonStyle(
                       shape:MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                           borderRadius:BorderRadius.circular(80) ,
                           side: BorderSide(color: Colors.teal,width: 3)
                       ))
                   ) ,
                   child:Text_Style("إلغاء الأمر",18,Colors.teal,"rtl"),
                   onPressed: (){
                     if(type=="setting")
                        Navigator.push(context,MaterialPageRoute(builder:(context){
                          return HomePage();
                          }));
                     else
                       Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context){
                          return  ShowModl(model,type);
                           }));
                   }),
             )
           ],)

    ]
            ),
          )
    ),
      ));
  }
}
