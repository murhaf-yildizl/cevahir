
import 'package:flutter/material.dart';
import 'package:cevahir/models/inci.dart';

class Material_{
  int material_id;

  String type,class_type,color,notes;
  double qnty,per_kilo;
  bool enough;


  Material_(this.material_id, this.type, this.color, this.notes, this.qnty,this.per_kilo,this.class_type);

  Material_.fromMap(Map<String,dynamic>map)
  {
    this.type=map['type'];
    this.notes=map['notes'];
    this.qnty=double.tryParse(map['qnty'].toString());
    this.color=map['color'];
    this.material_id=map['material_id'];
    this.per_kilo=map['per_kilo'];
    this.class_type=map['class_type'];
   }

    Material_.constructor();
}