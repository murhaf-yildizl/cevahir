
 import 'package:cevahir/controller/customer_controller.dart';
import 'package:cevahir/models/dispose_interface.dart';
import 'package:cevahir/models/image.dart';

import '../controller/image_controller.dart';
import 'customer.dart';
import '../controller/details_controller.dart';
 import 'details.dart';

class Model
{
  int model_id;
  String model_no;
  double price;
  Customer customer;
  String  date;
  List<ImageDetails> _images;
  List<Details>  _details;
  String nomune;

  Model(this.model_id, this.model_no, this.price, this.customer, this.date,
      this._images, this._details,this.nomune);

  Model.constructor(this.model_no,this.price,this.customer,this.date,this.nomune);
  Model.from_map(Map<String,dynamic>map)
{
  this.model_no=map["model_id"];
  this.price=double.parse(map['price']);
  this.customer=CustomerController.to_customer(map["customer"]);
  this.date=map['date'];
  this._images=ImageController.to_image(map['images']);
  this._details=DetailsController.to_details_list(map['details']);
  this.nomune=map['nomune'];
}

  set id(int id) {this.model_id=id;}



  set images(List<ImageDetails> value) {
    _images = value;
  }

  set details(List<Details> value) {
    _details = value;
  }


}