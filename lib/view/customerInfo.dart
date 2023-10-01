
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cevahir/models/customer.dart';
import 'package:cevahir/view/all_customers.dart';
import 'package:cevahir/view/text_style.dart';

class CustomerInfo extends StatefulWidget {
  Customer customer;
  CustomerInfo(this.customer);


  @override
  _CustomerInfoState createState() => _CustomerInfoState(customer);
}

class _CustomerInfoState extends State<CustomerInfo> {
  Customer customer;
  _CustomerInfoState(this.customer);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
          automaticallyImplyLeading:false ,
        toolbarHeight:100 ,
        title: Center(child: Text_Style("معلومات الزبون",24,Colors.white,"rtl")),
          backgroundColor:Colors.indigo.withOpacity(0.9),
        ),
      body: Container(

        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
             children: [
            createRow(customer.name,"الاسم"),
            createRow(customer.phone, "الهاتف"),
            createRow(customer.address, "العنوان"),
            SizedBox(height: 100),
            IconButton(icon:(Icon(Icons.replay,size: 40,)) ,onPressed:(){
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                  return AllCustomers();
                }));
              })
            ],
          ),
        )
      )
    );
  }

 Widget createRow(String data,String title) {
    return Padding(
      padding: const EdgeInsets.only(top:30,right:50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text_Style(data, 18, Colors.teal,"rtl"),
          SizedBox(width:100),
          Text_Style(title, 20, Colors.indigo,"rtl"),

        ],
      ),
    );
 }
}
