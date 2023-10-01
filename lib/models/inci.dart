

class Inci
{
  String type,notes;
  int qnty;
  double weight;
  int inci_id,material_id,model_id;

  Inci(this.type,this.material_id, this.notes, this.qnty,this.weight,this.model_id);
  Inci.fromMap(Map<String,dynamic>map)
  {
    this.material_id=map['material_id'];
    this.type=map['type'];
    this.qnty=map['qnty'];
    this.weight=map['weight'];
    this.notes=map['notes'];
    this.model_id=map['model_id'];
    this.inci_id=map['inci_id'];
  }
}