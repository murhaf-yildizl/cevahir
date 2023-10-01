

import 'customer.dart';
import '../controller/customer_controller.dart';
import 'model.dart';
import 'order.dart';

class OrderController{

  static Order order;
  static List<Order>orderList=[];

  static Map<String,dynamic> to_map(Order order)
  {
    return{
      'qnty':order.qnt,
      'total_price':order.total_price,
      'model_id':order.model_id,
      'date':order.date

    };
  }

  static  List<Order> to_list( List<Map<String,dynamic>> map)
  {
    orderList=[];
    map.forEach((element) {
       orderList.add(Order.from_map(element));
    });
     return orderList;
  }
}