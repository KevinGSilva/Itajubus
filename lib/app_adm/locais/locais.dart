import 'package:flutter/material.dart';
import 'package:itajubus/app_adm/locais/cadastra_local.dart';
import 'package:itajubus/app_adm/tela_adm.dart';
import 'package:itajubus/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../locais/editar_locais.dart';

class Locais extends StatefulWidget {
  const Locais({Key? key}) : super(key: key);

  @override
  State<Locais> createState() => _LocaisState();
}

class _LocaisState extends State<Locais> {
  final dropLocalValue = ValueNotifier('');
  List<dynamic> dropLocal = [];
  var id_local;

  Future<void> buscaLocal() async {
    var uri = '${url}local.php';
    var response = await http.get(Uri.parse(uri));
    var local = jsonDecode(response.body);

    setState(() {
      dropLocal = local;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buscaLocal();
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
            title: Text("Locais")),
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
                          'assets/images/local_icon.png',
                          width: 200,
                          height: 100,
                        ),
                      ),
                      const Text(
                        "Selecione um local para editar suas informações, ou adicione um novo local:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      ValueListenableBuilder(
                          valueListenable: dropLocalValue,
                          builder: (BuildContext context, String value, _) {
                            return SizedBox(
                              width: 400,
                              child: DropdownButtonFormField(
                                menuMaxHeight: 500,
                                isExpanded: true,
                                icon: const Icon(Icons.account_box),
                                hint: const Text('Editar local'),
                                decoration: InputDecoration(
                                    label: const Text('Nome'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6))),
                                value: (value.isEmpty) ? null : value,
                                onChanged: (escolha) {
                                  setState(() {
                                    dropLocalValue.value = escolha.toString();
                                    id_local = dropLocalValue.value;
                                  });

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // retorna um objeto do tipo Dialog
                                      return AlertDialog(
                                        title: const Text("Confirmar"),
                                        content: const Text("Editar local?"),
                                        actions: <Widget>[
                                          // define os botões na base do dialogo
                                          FlatButton(
                                            child: const Text("Ok"),
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditarLocais(
                                                              int.parse(
                                                                  id_local))));
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
                                items: dropLocal
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
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const CadastraLocal()));
          },
          child: const Icon(Icons.add),
        ));
  }
}
