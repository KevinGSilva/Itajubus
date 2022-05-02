import 'dart:convert';
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itajubus/app_adm/funcionarios/funcionarios.dart';
import 'package:itajubus/app_adm/locais/locais.dart';
import 'package:itajubus/widgets/customFutureBuilder.dart';
import '/../constants.dart';

class EditarLocais extends StatefulWidget {
  int id;

  EditarLocais(this.id);

  @override
  State<EditarLocais> createState() => _EditarLocaisState();
}

class _EditarLocaisState extends State<EditarLocais> {
  var _getLocal;
  String nome_local = '';
  String cpf = '';
  String data_nascimento = '';
  String matricula = '';
  String senha_login = '';
  var nome_init;
  var cpf_init;
  var data_nascimento_init;
  var matricula_init;
  var senha_init;
  var resposta_delete;

  Future getLocal() async {
    var uri = "${url}local.php?id=${widget.id}";
    var response = await http.get(Uri.parse(uri));
    print(response.body);
    var json = convert.jsonDecode(response.body);
    print(json['nome']);

    setState(() {
      nome_init = json['nome'];
    });

    return json;
  }

  void EditarLocais() async {
    var local = {"id": widget.id, "nome": "${nome_local}"};
    String data = jsonEncode(local);
    print(data);
    var uri = '${url}local.php?id=${widget.id}';
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
          content: Text("Local '${nome_init}' atualizado com sucesso"),
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
    var uri = "${url}local.php?id=${widget.id}";
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
                  "Certifique-se de que o local não esteja sendo usado para nenhuma rota antes de excluí-lo"),
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
              content: Text("Local '${nome_init}' deletado com sucesso!"),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Locais()));
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
                      content: Text("Excluir local '${nome_init}'?"),
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
        future: _getLocal,
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
                      initialValue: nome_init,
                      onChanged: (text) {
                        setState(() {
                          nome_local = text;
                        });
                      },
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          labelText: 'Nome', border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () => {EditarLocais()},
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
    _getLocal = getLocal();
  }
}

/*
  
*/