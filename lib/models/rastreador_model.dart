class RastreadorModel {
  String? id;
  String? latitude;
  String? longitude;
  String? horarioGps;
  String? observacao;
  String? situacao;

  RastreadorModel(
      {this.id,
      this.latitude,
      this.longitude,
      this.horarioGps,
      this.observacao,
      this.situacao});

  RastreadorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    horarioGps = json['horario_gps'];
    observacao = json['observacao'];
    situacao = json['situacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['horario_gps'] = this.horarioGps;
    data['observacao'] = this.observacao;
    data['situacao'] = this.situacao;
    return data;
  }
}
