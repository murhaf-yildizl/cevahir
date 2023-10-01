 import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cevahir/database/database.dart';
import 'package:cevahir/models/setting.dart';
import 'package:cevahir/utilities/Utilities.dart';
import 'package:cevahir/widgets/setting_interface.dart';
import 'package:cevahir/widgets/text_style.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/chat/v1.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'google_auth.dart';

const List<String>_scopes=[ga.DriveApi.driveScope];
const _clientId="1065305082033-vouquk37eu6hcqr14gvj2a0p7218lvdt.apps.googleusercontent.com";

class GoogleDrive {
  bool file_exist=false;
    var _client;
    var _drive;

  GoogleDrive.privateConstructor();
  static final GoogleDrive instance=GoogleDrive.privateConstructor();
  SharedPreferences pref;

  //Get Authenticated Http Client
 static Future<http.Client> getHttpClient() async {
    //Get Credentials
   final storage = SecureStorage();
    var credentials = await storage.getCredentials();

    if (credentials == null) {
      //Needs user authentication
      var authClient = await clientViaUserConsent(
          ClientId(_clientId),_scopes, (url) {
        //Open Url in Browser
        launch(url);
      });
      //Save Credentials
      await storage.saveCredentials(authClient.credentials.accessToken,
          authClient.credentials.refreshToken);
      return authClient;
    } else {
      print(credentials["expiry"]);
      //Already authenticated

      return authenticatedClient(
          http.Client(),
          AccessCredentials(
              AccessToken(credentials["type"], credentials["data"],
                  DateTime.tryParse(credentials["expiry"])),
              credentials["refreshToken"],
              _scopes));

    }
  }

  // check if the directory forlder is already available in drive , if available return its id
  // if not available create a folder in drive and return id
  //   if not able to create id then it means user authetication has failed
  Future<String> _getFolderId(ga.DriveApi driveApi) async {
    final mimeType = "application/vnd.google-apps.folder";
    String folderName = "cevahirDatabase";

     try {
       final found = await driveApi.files.list(
         q: "mimeType = '$mimeType' and name = '$folderName'",
         $fields: "files(id, name)",
       );
       final files = found.files;
        if (files == null) {
        print("Sign-in first Error!!!!!!!");
        return null;
      }

      // The folder already exists
      if (files.isNotEmpty) {
        file_exist=true;
        return files.first.id;
       }

      file_exist=false;
      // Create a folder
      ga.File folder = ga.File();
      folder.name = folderName;
      folder.mimeType = mimeType;
      final folderCreation = await driveApi.files.create(folder);
      print("Folder ID: ${folderCreation.id}");

      return folderCreation.id;
    } catch (e) {
      print("{{{{{{{{{{{{{{${e.toString()}");
      return null;
    }
  }


  uploadFileToGoogleDrive(File file, BuildContext context) async {
   _client = await getHttpClient();
    _drive = ga.DriveApi(_client);
    String folderId =  await _getFolderId(_drive);
    print("foldid=====$folderId");
         if(folderId == null){
           print("Sign-in first Error");
         }
         else {

           ga.File fileToUpload = ga.File();
          pref = await SharedPreferences.getInstance();
           //create file
           if(!file_exist)
           {
             fileToUpload.parents = [folderId];
             fileToUpload.name = p.basename(file.absolute.path);
              var respnse = await _drive.files.create(fileToUpload,
                 uploadMedia: ga.Media(file.openRead(), file.lengthSync()));
             pref.setString("file_id", respnse.id);


             MyUtilities.alertdialog(context,"تم الحفظ بنجاح!");
               }
           //update exist file
           else
           {
             String file_id=pref.getString("file_id");
             print("FILEID=$file_id");
            try
            {
            var response= await drive.files.update(fileToUpload, file_id).then((file11) {
              print("RESSSS=${file11}");
                MyUtilities.alertdialog(context, "تم الحفظ بنجاح!");
              });

            }catch(e){
              MyUtilities.show_dialog_box("لم يتم العثور على الملف!", context);
            }
           }

         }

   }

  Future<void> downloadGoogleDriveFile(String file_id,String fName) async {
    _client= GoogleDrive.instance.client;
    _drive=GoogleDrive.instance.drive;

      try {
        ga.Media file = await drive.files.get(
            file_id, downloadOptions: ga.DownloadOptions.fullMedia);

        final directory = await getApplicationDocumentsDirectory();

        final saveFile = File("${directory.path.substring(0,directory.path.length)}/$fName");
        print("-->>>${saveFile.path}");
        List<int> dataStore = [];
        file.stream.listen((data) {
          //print("DataReceived: ${data.length}");
          dataStore.insertAll(dataStore.length, data);
        }, onDone: () {
          print("Task Done");
          saveFile.writeAsBytes(dataStore).then((value) async {
            pref=await SharedPreferences.getInstance();
            pref.setString("db_path",saveFile.path);
            DataBaseHelper.set_database(saveFile.path);
          });

          //print("File saved at ${saveFile.path}");
        }, onError: (error) {
          print("Some Error");
        });
      }on Exception catch(e){
        print("-------------");
        print(e.toString());
        print("-------------");
      }

  }

  Future<ga.FileList> getFiles()async
  {

    _client=GoogleDrive.instance.client;
    _drive=GoogleDrive.instance.drive;

     final folderID=await _getFolderId(_drive);
     var files=await drive.files.list(spaces: 'drive',q:"'$folderID' in parents");
        print("XXXXXZZZZZ ${files.toString()}");
        if(files!=null)
          return files;



  }

   get drive{
   if(_drive!=null)
     return _drive;
    else initiate();

    }
    get client{
     if(_client!=null)
       return _client;
     else  initiate();

}

  Future<void> initiate()async {
   print("+++++++++++++++++++++++");
    _client = await getHttpClient();
    _drive = ga.DriveApi(_client);
 }



}

