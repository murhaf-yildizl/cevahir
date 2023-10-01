import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cevahir/database/database.dart';
import 'package:cevahir/models/customer.dart';
import 'package:cevahir/controller/customer_controller.dart';
import 'package:cevahir/utilities/Utilities.dart';
import 'package:cevahir/utilities/connection.dart';
import 'package:cevahir/view/add_model.dart';
import 'package:cevahir/view/all_models.dart';
import 'package:cevahir/view/customerInfo.dart';
import 'package:cevahir/view/homePage.dart';
import 'package:cevahir/view/text_style.dart';
import 'package:sqflite/sqflite.dart';
import 'add_customer.dart';
import 'create_drawer.dart';

class AllCustomers extends StatefulWidget {

  @override
  _AllCustomersState createState() => _AllCustomersState();
}

class _AllCustomersState extends State<AllCustomers> {
  Customer selecteduser;
  List<Customer> customerlist = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CreateDrawer(["إضافة زبون","إضافة موديل","صفحة الموديلات","الصفحة الرئيسية"],[AddCustomer(null),AddModel(),AllModels(),HomePage()]),
        appBar:AppBar(
        toolbarHeight:100 ,
        title: Center(child: Text_Style("الزبائن",24,Colors.white,"rtl")),
        backgroundColor:Colors.indigo.withOpacity(0.9),
    ),
    body:  Container(
     padding:EdgeInsets.all(16) ,
    child: SingleChildScrollView(

    physics: ScrollPhysics(),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children:[
     customerlist.isEmpty?FutureBuilder(
    future: DataBaseHelper.import_from_dadabase("SELECT * FROM customers  ORDER BY name"),
    builder:(BuildContext context,AsyncSnapshot <List<Map<String,dynamic>>> snapshot){

    if (snapshot.hasData && snapshot.data.length > 0 &&
    snapshot.error == null)
    {

    customerlist=CustomerController.toCustomerList(snapshot.data);

    return creatlistview();


    }


    return ConnectionTester.test_connection(snapshot);

    }
    ):creatlistview(),
    ]
    ),
    )
    )
    );
  }


  Widget createListRow(int position)
  {
    return Slidable(
          actionPane: SlidableDrawerActionPane(),

          actionExtentRatio: 0.15,

          child:  Padding(
            padding: const EdgeInsets.only(top:18),
            child: InkWell(
              onTap: (){
                Navigator.of(context).pushReplacement( MaterialPageRoute(builder:(context){
                  return CustomerInfo(customerlist[position]);
                }));
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.indigoAccent,radius: 40,
                  child: Text_Style(customerlist[position].name.toString().substring(0,1).toUpperCase(),16,Colors.white,"ltr"),
                  foregroundColor: Colors.white,
                ),
                title: Text_Style(customerlist[position].name.toString().toUpperCase(),18,Colors.black,"ltr"),
               ),
            ),
          ),
        actions: [
          IconSlideAction(
            closeOnTap:true ,
              foregroundColor:Colors.deepPurple ,
              onTap: () {
                    show_dialog_box(context, position);
              },

              icon:Icons.delete,

              caption: 'حذف',

            ),
                 ],
          secondaryActions: [
                IconSlideAction(
                icon: Icons.edit,
                caption: "تعديل",

                color: Colors.grey.shade200,
                foregroundColor: Colors.deepPurple,
                  onTap:(){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context){
                      return AddCustomer(customerlist[position]);
                    }));
                  } ,

              ),
             ],


   );




  }

  Widget creatlistview() {

    return  ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder:(context,position)
      {
        return createListRow(position);





      },itemCount:customerlist.length,

    );
  }

  Widget createDrawer() {
    return Drawer();
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
          child: Text_Style("سوف يتم حذف جميع الموديلات المتعلقة بهذا الزبون",16,Colors.red,"rtl"),
        ),
      ) ,
      //desc: 'USER_NOT_FOUND',
      //showCloseIcon: true,
      btnCancelOnPress: () {},
      btnOkOnPress: ()async {


        try {
          await DataBaseHelper.delete("DELETE FROM customers WHERE customer_id=${customerlist[position].id}");


        }  catch(e){exception=true;print("HHHHHHH");}


       if(exception)
          MyUtilities.show_dialog_box("لايمكن حذف هذا السجل, قد يكون مرتبطاً بسجلات أخرى في قاعدة البيانات!", context);
       else setState(() {
         customerlist.removeAt(position);
       });
        }




    ).show();

  }

}



