

import 'package:flutter/cupertino.dart';

import '../models/customer.dart';
import '../models/order.dart';
import '../models/order_controller.dart';

class CustomerController{
  static Customer customer;
  static List<Customer> customerlist=[];

  static List<Customer> toCustomerList(List<Map<String,dynamic>>map)
  {
    customerlist=[];
    map.forEach((element) {
      customerlist.add(to_customer(element));
    });

    return customerlist;
  }

  static Customer to_customer(Map<String,dynamic>map)
  {

    return Customer.constructor(map['customer_id'],map['name'],map['phone'],map['address'],map['logo']);
  }

  static Map<String,dynamic> to_map(Customer cust){
    return{


    'name':cust.name,
    'phone':cust.phone,
    'address':cust.address,
    'logo':cust.logo

    };
  }
}