import 'package:cevahir/utilities/Utilities.dart';
import 'package:cevahir/view/text_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
   import '../database/database.dart';
import '../models/material.dart';
import 'add_material.dart';
import 'create_drawer.dart';
import 'homePage.dart';

class WarehouseWidget extends StatefulWidget {

  @override
  _WarehouseWidget createState() => _WarehouseWidget();
}

class _WarehouseWidget extends State<WarehouseWidget> {

  List<String> header=["ملاحظات","الكمية","النخـب","اللون","النوع"];
   List<Widget>rows=[];

  List<Widget> _buildCells(List<String> data,bool header) {

    return List.generate(
      5,
          (index) => RotatedBox(
            quarterTurns: -1,
               child: Container(
                 alignment: Alignment.center,
                 width: 120.0,
                 height: 60.0,
                 color: header?Colors.teal:Colors.indigo,
                 margin: EdgeInsets.all(1.0),
                   child:index==3 && !header?getFormat(data[1]):Text(data[5-index-1],style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize:18 ),maxLines: 3,)),
      ),
    );
  }

  Widget buildrow(List<String>data)
  {
    return Column(children:_buildCells(data,false));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CreateDrawer(["الرئيسية","إضافة مواد"],[HomePage(),AddMaterial()]),
        appBar: AppBar(
          toolbarHeight: 100,
          title: Center(child: Text_Style("المستودع",24,Colors.white,null)),
          backgroundColor: Colors.indigo,
        ),
        body:Container(

          margin: EdgeInsets.all(8),
          child: Center(
            child: FutureBuilder(
                       future:DataBaseHelper.import_from_dadabase("SELECT * FROM material") ,
                       builder:(BuildContext context,AsyncSnapshot<List<Map<String,dynamic>>>snapshot)
                       {
                         List<Widget>rows=[];

                         if(snapshot.connectionState==ConnectionState.waiting)
                           return Center(child: CircularProgressIndicator());
                         else if(!snapshot.hasError && snapshot.hasData)
                           if(snapshot.data.length>0)
                           {
                             List<String>list=[];
                             rows=[];

                             snapshot.data.forEach((material) {
                               Material_ mat=Material_.fromMap(material);
                               list.addAll([mat.notes,mat.qnty.toString(),mat.class_type,mat.color,mat.type]);
                                rows.add(buildrow(list));
                                list=[];
                             });
                             return SingleChildScrollView(
                               child: Row(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: <Widget>[

                                   Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children:_buildCells(header,true),
                                   ),
                                   Flexible(
                                     child: SingleChildScrollView(
                                       scrollDirection: Axis.horizontal,
                                       child: Row(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: rows,
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                             );


                           }
                           else if(snapshot.data.isEmpty)
                             return Center(child: Text_Style("لا يوجد مواد بعد", 20, Colors.red,null));

                         return Container();
                       },
                     ),
          ),
        )
    );





  }



  Widget create_text(String txt,Color color,double size) {
    return  Padding(
        padding:EdgeInsets.all(10),
        child:Center(child: Text_Style(txt,size,color,null)));

  }

 Widget getFormat(String data) {

    double num=double.parse(data);
    var formatter=NumberFormat("#,###,###.000");
    String f=formatter.format(num);
   print(f);
    if(f.endsWith("000"))
      f=f.substring(0,f.length-4);

       return Text(num==0?data:f,style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize:18 ),maxLines: 3);

 }
}

