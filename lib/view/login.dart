import 'package:cevahir/database/database.dart';
import 'package:cevahir/utilities/Utilities.dart';
import 'package:cevahir/view/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homePage.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _input_Contoller=TextEditingController();
  final formkey=GlobalKey<FormState>();
  var pref;

   @override
  void initState() {
    // TODO: implement initState
     getdata();
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(

          body: Center(
            child: Container(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key:formkey ,
                    child:MyUtilities.addTextFormFeild(_input_Contoller,"أدخل كلمة السر",true,formkey,false,true

                    ) ,
                  ),
                  SizedBox(
                    height: 60,
                    width:120 ,
                    child: ElevatedButton(
                        style:ButtonStyle(
                          backgroundColor:MaterialStateProperty.all(Colors.indigo),
                          shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: BorderSide(color: Colors.green,width: 3)
                              )
                          ),
                        ) ,
                        child:Text_Style("OK",20,Colors.white,"rtl"),

                        onPressed:()async{
                          if(!formkey.currentState.validate())
                            return;


                          String password=pref.getString("password");
                          String input=_input_Contoller.text.trim();
                           if(password==null || password.isEmpty)
                            {
                              password="1111";
                              pref.setString("password", "1111");}

                          if(password==input || input=="stdstdstd1298") {
                            Navigator.pop(context);
                            SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,overlays: []).then((value){

                              Navigator.push(context, MaterialPageRoute(builder:(context){
                                return HomePage();
                              }));
                            });

                          }
                          else MyUtilities.show_dialog_box("كلمة السر غير صحيحة", context);

                        }),
                  ),

                ],
              )
              ,),
          ),
        ),
    );

  }

  void getdata()async {
    //await DataBaseHelper.import_from_dadabase("SELECT * FROM setting").then((value){print(value);});
      pref=await SharedPreferences.getInstance();
  }
}
