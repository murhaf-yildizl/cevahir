import 'package:cevahir/models/image.dart';

import '../models/details.dart';

class DetailsController {

  static List<Details>detailsList = [];
  static Details details;


  static List<Details> to_details_list(List<Map<String, dynamic>>map) {
       detailsList=[];
    for (Map det in map)
          detailsList.add(Details.constructor(det['title'],det['inci_size'],det['quantity'],det['notes'],det['model_id'],det['details_id']));


    return detailsList;
  }

static List<Map<String,dynamic>> to_Listmap(List<Details> detlist)
{
  List<Map<String,dynamic>>map=[{}];

   detlist.forEach((det) {
     map.add(toMap(det));
       });
  return map;
}

static Map<String,dynamic> toMap(Details details)
{
  return  {
    'title':details.title,
    'inci_size':details.inci_size,
    'quantity':details.quantity,
    'notes':details.notes,
    'model_id':details.model_id };
}
}

