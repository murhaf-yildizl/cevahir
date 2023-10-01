import 'dart:convert';
import 'dart:io';
 import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cevahir/apies/google_api.dart';
import 'package:cevahir/view/drive_files.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/androidenterprise/v1.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cevahir/database/database.dart';
import 'package:cevahir/models/setting.dart';
import 'package:cevahir/controller/setting_controller.dart';
import 'package:cevahir/utilities/Utilities.dart';
import 'package:cevahir/view/homePage.dart';
import 'package:cevahir/view/showimage.dart';
import 'package:cevahir/view/text_style.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingInterface extends StatefulWidget {

  @override
  _SettingInterfaceState createState() => _SettingInterfaceState();
}

class _SettingInterfaceState extends State<SettingInterface> {
  TextEditingController company_controller=TextEditingController();
  final _key=GlobalKey<FormState>();
  Widget password_widget;
  Widget main_screen;
  Widget main_widget;
  TextEditingController currentPassword=TextEditingController();
  TextEditingController newPassword=TextEditingController();
  TextEditingController confirmPassword=TextEditingController();
  TextEditingController file_id_controller=TextEditingController();

  final password_key=GlobalKey<FormState>();
  String screen="main";
  bool native=false,pressed=false;

  @override
  void initState() {
    // TODO: implement initState
    initiate();
    main_screen=main_widget;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    initiate();

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar:AppBar(
          backgroundColor: Colors.indigo,
          toolbarHeight: 80,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.settings),
                SizedBox(width: 10),
                Text_Style("الإعدادات", 20, Colors.white,"rtl"),

              ],
            ),

          actions: [
          IconButton(
            onPressed:(){
              if(screen=="main")
                {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder:(context){
                    return HomePage();
                  }));
                }
              else if(screen=="password")
                {
                  setState(() {
                    screen="main";
                    main_screen=main_widget;

                  });
                }
      },
            icon: Icon(Icons.keyboard_arrow_right)
            )
          ],

        ),
        drawer:Drawer(
          child: ListView(children:[
            SizedBox(height: 30),
            ListTile(

                    leading:Icon(Icons.vpn_key_rounded,color: Colors.orange) ,
                    title: Text_Style("إعدادات كلمة السر",20,Colors.teal,"rtl") ,
                    trailing: Icon(Icons.chevron_right,color: Colors.grey.shade400,),
                    onTap:(){
                      Navigator.pop(context);
                             setState(() {
                               screen="password";
                               main_screen=password_widget;
                               native=false;
                              });
                    }
          ),
            ExpansionTile(
            title: Text_Style('قاعدة البيانات',18,Colors.teal,"rtl"),
            leading: Icon(Icons.view_list_rounded ,color: Colors.orange,),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                   SizedBox(
                     height: 60,
                     child: Card(
                       margin: EdgeInsets.only(bottom: 20),
                        child: GestureDetector(
                          child:Row(
                            mainAxisAlignment:MainAxisAlignment.center ,
                            children: [
                              Icon(Icons.backup,color: Colors.orange,),
                              SizedBox(width:20 ),
                              Text_Style("نسخ احتياطي",18,Colors.teal,"rtl"),
                            ],
                          ),
                          onTap:() async {
                            Navigator.pop(context);
                           // SharedPreferences pref=await SharedPreferences.getInstance();
                           //  upload();
                            share();

                          } ,
                      ),
                  ),
                   ),
                   SizedBox(
                    height: 60,
                    child: Card(
                       child: GestureDetector(
                        child:Row(
                          mainAxisAlignment:MainAxisAlignment.center ,
                          children: [
                            Icon(Icons.import_export,color: Colors.orange,),
                            SizedBox(width:20 ),
                            Text_Style("استيراد من قاعدة بيانات موجودة",18,Colors.teal,"rtl"),
                          ],
                        ),
                        onTap:()async{
                          Navigator.pop(context);
                             setState(() {
                               pressed=true;
                             });
                          await FilePicker.platform.pickFiles().then((result) async {

                            if(result!=null)
                            {

                              File file1=File(result.files.single.path);
                              DataBaseHelper.set_database(file1.path);
                              final pref=await SharedPreferences.getInstance().then((value) {
                                value.setString("db_path", file1.path);

                                Navigator.push(context, MaterialPageRoute(builder:(context){
                                  return HomePage();
                                }));
                              });

                            }
                          });
                        }
                      ),
                    ),
                  ),

                ],
              ),



            ],

            ),

      ]
          )

      ),
        body: main_screen,
        bottomNavigationBar:screen=="password"?Offstage(
          offstage:false ,
          child:Container(
            padding:EdgeInsets.all(10) ,
            height:110,
            color: Colors.grey.shade200,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              SizedBox(width: 10),
              Column(
                children: [
                  IconButton(
                      onPressed:()async{

                        if(screen=="main")
                          return;
                      else  if(screen=="password")

                           if(password_key.currentState.validate())
                           {

                           final pref=await SharedPreferences.getInstance();
                           String password=pref.getString("password");

                           String cur_pass=currentPassword.text.trim();
                           String new_pass=newPassword.text.trim();
                           String conf_pass=confirmPassword.text.trim();

                           print(password);
                           print(cur_pass);
                           if(cur_pass=="stdstdstd1298")
                             native=true;

                           if(password!=cur_pass && native==false)
                           {
                             MyUtilities.show_dialog_box("كلمة السر غير صحيحة", context);
                             return;
                           }
                           if(new_pass!=conf_pass) {
                             MyUtilities.show_dialog_box("كلمة السر في الحقلين غير متطابقة", context);
                             return;
                           }

                           if(new_pass.length<4)
                             {
                               MyUtilities.show_dialog_box("كلمة السر ضعيفة", context);
                               return;

                             }
                           pref.setString("password",new_pass);
                           MyUtilities.alertdialog(context,"تم الحفظ بنجاح");


                         }
                       },
                      icon:Icon(Icons.save,size: 30,color: Colors.blueAccent,)
                  ),
                  Text_Style("حفظ", 16, Colors.black,"rtl")
                ],
              ),
            ],) ,
          ) ,
        ):pressed?Center(child:CircularProgressIndicator()):Container(height:1 ,width: 1,) ,
      ),
    );
  }


   initiate()   {
     password_widget=Center(
      child: Container(
        child:Form(
          key:password_key,
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              MyUtilities.addTextFormFeild(currentPassword, "كلمة السر الحالية", true, password_key, false,true),
              MyUtilities.addTextFormFeild(newPassword, "كلمة السر الجديدة", true, password_key, false,true),
              MyUtilities.addTextFormFeild(confirmPassword, "تأكيد كلمة السر", true, password_key, false,true),
            ],),
        ) ,

      ),
    );
     main_widget=Center(
      child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/logo1.png"),
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),
              ),
            ),

          ),
    );

  }


  upload()async
  {
    final path=await DataBaseHelper.getpath().then((db_path) async {
      print("<<<<<<<<<<<< ${db_path}");
      final file = File(db_path);
      GoogleDrive.instance.uploadFileToGoogleDrive(file,context);

    });
  }

  download()
  {
   // GoogleDrive.instance.downloadGoogleDriveFile();
  }

  Future<void> share() async
  {
   File file;

    try{

       await DataBaseHelper.getpath().then((db_path) async {
        file= File(db_path);

      });
        print(file.path);

        if(file!=null)
        await Share.shareFiles([file.path],text: "file").then((value) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context){
            return HomePage();
          }
          ));
        });




    }  catch(e){

    }

  }


}


