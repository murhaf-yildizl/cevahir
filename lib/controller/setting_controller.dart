

import 'package:cevahir/models/setting.dart';

class SettingController
{


  static Map<String,dynamic>to_map(Setting  setting)
  {
    return {
      'company_name':setting.company_name,
      'password':setting.password,
      'logo':setting.logo
    };
  }

}