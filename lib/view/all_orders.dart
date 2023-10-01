import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cevahir/database/database.dart';
import 'package:cevahir/models/customer.dart';
import 'package:cevahir/controller/customer_controller.dart';
import 'package:cevahir/models/material.dart';
import 'package:cevahir/controller/material_controller.dart';
import 'package:cevahir/models/order.dart';
import 'package:cevahir/models/order_controller.dart';
 import 'package:cevahir/utilities/Utilities.dart';
import 'package:cevahir/utilities/connection.dart';
import 'package:cevahir/view/add_model.dart';
import 'package:cevahir/view/all_models.dart';
import 'package:cevahir/view/create_drawer.dart';
import 'package:cevahir/view/homePage.dart';
import 'package:cevahir/view/show_model.dart';
import 'package:cevahir/view/text_style.dart';

class AllOrders extends StatefulWidget {

  @override
  _AllOrdersState createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  List<Map<String,dynamic>>orders=[];
  TextEditingController textcontoller=TextEditingController();
  String key=" ORDER BY order_id DESC";
  String where=" ";
  bool search=false;
  Customer selecteduser;
  List<Customer>customerlist=[];
  bool by_user=false;

  @override
  void initState() {
    // TODO: implement initState

    get_customerList() ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      drawer:CreateDrawer(["إضافة طلبية","الرئيسية"],[AllModels(),HomePage()]) ,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        toolbarHeight:100,
        title:Center(child: Text_Style("الطلبيات",20,Colors.white,"rtl")) ,
        actions: [
          PopupMenuButton(
               onSelected:(value){

                 by_user=false;
                 search=false;
                 where="";
                 selecteduser=null;

                 switch(value)
                 {
                   case "1":{  key="ORDER BY order_id"; break;}
                   case "2":{  key=" ORDER BY order_id DESC"; break;}
                   case "3":{  key=" ORDER BY order_id";by_user=true; break;}
                   case "4":{  search=true; key=" ORDER BY order_id DESC"; break;}

                 }
                  setState(() { });
               } ,
              icon:Icon(Icons.filter_list),
              itemBuilder:(context)=>[
                PopupMenuItem(
                  value: "1",
                    child:Text_Style("ترتيب من الأقدم إلى الأحدث",16,Colors.black,"rtl")
                ),
                PopupMenuItem(
                  value: "2",
                    child:Text_Style("ترتيب من الأحدث إلى الأقدم",16,Colors.black,"rtl")
                ),
                PopupMenuItem(
                  value:"3",
                    child:Text_Style("عرض بحسب الزبون",16,Colors.black,"rtl")
                ),
                PopupMenuItem(
                  value: "4",
                    child:Text_Style("عرض بحسب الموديل",16,Colors.black,"rtl")
                )


              ],
            initialValue:"ppp" ,

          )

        ],
      ),
      body: Container(
          padding: EdgeInsets.all(5),
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
            child:
            Column(children: [
              search?Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                    controller:textcontoller ,
                    onChanged: (value){  },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintTextDirection: TextDirection.rtl,
                        prefixIcon: IconButton(
                            icon: Icon(Icons.search),
                            alignment: Alignment.center,
                            onPressed: () {
                              {
                                if(textcontoller.text.isEmpty)
                                  return;
                                int code=int.tryParse(textcontoller.text.trim());
                                if(code==null || code<=0)
                                 {
                                   AwesomeDialog(context:context,body:Text_Style("الرقم الذي أدخلته غير صحيح",20,Colors.red,"rtl"),autoHide: Duration(seconds: 3)).show();
                                    return;
                                 }
                                      setState(() {
                                        where=" WHERE model_no=$code";
                                      });
                              }
                            }),
                        hintText: ("رقم الموديل"),
                        contentPadding: EdgeInsets.only(
                            top: 10, right: 40),
                        border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(25)))),
              ):Container(),
              by_user?create_dropdownList():Container(),
               FutureBuilder(
                  future:DataBaseHelper.import_from_dadabase("SELECT * FROM ((customers LEFT JOIN models ON models.customer_id=customers.customer_id ) JOIN orders ON models.model_id=orders.model_id ) $where  $key")  ,
                  builder: (BuildContext buildcontext,AsyncSnapshot<List<Map<String,dynamic>>> snapshot)
                  {

                    print(snapshot.data);
                     if(snapshot.connectionState==ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator());
                    else if(snapshot.hasData && !snapshot.hasError)
                    {
                      if(snapshot.data.length>0)
                      {
                        orders=snapshot.data.toList();
                         return creatListview();


                      }
                    }
                    return ConnectionTester.test_connection(snapshot);
                  }
              )
            ]
            ),

          )
      ),
    );
  }

  Widget creatListview() {
    return Column(
            children: [
      Container(
        padding: EdgeInsets.all(8),
        color: Colors.teal.shade300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text_Style(orders.length.toString(),20,Colors.black,"rtl"),
            Text_Style("العدد الإجمالي : ",20,Colors.black,"rtl"),

          ],
        ),
      ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap:true ,
          itemBuilder:(context,index){
            return creatItem(index);
          },
          itemCount:orders.length ,),
      ],
    );
  }

  Widget creatItem(int index) {
    DateTime dateTime= DateTime.parse(orders[index]['date']);

     return InkWell(
        onTap: (){
         Navigator.of(context).pushReplacement( MaterialPageRoute(builder:(context){
            return ShowModl(orders[index],"allorders");
          }));
        },
        child: Container(
          // color: Colors.indigo.shade400,
            height:300 ,
            child:Card(
                color:Colors.red.shade400 ,
                margin:EdgeInsets.only(top:10) ,
                child:Padding(
                    padding: const EdgeInsets.all(20),
                    child:Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.15,
                      child:  Column(
                       // mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                         Container(
                           color: Colors.indigo,
                           height: 50,
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                             Text_Style(orders[index]['name'].toString().toUpperCase(), 20, Colors.white,"rtl"),
                             Text(" : "),
                             Text_Style(orders[index]['model_no'], 20, Colors.white,"rtl"),

                           ],),
                         ),
                          SizedBox(height: 50),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text_Style("${dateTime.day}-${dateTime.month}-${dateTime.year}", 18, Colors.white,"rtl"),
                              SizedBox(width:20),
                              Text_Style("التاريخ :", 18, Colors.white,"rtl"),

                            ],
                          ),
                          SizedBox(height:20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text_Style((orders[index]['qnty']).toString(), 18, Colors.white,"rtl"),
                              SizedBox(width:20),
                              Text_Style("الكمية :", 18, Colors.white,"rtl"),


                            ],
                          ),
                          SizedBox(height:20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text_Style(orders[index]['total_price'].toString(), 18, Colors.white,"rtl"),
                              SizedBox(width:20),
                              Text_Style("القيمة الإجمالية :", 18, Colors.white,"rtl"),

                            ],
                          ),

                        ],),

                      actions: [

                        IconSlideAction(
                          closeOnTap:true ,
                          foregroundColor:Colors.deepPurple ,
                          onTap: () {
                            show_dialog_box(context, index);
                          },

                          icon:Icons.delete,

                          caption: 'حذف',


                        ),

                      ],
                    )
                )
            )
        )
    );
  }



  show_dialog_box(BuildContext context,int position)
  {

    bool exception=false;
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
            child: Text_Style("سوف يتم حذفه نهائياً من الهاتف",16,Colors.red,"rtl"),
          ),
        ) ,
        //desc: 'USER_NOT_FOUND',
        //showCloseIcon: true,
        btnCancelOnPress: () {},
        btnOkOnPress: ()async {


          try {

              await DataBaseHelper.delete("DELETE FROM orders WHERE order_id=${orders[position]['order_id']}");


          }  catch(e){exception=true;print("HHHHHHH");}


          if(exception)
            MyUtilities.show_dialog_box("لايمكن حذف هذا السجل, قد يكون مرتبطاً بسجلات أخرى في قاعدة البيانات!", context);
          else setState(() {
            orders.removeAt(position);
          });
        }




    ).show();

  }

  get_customerList()async {

   await DataBaseHelper.import_from_dadabase("SELECT * FROM customers ORDER BY name").then((value){
       if(value.isNotEmpty)
         customerlist=CustomerController.toCustomerList(value);

     });
     }

 Widget create_dropdownList() {

   if(customerlist.length>0)
    return Padding(
      padding: const EdgeInsets.all(10),
      child: DropdownButton(
        //dropdownColor: Colors.redAccent,

          focusColor:Colors.blue ,
          hint: Text("...حدد اسم الزبون",textAlign:TextAlign.center,style: TextStyle(fontSize: 18,color: Colors.indigo,fontWeight: FontWeight.bold,letterSpacing: 3 )),
          value: selecteduser,
          onChanged: (value){
            setState(() {
              selecteduser=value;
              where=" WHERE customers.customer_id=${selecteduser.id}";

            });
          },
          items: (

              customerlist.map((e) {
                return DropdownMenuItem(
                  value:e,
                  child: Container(
                    padding: EdgeInsets.only(bottom:5),
                      width: 200,
                      height: 50,
                      child: Container(
                        //color:Colors.indigo,
                        child: Center(
                          child: Text(e.name.toString().toUpperCase(),textAlign:TextAlign.center,style: TextStyle(fontSize:18,color: Colors.deepOrange,fontWeight: FontWeight.bold,letterSpacing: 2 )
                          ),
                        ),
                      )
                  ),
                );
              }).toList())
      ),
    );
 else return Container();
 }
  }



