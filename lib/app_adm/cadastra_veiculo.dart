import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class CadastraVeiculo extends StatefulWidget {
  const CadastraVeiculo({Key? key}) : super(key: key);

  @override
  State<CadastraVeiculo> createState() => _CadastraVeiculoState();
}

class _CadastraVeiculoState extends State<CadastraVeiculo> {
  String placa_veiculo = '';

  void cadastraVeiculo() async {
    var user = {"placa": "${placa_veiculo}"};
    String data = jsonEncode(user);
    var uri = '${url}veiculo.php';
    if (placa_veiculo.length != 7) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // retorna um objeto do tipo Dialog
          return AlertDialog(
            title: const Text("Erro!"),
            content: const Text("Insira uma placa válida!"),
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
            content: const Text("Veículo cadastrado com sucesso"),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Cadastrar veículos'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/veiculo.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      placa_veiculo = text;
                    });
                  },
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                      labelText: 'Placa', border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () => {cadastraVeiculo()},
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
