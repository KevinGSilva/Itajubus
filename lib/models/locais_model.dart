import 'dart:ffi';

class LocaisModel {
  final String id;
  final String nome;

  LocaisModel({required this.id, required this.nome});

  static LocaisModel fromJson(Map<String, dynamic> json) {
    return LocaisModel(id: json['id'] ?? 0, nome: json['nome'] ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    return data;
  }
}
