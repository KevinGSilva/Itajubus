import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:itajubus/app_adm/rotas/rotas.dart';
import '../../constants.dart';

import 'package:flutter/material.dart';

class CadastraRota extends StatefulWidget {
  const CadastraRota({Key? key}) : super(key: key);

  @override
  State<CadastraRota> createState() => _CadastraRotaState();
}

class _CadastraRotaState extends State<CadastraRota> {
  final dropValuePartida = ValueNotifier('');
  final dropValueDestino = ValueNotifier('');
  final dropValueFuncionario = ValueNotifier('');
  final dropValueVeiculo = ValueNotifier('');
  final dropValueRastreador = ValueNotifier('');
  List<dynamic> dropLocalPartida = [];
  List<dynamic> dropLocalDestino = [];
  List<dynamic> dropFuncionario = [];
  List<dynamic> dropVeiculo = [];
  List<dynamic> dropRastreador = [];
  String local_destino = '';
  String local_partida = '';
  String funcionario = '';
  String veiculo = '';
  String rastreador = '';
  String horario_partida = '';
  String horario_chegada = '';

  Future<void> buscaDestino() async {
    var uri = '${url}local.php';
    var response = await http.get(Uri.parse(uri));
    var json = convert.jsonDecode(response.body);

    setState(() {
      dropLocalPartida = json;
      dropLocalDestino = json;
    });
  }

  Future<void> buscaFuncionario() async {
    var uri = '${url}funcionario.php';
    var response = await http.get(Uri.parse(uri));
    var funcionario = convert.jsonDecode(response.body);

    setState(() {
      dropFuncionario = funcionario;
    });
  }

  Future<void> buscaVeiculo() async {
    var uri = '${url}veiculo.php';
    var response = await http.get(Uri.parse(uri));
    var veiculo = convert.jsonDecode(response.body);

    setState(() {
      dropVeiculo = veiculo;
    });
  }

  Future<void> buscaRastreador() async {
    var uri = '${url}rastreador.php';
    var response = await http.get(Uri.parse(uri));
    var rastreador = convert.jsonDecode(response.body);

    setState(() {
      dropRastreador = rastreador;
    });
  }

  Future<void> cadastraRota() async {
    var trajeto = {
      "id_local_inicio": local_partida,
      "id_local_fim": local_destino,
      "id_funcionario": funcionario,
      "id_veiculo": veiculo,
      "id_rastreador": rastreador,
      "horario_partida": "$horario_partida",
      "horario_chegada": "$horario_chegada"
    };
    String data = convert.jsonEncode(trajeto);
    var uri = '${url}trajeto.php';
    if (local_partida == '' ||
        local_destino == '' ||
        funcionario == '' ||
        veiculo == '' ||
        rastreador == '' ||
        horario_partida == '' ||
        horario_chegada == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: const Text("Erro!"),
            content: const Text("Todos os campos devem ser preenchidos!"),
            actions: <Widget>[
              // define os botões na base do dialogo
              FlatButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      var response = await http.post(Uri.parse(uri), body: data);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: const Text("Sucesso!"),
            content: const Text("Trajeto salvo com sucesso!"),
            actions: <Widget>[
              // define os botões na base do dialogo
              FlatButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Rotas()));
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de trajetos'),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Rotas()));
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Image.asset(
                'assets/images/trajeto_icon.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: ValueListenableBuilder(
                    valueListenable: dropValuePartida,
                    builder: (BuildContext context, String value, _) {
                      return SizedBox(
                        width: 300,
                        child: DropdownButtonFormField(
                          menuMaxHeight: 300,
                          isExpanded: true,
                          icon: const Icon(Icons.add_location_alt),
                          hint: const Text('Selecione o local'),
                          decoration: InputDecoration(
                              label: const Text('Partida'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6))),
                          value: (value.isEmpty) ? null : value,
                          onChanged: (escolha) {
                            setState(() {
                              dropValuePartida.value = escolha.toString();
                              local_partida = dropValuePartida.value;
                            });
                          },
                          items: dropLocalPartida
                              .map((op) => DropdownMenuItem(
                                    value: op['id'].toString(),
                                    child: Text(op['nome']),
                                  ))
                              .toList(),
                        ),
                      );
                    }),
              ),
              const SizedBox(height: 15),
              Center(
                child: ValueListenableBuilder(
                    valueListenable: dropValueDestino,
                    builder: (BuildContext context, String value, _) {
                      return SizedBox(
                        width: 300,
                        child: DropdownButtonFormField(
                          menuMaxHeight: 300,
                          isExpanded: true,
                          icon: const Icon(Icons.add_location_alt),
                          hint: const Text('Selecione o local'),
                          decoration: InputDecoration(
                              label: const Text('Destino'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6))),
                          value: (value.isEmpty) ? null : value,
                          onChanged: (escolha) {
                            setState(() {
                              dropValueDestino.value = escolha.toString();
                              local_destino = dropValueDestino.value;
                            });
                          },
                          items: dropLocalDestino
                              .map((op) => DropdownMenuItem(
                                    value: op['id'].toString(),
                                    child: Text(op['nome']),
                                  ))
                              .toList(),
                        ),
                      );
                    }),
              ),
              const SizedBox(height: 15),
              Center(
                child: ValueListenableBuilder(
                    valueListenable: dropValueFuncionario,
                    builder: (BuildContext context, String value, _) {
                      return SizedBox(
                        width: 300,
                        child: DropdownButtonFormField(
                          menuMaxHeight: 300,
                          isExpanded: true,
                          icon: const Icon(Icons.account_box),
                          hint: const Text('Selecione o funcionário'),
                          decoration: InputDecoration(
                              label: const Text('Funcionário'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6))),
                          value: (value.isEmpty) ? null : value,
                          onChanged: (escolha) {
                            setState(() {
                              dropValueFuncionario.value = escolha.toString();
                              funcionario = dropValueFuncionario.value;
                            });
                          },
                          items: dropFuncionario
                              .map((op) => DropdownMenuItem(
                                    value: op['id'].toString(),
                                    child: Text(op['nome']),
                                  ))
                              .toList(),
                        ),
                      );
                    }),
              ),
              const SizedBox(height: 15),
              Center(
                child: ValueListenableBuilder(
                    valueListenable: dropValueVeiculo,
                    builder: (BuildContext context, String value, _) {
                      return SizedBox(
                        width: 300,
                        child: DropdownButtonFormField(
                          menuMaxHeight: 300,
                          isExpanded: true,
                          icon: const Icon(Icons.airport_shuttle),
                          hint: const Text('Selecione o veiculo pela placa'),
                          decoration: InputDecoration(
                              label: const Text('Veiculo'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6))),
                          value: (value.isEmpty) ? null : value,
                          onChanged: (escolha) {
                            setState(() {
                              dropValueVeiculo.value = escolha.toString();
                              veiculo = dropValueVeiculo.value;
                            });
                          },
                          items: dropVeiculo
                              .map((op) => DropdownMenuItem(
                                    value: op['id'].toString(),
                                    child: Text(op['placa']),
                                  ))
                              .toList(),
                        ),
                      );
                    }),
              ),
              const SizedBox(height: 15),
              Center(
                child: ValueListenableBuilder(
                    valueListenable: dropValueRastreador,
                    builder: (BuildContext context, String value, _) {
                      return SizedBox(
                        width: 300,
                        child: DropdownButtonFormField(
                          menuMaxHeight: 300,
                          isExpanded: true,
                          icon: const Icon(Icons.gps_fixed),
                          hint: const Text('Selecione o rastreador'),
                          decoration: InputDecoration(
                              label: const Text('Rastreador'),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6))),
                          value: (value.isEmpty) ? null : value,
                          onChanged: (escolha) {
                            setState(() {
                              dropValueRastreador.value = escolha.toString();
                              rastreador = dropValueRastreador.value;
                            });
                          },
                          items: dropRastreador
                              .map((op) => DropdownMenuItem(
                                    value: op['id'].toString(),
                                    child: Text(op['observacao']),
                                  ))
                              .toList(),
                        ),
                      );
                    }),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 300,
                child: Column(
                  children: [
                    TextField(
                      onChanged: (text) {
                        setState(() {
                          horario_partida = text;
                        });
                      },
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                          labelText: 'Horario de partida (hh : mm)',
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.query_builder)),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      onChanged: (text) {
                        setState(() {
                          horario_chegada = text;
                        });
                      },
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                          labelText: 'Horario de chegada (hh : mm)',
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.query_builder)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        cadastraRota();
                      },
                      child: const Text('SALVAR')),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //buscaPartida();
    buscaDestino();
    buscaFuncionario();
    buscaVeiculo();
    buscaRastreador();
  }
}
