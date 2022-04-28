import 'package:flutter/material.dart';
import 'package:itajubus/app_adm/veiculos/cadastra_veiculo.dart';
import 'package:itajubus/app_adm/tela_adm.dart';
import 'package:itajubus/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../veiculos/edita_veiculos.dart';

class Veiculos extends StatefulWidget {
  const Veiculos({Key? key}) : super(key: key);

  @override
  State<Veiculos> createState() => _LocaisState();
}

class _LocaisState extends State<Veiculos> {
  final dropVeiculoValue = ValueNotifier('');
  List<dynamic> dropVeiculo = [];
  var id_veiculo;

  Future<void> buscaVeiculo() async {
    var uri = '${url}veiculo.php';
    var response = await http.get(Uri.parse(uri));
    var veiculo = jsonDecode(response.body);

    setState(() {
      dropVeiculo = veiculo;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buscaVeiculo();
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
            title: Text("Veiculos")),
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
                          'assets/images/veiculo.png',
                          width: 200,
                          height: 100,
                        ),
                      ),
                      const Text(
                        "Selecione um veículo para editar suas informações, ou adicione um novo veículo:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      ValueListenableBuilder(
                          valueListenable: dropVeiculoValue,
                          builder: (BuildContext context, String value, _) {
                            return SizedBox(
                              width: 400,
                              child: DropdownButtonFormField(
                                menuMaxHeight: 500,
                                isExpanded: true,
                                icon: const Icon(Icons.account_box),
                                hint: const Text('Editar veículo'),
                                decoration: InputDecoration(
                                    label: const Text('Placa'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6))),
                                value: (value.isEmpty) ? null : value,
                                onChanged: (escolha) {
                                  setState(() {
                                    dropVeiculoValue.value = escolha.toString();
                                    id_veiculo = dropVeiculoValue.value;
                                  });

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // retorna um objeto do tipo Dialog
                                      return AlertDialog(
                                        title: const Text("Confirmar"),
                                        content: const Text("Editar veículo?"),
                                        actions: <Widget>[
                                          // define os botões na base do dialogo
                                          FlatButton(
                                            child: const Text("Ok"),
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditarVeiculos(
                                                              int.parse(
                                                                  id_veiculo))));
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
                                items: dropVeiculo
                                    .map((op) => DropdownMenuItem(
                                          value: op['id'].toString(),
                                          child: Text(op['placa']),
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
                    builder: (context) => const CadastraVeiculo()));
          },
          child: const Icon(Icons.add),
        ));
  }
}
