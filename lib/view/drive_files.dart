import 'package:cevahir/apies/google_api.dart';
import 'package:cevahir/database/database.dart';
import 'package:cevahir/utilities/Utilities.dart';
import 'package:cevahir/view/text_style.dart';
 import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart';
//import 'package:googleapis/drive/v3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'homePage.dart';

class DriveFiles extends StatefulWidget {

  @override
  _DriveFilesState createState() => _DriveFilesState();
}

class _DriveFilesState extends State<DriveFiles> {
  FileList files;

  @override
  void initState() {
    // TODO: implement initState

     super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child:SingleChildScrollView(
          physics: ScrollPhysics(),
           scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            FutureBuilder(
                future:GoogleDrive.instance.getFiles(),
                builder:(BuildContext context,AsyncSnapshot<FileList>snapshot)
                {
                  if(snapshot.connectionState==ConnectionState.waiting)
                    return Center(child:CircularProgressIndicator());
                 else if(snapshot.hasData && !snapshot.hasError)
                 {
                    if (snapshot.data.files.length > 0)
                    {
                      files = snapshot.data;
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, position) {
                         print(files.files[position].createdTime) ;
                         //String dt=date.day.toString()+"-"+date.month.toString()+"-"+date.year.toString();
                            return ListTile(
                              title:Text_Style(files.files[position].name,18,Colors.black,"ltr") ,
                              trailing:Text_Style("",18,Colors.black,"ltr") ,
                              onTap:()async
                              {
                                  final pref=await SharedPreferences.getInstance();
                                  pref.setString("file_id",files.files[position].id);

                                GoogleDrive.instance.downloadGoogleDriveFile(files.files[position].id,files.files[position].name).then((value) {
                                 print("OKKKKKK");
                                  Navigator.push(context,MaterialPageRoute(builder:(context){
                                     return HomePage();
                                  }));
                                });



                              } ,
                            );
                        },
                        itemCount: files.files.length,
                      );
                    }
                    else if(snapshot.connectionState==ConnectionState.done)
                      return Center(child: Text("No data!!"));
                  }
                 return Container();
                }
            )
          ],),
        ) ,
      ),

    );
  }

}
