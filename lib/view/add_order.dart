import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cevahir/database/database.dart';
import 'package:cevahir/models/inci.dart';
import 'package:cevahir/controller/inci_controller.dart';
import 'package:cevahir/models/material.dart';
import 'package:cevahir/controller/material_controller.dart';
import 'package:cevahir/models/order.dart';
import 'package:cevahir/models/order_controller.dart';
import 'package:cevahir/utilities/Utilities.dart';
import 'package:cevahir/view/homePage.dart';
import 'package:cevahir/view/show_model.dart';
import 'package:cevahir/view/text_style.dart';
import 'package:cevahir/view/total_details.dart';
import 'package:path/path.dart';

import 'createOrder2.dart';

class AddOrder extends StatefulWidget {
Map<String,dynamic> model={};
String type;

AddOrder(this.model,this.type);

  @override
  _AddOrderState createState() => _AddOrderState(this.model,this.type);
}

class _AddOrderState extends State<AddOrder> {
 Map<String,dynamic>model={};
 String type="";
 final form_key=GlobalKey<FormState>();
 TextEditingController qnty_controller=TextEditingController();
 TextEditingController price_controller=TextEditingController();

  _AddOrderState(this.model, this.type);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: (){
      FocusScope.of(context).requestFocus(FocusNode());
    },

      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.indigo.shade500,
          toolbarHeight: 80,
          title: Center(child: Text_Style(
              "إنشاء الطلبية", 22, Colors.white, "rtl")),
          actions: [
            IconButton(
                onPressed:(){
                  Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)
                  {
                    return ShowModl(model, "exist");
                  }));
                },
                icon: Icon(Icons.keyboard_arrow_right_outlined))
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
                      key:form_key,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                               child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              createTextField(qnty_controller,"العدد الإجمالي "),
                                              SizedBox(height:20 ),
                                              createTextField(price_controller,"المبلغ الإجمالي"),
                                            ]),


                                      ]
                                  ),
                                  SizedBox(height: 60),
                                  SizedBox(
                                    height: 60,
                                    width:200 ,
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
                                        child:Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(icon:Icon(Icons.arrow_back,color: Colors.white)),
                                            Text_Style("التالي",20,Colors.white,"rtl"),
                                          ],
                                        ) ,

                                        onPressed:(){
                                          int qnt=int.tryParse(qnty_controller.text.trim());
                                          double price=double.tryParse(price_controller.text.trim());
                                          if(!form_key.currentState.validate())
                                            return ;
                                          if(qnt==null || qnt<=0 || price==null || price<=0 )
                                          {
                                            MyUtilities.show_dialog_box("الرقم الذي قمت بإدخاله غير صحيح", context);
                                            return;

                                          }
                                          Order order=Order(0,qnt,price, model['model_id'], DateTime.now().toString());
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                            return CreateOrder2(model,order,[]);
                                          }));
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
            ),


      ),
    );
  }


 Widget create_text(String txt,Color color,double size) {
   return  Padding(
       padding:EdgeInsets.all(10),
       child:Center(child: Text_Style(txt,size,color,"rtl")));

 }

 Widget createTextField(TextEditingController _controller, String hint) {

   return Container(

     height:80,
     width:200 ,
     child: TextFormField(


       onChanged: (value){

       },
       keyboardType: TextInputType.number,
       textAlign:TextAlign.center ,
       style: TextStyle(
           fontSize: 18,
           color:Colors.black
       ),
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
         if (value.isEmpty )
           return '!هذا الحقل مطلوب';
         else
           return null;
       },
     ),
   );
 }
}

