class AdmModel {
  String? id;
  String? nome;
  String? cpf;
  String? cargo;

  AdmModel({this.id, this.nome, this.cpf, this.cargo});

  AdmModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    cpf = json['cpf'];
    cargo = json['cargo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['cpf'] = this.cpf;
    data['cargo'] = this.cargo;
    return data;
  }
}
