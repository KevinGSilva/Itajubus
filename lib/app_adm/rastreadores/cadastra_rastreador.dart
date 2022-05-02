import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itajubus/app_adm/funcionarios/funcionarios.dart';
import 'package:itajubus/app_adm/rastreadores/rastreadores.dart';
import '../../constants.dart';

class CadastraRastreador extends StatefulWidget {
  const CadastraRastreador({Key? key}) : super(key: key);

  @override
  State<CadastraRastreador> createState() => _CadastraRastreadorState();
}

class _CadastraRastreadorState extends State<CadastraRastreador> {
  String observacao = '';

  void cadastraRastreador() async {
    var user = {"observacao": "${observacao}", "situacao": 0};
    String data = jsonEncode(user);
    var uri = '${url}rastreador.php';
    if (observacao == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: const Text("Erro!"),
            content: const Text("Insira uma observação!"),
            actions: <Widget>[
              // define os botões na base do dialogo
              FlatButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      var response = await http.post(Uri.parse(uri), body: data);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: const Text("Sucesso!"),
            content: const Text("Rastreador cadastrado com sucesso"),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Cadastrar rastreadores'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/rastreador.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      observacao = text;
                    });
                  },
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                      labelText: 'Observação', border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () => {cadastraRastreador()},
                  child: const Text('Cadastrar'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
