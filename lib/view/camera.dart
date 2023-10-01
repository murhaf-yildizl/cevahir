import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cevahir/utilities/Utilities.dart';
import 'package:cevahir/view/homePage.dart';
import 'package:cevahir/view/show_model.dart';
import 'package:cevahir/view/text_style.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:cevahir/controller/customer_controller.dart';
import 'package:cevahir/view/showimage.dart';

class CameraTest extends StatefulWidget {
   Map<String, dynamic> model;
   CameraDescription cameraDescription;
   String type;

   CameraTest(this.cameraDescription,this.model,this.type);

  @override
  CameraTestState createState() =>CameraTestState(cameraDescription,this.model,this.type);
}

class CameraTestState extends State<CameraTest> {
   CameraController _cameraController;
   Future<void>initializecontroller;
   CameraDescription camera;
   Map<String, dynamic> model;
   String type;

   CameraTestState(this.camera,this.model,this.type );

   @override
  void initState() {
    // TODO: implement initState
     try {
       print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++   $type");
       _cameraController = CameraController(camera, ResolutionPreset.medium);
       initializecontroller = _cameraController.initialize();
     }catch(e){}

    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _cameraController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight:100 ,
        backgroundColor: Colors.indigo,
        title: Center(child: Text_Style("الكاميرا",20,Colors.white,"")),
        actions: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Align(
              alignment: Alignment.center,
              child: FloatingActionButton.extended(
                heroTag: "camera",
                  onPressed:()
                      {

                           Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context){

                             switch(type)
                             {
                               case "setting":{return HomePage();break;}
                               default:{return ShowModl(model, type);}
                              }

                           }));
                      },
                label: Text_Style("رجوع",18,Colors.white,"ltr"),
                icon:Icon(Icons.keyboard_arrow_right) ,
               elevation:20 ,


              ),
            ),
          )
        ],
      )   ,
      body: Container(
        color: Colors.red.withOpacity(0.2),
        alignment: Alignment.center,
        padding: EdgeInsets.all(15),
        child: FutureBuilder(
          future:initializecontroller ,
          builder:(context,snapshot) {
            if(snapshot.connectionState==ConnectionState.done)
              return CameraPreview(_cameraController);
            else return Center(child:CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton:Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(

          child:Icon(Icons.camera) ,
          onPressed:()async{
            try {
              await initializecontroller;
              await _cameraController.takePicture().then((image) {
                if (image != null)
                {
                   String path = "";
                    image.readAsBytes().then((bytes) async {
                    print("lenttttttttttt=${bytes.length}");

                    if(bytes.length>300000)
                      path=await MyUtilities.compressImage(image.path);
               else   path = MyUtilities.TO_uint8list(bytes);

                    if(path!=null && path.isNotEmpty)
                  Navigator.of(context).push(MaterialPageRoute(builder: (
                        context) {
                      return ShowImage(path, model, type);
                    }));

                  });

                }
              }
                );


            }
            catch(e)

            {
              print(e);
            }
            } ,

        ),
      ) ,


    );
  }


}
