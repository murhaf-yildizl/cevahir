
import 'package:flutter/cupertino.dart';

import 'image.dart';

class ImageController{

  static List<ImageDetails>image_list;
  static ImageDetails image;

  static List<Map<String,dynamic>> tomap(List<ImageDetails>images)
  {
    List<Map<String,dynamic>> map=[{}];

    images.forEach((img) {

      if(img.image_id==0)
       map.add(to_map(img))   ;

    });

    return map;

  }
  static Map<String,dynamic> to_map(ImageDetails img)
  {
    return {
    'url':img.url,
    'title':img.title,
    'model_id':img.model_id
    };
  }
  static List<ImageDetails> to_image(List<Map<String,dynamic>>map)
  {
    image_list=[];
   for(Map img in map )
     {

      image_list.add(ImageDetails(img['image_id'],img['url'], img['title'], img['model_id']));

     }
   return image_list;

  }
}