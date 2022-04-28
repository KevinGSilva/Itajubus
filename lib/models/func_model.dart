class FuncModel {
  final String id;
  final String nome;
  final String cpf;
  final String data_nascimento;
  final String matricula;
  final String idTipoFuncionario;

  FuncModel(this.id, this.nome, this.cpf, this.data_nascimento, this.matricula,
      this.idTipoFuncionario);
}



/* class Func_model {
  int id;
  String nome;
  String cpf;
  String dataNascimento;
  String matricula;
  String idTipoFuncionario;
  String cargo;

  Func_model(
      {required this.id,
      required this.nome,
      required this.cpf,
      required this.dataNascimento,
      required this.matricula,
      required this.idTipoFuncionario,
      required this.cargo});

  static Func_model fromJson(Map<dynamic, dynamic> json) {
    return Func_model(
        id: json['id'],
        nome: json['nome'] ?? '',
        cpf: json['cpf'] ?? '',
        dataNascimento: json['data_nascimento'] ?? '',
        matricula: json['matricula'] ?? '',
        idTipoFuncionario: json['id_tipo_funcionario'] ?? '',
        cargo: json['cargo'] ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['id'] = id as String;
    data['nome'] = this.nome;
    data['cpf'] = this.cpf;
    data['data_nascimento'] = this.dataNascimento;
    data['matricula'] = this.matricula;
    data['id_tipo_funcionario'] = this.idTipoFuncionario;
    data['cargo'] = this.cargo;
    return data;
  }
} */