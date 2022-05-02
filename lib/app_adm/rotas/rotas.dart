import 'package:flutter/material.dart';
import 'package:itajubus/app_adm/rotas/cadastra_rota.dart';
import 'package:itajubus/app_adm/rotas/edita_rotas.dart';
import 'package:itajubus/app_adm/tela_adm.dart';
import 'package:itajubus/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Rotas extends StatefulWidget {
  const Rotas({Key? key}) : super(key: key);

  @override
  State<Rotas> createState() => _RotasState();
}

class _RotasState extends State<Rotas> {
  final dropRotaValue = ValueNotifier('');
  List<dynamic> dropRota = [];
  var id_rota;

  Future<void> buscaRota() async {
    var uri = '${url}trajeto_copia.php';
    var response = await http.get(Uri.parse(uri));
    var rota = jsonDecode(response.body);

    setState(() {
      dropRota = rota;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buscaRota();
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
                        "Selecione um trajeto para ver suas informações, ou adicione um novo trajeto:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      ValueListenableBuilder(
                          valueListenable: dropRotaValue,
                          builder: (BuildContext context, String value, _) {
                            return SizedBox(
                              width: 400,
                              child: DropdownButtonFormField(
                                menuMaxHeight: 500,
                                isExpanded: true,
                                icon: const Icon(Icons.account_box),
                                hint: const Text('Selecione'),
                                decoration: InputDecoration(
                                    label: const Text('Trajetos'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6))),
                                value: (value.isEmpty) ? null : value,
                                onChanged: (escolha) {
                                  setState(() {
                                    dropRotaValue.value = escolha.toString();
                                    id_rota = dropRotaValue.value;
                                  });

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      // retorna um objeto do tipo Dialog
                                      return AlertDialog(
                                        title: const Text("Confirmar"),
                                        content: const Text("Ver rota?"),
                                        actions: <Widget>[
                                          // define os botões na base do dialogo
                                          FlatButton(
                                            child: const Text("Ok"),
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditaRostas(int.parse(
                                                              id_rota))));
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
                                items: dropRota
                                    .map((op) => DropdownMenuItem(
                                          value: op['id'].toString(),
                                          child: Text(op['rota']),
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
                MaterialPageRoute(builder: (context) => CadastraRota()));
          },
          child: const Icon(Icons.add),
        ));
  }
}
