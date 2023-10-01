import 'package:flutter/material.dart ';
import 'package:flutter/material.dart';
import 'package:cevahir/widgets/text_style.dart';



class ConnectionTester
{

  static Widget test_connection(AsyncSnapshot snapshot)
  {
    switch(snapshot.connectionState)
    {
      case ConnectionState.waiting: return loading();
      case ConnectionState.active:  return loading();
      case ConnectionState.none:    return none_errore();break;
      case ConnectionState.done:
        if(snapshot.error!=null)
          return errore("Errore while connecting...");
        else if(!snapshot.hasData || snapshot.data.length==0)
              { return noData();}

    }
  }

  static Widget loading() {

    return Container(
                      padding: EdgeInsets.all(10),
                     child:Center(
                          child: CircularProgressIndicator(),
                     )
    );

  }

  static Widget none_errore() {return Container(child:Center(child:Text_Style("خطأ في الاتصال",16,Colors.red,"rtl")));}

  static Widget errore(Object error) {return Container(child:Center(child:Text_Style("حدث خطأ",16,Colors.red,"rtl")));}

  static Widget noData() {return Container(child:Padding(
    padding: const EdgeInsets.only(top:50),
    child: Center(child:Text_Style("لا يوجد بيانات بعد",16,Colors.red,"rtl")),
  ));}
}