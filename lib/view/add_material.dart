import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cevahir/database/database.dart';
import 'package:cevahir/models/details.dart';
import 'package:cevahir/controller/details_controller.dart';
import 'package:cevahir/models/material.dart';
import 'package:cevahir/utilities/Utilities.dart';
import 'package:cevahir/utilities/connection.dart';
import 'package:cevahir/view/add_model.dart';
import 'package:cevahir/view/text_style.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cevahir/view/warehouse.dart';
import '../controller/material_controller.dart';
import 'all_models.dart';
import 'homePage.dart';

class AddMaterial extends StatefulWidget{

   AddMaterial();


  @override
  State createState()=>_AddMaterialState();

}

class _AddMaterialState extends State {

  List<Material_> material_List=[];
  bool nodata=false;
  final _form_key = GlobalKey<FormState>();

  _AddMaterialState();

  @override
  void initState() {
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
        backgroundColor: Colors.indigo.shade500,
          toolbarHeight:100 ,
          title: Center(child: Text_Style("إضافة مواد",22,Colors.white,"rtl")),
        ),
          body:  Container(
            padding:EdgeInsets.only(top: 10) ,
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Form(
                key: _form_key,
                child: material_List.isEmpty && !nodata?FutureBuilder(
                    future: DataBaseHelper.import_from_dadabase("SELECT * FROM material"),
                    builder:(BuildContext context,AsyncSnapshot <List<Map<String,dynamic>>> snapshot){

                      if(snapshot.connectionState==ConnectionState.waiting)
                        return Center(child: CircularProgressIndicator());

                   else if (snapshot.hasData && snapshot.error == null)
                        if(snapshot.data.length > 0)
                        {

                        material_List=MaterialController.to_List(snapshot.data);
                         material_List.insert(0,Material_(-1, "type", "color", "notes", 1, 1, "class_type"));
                        return creatlistview();


                         }

                   else   return ConnectionTester.test_connection(snapshot);

                    }
                ):creatlistview(),
              ),
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
                                onPressed:()   {
                                 bool error=false;

                                   if(material_List.isEmpty)
                                    return Container();
                                  if(!_form_key.currentState.validate())
                                    return Container();

                                  if(_form_key.currentState.validate()) {
                                    material_List.forEach((element) {
                                       if (element.per_kilo== null || element.per_kilo<0)
                                           error=true;
                                    });

                                      if(error)
                                        {
                                          MyUtilities.show_dialog_box(
                                              "لا يمكنك إدخال غير الأرقام في خانة العدد",
                                              context);
                                           return 0;
                                        }

                                    material_List.forEach((element) {
                                      if(element!=material_List.first)
                                       {
                                         if (element.material_id == null || element.material_id <1)
                                           DataBaseHelper.insertToDataBase("material", MaterialController.to_map(element));
                                         else
                                           DataBaseHelper.update("UPDATE material SET "
                                               "type='${element.type}',"
                                               "class_type='${element.class_type}',"
                                               "color='${element.color}',"
                                               "qnty=${element.qnty},"
                                               "notes='${element.notes}',"
                                               "per_kilo='${element.per_kilo}'"
                                               "WHERE material_id=${element.material_id}").then((v){
                                                 });
                                       }
                                    }

                                    );

                                      if(material_List.length<=1)
                                        return 0;

                                      material_List = [];
                                      nodata = false;
                                    MyUtilities.alertdialog(context, "تم الحفظ بنجاح");
                                   }

                                } ),
                            SizedBox(height:10 ,),
                            Text_Style("حفظ", 16,Colors.grey.shade500,"rtl")

                          ],
                        ),
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FloatingActionButton(
                                  child: Icon(Icons.add,size: 30,color: Colors.white,),
                                  heroTag: 'add_material',
                                  onPressed:(){
                                    if(selected==null || selected.isEmpty)
                                      return;
                                    setState(() {
                                      material_List.add(Material_(0,"","","",0,0,selected));
                                    });
                                  }),
                              SizedBox(height:10 ,),

                              Text_Style("سطر جديد",16,Colors.grey.shade500,"rtl"),

                            ]

                        ),
                        create_dropdownButton(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            IconButton(icon:Icon(Icons.chevron_right_sharp,color:Colors.blue.shade500,size: 30,),
                                onPressed:(){

                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){

                                      return WarehouseWidget();

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
  String  selected;

  Widget create_dropdownButton() {

    return SizedBox(
       child: Padding(
        padding: const EdgeInsets.all(5),
        child: DropdownButton(
          //dropdownColor: Colors.redAccent,
            focusColor:Colors.blue ,

            hint: Center(child: Text(" ..حدد النوع",style: TextStyle(fontSize: 18,color: Colors.indigo,fontWeight: FontWeight.bold,letterSpacing: 3 ))),
            value: selected,
            onChanged: (value){
              setState(() {
                 selected=value;

              });
            },
            items: [

               DropdownMenuItem(
                    value:'أول',
                    child: Card(
                      color:Colors.indigo,

                      child: Center(
                        child: Text("نوع أول",textAlign:TextAlign.center,style: TextStyle(fontSize:18,color: Colors.white,fontWeight: FontWeight.bold )

                        ),
                      ),
                    ),
                  ),
              DropdownMenuItem(
                value:'ثاني',
                child: Card(
                  color:Colors.indigo,

                  child: Center(
                    child: Text("نوع ثاني",textAlign:TextAlign.center,style: TextStyle(fontSize:18,color: Colors.white,fontWeight: FontWeight.bold )

                    ),
                  ),
                ),
              )
            ]

        ),
      ),
    );
  }

  Widget createListRow(List<String> lst,int position)
  {

    List<Widget>widgetlist=[];

       for(int i=0;i<lst.length;i++)
    {
      widgetlist.add(add_feild(lst[i],i,position));
      widgetlist.add(SizedBox(width: (2)));
    }

       if(position==0)
         return Row(children:widgetlist);
   else return   Slidable(

        actionPane: SlidableDrawerActionPane(),

        actionExtentRatio: 0.25,


        child: Row(children:widgetlist),

        actions: [

          IconSlideAction(
            onTap: () {

              if(material_List[position].material_id>0)
                show_dialog_box(context,position);

              else
                setState(() {
                  material_List.removeAt(position);
                });

              if(material_List.isEmpty)
                nodata=true;
              else nodata=false;



            },

            icon:Icons.delete,

            caption: 'حذف',

          )
        ]
    );
  }

  bool changed=false;

  Widget add_feild(String data,int columnNo,int rowNo) {
    TextEditingController txt=TextEditingController();
    txt.text=data;

    return
      Expanded(
        child: Container(
          width: 100,
          color: rowNo==0?Colors.indigo:Colors.teal.shade400,
          child: TextFormField (

            onChanged:(text) {

              switch(columnNo)
              {
                case 0:{material_List[rowNo].notes=text;break;}
                case 1:{material_List[rowNo].per_kilo=double.tryParse(text);break;}
                case 2:{material_List[rowNo].color=text;break;}
                case 3:{material_List[rowNo].class_type=text;break;}
                case 4:{material_List[rowNo].type=text;break;}
              }

            }  ,
            cursorColor: Colors.white,
            cursorWidth:6 ,
            cursorHeight:24 ,
            maxLines: 2,
            style: TextStyle(fontSize: rowNo==0?18:16,color:Colors.white,fontWeight:rowNo==0?FontWeight.bold:FontWeight.normal,  ),
            controller:txt,
            enabled:columnNo==3|| rowNo==0?false:true ,
            decoration: InputDecoration(hintText: 'أدخل قيمة'),
            keyboardType:columnNo==1?TextInputType.number:TextInputType.text,
            textAlign: TextAlign.center,
            validator: (value) {

              if (value.isEmpty || value==null)
                return 'أدخل قيمة هنا';
              else
                return null;
            },
          ),
        ),
      );
  }

  Widget creatlistview() {
     return  ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder:(context,position)
      {

        if(position==0)
          return createListRow(["ملاحظات","العدد/الكيلو","اللون","النخــب","الاسم"],position);
     else return  Padding(
      padding: const EdgeInsets.only(bottom:6),
      child: createListRow([material_List[position].notes,material_List[position].per_kilo.toString(),material_List[position].color,material_List[position].class_type,material_List[position].type],position),
   );

      },itemCount:material_List.length,

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

          DataBaseHelper.delete("DELETE FROM material WHERE material_id=${material_List[position].material_id}");
          DataBaseHelper.delete("DELETE FROM recipt_content WHERE material_id=${material_List[position].material_id}");
          DataBaseHelper.delete("DELETE FROM inci WHERE material_id=${material_List[position].material_id}");

          material_List.removeAt(position);
        });
      },
    ).show();

  }



}