import 'package:cevahir/models/customer.dart';
import 'package:cevahir/models/model.dart';

class Order
{
  int order_id,model_id,qnt;
  double total_price;
  String date;

  Order(this.order_id, this.qnt,this.total_price,
      this.model_id,this.date);

  Order.from_map(Map<String,dynamic>map)
  {
    this.order_id=map['order_id'];
    this.qnt=map['qnty'];
    this.total_price=map['total_price'];
    this.model_id=map['model_id'];
   }

 }