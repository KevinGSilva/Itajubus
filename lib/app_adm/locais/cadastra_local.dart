import 'dart:convert';
import 'package:itajubus/app_adm/locais/locais.dart';

import '../../constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CadastraLocal extends StatefulWidget {
  const CadastraLocal({Key? key}) : super(key: key);

  @override
  State<CadastraLocal> createState() => _CadastraLocalState();
}

class _CadastraLocalState extends State<CadastraLocal> {
  String nome_local = '';

  void cadastraLocal() async {
    var user = {"nome": "${nome_local}"};
    String data = jsonEncode(user);
    var uri = '${url}local.php';
    var response = await http.post(Uri.parse(uri), body: data);
    if (nome_local == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: const Text("Erro!"),
            content: const Text("Insira um local!"),
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: const Text("Sucesso!"),
            content: Text("${nome_local} cadastrado com sucesso"),
            actions: <Widget>[
              // define os botões na base do dialogo
              FlatButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Locais()));
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
        title: const Text('Cadastrar locais'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/local_icon.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
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
                  onPressed: () => {cadastraLocal()},
                  child: Text('Cadastrar'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
