import 'package:flutter/material.dart';
import 'package:itajubus/app_motorista/funcionario_login.dart';
import 'package:itajubus/app_motorista/tela_motorista.dart';
import 'package:itajubus/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListTrajetos extends StatefulWidget {
  int id_func;
  ListTrajetos(this.id_func);

  @override
  State<ListTrajetos> createState() => _ListTrajetosState();
}

class _ListTrajetosState extends State<ListTrajetos> {
  final dropListaTrajetoValue = ValueNotifier('');
  List<dynamic> dropListaTrajeto = [];
  late var id_trajeto;

  Future<void> buscaListaTrajeto() async {
    var uri = '${url}trajeto_copia.php?id_funcionario=${widget.id_func}';
    var response = await http.get(Uri.parse(uri));
    var listaTrajeto = jsonDecode(response.body);

    if (listaTrajeto == null || listaTrajeto == '') {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Aviso!"),
              content: Text("Você não está escalado para nenhum trajeto"),
              actions: <Widget>[
                // define os botões na base do dialogo
                FlatButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FuncionarioLogin()));
                  },
                ),
              ],
            );
          });
    }

    setState(() {
      dropListaTrajeto = listaTrajeto;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buscaListaTrajeto();
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
                        builder: (context) => FuncionarioLogin()));
              },
              icon: Icon(Icons.arrow_back)),
          title: Text("Trajetos")),
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
                        'assets/images/trajeto_icon.png',
                        width: 200,
                        height: 100,
                      ),
                    ),
                    const Text(
                      "Selecione qual trajeto irá se iniciar:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    SingleChildScrollView(
                      child: ValueListenableBuilder(
                          valueListenable: dropListaTrajetoValue,
                          builder: (BuildContext context, String value, _) {
                            return SizedBox(
                              width: 400,
                              child: DropdownButtonFormField(
                                menuMaxHeight: 300,
                                isExpanded: true,
                                icon: const Icon(Icons.account_box),
                                hint: const Text('Selecione...'),
                                decoration: InputDecoration(
                                    label: const Text('Trajetos'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6))),
                                value: (value.isEmpty) ? null : value,
                                onChanged: (escolha) {
                                  setState(() {
                                    dropListaTrajetoValue.value =
                                        escolha.toString();
                                    id_trajeto = dropListaTrajetoValue.value;
                                  });

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // retorna um objeto do tipo Dialog
                                      return AlertDialog(
                                        title: const Text("Confirmar"),
                                        content: const Text("Iniciar trajeto?"),
                                        actions: <Widget>[
                                          // define os botões na base do dialogo
                                          FlatButton(
                                            child: const Text("Sim"),
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TelaMotorista(
                                                              int.parse(
                                                                  id_trajeto))));
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
                                items: dropListaTrajeto
                                    .map((op) => DropdownMenuItem(
                                          value: op['id'].toString(),
                                          child: Text(op['rota']),
                                        ))
                                    .toList(),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
