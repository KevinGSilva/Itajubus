import 'package:flutter/material.dart';
import 'package:itajubus/app_adm/funcionarios/cadastra_funcionario.dart';
import 'package:itajubus/app_adm/tela_adm.dart';
import 'package:itajubus/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'editar_funcionario.dart';

class Funcionarios extends StatefulWidget {
  const Funcionarios({Key? key}) : super(key: key);

  @override
  State<Funcionarios> createState() => _FuncionariosState();
}

class _FuncionariosState extends State<Funcionarios> {
  final dropFuncionarioValue = ValueNotifier('');
  List<dynamic> dropFuncionario = [];
  var id_func;

  Future<void> buscaFuncionario() async {
    var uri = '${url}funcionario.php';
    var response = await http.get(Uri.parse(uri));
    var funcionario = jsonDecode(response.body);

    setState(() {
      dropFuncionario = funcionario;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buscaFuncionario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TelaAdm(
                                title: '',
                              )));
                },
                icon: Icon(Icons.arrow_back)),
            title: Text("Funcionários")),
        body: Column(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/funcionarios.png',
                          width: 200,
                          height: 100,
                        ),
                      ),
                      const Text(
                        "Selecione um funcionário para editar suas informações, ou adicione um novo funcionário:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      ValueListenableBuilder(
                          valueListenable: dropFuncionarioValue,
                          builder: (BuildContext context, String value, _) {
                            return SizedBox(
                              width: 400,
                              child: DropdownButtonFormField(
                                menuMaxHeight: 500,
                                isExpanded: true,
                                icon: const Icon(Icons.account_box),
                                hint: const Text('Editar Funcionario'),
                                decoration: InputDecoration(
                                    label: const Text('Nome'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6))),
                                value: (value.isEmpty) ? null : value,
                                onChanged: (escolha) {
                                  setState(() {
                                    dropFuncionarioValue.value =
                                        escolha.toString();
                                    id_func = dropFuncionarioValue.value;
                                  });

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // retorna um objeto do tipo Dialog
                                      return AlertDialog(
                                        title: const Text("Confirmar"),
                                        content:
                                            const Text("Editar Funcionario?"),
                                        actions: <Widget>[
                                          // define os botões na base do dialogo
                                          FlatButton(
                                            child: const Text("Ok"),
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditarFuncionario(
                                                              int.parse(
                                                                  id_func))));
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
                                items: dropFuncionario
                                    .map((op) => DropdownMenuItem(
                                          value: op['id'].toString(),
                                          child: Text(op['nome']),
                                        ))
                                    .toList(),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const CadastraFuncionario()));
          },
          child: const Icon(Icons.add),
        ));
  }
}
