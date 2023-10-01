import 'package:cevahir/models/material.dart';

class Recipt
{
  String origin,date;
  double total;
  int recipt_id;

  Recipt(this.origin, this.date, this.total);

  Recipt.from_map(Map<String,dynamic>map)
  {
    this.date=map['date'];
    this.origin=map['origin'];
    this.total=map['total'];
    this.recipt_id=map['recipt_id'];
   }
}