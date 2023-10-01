

import 'material.dart';

class MaterialController
{

  Material_  material;
  static List<Material_> _material_list=[];

  static List<Material_> get material_list => _material_list;// material list in the depo

  static set material_list(List<Material_> value) {
    _material_list = value;
  }

  static Map<String,dynamic> to_map(Material_ material)
  {
    return{
      'type':material.type,
      'class_type':material.class_type,
      'color':material.color,
      'qnty':material.qnty,
      'notes':material.notes,
      'per_kilo':material.per_kilo
    };
  }

  static List<Material_> to_List(List<Map<String, dynamic>> data)
  {
    List<Material_>lst=[];
    data.forEach((element) {
      lst.add(Material_.fromMap(element));
    });
    return lst;
  }




}