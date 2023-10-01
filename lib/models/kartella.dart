
import 'package:cevahir/models/material.dart';

class Kartella extends Material_ {
  int inci_Qnt,color_Qnt;
  double remained;
  Material_ mat;
  Kartella(this.mat,this.color_Qnt,this.inci_Qnt,this.remained) : super(mat.material_id, mat.type,mat. color, mat.notes, mat.qnty, mat.per_kilo,mat. class_type);

 }