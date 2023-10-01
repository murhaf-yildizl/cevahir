import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cevahir/view/add_recipt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cevahir/database/database.dart';
import 'package:cevahir/models/details.dart';
import 'package:cevahir/controller/details_controller.dart';
import 'package:cevahir/models/inci.dart';
import 'package:cevahir/controller/inci_controller.dart';
import 'package:cevahir/models/material.dart';
import 'package:cevahir/controller/material_controller.dart';
import 'package:cevahir/models/recipt.dart';
import 'package:cevahir/models/recipt_content.dart';
import 'package:cevahir/controller/recipt_content_controller.dart';
import 'package:cevahir/utilities/Utilities.dart';
import 'package:cevahir/utilities/connection.dart';
import 'package:cevahir/view/add_model.dart';
import 'package:cevahir/view/all_recipts.dart';
import 'package:cevahir/view/homePage.dart';
import 'package:cevahir/view/text_style.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'all_models.dart';

class AddReciptContent extends StatefulWidget{
  int  recipt_id;
  String type;

  AddReciptContent(this.recipt_id,this.type);

  @override
  State createState()=>_AddReciptState(recipt_id,this.type);

}
class _AddReciptState extends State {
  int recipt_id;
  List<ReciptContent> contentList=[];
  bool nodata=false;
  final _form_key = GlobalKey<FormState>();
  Material_ selected_type;
  List<Material_>material_list=[];
  String type;



  _AddReciptState(this.recipt_id,this.type);

  @override
  initState()  {
    if(material_list.isEmpty)
           get_materialList();
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
            automaticallyImplyLeading:false ,
            toolbarHeight: 100,
            backgroundColor: Colors.indigo,
            title: Center(child: Text_Style("محتويات الفاتورة",20,Colors.white,"rtl")),
          ),
          body:  Container(
            padding:EdgeInsets.only(top:20),
            child: Form(
                key: _form_key,
                child: contentList.isEmpty && !nodata?FutureBuilder(
                    future: DataBaseHelper.import_from_dadabase("SELECT * FROM recipt_content WHERE recipt_id=${recipt_id}"),
                    builder:(BuildContext context,AsyncSnapshot <List<Map<String,dynamic>>> snapshot){

                      if(snapshot.connectionState==ConnectionState.waiting)
                        return Center(child: CircularProgressIndicator());

                      else if (snapshot.hasData && snapshot.error == null)
                        if(snapshot.data.length > 0)
                        {
                           contentList=ReciptContentController.to_list(snapshot.data);

                          if(!contentList.isEmpty)
                             return  !material_list.isEmpty? creatlistview():Container();

                          return  Container();


                        }

                      return ConnectionTester.test_connection(snapshot);

                    }
                ):creatlistview(),

                ),
          ),
          bottomNavigationBar:type=="new"?Offstage(

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

                                  bool valid=true;
                                  double current;

                                  if(contentList.isEmpty)
                                    return Container();
                                  if(!_form_key.currentState.validate())
                                    return Container();
                                  if(_form_key.currentState.validate()) {
                                    contentList.forEach((element) {
                                      if (element.content_qnty == null || element.content_qnty<=0||
                                          element.unit_price == null || element.unit_price<=0)
                                      {
                                        valid=false;
                                      }
                                    });
                                    if(!valid) {
                                      MyUtilities.show_dialog_box(
                                          "الأرقام ليست بالصورة الصحيحة",
                                          context);
                                      return 0;
                                    }
                                    contentList.forEach((element) async {
                                      if (element.content_id == null || element.content_id <1)

                                        await  DataBaseHelper.insertToDataBase("recipt_content",ReciptContentController.to_map(element));

                                      else

                                        await DataBaseHelper.update("UPDATE recipt_content SET material_id='${element.material_id}',unit_price='${element.unit_price}',content_qnty=${element.content_qnty},content_notes='${element.content_notes}'  WHERE content_id=${element.content_id}");
                                      material_list.forEach((mat) {
                                        if(mat.material_id==element.material_id)
                                          {
                                            current=mat.qnty;
                                            material_list[material_list.indexOf(mat)].qnty+=element.content_qnty;
                                            print("------ ${element.content_qnty}\\\\ ${current}");


                                          }
                                      });


                                      await DataBaseHelper.update("UPDATE material SET qnty=(${element.content_qnty}+${current}) WHERE material_id=${element.material_id}  ");

                                    }
                                    );

                                    setState(() {
                                      nodata=false;
                                      contentList=[];
                                     });
                                    alertdialog(context, "تم الحفظ بنجاح");

                                  }
                                } ),
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
                                    if(selected_type==null)
                                      return;
                                    else setState(() {

                                      contentList.add(ReciptContent(0,recipt_id,0,selected_type.material_id,"",0));
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
                                    return AllRecipts();

                                  }));

                                }
                            ),
                            SizedBox(height:10 ,),

                            Text_Style("رجوع", 16,Colors.grey.shade500,"rtl")

                          ],
                        ),



                      ])

              )
          ):Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  IconButton(
                      onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                          return AllRecipts();

                        }));
                      },
                      icon: Icon(Icons.arrow_back_ios)),
                  SizedBox(width: 10),
                  Text_Style("رجوع", 18, Colors.black,"rtl")
                ],
              ),
            ),
          )
      ),
    );

  }

  Widget createListRow(List<dynamic> lst,int position,Material_ mat)
  {

    List<Widget>widgetlist=[];

    for(int i=0;i<lst.length;i++)
    {
      widgetlist.add(add_feild(lst[i],i,position));
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

              if(contentList[position].content_id!=null && contentList[position].content_id>0)
                show_dialog_box(context,position,mat);

              else
                setState(() {
                  contentList.removeAt(position);
                });

              if(contentList.isEmpty)
                nodata=true;
              else nodata=false;

            },

            icon:Icons.delete,

            caption: 'حذف',

          )
        ]
    );
  }

  Widget add_feild(String data,int columnNo,int rowNo) {
    TextEditingController txt=TextEditingController();
    txt.text=data;
    return  Flexible(
      child: Container(
        width: 100,
        color: rowNo==-1?Colors.indigo:Colors.teal.shade400,
        child: TextFormField (
          maxLines:rowNo==-1?1:3,
              keyboardType: columnNo==1|| columnNo==2?TextInputType.number:null,
              onChanged:(text) {
                switch(columnNo)
                {
                  case 0:{contentList[rowNo].content_notes=text;break;}
                  case 1:{contentList[rowNo].unit_price=double.tryParse(text.trim());break;}
                  case 2:{contentList[rowNo].content_qnty=double.tryParse(text.trim());break;}
                  case 3:{contentList[rowNo].material_id=int.tryParse(text.toString());break;}

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
              enabled:(columnNo==3 || type=="exist" || rowNo==-1)?false:true ,
              decoration: InputDecoration(hintText: 'أدخل قيمة'),
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
        //shrinkWrap: true,
        children:[
          createListRow(["ملاحظات","السعر","الكمية","المادة"],-1,null),
          ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder:(context,position)
          {
            material_list.forEach((element) {
              if(contentList[position].material_id==element.material_id)
                mat=element;
            });
            if(mat==null)
              return Container();
        else  return Padding(
              padding: const EdgeInsets.only(bottom:6),
              child: createListRow([contentList[position].content_notes,contentList[position].unit_price.toString(),contentList[position].content_qnty.toString()," ${mat.type} ${mat.color} ${mat.class_type}"],position,mat),
            );
          },itemCount:contentList.length,

        ),
      ]
      ),
    );
  }

  show_dialog_box(BuildContext context,int position,Material_ mat)
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
      btnOkOnPress: ()   {

         setState(()   {
           double remained=mat.qnty-contentList[position].content_qnty;
           if(remained<0)
             remained=0;
           DataBaseHelper.update("UPDATE material SET qnty='$remained' WHERE material_id=${contentList[position].material_id} ");
           DataBaseHelper.delete("DELETE FROM recipt_content WHERE content_id=${contentList[position].content_id}");

          contentList.removeAt(position);
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
                        child: Text("${e.type} ${e.class_type}  ${e.color}",textAlign:TextAlign.center,style: TextStyle(fontSize:16,color: Colors.white,fontWeight: FontWeight.bold )

                        ),
                      ),
                    ),
                  ),
                );
              }).toList())
      ),
    );

  }

  get_materialList()async {

       material_list.isEmpty? await DataBaseHelper.import_from_dadabase("SELECT * FROM material").then((value){
      setState(() {
        print(value);
        material_list=MaterialController.to_List(value);

      });

    }
    ):null;
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
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context){
            return AllRecipts() ;
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




