import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:itajubus/app_adm/cadastra_funcionario.dart';
import 'package:itajubus/views/Tela02.dart';
import 'package:http/http.dart' as http;
import 'package:itajubus/constants.dart';

class TesteLista extends StatelessWidget {
  late var id;
  late var nome;
  late var matricula;

  Future getFuncionarios() async {
    var uri = "${url}funcionario.php";
    var response = await http.get(Uri.parse(uri));
    var json = jsonEncode(response.body);
  }

  // Generate some dummy data
  final List dummyList = List.generate(15, (index) {
    return {
      "id": index,
      "title": "This is the title $index",
      "subtitle": "This is the subtitle $index"
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Usuarios')),
      body: SafeArea(
        child: ListView.builder(
          itemCount: dummyList.length,
          itemBuilder: (context, index) => Card(
            elevation: 6,
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(dummyList[index]["title"]),
              subtitle: Text(dummyList[index]["subtitle"]),
              trailing: IconButton(
                  onPressed: () {
                    var id_local = dummyList[index]["id"];
                    var nome = dummyList[index]["title"];
                    print(id_local);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // retorna um objeto do tipo Dialog
                        return AlertDialog(
                          title: const Text(""),
                          content: const Text("Editar usuario"),
                          actions: <Widget>[
                            // define os botões na base do dialogo
                            FlatButton(
                              child: const Text("Ok"),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Tela02(id_local)));
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
                  icon: Icon(Icons.edit)),
            ),
          ),
        ),
      ),
    );
  }
}
