
import 'package:cevahir/models/recipt_content.dart';

class ReciptContentController{

  static List<ReciptContent> reciptcontent_list=[];

  static Map<String,dynamic> to_map(ReciptContent reciptContent)
  {
    return{
      'recipt_id':reciptContent.recipt_id,
      'material_id':reciptContent.material_id,
      'unit_price':reciptContent.unit_price,
      'content_qnty':reciptContent.content_qnty,
      'content_notes':reciptContent.content_notes

    };
  }

  static List<ReciptContent> to_list(List<Map<String,dynamic>>map)
  {
    reciptcontent_list=[];
    map.forEach((element) {
      reciptcontent_list.add(ReciptContent.from_map(element));
    });

    return reciptcontent_list;
  }
}