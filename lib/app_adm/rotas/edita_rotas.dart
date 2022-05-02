import 'dart:convert';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itajubus/app_adm/rastreadores/rastreadores.dart';
import 'package:itajubus/app_adm/rotas/rotas.dart';
import 'package:itajubus/widgets/customFutureBuilder.dart';
import '/../constants.dart';

class EditaRostas extends StatefulWidget {
  int id;

  EditaRostas(this.id);

  @override
  State<EditaRostas> createState() => _EditaRostasState();
}

class _EditaRostasState extends State<EditaRostas> {
  var _getRota;
  var localInicio;
  var localFim;
  var funcionario;
  var veiculo;
  var idRastreador;
  var horarioPartida;
  var horarioChegada;
  var resposta_delete;

  Future getRota() async {
    var uri = "${url}trajeto_copia.php?id=${widget.id}";
    var response = await http.get(Uri.parse(uri));
    print(response.body);
    var json = convert.jsonDecode(response.body);
    print(json[0]['local_inicio']);

    setState(() {
      localInicio = json[0]['local_inicio'];
      localFim = json[0]['local_fim'];
      funcionario = json[0]['funcionario'];
      veiculo = json[0]['veiculo'];
      idRastreador = json[0]['id_rastreador'];
      horarioPartida = json[0]['horario_partida'];
      horarioChegada = json[0]['horario_chegada'];
    });

    return json;
  }

  /* void EditaRostas() async {
    var rastreador = {"id": widget.id, "observacao": "${observacao}"};
    String data = jsonEncode(rastreador);
    print(data);
    var uri = '${url}rastreador.php?id=${widget.id}';
    print(uri);
    /*  */
    var response = await http.put(Uri.parse(uri), body: data);
    print(response.body);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: const Text("Sucesso!"),
          content: Text("Local '${observacao}' atualizado com sucesso"),
          actions: <Widget>[
            // define os botões na base do dialogo
            FlatButton(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Rastreadores()));
              },
            ),
          ],
        );
      },
    );
  } */

  Future<void> deletaRota() async {
    var uri = "${url}trajeto_copia.php?id=${widget.id}";
    var response = await http.delete(Uri.parse(uri));
    print(response.body);
    resposta_delete = response.body;
    print(widget.id);

    if (resposta_delete == null || resposta_delete == '') {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("ALERTA!"),
              content: Text(
                  "Certifique-se de que o rastreador não esteja sendo usado para nenhuma rota antes de excluí-lo"),
              actions: [
                FlatButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    child: Text("Ok"))
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext contexte) {
            return AlertDialog(
              title: Text("Deletado!"),
              content: Text("Rota deletada com sucesso!"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Rotas()));
                    },
                    child: Text("ok"))
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Trajeto'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Excluir!"),
                      content: Text("Excluir rota?"),
                      actions: <Widget>[
                        // define os botões na base do dialogo
                        FlatButton(
                          child: const Text("Sim"),
                          onPressed: () {
                            deletaRota();
                            Navigator.of(context).pop();
                          },
                        ),
                        FlatButton(
                          child: const Text("Cancelar"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            },
            icon: Icon(Icons.delete),
            color: Colors.red,
          )
        ],
      ),
      body: CustomFutureBuilder(
        future: _getRota,
        onEmpty: (context) {
          return Center(child: Text('Não há dados disponiveis'));
        },
        onComplete: (context, rotas) {
          return SingleChildScrollView(
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: localInicio,
                      onChanged: (text) {
                        setState(() {});
                      },
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: 'Partida', border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      initialValue: localFim,
                      onChanged: (text) {
                        setState(() {});
                      },
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: 'Destino', border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      initialValue: funcionario,
                      onChanged: (text) {
                        setState(() {});
                      },
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: 'Funcionário',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      initialValue: veiculo,
                      onChanged: (text) {
                        setState(() {});
                      },
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: 'Veículo', border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      initialValue: idRastreador,
                      onChanged: (text) {
                        setState(() {});
                      },
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: 'Rastreador',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      initialValue: horarioPartida,
                      onChanged: (text) {
                        setState(() {});
                      },
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: 'Horário de partida',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      initialValue: horarioChegada,
                      onChanged: (text) {
                        setState(() {});
                      },
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: 'Horario de chegada',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        onError: (context, error) {
          return Center(child: Text((error).toString()));
        },
        onLoading: (context) => Center(child: CircularProgressIndicator()),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getRota = getRota();
  }
}

/*
  
*/