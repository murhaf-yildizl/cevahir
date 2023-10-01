import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cevahir/database/database.dart';
import 'package:cevahir/models/recipt.dart';
import 'package:cevahir/controller/recipt_controller.dart';
import 'package:cevahir/utilities/Utilities.dart';
import 'package:cevahir/view/add_recipt_content.dart';
import 'package:cevahir/view/all_recipts.dart';
import 'package:cevahir/view/text_style.dart';

class AddRecipt extends StatefulWidget {
  int recipt_id;

   AddRecipt(this.recipt_id);


  @override
  _AddReciptState createState() => _AddReciptState(recipt_id);
}

class _AddReciptState extends State<AddRecipt> {
  int recipt_id;

  final formKey=GlobalKey<FormState>();
  TextEditingController origin_controller=TextEditingController();
  TextEditingController total_controller=TextEditingController();

  _AddReciptState(this.recipt_id);

  @override

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 100,
          backgroundColor: Colors.indigo,
          title: Center(child: Text_Style("فاتورة جديدة",20,Colors.white,"rtl")),
          actions: [
            IconButton(
                onPressed:(){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(contex){
                    return AllRecipts();
                  }));
                },
                icon:Icon(Icons.keyboard_arrow_right_outlined,size: 30)
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(top:50),
          child:Form(
          key: formKey,
          child: Center(
            child: ListView(
               children: [

              MyUtilities.addTextFormFeild(origin_controller,"المصدر", true, formKey,false,false),
              MyUtilities.addTextFormFeild(total_controller,"القيمة الإجمالية", true, formKey,true,false),
               SizedBox(height:30 ,),
              SizedBox(
                width: 200,
                height: 50,
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
                    child:Text_Style("إنشاء",18,Colors.white,"rtl") ,

                    onPressed:()async{
                      String origin=origin_controller.text.trim();
                      double total=double.tryParse(total_controller.text.trim());

                      if(!formKey.currentState.validate())
                        return ;
                      if(total==null || total<=0)
                      {
                        MyUtilities.show_dialog_box("الرقم الذي قمت بإدخاله غير صحيح", context);
                        return;

                      }
                      Recipt recipt=Recipt(origin,DateTime.now().toString(), total);
                      Map<String,dynamic>row=ReciptController.to_map(recipt);
                        await DataBaseHelper.insertToDataBase("recipt", row).then((value) {
                           if(value!=null && value>0)
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                              return AddReciptContent(value,"new");
                            }));
                        }) ;




                    }),
              ),
            ],),
          ),
        ) ,),
      ),
    );
  }
}
