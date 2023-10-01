import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cevahir/view/text_style.dart';

import 'add_customer.dart';
import 'add_model.dart';

class CreateDrawer extends StatelessWidget
{
  List<String> menu=[];
  List<Object> next_page=[];

  CreateDrawer(this.menu, this.next_page);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(itemBuilder: (context,position){
        return Padding
          (padding:EdgeInsets.only(top: 40,left: 70),

            child:ListTile(

                title: Text_Style(menu[position],20,Colors.teal,"rtl") ,
                trailing: Icon(Icons.chevron_right,color: Colors.grey.shade400,),
                onTap:(){
                  Navigator.pop(context);
                  if(position==6)
                    exit(0);
                 else Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (context){
                    return next_page[position];
                  }));


                }

            )
        );

      },
        itemCount: menu.length,
      ),
    );
  }
}