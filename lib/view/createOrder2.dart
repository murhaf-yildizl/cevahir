import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cevahir/models/kartella.dart';
import 'package:cevahir/models/order_applyment.dart';
import 'package:cevahir/view/show_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cevahir/database/database.dart';
import 'package:cevahir/models/material.dart';
import 'package:cevahir/controller/material_controller.dart';
import 'package:cevahir/utilities/Utilities.dart';
import 'package:cevahir/utilities/connection.dart';
import 'package:cevahir/view/add_material.dart';
import 'package:cevahir/view/add_model.dart';
import 'package:cevahir/view/all_orders.dart';
import 'package:cevahir/view/text_style.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/order.dart';
import '../models/order_controller.dart';
import 'homePage.dart';


class CreateOrder2 extends StatefulWidget{
  Map<String, dynamic> model;
  Order order;
  List<Kartella> detList=[];

  CreateOrder2(this.model,this.order,this.detList);

  @override
  State createState()=>CreateOrder2_State(this.model,this.order,this.detList);


}

class CreateOrder2_State extends State {
  Map<String, dynamic> model;
  Order order;
  List<Kartella> detList=[];
  bool nodata=false;
  final _form_key = GlobalKey<FormState>();
   Material_ selected_type;
  List<Material_>material_list=[];


  CreateOrder2_State(this.model,this.order,this.detList);

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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight:100 ,
          title: Center(child: Text_Style("${model['name'].toString().toUpperCase()} (${model['model_no']})- KARTELLA",20,Colors.white,"rtl")),
          backgroundColor:Colors.indigo ,
        ),
          body:  Container(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child:material_list.isEmpty?Center(
                    child: Container(
                        padding:EdgeInsets.only(top:30) ,
                        child:Column(
                          children:[
                            Text_Style("لا يوجد لديك مواد لإضافتها", 18, Colors.black,"ltr"),
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
                                Text_Style("أضف المواد الآن", 18,Colors.black, "ltr")
                              ],)

                          ],)
                    )):
                Form(
                  key: _form_key,
                  child:creatlistview(),
                  ),
                )

            ),
          bottomNavigationBar:Offstage(

              offstage:false ,
              child:Container(
                  height: 120,
                  padding:EdgeInsets.all(10) ,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Row(
                            children: [
                              FloatingActionButton(
                                  child: Icon(Icons.add,size: 30,color: Colors.white,),
                                  heroTag: 'add_details',
                                  onPressed:(){
                                    if(selected_type==null)
                                      return;
                                    else setState(() {


                                      detList.add(Kartella(selected_type,0,0,0));
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
                                      return ShowModl(model,"exist");
                                  }));

                                }
                            ),
                            SizedBox(height:10 ,),

                            Text_Style("رجوع", 16,Colors.grey.shade500,"ltr")

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
      return Row(
          children:widgetlist);

    else return   Slidable(

        actionPane: SlidableDrawerActionPane(),

        actionExtentRatio: 0.25,

        child: Row(children:widgetlist),

        actions: [

          IconSlideAction(
            onTap: () {
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
        padding:EdgeInsets.all(3),
        width:100,
        color: rowNo==-1?Colors.indigo:Colors.teal.shade400,
        child: TextFormField (
        maxLines:rowNo==-1?1:3 ,
        keyboardType: columnNo==0||columnNo==1?TextInputType.number:null,

        onChanged:(text) {

          switch(columnNo)
          {

            case 0:{
              detList[rowNo].color_Qnt=int.tryParse(text.trim());

              break;}
            case 1:{
              detList[rowNo].inci_Qnt=int.tryParse(text.trim());

            break;}
          }


            return _form_key.currentState.validate();

        }  ,
        cursorColor: Colors.white,
        cursorWidth:6 ,
        cursorHeight:24 ,
        style: TextStyle(
            fontSize: rowNo==-1?18:16,color:Colors.white,fontWeight:rowNo==-1?FontWeight.bold:FontWeight.normal
        ),
        controller:txt,
        enabled:columnNo==2 || rowNo==-1?false:true ,

        decoration: InputDecoration(
             hintText: 'أدخل قيمة'),
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
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
            createListRow(["عدد القصة","عدد الإنجي","النوع"],-1,null),
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
                  child: createListRow([detList[position].color_Qnt.toString(),detList[position].inci_Qnt.toString(),"${mat.type} ${mat.color} ${mat.class_type} "],position,mat),
                );
              },itemCount:detList.length,

            ),
             detList.isEmpty?Container(): Column(
               children: [
                 SizedBox(
                   height: 20
                 ),
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

                       onPressed:() {
                          Navigator.pop(context);
                         Navigator.of(context).push(MaterialPageRoute(builder:(context){
                           return OrderApplyment(detList,order,model);
                         }));
                       }
                 ),
                     ),
               ],
             )
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
        Text_Style("تحذير", 22, Colors.red,"ltr")
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
          child: Text_Style("حذف هذا السطر سوف يؤدي إلى حذفه نهائياً من الهاتف",16,Colors.red,"ltr"),
        ),
      ) ,
      //desc: 'USER_NOT_FOUND',
      //showCloseIcon: true,

      btnCancelOnPress: () {},
      btnOkOnPress: () {

        print("pos=$position");
        setState(() {

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
          hint: Center(child: Text("نوع الإنجي",style: TextStyle(fontSize: 16,color: Colors.indigo,fontWeight: FontWeight.bold,letterSpacing: 3))),
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
                        child: Text("${e.type}  ${e.class_type} ${e.color}",textAlign:TextAlign.center,style: TextStyle(fontSize:16,color: Colors.white,fontWeight: FontWeight.bold )

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
          child: Text_Style(text,18,Colors.red,"ltr"),
        ),
      ) ,
      //desc: 'USER_NOT_FOUND',
      //showCloseIcon: true,
      btnOk:TextButton(child:Text_Style("OK",18,Colors.black,"ltr") ,
        onPressed: (){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context)
          {
            return HomePage();
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




