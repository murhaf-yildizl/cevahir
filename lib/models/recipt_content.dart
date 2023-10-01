import 'package:cevahir/models/recipt.dart';
import 'material.dart';

class ReciptContent
{
  int content_id,recipt_id,material_id;
  double unit_price,content_qnty;
  String content_notes;



  ReciptContent(this.content_id, this.recipt_id, this.unit_price,this.material_id,this.content_notes,this.content_qnty);

  ReciptContent.from_map(Map<String,dynamic>map)
  {
    this.content_id=map['content_id'];
    this.recipt_id=map['recipt_id'];
    this.material_id=map['material_id'];
    this.unit_price=map['unit_price'];
    this.content_qnty=map['content_qnty'];
    this.content_notes=map['content_notes'];
    
  }

}