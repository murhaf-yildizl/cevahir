import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cevahir/database/database.dart';
import 'package:cevahir/models/customer.dart';
import 'package:cevahir/controller/customer_controller.dart';
import 'package:cevahir/widgets/text_style.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'connection.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class MyUtilities
{


 static void show_dialog_box(String txt,BuildContext context)
  {
    AwesomeDialog(
      context: context,
      customHeader:Icon(Icons.error_outline_sharp,color: Colors.red,size:60) ,
      dialogType: DialogType.ERROR,
      borderSide: BorderSide(color: Colors.green, width: 2),
      buttonsBorderRadius: BorderRadius.all(Radius.circular(1)),
      headerAnimationLoop: true,
      autoHide:Duration(seconds: 2) ,
      animType: AnimType.SCALE,
      title: 'Error',
      body:Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text_Style(txt,18,Colors.red,"rtl"),
        ),
      ) ,
      //desc: 'USER_NOT_FOUND',
      //showCloseIcon: true,
      // btnCancelOnPress: () {},
      // btnOkOnPress: () {},


    ).show();
  }
  static String convertDate(String date) {
   if( date==null)
     return "";
    Duration timeAgo = DateTime.now().difference(DateTime.parse(date));
    DateTime difference = DateTime.now().subtract(timeAgo);
    return timeago.format(difference);
  }

static  alertdialog(BuildContext context,String text)
{

  AwesomeDialog(
    context: context,
    customHeader:Icon(Icons.check_circle,color: Colors.green,size:60) ,

    dialogType: DialogType.SUCCES,
    borderSide: BorderSide(color: Colors.green, width: 2),
    buttonsBorderRadius: BorderRadius.all(Radius.circular(1)),
    headerAnimationLoop: true,
    autoHide:Duration(seconds: 2) ,
    animType: AnimType.SCALE,
    body:Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text_Style(text,18,Colors.red,"rtl"),
      ),
    ) ,
    //desc: 'USER_NOT_FOUND',
    //showCloseIcon: true,
  ).show();

}


    static Widget addTextFormFeild(TextEditingController _controller,String hint,bool required,GlobalKey<FormState> formkey,bool number,bool password)
  {
    return   Column(
      children: [
        Container(

          height:80,
          width:200 ,
          child: TextFormField(
            obscureText: password,
             textAlignVertical:TextAlignVertical.center ,
            onChanged:(text){
              if(formkey!=null)
                if(formkey.currentState.validate())
                return;

            } ,
            textAlign:TextAlign.center ,
            style: TextStyle(
              fontSize: 18,
              color:Colors.black
            ),
            keyboardType:number?TextInputType.number:TextInputType.text,
            controller:_controller,
            decoration: InputDecoration(
              hintText:hint,
             contentPadding:EdgeInsets.zero ,
             // hintStyle:(TextStyle(color:Colors.grey.shade500,letterSpacing: 3,)) ,
              border: OutlineInputBorder(
                borderRadius:BorderRadius.circular(20),
                borderSide:BorderSide(color:Colors.red,width: 30, )
              ),
              filled:true,

             // fillColor:Colors.amberAccent,


            ),
             validator: (value) {
              if (value.isEmpty && required)
                return '!هذا الحقل مطلوب';
              else
                return null;
            },
          ),
        ),
        SizedBox(height: 20,)
      ],
    );

  }


static String TO_uint8list(Uint8List data) {
  return base64Encode(data);
}

 static Future<String>  compressImage(String path) async {
   print("________________");

   return await FlutterImageCompress.compressWithFile(
     path,
     //minWidth: 2300,
     //minHeight: 1500,
     quality: 44,
     rotate: 0,
   ).then((value){
     print("HHHHHHHHHHHHHHHHHHHHHHHHh");
     print(value.length);
     return MyUtilities.TO_uint8list(value);

   });

 }


}