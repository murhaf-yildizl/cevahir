import 'package:cevahir/models/recipt.dart';

class ReciptController
{

 static List<Recipt>recipts=[];

  static Map<String,dynamic> to_map(Recipt recipt)
  {
    return {
      'origin':recipt.origin,
      'date':recipt.date,
      'total':recipt.total
    };


  }

  static List<Recipt> to_list(List<Map<String,dynamic>>map)
  {
    recipts=[];

    map.forEach((element) {
      recipts.add(Recipt.from_map(element));
    });
    return recipts;
  }
}