import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable_sliver_list/expandable_sliver_list.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cevahir/database/database.dart';
import 'package:cevahir/models/customer.dart';
import 'package:cevahir/controller/customer_controller.dart';
import 'package:cevahir/utilities/Utilities.dart';
import 'package:cevahir/view/create_drawer.dart';
import 'package:cevahir/view/homePage.dart';
import 'package:cevahir/view/show_model.dart';
import 'package:cevahir/view/text_style.dart';

import 'add_model.dart';


class AllModels extends StatefulWidget {

  final String title='';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AllModels> {

  List<Customer> customerlist = [];
  Customer selecteduser;
  List<Map<String,dynamic>> last_5_model=[] ;
  List<Map<String,dynamic>> result=[];
  bool loadmorepressed=false;
  final _lastkey=GlobalKey();

  ExpandableSliverListController<Map<String,dynamic>> _controller =
  ExpandableSliverListController<Map<String,dynamic>>();
   bool search=false;
  TextEditingController textcontoller =TextEditingController();
  var futurebuilder;
  int count=0;
  String nomune="no";
  final GlobalKey<ScaffoldState>scafold_state=GlobalKey<ScaffoldState>();

   @override
  void initState() {
    // TODO: implement initState
     get_count().then((value){count=value;});
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    String qw="";
     switch(loadmorepressed)
    {
      case true:{
        selecteduser == null ? qw =
        "SELECT  *  FROM (SELECT  * FROM ((models  LEFT JOIN customers ON customers.customer_id=models.customer_id ) LEFT JOIN images ON models.model_id= images.model_id ) WHERE models.nomune='$nomune' AND models.model_id<${last_5_model[last_5_model.length -1]['model_id']} ORDER BY image_id DESC)"
            : qw ="SELECT  *  FROM (SELECT  * FROM ((models  LEFT JOIN customers ON customers.customer_id=models.customer_id ) LEFT JOIN images ON models.model_id= images.model_id ) WHERE models.nomune='$nomune' AND customers.customer_id=${selecteduser.id} AND models.model_id<${last_5_model[last_5_model.length -1]['model_id']}  ORDER BY image_id DESC)";
        break;
      }
      case false:{
        selecteduser==null? qw="SELECT  *  FROM (SELECT  * FROM ((models  LEFT JOIN customers ON customers.customer_id=models.customer_id ) LEFT JOIN images ON models.model_id= images.model_id ) WHERE models.nomune='$nomune'  ORDER BY image_id DESC)"
            :qw="SELECT  *  FROM (SELECT  * FROM ((models  LEFT JOIN customers ON customers.customer_id=models.customer_id ) LEFT JOIN images ON models.model_id= images.model_id ) WHERE models.nomune='$nomune' AND customers.customer_id=${selecteduser.id} ORDER BY image_id DESC)";

      }

    }

   !search?qw+="  GROUP BY model_id ORDER BY model_id DESC LIMIT 50":
      qw = "SELECT * FROM (SELECT  *  FROM (SELECT  * FROM ((models  LEFT JOIN customers ON customers.customer_id=models.customer_id ) LEFT JOIN images ON models.model_id= images.model_id ) ORDER BY image_id DESC)) WHERE nomune='$nomune' AND model_no like '%${textcontoller.text.trim()}%' OR  name like '%${textcontoller.text.trim()}%'    ";
     get_count().then((value){count=value;});

     !search?futurebuilder= FutureBuilder(
        future:DataBaseHelper.import_from_dadabase(qw),
        builder:(BuildContext context,AsyncSnapshot<List<Map<String,dynamic>>> snapshot){
          bool data=false;
          if(snapshot.connectionState==ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          else if(snapshot.hasData &&  snapshot.data.length > 0 &&
              snapshot.error == null) {
            print(snapshot.data);
             data=true;
            if (!loadmorepressed)
              last_5_model = snapshot.data.toList();
            else {
              List<Map<String, dynamic>> lst = last_5_model.toList();
              loadmorepressed = false;
              snapshot.data.toList().forEach((element) {
                lst.add(element);
                _controller.insertItem(element, lst.length - 1);
              });

              last_5_model = lst;


            }

            _controller.setItems(last_5_model);
          }
      else if(snapshot.connectionState==ConnectionState.done && data==false && last_5_model.isEmpty)
                return Center(child: Text_Style("لا يوجد بيانات بعد!", 22, Colors.red,"rtl"));

          return createList();


        }
    ):
        futurebuilder= FutureBuilder(
        future:DataBaseHelper.import_from_dadabase(qw),
        builder:(BuildContext context,AsyncSnapshot<List<Map<String,dynamic>>> snapshot){
               last_5_model=[];
          if(snapshot.connectionState==ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          else if(snapshot.hasData &&  snapshot.data.length > 0 &&
              snapshot.error == null) {

              last_5_model = snapshot.data.toList();
              _controller.setItems(last_5_model);
              return createList();
             }
          else  if(snapshot.connectionState==ConnectionState.done && last_5_model.isEmpty )
              return Center(child: Text_Style("لا يوجد موديل مرتبط بهذا الكود!", 22, Colors.red,"rtl"));
          return Container();


        }
    );
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        key: scafold_state,
         endDrawer:creatDrawer(),
          appBar:AppBar(

            toolbarHeight: 150,
            backgroundColor:Colors.indigo.withOpacity(0.9),

            flexibleSpace: Container(
              child: Stack(
                children: [
                  Center(
                    child: Transform.translate(
                      offset: Offset(0, -10),
                      child: dropdown_button(),
                    ),
                  ),
                  Center(
                    child: Transform.translate(
                      offset: Offset(0, 50),
                      child: Container(
                        width: 300,
                        height: 40,
                        color: Colors.transparent,
                        child: TextField(
                          controller:textcontoller ,
                         onChanged: (value){
                            if(value.isEmpty)
                              setState(() {
                                search=false;
                              });
                         },

                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintTextDirection:TextDirection.ltr,
                                prefixIcon: IconButton(
                                icon: Icon(Icons.search),
                                alignment: Alignment.center,
                                onPressed: () {
                                     {
                                       if(textcontoller.text.isEmpty)
                                         return;
                                     setState(() {
                                         search=true;
                                             });
                                   }
                                   }),
                                hintText: ("بحث"),
                                contentPadding: EdgeInsets.only(
                                    top: 10, right: 40),
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(25)))),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),

        body: futurebuilder
      ),
    );
  }


  Widget dropdown_button() {
    if (!customerlist.isEmpty)
      return create_dropdownbutton();
    else
      return FutureBuilder(
        future: DataBaseHelper.import_from_dadabase("SELECT * FROM customers ORDER BY name"),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if ((snapshot.hasData &&
              snapshot.data.length > 0 && snapshot.error == null) ||!customerlist.isEmpty) {

            customerlist = CustomerController.toCustomerList(snapshot.data);
            return create_dropdownbutton();
          }
          return Container();
        },
      );
  }

  Widget create_dropdownbutton() {
    return DropdownButton(
      //dropdownColor: Colors.redAccent,

        focusColor:Colors.blue ,
        hint:nomune=="no"?Text("...حدد اسم الشركة",textAlign:TextAlign.center,style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 3 )):Text("نــومونيــه",textAlign:TextAlign.center,style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold,letterSpacing: 3 )),
        value: selecteduser,
        onChanged: (value){

          setState(() {
            last_5_model=[];
            loadmorepressed=false;
            selecteduser = value;
            search=false;
            nomune="no";
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
                      color:Colors.pinkAccent,
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

  Widget createList() {
    return CustomScrollView(
       slivers: [
        count>0 && !search?SliverToBoxAdapter(child:Center(
            child:Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text_Style("العدد الإجمالي: $count",20,Colors.black,"ltr"),
            )
             )
            )
            :SliverToBoxAdapter(),
        ExpandableSliverList<Map<String,dynamic>>(
            initialItems: last_5_model,
            controller: _controller,
            // duration: const Duration(milliseconds: 1000),
            builder: (context, item, index) {
              String url=item['url'];
              var img;

              if(url!=null)
               img=Base64Decoder().convert(url);


              return Slidable(
                actionPane: SlidableDrawerActionPane(),

                actionExtentRatio: 0.25,

                child: Padding(
                  padding: const EdgeInsets.all(5.0),

                  child: Card(

                    color:Colors.white,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 10),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                url!=null?ClipOval(

                                  child: Image.memory(
                                    img,
                                    fit:BoxFit.cover,
                                    width: 150,
                                    height: 150,

                                  ),
                                ):CircleAvatar(
                                    backgroundColor:Colors.indigo.withOpacity(0.9),                                    foregroundColor: Colors.white,
                                    radius:70,
                                    child:Text(item['name'].toString().substring(0,1).toUpperCase())
                                ),
                                SizedBox(width:12),
                                Expanded(
                                  flex:1,
                                  child: Row(children: [
                                    Expanded(child: Text(item['name']==null?"غير معروف":item['name'].toString().toUpperCase(),style:TextStyle(fontSize: 16,fontWeight:FontWeight.bold,letterSpacing:1),textDirection: TextDirection.ltr,maxLines:2,)),
                                     Expanded(child: Text(" ( ${item['nomune'].toString()=="yes"?"نومونيه":item['model_no']} )",style:TextStyle(fontSize: 16,fontWeight:FontWeight.bold,letterSpacing:1),textDirection: TextDirection.ltr,maxLines: 2,))
                                  ],),
                                )
                              ]),
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text_Style(
                                      MyUtilities.convertDate(item['date']),
                                      16, Colors.black.withOpacity(0.5), "ltr"),
                                   Flexible(
                                    flex: 1,
                                    child: InkWell(
                                          child: Text_Style(
                                              "عرض التفاصيل", 18, Colors.black.withOpacity(0.5),
                                              "rtl"),
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                            return ShowModl(item,"exist");
                                          }));
                                        },
                                      ),
                                  )

                                ]
                            ),
                          ),

                        ]
                    ),
                  ),
                ),

                actions: [
                  IconSlideAction(
                    icon: Icons.remove_circle,
                    foregroundColor: Colors.deepPurple,
                     caption: 'حذف',

                    onTap: ()async {
                      await DataBaseHelper.delete("DELETE FROM models WHERE model_id=${item['model_id']}").then((value){
                        MyUtilities.alertdialog(scafold_state.currentContext,"تم الحذف بنجاح");
                        setState(() {
                          last_5_model.removeAt(index);
                        });

                      });



                    },
                  ),
                  IconSlideAction(
                    icon: Icons.edit,
                    foregroundColor: Colors.deepPurple,
                     caption: 'تعديل',

                    onTap: () {
                             Navigator.push(context,MaterialPageRoute(builder:(context){
                              return AddModel.edit(item,"exist",);
                            }));
                    },
                  )

                ],
              );
            }
        ),
      !search && last_5_model.length<count?SliverToBoxAdapter(
            key: _lastkey,
            child:Container(

              child:TextButton(
                  onPressed: ()async {

                    if(last_5_model.length==count)
                      return;
                    setState(() {
                      loadmorepressed=true;
                    });
                    Future.delayed(Duration(milliseconds: 500)).then((value){
                      try {

                        Scrollable.ensureVisible(_lastkey.currentContext);

                      }
                      catch(Ex){}


                    });
                  },

                  child: Text_Style("عرض المزيد ...",18,Colors.black,"rtl")),


            )
        ):SliverToBoxAdapter()

      ],

    );
  }

  Future<int>get_count()async {

    if(selecteduser==null)
      count=await DataBaseHelper.getcount("SELECT COUNT(model_id) FROM models WHERE nomune='$nomune'");
 else count=await DataBaseHelper.getcount("SELECT COUNT(model_id) FROM models WHERE nomune='$nomune' AND customer_id=${selecteduser.id}");

 return count;

  }


 Widget creatDrawer() {
     return Drawer(
       child: Column(
         children: [
       Padding (
         padding: EdgeInsets.only(top: 40, left: 70),
          child: ListTile(
                     title: Text_Style("جميع الموديلات", 20, Colors.teal, "rtl"),
                   trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400,),
                    onTap: () {
                       nomune="no";
                     Navigator.pop(context);
                     Navigator.of(context).pushReplacement(
                         MaterialPageRoute(builder: (context) {
                           return AllModels();
                         }));
                   }
               )
           ),
       Padding (
               padding: EdgeInsets.only(top: 40, left: 70),
   child: ListTile(
   title: Text_Style("نــومــونيـــه", 20, Colors.teal, "rtl"),
   trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400,),
   onTap: () {
        setState(() {
           Navigator.pop(context);
          nomune="yes";
          last_5_model=[];
          selecteduser=null;
          loadmorepressed=false;
          search=false;
        });
   }
   )
   ),
       Padding(
   padding: EdgeInsets.only(top: 40, left: 70),
   child:ListTile(
   title: Text_Style("إضافة موديل", 20, Colors.teal, "rtl"),
   trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400,),
   onTap: () {
   Navigator.pop(context);
   Navigator.of(context).pushReplacement(
   MaterialPageRoute(builder: (context) {
   return AddModel();
   }));
   }
   ),
   ),
       Padding(
   padding: EdgeInsets.only(top: 40, left: 70),
   child:  ListTile(
       title: Text_Style( "الرئيسية", 20, Colors.teal, "rtl"),
       trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400,),
       onTap: () {
         Navigator.pop(context);
         Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (context) {
               return HomePage();
             }));
       }
   )
   ),
         ],
       )
   );
 }
}