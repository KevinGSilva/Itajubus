import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itajubus/constants.dart';
import 'package:itajubus/models/func_model.dart';

import '../widgets/customFutureBuilder.dart';
import 'Tela02.dart';

class FuncList extends StatefulWidget {
  const FuncList({Key? key}) : super(key: key);

  @override
  State<FuncList> createState() => _FuncListState();
}

class _FuncListState extends State<FuncList> {
  List<dynamic> listFuncionarios = [];
  var _func_model;
  late var id;
  late var nome;
  late var matricula;
  late int tamanho;

  Future getFuncionarios() async {
    var uri = "${url}funcionario.php";
    var response = await http.get(Uri.parse(uri));
    var funcionario = jsonDecode(response.body);

    setState(() {
      listFuncionarios = funcionario;
    });
    print(listFuncionarios);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _func_model = getFuncionarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Funcionarios"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: CustomFutureBuilder(
            future: _func_model,
            onEmpty: (context) {
              return Center(child: Text('Não há dados disponiveis'));
            },
            onComplete: (context, funcionarios) {
              return SafeArea(
                child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) => Card(
                    elevation: 6,
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text((listFuncionarios).toString()),
                      subtitle: Text(matricula),
                      trailing: IconButton(
                          onPressed: () {
                            var id_local = id;
                            print(id_local);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // retorna um objeto do tipo Dialog
                                return AlertDialog(
                                  title: const Text(""),
                                  content: const Text("Editar usuario"),
                                  actions: <Widget>[
                                    // define os botões na base do dialogo
                                    FlatButton(
                                      child: const Text("Ok"),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Tela02(id_local)));
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
                              },
                            );
                          },
                          icon: Icon(Icons.edit)),
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
        ));
  }
}
