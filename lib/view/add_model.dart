import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart ';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cevahir/database/database.dart';
import 'package:cevahir/models/customer.dart';
import 'package:cevahir/controller/customer_controller.dart';
import 'package:cevahir/models/model.dart';
import 'package:cevahir/utilities/Utilities.dart';
import 'package:cevahir/utilities/connection.dart';
import 'package:cevahir/view/add_image.dart';
import 'package:cevahir/view/all_models.dart';
 import 'package:cevahir/view/homePage.dart';
import 'package:cevahir/view/show_model.dart';
import 'package:cevahir/view/showdetails.dart';
import 'package:cevahir/view/text_style.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../controller/model_controller.dart';
import 'add_customer.dart';
import 'all_customers.dart';
import 'create_drawer.dart';

class AddModel  extends StatefulWidget {
  Map<String, dynamic> model;
  String type="new";


  AddModel();
  AddModel.edit(this.model,this.type);

  @override
  _State createState() => _State(model,type);

}

class _State extends State {
  final _formkey=GlobalKey<FormState>();
  TextEditingController model_no_controller=TextEditingController();
  TextEditingController model_price_controller=TextEditingController();
   Model model;
  int model_id=-1;
  List<Customer> customerlist=[];
  Customer selecteduser;
  bool no_selected_item=false;
  String type="new";
  Map<String,dynamic>item;
  bool nomune=false;

  _State(this.item,this.type){

  }

  @override
  void initState()  {
    print("type=$type");
    if(type=="exist")
      {
        if(item['nomune']=="yes")
          this.nomune=true;
     else this.nomune=false;
        model_no_controller.text=item['model_no'];
        if(item['price']==null || item['price']=="null")
         model_price_controller.text=" ";
   else  model_price_controller.text=item['price'].toString();

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
        appBar:AppBar(
          backgroundColor:Colors.indigo.withOpacity(0.9),
          title:Center(child: Text_Style("معلومات الموديل",24,Colors.white,"rtl")) ,
          toolbarHeight: 100,
        ) ,
        drawer: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.lightBlue.shade100,

            ) ,

            child:CreateDrawer(["الصفحة الرئيسية","سجل الموديلات","إضافة زبون","إحصائيات"],[HomePage(),AllModels(),AddCustomer(null)])
        ),

        body:Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              padding: EdgeInsets.all(8),
                  child: Form(
                  key: _formkey,
                    child:Center(
                      child: Container(
                        height:600 ,
                        margin: EdgeInsets.all(10),
                        child: ListView(
                          children: [
                          MyUtilities.addTextFormFeild(model_no_controller, "رقم الموديل",true,_formkey,true,false),
                          MyUtilities.addTextFormFeild(model_price_controller, "السعر",false,_formkey,true,false),

                         SizedBox(height:10),
                         Row(
                             mainAxisAlignment:MainAxisAlignment.center,
                             children:[
                               no_selected_item? Icon(Icons.error_outline,size:30,color:Colors.red):Container() ,
                               SizedBox(width:20 ),
                               dropdown_button()
                             ]),
                         SizedBox(height:10),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Checkbox(value: this.nomune, onChanged:(val) {
                               setState(() {
                                  this.nomune=val;

                               });
                             }),
                             Text_Style("نومونيه", 18, Colors.black, "rtl")
                           ],
                         )
                            ]
                      )
                   ),
                    )
                  )
                ),
          ),
        ),

          bottomNavigationBar:Offstage(
          offstage:false ,
          child:Container(
               height: 100,
              padding:EdgeInsets.all(10) ,
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        IconButton(icon:Icon(Icons.save,color:Colors.blue.shade500,size: 30,),
                            onPressed:(){

                            _formkey.currentState.save();

                               if(_formkey.currentState.validate())
                              {
                                setState(() {
                                  if (selecteduser == null) {
                                    no_selected_item = true;
                                    return 0;
                                  }

                                  double price=double.tryParse(model_price_controller.text);
                                  if(price==null)
                                    {
                                      MyUtilities.show_dialog_box("الرقم المدخل غير صحيح",context);
                                      return 0;
                                     }


                              if(type=="exist")
                                {
                                  model = Model.constructor(
                                        model_no_controller.text,price,selecteduser,
                                        item['date'],nomune?"yes":"no");
                                     DataBaseHelper.update("UPDATE models SET nomune='${model.nomune}',model_no='${model.model_no}',price='${model.price}',customer_id='${model.customer.id}',date='${model.date}' WHERE model_id=${item['model_id']}")
                                      .then((value) async {
                                       alertdialog(context, "تم الحفظ بنجاح");
                                  });
                                }

                                  else {
                                        model = Model.constructor(
                                        model_no_controller.text,price,selecteduser,DateTime.now().toString(),nomune?"yes":"no");
                                        DataBaseHelper.insertToDataBase("models", ModelController.to_map(model))
                                        .then((value) async {
                                          model_id = value;
                                  if (model_id > 0 && model_id != null)
                                        alertdialog(context, "تم الحفظ بنجاح");



                                                                        });
                                      }


                                });
                              }

                            } ),
                         Text_Style("حفظ", 16,Colors.black,"rtl")

                      ],
                    ),
                   )
      ) ,
      ),
    );
  }

  Widget   dropdown_button()
  {
    if(!customerlist.isEmpty)
      return create_dropdownbutton();

    else return  FutureBuilder(
      future:DataBaseHelper.import_from_dadabase("SELECT * FROM customers ORDER BY name") ,
      builder:(BuildContext context,AsyncSnapshot<List<Map<String,dynamic>>> snapshot)
      {

        if ((snapshot.hasData && snapshot.data.length>0 && snapshot.error ==null) || !customerlist.isEmpty) {

          customerlist = CustomerController.toCustomerList(snapshot.data);

          if(type=="exist")
          customerlist.forEach((element) {
             if(element.id==item['customer_id'])
               selecteduser=element;
           });
          return create_dropdownbutton();

        }

        else return  Text_Style("لا يوجد زبائن بعد", 16, Colors.pink, "rtl");


      } ,
    );
  }

  Widget create_dropdownbutton() {
    return DropdownButton(
      //dropdownColor: Colors.redAccent,

        focusColor:Colors.blue ,
        hint: Text("...حدد اسم الشركة",textAlign:TextAlign.center,style: TextStyle(fontSize: 18,color: Colors.indigo,fontWeight: FontWeight.bold,letterSpacing: 3 )),
        value: selecteduser,
        onChanged: (val){
          setState(() {
             selecteduser=val;
            if(selecteduser!=null)
              no_selected_item=false;
          });
         },
        items: (

               customerlist.map((e) {
              return DropdownMenuItem(
                  value:e,
                  child: Container(
                      width: 150,
                       height: 30,
                       child: Container(
                         color:Colors.indigo,
                         child: Center(
                           child: Text(e.name.toString().toUpperCase(),textAlign:TextAlign.center,style: TextStyle(fontSize:18,color: Colors.white,fontWeight: FontWeight.bold )
                      ),
                         ),
                       )
                  ),
                        );
            }).toList())
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
        if(type=="exist")
         model_id=item['model_id'];

        if(model_id==null)
          model_id=-1;

         Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context){
            return ShowModl({'model_id':model_id,'model_no':model.model_no,'name':nomune?"":selecteduser.name},type) ;
          }));
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

