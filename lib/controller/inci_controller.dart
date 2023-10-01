import 'inci.dart';

class InciController{

 static List<Inci> _lst=[];

  static Map<String,dynamic>to_map(Inci inci)
  {
     return {
      'type':inci.type,
      'qnty':inci.qnty,
      'weight':inci.weight,
      'notes':inci.notes,
      'material_id':inci.material_id,
      'model_id':inci.model_id
    };
  }

  static List<Inci>to_list(List<Map<String,dynamic>>map)
  {
    _lst=[];
    map.forEach((element) {
      _lst.add(Inci.fromMap(element));
    });
    return _lst;
  }

 static Future<List<Inci>> get getlst  async { //inci list in one model
   return _lst;
 }

 static set lst(List<Inci> value) {
    _lst = value;
  }
}