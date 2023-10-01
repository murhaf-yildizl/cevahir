

class Setting
{
  int id;
  String company_name,password,logo;

  Setting(this.id, this.company_name, this.password, this.logo);
  Setting.constructor(this.company_name, this.password, this.logo);
  Setting.fromMap(Map<String,dynamic>map)
  {
    this.id=map['id'];
    this.password=map['password'];
    this.company_name=map['company_name'];
    this.logo=map['logo'];
  }
}