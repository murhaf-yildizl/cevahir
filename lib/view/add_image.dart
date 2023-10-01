import 'dart:async';
import 'dart:convert';
 import 'dart:io';
import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:camera/camera.dart';
import 'package:cevahir/utilities/Utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cevahir/database/database.dart';
import 'package:cevahir/models/image.dart';
import 'package:cevahir/controller/image_controller.dart';
import 'package:cevahir/models/model.dart';
import 'package:cevahir/utilities/connection.dart';
import 'package:cevahir/view/add_model.dart';
import 'package:cevahir/view/all_models.dart';
 import 'package:cevahir/view/homePage.dart';
import 'package:cevahir/view/showimage.dart';
import 'package:cevahir/view/text_style.dart';
import 'package:page_view_indicator/page_view_indicator.dart';
import 'all_orders.dart';
import 'camera.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class AddImage extends StatefulWidget {
  int model_id;
  Map<String,dynamic> model={};
  String type;

  AddImage(this.model_id,this.type);

  AddImage.constructor(this.model,this.type){
    this.model_id=model['model_id'];
  }

  @override
   createState() =>model.length<1?_MyAppState(model_id,type):_MyAppState.constructor(model,type);
}

class _MyAppState extends State{
  String img_path="";
   ValueNotifier<int> pageIndexNotifier= ValueNotifier(0);
  List<ImageDetails> images=[];
  Map<String,dynamic> model={};
  PageController pageController=PageController(initialPage:0);
  TextEditingController  _input_Contoller=TextEditingController();
  final formkey=GlobalKey<FormState>();
  String type;
  int model_id;
  List<ImageDetails> renamed_images=[];
  bool pressed=false;

  _MyAppState(this.model_id,this.type);

  _MyAppState.constructor(this.model,this.type){this.model_id=model['model_id'];}


    @override
  Widget build(BuildContext context) {
     return  Scaffold(
          body: Container(

            color: Colors.white,
            child: Column(
          children: <Widget>[

         images.length>0? FutureBuilder(
             future: getimages(),
             builder:(BuildContext context,AsyncSnapshot <List<ImageDetails>> snapshot)
             {
               return build_images(snapshot);

             }
         ):
         FutureBuilder(
            future:type=="setting"?DataBaseHelper.import_from_dadabase("SELECT * FROM start_images"):
            DataBaseHelper.import_from_dadabase("SELECT * FROM images WHERE model_id=$model_id") ,
              builder:(BuildContext context,AsyncSnapshot <List<Map<String,dynamic>>> snapshot){

                if(snapshot.connectionState==ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
              else   if (snapshot.hasData && snapshot.error ==null)
                {
                    if( snapshot.data.length >0)
                      images = ImageController.to_image(snapshot.data);
                }

                 else  if(snapshot.connectionState==ConnectionState.done)
                        if(!snapshot.hasData)
                            return Center(
                       child: Padding(
                           padding: EdgeInsets.only(top:50),
                           child:Text_Style("لا يوجد صور بعد",18,Colors.red,"rtl")
                       ));

                return build_images(snapshot);


              }

              ),
                 ]
               )),
           // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar:Offstage(
            offstage:false ,
            child:Container(

             height: 100,
             padding:EdgeInsets.all(10) ,
             child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [


               Column(

                 children: [
                   IconButton(icon:Icon(Icons.save,color:Colors.blue.shade500),
                       onPressed:(){
                         if(images.length<1)
                           return;
                         print("type: size=${images.length}");
                         List<Map<String,dynamic>>rowlist = ImageController.tomap(images);


                         rowlist.forEach((row) {

                           if(row.length>0)
                             if(row['image_id']==null || row['image_id']==0)
                               type=="setting"?DataBaseHelper.insertToDataBase("start_images", row):DataBaseHelper.insertToDataBase("images", row);

                           renamed_images.forEach((ImageDetails element) {
                             if(element.image_id!=0)
                              type=="setting"? DataBaseHelper.update("UPDATE start_images SET title='${element.title}' WHERE image_id=${element.image_id}"):DataBaseHelper.update("UPDATE images SET title='${element.title}' WHERE image_id=${element.image_id}");
                           });
                         }

                         );
                         saved(context);

                         setState(() {
                           images=[];
                           renamed_images=[];
                         });
                       }
                   ),
                   Text_Style("حفظ", 16,Colors.deepPurple,"rtl")

                 ],
               ),
              FloatingActionButton(
                child:PopupMenuButton(
                     onSelected:(value)async {
                     if (value == 1) {
                       final cameras = await availableCameras().then((value) {
                         final firstcamera = value.first;

                         Navigator.of(context).push(
                             MaterialPageRoute(builder: (context) {
                               return CameraTest(firstcamera, this.model,type);
                             }));
                       });
                     }
                else if (value == 2) {
                       String path="";
                        await ImagePicker().pickImage(
                           source: ImageSource.gallery).then((image) async{
                         if(image!=null)
                           {
                             print("========================");
                               var bytes= File(image.path).readAsBytesSync();
                               print(bytes.length);
                                    if(bytes.length>300000)
                                      {
                                        path=await MyUtilities.compressImage(image.path) ;


                                      }
                              else  path=MyUtilities.TO_uint8list(bytes);

                              if(path!=null && path.isNotEmpty)
                               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                                 return ShowImage(path, this.model,type);
                               }));


                           }
                       });

                     }
                   },

                   icon: Icon(Icons.camera_alt),
                   itemBuilder:(context)=>[
               PopupMenuItem(
                 child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children:[
                         IconButton(icon:Icon(Icons.camera_alt,color: Colors.deepPurple,)),
                         Text_Style("الكاميرا",16,Colors.deepPurple,"rtl"),

                          ]
                          ),
                 value: 1,),
               PopupMenuItem(
                   child:Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                       children:[
                     IconButton(icon:Icon(Icons.image_outlined,color: Colors.deepPurple,)),
                     Text_Style("الإستديو",16,Colors.deepPurple,"rtl"),

                   ]
                   ),
                 value: 2,)

               ]
               )
              ),
             Row(children: [


                      Column(

                        children: [
                          IconButton(icon:Icon(Icons.chevron_right,color:Colors.blue.shade500),
                              onPressed:(){
                               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                                 if(type=="new")
                                   return AddModel();
                            else if(type=="exist")
                                   return AllModels();
                           else if(type=="allorders")
                                   return AllOrders();
                          else if(type=="setting")
                            return HomePage();



                               }));


                              } ),
                          Text_Style("رجوع", 16,Colors.deepPurple,"rtl")

                        ],
                      )
                    ])

                 ],
               )
       )
     )
    );




  }

Widget  build_images(var snapshot)
  {
      if(snapshot.hasData && snapshot.connectionState==ConnectionState.done)
    {

      return Flexible(
        child: PageView.builder(

            controller: pageController,
            itemBuilder: (context,index)
            {
               return SingleChildScrollView(
                 scrollDirection: Axis.vertical,
                  child: Column(
                     children:[
                      Stack(children: [
                          Container(
                            padding:EdgeInsets.all(10) ,
                              height:MediaQuery.of(context).size.height*0.8,
                              width: MediaQuery.of(context).size.width,
                              child:Image.memory(base64Decode(images[index].url),fit: BoxFit.cover)
                          ),
                          Positioned.fill(child: Material(
                            color:Colors.transparent,
                            child:InkWell(

                              onLongPress: (){
                                showpopupmenu(index);
                              },
                              onTap:(){
                                // ind=index;
                              } ,

                            ) ,
                          ))
                        ]
                      ),

                   _pageindicator(images.length),
                   Text_Style( images[index].title, 24, Colors.red,"rtl")
                    ],

              ),
                );

            },
            itemCount: snapshot.data.length,
            onPageChanged: (index) {

              pageIndexNotifier.value = index;

            }
        ),
      );
    }
     else return Container();

  }


  Widget _pageindicator(int length) {
   return  PageViewIndicator(
      pageIndexNotifier: pageIndexNotifier,
      length: length,

      normalBuilder: (animationController, index) => Circle(
        size: 12.0,
        color: Colors.black,
      ),
      highlightedBuilder: (animationController, index) => ScaleTransition(
        scale: CurvedAnimation(
          parent: animationController,
          curve: Curves.ease,
        ),
        child: Circle(
          size: 12.0,
          color: Colors.red,
        ),
      ),
    );
  }

  Future<List<ImageDetails>>getimages() async
  {
    return await images;
  }

  deleteDialog(BuildContext context,int index)
  {

  AwesomeDialog(
  context: context,
  customHeader:Column(children: [
  Icon(Icons.error_outline_sharp,color: Colors.red,size:60) ,
  Text_Style("تحذير", 22, Colors.red,"rtl")
  ]
  ),
  dialogType: DialogType.ERROR,
  borderSide: BorderSide(color: Colors.green, width: 2),
  buttonsBorderRadius: BorderRadius.all(Radius.circular(1)),
  headerAnimationLoop: true,
  // autoHide:Duration(seconds: 3) ,
  animType: AnimType.SCALE,
  title: 'تحذير هام',
  body:Center(
  child: Padding(
  padding: const EdgeInsets.all(10),
  child: Text_Style("سوف يتم حذف هذه الصورة نهائياً من الهاتف",16,Colors.red,"rtl"),
  ),
  ) ,
  //desc: 'USER_NOT_FOUND',
  //showCloseIcon: true,
  btnCancelOnPress: () {},
  btnOkOnPress: () {
  setState(() {

  if(images[index].image_id!=0)
  type=="setting"?DataBaseHelper.delete("DELETE FROM start_images WHERE image_id=${images[index].image_id}"):
  DataBaseHelper.delete("DELETE FROM images WHERE image_id=${images[index].image_id}");
  images.removeAt(index);
  });
  },


  ).show();

}


  String renameDialog(BuildContext context,int index)      {
    String title="";

    Widget cancelbutton=TextButton(
        style: ButtonStyle(
            backgroundColor:MaterialStateProperty.all(Colors.grey.shade200 ,
            )),
        onPressed: (){
        Navigator.pop(context);},
        child:Text_Style("إلغاء الأمر",18,Colors.black,"rtl"));

    Widget okbutton=TextButton(
        style: ButtonStyle(
            backgroundColor:MaterialStateProperty.all(Colors.grey.shade200 ,
            )),
        onPressed: (){
              title=_input_Contoller.text;
              if(!formkey.currentState.validate())
                return;
              Navigator.pop(context);
              setState(() {
                images[index].title=title;

                if(!renamed_images.contains(images[index]))
                    renamed_images.add(images[index]);
              });
                },
          child:Text_Style("موافق",18,Colors.black,"rtl"));

    AlertDialog alert=AlertDialog(
      title: Center(child:Text("إعادة تسمية")),
      content:Form(
        key:formkey,
        child: TextFormField(
             controller:_input_Contoller,
          decoration:InputDecoration(
            hintText: ("...أدخل الاسم")),
            textAlign:TextAlign.right  ,
            validator:(value){
               if(value.isEmpty)
                 return "يجب أن تدخل قيمة";

            } ,

        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            cancelbutton,
            SizedBox(width:20),
            okbutton,
          ],)
      ],
    );

    showDialog(context: context, builder: (BuildContext context){
      return alert;
    });
    return title;
  }
  void showpopupmenu(int index)async {
    await showMenu(

        context: context,
         position: RelativeRect.fromLTRB(100, 250,150, 100),
        items:[
          PopupMenuItem(
              value:1,
              child:Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                Icon(Icons.delete,color: Colors.deepPurpleAccent,),
                SizedBox(width:10),
                Text_Style("حذف",18,Colors.deepPurpleAccent,"rtl")

            ])
            ),
          PopupMenuItem(
              value:2,
              child:Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                Icon(Icons.drive_file_rename_outline,color: Colors.deepPurpleAccent,),
                SizedBox(width:10),
                Text_Style("...إعادة تسمية",18,Colors.deepPurpleAccent,"rtl")

              ])
          ),
        ],
        color:Colors.white
    ).then((value){
          if(value==1)
            {

              deleteDialog(context,index);
         }
          else if(value==2)
            {
              print(renameDialog(context,index));

            }
    });

  }


  saved(BuildContext context)
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
          child: Text_Style("تم الحفظ بنجاح",18,Colors.red,"rtl"),
        ),
      ) ,
      //desc: 'USER_NOT_FOUND',
      //showCloseIcon: true,
    ).show();

  }

}