import 'package:flutter/material.dart';
import 'package:itajubus/app_adm/rastreadores/cadastra_rastreador.dart';
import 'package:itajubus/app_adm/rastreadores/edita_rastreadores.dart';
import 'package:itajubus/app_adm/tela_adm.dart';
import 'package:itajubus/constants.dart';
import 'package:http/http.dart' as http;
import 'package:itajubus/views/my_home_page.dart';
import 'dart:convert';

class Rastreadores extends StatefulWidget {
  const Rastreadores({Key? key}) : super(key: key);

  @override
  State<Rastreadores> createState() => _LocaisState();
}

class _LocaisState extends State<Rastreadores> {
  final dropRastreadorValue = ValueNotifier('');
  List<dynamic> dropRastreador = [];
  var id_rastreador;

  Future<void> buscaRastreador() async {
    var uri = '${url}rastreador.php';
    var response = await http.get(Uri.parse(uri));
    var rastreador = jsonDecode(response.body);

    setState(() {
      dropRastreador = rastreador;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buscaRastreador();
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
            title: Text("Rastreadores")),
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
                          'assets/images/rastreador.png',
                          width: 200,
                          height: 100,
                        ),
                      ),
                      const Text(
                        "Selecione um rastreador para editar suas informações, ou adicione um novo rastreador:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      ValueListenableBuilder(
                          valueListenable: dropRastreadorValue,
                          builder: (BuildContext context, String value, _) {
                            return SizedBox(
                              width: 400,
                              child: DropdownButtonFormField(
                                menuMaxHeight: 500,
                                isExpanded: true,
                                icon: const Icon(Icons.account_box),
                                hint: const Text('Editar rastreador'),
                                decoration: InputDecoration(
                                    label: const Text('Observação'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6))),
                                value: (value.isEmpty) ? null : value,
                                onChanged: (escolha) {
                                  setState(() {
                                    dropRastreadorValue.value =
                                        escolha.toString();
                                    id_rastreador = dropRastreadorValue.value;
                                  });

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // retorna um objeto do tipo Dialog
                                      return AlertDialog(
                                        title: const Text("Confirmar"),
                                        content:
                                            const Text("Editar rastreador?"),
                                        actions: <Widget>[
                                          // define os botões na base do dialogo
                                          FlatButton(
                                            child: const Text("Ok"),
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditaRastreador(int.parse(
                                                              id_rastreador))));
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
                                items: dropRastreador
                                    .map((op) => DropdownMenuItem(
                                          value: op['id'].toString(),
                                          child: Text(op['observacao']),
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
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => CadastraRastreador()));
          },
          child: const Icon(Icons.add),
        ));
  }
}
