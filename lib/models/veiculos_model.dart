class VeiculosModel {
  String? id;
  String? placa;

  VeiculosModel({this.id, this.placa});

  VeiculosModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    placa = json['placa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['placa'] = this.placa;
    return data;
  }
}
