import 'dart:convert';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itajubus/app_adm/funcionarios/funcionarios.dart';
import 'package:itajubus/app_adm/locais/locais.dart';
import 'package:itajubus/app_adm/veiculos/veiculos.dart';
import 'package:itajubus/widgets/customFutureBuilder.dart';
import '/../constants.dart';

class EditarVeiculos extends StatefulWidget {
  int id;

  EditarVeiculos(this.id);

  @override
  State<EditarVeiculos> createState() => _EditarLocaisState();
}

class _EditarLocaisState extends State<EditarVeiculos> {
  var _getVeiculo;
  String placa = '';
  String cpf = '';
  String data_nascimento = '';
  String matricula = '';
  String senha_login = '';
  var placa_init;
  var cpf_init;
  var data_nascimento_init;
  var matricula_init;
  var senha_init;
  var resposta_delete;

  Future getVeiculo() async {
    var uri = "${url}veiculo.php?id=${widget.id}";
    var response = await http.get(Uri.parse(uri));
    print(response.body);
    var json = convert.jsonDecode(response.body);
    print(json[0]['placa']);

    setState(() {
      placa_init = json[0]['placa'];
    });

    return json;
  }

  void EditarVeiculos() async {
    var local = {"id": widget.id, "placa": "${placa}"};
    String data = jsonEncode(local);
    print(data);
    var uri = '${url}veiculo.php?id=${widget.id}';
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
          content: Text("Local '${placa_init}' atualizado com sucesso"),
          actions: <Widget>[
            // define os botões na base do dialogo
            FlatButton(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Locais()));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deletaLocal() async {
    var uri = "${url}veiculo.php?id=${widget.id}";
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
                  "Certifique-se de que o veículo não esteja sendo usado para nenhuma rota antes de excluí-lo"),
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
              content: Text("Veículo '${placa_init}' deletado com sucesso!"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Veiculos()));
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
        title: const Text('Editar Veículo'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Excluir!"),
                      content: Text("Excluir veículo '${placa_init}'?"),
                      actions: <Widget>[
                        // define os botões na base do dialogo
                        FlatButton(
                          child: const Text("Sim"),
                          onPressed: () {
                            deletaLocal();
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
        future: _getVeiculo,
        onEmpty: (context) {
          return Center(child: Text('Não há dados disponiveis'));
        },
        onComplete: (context, funcionarios) {
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
                      initialValue: placa_init,
                      onChanged: (text) {
                        setState(() {
                          placa = text;
                        });
                      },
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: 'placa', border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () => {EditarVeiculos()},
                      child: Text('Salvar'),
                    )
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
    _getVeiculo = getVeiculo();
  }
}

/*
  
*/