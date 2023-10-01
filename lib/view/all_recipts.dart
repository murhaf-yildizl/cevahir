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
import 'package:cevahir/view/add_recipt.dart';
import 'package:cevahir/view/create_drawer.dart';
import 'package:cevahir/view/homePage.dart';
import 'package:cevahir/view/show_model.dart';
import 'package:cevahir/view/text_style.dart';

import 'add_recipt_content.dart';

class AllRecipts extends StatefulWidget {

  @override
  _AllReciptsState createState() => _AllReciptsState();
}

class _AllReciptsState extends State<AllRecipts> {
  List<Map<String,dynamic>>recipts=[];
  TextEditingController textcontoller=TextEditingController();
  String key=" ORDER BY recipt_id DESC";
  String where=" ";
  bool search=false;
  String origin="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      drawer:CreateDrawer(["إضافة فاتورة","الرئيسية"],[AddRecipt(0),HomePage()]) ,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        toolbarHeight:100,
        title:Center(child: Text_Style("الفواتير",20,Colors.white,"rtl")) ,
        actions: [
          PopupMenuButton(
            onSelected:(value){
              search=false;
              where="";

              switch(value)
              {
                case "1":{  key="ORDER BY recipt_id"; break;}
                case "2":{  key=" ORDER BY recipt_id DESC"; break;}
                case "3":{  search=true; key=" ORDER BY recipt_id DESC"; break;}

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
                  child:Text_Style("عرض بحسب المورّد",16,Colors.black,"rtl")
              ),


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

                                origin=textcontoller.text.trim();

                                if(origin.isEmpty)
                                {
                                  AwesomeDialog(context:context,body:Text_Style("رجاءً قم بإدخال كلمة البحث ",20,Colors.red,"rtl"),autoHide: Duration(seconds: 3)).show();
                                  return;
                                }
                                setState(() {
                                  where=" WHERE origin like'%$origin%'";
                                });
                              }
                            }),
                        hintText: ("بــحث"),
                        contentPadding: EdgeInsets.only(
                            top: 10, right: 40),
                        border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(25)))),
              ):Container(),
              FutureBuilder(
                  future:DataBaseHelper.import_from_dadabase("SELECT * FROM recipt $where $key")  ,
                  builder: (BuildContext buildcontext,AsyncSnapshot<List<Map<String,dynamic>>> snapshot)
                  {

                    print(snapshot.data);
                    if(snapshot.connectionState==ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator());
                    else if(snapshot.hasData && !snapshot.hasError)
                    {
                      if(snapshot.data.length>0)
                      {
                        recipts=snapshot.data.toList();
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
              Text_Style(recipts.length.toString(),20,Colors.black,"rtl"),
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
          itemCount:recipts.length ,),
      ],
    );
  }

  Widget creatItem(int index) {
    DateTime dateTime= DateTime.parse(recipts[index]['date']);

    return InkWell(
        onTap: (){
          Navigator.of(context).pushReplacement( MaterialPageRoute(builder:(context){
            return AddReciptContent(recipts[index]['recipt_id'],"exist");
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
                            width: 200,
                              child:Center(child: Text_Style(recipts[index]['origin'].toString().toUpperCase(), 20, Colors.white,"rtl")),
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
                              Text_Style(recipts[index]['total'].toString(), 18, Colors.white,"rtl"),
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
             List<Map<String,dynamic>> data=[];
             data=await DataBaseHelper.import_from_dadabase("SELECT * FROM recipt_content WHERE recipt_id=${recipts[position]['recipt_id']}");

              if(data.length<=0 || data==null )
                await DataBaseHelper.delete("DELETE FROM recipt WHERE recipt_id=${recipts[position]['recipt_id']}").then((value){
                  MyUtilities.alertdialog(context,"تم الحذف بنجاح");
                });
              else  MyUtilities.show_dialog_box("لايمكن حذف هذا السجل, قد يكون مرتبطاً بسجلات أخرى في قاعدة البيانات!", context);

          }  catch(e){exception=true;print("HHHHHHH");}


          if(exception)
            MyUtilities.show_dialog_box("لايمكن حذف هذا السجل, قد يكون مرتبطاً بسجلات أخرى في قاعدة البيانات!", context);


          else setState(() {
            recipts.removeAt(position);

          });
        }




    ).show();

  }

}



