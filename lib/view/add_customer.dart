import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cevahir/database/database.dart';
import 'package:cevahir/models/customer.dart';
import 'package:cevahir/controller/customer_controller.dart';
import 'package:cevahir/utilities/Utilities.dart';
import 'package:cevahir/view/add_model.dart';
import 'package:cevahir/view/all_customers.dart';
import 'package:cevahir/view/all_models.dart';
import 'package:cevahir/view/create_drawer.dart';
import 'package:cevahir/view/text_style.dart';
import 'package:sqflite/sqflite.dart';
import 'homePage.dart';

class AddCustomer extends StatefulWidget
{
  Customer customer;
  AddCustomer(this.customer);


  @override
   createState()=>AddCustomerPageState(customer);
}

class AddCustomerPageState extends State{

  final _formkey=GlobalKey<FormState>();
  TextEditingController namecontroller=TextEditingController();
  TextEditingController phonecontroller=TextEditingController();
  TextEditingController addresscontroller=TextEditingController();
  Database database;
  bool finished=false;
  Customer customer;
  AddCustomerPageState(this.customer);

@override
  void initState() {
    // TODO: implement initState
   if(customer!=null)
     {
     namecontroller.text=customer.name;
     phonecontroller.text=customer.phone;
     addresscontroller.text=customer.address;
     }
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
           title: customer==null?Center(child: Text_Style("إضافة زبون جديد",22,Colors.white,"rtl")):Center(child: Text_Style("تعديل البيانات",22,Colors.white,"rtl")),
          toolbarHeight: 100,
          backgroundColor:Colors.indigo.withOpacity(0.9),
        ),
        drawer:CreateDrawer(["الزبائن","إضافة موديل","صفحة الموديلات","الرئيسة"],[AllCustomers(),AddModel(),AllModels(),HomePage()]) ,

        body: Container(
              alignment:Alignment.topCenter ,
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                       child: Container(
                         width:double.infinity ,
                          child: Form(
                  key:_formkey ,
                            child:Column(children: [
                              MyUtilities.addTextFormFeild(namecontroller, "الاسم",true,_formkey,false,false),
                              MyUtilities.addTextFormFeild(phonecontroller, "رقم الهاتف (اختياري)",false,_formkey,true,false),
                              MyUtilities.addTextFormFeild(addresscontroller,"العنوان (اختياري)",false,_formkey,false,false),
                              SizedBox(height: 50),
                              SizedBox(
                                  height:50 ,
                                  width:200 ,
                                  child: TextButton(
                                      style:ButtonStyle(
                                          shape:MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                              borderRadius:BorderRadius.circular(50) ,
                                              side: BorderSide(color: Colors.teal,width: 3)
                                          ))
                                      ) ,
                                      child:Text_Style("حفظ",18,Colors.teal,"rtl"),
                                      onPressed: (){
                                        if(_formkey.currentState.validate())
                                        {


                                          Customer cust=Customer.constructor(0,namecontroller.text, phonecontroller.text,addresscontroller.text,Icons.ac_unit.toString());

                                          Map<String,dynamic>row=CustomerController.to_map(cust);
                                          if(customer==null)
                                            DataBaseHelper.insertToDataBase("customers", row);
                                          else DataBaseHelper.update("UPDATE customers SET name='${namecontroller.text}',phone='${phonecontroller.text}',address='${addresscontroller.text}' WHERE customer_id=${customer.id}");

                                          alertdialog(context, "تم الحفظ بنجاح");

                                          //   !finished? timer():null;
                                        }


                                      }
                                  )
                              ),
                            ]
                            ),
                  ),
                       ),
                    ),
            ),

          ),
    );

  }

  alertdialog(BuildContext context,String text)
  {

    AwesomeDialog(
      context: context,
      customHeader:Icon(Icons.check_circle,color: Colors.green,size:60) ,

      dialogType: DialogType.SUCCES,
      borderSide: BorderSide(color: Colors.green, width: 2),
      buttonsBorderRadius: BorderRadius.all(Radius.circular(1)),
      headerAnimationLoop: true,
      //autoHide:Duration(seconds: 2) ,
      animType: AnimType.SCALE,

      body:Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text_Style(text,18,Colors.red,"rtl"),
        ),
      ) ,
      //desc: 'USER_NOT_FOUND',
      //showCloseIcon: true,
      btnOk:TextButton(child:Text_Style("OK",18,Colors.black,"ltr") ,
                       onPressed: (){
                         Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context)
                         {
                           return AllCustomers();
                         } ));
                       },
      style: ButtonStyle(
       shape:MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
       borderRadius:BorderRadius.circular(50) ,
       side: BorderSide(color: Colors.teal,width: 3)
      )
       )
      ),

                   ),


    ).show();

  }

  }


