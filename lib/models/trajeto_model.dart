class Trajeto {
  final String id;
  final String rota;
  final String idLocalidadeInicio;
  final String localInicio;
  final String localInicioLat;
  final String localInicioLong;
  final String idLocalidadeFim;
  final String localFim;
  final String localFimLat;
  final String localFimLong;
  final String idFuncionario;
  final String funcionario;
  final String idVeiculo;
  final String veiculo;
  final String idRastreador;
  final String latitude;
  final String longitude;
  final String horarioPartida;
  final String horarioChegada;

  Trajeto(
      {required this.id,
      required this.rota,
      required this.idLocalidadeInicio,
      required this.localInicio,
      required this.localInicioLat,
      required this.localInicioLong,
      required this.idLocalidadeFim,
      required this.localFim,
      required this.localFimLat,
      required this.localFimLong,
      required this.idFuncionario,
      required this.funcionario,
      required this.idVeiculo,
      required this.veiculo,
      required this.idRastreador,
      required this.latitude,
      required this.longitude,
      required this.horarioPartida,
      required this.horarioChegada});

  static Trajeto fromJson(Map<String, dynamic> json) {
    return Trajeto(
      id: json['id'] ?? 0,
      rota: json['rota'] ?? '',
      idLocalidadeInicio: json['id_localidade_inicio'] ?? 0,
      localInicio: json['local_inicio'] ?? '',
      localInicioLat: json['local_ini_lat'] ?? '',
      localInicioLong: json['local_ini_long'] ?? '',
      idLocalidadeFim: json['id_localidade_fim'] ?? 0,
      localFim: json['local_fim'] ?? '',
      localFimLat: json['local_fim_lat'] ?? '',
      localFimLong: json['local_fim_long'] ?? '',
      idFuncionario: json['id_funcionario'] ?? 0,
      funcionario: json['funcionario'] ?? '',
      idVeiculo: json['id_veiculo'] ?? 0,
      veiculo: json['veiculo'] ?? '',
      idRastreador: json['id_rastreador'] ?? 0,
      latitude: json['latitude'],
      longitude: json['longitude'],
      horarioPartida: json['horario_partida'] ?? '',
      horarioChegada: json['horario_chegada'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rota'] = this.rota;
    data['id_localidade_inicio'] = this.idLocalidadeInicio;
    data['local_inicio'] = this.localInicio;
    data['id_localidade_fim'] = this.idLocalidadeFim;
    data['local_fim'] = this.localFim;
    data['id_funcionario'] = this.idFuncionario;
    data['funcionario'] = this.funcionario;
    data['id_veiculo'] = this.idVeiculo;
    data['veiculo'] = this.veiculo;
    data['id_rastreador'] = this.idRastreador;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['horario_partida'] = this.horarioPartida;
    data['horario_chegada'] = this.horarioChegada;
    return data;
  }
}
