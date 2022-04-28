import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:itajubus/constants.dart';
import 'package:itajubus/widgets/customFutureBuilder.dart';
import 'package:itajubus/models/locais_model.dart';

class Tela02 extends StatefulWidget {
  var idLocal;

  Tela02(this.idLocal);

  @override
  State<Tela02> createState() => _Tela02State();
}

class _Tela02State extends State<Tela02> {
  late var nomeLocal = '';
  late Future _loadLocal;

  Future<LocaisModel> getLocal() async {
    var response =
        await http.get(Uri.parse("${url}local.php?id=${widget.idLocal}"));
    var resposta = response.body;
    print(resposta);
    LocaisModel data = LocaisModel.fromJson(jsonDecode(resposta));
    setState(() {
      nomeLocal = data.nome;
    });
    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    _loadLocal = getLocal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Passando valores entre telas"),
          centerTitle: true,
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomFutureBuilder(
              future: _loadLocal,
              onEmpty: (context) {
                return Center(
                  child: Text('Usuário não encontrado'),
                );
              },
              onComplete: (context, p) {
                return Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: nomeLocal,
                        decoration: InputDecoration(
                          label: Text("Nome"),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.name,
                      )
                    ],
                  ),
                );
              },
              onError: (context, error) {
                return Center(child: Text(error.toString()));
              },
              onLoading: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            )));
  }
}
