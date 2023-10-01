
import 'package:flutter/material.dart';
import 'package:cevahir/models/order.dart';

import 'order_controller.dart';

class Customer{
int _id;
String _name,_phone,_address;
String _logo;
List<Order> _orders;


Customer(this._id, this._name, this._phone, this._address, this._orders,this._logo);

Customer.constructor(this._id,this._name,this._phone,this._address,this._logo);


Customer.from_map(Map<String,dynamic>map)
{
  this._id=map['customer_id'];
  this._name=map['name'];
  this._phone=map['phone'];
  this._address=map['address'];
  this._logo=map['logo'];
  //this._orders=OrderController.to_order(map['orders']);
}


int get id => _id;

set orders(List<Order> value) {
  _orders = value;
}

set address(value) {
  _address = value;
}

set phone(value) {
  _phone = value;
}

set name(String value) {
  _name = value;
}

set id(int value) {
  _id = value;
}

get name => _name;

get phone => _phone;

get address => _address;

List<Order> get orders => _orders;

  get logo => _logo;
}