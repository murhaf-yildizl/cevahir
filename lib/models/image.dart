
import 'dart:typed_data';

class ImageDetails
{
  String _title;
  int _image_id,_model_id;
   String _url;

  ImageDetails(this._image_id,this._url, this._title,this._model_id);


  int get model_id => _model_id;
  int get image_id=>_image_id;
  String get title=>_title;
  String get url => _url;


  set url( String value) {
    _url = value;
  }

  set model_id(int value) {
    _model_id = value;
  }



  set title(value) {
    _title = value;
  }

}