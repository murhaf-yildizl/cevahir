 import 'package:flutter/material.dart';

class Text_Style extends StatelessWidget
{

   String txt;
   double size;
   Color color;
   String direction;

  Text_Style(this.txt, this.size, this.color,this.direction);

  @override
 Widget build(BuildContext context)
 {

    return Text(txt,style:TextStyle(fontSize: size,color:color,letterSpacing: 2),maxLines: 10,textDirection:direction=="rtl"?TextDirection.rtl:TextDirection.ltr,);
  }


}