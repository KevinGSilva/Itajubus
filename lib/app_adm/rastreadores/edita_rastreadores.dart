import 'dart:convert';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itajubus/app_adm/funcionarios/funcionarios.dart';
import 'package:itajubus/app_adm/locais/locais.dart';
import 'package:itajubus/app_adm/rastreadores/rastreadores.dart';
import 'package:itajubus/widgets/customFutureBuilder.dart';
import '/../constants.dart';

class EditaRastreador extends StatefulWidget {
  int id;

  EditaRastreador(this.id);

  @override
  State<EditaRastreador> createState() => _EditarLocaisState();
}

class _EditarLocaisState extends State<EditaRastreador> {
  var _getRastreador;
  var observacao_init;
  var observacao;
  var resposta_delete;

  Future getRastreador() async {
    var uri = "${url}rastreador.php?id=${widget.id}";
    var response = await http.get(Uri.parse(uri));
    print(response.body);
    var json = convert.jsonDecode(response.body);
    print(json[0]['observacao']);

    setState(() {
      observacao_init = json[0]['observacao'];
    });

    return json;
  }

  void editaRastreador() async {
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
  }

  Future<void> deletaLocal() async {
    var uri = "${url}rastreador.php?id=${widget.id}";
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
              content: Text("Rastreador deletado com sucesso!"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Rastreadores()));
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
        title: const Text('Editar rastreador'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Excluir!"),
                      content: Text("Excluir rastreador '${observacao}'?"),
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
        future: _getRastreador,
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
                      initialValue: observacao_init,
                      onChanged: (text) {
                        setState(() {
                          observacao = text;
                        });
                      },
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: 'Observaçao',
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () => {editaRastreador()},
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
    _getRastreador = getRastreador();
  }
}

/*
  
*/