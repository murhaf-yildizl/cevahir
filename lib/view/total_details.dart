import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cevahir/database/database.dart';
import 'package:cevahir/models/details.dart';
import 'package:cevahir/controller/details_controller.dart';
import 'package:cevahir/models/inci.dart';
 import 'package:cevahir/models/material.dart';
 import 'package:cevahir/utilities/Utilities.dart';
import 'package:cevahir/utilities/connection.dart';
import 'package:cevahir/view/add_material.dart';
import 'package:cevahir/view/add_model.dart';
import 'package:cevahir/view/all_orders.dart';
import 'package:cevahir/view/text_style.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../controller/inci_controller.dart';
import '../controller/material_controller.dart';
import 'all_models.dart';
import 'homePage.dart';

class TotalDetails extends StatefulWidget{
  int  model_id;
  String type;

  TotalDetails(this.model_id,this.type);

  @override
  State createState()=>_AddModelState(model_id,type);


}
class _AddModelState extends State {
  int model_id;
  List<Inci> detList=[];
  bool nodata=false;
  final _form_key = GlobalKey<FormState>();
  String type;
  Material_ selected_type;
  List<Material_>material_list=[];
 _AddModelState(this.model_id,this.type);

  @override
   initState()  {
    get_material_list();
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
     return GestureDetector(
       onTap: (){
         FocusScope.of(context).requestFocus(FocusNode());
       },
       child: Scaffold(
          body:  Container(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child:material_list.isEmpty?Center(
          child: Container(
          padding:EdgeInsets.only(top:30) ,
           child:Column(
             children:[
               Text_Style("لا يوجد لديك مواد لإضافتها", 18, Colors.black,"rtl"),
               SizedBox(height: 20),
               Icon(Icons.error,color: Colors.grey,size: 30,),
               SizedBox(height: 50),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   IconButton(
                       onPressed:(){
                         Navigator.pushReplacement(context,MaterialPageRoute(builder:(context){
                           return AddMaterial();
                         }));
                       },
                       icon: Icon(Icons.add)
                   ),
                   Text_Style("أضف المواد الآن", 18,Colors.black, "rtl")
                 ],)

             ],)
       )):
              Form(
                          key: _form_key,
                          child: detList.isEmpty && !nodata?FutureBuilder(
                              future: DataBaseHelper.import_from_dadabase("SELECT * FROM inci WHERE model_id=${model_id}"),
                              builder:(BuildContext context,AsyncSnapshot <List<Map<String,dynamic>>> snapshot){
                                InciController.lst=detList;
                                if (snapshot.hasData && snapshot.data.length > 0 &&
                                    snapshot.error == null)
                                {
                                    detList=InciController.to_list(snapshot.data);
                                    InciController.lst=detList;
                                    return !material_list.isEmpty? creatlistview():Container();


                                }
                              else  return ConnectionTester.test_connection(snapshot);

                              }
                          ):Column(
                            children: [

                              creatlistview(),
                            ],
                          ),
                        )

            ),

          ),
          bottomNavigationBar:Offstage(

              offstage:false ,
              child:Container(
                  height: 120,
                  padding:EdgeInsets.all(10) ,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            IconButton(icon:Icon(Icons.save,color:Colors.blue.shade500,size: 30,),
                                onPressed:(){
                                  bool error=false;

                                  if(detList.isEmpty || type=="allorders")
                                    return Container();
                                  if(!_form_key.currentState.validate())
                                    return Container();
                                  if(_form_key.currentState.validate()) {
                                    detList.forEach((element) {
                                        if (element.qnty == null || element.qnty<=0) {
                                          error=true;
                                        MyUtilities.show_dialog_box(
                                            "الأرقام ليست بالصورة الصحيحة",
                                            context);
                                        return;
                                      }
                                    });

                                    if(!error)
                                      {
                                     detList.forEach((element) {
                                       print(element.qnty);
                                       print("id=${element.inci_id}");
                                       if (element.inci_id == null ||
                                           element.inci_id < 1)
                                         DataBaseHelper.insertToDataBase("inci",
                                             InciController.to_map(element));
                                       else
                                         DataBaseHelper.update(
                                             "UPDATE inci SET type='${element.type}', "
                                                 "material_id='${element.material_id}',"
                                                 "qnty=${element.qnty},"
                                                 "weight=${element.weight},"
                                                 "notes='${element.notes}',"
                                                 "model_id=${element.model_id}"
                                                 "  WHERE inci_id=${element.inci_id}");
                                     }
                                     );

                                     detList=[];
                                     nodata=false;
                                     MyUtilities.alertdialog(context, "تم الحفظ بنجاح");

                                      }

                                      }
                                 }
                                      ),
                            SizedBox(height:10 ,),
                            Text_Style("حفظ", 16,Colors.grey.shade500,"rtl")

                          ],
                        ),
                        Row(
                             children: [
                              FloatingActionButton(
                                  child: Icon(Icons.add,size: 30,color: Colors.white,),
                                  heroTag: 'add_details',
                                  onPressed:(){
                                    if(selected_type==null || type=="allorders")
                                      return;
                                   else setState(() {

                                      detList.add(Inci(selected_type.type,selected_type.material_id,"",0,selected_type.per_kilo,this.model_id));
                                    });
                                  }),
                               create_dropdownButton()

                            ]

                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            IconButton(icon:Icon(Icons.chevron_right_sharp,color:Colors.blue.shade500,size: 30,),
                                onPressed:(){

                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                                    if(type=="exist" || type=="order")
                                      return AllModels();
                                    else if(type=="new")
                                      return AddModel();
                                    else if(type=="allorders")
                                      return AllOrders();

                                  }));

                                }
                            ),
                            SizedBox(height:10 ,),

                            Text_Style("رجوع", 16,Colors.grey.shade500,"rtl")

                          ],
                        ),



                      ])

              )
    )
       ),
     );

  }

  Widget createListRow(List<dynamic> lst,int position,Material_ mat)
  {

    List<Widget>widgetlist=[];

    for(int i=0;i<lst.length;i++)
    {
      widgetlist.add(add_feild(lst[i],i,position,mat));
      widgetlist.add(SizedBox(width: (1)));
    }

    if(position==-1)
      return Row(children:widgetlist);

   else return   Slidable(

        actionPane: SlidableDrawerActionPane(),

        actionExtentRatio: 0.25,

        child: Row(children:widgetlist),

        actions: [

          IconSlideAction(
            onTap: () {

              if(detList[position].inci_id!=null)
                show_dialog_box(context,position);

              else
                setState(() {
                  detList.removeAt(position);
                });

              if(detList.isEmpty)
                nodata=true;
              else nodata=false;

            },

            icon:Icons.delete,

            caption: 'حذف',

          )
        ]
    );
  }

  Widget add_feild(String data,int columnNo,int rowNo,Material_ mat) {
    TextEditingController txt=TextEditingController();
    txt.text=data;
    return Expanded(
        child: Container(
          width: 100,
          color: rowNo==-1?Colors.indigo:Colors.teal.shade400,
          child: TextFormField (
            maxLines:rowNo==-1?1:3 ,
            keyboardType: columnNo==1?TextInputType.number:null,
            onChanged:(text) {

          switch(columnNo)
              {

                case 0:{detList[rowNo].notes=text;break;}
                case 1:{
                   detList[rowNo].qnty=int.tryParse(text.trim());
                   if(detList[rowNo].qnty==null)
                     break;

                   detList[rowNo].weight=num.parse((detList[rowNo].qnty/mat.per_kilo).toStringAsFixed(3));


                   if(detList[rowNo].qnty==null)

                      MyUtilities.show_dialog_box("لا يمكنك إدخال غير الأرقام في خانة العدد", context);
                       break;
                }
                 case 2:{detList[rowNo].material_id=int.tryParse(text.toString());break;}
              }
              if(_form_key.currentState.validate())
                return;

            }  ,
            cursorColor: Colors.white,
            cursorWidth:6 ,
            cursorHeight:24 ,
            style: TextStyle(
                fontSize: rowNo==-1?18:16,color:Colors.white,fontWeight:rowNo==-1?FontWeight.bold:FontWeight.normal
                ),

            controller:txt,
            enabled:columnNo==2|| columnNo==3 || type=="allorders"|| rowNo==-1?false:true ,
            decoration: InputDecoration(hintText: 'أدخل قيمة'),
            textAlign: TextAlign.center,
            validator: (value) {

              if (value.isEmpty)
                  return 'أدخل قيمة هنا';
              else
                  return null;
            },
          ),
        ),
      );
  }

   Widget  creatlistview(){
     Material_ mat;

     return SingleChildScrollView(
       child: Column(
          children:[
           createListRow(["ملاحظات","العدد","النخـب","النوع"],-1,null),
           ListView.builder(
           physics: NeverScrollableScrollPhysics(),
           shrinkWrap: true,
           itemBuilder:(context,position)
           {
             material_list.forEach((element) {
              if(detList[position].material_id==element.material_id)
                mat=element;
            });
            return Padding(
               padding: const EdgeInsets.only(bottom:6),
               child: createListRow([detList[position].notes,detList[position].qnty.toString(),mat.class_type,"${mat.type} ${mat.color} "],position,mat),
             );
           },itemCount:detList.length,

         ),
       ]
       ),
     );
  }

  show_dialog_box(BuildContext context,int position)
  {
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
          child: Text_Style("حذف هذا السطر سوف يؤدي إلى حذفه نهائياً من الهاتف",16,Colors.red,"rtl"),
        ),
      ) ,
      //desc: 'USER_NOT_FOUND',
      //showCloseIcon: true,

      btnCancelOnPress: () {},
      btnOkOnPress: () {

        print("pos=$position");
        setState(() {

          DataBaseHelper.delete("DELETE FROM inci WHERE inci_id=${detList[position].inci_id}");
          detList.removeAt(position);
        });
      },
    ).show();

  }


  Widget create_dropdownButton() {

    return Padding(
      padding: const EdgeInsets.all(14),
      child: DropdownButton(
        //dropdownColor: Colors.redAccent,
          focusColor:Colors.blue ,
          hint: Center(child: Text("نوع الإنجي",style: TextStyle(fontSize: 16,color: Colors.indigo,fontWeight: FontWeight.bold,letterSpacing: 3 ))),
          value: selected_type,
          onChanged: (value){
            setState(() {
              selected_type=value;

            });
          },
          itemHeight:60 ,
          items: (
              material_list.map((e) {
                return DropdownMenuItem(
                  value:e,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:1),
                    child: Container(
                      width: 150,
                      color:Colors.indigo,
                      child: Center(
                        child: Text("${e.type} ${e.class_type} ${e.color}",textAlign:TextAlign.center,style: TextStyle(fontSize:16,color: Colors.white,fontWeight: FontWeight.bold )

                        ),
                      ),
                    ),
                  ),
                );
              }).toList())
      ),
    );

  }

  Future<Widget>get_material_list()async {
    if(material_list.isEmpty)
    {
      var result = await DataBaseHelper.import_from_dadabase(
          "SELECT * FROM material").then((value) {
            print(value);
        setState(() {
          material_list = MaterialController.to_List(value);
          MaterialController.material_list=material_list;
          material_list.forEach((element) {print(element.material_id);});

        });

      });
    }

  }

  }




