import '../controller/details_controller.dart';
import 'image_controller.dart';
import 'model.dart';

class ModelController{

  static Model model;
  static List<Model>model_list=[];

 static  List<Model> to_model(List<Map<String,dynamic>>map)
  {
    model_list=[];
    for(Map mod in map ) {

      //model.images= ImageController.to_image(mod['images']);
      //model.details = DetailsController.to_details_list(mod['details']);

      model_list.add(Model(mod['model_id'],mod['nomune'],mod["model_no"],mod["price"],mod['date'],null,null,null));
    }
    return model_list;
  }

  static Map<String,dynamic> to_map(Model mod) {
     return {
      "nomune":mod.nomune,
      "model_no":mod.model_no,
      "price":mod.price,
      "customer_id":mod.customer.id,
      "date":mod.date
    };
  }
}