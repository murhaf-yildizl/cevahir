import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cevahir/database/database.dart';
import 'package:cevahir/models/details.dart';
import 'package:cevahir/controller/details_controller.dart';
import 'package:cevahir/utilities/Utilities.dart';
import 'package:cevahir/utilities/connection.dart';
import 'package:cevahir/view/add_model.dart';
 import 'package:cevahir/view/text_style.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:googleapis/containeranalysis/v1.dart';
import 'all_models.dart';
import 'all_orders.dart';
import 'homePage.dart';

class ShowDetails extends StatefulWidget{

  int  model_id;
  String type;

  ShowDetails(this.model_id,this.type);


  @override
  State createState()=>_AddModelState(model_id,type);

}

class _AddModelState extends State {

  int model_id;
   List<Details> detList=[];
  bool nodata=false;
  final _form_key = GlobalKey<FormState>();
  String type;

  _AddModelState(this.model_id,this.type);

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
          body:  Container(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),

                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[

                      Form(
                        key: _form_key,
                        child: detList.isEmpty && !nodata?FutureBuilder(
                            future: DataBaseHelper.import_from_dadabase("SELECT * FROM details WHERE model_id=${model_id}"),
                            builder:(BuildContext context,AsyncSnapshot <List<Map<String,dynamic>>> snapshot){

                              if (snapshot.hasData && snapshot.data.length > 0 &&
                                  snapshot.error == null)
                              {
                                print(snapshot.data);
                                detList=DetailsController.to_details_list(snapshot.data);
                                detList.insert(0, Details("title", "inci_size", "notes", 0, -1));
                        print("zzzz ${detList.length}");
                                return Container(child: creatlistview());//creatlistview();


                              }

                              return ConnectionTester.test_connection(snapshot);

                            }
                        ):creatlistview()//creatlistview(),
                      ),
                    ]
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
                             onPressed:(){
                               bool error=false;

                               if(detList.isEmpty || type=="allorders")
                                 return Container();
                               if(!_form_key.currentState.validate())
                                 return Container();
                               if(_form_key.currentState.validate()) {
                                 detList.forEach((element) {
                                   if (element.quantity == null) {
                                     error = true;
                                     MyUtilities.show_dialog_box(
                                         "لا يمكنك إدخال غير الأرقام في خانة العدد",
                                         context);
                                     return 0;
                                   }
                                 });

                                 if (!error) {
                                   detList.forEach((element) {
                                     if (element != detList.first) {
                                       if (element.details_id == null ||
                                           element.details_id < 1)
                                         DataBaseHelper.insertToDataBase(
                                             "details",
                                             DetailsController.toMap(element));
                                       else
                                         DataBaseHelper.update(
                                             "UPDATE details SET title='${element
                                                 .title}',inci_size='${element
                                                 .inci_size}',quantity=${element
                                                 .quantity},notes='${element
                                                 .notes}',model_id=${element
                                                 .model_id}  WHERE details_id=${element
                                                 .details_id}");
                                     }

                                   }
                                   );
                                 }

                                 if (detList.length <= 1)
                                   return 0;
                                     detList = [];
                                     nodata = false;

                                   MyUtilities.alertdialog(
                                       context, "تم الحفظ بنجاح");
                                 }
                               }
                             ),
                         SizedBox(height:10 ,),
                         Text_Style("حفظ", 16,Colors.grey.shade500,"rtl")

                       ],
                     ),
                     Column(
                       // mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           FloatingActionButton(
                               child: Icon(Icons.add,size: 30,color: Colors.white,),
                               heroTag: 'add_details',
                               onPressed:(){
                                 if(type=="allorders")
                                   return;
                                 setState(() {
                                   detList.add(Details("","","",0,this.model_id));
                                 });
                               }),
                           SizedBox(height:10 ,),

                           Text_Style("سطر جديد",16,Colors.grey.shade500,"rtl"),

                         ]

                     ),
                     Column(
                       mainAxisAlignment: MainAxisAlignment.center,

                       children: [
                         IconButton(icon:Icon(Icons.chevron_right_sharp,color:Colors.blue.shade500,size: 30,),
                             onPressed:(){

                               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                                 if(type=="exist")
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







Widget createListRow(List<String> lst,int position)
{

List<Widget>widgetlist=[];

for(int i=0;i<lst.length;i++)
{
  widgetlist.add(add_feild(lst[i],i,position));
  widgetlist.add(SizedBox(width: (1)));
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

                  if(detList[position].details_id!=null)
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

  Widget add_feild(String data,int columnNo,int rowNo) {
   TextEditingController txt=TextEditingController();
    txt.text=data;
    return
      Expanded(
        child: Container(
          width: 100,
          color: rowNo==0?Colors.indigo:Colors.teal.shade400,
          child: TextFormField (

            keyboardType: columnNo==1?TextInputType.number:null,
            onChanged:(text) {

               switch(columnNo)
               {
                 case 0:{detList[rowNo].notes=text;break;}
                 case 1:{
                   detList[rowNo].quantity=int.tryParse(text.trim());
                       break;
                 }
                 case 2:{detList[rowNo].inci_size=text;break;}
                 case 3:{detList[rowNo].title=text;break;}
                 }
               if(_form_key.currentState.validate())
                 return;

          }  ,
            maxLines:2 ,
            cursorColor: Colors.white,
            cursorWidth:6 ,
            cursorHeight:24 ,
            style: TextStyle(
              fontSize: rowNo==0?18:16,color: rowNo==0?Colors.white:Colors.white,fontWeight:rowNo==0?FontWeight.bold:FontWeight.normal   ),
            controller:txt,
            enabled: type=="allorders" || rowNo==0?false:true,
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

  Widget creatlistview() {

    return  ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        itemBuilder:(context,position)
        {
          if(position==0)
            return createListRow(["ملاحظات","العدد","الحجم","الاسم"],position);
         else return Padding(
           padding: const EdgeInsets.only(bottom:6),
           child: createListRow([detList[position].notes,detList[position].quantity.toString(),detList[position].inci_size,detList[position].title],position),
         );
        },itemCount:detList.length,

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

           DataBaseHelper.delete("DELETE FROM details WHERE details_id=${detList[position].details_id}");
           detList.removeAt(position);
         });
       },
    ).show();

  }



}