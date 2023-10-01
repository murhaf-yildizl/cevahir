import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cevahir/models/kartella.dart';
import 'package:cevahir/models/material.dart';
import 'package:cevahir/models/order.dart';
import 'package:cevahir/view/all_orders.dart';
import 'package:cevahir/view/createOrder2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cevahir/view/text_style.dart';
 import 'package:intl/intl.dart';

import '../database/database.dart';
import '../utilities/Utilities.dart';
import 'order_controller.dart';

class OrderApplyment extends StatefulWidget {
  Map<String, dynamic> model;
  Order order;
  List<Kartella> detList=[];


  OrderApplyment(this.detList, this.order,this. model);

  @override
  _OrderApplymentState createState() => _OrderApplymentState(model,order,detList);
}

class _OrderApplymentState extends State<OrderApplyment> {
  Map<String, dynamic> model;
  Order order;
  List<Kartella> detList=[];

  _OrderApplymentState(this. model,this.order,this. detList);

  @override
  void initState() {
    // TODO: implement initState


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text_Style("إكمال الطلبية",20,Colors.white,null)),
        toolbarHeight:90 ,
        backgroundColor: Colors.indigo.shade600,

      ) ,
      body:Container(
        padding: EdgeInsets.all(6),
        child: creatlistview(),
      )

    );
  }



  Widget createListRow(List<dynamic> lst,int position)
  {

    List<Widget>widgetlist=[];

    for(int i=0;i<lst.length;i++)
    {
      widgetlist.add(add_feild(lst[i],i,position));
      widgetlist.add(SizedBox(width: (1)));
    }

    return Row(children:widgetlist);

  }

  Widget add_feild(String data,int columnNo,int rowNo) {
    TextEditingController txt=TextEditingController();
    txt.text=data;


    return Expanded(
      child: Container(
        padding:EdgeInsets.all(3),
        width:100,
        color: rowNo==-1?Colors.indigo:Colors.teal.shade400,
        child: TextFormField (
          maxLines:rowNo==-1?1:2 ,
          style: TextStyle(
              fontSize: rowNo==-1?18:16,color:Colors.white,fontWeight:rowNo==-1?FontWeight.bold:FontWeight.normal
          ),
          controller:txt,
          enabled:false,

          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          
        ),
      ),
    );

  }

  Widget  creatlistview(){
    NumberFormat  formatter=NumberFormat("#,###,###.000");
    String f1,f2;

    return SingleChildScrollView(
      child: Column(
          children:[
            createListRow(["المستودع","الكمية","النوع"],-1),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder:(context,position)
              {
               Material_ mat=detList[position];
               double weight=double.parse((detList[position].inci_Qnt*detList[position].color_Qnt/mat.per_kilo).toStringAsFixed(3));
               double sum=getsum(detList[position]);
               double depo=mat.qnty-sum;
               detList[position].remained=depo;

                if(depo<0)
                 depo=0;

                if(depo>=100)
                 f1=formatter.format(depo);
            else f1=depo.toStringAsFixed(3);

                if(weight>=100)
                  f2=formatter.format(weight);
            else  f2=weight.toStringAsFixed(3);

               print("--------- $f2");

               if(f1.endsWith("000"))
                 f1=f1.substring(0,f1.length-4);

               if(f2.endsWith("000"))
                 f2=f2.substring(0,f2.length-4);

              return Padding(
                  padding: const EdgeInsets.only(bottom:3),
                  child: createListRow([f1,f2,"${mat.type} ${mat.color} ${mat.class_type} "],position),
                );
              },itemCount:detList.length,

            ),
            if (detList.isEmpty) Container() else Column(
              children: [
                SizedBox(
                    height: 20
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        width:150 ,
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
                            child:Center(
                              child: Row(
                                 children: [
                                  IconButton(icon:Icon(Icons.save,color: Colors.white)),
                                  Text_Style("حفظ",20,Colors.white,null),

                                ],
                              ),
                            ) ,

                            onPressed:() async {
                               bool enough=true;
                                                          
                                detList.forEach((element) {
                                  if (element.remained<=0)
                                       enough =false;
                                   });
                                
                                  if (!enough)
                                  {
                                    MyUtilities.show_dialog_box(
                                        "الكمية غير كافية!", context);
                                    return 0;
                                  }

                                  if (enough) {
                                    detList.forEach((element) async {
                                     if(element.inci_Qnt>0 && element.color_Qnt>0)
                                      await DataBaseHelper.update("UPDATE material SET qnty=${element.remained}  WHERE material_id=${element.material_id}");

                                  }
                                );

                                    Map<String, dynamic>row = OrderController.to_map(this.order);
                                    await DataBaseHelper.insertToDataBase(
                                        "orders", row).then((value) {
                                      alertdialog(context, "تم الحفظ بنجاح");
                                    }
                                    );
                              }
                            }
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width:150 ,
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
                                Text_Style("رجوع",20,Colors.white,null),
                                IconButton(icon:Icon(Icons.keyboard_arrow_right_rounded,color: Colors.white)),

                              ],
                            ) ,

                            onPressed:() {
                               Navigator.of(context).push(MaterialPageRoute(builder:(context){
                                return CreateOrder2(model,order,detList);
                              }));
                            }
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ]
      ),
    );
  }

  double getsum(Kartella kat)
  {
    double sum=0;

    detList.forEach((element) {
      if(element.material_id==kat.material_id)
        sum+=element.color_Qnt*element.inci_Qnt/element.per_kilo;
    });
    return sum;
  }


alertdialog(BuildContext context,String text)
{
  print(")))))))))))))))))))))))");

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
        child: Text_Style(text,18,Colors.red,null),
      ),
    ) ,
    //desc: 'USER_NOT_FOUND',
    //showCloseIcon: true,
    btnOk:TextButton(child:Text_Style("OK",18,Colors.black,null) ,
      onPressed: (){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context)
        {
          return AllOrders();
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


